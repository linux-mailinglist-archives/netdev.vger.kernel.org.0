Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D770F312254
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 08:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBGH6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 02:58:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5004 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229445AbhBGH5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 02:57:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1177fXcb010267;
        Sat, 6 Feb 2021 23:57:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=2tUELGNYxXgU+dG4Kh7vBPl5i+lP7xZC0Aeq+nbccfs=;
 b=CqO9fIXtug3JTJ0lxcgoBK3gk6MiaGiGV63Buv9YlNFw8ug+KcTlKf8EPlslDlXGnG6U
 v0bvO4MWAilXdfzwcTQxkzsC20NunWqWcEV1gHFhf5QImrDEviai/j3QTKqno8Qjsqf/
 8a6Ikrr5BD8uQmY6jPkQKdPw939SxgwSQ0JiRubdMqeTHo5xCK4V9zzIMXzY5lFgqR9F
 LOZfjbkGXiA/EDk2voX/a8C5kLApR/O6MQoO+C1TugSnfMd2Dg4L9eMUcBA3qBlYTHq5
 z6j2LSov/7GbEWbV37izv57ExqIaCJJY8y+NVtTOE9ciopwlg0JAGBQhSMBOkirPUAL/ SA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbr9sh3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 23:57:00 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 23:56:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 23:56:57 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 6 Feb 2021 23:56:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Agj+oJqWORDZg0fl0M8YzL7ISUneNJiDFnX6s0A4cXPo5Jsb4q+navyq1UOPYAPzlydhKgrvv7tjkFzfUlVzzUBA6gghhhgiDip7THVPkFkFVzGIsczQf5t3zu03obud9Pzf4jKj8GPH2ysdo7BRMBYQED6wDb/H32QUMPyRCFWs9YPi/cdTNTVQGOJQQ/2zcQwOj0V8EHivFfMVoIlMHy1LwLTmvfGl3KSvOpgrzfLLG6Q++adryW0LQf1XL7+18CH9VUMQN0fn0cPkpsxY/m+L+pDn+jXcbdmaqxXWZOQvKirV/QW5X8mX9FCP3tWLIWI5KBAMWY6vugjht6ZTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tUELGNYxXgU+dG4Kh7vBPl5i+lP7xZC0Aeq+nbccfs=;
 b=XfKGnh5A+mPINNbZVvk4PbmJ4vPlncECrXhVMl8JniMYATOmqY9bmwGIIdyucEiIiVDKnx6dcgfeK7r90I/oDdEYqF7WZD5fKjq9ktWHC/ZdF6EwYyP8+/c1ZkZokiGXGBLXY5W70S+FbQYlmADuWSpyDhEoqXoCXBwKTwpr1MmFpWAe2q1uiiRqCNDjrZe2DENCxqI1x6yE/kdchPG4dr/kAXkg1/0bF1k4zxd+KYScOv0Z2cVCWOjxAHBokA6KhSSCmVPDOG7bQlOldXLYWOjviJXrvloZOp5MFxev+OkoLk3W8vlwa54o3Jb+1O6xTrrDa/p1PAUn2p82ZxWunA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tUELGNYxXgU+dG4Kh7vBPl5i+lP7xZC0Aeq+nbccfs=;
 b=kparYgK6ZLmDuG1M5hkGfQM1ULKJF2lIKEKiluNj5m37sGmr+KcvpWN3eYMPs3njybwenvvAs52rinMBTnaFxjhnwz4ENL731MDe5piHSG9tI57npmbw5ZdrUiTDZrPTuvTxC3DXjG/bT50mlejl5EsF04Mjx2C5I81Juh2AAHk=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Sun, 7 Feb
 2021 07:56:54 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 07:56:54 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        Kostya Porotchkin <kostap@marvell.com>
Subject: RE: [EXT] Re: [PATCH v8 net-next 02/15] dts: marvell: add CM3 SRAM
 memory to cp11x ethernet device tree
Thread-Topic: [EXT] Re: [PATCH v8 net-next 02/15] dts: marvell: add CM3 SRAM
 memory to cp11x ethernet device tree
Thread-Index: AQHW/KeirqrBUxHL2EKPzuMxVvFK7apLyXkAgACKMeA=
Date:   Sun, 7 Feb 2021 07:56:53 +0000
Message-ID: <CO6PR18MB3873467A6C0BE7EE06D89AF9B0B09@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
        <1612629961-11583-3-git-send-email-stefanc@marvell.com>
 <20210206154004.4aaa32ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206154004.4aaa32ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f7190fb-ddae-4598-e5f7-08d8cb3def44
