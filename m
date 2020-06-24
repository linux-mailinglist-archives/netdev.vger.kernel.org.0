Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7014D206CB6
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbgFXGjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:39:48 -0400
Received: from alln-iport-8.cisco.com ([173.37.142.95]:57191 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388582AbgFXGjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 02:39:45 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2020 02:39:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3099; q=dns/txt; s=iport;
  t=1592980784; x=1594190384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xWBM2vE0FQ2vKsvc8Dn1Hs9MkPPPcSR+9RFtU+CbtJc=;
  b=gvDF0HmEWwLABUjtzRRzIhetnG+aserKPYtjVv+pMpnC6p9rLCouJr1i
   2dXcPpui5otjzdov5xakJAC3jh8NvqOm92gGO8XI/TktRd9SCV6TuYyYQ
   crg4CNI/vEpdoBPeif4nlbshjwNHmewBz2n6YaWikxgBW7Cgt+ZEI3CQ8
   8=;
IronPort-PHdr: =?us-ascii?q?9a23=3ApNe+BhbJYDDg5HaBXBQqjAn/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el21QaZD4Hc7PRLkO3Q9avmCiQM4peE5XYFdpEEFx?=
 =?us-ascii?q?oIkt4fkAFoBsmZQVb6I/jnY21ffoxCWVZp8mv9PR1TH8DzNFnVpXu99jkUXB?=
 =?us-ascii?q?75ZkJ5I+3vEdvUiMK6n+m555zUZVBOgzywKbN/JRm7t0PfrM4T1IBjMa02jB?=
 =?us-ascii?q?DOpyhF?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AOAACD8vJe/4gNJK1mGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBARIBAQEBAQEBAQEBAQFAgTgCAQEBAQELAYFRUQeBRy8sh2o?=
 =?us-ascii?q?DjUmUWYN+gS4UgRADVQsBAQEMAQEtAgQBAYRHAoITAiQ2Bw4CAwEBCwEBBQE?=
 =?us-ascii?q?BAQIBBgRthVsMhXIBAQEBAxIVEwYBATcBCwQCAQgRAwEBAQEeEDIdCAIEAQ0?=
 =?us-ascii?q?FCBqFUAMuAawuAoE5iGF0gQEzgwEBAQWFLBiCDgmBOAGCZoV5hAMaggCBVIJ?=
 =?us-ascii?q?NPoIaggobg0WCLZFzonUKglqZTp8BLZEKnksCBAIEBQIOAQEFgVoIKoFWcBW?=
 =?us-ascii?q?DJFAXAg2OHgwXFIM6ilZ0NwIGCAEBAwl8kCMBAQ?=
X-IronPort-AV: E=Sophos;i="5.75,274,1589241600"; 
   d="scan'208";a="516651427"
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Jun 2020 06:32:38 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 05O6WboN017692
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 24 Jun 2020 06:32:38 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Jun
 2020 01:32:37 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Jun
 2020 01:32:37 -0500
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 24 Jun 2020 01:32:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxZc6bA4dPCiI5zIWy+Tlvp1FvdsWsdqcafvVSWqg8LdVs5cWGp18Ae6DMci6ovTPVG1xci+x1dSBtBZ0QuQ8+xQjrokegYa3y9l/PNRPAV2TpentCfPcy7FrQgsaHUrsg05lwJfN3SijyV8ILOmCKvp7olrOeE4mrAAuMlk41H1lhiNpURS6o4sp5XAKP/jlg7apNakKVcSVh5+XkW3PZL2WXEAWSQAB0M576NF+9iAFipNLr5dlQKTrSrjixnMpJ70SWaA5ZtCNYRlz3CUh94Gj7uafruYJgluLeEhzOKtzKJFoF/huGLUX9rSoDZhuA4aju0zK5lPPcKkAuGViQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDA+9sQ4BK8U4WckdkGjBO/ZqdXDlyKgw0jrFrd4Lwg=;
 b=LwBzmgnbRo/FLc9JwByg8bhvEfX6gSwMcsDntQeGH1tN/wam7SADFc5QA9W5/J8pFFlsxZRr55/kbIWMICt03t6lvLykX0aHBmgR39/DVCuQJjsRjU0cXLSOu0EDWj93xCKdly/h2+OrieeMvciZEGfZTztq6+TtMLP3soOGu0q5hBEm8oKc5IC6QTZWxD88DYGKggR8gZohmrdEH18y5vTydNGtyNzN2qUHuMO+usM3kjv4pEiojXUUIoglsSpvp2ACJUFbVQXED9x2exyPu0stqI8QDmZD+j4FXX9ag1oqu+uuXlBO2K9y/di4XDzH4KfAdaWxdDm8eFzcKEqAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDA+9sQ4BK8U4WckdkGjBO/ZqdXDlyKgw0jrFrd4Lwg=;
 b=VK49Mx372So98/s+xzy98h51G7C3L3S0JBcjQj4WtFOC2toD3OMriaD6rB+CtLCljy1uwugsKAR17/rM6UIOCrnCS9Vvo28F2VRdQFCVwCGcm880O5nGyKbWdqPN8LsCfhay+qtkMrpM4aPw13w0l1+LaUSu0xgBt86HX9pUcCY=
Received: from BYAPR11MB3799.namprd11.prod.outlook.com (2603:10b6:a03:fb::19)
 by BY5PR11MB3958.namprd11.prod.outlook.com (2603:10b6:a03:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 24 Jun
 2020 06:32:36 +0000
Received: from BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::60fb:1a14:be44:9b0b]) by BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::60fb:1a14:be44:9b0b%3]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 06:32:36 +0000
From:   "Christian Benvenuti (benve)" <benve@cisco.com>
To:     Kaige Li <likaige@loongson.cn>, David Miller <davem@davemloft.net>
CC:     "_govind@gmx.com" <_govind@gmx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lixuefeng@loongson.cn" <lixuefeng@loongson.cn>,
        "yangtiezhu@loongson.cn" <yangtiezhu@loongson.cn>
