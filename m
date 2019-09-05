Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB6EAAEF5
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 01:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfIEXIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 19:08:15 -0400
Received: from mail-eopbgr740102.outbound.protection.outlook.com ([40.107.74.102]:56048
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726626AbfIEXIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 19:08:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8qlrodEcqIRyzRhYCqlYy3KKA6QZg5ZhIaOcrqxClRbrlhmZFFCqby5HRBs/wUpCMbPdggHWXCIACXPZvOH6OaTCYTGivwLoQz+DzyzbxyzOVhwqnWAuJrdE29g4zs9wQ3Rg7OGl38AzlgECNlrrKaeV3PTPn6+hcp2z6nUrP3etOqOiwR0AkKdlMuQ74cmDyjvT+48urMQ9dlLBXP2losS2UZHmaSGoqd743ldl2M+6mBdYyTcVMUE/COGbWsDg4z/SjOICQe8zr+v/vjHIDqcVfNUPYwx0sPYD7sAeHlLnyEfrMsnaW6T9lPX4DA7jJ0Z2B1uQVQH0KQ1ojYhdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtMAG5qxbOZu6s6pC+n+AdcM8AUGaXFamTe4x60QX54=;
 b=PGK1vehlinKN+Ski3ZwVmV+Sjz0+77bflzeArhunRJfKa8ZR4agZVLBWEod4yuW8paQgcOyak6D5C+cx5EuE+1vfXyDsN+y23CubAu8K4r4jTHFvmjB0xTHIQrUMZoLb1yjxDJvxnyBKDj0mGWt9iaBMXkAzPJRlmEtRrPgeoSwZrTYPM+UOdf8XU/ZV++nWTjUxtN8r25QEb+JkTm3LGxSoLsY7KLpSfm4M78JTimv00wwgcaLE0EwjbhvOc9CK6yACWUXZEbV5K4uWGMRuwshoDDDIUUETISCH1I8Tarmk/lTnmybRAVBfPU61UEY/GOmB9itIh9DNPH76MSduvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtMAG5qxbOZu6s6pC+n+AdcM8AUGaXFamTe4x60QX54=;
 b=JLLvyaVaCNuwdTJ9Lo50yoLdvUp/f7m+vAMlfHM2E5eqwdqAN3E9oayfMePgFOQl849SB17b/uKuc41cCCdj+095dxg/uxQA9EZHfMYmuyR7Is2Wn8m16O5p3QYM7EXkjXecuxEHEG240FwhvPadk21ym3jnya/x1sgZVT3jHyI=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1417.namprd21.prod.outlook.com (20.180.21.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.4; Thu, 5 Sep 2019 23:07:32 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::2cde:35d7:e09a:5639]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::2cde:35d7:e09a:5639%6]) with mapi id 15.20.2263.005; Thu, 5 Sep 2019
 23:07:32 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: RE: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Thread-Topic: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Thread-Index: AQHVXuVjZEYmBu9A80OagVmDV3gGfqcUUN2AgAlrzFA=
Date:   Thu, 5 Sep 2019 23:07:32 +0000
Message-ID: <DM6PR21MB13373166435FD2FC5543D349CABB0@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
        <1567136656-49288-3-git-send-email-haiyangz@microsoft.com>
 <20190830160451.43a61cf9@cakuba.netronome.com>
In-Reply-To: <20190830160451.43a61cf9@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-05T23:07:30.9040322Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f1f33891-0eb0-440a-9ebe-a5e6eb79496f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff0464a8-2242-4c64-ad68-08d73255d50b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1417;
x-ms-traffictypediagnostic: DM6PR21MB1417:|DM6PR21MB1417:|DM6PR21MB1417:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1417EC4451D151C89F163658CABB0@DM6PR21MB1417.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(189003)(199004)(13464003)(9686003)(316002)(10090500001)(66066001)(6246003)(54906003)(53936002)(22452003)(3846002)(6116002)(6436002)(4326008)(6916009)(2906002)(55016002)(5660300002)(66446008)(66556008)(66476007)(76116006)(52536014)(66946007)(64756008)(6506007)(8990500004)(11346002)(8936002)(26005)(478600001)(305945005)(102836004)(186003)(74316002)(229853002)(486006)(7736002)(81156014)(8676002)(81166006)(7696005)(14454004)(76176011)(446003)(86362001)(53546011)(476003)(33656002)(99286004)(25786009)(71200400001)(10290500003)(256004)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1417;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d4Y5YAHQC+x4MYOfU4eiGVL1GWtyblaKJ4W9rN5U2LHRkRy21IZiqWxKuX0NpiEllCPleSAR5BHeuPecCQ76BK1hQSJ91pSC2wSDqDYhYgMdKnTlB/A67YXeHQs6CMuapyxR86KcxUntx90qVUf/BF2w2RXR0R2gf6Z/iVKvJpXabGqS7PKFmdmtPvRjMb/GJEoL44ONw1qhSMapJ+Ll/+4r2bppDq/8m9d/7E4vb6ujXHBWSWbg+Y2tFmEjkU0HlDehFMgsLU1NRpMBt35oGDIxNZ+V3aE+TPhkvLXU0RQ4tHgJ3Xmx+Ggw8XmeplVYnSRtV5FvTvHbWrVa9zM+D4+OGr2TnYYCkuAw+2zS4Y/bad2dzBKUnOWFgCM8k2ZQyz8oLl0l6h8mKGcOz7GpfBpbhfr5mHa2JX2tRomH+hA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff0464a8-2242-4c64-ad68-08d73255d50b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 23:07:32.3687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gIIi0+bs9zrW6ckkEJ0itoeBXAYCnEF9gJuUZfAZg1DMJ7nPb0Uzwu5amEWxzczDPp5JPjVXU1By2m+jwAAfIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Friday, August 30, 2019 7:05 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-
> kernel@vger.kernel.org; Mark Bloch <markb@mellanox.com>
> Subject: Re: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to=
 VF
> NIC
>=20
> On Fri, 30 Aug 2019 03:45:38 +0000, Haiyang Zhang wrote:
> > VF NIC may go down then come up during host servicing events. This
> > causes the VF NIC offloading feature settings to roll back to the
> > defaults. This patch can synchronize features from synthetic NIC to
> > the VF NIC during ndo_set_features (ethtool -K), and
> > netvsc_register_vf when VF comes back after host events.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: Mark Bloch <markb@mellanox.com>
>=20
> If we want to make this change in behaviour we should change net_failover
> at the same time.

After checking the net_failover, I found it's for virtio based SRIOV, and v=
ery=20
different from what we did for Hyper-V based SRIOV.

We let the netvsc driver acts as both the synthetic (PV) driver and the tra=
nsparent=20
bonding master for the VF NIC. But net_failover acts as a master device on =
top=20
of both virtio PV NIC, and VF NIC. And the net_failover doesn't implemented=
=20
operations, like ndo_set_features.
So the code change for our netvsc driver cannot be applied to net_failover =
driver.

I will re-submit my two patches (fixing the extra tab in the 1st one as you=
 pointed=20
out). Thanks!

- Haiyang