x-ms-traffictypediagnostic: CO6PR18MB3873:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3873162D541B0EF46AF606A3B0B09@CO6PR18MB3873.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z4I08YFez47//QQUJnel09lhT3b6KvZ1i6PwRYkjmwuSW3dfpaQIs40oSTIERjyLBdeR2ur0UHBk/zbtntdm4hTsZTHoVOnd7LNLDvoi0F4NgQq+g1N7UFgMcTFk4iEq8Oo2hvFU8w0bdw104rhLupPsYxRrcDtsRDwonzoQdrG9aQkueLARIaRcfJycpBXt4Z7cMujLkNidFZS6zyBaDhf75j+YHYVAZZK7uRFH27cLwCzUUNSEG9FxKfE07DWZB19/LQPKl488fOdA8b2UDE/SFGZ7uLQIMJD1iOh82T24IXcxXe6JbJwWRz3Ns/OaOO18oQx9JDho43+J4mSmRX9Ko//i15kag29goTvjg3M4XCK7Rcx0dGrAXBZB4S+QKr0ZLLTwwuwKBR7xyY8qQ0QarGI07SgjfMEblJz6w7fC8m/5ghEiqUfq+Fn5Znow+DAgYKmI7Rvvh4drToSB0BmfMsbsyXTcUwfOpn4SEASPDpZx3dfrMTOWZsl/aTtRVtvxaDRBRIjY/C5aqsoAGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39850400004)(376002)(136003)(346002)(4326008)(8936002)(7696005)(6916009)(6506007)(5660300002)(71200400001)(52536014)(8676002)(186003)(76116006)(4744005)(33656002)(66476007)(66556008)(64756008)(9686003)(66446008)(316002)(2906002)(26005)(55016002)(107886003)(478600001)(86362001)(7416002)(66946007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hzUGmrYKjPeliCiH6opKfb7oJ8oLlgzeHTxS1M5B3+66piDO7t1f7CrZBrS6?=
 =?us-ascii?Q?i+HAqQV5pw+4TsviaTakw3LUqIJ1zzEBeRuZDfYC+BMvzvNGM4kOTQxlaPUA?=
 =?us-ascii?Q?8z/fsxeziENUhYaW9o0fdJ3terATWOhPYVHLuoSI5bxm1ziS01WZ+ZemYN95?=
 =?us-ascii?Q?SHYFHTvHumSBPKVGfIS22R8VcEDq/CEdywZF1jidhpbWE8jVWgyCTgQfYW7F?=
 =?us-ascii?Q?R00eisFxFI94j4UrxVWiyp1zTqggLYcfyVU5CX4aIz2IpZ+an7NqKc7M5Agl?=
 =?us-ascii?Q?JP+aTwaYOGo1FP440nZ/SN2vvH1YY8bMr/h1MmZJcZJ/OtTkq93T0D/dz0Xg?=
 =?us-ascii?Q?gv2eDI6LL9F/R0a2ngTfhn8BSUC7mtKptGfjCD0TvPAb+Ut1OnVZHCVOwdj5?=
 =?us-ascii?Q?p+Rv0et1m8hjXxmKqYNTZTnsPOZ6RKTxla9p2mycTFSgj3KbsF9W1hYKDFW3?=
 =?us-ascii?Q?eBzMVQ0FnqerF2lNCudJqZ58h13r9oV7p4Q8leblETUjkbITTZ/1MKffBwj7?=
 =?us-ascii?Q?YTFTg2wsHe1CiOdmT4TvwHnMZjDwnl+rKvLH2VnqetrHZAIG1NxYZW3XFyKY?=
 =?us-ascii?Q?uyaNffBCfLbGtAScC5OOtt9ahO5ETshAPEQnOWkCugESkyM/fN8VXayyzlz0?=
 =?us-ascii?Q?nNboBGIYunD4qkyvEBO/6ziJnTTbw4qIbc9TWA2lt8Op5DnYoz0GqHyB34a2?=
 =?us-ascii?Q?rvd1xh7RrNDO2fMVjNb81Xx45oevCcH+GUCjOQGp2IIp5pyHMkGfzePPc2b3?=
 =?us-ascii?Q?HzhG7TQ1M2Vxff/yLfsQnoQQjCZNDUmq7o7kA2jHUfZrmbCoisuccEmlZuIO?=
 =?us-ascii?Q?URlPoxQKTWltKyFXURCZOROx8bkT+0eyixM/9Imq9IPuNER7ncFvsDOb8Bu+?=
 =?us-ascii?Q?j2kK1xMANxIE2cCSV/+HlWxHhbzRNXwGgGkwy4t2ny7t1JgkNpA4FTX39RoQ?=
 =?us-ascii?Q?/LtymV7/9fvd7i7Le0/xOo9PZPAI2GeYkE45WiGvJRGkGarD0yieG+rOOD5R?=
 =?us-ascii?Q?B7NHnjIzRxsANiOlnDunlhCtWXmr6FLKt/bdLnJfH3ZSMYlvEx8WomBPPS36?=
 =?us-ascii?Q?k/DmX6qBTMo+GNWqGoHKkoBxDV+lR4ltHR0QN9SGw+lwoDoIrOhtZ4Wu/PTC?=
 =?us-ascii?Q?1jti4NJ+W/SE9BxSrsXtaWwCB/D9TUKyPgvMpRVb8jX0C6O/eJ+w3CghDa4G?=
 =?us-ascii?Q?vG9zL0DqMLBtLgMCGJFEVnwJ0LgLdGIutMiLjIscfNCTsTLOserVJS2vZg8V?=
 =?us-ascii?Q?GLj7EeMhOR6NDAyPgwe/Agf+DIw6gbsLsOnAdCcN9txgM+5vVEdFf9oWTj+M?=
 =?us-ascii?Q?dSk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7190fb-ddae-4598-e5f7-08d8cb3def44
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 07:56:53.7860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aCiFgE1fdI+bxZajg826ARTUrGwuZfbXtHSV64urFBn7LyCNsmnFhnbowmYw5yKYI2m0ghcmOZ2e6st61hXjkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3873
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_03:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ----------------------------------------------------------------------
> On Sat, 6 Feb 2021 18:45:48 +0200 stefanc@marvell.com wrote:
> > From: Konstantin Porotchkin <kostap@marvell.com>
> >
> > CM3 SRAM address space would be used for Flow Control configuration.
> >
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>
>=20
> Isn't there are requirement to CC the DT mailing list and Rob on all devi=
ce
> tree patches?  Maybe someone can clarify I know it's required when adding
> bindings..

I would repost with robh+dt@kernel.org, gregory.clement@bootlin.com and dev=
icetree@vger.kernel.org in CC

Thanks,
Stefan.
