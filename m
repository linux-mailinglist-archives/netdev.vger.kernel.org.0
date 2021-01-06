Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4429A2EC267
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbhAFRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:36:58 -0500
Received: from mail-bn7nam10on2131.outbound.protection.outlook.com ([40.107.92.131]:52992
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbhAFRg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 12:36:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkx5LNhfc9TUfGtIAS8HdjeZL5c6Sqf2hEaTPFPW54pNO97s07LEu7Yc4A952CeG42HsqPvZugz5OtsZQKV8OW/x53IkTwqz5ZoHqK2xl2KGDZ0oZBdPyMfn2e6vXEj9rgmVXpioRWjWXOCpd/QAHFP3OnpRUP2GnvWBooVSYTDROGBaBdNSra7QVTKXxqvn0gnLQWiF0BJqTfwe0BQZAy2xg/66Ww2uDD4aL0omarRafUTCC6lcSSGhPGKrKs29/N8BZjXadpretn0/+xoPhqVc8FkoKW40BDvllZcIvS1olJA9EhCvCPVMxNkXvitLmkJkfFp4CR+kDhLi8kMDOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/QpezglIvGrA0eZjsy6ri3332sHdSEST+KEv0P+WZY=;
 b=hQSZoiYkrZDeuzwpGOUfaXK+GACVJLIp671N3nO4Y5JgWFb2rWYHlj/ciUdJ1tAt4/hCBPq63uYDCvJUN9Y5TTXb2ascrImCoC5Q1vgTOE8+/irUA39DJeg33GasOtlZNFp3WJ0oM2NcUDj+5etUSpvUjNMteEBa8jhu2BPjGPCFj+NY1RabszouusRvr37zzgGWEUumqZEl1KTjpfMHuwLD6YsNEs8ipoWNfIhj/icEPGuXrSypCk7qnoY8ZOGC/jAZ+f5veSQmSiJuYjTdS/c9n8M1tZr01Z5KgBYiVp+fSz3ENB4ZB2w0Td9DDZ13Ph0bKUTwMizr0mCanDjJYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/QpezglIvGrA0eZjsy6ri3332sHdSEST+KEv0P+WZY=;
 b=ZPqKHMVqczy+D3UPQ2geNOvfmiNUWtiLe4utjyC2bKDU5r7frzkXKozyr1cR43fk+z6419eCfTqNh5WpFkY810R/lF3HSHTmC1Apx6DCwYcQKKWj+oPnFV0is8u4woJHJguyZ0B8LHORihcXk9CF+5hvF1coUZWrFE7kFEis+T4=
Received: from (2603:10b6:207:30::18) by
 BL0PR2101MB1332.namprd21.prod.outlook.com (2603:10b6:208:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.0; Wed, 6 Jan
 2021 17:36:10 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::246e:cb1c:4d14:d0eb]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::246e:cb1c:4d14:d0eb%7]) with mapi id 15.20.3763.002; Wed, 6 Jan 2021
 17:36:09 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@linuxonhyperv.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/3] hv_netvsc: Check VF datapath when sending traffic to
 VF
Thread-Topic: [PATCH 1/3] hv_netvsc: Check VF datapath when sending traffic to
 VF
Thread-Index: AQHW48mMgWlBHLToj0W1O847C80iS6oa3Sng
Date:   Wed, 6 Jan 2021 17:36:09 +0000
Message-ID: <BL0PR2101MB093013B5AD2A01249C91FD2FCAD09@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=936cfab2-dd80-451e-ab44-bbdd7da62f59;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-06T17:35:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxonhyperv.com; dkim=none (message not signed)
 header.d=none;linuxonhyperv.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b18b3306-4813-468f-b3c5-08d8b2698e19
