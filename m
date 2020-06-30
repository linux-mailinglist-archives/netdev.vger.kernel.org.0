Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8123120FB76
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390663AbgF3SNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:13:36 -0400
Received: from mail-dm6nam11on2127.outbound.protection.outlook.com ([40.107.223.127]:54208
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbgF3SNf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 14:13:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEXFDrjVviZeSoEAcP7mGFTW+WRFKLtd3yBfPatr/qQGYCfhwZN5PBK7THi9RNvv8izSZyrPa9pooQjIQ7aaUCz7vspSX2zVJ9i0y24EvB0rhRG3AR0o41cRnDtQjwjtKzSmTfzYnVNjHBmhVqw/P/l5P2EkkW149Z7z7TucfxI/5DRI+xshzGFV/r7iReqcHtRmw/PNY73fzKP52ohaFkvlrAFkYpZHrtHqqkhDvhyXt3Y18yFhhR1yiaaE+ST7XrKl7F/Fp75iyTMsqexl1qJqwkwYCr/OWtewO2DXNhH13GirIAtvOBjK07CY8JrS+YYwbcE887bZZSB1u5DfCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ci+eMdOPSubnsTlUv4P8HpKDkQzSkexc1lODC7isFJ8=;
 b=DSAMRU6ysSJmIJzec6BCS5wYrPycd/kxe3kZsBmmRKW4G3kIp/ia9U1Xuf8XsfFMYRt7G0meCewljRExH/jjDXoyY8/yvZT+tLt+rc+67WxONYGaboVkTx5pyB/NbBW/r0D9PZZ4GV7LlGk9I4GM7N4+c+B+HNdh6iFPXVWUkWBuFNS+BWPpoLdUQuo2WE4PH9zk29ddg5JhNUPW8yEe3FSe3Pkkd4BnT7t0t0s9eCK9THMsqjxqOdlI+Dccl7IOwxKlPKN5fHq1AfTO9CMqT01yZlDAMKXB6RkxzwCc6ZDg2JeGAGdlVhLH5pRyn2kTBhQ/wVq0ODSs63eOSFASBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ci+eMdOPSubnsTlUv4P8HpKDkQzSkexc1lODC7isFJ8=;
 b=V/xCwuh46c+3vtzt1yeAQ5FYX5wzpdp2b0/LrsnjeV0oTmOF977aNw9dDDXMOKZUovlDR5Z1IU7LwjIJ535yyIbCw61x13apeS7B/jMMV8iheeJzPepMvFhKmiYUQ3ZYIhpCSCMQZLboM2lQICPIKeLagBvqzMl5JgM2t1SUrkw=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1850.namprd21.prod.outlook.com (2603:10b6:302:3::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.2; Tue, 30 Jun
 2020 18:13:31 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3174.001; Tue, 30 Jun 2020
 18:13:31 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Andres Beltran <lkmlabelt@gmail.com>
CC:     Andres Beltran <t-mabelt@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH v3 0/3] Drivers: hv: vmbus: vmbus_requestor data structure
 for VMBus hardening
Thread-Topic: [PATCH v3 0/3] Drivers: hv: vmbus: vmbus_requestor data
 structure for VMBus hardening
Thread-Index: AQHWTvOf4ttKaLwwGECv5rK/oufMBqjxZnGAgAAPS4A=
Date:   Tue, 30 Jun 2020 18:13:31 +0000
Message-ID: <MW2PR2101MB1052E024460AE69A546183B2D76F0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200630153200.1537105-1-lkmlabelt@gmail.com>
 <20200630101621.0f4d9dba@hermes.lan>
In-Reply-To: <20200630101621.0f4d9dba@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-06-30T18:13:30Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1962cb0b-609d-47c4-83e0-cfb0c0e4623c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 41f87a0c-fa8a-4053-0428-08d81d214beb
x-ms-traffictypediagnostic: MW2PR2101MB1850:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB18509E4BE6E7A368A700C5C1D76F0@MW2PR2101MB1850.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SO1NAwTq02ut+DZhAxqO2xbFIpc2ITQptowoi8BMjzdQy790GwDmb95c0zRrV6PYIBxwpgMY2DXTrnVeuRKRx4Zet9KBUSryWVTMP8XPCwQkrtHCMByR5d0XczM0lJLooKi3kYX/ssyH3ZTDxnD2Zy2v7zX36neDPmjIjEV91fXF/mFEJeEOI+EaBOaXNTLABBu4Mz1lAA5vcuR5j8GDi3AtYkdRIQRLPhSlKtoNdx2oXzGs30ZXKs9RCt+hLa5dlDVwYaCxU8+cmHnshh7osvACUilQFWfANRiPyXdjplIiNyDb6502YtwpesZUS82ESs24LU/1rxh03EpJM2uf5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(10290500003)(316002)(33656002)(54906003)(83380400001)(110136005)(86362001)(26005)(478600001)(71200400001)(82950400001)(82960400001)(6506007)(52536014)(2906002)(66946007)(55016002)(7696005)(8676002)(9686003)(8936002)(76116006)(186003)(66476007)(8990500004)(4326008)(7416002)(5660300002)(64756008)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KV8VeQuvq1LtOEo/fcLIq1XrDgtJpnevzjQywIoGWznbxdy/rR3Za8DEhdEh4pc2vy6j/IHWs/kJHklzeW8cIew5wDtXbLXXFE+x/R6QATCyf8oTJRalbfdODFypx+Z4hJve/NeeXhycLx+tpwE6VuYDyhIMKb0DnBGcJXOLIHJbMbzX+sFf0kKpWXZWOp+4Ycf90bnCEC28ffeh2o6X0oFtGQy6ssy/BtNLhVWeXFRCQPNoJ/FQhFJKN6TcnAf4qcM7WSQfebxH/Q11j0Rqpj3Bu488owalrCmPgv+eCkxEMJtgupgiX6fEyfPN5smJqLoQfy9LOUEy5Cdm21k0rw0VoBBHl+s4HIfKlxc+L1GVxKhaOLYrU/9jHrPzvvf4CSIHszbLoSwWDLIfcse3RjCaYK59DyM9b5a54724ibSP6+LUi/6Byp3UNGvT8Z1nmdJRowQcgxuXICve9985L51+nkz9YWJBKDyJc8/2MB76HKDotFfmG4USsbp5Od81
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f87a0c-fa8a-4053-0428-08d81d214beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 18:13:31.6315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 40K+/kjZoyTmEVRCRbfh/laAQ2kBfp8jJ8+u43YRU6gRo6kx0qEqo4Nh/Ai67D5okJMOgmkXEk4gAi70sWbUCFapWSXMG7f1V6U4bYPgKIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1850
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>  Sent: Tuesday, June 3=
0, 2020 10:16 AM
>=20
> On Tue, 30 Jun 2020 11:31:57 -0400
> Andres Beltran <lkmlabelt@gmail.com> wrote:
>=20
> > Currently, VMbus drivers use pointers into guest memory as request IDs
> > for interactions with Hyper-V. To be more robust in the face of errors
> > or malicious behavior from a compromised Hyper-V, avoid exposing
> > guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
> > bad request ID that is then treated as the address of a guest data
> > structure with no validation. Instead, encapsulate these memory
> > addresses and provide small integers as request IDs.
> >
> > The first patch creates the definitions for the data structure, provide=
s
> > helper methods to generate new IDs and retrieve data, and
> > allocates/frees the memory needed for vmbus_requestor.
> >
> > The second and third patches make use of vmbus_requestor to send reques=
t
> > IDs to Hyper-V in storvsc and netvsc respectively.
> >
> > Thanks.
> > Andres Beltran
> >
> > Tested-by: Andrea Parri <parri.andrea@gmail.com>
> >
> > Cc: linux-scsi@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: David S. Miller <davem@davemloft.net>
> >
> > Andres Beltran (3):
> >   Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
> >     hardening
> >   scsi: storvsc: Use vmbus_requestor to generate transaction IDs for
> >     VMBus hardening
> >   hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus
> >     hardening
> >
> >  drivers/hv/channel.c              | 154 ++++++++++++++++++++++++++++++
> >  drivers/net/hyperv/hyperv_net.h   |  13 +++
> >  drivers/net/hyperv/netvsc.c       |  79 ++++++++++++---
> >  drivers/net/hyperv/rndis_filter.c |   1 +
> >  drivers/scsi/storvsc_drv.c        |  85 ++++++++++++++---
> >  include/linux/hyperv.h            |  22 +++++
> >  6 files changed, 329 insertions(+), 25 deletions(-)
> >
>=20
> How does this interact with use of the vmbus in usermode by DPDK through
> hv_uio_generic?
> Will it still work?

This new mechanism for generating requestIDs to pass to Hyper-V is
available for VMbus drivers to use, but drivers that have not been updated
to use it are unaffected.  So hv_uio_generic will work as it always has.

Michael

