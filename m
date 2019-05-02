Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8C111C59
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfEBPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:13:01 -0400
Received: from mail-eopbgr710078.outbound.protection.outlook.com ([40.107.71.78]:54784
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbfEBPNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 11:13:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBSjZC2wxTuWVNV36/ryoUBIhXFbwmAJOS7ExayD94A=;
 b=au183SU2eryBBNioxJxkkhYHaRR3DxUXh69X0sKVn0OFOUVe0OKMxlGjWovjTKFuMfhqXulcAZQPvYroa/cu457l7/fmu6UL7fQupQ6wcXw5iwF48bGFsS3p+RetdAWT08vVE69ZwTdmE1iSFAnTW1wjaH2QG9OY1dX1R6M+VM8=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.26.153) by
 BN7PR02MB4099.namprd02.prod.outlook.com (52.132.223.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Thu, 2 May 2019 15:12:56 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::4155:72d9:c5a:70ef]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::4155:72d9:c5a:70ef%7]) with mapi id 15.20.1856.008; Thu, 2 May 2019
 15:12:55 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: RE: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
Thread-Topic: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
Thread-Index: AQHVANLEhtzBTB57XkuBybCTxm8h4qZXu4sAgAAyTOA=
Date:   Thu, 2 May 2019 15:12:55 +0000
Message-ID: <BN7PR02MB512413C534A8EFA925105441AF340@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
 <20190502120012.GA19008@Red>
In-Reply-To: <20190502120012.GA19008@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [123.201.77.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41c7f480-5f35-4302-928b-08d6cf10a7a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN7PR02MB4099;
x-ms-traffictypediagnostic: BN7PR02MB4099:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN7PR02MB4099B436E6AE1A8A88D6DB57AF340@BN7PR02MB4099.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(396003)(376002)(39860400002)(13464003)(189003)(199004)(68736007)(81166006)(14444005)(6436002)(186003)(476003)(7696005)(81156014)(8676002)(53936002)(107886003)(76116006)(966005)(71190400001)(71200400001)(486006)(316002)(2906002)(14454004)(8936002)(54906003)(55016002)(6916009)(9686003)(74316002)(305945005)(76176011)(11346002)(3846002)(99286004)(73956011)(478600001)(6116002)(52536014)(256004)(229853002)(6306002)(102836004)(26005)(5660300002)(86362001)(25786009)(6506007)(33656002)(4326008)(66556008)(64756008)(66446008)(66476007)(446003)(53546011)(7736002)(66946007)(6246003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB4099;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G/dumqUMbhxOu2A1WpzKE2A9u254WhClmjfJ/iS+lK8W8uWZ1x/UNiANqLHbFbF6wwlJ3vouqkFpjL8LK828JylmOX7hdRtRlqFPJk8GbSjZRhA6sGoxFpAKjN+CQxYgSumfTIOmXv9Cvm5AolGX0BmbhvawReW5O+eqDHS2RlhmDh/IQPjcGiasKyxvv8+wQxefZh5IMio1bmksj/Skv1oe01NbkixgB5umvXHjQ63MQ/rQNesdECT5X8lGSQz1XeZeLgor/li75uYIej4Tzw4LL/0+TR+RinzSSNAMpoOaIIkOKVPsi0Z6g/AZ+W0MdZjLQ9w2NgVOoBIh77/N6n39rGw5pJlyXUVa/PEgL0kGQvL0QVd5tYuDX0tEvwMEONfq8vtI/ORf1Wd4dNf7Yba9oUhD7/z5t+9RkWAAS5U=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c7f480-5f35-4302-928b-08d6cf10a7a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 15:12:55.5740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Corentin,

Please find my response inline.

> -----Original Message-----
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> Sent: Thursday, May 2, 2019 5:30 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: herbert@gondor.apana.org.au; kstewart@linuxfoundation.org;
> gregkh@linuxfoundation.org; tglx@linutronix.de; pombredanne@nexb.com;
> linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; Sarat Chand Savitala <saratcha@xilinx.com>; Kalya=
ni
> Akula <kalyania@xilinx.com>
> Subject: Re: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
>=20
> On Thu, May 02, 2019 at 04:04:38PM +0530, Kalyani Akula wrote:
> > This patch set adds support for
> > - dt-binding docs for Xilinx ZynqMP SHA3 driver
> > - Adds communication layer support for sha_hash in zynqmp.c
> > - Adds Xilinx ZynqMP driver for SHA3 Algorithm
> > - Adds device tree node for ZynqMP SHA3 driver
> >
> > V3 Changes :
> > - Removed zynqmp_sha_import and export APIs.The reason as follows The
> > user space code does an accept on an already accepted FD when we
> > create AF_ALG socket and call accept on it, it calls af_alg_accept and
> > not hash_accept.
> > import and export APIs are called from hash_accept.
> > The flow is as below
> > accept--> af_alg_accept-->hash_accept_parent-->hash_accept_parent_noke
> > accept--> y
> > for hash salg_type.
> > - Resolved comments from
> >         https://patchwork.kernel.org/patch/10753719/
> >
>=20
>=20
> Your driver still doesnt handle the case where two hash are done in paral=
lel.
>=20

Our Firmware uses IPI protocol to send this SHA3 requests to SHA3 HW engine=
, which doesn't support parallel processing of 2 hash requests.
The flow is=20
SHA3 request from App -> SHA3 driver-> ZynqMp driver-> Firmware (which does=
n't support parallel processing of 2 requests) -> SHA3 HW Engine


> Furthermore, you miss the export/import functions.
>=20

When user space code does an accept on an already accepted FD as below
sockfd =3D socket(AF_ALG, SOCK_SEQPACKET, 0);
bind(sockfd, (struct sockaddr *)&sa, sizeof(sa));
fd =3D accept(sockfd, NULL, 0);

where my sockaddr is=20
struct sockaddr_alg sa =3D {
        .salg_family =3D AF_ALG,
        .salg_type =3D "hash",
        .salg_name =3D "xilinx-sha3-384"
 };

Upon calling accept the flow in the kernel is as mentioned
accept--> af_alg_accept-->hash_accept_parent-->hash_accept_parent_nokey
for hash salg_type.

And where import and export functions are called from hash_accept. hence, t=
hese functions never be called from the application.
So, I removed those from the driver.

Regards
Kalyani.

> Regards
