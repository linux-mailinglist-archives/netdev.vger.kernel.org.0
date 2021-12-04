Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F244686BD
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385276AbhLDRtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:49:19 -0500
Received: from mail-eopbgr60110.outbound.protection.outlook.com ([40.107.6.110]:53571
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbhLDRtS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 12:49:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPEYx3odqi9DZBp4ozpP1L5w9rk/wzh/l/TgybYZhjIXoOxuhVCX783pBK6fKSfRwjVEc86b8W6PfFOnXDfUD10q2xYsbK2pRn+8MgS27Kwy+msGVlpZttO9hbn/4I+UV1aSvpZQ/XivkQSo86SnuHo3odDG7JqE6omNtuYcv0boRuJfRrFOGpsRva+vVNUgqHJDF6YptkbLJxqk7TXb/4cUMtmEPb3fVMtqDGMIi+B74DYsIvy21oTBIs0HjaBg+JHGomifJyVtf/CFIf7swN5TtUR0MAes5tXNKur02WQdb2Zfru1CRHGtaY+c8KpGIK6pB+QwJ1yBD3T5/WgD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7q2i0PvnwQPRyhnSjMhpEa227V5URbIB4yNYAwNfylQ=;
 b=GTg0i9PhDOvNifySMcFOZCHuWbnKwYDTBWJNrDfR/P7K5d121sffmPeqgrTZ/yZ/pIYpQxuGTU4ddNjHd8mOAcIsi6ZSne8QQ/p8dOXPq8KVVRHvCe5EEfVtT573Or+dysAp+ezHxvbsXUjKDU5CjQmf8GKeA6j/MWHi1g8yiwkrcFfeM2T+SV/pgLFVB8x4mq65RUAwECLsdrtNNvWQ6Kt7o6WyDfU5c2Xd53S1eZrfVrg/Yk9ORsf/NSfxexOf9yNHM9AYEXaskY1SREdD89bm47Xf8hurs9s44Ay43glxb2plXjXrV+90LUxQSLL6vBDB8UB4yAN7ue7XuC2DwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q2i0PvnwQPRyhnSjMhpEa227V5URbIB4yNYAwNfylQ=;
 b=s8iVI4jleVizyD5XV3MXjEqMQ1fltiiXIdtHJoggcfhkOLVWlahsXh/Lr1UHYdxi99/FxxnS3AtmLvZXE1tdDnt+rOfEUHg+6jt17x4Ev/tzu0m4aLKi+BQzXwmyOpeEWF1DTr8jxG0eg+f7+lzgSUGa3uQnZeoWcyh+qHVHBB8=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0573.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 17:45:48 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 17:45:48 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Julia Lawall <julia.lawall@inria.fr>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Serhiy Boiko <serhiy.boiko@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: prestera: fix flexible_array.cocci warnings
Thread-Topic: [PATCH] net: prestera: fix flexible_array.cocci warnings
Thread-Index: AQHX6CprF+EcSGauEkCSv2NoEin9gqwim9iC
Date:   Sat, 4 Dec 2021 17:45:48 +0000
Message-ID: <VI1P190MB07349BB76E8DE98B61D63A7B8F6B9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <alpine.DEB.2.22.394.2112031043180.5247@hadrien>
In-Reply-To: <alpine.DEB.2.22.394.2112031043180.5247@hadrien>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 1092310c-89e4-5e2e-71d1-c863b279d95b
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fa28406-1fd3-4c20-2933-08d9b74de850
x-ms-traffictypediagnostic: VI1P190MB0573:
x-microsoft-antispam-prvs: <VI1P190MB05736F73AFE5CD2620F06C958F6B9@VI1P190MB0573.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:269;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83VOsAPwsVdHDyhEQ9xbBf/Q0tHmHLxPSSwuDZmtp0k7e997reP9raCx1XwXrX8+4vx3TbyFwX+Ub5fYoTiyfbsyOjNAV2Jpd+vL9evamVic5TDBML+/ylqYi9ghDCDn8WY6pJsHQ6Slj4EzycUiVYbwRRalMqDQpuevaetPeBp+roZlvd2kka1HP180kfbyTDgr9tBpPHb+OxusQ0njKuJmymwSZfrL52zRHxQGfYwKkRc9aPFaeTkfvpQ2tgrL0gK53NKIRoZ21Xs8+8v3nuXbEj3gSaRucUU6TUw3aW7XV5dYjsJc0Lq98kmcHcU52j/8wMdq793Bcj36PtPR1OQnR+uk1aXmDzlEmdDLhP5mK2Vb3yoXWW2G7s6EAfWYx8OGu4Igij79OhunvIs4Y5N3gcsE0UTmcW7FXJ4iD74jHFrpDQ/sU5yWkZveZoKaDsmXXhWBjjKRjDoPOgFd8kGxyMrOXSzHdmZpYdHLWPyWB/EX4i4phsiHK5gUZhdPA1qCUQd1uLinQt77M8HdK3T0wR/Dj/QaPwQZb9eV3TYF78VIdg+eBnq7ixMwleZvEB2vc014JPfkBcEToWwJyvmqz9jvuDvE4eDo+yVNJD6rKFt5BzlydNHqy1nSFndYf+8BdwhnpiXqJoii1WbyzuwBNWHBABBnhMIrJeJJ2Uq9dZYjWBaJSZ/u2uoWCLiCuUeYx+Ckimp8I7lhc09dTglpA2hr0P+1Z2SK7kpZWPvirUB/TrweSfEOzrqf76IYB0gvFNzkqplUn03E2OljbhT7sagRi+tFdbVTn79xqWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(396003)(366004)(376002)(136003)(8936002)(186003)(110136005)(9686003)(6506007)(52536014)(316002)(26005)(38100700002)(86362001)(7416002)(83380400001)(7696005)(54906003)(55016003)(966005)(64756008)(66556008)(91956017)(2906002)(44832011)(66446008)(76116006)(66476007)(5660300002)(4326008)(66946007)(38070700005)(8676002)(508600001)(122000001)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?adiE8SDARHR3d1iRtMNJCKPDv9pSyNmR+goT2uTRtIYUz9S7Nm7fVTCiDq?=
 =?iso-8859-1?Q?TkbkiwBSKSPuVn2kjViE0EDLPYlhNitmhzAV0fbO1kDUylXfzKaCkSneJU?=
 =?iso-8859-1?Q?SEaGe4YxYbXviQUxfywYvm/60tg3B7gLECwgiNCuY4IURtUTRAEF/BHjYZ?=
 =?iso-8859-1?Q?SluBs53u7Fdq2EaTkBoSTjK4r9FJaTX1F7pAi12mnFase4cY1rLhrMCmTx?=
 =?iso-8859-1?Q?KvJTZFLb9XswifeZ9dEX0KYWVFwe8fnojW++5spiOceuIkXGW3H+LcfnOh?=
 =?iso-8859-1?Q?c09vnmujMb+BwUbc8ZwkkHiM2eLOXKTnrONNiU/Pj14mrGqA8n4YJUlfzR?=
 =?iso-8859-1?Q?f943KCvDTUVh3Io7lA6SlzeUNrhCBI9RXyL8KLTzHUyRQ5Uub838pNT5Fc?=
 =?iso-8859-1?Q?XxtPTCf3YW4yi7/u+5+kmRvBMh3CCvU2Hi9HnP12/u/gpUJyWZgWeA4FeV?=
 =?iso-8859-1?Q?Ozb0MIZE2z4/4fau+N7ee080Z8W2K6Xbq+CE8CylXph66PrX6YrOsENcyy?=
 =?iso-8859-1?Q?stMmN7R1ZHKbK+JhntHreELFVp2lrTYi9ge7NTVqhr9AxBeXpr8IZU1RAc?=
 =?iso-8859-1?Q?dSxISuQAx5B4wruviYUdDBki2rHOK/Ng2POHaph2EWNU16lN6MQ8WfVl99?=
 =?iso-8859-1?Q?ySNGBYAtU/OSAoo1vbV4RUBCHfo5QEnfuJv8Z0d28rzDVwDpaa3vb/hY1m?=
 =?iso-8859-1?Q?bxqzu7YlSJ71JKZzsUqY5EEejONWjWfT5ttftaqBEixYKv1NIAz2l4VfXu?=
 =?iso-8859-1?Q?u/Iblm5iN9Ih1DRh43AOSi9hYcAdGW1airCb3g+WAV9SCRptT02QNzBVQJ?=
 =?iso-8859-1?Q?nittWzXXecMAgpB3CZmT4M+GMFQfZMZtfNdrVWTuX/FT07UN/k1stJVeb8?=
 =?iso-8859-1?Q?HKUpNXjUtrk8y5r6DQ/PfqCPvtYuJgpQddBnrPNbOwjhfLqO2QTvtTu+BW?=
 =?iso-8859-1?Q?+13OdYEq80XPzSV6HXYiVTXBBn7IRqTToFBFL8v0kaSB7nUHTwiS/ikYv7?=
 =?iso-8859-1?Q?sZo3AkZep8+WgfYIL3tMZWN+6D31rFcLRNrW8zSUt9fbbCD9kkgpGKujY2?=
 =?iso-8859-1?Q?ltzWk8Znrm0f7eMVvGbjbfrXOCl/sllfXmcUv/YWdb02gGrYwQWsckBrPc?=
 =?iso-8859-1?Q?1IyYPEsOre2YPbIY+KZsMcDbJdPUynADFhYs2p/KNzUHHIH0w+HQyxNCUJ?=
 =?iso-8859-1?Q?EctZINHyEq5XDPJQ2caPAvxX3ct7T7v/i80VEwbKSoCmPcJG9kFaC+ocHj?=
 =?iso-8859-1?Q?kAwSavopilaFHJCBsrN4Vw1xcJSlTwVJ8gW+4LCmkxNbmH8CZprNuGl6Vt?=
 =?iso-8859-1?Q?bclLbRc699rEvb3kokZOybEpsWJCvXct+IEe54wwnUZSevNT0qmbUhunO3?=
 =?iso-8859-1?Q?x81TBAynJ2otzuDzLsCMdp+TdewBwijqMRKXmGgCZpeuy6SwKHwH89fdud?=
 =?iso-8859-1?Q?SesGaVHL6qYs89Z9CDdnTXXUk0T4BNTFHfI1W7gW0PyuIeiggxG6GxYVVf?=
 =?iso-8859-1?Q?G4picQtY/zVRX7mZwICFjhO7wvEIF+ZsNmz7v2TPPnJyIPNSCQcM2k7de1?=
 =?iso-8859-1?Q?Iu++vI1JNQwnzHSmLpZbymE3Y/qFBnkbib1Pc8UQQTnWXUs9E+3DrmId0a?=
 =?iso-8859-1?Q?6OIDte08JWJFPeogp3ko+r/h22IYklkdzT1va5m/chdI0Abx8rNYYnz0vy?=
 =?iso-8859-1?Q?SlAd0x9PvpsAClPz+dasQp0xSVHQHvFz7DR0WTjaP+7EpSiYo5INsrcXaU?=
 =?iso-8859-1?Q?zpnA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa28406-1fd3-4c20-2933-08d9b74de850
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 17:45:48.5935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kskZLp3ZYon94JTR+sbSv0igMkh38N53zaEaeXHunITux+RLkE8PCLiNCN2QEWzLPhj/wix8m3Qdl90COoHS+/M+sIQVRhQllN87Y3SSYeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0573
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] net: prestera: fix flexible_array.cocci warnings =0A=
>  =0A=
> From: kernel test robot <lkp@intel.com>=0A=
> =0A=
> Zero-length and one-element arrays are deprecated, see=0A=
> Documentation/process/deprecated.rst=0A=
> Flexible-array members should be used instead.=0A=
> =0A=
> Generated by: scripts/coccinelle/misc/flexible_array.cocci=0A=
> =0A=
> Fixes: 6e36c7bcb461 ("net: prestera: add counter HW API")=0A=
> CC: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> Reported-by: kernel test robot <lkp@intel.com>=0A=
> Signed-off-by: kernel test robot <lkp@intel.com>=0A=
> Signed-off-by: Julia Lawall <julia.lawall@inria.fr>=0A=
> ---=0A=
> =0A=
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master=0A=
> head:   9606f9efb1cec7f8f5912326f182fbfbcad34382=0A=
> commit: 6e36c7bcb4611414b339173cdc33fdcb55c08f9e [4129/4921] net: prester=
a: add counter HW API=0A=
> :::::: branch date: 19 hours ago=0A=
> :::::: commit date: 3 days ago=0A=
> =0A=
> Please take the patch only if it's a positive warning. Thanks!=0A=
> =0A=
>  prestera_hw.c |    2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> @@ -443,7 +443,7 @@ struct prestera_msg_counter_resp {=0A=
>          __le32 offset;=0A=
>          __le32 num_counters;=0A=
>          __le32 done;=0A=
> -       struct prestera_msg_counter_stats stats[0];=0A=
> +       struct prestera_msg_counter_stats stats[];=0A=
>  };=0A=
> =0A=
>  struct prestera_msg_span_req {=0A=
=0A=
Hi Julia,=0A=
=0A=
Fixed in https://www.spinics.net/lists/kernel/msg4167402.html=0A=
=0A=
Thanks and Regards,=0A=
Volodymyr=
