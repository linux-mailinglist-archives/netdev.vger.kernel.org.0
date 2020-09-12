Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40B9267BE3
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgILTXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:23:31 -0400
Received: from mail-mw2nam10on2114.outbound.protection.outlook.com ([40.107.94.114]:54669
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:23:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yde6PBD1cPsRuaANZH+t9e23zgokJOQKtDMPBl2I5r78Q/joN+EMafVVWWTz5Dx7zxHMxzFfOw9A1ky7aIziPR0wE1/EpTRs6oYW1JDUEFfHJ53F7ERdN2Yyhk3tL0MHCWjfVgfaAfylRaIw6zhf+AavAYRUqILbCNREG1WkBgk4Rjf+OHMYLLMapdtcOgli1iJGBrKoyy+GhVbKV1o/4iO7NmYUPsfqPMajosPhITtgPluC0w8sqCWT77JO6Tdg3IKewCFMQ9mVlIAg/oYqFlz4UeKPhJ07WHC/x01yENrEvgKyjQFIbtM7nIInS+0jQwIC3jQf4aC54+bvmF2J4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMP08KSLf9/k4zv1G1BpYMEP8EWoFkaIJKBBJBtGhYc=;
 b=ktqsLB2U5ZzCw5CcVekxxl5jbjaRxx1A7qtvF35puZi12pPMdzhGHBZGfWBAmM7iay7zZMUzeUyndFKqKcY3VzO/blWERzzhayRq+wnI/++M/W7leXhb29xEvgfsjVYjmHqvyYBrLHiOjE6hRrgsANZSWcbDwGgrPyHAxyXPpZYLvAl1fxWjArGgu6BNFA2pH6qxdmX+A/3TGGCUVBFj3VF0jdwjDP8QBnTDn5y41CjdP3dLObQhK8rrcyC2oB2g3pI2jPG5jl+gBRpbbJv3HbPVAy06RZHflfLW4R7qg/jgLrJwXg3VgCT/nLQQYuLI6RRuMwryv3Gu07CR08l1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMP08KSLf9/k4zv1G1BpYMEP8EWoFkaIJKBBJBtGhYc=;
 b=MurFS5HBKG42taDdLWiZ7JwWZygwAg/rqkW4BlRiFv1h33rtEWbD7zu9hRhitIkb5VhivDigEHLA7ONgK4Bv9EtxP4QUHqvvlhweCly/7VLyxCm9LuTgI3Jqmvg931Ngv8GjCUdUTqrnqVu7ZlLQ8buz9ovrj86EJWqIJpOalAc=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0730.namprd21.prod.outlook.com (2603:10b6:301:7f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4; Sat, 12 Sep
 2020 19:23:22 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:23:22 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE
 for gpadl
Thread-Topic: [PATCH v3 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE
 for gpadl
Thread-Index: AQHWh3+XvK3gEZf5Dkqy4sFhfg8006llZRFg
Date:   Sat, 12 Sep 2020 19:23:22 +0000
Message-ID: <MW2PR2101MB1052F3454F1AAF4A5D9D0EE0D7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-2-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-2-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:23:20Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5f8c0fd0-33b2-42c9-9c1c-c5efb702d8c6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 06335d38-89f9-4891-cee0-08d857515061
x-ms-traffictypediagnostic: MWHPR2101MB0730:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR2101MB07306B44D32F72915BEEEBA4D7250@MWHPR2101MB0730.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B2FKYIsUYmIXB/0W/Ecn/etXUs9LgxzeZz1TbOqf2ACfbJRgfVK9yTEoMgYwIBHI7diwpELk5OQ06OJsZVVqHTC/a2lpEcCyggvPKHxQlhD4GGoobiHxv8/epOkhAzb7TH78Q1EhCDReXu52OAA9OAMt+WzLVMrQeMqoRxXmbyDqGWcttOgOygWLQBjJ6WgyysM3oCmlaDe4vKXFyb+qPEM21XDtN8hLmp1zb6Xvb6CUPm+wTaaPEcTewxwRCI+iR8YzbAvlNSKy4SSHZhE9ALyPC0OZDFgG8BIhx9MyVs6epIXL5HBeFA1LJy9Nb0vDa62GsOAoLLydoyiisnR4OAs9TElREelHnt6BPPWJC5WXx4EO3tJLgiX7SHtLTnmg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(4744005)(52536014)(5660300002)(8936002)(2906002)(82950400001)(8676002)(33656002)(66556008)(66446008)(64756008)(66476007)(83380400001)(8990500004)(76116006)(71200400001)(66946007)(82960400001)(7696005)(26005)(7416002)(6506007)(316002)(110136005)(54906003)(478600001)(10290500003)(9686003)(55016002)(186003)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: N0suUn9yuUEDnjo1ifLVoFehoHy1HE6hpnYEV8V/61/Yz2/UZZZ4KLA53KslpnL4L7A16mV4atRIYRdCoR2GkCTDCEKpwJesxXd5T2UKOhu8szZU+OvJ36c6eXydfYPvrx6j+QxJC4lRE3OC0Yqka/YdtA8rHl31gA+NVrr4/AUlkKL/49nGvaOcgMrij+J6+4m1bVMNXJbmRc6DGanc5I98YEo19PYhlUxwza1BYbSxRNQnpliVoeUSGdoP6+TJXe+o36ACpdmk1KrSvB0Vs45HE5Ewp2OZSYpmZJuf9r8ks9AA9gTnuKUkn1o9Ez+TzwVA5lmgkMEvqzaCQG/UDZq/Lig02aAbEyWEtCUtbs8XF1x+nFS2mtO35ELXoZZhoMhfIOXRJNR06f2/ka+YjdI8sWUGy4rdrWD5KRnOE97A0DfUvxKIM9jfBJvj3iaSL/tCnWZMEngCEthngzsWI594sO/0Kk98F/v0oWigX6tJY/ia9IuRZwxWWJ9KPBj90n0xF5sraEVttRlF7Rf/r50FKaeZIW0cIXva/JFkJQZF95mnrekG8pIhnijNOD7f5iJYfNTMZFwwlXmCys8Bmp2EKwCCfJ1U8cqe6vroncRyHpg21+s5oYv2RufgXfUjVRaxbiQOHP958sKSQaX+gQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06335d38-89f9-4891-cee0-08d857515061
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:23:22.2481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QU/W+ACeXgEzt/QAfyaoWQLOq07ddEKi+WbdjuGQI1wOP5CqLwk+z0QuuJPL70kQR0ex/pD1SqP6td0PIfFG9tL0qcPsEdMj7Kbz+3SV/+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> Since the hypervisor always uses 4K as its page size, the size of PFNs
> used for gpadl should be HV_HYP_PAGE_SIZE rather than PAGE_SIZE, so
> adjust this accordingly as the preparation for supporting 16K/64K page
> size guests. No functional changes on x86, since PAGE_SIZE is always 4k
> (equals to HV_HYP_PAGE_SIZE).
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hv/channel.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
