Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3621330FDF
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCHNqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:46:55 -0500
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:36531
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229797AbhCHNqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 08:46:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDqfnJMIk/uA6pt4eiB/SWfSqyPMEofosDQsQZHHpQCBsCTiwO00BC02910wdcxlvPnleTOnt4ajVSa/4c8zazz+1By+AiXmG9vublAn4ZNV45Yqu2SZsO4J196EbOpmAHoFISOK97o7BnKXl/RB1wOEMLeflHMFIbmn7KtbIwtsjJQnSKfys3Z4S8eEbhZ+bU1gUg/WxkHP+yAu/kFbWg7Da47LaukIVHyOTd16BNgQqo5jPylzUzRiM5d8ooY1oMMI9+6URF8MShbtYGJLivWx8fCny0RTEcIfeg4GOYajyfwJRI6/HlK1ay9IEcLoC0E0v+bMB3Yyzctjck/fpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTIy26PPiGnrUqWP3/mdSj8EduuekmfJdqxaspVFVC4=;
 b=ZXLs3vqh/y5ihNpTVA2TP+tq+57AglVb1XpNmFWQdaBHCQxqSS31XzY8+19FjVK3OHwadJFznodRm8t9EBSYnh/G5OVu7kBeKsEE5BisrqaEDI9WVvhnbQMOmU0Y7+JHBx06i9Enk3JigkDmD/HRst77aZ5/XdehTwiDbYOJTiCnV3jhgz1VLNMOvQQrpUJnsuGFqH24+zMaKeGTBopZcgD862wVAPPTrKJEwHOvAavc9rzKrQvIy8eRIVXeAKizxQ7Thw5uozGT66v+3PM8hsNRQwFeO/qfwiCsafSQqQcXouMZTA7gDW7ANSHzYnzKA41VXF9uZMen6TUaA4Xf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTIy26PPiGnrUqWP3/mdSj8EduuekmfJdqxaspVFVC4=;
 b=WsBhlMK/IBW3NqjzKl7byKDFgE6dnc8mpZaBRZ7BdyFaeIJX/6T4bA+Q6thaZHeJ8At/aAypmnHam9pTepiXannXKISikasQJRr0zPn5kflzcrpYlg57BzGqK/YcIjewctEM+XiYkI7EfdNgmzgyMAh2S8hE/gPfRuUVf2kV04Y=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6461.eurprd04.prod.outlook.com (2603:10a6:803:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Mon, 8 Mar
 2021 13:46:36 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1c19:2fd2:7521:31d5]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1c19:2fd2:7521:31d5%7]) with mapi id 15.20.3890.038; Mon, 8 Mar 2021
 13:46:36 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "freysteinn.alfredsson@kau.se" <freysteinn.alfredsson@kau.se>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Thread-Topic: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Thread-Index: AQHXFAtVM8VykLFZCkC3002s1VwvZap6GZ0g
