Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0A4CDCD9
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbiCDSnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241831AbiCDSnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:43:01 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2103.outbound.protection.outlook.com [40.107.92.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FD21CBA81
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 10:42:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRj3uhibVNVDJAgdSrSxgqiCkTKd7LQKvD4rxHAVmQdN3BN0ecNCwvh1e+1xh6JCFnDyCOITz73armrABU+I1OpV+cOJ2IBPK80gTim0M1FHorUFQVBDMW9AdPS34MzquoWU3vtnqRUbfTBPWCo8kJA1T2Q1EF+ufRVF/Xiy5rZuDGBYHx75FCERbaCxiEtqfGwbAhe0aM67Udr8kUGNT8OOnFpCcX77BbM0g2H1NNxs5P4O75JPVePJZuxMn7V5B6ZWzBJr11mm9V90n7T+S4LkN0xK2kXmKpPTvcaCuELztZn/wOR9d9kaEyA9TWvgKUZn15cqOCPWURCOzFEN5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4peY40iBv5msUikfshyihxo2FqnsDaLW/ql9AYq3oQ=;
 b=SFvLCb9NrDlr01X7lJlB6R7TG6faYkpgl/njVkmHgmm5jcrmxEODJ/XXENa9d+wt0f95Uo3shD7V61B8wN5J+Q22FYoMaGotjBX8KSCO/su/ko0zThK0Xq1EV4iaOUooSF0BIuDRkb250nesKmFRZ/8TyPFF85bkhSbAblA+NItRdtk15J/j8qd4LP6HPnkOrsHDJsEAiKEJ751UwAWfVyF+ED5pMO3zjVHURIyJtEPdDQIBMOuTdqbKBB0ZMImCOaP34xtVOVyZ2gh74WRhAPEDJCGGa/tfXpbBe3Vghb/ml4JFJfXwZp7KlYZz7ud3rt171gBELLBcNmYBvKNMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4peY40iBv5msUikfshyihxo2FqnsDaLW/ql9AYq3oQ=;
 b=gC3PEnCpVdOdLvZz0KkWCv7Lb2sGgbm8alPxnKQ5O6mwCl/0okCk5TfL5+8/lYkldSp2JPm8CX4frSFrTKuOx7anwOB1/RNLKI8/jaQ8i0sypz5NvM5WACkJEf69cfysj544m0DULnt/nx7zIAAU9VUTJOWUlMLQ0nc7KD8p3SM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by CH2PR13MB3464.namprd13.prod.outlook.com (2603:10b6:610:2f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.8; Fri, 4 Mar
 2022 18:42:09 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::e035:ce64:e29e:54f6]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::e035:ce64:e29e:54f6%5]) with mapi id 15.20.5061.008; Fri, 4 Mar 2022
 18:42:08 +0000
Date:   Fri, 4 Mar 2022 19:42:02 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 5/5] nfp: xsk: add AF_XDP zero-copy Rx and Tx
 support
Message-ID: <YiJdem4OCBKwLpYv@bismarck.dyn.berto.se>
References: <20220304102214.25903-1-simon.horman@corigine.com>
 <20220304102214.25903-6-simon.horman@corigine.com>
 <YiIZ2nVNdH2HMTSI@boxer>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiIZ2nVNdH2HMTSI@boxer>