Subject: RE: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
Thread-Topic: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
Thread-Index: AQHWSTYrQiYT8rgg0Ee7vd1HHqJOFKjmuV2AgAAO4ACAADrGgIAAGDMAgAAE/ACAAAGysA==
Date:   Wed, 24 Jun 2020 06:32:36 +0000
Message-ID: <BYAPR11MB37994715A3DD8259DF16A34DBA950@BYAPR11MB3799.namprd11.prod.outlook.com>
References: <20200623.143311.995885759487352025.davem@davemloft.net>
 <20200623.152626.2206118203643133195.davem@davemloft.net>
 <7533075e-0e8e-2fde-c8fa-72e2ea222176@loongson.cn>
 <20200623.202324.442008830004872069.davem@davemloft.net>
 <70519029-1cfa-5fce-52f3-cfb13bf00f7d@loongson.cn>
In-Reply-To: <70519029-1cfa-5fce-52f3-cfb13bf00f7d@loongson.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c8:1005::9b8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff8657fa-9cb7-484a-1c55-08d818086268
x-ms-traffictypediagnostic: BY5PR11MB3958:
x-microsoft-antispam-prvs: <BY5PR11MB3958D362DA0162F234CD21C7BA950@BY5PR11MB3958.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Dy+GbLyCN08mnIKSkAAl45Ik0e2FMbaRkKx3xQcLQrWhOrKN1Mu2DUWNv7V0Z3sx/i9CBvv22++owmV8bFkNxeX+PQwC3+Z1OKkR6y2yXhLBi2v9xqKMLkCdmI+8qh5t+iKlD4pIzh4haDB8cMD7ccSCH1+wCsZkBHkqW0UiqTYPMJf+wtNp7UegZo3VvzoSUg40Yw2IZ1HYeB+af48EDqHgyLCwXnZBOUm8SzIcjMY8kiyGLileSYsdEHd7wIZtpWkMajxgWpGvI1YPe+L7CfrgG7jIEiMyeMAo4DHuqvO6mxd3Oz5wSbKx0NxBnpehEx0UEj32ANVJxKNb2oYLKYoxsO9FQ8EpeptBTju28ZfPQMkMMr+R65BJuvHrOic
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3799.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(66476007)(186003)(66556008)(7696005)(478600001)(9686003)(5660300002)(6506007)(8676002)(8936002)(53546011)(52536014)(86362001)(110136005)(76116006)(4326008)(66446008)(64756008)(2906002)(66946007)(83380400001)(33656002)(316002)(55016002)(71200400001)(54906003)(518174003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TbjTiLoz2aFtflubhdELcp6w4O8P9xUJMHn4Za06vdZRtg7MLlnEsOxIr/Y2ByP8jYdHSx/PECGV+P24QaXiIom3Vc6RJ3f7i1nmZiuSYgBwB7P7d+pW5Px2Az6zNE5J2SeC30WSHLlH4BiRmPhMf5vvveTRjFPBXUgcI8BTP0OHPadU7NVqXmzbaXX9JST+3AZpzb4aFhXG0xpGJNMazfZOR3Ujjg4gCqanxEvXH564FrcnHBoozvoepQDFd+4HMU9PE79GiW2Ni+o36qIkmU2BPpcXdEEUuJRBEGA6vS//XxB65LraXfK6x0GZD0gH7O/cdG8QwT9xBjupDtJzzjAIYJxW4F9i/0wcy82038AHelg5yy+TNBBPqM7WPFQItJ47VJtLvwrzWgejS/K2qWeYQOwsa9lVaSuPiZFM0ibDfdc0GWsjXO9QLcUtU7ZkDj1cllD7TvgcNoYJItH68Qt4BpSDgKMh6YDOZLSvXN4j9l7uXctjexCrdLhBEFhVN48YDujZFBA642GBFaih9g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3799.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff8657fa-9cb7-484a-1c55-08d818086268
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 06:32:36.1111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /v1vytIOfs7EZ7cBAO9yiiye6yG5unzxSiOIGdLwT/ZCarFTFQQTziwD4otf817c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3958
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: alln-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Kaige Li
> Sent: Tuesday, June 23, 2020 8:41 PM
> To: David Miller <davem@davemloft.net>
> Cc: Christian Benvenuti (benve) <benve@cisco.com>; _govind@gmx.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> lixuefeng@loongson.cn; yangtiezhu@loongson.cn
> Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug =
in
> enic_init_affinity_hint()
>=20
>=20
> On 06/24/2020 11:23 AM, David Miller wrote:
> > From: Kaige Li <likaige@loongson.cn>
> > Date: Wed, 24 Jun 2020 09:56:47 +0800
> >
> >> On 06/24/2020 06:26 AM, David Miller wrote:
> >>> From: David Miller <davem@davemloft.net>
> >>> Date: Tue, 23 Jun 2020 14:33:11 -0700 (PDT)
> >>>
> >>>> Calling a NIC driver open function from a context holding a
> >>>> spinlock is very much the real problem, so many operations have to
> >>>> sleep and in face that ->ndo_open() method is defined as being
> >>>> allowed to sleep and that's why the core networking never invokes
> >>>> it with spinlocks
> >>>                                                         ^^^^
> >>>
> >>> I mean "without" of course. :-)
> >>>
> >>>> held.
> >> Did you mean that open function should be out of spinlock? If so, I
> >> will send V2 patch.
> > Yes, but only if that is safe.
> >
> > You have to analyze the locking done by this driver and fix it properly=
.
> > I anticipate it is not just a matter of changing where the spinlock
> > is held, you will have to rearchitect things a bit.
>=20
> Okay, I will careful analyze this question, and make a suitable patch in =
V2.
>=20
> Thank you.

