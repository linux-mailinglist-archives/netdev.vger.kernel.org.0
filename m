Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0913439
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfECT6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 15:58:22 -0400
Received: from mail-eopbgr1310115.outbound.protection.outlook.com ([40.107.131.115]:39136
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbfECT6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 15:58:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=h0cpzNenm9FUkvSlNzawlQ/YhQSCw6SFBkYpyYoPGTf4VNKZbxJaN9nYKug2wUgZwmVc+6bJwXXTC354jpW/etEICe5XQCO1ScrIja9lDL8YpZLFF/l7l91oVv+4EDd2XsDp7JLG+MyN3j7Da9gL7Vo4W9E/JlJj1kYffcEUZQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMRXDRqPW08ac2Qx5VQBL5kdsZPGVlBC5dzAf5TEYQY=;
 b=p9JIKrdNV/DxSlYlU3xzfXln2OfAwH+GXPcJGagGGX9K6iPjXiLoJ8B6hJeCC9XLEVzSd3rCYF/URYAQbFjgrAc9Fzp+XD8h4HRXO61302XBwS55VoRvqfn3EDXN2ZljjhsKCdGLWAGTySOs5Xl62zkPVLnSmzNA4H5KoSQ+TU0=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMRXDRqPW08ac2Qx5VQBL5kdsZPGVlBC5dzAf5TEYQY=;
 b=AorFzR+nYM2JzF8bidM1Nkv8wJ1bwJHDDUZR7oRzzFtPUEVinFuK2kTrkpsMJYxBMTIFTVlg8bTFIYLI7ES754uHR2/81ultTOcYvnncbz2jdn5aZL3RAq+T1Nws4iwDRwH/vJ+kZvnMTPK3rOquu65Q0s6mSK5+9mX9OV3hxQg=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0188.APCP153.PROD.OUTLOOK.COM (10.170.190.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.11; Fri, 3 May 2019 19:58:13 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::9810:3b6b:debd:1f16]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::9810:3b6b:debd:1f16%4]) with mapi id 15.20.1856.004; Fri, 3 May 2019
 19:58:13 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Hyperv netvsc - regression for 32-PAE kernel
Thread-Topic: Hyperv netvsc - regression for 32-PAE kernel
Thread-Index: AQHVAeqHjkTZJm8GekSKWOjutArYtA==
Date:   Fri, 3 May 2019 19:58:13 +0000
Message-ID: <PU1P153MB01698936BF3332FCBF64D65DBF350@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <6166175.oDc9uM0lzg@rocinante.m.i2n>
 <DM5PR2101MB091875296619F1518C109E71D7340@DM5PR2101MB0918.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR2101MB091875296619F1518C109E71D7340@DM5PR2101MB0918.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-02T22:23:34.1321169Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f05d3649-7f6f-4063-881f-89c658604d4e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:6103:22e4:1ccc:dff3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eebda9a8-f907-40fb-f54e-08d6d001acfc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0188;
x-ms-traffictypediagnostic: PU1P153MB0188:
x-microsoft-antispam-prvs: <PU1P153MB0188A5B4A10FC91ABFFB3D26BF350@PU1P153MB0188.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(39860400002)(366004)(346002)(199004)(189003)(7696005)(76176011)(86612001)(55016002)(10290500003)(446003)(6436002)(8676002)(478600001)(33656002)(2906002)(14454004)(66446008)(81166006)(8936002)(66946007)(53936002)(66476007)(99286004)(6506007)(8990500004)(102836004)(73956011)(71200400001)(53546011)(22452003)(71190400001)(76116006)(64756008)(9686003)(229853002)(186003)(66556008)(316002)(6246003)(25786009)(4326008)(14444005)(256004)(46003)(68736007)(11346002)(6116002)(52536014)(486006)(476003)(7736002)(1511001)(5660300002)(305945005)(81156014)(86362001)(2501003)(74316002)(10090500001)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0188;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IlkJwDfgB8PISdmuc1Z2HceyO67Ug9jmv8FlE7g3ev7DqCzZzuiNUQp2UgUBN68ZCHzhk3Ql80drSPk2ij1P5NgwFTlTUfME3MQPE+yPjaBDxoRhpVn7z1qgo3nQHinFr+rV+B0Sv8EBFdHERNtoodE0oRgByC4r82qudCdP/AjLI9UlkrHswRoVj0BM6btN3AMFuBisZd6GOLLlpbuIP1i3AW7/zeM6H5AsEb8KNL9Vg5ZSuAJrfindDNy4f9II6x8ZrOaIjCy/BgaPTikHKobqGrjw7qqsv2DsZdx2H8snJFt9U08Bb+6Fsc4tW7fV1ETtyet22vEZ86cjPs0uLKxDHfsdjRm1Cy1okDRgvDmhWAKsgEATIo9up1aZgqcuafeR8ZhqS+FpoVQc9OFEhvRTEt10G/9PIfu0wT6I2mw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebda9a8-f907-40fb-f54e-08d6d001acfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 19:58:13.2149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0188
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Michael Kelley
> Sent: Thursday, May 2, 2019 3:24 PM
> To: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>;
> linux-hyperv@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Subject: RE: Hyperv netvsc - regression for 32-PAE kernel
>=20
> From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com> Sent: Thurs=
day,
> May 2, 2019 9:14 AM
> >
> > So I got to the following commit:
> >
> > commit 6ba34171bcbd10321c6cf554e0c1144d170f9d1a
> > Author: Michael Kelley <mikelley@microsoft.com>
> > Date:   Thu Aug 2 03:08:24 2018 +0000
> >
> >     Drivers: hv: vmbus: Remove use of slow_virt_to_phys()
> >
> >     slow_virt_to_phys() is only implemented for arch/x86.
> >     Remove its use in arch independent Hyper-V drivers, and
> >     replace with test for vmalloc() address followed by
> >     appropriate v-to-p function. This follows the typical
> >     pattern of other drivers and avoids the need to implement
> >     slow_virt_to_phys() for Hyper-V on ARM64.
> >
> >     Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> >     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > The catch is that slow_virt_to_phys has a special trick implemented in =
order
> > to keep specifically 32-PAE kernel working, it is explained in a commen=
t
> > inside the function.
> >
> > Reverting this commit makes the kernel 4.19 32-bit PAE work again. Howe=
ver
> I
> > believe a better solution might exist.
> >
> > Comments are very much appreciated.
> >
>=20
> Julie -- thanks for tracking down the cause of the issue.  I'll try to
> look at this tomorrow and propose a solution.
>=20
> Michael Kelley

Hi Juliana,
Can you please try the below one-line patch?=20

It should fix the issue.

Thanks,
-- Dexuan

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 23381c4..aaaee5f 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -38,7 +38,7 @@

 static unsigned long virt_to_hvpfn(void *addr)
 {
-       unsigned long paddr;
+       phys_addr_t paddr;

        if (is_vmalloc_addr(addr))
                paddr =3D page_to_phys(vmalloc_to_page(addr)) +