X-ClientProxiedBy: AM6PR10CA0106.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::47) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5667625b-dbac-48de-3c7e-08d9fe0eafe6
X-MS-TrafficTypeDiagnostic: CH2PR13MB3464:EE_
X-Microsoft-Antispam-PRVS: <CH2PR13MB3464D3DBE02516EE03E9354BE7059@CH2PR13MB3464.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: goCsgx7N7lFm+RTrebGJ4GuoBfpAY7kSsS0DuuNLd2GyxywNB2oPjY4TWatwH9Tdj6gQwLOtLei1agEwt2SkZ+1qDLare+ZZjd9LilBCuAcp5jR1G0125pG7RMWzpw2JTXALSqG1QSVuSE+GzSdnNgoyWhRVxtJSgqWI5XftW74zODRt8ieq9/UNMvZ4Y1aJbfwITT6+AFeaesb0f4KNA+Mow2a67WBoVm0vXsf6ak2iS50hoOcCFFzDVUFj1i2ac+jA1VwY6wg6KhCyjU5XZebE3TsEH1mOVFkEDUcalF6VLarMQMgsDO/IQi5qanJmIOATXg3+6T73VCp0DkVno8BSP9GJx7mhACuG7HZhN6koTi+EW90zvdOPZ0YF6ZkpqZn9fBRTdpCYdJKIz/HY6WoyeItliBQWJauSzHeiGWWYdwGc4fGLu+iNqS9GOXCLuv+Uz5YAW0vK6q3uz1YpPX2DDgpoATEz6PanVcetNWxpL90rV7LZbd4tyDn1LOvoDf79O8mHvZOrwBACyTisOPd1GI0ka1tf3Dhpt894Oy7c50EtoMKfJYyyBHZdaHxtXa4ZDQAHAISsP7Hqdn/HSRIKQMs8reSHR1BDRnch5ijJ40hZ6Ric5pMOPwk79FujG5iPB0YfaHfs11OSgSsr9ElNANs8IhXlX4P/aODNmogvs4UbxiHMRDsBHMJZCFe4VFwlxt+9Hi6wACaN3VJC1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(39830400003)(376002)(346002)(396003)(5660300002)(66476007)(54906003)(6512007)(6506007)(6666004)(9686003)(38350700002)(186003)(4326008)(8936002)(26005)(2906002)(52116002)(66556008)(53546011)(8676002)(38100700002)(107886003)(508600001)(66946007)(66574015)(6486002)(86362001)(83380400001)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?rfAhZdRJQOadOrF+tPZ/f7InHtuY46YNQjUgb7syNwWgKxTKiiwwgVhTg9?=
 =?iso-8859-1?Q?gUmO6ZNdiWKNQ74RcY/bLvSl4UyERoynmKAWbRhGNQVg8JuoUhe5t3+9eD?=
 =?iso-8859-1?Q?jNI9FnVL/bEvcSV5YnCefWvs+4al1ouEn24Q5FAzsnTNs55tl73NgmPGqI?=
 =?iso-8859-1?Q?daQJp4bmirYw57kScH2TpeKV5xA56R9wayPA5A3uSG7QfydJ34qQ/ExeJO?=
 =?iso-8859-1?Q?14Q7v8aNb5Mv0GRvXE3b8Of2est+YfE3TFnxpCUqu44RFfDbs8wRUKp0cS?=
 =?iso-8859-1?Q?OEcUIVO4VjpepzK6O1oTGSbaZ3vAEi7mTYbli9cZUt9ZxwDRuH+VNtLDQD?=
 =?iso-8859-1?Q?P9iViZ9svHB47XKAd8qthhNE2PXPVcbgvNjkO2o11oEfdRwhKFgHnTamQF?=
 =?iso-8859-1?Q?CEnBc+fnj2bOqBnRWBGITXfO3IWeiMbMaqlyf967zsrEa3Xm28FisnrS8Q?=
 =?iso-8859-1?Q?BeTl6yE/+v+M2ToBMA/lD3lDf2KsQBrqINbXXVB0xOC8gs26Ql31J0Cx6b?=
 =?iso-8859-1?Q?gO9ireH9mst4md5aQ3Y72nl+w6TUFEO76WvModYqq8pNvlQzR6CslGxZ4D?=
 =?iso-8859-1?Q?4VIsWaJWA7Uc1z39i0PBfX39xrL2j+Ue843IZuc58wtiQ1sT+I/qt21KVz?=
 =?iso-8859-1?Q?t/IE9FBbBaoIEQ5E4NsZPyV5+8rOc4irrqBqLT9nIjXRKCJp4tubBHh8NF?=
 =?iso-8859-1?Q?bzMv8chBqa0R43NIBa1HWi0fNrHMY3pNWSEkucQDRrHxoUUplKN6o32NC7?=
 =?iso-8859-1?Q?hQedqFSIdOZYfKpCPVq2wiEWVcUz7TqWe3pH/Ono9GtmVfWyO3KQeZ6ZMi?=
 =?iso-8859-1?Q?OcJ2vsFl7ArEvLSthEmye8NzowyuzjOFy+2Ddt+HkxWbvOMQrsMetZgx0j?=
 =?iso-8859-1?Q?D+kISSs/u4tBlToVBj8SJf47SR1j6E/wH22poYQunr1I/ktofUgUgVdKK8?=
 =?iso-8859-1?Q?nmhlXAe5HwlwwIm9S6KFR6DztQgfJVrGojlQO9hzxCo1+HDGPoEBq/pq/a?=
 =?iso-8859-1?Q?s8y3AI1UA1dtrtYS2ZA2risxl4QS3IAJmjxa+QNr4i6EvYy1/iAc9ldX87?=
 =?iso-8859-1?Q?53JcdwgPPR7wxXrp8jZZRQGgQUa4WSetELW63eO3tpIQK248XGSScWXAQQ?=
 =?iso-8859-1?Q?v7dnZ55oWc8LiZyMa6MNLmN7L1qG32rq1kdKAta+LkdS7m21Sm98cQW0gb?=
 =?iso-8859-1?Q?HClc9xfvHsCN5AtX1BgtV1QvgN2UQHfpgz+z/malH+dAljytk4fM4tqmjx?=
 =?iso-8859-1?Q?Ngh2FSr2PqoO0Ha+GLYm86LFcG81z8/qMTuMSQuZgTC1lVuz7yHVoAuXo6?=
 =?iso-8859-1?Q?AO4WlhIObF6v8RskuMCspbFX8p/AW2OjKXIxtXzq8lMrBUZyWqWQSLkHbc?=
 =?iso-8859-1?Q?q0RoMVmTYe2n66xlFXJbtlDNwa3PCjPJFNnfu47QapAOQfXoIeyEW1lka2?=
 =?iso-8859-1?Q?2FdNH5sp/BLxE+U1zOMtczNaFUSS1JaJxpYMk19XZZSPNh4XkflD2eZWun?=
 =?iso-8859-1?Q?IZUD1pekB3s5occPs2f+f3EHyFj1WEbWqrTfKFY2ZMSmDLykURerJU4r9W?=
 =?iso-8859-1?Q?7ta+JvQ=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5667625b-dbac-48de-3c7e-08d9fe0eafe6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 18:42:08.6872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrxlZhXKwSe6fGJ6725XT8BM015Wc5LKNG2xkXkZnZNKMXEDEkrk1IuhTjZ+CVmQrgTEwa9uQerOZ3AzgbR+HyoLTNFhlPxlFa3HyukrgpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3464
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