x-ms-traffictypediagnostic: BL0PR2101MB1332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB1332220669912829D7D1702CCAD09@BL0PR2101MB1332.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N/4vXD2LOZsxpudp+Nm/ryGgmBu0S54X2zTb02c+cMP0TVcEK+g2vcpEIbWhqtMLkHjifM6vU2HAtaUG9M1pBNE7Iqkub96etx5SrZyFlGwP0imJvhb4i/ThpJ19JnXX+T4p3C4Nt2buMhs18RcqvLLlUP/EHEK+PSTpzc59Pz3Vicq28vs6FENl8yA6ZapzlFJWwJ9n6jJxlezSXiZECCgR0UYoPnAv2w5EyPFTyXrPS5n8MkeTEbSPvsNgIWZ4pv9tpjhT7ABMX3rI6UsUltRbGuUOI+UURN5mnNUgrfDqP9XZ/AosBFv6VetiZNZbTz7SFY31hm7/C2xQrKZ0jkeUst3t+jClhBDOJOW0lq1uhmc8OkfXXHAnqvZl7oOknFVNLxJRXyVsQg+uj4OIlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(53546011)(66476007)(66446008)(64756008)(33656002)(6506007)(76116006)(66556008)(83380400001)(8936002)(8676002)(26005)(82960400001)(186003)(4744005)(71200400001)(66946007)(82950400001)(110136005)(316002)(4326008)(10290500003)(478600001)(52536014)(7696005)(2906002)(107886003)(9686003)(8990500004)(5660300002)(55016002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AYFirQRqIBIesPm5RxOEq2IZtiM3s3agbjuxEzYCukNuuzFCEFVkt/T0UbDg?=
 =?us-ascii?Q?lyPyP/ddMT5JCN+A+K7B/xZ1yUONc1NP2V0zgLMiPo9b3LmnnFwcj2y3wFiC?=
 =?us-ascii?Q?/EPFg/yZc2fYcNXhGIC1Axp2naGAPg4PbMyzFQ2KP25d8ub/grcnmyQUV7TZ?=
 =?us-ascii?Q?l+G8n85wEPukp4slq2laTkRRpOqAYjvGmvWU4jB20vS3K8NtoYj9mwfGkeIh?=
 =?us-ascii?Q?NH4RrMROeEQsnReF9Acvtpw42PErKrg1gc0RTbfhLQmGFEuolUMEdnhpBlwT?=
 =?us-ascii?Q?ys78GzXLjbODoZKPrD0uON5iZd1ijab3BNt7zAV3jbPmgP/E6aQX2xgyg7mv?=
 =?us-ascii?Q?d4gYiFXOnDj2KPhmYpMsoZGhwxuUSA1Dp6ua4IkiZSsaRQM3UOAUgbDNTccZ?=
 =?us-ascii?Q?IiGMuV2hA/9Y5bx1cMdJIs+auaHbpoQrLLrO+1xVjU3HAVYTHt2FhKfJGZsR?=
 =?us-ascii?Q?tWSEnIR3VqwW7cW7XiALT+227XA0Dl/7kIBJ7ACOzTfpSyc64jl0E6iiTHel?=
 =?us-ascii?Q?fZIb0I8jrMArpV1yqDFuEvzcbAApsLbHtRTwumbMBmVie+BRp4YSe5FGMTok?=
 =?us-ascii?Q?vJInZPbNnfoK5NAWJ0+Ts2vhSWAtiL/lw0rLiVmYbX1EzuspJEmFkKMifGvo?=
 =?us-ascii?Q?BIT/yfoPZZ8c/v33sjrwTjtObfZtVTAXGP7GhiGm1TFjeYeMba+5i66DMPL5?=
 =?us-ascii?Q?QankWbELK1T4yW4jJ8xxShrCBmDznanpJk+t808nE5LcLP2RnuBp0Veoe+R4?=
 =?us-ascii?Q?h4MT+xq6o2YrlQhPKExEuCLuOgPYZMNyB2RbD8qiENfOxvoXQ6h5gZQO0J5o?=
 =?us-ascii?Q?U7x1dkHbQgNuYHpJlwXi/f29dpHNzYG2NDXCwBRUcry/4Jz3lzCWO+QmT2UA?=
 =?us-ascii?Q?QqN09bxk39EOlgP7cybKTmUuxq2Imks12k+ricMkHnWhOv+ch/StIe6ExYhO?=
 =?us-ascii?Q?N7XKdP3zekeX20VYc8O+FQ6YRHqcOhB6in12yRDlLrc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18b3306-4813-468f-b3c5-08d8b2698e19
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 17:36:09.5685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9nfjrK8Cv6Sw93IX0ba5GOMybuIRc3/tfWmizepiBBDCLlytqs0j6cGOyO/6qBeLv8/1Vmh3n2ztoGGjjRVFoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Long Li <longli@linuxonhyperv.com>
> Sent: Tuesday, January 5, 2021 8:16 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH 1/3] hv_netvsc: Check VF datapath when sending traffic to
> VF
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The driver needs to check if the datapath has been switched to VF before
> sending traffic to VF.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