Date:   Mon, 8 Mar 2021 13:46:36 +0000
Message-ID: <VI1PR04MB5807A0AA3FF233F4ED1042AFF2939@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
In-Reply-To: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 714325ec-2eab-46e0-a5f4-08d8e23897f1
x-ms-traffictypediagnostic: VE1PR04MB6461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64616D2515BC78E8888B9230F2939@VE1PR04MB6461.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZNG6QVpqt8KKn+kuuAZugLwTJQOhf2NN+pCin5BiD5gTqDgnCJePGiwBvXSiTQR4RMmSIpsxV1PAH19Qcqw50/OYdaymJRxwwpfnuBb7c09HyIo3MoZV+cbnUuTaiqYts/qCq31P7VryALsT0+3EWOLvcrInIiAJhKo69A3SbWhvkjXegot3mQ209U+5mCQADmw7FClbMsqtkPlFkdyN0oXOA41I0bfdCVb90fqpw8QCjcl9qUDpK7UgCFaOwHjn9xi/ZzQ63DdV9Z0G9f2XUNUbse6eBxRP8dWrXP+Fp1KKz3xSnQdVGCcX47u1WyH/Uh0lhVh0eHmLKGPGKLY8A+JN1FOi5pBYvYDWhkzUuThdZ432bnl5fbyhTDr5gJVZ0cjchh0ILnHHLeghrddLk2lCs0ru6WAH62IdKsbfO/tN7qTZ27CgrQhFeC1fhq+MLAfD3X1JFHWkpRcPPDz5kATFUgwNYhp/vlMgL7CQoTbMyaxonXVRcryNA9H6Af6p5w005FmvMtTZxbR0C+8/sA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(55016002)(110136005)(52536014)(86362001)(4326008)(5660300002)(7416002)(33656002)(53546011)(186003)(26005)(7696005)(8936002)(76116006)(6506007)(478600001)(54906003)(64756008)(66476007)(8676002)(83380400001)(71200400001)(66946007)(316002)(66446008)(2906002)(9686003)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?h7vhe16cQ5GV0fM6nPsTPy1OGKDeWCjChPTKPy+PfJj2Ynqac9m4qrXXv41K?=
 =?us-ascii?Q?GuZYl32FNg2tuM72OyfXoM94MDWQnPr69QqiWW1ACj2D/NtW8GglxcIuwxZb?=
 =?us-ascii?Q?/azYTsiogYBL6AqcG9wJ+YfWbDjTCd41VY2s+Dj8qitXEODEH7WJWci7PAZV?=
 =?us-ascii?Q?qGARWTthnEto6A2QcqyWn2C1eg+iAUG3OUxkocZM7LkwoqzVyozPlCsN3i3H?=
 =?us-ascii?Q?R4/u++dl+MN+lDsve0p1eSN6bELdiHnHxIm8Lyx7bfUzMKo9er+z1p9jFmMN?=
 =?us-ascii?Q?BDM7h99W8d7IWsjADQqGq90TKi7AOabNV/kvzGsAj6yd8BFbCqkyeHD2qWEP?=
 =?us-ascii?Q?SIKG374wQsEPYTQzi0TnG+KJJUUG40tA/8S77HlGANjRkHsPW9CYsxC/AVRW?=
 =?us-ascii?Q?n7CFeZLy4icEibLwK7+YsInncTh8sEcLV2Fur0UiiebF77wCJ/N3OtTg1IeX?=
 =?us-ascii?Q?qy3xemGVrbLQMF7VhWPBnZl8F4Mwzcr/pCQXVJWurGAHqiDQVw+Ku51V1z1g?=
 =?us-ascii?Q?Bn8ndcI5/mQyokXoNe67gTI5zCdQmrgckwEDCk/uHJPYIPAbLVFFrWuxfvPg?=
 =?us-ascii?Q?UgjcB9sVr8nDInPb4JTcIjrridJ+Cgbblt1fbYVhkk4VfpoIGLDFYIpUA0nY?=
 =?us-ascii?Q?AmpDOzfiVbDzAHSjLkJce51l3BiCH4mWXnYbDKIQtq1L2/HvWRAmnJh4KhXF?=
 =?us-ascii?Q?aPry+yN5z+aIHPLJa5zZHK3JEsRKSnxJpwhq1lX/7/uF0p0/ZaSZtvqEp+IP?=
 =?us-ascii?Q?8QflVYQ+4MLT+KyuZB/SDFhPmzoMBJhEPG3//tvY481dZrHzmE1t6D6kRdcQ?=
 =?us-ascii?Q?Ecy4BBD4G5xekjJKZyYgKTxp4RzOgVurlcOs4prhAyEWFZSG+JkLRETzdHHO?=
 =?us-ascii?Q?KEdu0p1nexoKDEqiqTa+QLIQdJxp/rUVBUDFLmB0pZ80NjxviL5qTzeMA5wK?=
 =?us-ascii?Q?l/XdgUrG1hQn4oDeLvVhFeVRPMZhzR/7bN1TXIP9cshGkWKbDtNk2MqnTnLh?=
 =?us-ascii?Q?HF5FPt/IP+jd9ir3/BRvG/jZ3dy7dz+watqFjcBIhdVnVEivlYPvkwOPWkAo?=
 =?us-ascii?Q?fzPKdQ4/tu5HX++xKIZ3gjCvtR1Lx/yzyr0dShMMLfOLuL0LAYQYyvxCiWub?=
 =?us-ascii?Q?VBiARdF+6bjtpalnJ115AZOEdqEq8P8ChPpn4x/kEFjEvajeLLysj6pK9aW2?=
 =?us-ascii?Q?IspiE8RDSGCk+FcO0gWzO9ekbrhvA466sO6at7MSGEcwAOjVCTdOY3VDIFfd?=
 =?us-ascii?Q?/EaktFijImU4ppsg4MnGsgFzHa6zPlvQmWbWKmFK7ESL9Q7C4kUTSNI9K0rl?=
 =?us-ascii?Q?SBU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714325ec-2eab-46e0-a5f4-08d8e23897f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2021 13:46:36.6298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CVLcEepE3aWZyogEfmPCR92ofF3xqVphUf6CHMRez+BmRF+WNvKmFHIHCKluzm6Ef24oYa1XGFVjAlc+ILkGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> Sent: Monday, March 8, 2021 13:07
> To: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> ast@kernel.org; daniel@iogearbox.net; brouer@redhat.com;
> toke@redhat.com; freysteinn.alfredsson@kau.se;
> lorenzo.bianconi@redhat.com; john.fastabend@gmail.com;
> jasowang@redhat.com; mst@redhat.com; thomas.petazzoni@bootlin.com;
> mw@semihalf.com; linux@armlinux.org.uk; ilias.apalodimas@linaro.org;
> netanel@amazon.com; akiyano@amazon.com;
> michael.chan@broadcom.com; Madalin Bucur <madalin.bucur@nxp.com>;
> Ioana Ciornei <ioana.ciornei@nxp.com>; jesse.brandeburg@intel.com;
> anthony.l.nguyen@intel.com; saeedm@nvidia.com;
> grygorii.strashko@ti.com; ecree.xilinx@gmail.com;
> maciej.fijalkowski@intel.com
> Subject: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap
> for XDP_REDIRECT
>=20
> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped
> frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
>=20
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

For the dpaa driver:
Reviewed-by: Camelia Groza <camelia.groza@nxp.com>

