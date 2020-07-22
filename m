Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876DE22A10F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732822AbgGVVGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:06:36 -0400
Received: from mail-bn7nam10on2134.outbound.protection.outlook.com ([40.107.92.134]:20544
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726447AbgGVVGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:06:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiAP2x5YbZHUWx6ZWrBqU4AvG8//JoVhQvsr+9CATPcXA/xD8MYzSuTwY/KtqcAtjkVSR59kjrFkjwt4fprTxOJvGByu3AqqrePTpNu9YdLjbY0V27rHvfVrniaFgYF9FxRBFIjCxfa+1pZvZeIvhmzKjiZYJ8jkWdYTLCTADuKfJsfGDvLpT3mKTrhT+ewiHVBhY298VAic7QMG4KsSGupJNR323WOTDdoJT85piPBWjO5JVYPZ6utsJrkB3Gs2QTK8L1hiJE5kCppxamrLs9NMchSIB41N6BLWsIEHIyC0zEnhVKP0ajNlP2iMW4nTG6WQXWExqbGsebiE1ow5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lMasATm9m2GgcBwa5O1jLWooNgMcGvcd3hAK55w77o=;
 b=G57n+8Y4QU91D2tRlQbAWLyBrwyNw1KEJVuNsd9XLrw1V2kixmtYfBzYv46e2NNn6bE02VB+CzFwDwYUzf2I4Yu1BNRU41iXaVMyb3P8g4yva9IZYwdmHxK6rKkwqu28ZVC9vSIb9xYUYkhPF4MYLcrM2eetvnsqQu5MGy1wiNkS2qSEzt/Jj0k8Y5tAfaku2Isc5xzMjpqPrC1l0AFe9ldhNykEq7hvgdS1x69DR8ERXpUVIP5oAf8TArAkzELrspZX8QoJc6B8JML5qxaG5F5C2VUNXUWdJ3Hs5hmz2RVLEa+7oz7AkpHqhg24rIhwBNYl1llAfPjTcWiOnzRNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lMasATm9m2GgcBwa5O1jLWooNgMcGvcd3hAK55w77o=;
 b=IDLw097BtTmUItquERLqz5ee91L+7rIxGqyIhB7KFQ5EFLzwFDB3F3FbHFtMe8w5qeKX33Q7STRfUOuoo16HhFkJ5Td5qfaxtsNoi0yGlC8NdhUaITzd0VlDXozwp349R7RuCMNwlLl5iz/TXfS25+DiYuSvbnZTDCcdXfGlkrk=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1028.namprd21.prod.outlook.com
 (2603:10b6:207:34::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.0; Wed, 22 Jul
 2020 21:06:31 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.007; Wed, 22 Jul 2020
 21:06:31 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Sriram Krishnan <srirakr2@cisco.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     "mbumgard@cisco.com" <mbumgard@cisco.com>,
        "ugm@cisco.com" <ugm@cisco.com>, "nimm@cisco.com" <nimm@cisco.com>,
        "xe-linux-external@cisco.com" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6] hv_netvsc: add support for vlans in AF_PACKET mode
Thread-Topic: [PATCH v6] hv_netvsc: add support for vlans in AF_PACKET mode
Thread-Index: AQHWYD4zMrrU71PALk6zvPLr8Box4qkUFzuw
Date:   Wed, 22 Jul 2020 21:06:30 +0000
Message-ID: <BL0PR2101MB09304ED1D26BD3D61EF62948CA790@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200722153845.79946-1-srirakr2@cisco.com>
In-Reply-To: <20200722153845.79946-1-srirakr2@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-22T21:06:29Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=70356182-baba-4c36-a4df-3b2fdb1f4f5e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6f8f4a3c-f06b-4834-a9e2-08d82e831bd2
x-ms-traffictypediagnostic: BL0PR2101MB1028:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB102885773035FEB0AFBF13C3CA790@BL0PR2101MB1028.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r3hXAJe9gehAMWwnuJOJQIk2M4iDFhg8OfJqBa4xoJVhFOVDZK+lgJtDcyVbIqyGVqROPIrS5zBcz4DwmrOJ71qc4OVKsixDk0WmGrH9ESQCNqkzSH4nipt9j82fy7TH2BZQOdosZx3TjKiK9Od1dKqBJsPKa4EdS3o0FzJACg7626OVIm9s74X42xrlVBEjoJC1tRhYbxeR0zbdCrrKdPz7mmFuYFexGPpEj7iFE/g/S7Q38wNJ8o1jkOZz+GfK+LQIq1rFU6W1ZnBKJgW8du8AdEjbCxYRyfIv81icMBQYF/xcXYcbB8+iJS3HIaNk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(8676002)(5660300002)(83380400001)(6506007)(10290500003)(9686003)(7696005)(2906002)(54906003)(186003)(86362001)(55016002)(478600001)(26005)(53546011)(110136005)(66446008)(64756008)(66556008)(66476007)(316002)(33656002)(66946007)(8936002)(76116006)(4326008)(82950400001)(82960400001)(7416002)(8990500004)(71200400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HNfXYmbjw39hGOYo2qG3mJYA109YXVgcJuaLYfJ7J8/TU2RZKFoSWEqtsDFqT1KXLpY3NaQ3ZxOhO9HtuzGt4TKs67DUmBIxUndTms/2DbRcLu1u9775UupWVt9Qz5SLLtLOerHaqb+Juijnm7X8oykiquMPKa0dtPuuFPCgBXE1NZZnxG7KVZN97YkiqVCWnkkZNJbBrct4jmn26xUdNgDK3U6rKd0T2Gy5nFkxWXvFeNgihtJYJYrZckmVKWnFdMMpqmkXwHgrAhw3cXXfw4+G/xgaQOOOwCwtMVNY/qsa7Q0jhElG1ThWneDWC6l2WuHO0tt93EGlbvX0UuNWpoUAhoep4Mc5S/meiTFGkdXLtctulnMq3yX+w/F2kofKCkuZzTXXm4iTOlGouYrjneaJ4wCbrHaKPD1mj3/jzs0ETx0NMRM4QncsrCCblKuSJM4LVtVWSW6rHGLGPkU6t+5eGiqwQQ7I/jNXaVC311eqsOBjv0yqE/+BJfjAgE87sBVS+wIo750+I4VaUfwVFlYYnYvTfFlV8ur4clSSjxysGgk6MTutmHEEC0fmiUB3dXukw4vHf2DKMEPmX98bvTQlyVKEI/hhSUEOIgBMYPU6oH+uKhvojnkNeYUgiIZay5tqaVUu4FupgE3xX3ZcuQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8f4a3c-f06b-4834-a9e2-08d82e831bd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 21:06:31.3710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XqBBm4ulmsin1qrcZg+qKcaqzQNYWFmwmlGv910DUpjRznCqoxM97999+RdrHDeyPIna95bqhRWdV+wfp7YtRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sriram Krishnan <srirakr2@cisco.com>
> Sent: Wednesday, July 22, 2020 11:39 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>
> Cc: mbumgard@cisco.com; ugm@cisco.com; nimm@cisco.com; xe-linux-
> external@cisco.com; David S. Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; linux-hyperv@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v6] hv_netvsc: add support for vlans in AF_PACKET mode
>=20
> Vlan tagged packets are getting dropped when used with DPDK that uses
> the AF_PACKET interface on a hyperV guest.
>=20
> The packet layer uses the tpacket interface to communicate the vlans
> information to the upper layers. On Rx path, these drivers can read the
> vlan info from the tpacket header but on the Tx path, this information
> is still within the packet frame and requires the paravirtual drivers to
> push this back into the NDIS header which is then used by the host OS to
> form the packet.
>=20
> This transition from the packet frame to NDIS header is currently missing
> hence causing the host OS to drop the all vlan tagged packets sent by
> the drivers that use AF_PACKET (ETH_P_ALL) such as DPDK.
>=20
> Here is an overview of the changes in the vlan header in the packet path:
>=20
> The RX path (userspace handles everything):
>   1. RX VLAN packet is stripped by HOST OS and placed in NDIS header
>   2. Guest Kernel RX hv_netvsc packets and moves VLAN info from NDIS
>      header into kernel SKB
>   3. Kernel shares packets with user space application with PACKET_MMAP.
>      The SKB VLAN info is copied to tpacket layer and indication set
>      TP_STATUS_VLAN_VALID.
>   4. The user space application will re-insert the VLAN info into the fra=
me
>=20
> The TX path:
>   1. The user space application has the VLAN info in the frame.
>   2. Guest kernel gets packets from the application with PACKET_MMAP.
>   3. The kernel later sends the frame to the hv_netvsc driver. The only w=
ay
>      to send VLANs is when the SKB is setup & the VLAN is stripped from t=
he
>      frame.
>   4. TX VLAN is re-inserted by HOST OS based on the NDIS header. If it se=
es
>      a VLAN in the frame the packet is dropped.
>=20
> Cc: xe-linux-external@cisco.com
> Cc: Sriram Krishnan <srirakr2@cisco.com>
> Signed-off-by: Sriram Krishnan <srirakr2@cisco.com>

Thanks you!
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