Hi David, Kaige,
I assume you are referring to the enic_api_lock spin_lock used in

  enic_reset()
  which is used to hard-reset the interface when the driver receives an err=
or interrupt

and

  enic_tx_hang_reset()
  which is used to soft-reset the interface when the stack detects the TX t=
imeout.

Both reset functions above are called in the context of a workqueue.
However, the same spin_lock (enic_api_lock) is taken by the enic_api_devcmd=
_proxy_by_index() api that is exported by the enic driver and that the usni=
c_verbs driver uses to send commands to the firmware.
This spin_lock was likely added to guarantee that no firmware command is se=
nt by usnic_verbs to an enic interface that is undergoing a reset.
Unfortunately changing that spin_lock to a mutex will likely not work on th=
e usnic_verbs side, and removing the spin_lock will require a rearchitect o=
f the code as mentioned by David.

Kaige, V2 is of course more than welcome and we can test it too.
We/Cisco will also look into it, hopefully a small code reorg will be suffi=
cient.

David, from your previous emails on this 3D I assume
- we can leave request_irq() in ndo_open (ie, no need to move it to pci/pro=
be), which is done by a number of other drivers too.
- no need to change GFP_KERNEL to GFP_ATOMIC as it was suggested in the ori=
ginal patch.

Thanks!
/Chris