Thanks for your feedback.

On 2022-03-04 14:53:30 +0100, Maciej Fijalkowski wrote:
> On Fri, Mar 04, 2022 at 11:22:14AM +0100, Simon Horman wrote:
> > From: Niklas Söderlund <niklas.soderlund@corigine.com>
> > 
> > This patch adds zero-copy Rx and Tx support for AF_XDP sockets. It do so
> > by adding a separate NAPI poll function that is attached to a each
> > channel when the XSK socket is attached with XDP_SETUP_XSK_POOL, and
> > restored when the XSK socket is terminated, this is done per channel.
> > 
> > Support for XDP_TX is implemented and the XDP buffer can safely be moved
> > from the Rx to the Tx queue and correctly freed and returned to the XSK
> > pool once it's transmitted.
> > 
> > Note that when AF_XDP zero-copy is enabled, the XDP action XDP_PASS
> > will allocate a new buffer and copy the zero-copy frame prior
> > passing it to the kernel stack.
> > 
> > This patch is based on previous work by Jakub Kicinski.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  drivers/net/ethernet/netronome/nfp/Makefile   |   1 +
> >  drivers/net/ethernet/netronome/nfp/nfp_net.h  |  31 +-
> >  .../ethernet/netronome/nfp/nfp_net_common.c   |  98 ++-
> >  .../ethernet/netronome/nfp/nfp_net_debugfs.c  |  33 +-
> >  .../net/ethernet/netronome/nfp/nfp_net_xsk.c  | 592 ++++++++++++++++++
> >  .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |  29 +
> >  6 files changed, 756 insertions(+), 28 deletions(-)
> >  create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
> >  create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
> 
> (...)
> 
> > +
> > +static void nfp_net_xsk_tx(struct nfp_net_tx_ring *tx_ring)
> > +{
> > +	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
> > +	struct xdp_desc desc[NFP_NET_XSK_TX_BATCH];
> > +	struct xsk_buff_pool *xsk_pool;
> > +	struct nfp_net_tx_desc *txd;
> > +	u32 pkts = 0, wr_idx;
> > +	u32 i, got;
> > +
> > +	xsk_pool = r_vec->xsk_pool;
> > +
> > +	while (nfp_net_tx_space(tx_ring) >= NFP_NET_XSK_TX_BATCH) {
> > +		for (i = 0; i < NFP_NET_XSK_TX_BATCH; i++)
> > +			if (!xsk_tx_peek_desc(xsk_pool, &desc[i]))
> > +				break;
> 
> Please use xsk_tx_peek_release_desc_batch() and avoid your own internal
> batching mechanisms. We introduced the array of xdp_descs on xsk_buff_pool
> side just for that purpose, so there's no need for having this here on
> stack.
> 
> I suppose this will also simplify this ZC support.

This is a great suggestion. I will create a patch to use 
xsk_tx_peek_release_desc_batch() here.

> 
> Dave, could you give us some time for review? It was on list only for few
> hours or so and I see it's already applied :<
> 
> > +		got = i;
> > +		if (!got)
> > +			break;
> > +
> > +		wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
> > +		prefetchw(&tx_ring->txds[wr_idx]);
> > +
> > +		for (i = 0; i < got; i++)
> > +			xsk_buff_raw_dma_sync_for_device(xsk_pool, desc[i].addr,
> > +							 desc[i].len);
> > +
> > +		for (i = 0; i < got; i++) {
> > +			wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
> > +
> > +			tx_ring->txbufs[wr_idx].real_len = desc[i].len;
> > +			tx_ring->txbufs[wr_idx].is_xsk_tx = false;
> > +
> > +			/* Build TX descriptor. */
> > +			txd = &tx_ring->txds[wr_idx];
> > +			nfp_desc_set_dma_addr(txd,
> > +					      xsk_buff_raw_get_dma(xsk_pool,
> > +								   desc[i].addr
> > +								   ));
> > +			txd->offset_eop = PCIE_DESC_TX_EOP;
> > +			txd->dma_len = cpu_to_le16(desc[i].len);
> > +			txd->data_len = cpu_to_le16(desc[i].len);
> > +		}
> > +
> > +		tx_ring->wr_p += got;
> > +		pkts += got;
> > +	}
> > +
> > +	if (!pkts)
> > +		return;
> > +
> > +	xsk_tx_release(xsk_pool);
> > +	/* Ensure all records are visible before incrementing write counter. */
> > +	wmb();
> > +	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, pkts);
> > +}
> > +
> > +static bool
> > +nfp_net_xsk_tx_xdp(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
> > +		   struct nfp_net_rx_ring *rx_ring,
> > +		   struct nfp_net_tx_ring *tx_ring,
> > +		   struct nfp_net_xsk_rx_buf *xrxbuf, unsigned int pkt_len,
> > +		   int pkt_off)
> > +{
> > +	struct xsk_buff_pool *pool = r_vec->xsk_pool;
> > +	struct nfp_net_tx_buf *txbuf;
> > +	struct nfp_net_tx_desc *txd;
> > +	unsigned int wr_idx;
> > +
> > +	if (nfp_net_tx_space(tx_ring) < 1)
> > +		return false;
> > +
> > +	xsk_buff_raw_dma_sync_for_device(pool, xrxbuf->dma_addr + pkt_off, pkt_len);
> > +
> > +	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
> > +
> > +	txbuf = &tx_ring->txbufs[wr_idx];
> > +	txbuf->xdp = xrxbuf->xdp;
> > +	txbuf->real_len = pkt_len;
> > +	txbuf->is_xsk_tx = true;
> > +
> > +	/* Build TX descriptor */
> > +	txd = &tx_ring->txds[wr_idx];
> > +	txd->offset_eop = PCIE_DESC_TX_EOP;
> > +	txd->dma_len = cpu_to_le16(pkt_len);
> > +	nfp_desc_set_dma_addr(txd, xrxbuf->dma_addr + pkt_off);
> > +	txd->data_len = cpu_to_le16(pkt_len);
> > +
> > +	txd->flags = 0;
> > +	txd->mss = 0;
> > +	txd->lso_hdrlen = 0;
> > +
> > +	tx_ring->wr_ptr_add++;
> > +	tx_ring->wr_p++;
> > +
> > +	return true;
> > +}
> > +
> > +static int nfp_net_rx_space(struct nfp_net_rx_ring *rx_ring)
> > +{
> > +	return rx_ring->cnt - rx_ring->wr_p + rx_ring->rd_p - 1;
> > +}
> > +
> > +static void
> > +nfp_net_xsk_rx_bufs_stash(struct nfp_net_rx_ring *rx_ring, unsigned int idx,
> > +			  struct xdp_buff *xdp)
> > +{
> > +	unsigned int headroom;
> > +
> > +	headroom = xsk_pool_get_headroom(rx_ring->r_vec->xsk_pool);
> > +
> > +	rx_ring->rxds[idx].fld.reserved = 0;
> > +	rx_ring->rxds[idx].fld.meta_len_dd = 0;
> > +
> > +	rx_ring->xsk_rxbufs[idx].xdp = xdp;
> > +	rx_ring->xsk_rxbufs[idx].dma_addr =
> > +		xsk_buff_xdp_get_frame_dma(xdp) + headroom;
> > +}
> > +
> > +static void nfp_net_xsk_rx_unstash(struct nfp_net_xsk_rx_buf *rxbuf)
> > +{
> > +	rxbuf->dma_addr = 0;
> > +	rxbuf->xdp = NULL;
> > +}
> > +
> > +static void nfp_net_xsk_rx_free(struct nfp_net_xsk_rx_buf *rxbuf)
> > +{
> > +	if (rxbuf->xdp)
> > +		xsk_buff_free(rxbuf->xdp);
> > +
> > +	nfp_net_xsk_rx_unstash(rxbuf);
> > +}
> > +
> > +void nfp_net_xsk_rx_bufs_free(struct nfp_net_rx_ring *rx_ring)
> > +{
> > +	unsigned int i;
> > +
> > +	if (!rx_ring->cnt)
> > +		return;
> > +
> > +	for (i = 0; i < rx_ring->cnt - 1; i++)
> > +		nfp_net_xsk_rx_free(&rx_ring->xsk_rxbufs[i]);
> > +}
> > +
> > +void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring)
> > +{
> > +	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
> > +	struct xsk_buff_pool *pool = r_vec->xsk_pool;
> > +	unsigned int wr_idx, wr_ptr_add = 0;
> > +	struct xdp_buff *xdp;
> > +
> > +	while (nfp_net_rx_space(rx_ring)) {
> > +		wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
> > +
> > +		xdp = xsk_buff_alloc(pool);
> 
> Could you use xsk_buff_alloc_batch() with nfp_net_rx_space(rx_ring) passed
> as requested count of xdp_bufs instead calling xsk_buff_alloc() in a loop?

I think I can, I will give it a try and post a patch. Thanks for the 
pointer.

> 
> > +		if (!xdp)
> > +			break;
> > +
> > +		nfp_net_xsk_rx_bufs_stash(rx_ring, wr_idx, xdp);
> > +
> > +		nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
> > +				      rx_ring->xsk_rxbufs[wr_idx].dma_addr);
> > +
> > +		rx_ring->wr_p++;
> > +		wr_ptr_add++;
> > +	}
> > +
> > +	/* Ensure all records are visible before incrementing write counter. */
> > +	wmb();
> > +	nfp_qcp_wr_ptr_add(rx_ring->qcp_fl, wr_ptr_add);
> > +}
> > +
> 
> (...)

-- 
Regards,
Niklas Söderlund
