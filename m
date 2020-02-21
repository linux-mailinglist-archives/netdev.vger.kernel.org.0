Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8868167669
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387515AbgBUIdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:33:40 -0500
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:58944
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732190AbgBUIdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 03:33:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsfHkWq5mS93R1KBKL7cvMLaw4G84zl5lmT/RKCauhyTFploOUPhtGlmgC1BqZ+/wzKF1Tp+Kt/8s+BNnfqfvuXt0tGuPOHu/yu+69MtiG57Ud/f8bVEUr4QP1lfufARVyciQgFEfFutCXXaUENkQR01tWMgAOmdqaalIeIHpMXcbMA4HlYw6FlMfo2fQh/6BrbgJBwKQtD45YuWzInKGeq2Wf9QgzvFGfWiEuBncfRrkpXrFOVESp25gjscVQoimkKCl4CgdakHD5V0c0U1N/XezUFA4jmcsi1Wrhk1lk3ijm7fOQqteGy2mq9ZaJldwEsxQuCzfYrae+5VD3dXuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9c9BfSUueBxLzB7X8rszAGxPEVjr5ZoEMXt+TsFFXI=;
 b=C67kIxaWWyD4LynpYLZWEACJ2LyvvooHxlNTN4D9+kXt9/EEozIomu5bOdcSNWMbqxRymCgEZRLn5FeJHLq25eLo0aigWLQLcKfnbxqjQ3GjB8X3vjoMlv3lfM7s5jwjQXxmLfI3pEo0Fm1sUA8B9e6Pf2Alocewj6YybCw9pY3QLJK76H6WOHE+qQbR1nYP0jSWU1WCkEJ8Y70UG+XtITK0r0FdOm0ZxlHiCiSIL+Tm28htNjtBR/5k5JeJRUOxzoYAbChhPmm7OOtFU+IHchZnENQVuJB3tRCFYFo7tXcbncMLp+tGBUDTEwSnvIbfdfrh1OjYNo1XTO2Q+kfx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9c9BfSUueBxLzB7X8rszAGxPEVjr5ZoEMXt+TsFFXI=;
 b=pdQrJaWzXkA2owp2WSJQVndH7TUvWvubn4+jIOxS8t0kRcObjU6Ptd4BGEYEa9DenVRossxR0Zh6pzDyKKcQtkCbDzYfRqjldC5+8NVuBtwBf09OF2podQxRtDnCV7uGZUAOeSmQw6UEU4RReWaMKKslvJmZ1I/LEXN5S0veFYc=
Received: from BY5PR02MB6371.namprd02.prod.outlook.com (2603:10b6:a03:1fd::30)
 by BY5PR02MB7042.namprd02.prod.outlook.com (2603:10b6:a03:23b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18; Fri, 21 Feb
 2020 08:33:37 +0000
Received: from BY5PR02MB6371.namprd02.prod.outlook.com
 ([fe80::a9b0:3f4f:bc1b:6af9]) by BY5PR02MB6371.namprd02.prod.outlook.com
 ([fe80::a9b0:3f4f:bc1b:6af9%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 08:33:36 +0000
From:   Harpreet Singh Anand <hanand@xilinx.com>
To:     Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: RE: [PATCH V4 5/5] vdpasim: vDPA device simulator
Thread-Topic: [PATCH V4 5/5] vdpasim: vDPA device simulator
Thread-Index: AQHV57Tnjl2/vAGwKU24MSzCkROB/aglAeaQ
Date:   Fri, 21 Feb 2020 08:33:36 +0000
Message-ID: <BY5PR02MB637195ECE0879F5F7CB72CE3BB120@BY5PR02MB6371.namprd02.prod.outlook.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-6-jasowang@redhat.com>
In-Reply-To: <20200220061141.29390-6-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hanand@xilinx.com; 
x-originating-ip: [182.71.24.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c81cb41f-726a-458e-0702-08d7b6a8bedf
x-ms-traffictypediagnostic: BY5PR02MB7042:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <BY5PR02MB70425FE097B24175F4B20D15BB120@BY5PR02MB7042.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(396003)(376002)(346002)(366004)(189003)(199004)(33656002)(86362001)(9686003)(2906002)(81166006)(55016002)(7696005)(81156014)(52536014)(558084003)(8676002)(7416002)(4326008)(8936002)(6506007)(54906003)(26005)(186003)(71200400001)(110136005)(478600001)(316002)(66946007)(66556008)(66446008)(5660300002)(76116006)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB7042;H:BY5PR02MB6371.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Drd68hkeu2HsFOjSiBEPSU7470yMpC/hL6ILsjyoQCcQu7yiyscQfcNiLYvZljzNgCnrVs9Qtv86BXXQ6DCIaGTkz7X4X4lDHix8Bt4OGzr7wtceSfG6gkzF1/hR5H0j+42vdTjqi0K3NvVs6swA7StZ/Dkb9FIpWtS9+1+EkqNzgjakrntalNGym1ditiv4JwG7mit8O7qed0lxgiX1jO4aAYK23NXD5XvIU5huWuaFtXv4hGRAS6vRIuGmdRe1MuS9AA6nIYQ6ozA32XqYrUrIRYowxwjbFw51pXQ9GZO4TTMb5kpxGupJ0YZOq0VVVrgM8F157Pu85a3xESzolHCWuofXECamuy4NwbV2E5niFtJy0LKJz1pyHVub7osANnoNpWDoNgRXqkgjDgrs95OB6JoelscW/WMQVyDBxiuDt0ArfGRPJNjYCA06QKu6
x-ms-exchange-antispam-messagedata: 4Kf2hXqIGZbPucgKdQCVm9KdSE3gc809TfemxDiza9geF0fVEgGmh+SF4uWOKLHSBNUqWQvceh0hDyPs6XDc81bQFoVNleFE/bvqVU8wEPGbVtMwmL5t0YIKtokrWAtapsJSL01Jjb4F7XWXNZihpg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c81cb41f-726a-458e-0702-08d7b6a8bedf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 08:33:36.7373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Qnuyg7uZBgWAX0NmO958nircwn9gid6gteoJowuzUiecre5HzcDWF64IjxaUo/7NBRbRO3kvl2mEYGKs66jPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB7042
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+       ret =3D device_register(&vdpasim->dev);
+       if (ret)
+               goto err_init;
+
+       vdpasim->vdpa =3D vdpa_alloc_device(dev, dev, &vdpasim_net_config_o=
ps);
+       if (ret)
+               goto err_vdpa;

[HSA] Incorrect checking of the return value of vdpa_alloc_device.



