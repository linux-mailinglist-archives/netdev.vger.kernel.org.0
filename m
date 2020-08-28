Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF16B255EA0
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgH1QOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:14:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:58072 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgH1QOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:14:38 -0400
IronPort-SDR: q6+vspLw0h148Hd2BoqSdSfDfdMXRgtkTpdtc0eTBb99usx9RcDVtAUOFSvROWqBVH2TqU6VQl
 a1VBal2kihLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="154238786"
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="154238786"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 09:14:27 -0700
IronPort-SDR: 9NMIzER9R72HhnMw8iCKyAzdUMfAIRBiUKYJeMJeF1zLUExA7xtOSZgL6aEohnKMHBBjW9nvKa
 YdRS5tL/5WNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="501072583"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 28 Aug 2020 09:14:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Aug 2020 09:14:03 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Aug 2020 09:14:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX161.amr.corp.intel.com (10.22.240.84) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 28 Aug 2020 09:14:02 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.50) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 28 Aug 2020 09:14:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxz+G2EZxvKtUWTnmvybTquVeIT3fsMmq/HcehNiROLHtChk1BlPVch7bmqQTsnhlYhuAhAvQNMRR0v3hjANcmpaZC43iVneSdHE3hdMUMAXjBDQZDqp63aVvX50AjaSmXSUlXisiZjXXqqwpr+KwBJrGpatcqgVk6G6okNrZdBmsBViyItFJ/MbhFtZg22ZCvtyVrOU9VKhv/T0KNIWh8KyYupSK73gvj3Vr91hJM3ry7qkDLrqUIbumuML5maBVcmKsb2Jqv81YC0oTV6NCgfMOVxqWsBy8PaU1Iu/oAXlfTZ4hAhmT73PfXIrO57nY0C6keHLQ2YzX7p7iU1LIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Icg9rN80Rw+D1JV4QILa6964bLiygum3IlSyxYU3qE=;
 b=Yp0EmDwxlS3WhkWxwSqIgMS00cQq1NaFF68Bv8oTNVa9gcBhJM8Ndstm0ggE2gvdyf72bEl6dF1j7gLPZvg/zOqgaVOvsU8mK63fzISgVgmNikaP94LLgBGTS1+1ov4PLztGWsXciB1RBMG2q4lmzK3J4xLhgV6r0w7A9/cBtBIExGz+rI8Xo2AuNYRfVMQAIy5TKdhuu+xy2Ar+YinirfnPfYhZ0zCjiLe89sJ+3KnBfkcF19n6Lirp8Tv/5+5ZYxvf/Q8tH2qmbWtK9hIHv1cCyzaCv51bb34ux2rDQd5gEGvr81ZDfn4paw0xWHmVSQTLpASvO1VPh3q/1pFVFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Icg9rN80Rw+D1JV4QILa6964bLiygum3IlSyxYU3qE=;
 b=yQMGX8OFV+X60MDypDh3oO7dfSsxR9tMHFQ4jEP5b/ZmJxbgjv+6YtrzbgWTIjMSqPwSQrO1RmNS82wtO3Q27BccFGAPsZdwQ/DXHF1aZDvXpm0b70ukoC2fzuUieMToVSOtB6yXJ7AQl5oageOvM7AQ5CRDx0NhSi41wrG1W58=
Received: from MWHPR11MB2032.namprd11.prod.outlook.com (2603:10b6:300:2b::13)
 by MWHPR11MB0080.namprd11.prod.outlook.com (2603:10b6:301:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Fri, 28 Aug
 2020 16:14:00 +0000
Received: from MWHPR11MB2032.namprd11.prod.outlook.com
 ([fe80::a96d:aa1b:403a:7d11]) by MWHPR11MB2032.namprd11.prod.outlook.com
 ([fe80::a96d:aa1b:403a:7d11%2]) with mapi id 15.20.3326.023; Fri, 28 Aug 2020
 16:14:00 +0000
From:   "Janjua, Weqaar A" <weqaar.a.janjua@intel.com>
To:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf-next]
  0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
