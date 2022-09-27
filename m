Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13105EC4A1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiI0NiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiI0Nhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:37:54 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C2CD4DF2;
        Tue, 27 Sep 2022 06:37:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/eIUFj8hOZ5RcU8A3VR8QMMCPA0zfSW9a18H+MElu0m/l/Kf4YGSddd6V4ZQ447oReeafUjjLGpadFDZ4yCaLA1qNV2lCAfSGC6Dww+wiAwM+SrOFA48zQ/R6opYqOkv6nhJxsVmmiBd9I2tuZO7ZIpup/x9GWXXiL6hXFDaqzYew5F5OuKRSGg82lJIrw32LpT0r8+uYnaBWLby5VqFSrRvtu1a1/e9UJ1MP19zXXDOWdF3jmEbFDeSKBu6i19VkM3zWFhFsfG5hSaZTyRZux844e2dqHFYz+9YBTX+ls00g8cI4LRdrLKmRBQs/IBUGCXBJ0vnis2ZzAM8YMAeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TsJWldHdNdrFnJ9bojVXTtEEgKiUBTubyYLnHi5S248=;
 b=RIyiSrdNwbPNytyODZOA6xoMl5gC0RJBfwKDr9gEkM1mP3a3gFMEmCs+6EfPB7GLj9KItvWupe8p5CMaPPvrrsA/MWq4E1bffA0axCzM1OlBpCcHw5YglmBj4AXkV/vxNTS+ZiQ7L7ET7ZXtlDj4ox2nX87LB0mUUXt59I58j5vsRcD24f/7LZ5UcWBrliJsOB4hzxEMAd+CjK+hsX42ICW1MaCZT1FUJ9BdRxPsaFOHChLwYLuZW6kW97TCeG90daMJUC+fJQE6l9z28PORr2s6P9ZdEmKH9AEkVGT6E5mAXFgo8yBjWf6Yy8H1ejiQWc5a9T7TGwfKybN8TsM8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsJWldHdNdrFnJ9bojVXTtEEgKiUBTubyYLnHi5S248=;
 b=aevNQVmTupvTNm9YwfHIZQYL3er+4Q+FnJS1VJOM7+s2m167JBZDe1H8xIVimUUO7P6ozexMt8USV3UiR3HygxF7my99055FDutcZ3Ng6hDhV1hdoEXvT+HWRDAFyyRvQ/qVNGHiXJLrp7RHY7VQYxebdR4nD1mW7WdJ9MwfCe4=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM9PR04MB7681.eurprd04.prod.outlook.com (2603:10a6:20b:286::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 13:37:47 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 13:37:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Subject: Re: [PATCH net-next v2 03/12] net: dpaa2-eth: add support for
 multiple buffer pools per DPNI
Thread-Topic: [PATCH net-next v2 03/12] net: dpaa2-eth: add support for
 multiple buffer pools per DPNI
Thread-Index: AQHYz2OtgwM9RaFMIEa0o/WkIcZNvq3zP92AgAAOAwA=
Date:   Tue, 27 Sep 2022 13:37:46 +0000
Message-ID: <20220927133746.ox2qsfjtsiiekvpv@NXL49225.wbi.nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
 <20220923154556.721511-4-ioana.ciornei@nxp.com>
 <83c9e18e27084a3458f1e4c928eb6fe603e37e0e.camel@redhat.com>
In-Reply-To: <83c9e18e27084a3458f1e4c928eb6fe603e37e0e.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR04MB9055:EE_|AM9PR04MB7681:EE_
x-ms-office365-filtering-correlation-id: ba706c73-50bc-474b-3e2b-08daa08d76ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOOJfOlaktC1eYVJlz8QcAqpXx0lTQZ50JVuaVhflJ84SnNq2YZ8Ha7xuFkOKABxQ9czC8LS43u8REOsqFv52X8X4n/4TOHhx31aVunmePEvUYu326x+CCpwIC6Fdrpm8a48khuA6BM2DjrBAFKMCdfmI3Z4OSBAW84BixdI0+QCtKxF7qaWP0MvtFLFEdHG82czKwY9I+rPOS777eBDD824N8mJnxD4tuYtfQUc3k0ZoXjEGv4kXnJauFakV2UUIKStgjhy14ITLifP+tYSfLZs+CsBsmgr26B93qc04zIHD0J+o3COLgjkuvIWpKsXXA6PdfUGCvNi27XBVhvRO7ohKfqGO7IbH/pXswcsgYmQRGesefK8E/Woil4Js4WN9K10odB9OIeLGNkcKjM+MErnSwaNUac8z2mY1SpNFrmpxPCxBT3DgYk2JOHN8S9hvZvPmXf12yjMYxTf2X5CJXKBf+6MKOqzmGmFzRdg/scM0CwUJfC4orN1SdnvEOsoU4VNL7i6cng4DjQs+zVm6ALOqw0eXtRqY1CAt4iZ5OFP7L6HoMdxDKp1toByMwoVR3zJtCo4N3C8eFll5h8G3XKvmdPkASDiQSwbX7j+nPMyuJ2wtUfGn66aYi7gr2qMIRBKMG7Fkzb/NcBW56YXF5pjFjosGg2XTrxNFPJdo9fzUrLMguhiktvd1VcCUmYj1x9hEnqW+NUFdgA55u+b3OLYv04hHBrTBgr0AUe3TXZZLTinTAy6V//GNoF6LdBB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(54906003)(6916009)(316002)(38070700005)(7416002)(8936002)(5660300002)(44832011)(86362001)(66556008)(66476007)(64756008)(4326008)(66946007)(8676002)(76116006)(91956017)(41300700001)(2906002)(6512007)(26005)(71200400001)(186003)(478600001)(6506007)(6486002)(38100700002)(122000001)(1076003)(83380400001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Pr7/Yhtv8AVuDCjHvBOlUnkBPZyW/8o76aGdU91SNI3yQCrZcnQZpCtLrYU?=
 =?us-ascii?Q?IPbSfgEgIoXdzoZvTm41OZZPKjsn/x3VoxRst0spcCn0Yj4FLIGqt8X7PVB3?=
 =?us-ascii?Q?hptfxc9Xwy5mp1gI7UypwF2p3ITPnB5FSspTO6lrbpFJCc5i9Vza37JHCmUF?=
 =?us-ascii?Q?Idht9CNpH1OBvZ5h6qFAQlNrFL5lLezv4OsMp8kFJ9uEJbBvGcFBakmabVmV?=
 =?us-ascii?Q?+Gkf/UO9o0ROLICO3R1IbjtrJPxmj/zs+37ZiCVt9JQohlnNsi7T3VkQDp2P?=
 =?us-ascii?Q?fjpR9EZKHqS+wFOzeQGt0cdUqKGwZzt6FBQEFaZ3w8Cwc4xCAl1sUW02cxKm?=
 =?us-ascii?Q?esY7R4VBwMNBnGlTNMk6TC7xEQMNyUrr+outg8EOOYHt3Yf9YbfL2mkyjHeB?=
 =?us-ascii?Q?OKF/3Ii16LFUQHIybqmAhkeZe6TPgIhSgAUW2bzLQAi08BpADtT8WrBiVNjn?=
 =?us-ascii?Q?NJSxx8cDWfY1TXmtXBzYxEgYDdicGoqGYMIkdRPJU2esk6CVqRKsBl5oXSAI?=
 =?us-ascii?Q?q5DzpOiJ8aadrA+92pOuRaOqszeCNsPFLSKcwqjCJaFc8X2PaJjPobzjRbzi?=
 =?us-ascii?Q?zZSRLnTuYCex8/gE9/UtMcGIgIXYZZPAm9A1VnfihxpZO/YtEYPdXJ/gykTX?=
 =?us-ascii?Q?O5JzFPICiQ7nBh/hQuFg4N8i8oPtQjG5m2xFWaF9ZPvVSvRoKxYRY1YAfWVJ?=
 =?us-ascii?Q?Rxj8iHFkWL5m6e3yQ2qwjtx63AXG1FTJp+o/wh606Hp+GT8Xy4ZhpebzWIRM?=
 =?us-ascii?Q?nofXX88h0xLz+F1wI1dHSyxN47f9t02qlsYjdLW94xebMSKd0AZ8LQxIRSVN?=
 =?us-ascii?Q?OpBIE/tDOtqgFiJjXLtb0kKjkAfYQV/glX1A5Rwya6byO92s5O68z8z9z3mR?=
 =?us-ascii?Q?4S9+niR6VIfURj/sJKpknvx6CZqSMCJuMtFNj3lWDPe33bF0YZByc2ft4lWc?=
 =?us-ascii?Q?3ESsXoiK9a5yNTkqsq7QYBrYYAUjE7lkXqlx58uQCCgKdn2GeSZRpuPLIE6L?=
 =?us-ascii?Q?L1NADlMxIlgs7hinkCFaIWqSzQn/q3cFUxx125HcdZXzSOW27cU+BZQJxpIC?=
 =?us-ascii?Q?+6PIx6rDwPrAOvZPVLCINtaYO7+qIwVRFY7l2Yh0UqeQX1gBNaUEct+5zj9s?=
 =?us-ascii?Q?AlPMhfbP+UcsqNpVJFOM3YRuTkNLY6NP6OyVBD+/A+E+nhGEeL3M6CXXFle1?=
 =?us-ascii?Q?0htmCqDItaN/X06vJTyDXSLfCUqSf5TMp/PCePk2ostCaVe76/6MisWCDPL9?=
 =?us-ascii?Q?CorJ2ARvVF9nbSNK1CSXmky+Fs3bL8U92JBqZacYrEdNMmXcK4pfExzKhl/R?=
 =?us-ascii?Q?+g5Fh1K6WAfc/YnS98HNPZ0ORrlQidl4loVx1ZF/oJBNN7MYU1Bg+IwVPS9B?=
 =?us-ascii?Q?YDp9k1JZANA349XKB4gFtwvWSCtYvVtadW9pRW2gRvndpESLTWpeMfun3Oy1?=
 =?us-ascii?Q?Nxr9sSLmVXG4MxcE6NrHMOwfijnTAbUquxAy89RxcUB90zR7/0bH9WDKSe6L?=
 =?us-ascii?Q?lX4Q5zwQL2xBahvvSSnCR7yOh47XkMo84ny7U61kUmf6qlcmrFNEqRVIrgmv?=
 =?us-ascii?Q?fsHLZqbut4UEIMEYrR0kMsxhI26GJoT/whV2CdNxhWDGewFmkV2DDNout0UI?=
 =?us-ascii?Q?jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <80C1EB3D35AC4447857EB58A7A9DFF51@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba706c73-50bc-474b-3e2b-08daa08d76ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 13:37:47.0250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nh9pnT5VsAXA/VrR1SJXmsGSfBM5n8PORHWMcdLq62c8VOCMaZLIaJfNRRmVxJfqDPFJOtogFPXrhG/HLEN3QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7681
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 02:47:37PM +0200, Paolo Abeni wrote:
> On Fri, 2022-09-23 at 18:45 +0300, Ioana Ciornei wrote:
> > From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> >=20
> > This patch allows the configuration of multiple buffer pools associated
> > with a single DPNI object, each distinct DPBP object not necessarily
> > shared among all queues.
> > The user can interogate both the number of buffer pools and the buffer
> > count in each buffer pool by using the .get_ethtool_stats() callback.
> >=20
> > Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v2:
> >  - Export dpaa2_eth_allocate_dpbp/dpaa2_eth_free_dpbp in this patch to
> >    avoid a build warning. The functions will be used in next patches.
> >=20

(...)

> > -/* Allocate and configure one buffer pool for each interface */
> > -static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
> > +/* Allocate and configure a buffer pool */
> > +struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *pr=
iv)
> >  {
> > -	int err;
> > -	struct fsl_mc_device *dpbp_dev;
> >  	struct device *dev =3D priv->net_dev->dev.parent;
> > +	struct fsl_mc_device *dpbp_dev;
> >  	struct dpbp_attr dpbp_attrs;
> > +	struct dpaa2_eth_bp *bp;
> > +	int err;
> > =20
> >  	err =3D fsl_mc_object_allocate(to_fsl_mc_device(dev), FSL_MC_POOL_DPB=
P,
> >  				     &dpbp_dev);
> > @@ -3219,12 +3244,16 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_et=
h_priv *priv)
> >  			err =3D -EPROBE_DEFER;
> >  		else
> >  			dev_err(dev, "DPBP device allocation failed\n");
> > -		return err;
> > +		return ERR_PTR(err);
> >  	}
> > =20
> > -	priv->dpbp_dev =3D dpbp_dev;
> > +	bp =3D kzalloc(sizeof(*bp), GFP_KERNEL);
> > +	if (!bp) {
> > +		err =3D -ENOMEM;
> > +		goto err_alloc;
> > +	}
>=20
> It looks like 'bp' is leaked on later error paths.
>=20

Yes, I missed this.

Thanks!=
