Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E674523BED4
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 19:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgHDR0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 13:26:47 -0400
Received: from mail-dm6nam11on2132.outbound.protection.outlook.com ([40.107.223.132]:37088
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729760AbgHDR0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 13:26:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEdgRJVlH7wJVCPEVLxwAnLeBJcm5hI7bUGLhPA8Z3/dhvqW1YdALckQ1VxuPaIuap3UQyEI8kq0dCuT0rmEW+IQbLQRuskJZdPID5nPQxNoxlaNf0ZQOmW7MgpNG14dsqGbFuWU3aRxcn4jBNERVjr9t4jiX3Bmh1oqxg/PSaGyuD5pHNfNe7du+zF7NABh6owqplKRfkLt3wCNwbwb+xr7FHsQt4tVXPJNZ1MW6oC7BRqoDafKsctV77qRu+1D0pLGUTeTTV3nYuvqr3V9bqL29ZbLQgxsRyMlGtDcrGWCy3U1hIlVCc/65MRT1aKd3ZZpLgcLyQmEbabW3ba0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu5UHZG7fzERdln2XPueNPsHt9RmwpzS573sjSFWIDA=;
 b=jRtXFb5lrCRSSj3q1b+kkoRr40/Nn/mUrXyIJWiNIwVeUv8N0ZxosRfcbziL4J1xB7p2c6eztBdltQ/97HEt2S87dGpVZoDrscI93HStzvyymTQttTDio/CW1RE5f4McA77sYK1wwbHZcSwQd5gLIK2KLBqU4xe0EPeqNmPn97rgIVJfMfZAYGC/mOBBRjtsIFfBGh/2i6rLtX3WxK3GrfCN4AEogZsdzhXdlhcDbRLS18KSfeRAK2QgnOMn0KMWDCF4BE1kbL1Ym8tgZ4mxg2MXqLR7PDQn1fvCpchuau399/Y+CsXegDNfdgehTApVgelmuNci9OT3VHDAKLbhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu5UHZG7fzERdln2XPueNPsHt9RmwpzS573sjSFWIDA=;
 b=ChQTC5U0OBU8JokCNnzELDax/eORieG/jKyOdmrSEqBVjtBD1FhThejFa1LfM1Vud2kw915/WuUFn9PHeNxVo5qH8ltZWDrarFA1AtkvPjhGZkUXdqgb1hVvnzup3X3NZnz71FHR8CQV/GhymfTGZANLlJ8pPKjx4Wu2U/14G4o=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1779.namprd21.prod.outlook.com
 (2603:10b6:207:19::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.2; Tue, 4 Aug
 2020 17:26:44 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%4]) with mapi id 15.20.3283.001; Tue, 4 Aug 2020
 17:26:44 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Shah, Ashish N" <ashish.n.shah@intel.com>
Subject: RE: [PATCH] hv_netvsc: do not use VF device if link is down
Thread-Topic: [PATCH] hv_netvsc: do not use VF device if link is down
Thread-Index: AQHWan/mLqHhVjec0kKlnoZJGrvU7akoM03w
Date:   Tue, 4 Aug 2020 17:26:43 +0000
Message-ID: <BL0PR2101MB093051C80B1625AAE3728551CA4A0@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200804165415.7631-1-stephen@networkplumber.org>
In-Reply-To: <20200804165415.7631-1-stephen@networkplumber.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-08-04T17:26:41Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=851bef6e-8a0c-4ab6-856f-28cdb99beb8c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9b72e943-3e59-4b16-9141-08d8389b8f2e
x-ms-traffictypediagnostic: BL0PR2101MB1779:
x-microsoft-antispam-prvs: <BL0PR2101MB1779B71AE8058762CB17BC5ECA4A0@BL0PR2101MB1779.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(66556008)(5660300002)(66946007)(8676002)(53546011)(76116006)(33656002)(10290500003)(316002)(8990500004)(54906003)(110136005)(6506007)(2906002)(66476007)(4744005)(8936002)(9686003)(82960400001)(55016002)(52536014)(64756008)(66446008)(4326008)(7696005)(82950400001)(26005)(83380400001)(478600001)(86362001)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b72e943-3e59-4b16-9141-08d8389b8f2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 17:26:44.4906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EXAdbkOslHIZ7703oCWpgBioNHsuNlbtWFOpwAe18lvNDzGRPe4VKqPPUwum3Jdhw/igN0XnfZImv5WAjeZSYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Tuesday, August 4, 2020 12:54 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; davem@davemloft.net;
> kuba@kernel.org
> Cc: netdev@vger.kernel.org; wei.liu@kernel.org; Stephen Hemminger
> <stephen@networkplumber.org>; Shah, Ashish N <ashish.n.shah@intel.com>
> Subject: [PATCH] hv_netvsc: do not use VF device if link is down
>=20
> If the accelerated networking SRIOV VF device has lost carrier
> use the synthetic network device which is available as backup
> path. This is a rare case since if VF link goes down, normally
> the VMBus device will also loose external connectivity as well.
> But if the communication is between two VM's on the same host
> the VMBus device will still work.
>=20
> Reported-by: "Shah, Ashish N" <ashish.n.shah@intel.com>
> Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Thank you.

