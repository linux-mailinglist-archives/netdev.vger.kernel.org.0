Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE22F446712
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhKEQgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:36:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2462 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230369AbhKEQgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:36:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A5B27gL015567;
        Fri, 5 Nov 2021 09:33:23 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3c4t2fun43-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 09:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlvohL03cnGyYekGy84hRVjjutviNrgFxj2riV1CWYQnYxJtY+HTHwwqutDj0G9L+gGfhQPsb6igPBtZGE6nTMAmUSEp24rnSHmNqixYFfFiOUg2YV8gP7DP+PeUgFFUFYtqaj/5o+LRpu6ay5KdqSeTxCeFNSaBfg++pi8HZhSuBVUQMVeOTl8uCaFpRgdmpJuxBY+XDAj/HWK7uqaaJvCHixOwfHBefm212Qxzgo7V/OR2cpjzBhUQKTJjKw8ElMEgHCzsfLiK6d+Lh/RtVEFBc/lQZFoeVWxE7M0NgybdnnDykGpnaN0MA9hANeTeFE5NZgL2wPtNafAPlW83Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEFBVkrDzN55h8NImz9dXXpX83KCzW7wbvhXfLLpGwk=;
 b=GC9HG9cN2JpNm392ygk2DY7OzIraLw3XmFu2jlELzdrQNAMBI5ucHvn8tA3fgT9Rgt8J9p8CJRtoUIRcTwO56aJzwjYNE4MF+MDVbNfaOedsrUbUCOD0UFRysKJQMpB9GN+IP6eaAkvu3bfNoU+n5Ke4k2ZSYee1SrqD7EgFd8gPtFKemzaCicNlDtPE8ihrneUTEzSan3lSiZ1RBYP9g50JmZl+ONYtjkH36GkBvvuFa7ZrYusIWKDlEaTutuxaSbPZzns5x+9+kg8a9+m2naLSXPIp8ECxZaienhj3A1JU16UR9rBHP+MP/zbdH/0WD//fQYBcrGcjws4VIL3ZYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEFBVkrDzN55h8NImz9dXXpX83KCzW7wbvhXfLLpGwk=;
 b=N+Zi5ciIOqsRl7mXXekV64k3LrOdXgWKt0TV7rgFDAYmNYFZxtau8RLw3l5Ml95qcvw5tMZmbaVPy7HYY3fWQLgE5AqBH+QY4PCPQE8xcu1A+01xwG0NvmmMYVs9NChghOZkwqR8ynCSd83DNTlNKySgDV4xvBuqaIbKzcO6N2Q=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2550.namprd18.prod.outlook.com (2603:10b6:a03:138::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 16:33:20 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4649.022; Fri, 5 Nov 2021
 16:33:20 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Networking <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
Thread-Topic: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
Thread-Index: AQHX0mLXF6japSIPFUqp5Xvf8t6pvg==
Date:   Fri, 5 Nov 2021 16:33:19 +0000
Message-ID: <SJ0PR18MB400959CE08EC6BFB397CAAB3B28D9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1636031398-19867-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <CAK8P3a2nbEFGPRWKwjLYOz3wROLOk1SN-6Wd7-sNkaEuuid==w@mail.gmail.com>
In-Reply-To: <CAK8P3a2nbEFGPRWKwjLYOz3wROLOk1SN-6Wd7-sNkaEuuid==w@mail.gmail.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 2f56df9b-0b72-f087-8c67-90ed04a28acc
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 790eeec0-084f-4bf5-48ae-08d9a079fa60
x-ms-traffictypediagnostic: BYAPR18MB2550:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB2550E7D3B1D7456E2E492779B28E9@BYAPR18MB2550.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 77+Vfvc0J6fj5Y/Kj43LjjoWKBfmw3G1n7HZ6c4u0vatroIC3o7F4oASb9GhkKxYF83tOXGD8QGe2AKpE7BmwnfoAjRNpOuAJCszK0ofCCevi1YYgdS98qgxl8t9wWLaRedd61Jb1WNltbnebCdeK78fW9snZ6jTuRI1epufPiTSYg3JeGGeXD1aYDbqtvPGlBGunQzgEFiarCb8TdKH4vYKRSmx4cZo5Zp6pZWbAgCvq96rnZTGyhpkKsX2svmxu208yJJX0w27wH8Jw8hSRb878u7WYcZCD3Xi0b62jQ/avO4k1hIQpqoQorMI7L0Uk8yfibNnqfTTOhMMVcI4Z2A8dR2Jk+/fXEypFb2r9fJWHxTXwdWg8cT9zQalM4+1ObSNiH7Kw86uYxbTkSbEZskCc0YeRbmW2O2WjiENltgYMWjSTBMdcLtz0O/Y46fmfu+oVmfm96EuKDV8LkH4doL9Ir5FtAy/BOq7lKTC6sQJmbTuvcFFjE39bLaMAUKwFpiVQMTnCzYTDTJPFs3btnFB9zKLK14xw1exZZRJlMaUbH/c2YyCGlO5kLnm267BsEQQfEvQ/y6NlXFoj9KJoa7wnhyX7b6y2dfT06ovBHDLPPSUpz/xN5aoikCxMIRtdN42h5ZKf95+eifqIxJvFviG7hEzURpjM8LBa65j177E1yyhSuRapLnIG0bqkOvypKMC+We8oYY6JwPiu2MmvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(76116006)(8936002)(38100700002)(9686003)(122000001)(316002)(55016002)(71200400001)(54906003)(33656002)(7696005)(7416002)(5660300002)(52536014)(53546011)(38070700005)(8676002)(186003)(2906002)(508600001)(6506007)(6916009)(66476007)(86362001)(66446008)(83380400001)(66556008)(64756008)(4326008)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4l5BjSFho88XES1qVT9YJ0nYpmwXWbQUC2dqNjAXAHnHd+ygAwZwzbtbxY?=
 =?iso-8859-1?Q?GltdqLE4HIeIMvNgI+7Dq8mF4oMG4i0exqBsR0ZRe2Hc2fmkvKfnuXWxRN?=
 =?iso-8859-1?Q?IwUaNn1te467dC2UFOXAWDGaVarsietjFxzu/DELk+usOr96F/KY4mW7Sc?=
 =?iso-8859-1?Q?4uqZtkvXMrze+YI9p7Gi052e+fzFRZ8Hptjgqytop773xuAIYqB9bGzYgo?=
 =?iso-8859-1?Q?PHrcB6PyhWpkUdjZentkSMZYzW/fybqvJDH3gVban53E1OpLlSBhca9YyF?=
 =?iso-8859-1?Q?L8BQdt9gLZxIUkM3RqOkXNRIv9MXtg0drtpRclBmOJkfAd4RSYoQw58cVI?=
 =?iso-8859-1?Q?bMLi+KhTFkPuR447xjgYGEpau9YGY/WoNTI2DGO6ti2P+sNTN8jGVC9/pG?=
 =?iso-8859-1?Q?kROJ15EIhOZJbU2HXNIGBVGykaH9HO9ZH5GrwwZzF9ZhaoLe+NSsaaQdEe?=
 =?iso-8859-1?Q?iG7WtWcCSKVxSmhVLOUhzztSeeXdeJLyf7lWHVWWJwpVHbRkwP8z+QsP/F?=
 =?iso-8859-1?Q?1EdmY3HOJVLdnAjYwh24rSmlfoshOPUKDh23pxon44xN9IJ+H3KjnOCCk0?=
 =?iso-8859-1?Q?Tl07Qo+Bn7Z6OJ7ypK7rZ/7fe8PeZXu8pLMoZPZmhSHjvBQsYI+ydW1JEU?=
 =?iso-8859-1?Q?skGl/+a3fBikTPbE8X6NhMfpyTJi+fvLphBex5b4wJ73TiTk+6G56CjWSU?=
 =?iso-8859-1?Q?7Hjl5DNirEbSAeCVIO89izfp38bIHVBSvqoOFVIDHnQ9ni9/+B1MH/GW4l?=
 =?iso-8859-1?Q?cWOKem5pO/uUXdyLHk/sbiq3ON7N9FzW4AzufIbm/KXAFGsm1hM6kfzpcw?=
 =?iso-8859-1?Q?qxlq4fona/628jJdEVyvFEc9pcDL98zbEwUQj9QHlpNEGWoyTRQQbM4E+4?=
 =?iso-8859-1?Q?PHnh5Rem3gmunEg+7ug6ScdtL5vRBBSfEEU2G9/xV0aKP3x3ZGFyJaUstV?=
 =?iso-8859-1?Q?GTt6dEUjjBKkpAXHMfCCeehSQefjv1lH8AFGPHK03ntF05KoHaAHLQDbNc?=
 =?iso-8859-1?Q?TjMSkwGJjwVvJlDmlbYp9FfDyxITjZPo2hR1wFpiFOz89J7cRwax670mK3?=
 =?iso-8859-1?Q?7XDPRzRHHRhSixo8v4miMFjeDyJda2TV7+h24MJE3APenqjyruKP7wsii/?=
 =?iso-8859-1?Q?gsKxgafW4fWStGZ0eGTauVyM6Gzgwmy64ncq/73Yd7biEo4ZcDNZF5nWBH?=
 =?iso-8859-1?Q?MOjyDCJItBjYMtgqxHUY1cNSXmYYLCHLMI0lIJ3lLZkk1ApX5CQt0p8AQH?=
 =?iso-8859-1?Q?xqGaKIffx5MAbY4fDvsur+/1CeKD/EAJ1t8vAhoQi8ihAFHB76awW3yh5O?=
 =?iso-8859-1?Q?Aa4KNyd43PrFjo120WeanEqmzsUVXWVvUVFmOHOS3DCAG9vz2uF/+cG9vi?=
 =?iso-8859-1?Q?ovRujerL7S9TI2WIwu7sbE+7fk+DOlqNgLQ5VwSeUq2AlMFydEdh7a2oVD?=
 =?iso-8859-1?Q?ZE7tXYncW5Z067DnFFu7r36MU/9sYCa6oBj2cBvikiPpTk45m8c3jtnllp?=
 =?iso-8859-1?Q?qlObR9ZWppaHX9zAnHW1ajQ8wXL4QsK4/dXQYtjnacOkC3MgbBJlsCg1V5?=
 =?iso-8859-1?Q?pp/a2YoS6fKPZEpiglLVzHgXIuo8n7huvvhMIFbFT5GLWWejQJWFp2y7BD?=
 =?iso-8859-1?Q?3cFL4sB3vCaMZdL3+dhWSPwaYHDbIYTyIQHoP8wSMG9MAsoR0NAaqzNw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790eeec0-084f-4bf5-48ae-08d9a079fa60
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 16:33:19.9835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m0a+f1I8312sXi5oSJjT5t64Di+WPcVvc+apWREleT4V4gIAdYFsNScFTVEdf9x8ENXRzigPQBh3rPNbzOqICQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2550
X-Proofpoint-ORIG-GUID: UxMR16SBRTq_vFMdqXTPADx_qGwr40zj
X-Proofpoint-GUID: UxMR16SBRTq_vFMdqXTPADx_qGwr40zj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_02,2021-11-03_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Nov 4, 2021 at 2:09 PM Volodymyr Mytnyk=0A=
> <volodymyr.mytnyk@plvision.eu> wrote:=0A=
> >=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> >=0A=
> > The prestera FW v4.0 support commit has been merged=0A=
> > accidentally w/o review comments addressed and waiting=0A=
> > for the final patch set to be uploaded. So, fix the remaining=0A=
> > comments related to structure laid out and build issues.=0A=
> >=0A=
> > Reported-by: kernel test robot <lkp@intel.com>=0A=
> > Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support=
")=0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> =0A=
> I saw this warning today on net-next:=0A=
> =0A=
> drivers/net/ethernet/marvell/prestera/prestera_hw.c:285:1: error:=0A=
> alignment 1 of 'union prestera_msg_port_param' is less than 4=0A=
> [-Werror=3Dpacked-not-aligned]=0A=
> =0A=
> and this is addressed by your patch.=0A=
=0A=
yes, I don't see any errors on the patchwork anymore.=0A=
=0A=
> =0A=
> However, there is still this structure that lacks explicit padding:=0A=
> =0A=
> struct prestera_msg_acl_match {=0A=
>         __le32 type;=0A=
>         /* there is a four-byte hole on most architectures, but not on=0A=
> x86-32 or m68k */=0A=
=0A=
Checked holes on x86_64 with pahole, and there is no holes. Maybe on some=
=0A=
other there will be. Will add 4byte member here to make sure. Thx.=0A=
=0A=
>         union {=0A=
>                 struct {=0A=
>                         u8 key;=0A=
>                         u8 mask;=0A=
>                 } __packed u8;=0A=
> /* The __packed here makes no sense since this one is aligned but the=0A=
=0A=
right, will remove it.=0A=
=0A=
> other ones are not */=0A=
>                 struct {=0A=
>                         __le16 key;=0A=
>                         __le16 mask;=0A=
>                 } u16;=0A=
>                 struct {=0A=
>                         __le32 key;=0A=
>                         __le32 mask;=0A=
>                 } u32;=0A=
>                 struct {=0A=
>                         __le64 key;=0A=
>                         __le64 mask;=0A=
>                 } u64;=0A=
>                 struct {=0A=
>                         u8 key[ETH_ALEN];=0A=
>                         u8 mask[ETH_ALEN];=0A=
>                 } mac;=0A=
>         } keymask;=0A=
> };=0A=
> =0A=
> and a minor issue in=0A=
> =0A=
> struct prestera_msg_event_port_param {=0A=
>         union {=0A=
>                 struct {=0A=
>                         __le32 mode;=0A=
>                         __le32 speed;=0A=
>                         u8 oper;=0A=
>                         u8 duplex;=0A=
>                         u8 fc;=0A=
>                         u8 fec;=0A=
>                 } mac;=0A=
>                 struct {=0A=
>                         __le64 lmode_bmap;=0A=
>                         u8 mdix;=0A=
>                         u8 fc;=0A=
>                         u8 __pad[2];=0A=
>                 } __packed phy;=0A=
>         } __packed;=0A=
> } __packed;=0A=
> =0A=
> There is no need to make the outer aggregates __packed, I would=0A=
> mark only the innermost ones here: mode, speed and lmode_bmap.=0A=
> Same for prestera_msg_port_cap_param and prestera_msg_port_param.=0A=
> =0A=
=0A=
Will add __packed only to innermost ones. Looks like only phy is required t=
o have __packed.=0A=
=0A=
> =0A=
> It would be best to add some comments next to the __packed=0A=
> attributes to explain exactly which members are misaligned=0A=
> and why. I see that most of the packed structures are included in=0A=
> union prestera_msg_port_param, which makes that packed=0A=
> as well, however nothing that uses this union puts it on a misaligned=0A=
> address, so I don't see what the purpose is.=0A=
=0A=
Will try to get rid of the __packed attributes from prestera_msg_port_param=
 by aligning=0A=
the members in nested union of that struct. Thx.=0A=
=0A=
> =0A=
>        Arnd=0A=
