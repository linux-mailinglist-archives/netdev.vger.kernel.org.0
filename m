Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8F7358D88
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhDHTg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 15:36:59 -0400
Received: from mail-dm6nam08on2119.outbound.protection.outlook.com ([40.107.102.119]:13377
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232287AbhDHTg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 15:36:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaeAKYjtROuKzcDFLYrE56h32bfWZn+FmnD2+lOiGfRAynnv41pyQOytiCDiv2jMxBfGfCxn4ociILy+JFQcpUqicErpSysPysaZL/N0t2Vf/qKEs2dHW0aeynzAH2L7ZesG9ck2fSeNuobcPQ8l25fDLWwJi0i55x1cjDtqs6zrQuHUuYeclgu8Auofbg0AKtQpMJS1fFIz2TvtE3FRrIwrSHC5cQbrmR3Ec7yEaNC87zpa+EGvKp7vihTBqLrb1FhFt7ZjNtMxTsBv/TOdU0cvosBiBInZhRtgEieMf7DCkmwfdjPQMxoxJJnaDZT7TuTR/Ld0VhzqxfYzVsidAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVN4LHXhs34gYXyZLXXYtKAGfZZ9YhONaDM2NVVb4bE=;
 b=ZeaH3V/LQicaMokyM2I/7VXa+JM5XsVbQXXMlmkm7ggFAvKO0babwzre0IVbzQulmhB8ClTmbzxCMFkrvb+3lTh7FWl3i5tuTaiXFw+NQRliWhO/b0YaVcz6opnPO/l+VG/ui3l03qCL0cAZAV7vet4d4fTE513cc8bftgfRLd3Zkrq+0yxZdGLZWSz98gRnhC0YyH/aXFLYWJsFcQNCBYiAR8as0vKsbqN+OiGsSwLBVWZfWXbtutpPU6ludYaPOx3tWi8ZYBRrc1qjV1PYAvG98O+KgYyUyE4vD4wAerInn0PMlh8lNUf1QPefzE8/BhYAUqJ89w5vPtcMRRBnSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVN4LHXhs34gYXyZLXXYtKAGfZZ9YhONaDM2NVVb4bE=;
 b=AGEfSbdFLorn59Ew0HH7qHfYJ+aWyyc7rVdMAakfNKVJNRAW52asisnXh9VTKKYGnvwRgPp+ANLJXPVHTQSXrEVDZuGD3KwPy+g9Z2/TWqSM2LzSAoQfzgUNKQkevYMLrEaUcz4CaelD76m7If32sLtKPrtu+Op3KsZD7jgUUQw=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0511.namprd21.prod.outlook.com
 (2603:10b6:300:df::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Thu, 8 Apr
 2021 19:36:43 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Thu, 8 Apr 2021
 19:36:43 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLJNvWwTaiq/N6kmoh2zI81GxFKqq1e8AgAAs1JA=
Date:   Thu, 8 Apr 2021 19:36:43 +0000
Message-ID: <MW2PR2101MB089287F1085679E5FDABFC18BF749@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210408091543.22369-1-decui@microsoft.com>
        <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
 <20210408095222.058022d0@hermes.local>
In-Reply-To: <20210408095222.058022d0@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b8b8998d-5903-4369-9444-9f4367fe035c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-08T19:32:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:adc1:3ae7:8580:9c8a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22241e18-012b-482d-4584-08d8fac5a3d6
x-ms-traffictypediagnostic: MWHPR21MB0511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB05111E2FE53375B7ACF592ABBF749@MWHPR21MB0511.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c/stn26cWrCcMWoVTapnPMNv+o6B+6KYFa7B12rdz+wP0nR7I4iAOqWdutSKFEJWlEp0fn5fB8PSaWLES3YVKSE8Y2SQoGJkT6mvH/Ryc+WIkBRDOTLXyX+tVk+0O1jSVbrqfQX0zDoNxig9MwQ4CRybD0rj0cxE6+mFmhcA+ZIj1mYUFGHwE97A76R6MvmC22z1bNHzpNDNQqOCtFqXEGy03PSoTlJM8C9yptcFg/n1DwltGbk5q/wl5aP1jBZlyyJtojPFOenwt5xa3s1jWyoAQREGPbn8ZQ7KETCGqPfS8VfizFiFvdD1Bf5BsulzkhkuxaDPJba+y+zJ8LP2Bk4ysuIUmhBegunDa3xtpdeinxELTWO4w0uQx0Q2GyWuGtmyOZvkz+jDcLvzd52FtoOXbAgdse9+PdLVVQ8usMGrCBZZiH5xW6Qg2lunbH8Ia3H1T/vPVxXwpPiwAkCtr8XmCRf42QZ0skqsLwthSzJGRmi1GiP+ffv7J/wUnieB2S0KMMaycSLrJOGpR0Wq3JL1eNm1GvDg/y7Yds5X9l+h4LMjvKp568BOrnznW6YAQlxxlxibGqvgm8hhTunxncZk0ycag2T66/IvqnL1uqObNpfcEHCVPQXd9izaNEQcaDqt/HeSAa3QLdH5lZBm+oBabrC0LYWU6TBRB6e2Fbs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(47530400004)(8990500004)(83380400001)(7416002)(10290500003)(8676002)(478600001)(186003)(4326008)(55016002)(33656002)(38100700001)(8936002)(2906002)(76116006)(64756008)(66446008)(66946007)(66556008)(66476007)(5660300002)(9686003)(86362001)(52536014)(54906003)(82960400001)(110136005)(82950400001)(316002)(71200400001)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JP0enpZpnfOz0h0E0L7lS5b5EFanrgqgCrKtovLggfhSECbRwUxrrzAhtXwI?=
 =?us-ascii?Q?xbKHbFUe+orZ0LYLlN/vBAuICX52jB7yI9gUJohB8flrJ6Rs0CoJI6nd+HI3?=
 =?us-ascii?Q?x20dVXtC5e751LFDLDuyEqf+HPLj9w/vO7uOdFyvUCO1A+gxlLhSKw8AO+Se?=
 =?us-ascii?Q?CJOq4WyYhBJuY9VyIF4NO6z005iCvp8xDFcNORnMizLaxjRPwe4i1wbvhoZx?=
 =?us-ascii?Q?l9UshUhACuIJkcqYMcOKY12d55UBVKmx3K+Wx9eRY47D9rfBTOiYspyD2DvY?=
 =?us-ascii?Q?/hJ+CCKO1nY5ybBx+d6wvhgqADRTFJT20FcVOLCw591ZedJjGLLhwuGymqjV?=
 =?us-ascii?Q?IuUaqFzIYzL0OnVfn57AwP1O/rHnm3+iWTkGJEhpDbYyNytuUaSudLmeDzc7?=
 =?us-ascii?Q?S44HVrWfXKsVP3b+vPB9oE7PrYxx4nxQ+wSJlVKmhliBUktyJrlD5G5PasAR?=
 =?us-ascii?Q?HckcD/ElYb56V2fW16eOGjHa7GEhOmTMGB/sBKH+EWFdEU4GjXYcoPM82q3v?=
 =?us-ascii?Q?m1kvL2p/y/TUE6SdhLDRprk3+AAQkMfNpmZmS4fsI8Uow/uGmy76YiDpoArv?=
 =?us-ascii?Q?j5vEqLg6h0a7gAu4kRYWWBBPOaLKogN9hR+sCPuLW1NCXog8AMlVmUqgdNZB?=
 =?us-ascii?Q?peEoZ1Di2PMqcq7iuXV893WlcgDNhQb7yqyopqeo1Q9MoloiFMGQiA8alSe1?=
 =?us-ascii?Q?Z0zeRGjKVh2DLJSOXjVr9n/Yb05jtqIQCIdS7Ujh1VvpN5eKpAeyh1DhAkGm?=
 =?us-ascii?Q?ePDoQxSQgKLwM2Ym76Ag+bprVWc7xSfcYrKXYWUcvSa4h5jQDCpUTd5YrZUb?=
 =?us-ascii?Q?FGabT2TQuYDx2oSImmQONhZE8u6c1S0pGyuFX0qA94tDeDbC4bHIGYe+WbIX?=
 =?us-ascii?Q?JnJoPhj/3vIvJ0QATn+k3dMAYBIMr6WN8mM/QODULzrGuNjr2RGffDXLJNg4?=
 =?us-ascii?Q?0k+5UfoqLIGP1lcNuD+ipmAm6bBeLaCjyekiHimY5t+MvzZBrDMRw4+sBeTP?=
 =?us-ascii?Q?Zzh7nzAK7V/rvitzYCmqBoXFj/zNcnHyvJPWp1WF5z4X8sUuViLAZhn2yKuo?=
 =?us-ascii?Q?DL2j/LkOmkYZ2WM8JnU9k2XW+lGeqID75V8xBa6Az36f/h9yXTB9DB6LAcYd?=
 =?us-ascii?Q?d+TWgfOstT8vovlAq+ewB+PzyfZA7yjKzQO6LCIBF2F+8W3EfzwApSVan9KV?=
 =?us-ascii?Q?9vd84aXetNVKKnFiukJCO9Wx3rbOrFAVmeBfy1e9J3lj7UdxVgb9kKy1mF7o?=
 =?us-ascii?Q?erZkCxhvuuZQMsOnaXni0gMrp4O2QByc//eLjJHHr0PXG/rr0yGGhIKb9vrX?=
 =?us-ascii?Q?Xvg17HYw1N+VcX0k6f1zWIPXSiWL+HvOpM9MYnQMWg03Hr2wovknnKNDyMWc?=
 =?us-ascii?Q?FEEw+QirL/tQEm97eexa7VQdj99K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22241e18-012b-482d-4584-08d8fac5a3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 19:36:43.6065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H6i1nLpwTwGwHUNuQm+I8aB8ABmeS/CJ6JBCAgZLHGwy2pJRe+6WrWdVDs2LrsLr9iqTRxtwS/R8n2jfkrAdZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Thursday, April 8, 2021 9:52 AM

Thanks all for your input! We'll make the below changes as suggested:

Microsoft Azure Network Device =3D=3D> Microsoft Network Devices
Drop the default m
validated =3D=3D> supported

We'll also fix some warnings reported by "kernel test robot".

Will post v3 later today.

Thanks,
Dexuan

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/=
microsoft/Kconfig
index 12ef6b581566..e1ac0a5d808d 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -3,26 +3,25 @@
 #
=20
 config NET_VENDOR_MICROSOFT
-	bool "Microsoft Azure Network Device"
+	bool "Microsoft Network Devices"
 	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
=20
 	  Note that the answer to this question doesn't directly affect the
 	  kernel: saying N will just cause the configurator to skip the
-	  question about Microsoft Azure network device. If you say Y, you
-	  will be asked for your specific device in the following question.
+	  question about Microsoft network devices. If you say Y, you will be
+	  asked for your specific device in the following question.
=20
 if NET_VENDOR_MICROSOFT
=20
 config MICROSOFT_MANA
 	tristate "Microsoft Azure Network Adapter (MANA) support"
-	default m
 	depends on PCI_MSI && X86_64
 	select PCI_HYPERV
 	help
 	  This driver supports Microsoft Azure Network Adapter (MANA).
-	  So far, the driver is only validated on X86_64.
+	  So far, the driver is only supported on X86_64.
=20
 	  To compile this driver as a module, choose M here.
 	  The module will be called mana.