Thread-Topic: [PATCH bpf-next]
  0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
Thread-Index: AQHWfU7N5JVVq0Gtik2+5+EvqwZdwalNsT4g
Date:   Fri, 28 Aug 2020 16:14:00 +0000
Message-ID: <MWHPR11MB2032142C1FE0DD228A396AEBA4520@MWHPR11MB2032.namprd11.prod.outlook.com>
References: <20200828152019.42201-1-weqaar.a.janjua@intel.com>
In-Reply-To: <20200828152019.42201-1-weqaar.a.janjua@intel.com>
Accept-Language: en-IE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [80.111.140.23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d846ab2-56af-4762-96d0-08d84b6d6013
x-ms-traffictypediagnostic: MWHPR11MB0080:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00800EB20B00B236B7F8755FA4520@MWHPR11MB0080.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QqC558EN6DZZ54VGU6rv34eVRHFfSiyfxmJNEfTplsCBuHZlqNqbpHo+eat1i6/ER+gD64Nftxhsy0BTHwsgQvCW3YvKUxjIMT5ij1KXtZzVEX7/AspLiPB3AdGZdsssxxrqbIUx2yJefKBZraKw9oBthaHCBRuxStlclu7ug7ENX1YgbR/7rrm7OVq/3X3zZfD/EUgSIjWHweZOAijG7MXKLz2rtvyXxf0efrlYA8qQvZvHELCwuPszPU8/eHgTD6kdgxVUT0hh1IuhSIjNZszkSGZd7iXMllg6Gc2iq9ocppd7Q91sz/RMdk8b1zci3524WFALw/ALayjY+R5g3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB2032.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(186003)(26005)(53546011)(76116006)(6506007)(7696005)(66476007)(5660300002)(66556008)(71200400001)(9686003)(52536014)(2906002)(55016002)(66446008)(64756008)(66946007)(8936002)(316002)(4326008)(8676002)(86362001)(83380400001)(110136005)(478600001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gMt/fwTbdqG7cyPf5WnsSj3woOsrChj2kn7xSOweL2O4Q5hE/Zz+i19ZYUiyEgoRrfuAjhOU1pRUG7+pp6j+yMVERq2wzbB5hCEieVGqOfniEwoGWAdkNxSfw2n4SfiFr+872lUEri2JNlPCH4xp5wsLOiTktiNaeCj2GxkO2jvVDIXF/bmYFW/RIS2mfFT5QaCkUyHjIgvijvKq9OP+X90ioSHCaKh2JQxb6xYw1SVKQSMdy8H7OGXH4Lr0L08Q3g6Jq0Fma6kfWMiMIXve3IsV+CKGWtOnaJff/TF4xUlw1TzD/LkHrvB4JnRhJkHj7td2oJSaEgZtlu2kcr3GO+YAT2vkUbtgLi2t+RxpZxlE7pDALWvAKd/7M+6U4GyAhNGQ+FCWdQxUdnOQrKDlOixt0XHpk/U33JjVaowzh9/FHQPzc1ds7TLB/i6EoKTh1HVo9G5EI28RUn4pLN5MzTT+5Ad7yLHb3TnzfL+Zk4oCn78AJ4sR+syM32uleT2RDKvdyF8bI2y4PRjqkFYKoO4XkqhGB5Nzo2amcGMSH2EWhUz9HBMpZnjjzmbP5eIYkLJC16qOfYDZ0kMuQALwaQGBY0nX6isM8NdWnWKcypu4TtCLiRLuUxjtMzXaul/N1HpTKbsw6zUx9EOH3/uOFw==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB2032.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d846ab2-56af-4762-96d0-08d84b6d6013
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 16:14:00.6281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F9TGnxP54WqfumiwqYu/mRIVrpPgfove6+WJdAj87j9ateIHqdRFa3wxhIWpAM+1h75XdHc8EAgUludg0gYinzZRcPFYCNaPOFwznz5shbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0080
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Janjua, Weqaar A <weqaar.a.janjua@intel.com>
> Sent: Friday, August 28, 2020 4:20 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; ast@kernel.org; daniel@iogearbox.net;
> netdev@vger.kernel.org; jonathan.lemon@gmail.com
> Cc: Janjua, Weqaar A <weqaar.a.janjua@intel.com>; bpf@vger.kernel.org
> Subject: [PATCH bpf-next] 0001-samples-bpf-fix-to-xdpsock-to-avoid-
> recycling-frames.patch
> =

> ---
>  ...to-xdpsock-to-avoid-recycling-frames.patch | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-
> frames.patch
> =

> diff --git a/0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.pa=
tch
> b/0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
> new file mode 100644
> index 000000000000..ae3b99b335e2
> --- /dev/null
> +++ b/0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
> @@ -0,0 +1,62 @@
> +From df0a23a79c9dca96c0059b4d766a613eba57200e Mon Sep 17
> 00:00:00 2001
> +From: Weqaar Janjua <weqaar.a.janjua@intel.com>
> +Date: Fri, 28 Aug 2020 13:36:32 +0100
> +Subject: [PATCH bpf-next] samples/bpf: fix to xdpsock to avoid
> +recycling  frames
> +To: magnus.karlsson@intel.com
> +
> +The txpush program in the xdpsock sample application is supposed to
> +send out all packets in the umem in a round-robin fashion.
> +The problem is that it only cycled through the first BATCH_SIZE worth
> +of packets. Fixed this so that it cycles through all buffers in the
> +umem as intended.
> +
> +Fixes: 248c7f9c0e21 ("samples/bpf: convert xdpsock to use libbpf for
> +AF_XDP access")
> +Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> +---
> + samples/bpf/xdpsock_user.c | 10 +++++-----
> + 1 file changed, 5 insertions(+), 5 deletions(-)
> +
> +diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> +index 19c679456a0e..c821e9867139 100644
> +--- a/samples/bpf/xdpsock_user.c
> ++++ b/samples/bpf/xdpsock_user.c
> +@@ -1004,7 +1004,7 @@ static void rx_drop_all(void)
> + 	}
> + }
> +
> +-static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int
> +batch_size)
> ++static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int
> ++batch_size)
> + {
> + 	u32 idx;
> + 	unsigned int i;
> +@@ -1017,14 +1017,14 @@ static void tx_only(struct xsk_socket_info
> *xsk, u32 frame_nb, int batch_size)
> + 	for (i =3D 0; i < batch_size; i++) {
> + 		struct xdp_desc *tx_desc =3D xsk_ring_prod__tx_desc(&xsk-
> >tx,
> + 								  idx + i);
> +-		tx_desc->addr =3D (frame_nb + i) <<
> XSK_UMEM__DEFAULT_FRAME_SHIFT;
> ++		tx_desc->addr =3D (*frame_nb + i) <<
> XSK_UMEM__DEFAULT_FRAME_SHIFT;
> + 		tx_desc->len =3D PKT_SIZE;
> + 	}
> +
> + 	xsk_ring_prod__submit(&xsk->tx, batch_size);
> + 	xsk->outstanding_tx +=3D batch_size;
> +-	frame_nb +=3D batch_size;
> +-	frame_nb %=3D NUM_FRAMES;
> ++	*frame_nb +=3D batch_size;
> ++	*frame_nb %=3D NUM_FRAMES;
> + 	complete_tx_only(xsk, batch_size);
> + }
> +
> +@@ -1080,7 +1080,7 @@ static void tx_only_all(void)
> + 		}
> +
> + 		for (i =3D 0; i < num_socks; i++)
> +-			tx_only(xsks[i], frame_nb[i], batch_size);
> ++			tx_only(xsks[i], &frame_nb[i], batch_size);
> +
> + 		pkt_cnt +=3D batch_size;
> +
> +--
> +2.20.1
> +
> --
> 2.20.1

[Janjua, Weqaar A] Apologies, please discard this patch, will resubmit.
--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the s=
ole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact =
the
sender and delete all copies.

