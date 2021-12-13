Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3A54734FD
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 20:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242375AbhLMTa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 14:30:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35974 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242252AbhLMTaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 14:30:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDGnGNg027709;
        Mon, 13 Dec 2021 11:30:52 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cx21kjms5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 11:30:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYTo6CFbEYdhq3DT5S2g7GCJbzFOn4PNuIgKBEk468sF2vaRcsGxwflPo5VPWbP+emG5syRcYI/AVGA4GGIkBKEoZhwfIvit+u9BCmdSR2yqEzJctnYEVel2rAWi5fWr5jSnonVZi1/iFcv/fttBftHB6/pPgtfoKZIHvpjnfT+3vnhtsPgeXwRSZiR7m5y2gANT98XMK6y2CxkltKhQ47gIcGmBFK7EZf6gDERkfo1zY53c/O12MPEPxif+KeZMBbnYjnk0bG2hwfwEFNLWpEUTQGWzBPJjFQe+mCpZRiIVs+8OI3l8wxCIShxPfyXw1OczZcJYSDujdh9OWkU51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z12u5WoP9LmyXMaSgnrAyqBflxVpN0vfOLPzy8BgQlc=;
 b=QfvuHKRXpOC7U6q0oKvbiLkhOnxGvf2yVQvCT1kWAFfEgUT0+gDqUngIg9OYxrx9AJghBf9RSPy7RAASQRUGeZs7XEwviEPUJ5b5O9fTuOBmM1sSKaikt4CHJy9bAySXLFDk6opFzD0Hl7AfZX6IvM5X99CkZLlRAuwK2KpiaWipkaVVgBAISGDogFe6zHCQoViaCC8felZ/x8u2UA6SYROlAD/MJwUnZfNiSX1QczEfdfPGMhYGz4OdrHpCDaoPeQtV+E7l+50I+WpIntNskI/EILXTJPmAk0+F5DJLoh6L0viXy1gBEbm5EqJbCB7N1BIWWwJVmrSktNzszW/GnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z12u5WoP9LmyXMaSgnrAyqBflxVpN0vfOLPzy8BgQlc=;
 b=C4IihVW0L9gWujANivRFd7iiIMsYtABV5Tw1AkR4Fv+SPgoraA4+peSc2UORWGMlN7KmGQg5mW/lBPBGUOHW0wHGQjob5KkdBtEKMDhwIZkuVbFGTh2mhawdflDCH6Py/pd3YnzoY1K8VJH1i6BUn9Nrt6Nw4FHTJqUAc+KrWdA=
Received: from CO1PR18MB4732.namprd18.prod.outlook.com (2603:10b6:303:eb::13)
 by CO1PR18MB4763.namprd18.prod.outlook.com (2603:10b6:303:ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 19:30:49 +0000
Received: from CO1PR18MB4732.namprd18.prod.outlook.com
 ([fe80::ecd1:ab65:7da0:4db3]) by CO1PR18MB4732.namprd18.prod.outlook.com
 ([fe80::ecd1:ab65:7da0:4db3%3]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 19:30:49 +0000
From:   Radha Chintakuntla <radhac@marvell.com>
To:     Radha Chintakuntla <radhac@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] octeontx2-nicvf: Add netdev interface support for SDP
 VF devices
Thread-Topic: [PATCH v2] octeontx2-nicvf: Add netdev interface support for SDP
 VF devices
Thread-Index: AQHX6s7AoDEU5F1vxEeCuvuaE7X706ww2MJw
Date:   Mon, 13 Dec 2021 19:30:49 +0000
Message-ID: <CO1PR18MB47325EDDE8051D1CE2865444C5749@CO1PR18MB4732.namprd18.prod.outlook.com>
References: <20211206182605.31087-1-radhac@marvell.com>
In-Reply-To: <20211206182605.31087-1-radhac@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01309324-e490-4af0-6b14-08d9be6f11a9
x-ms-traffictypediagnostic: CO1PR18MB4763:EE_
x-microsoft-antispam-prvs: <CO1PR18MB47633418070BA143E47821C1C5749@CO1PR18MB4763.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I7j9GNsXK2a1X2pVWUB51t6/MEQROh4r77DMqElHxAHLi0QejkA1+RmIXevJPG6+bUDqfyM2e7K9uLyxbyO9grdfJ6zC7HRaJWtNJReP/fuuZuHN8hiT7O+4y4DbThljKqH2sQTrMU8sXAWTutaz0jYRZgKlX2VQQ3LcQydGxqMBHWeQOm8YYks4PRNyBiyvsbgBjfLoUwgZWbg5ef3gRrOPgFOLXZFZyjAyLCDRLdjoE4l8aT20A3K1yq5AhXZVCVeRRIKgT1bYediboqiFu/aYQOC9foIfu4BE3x/ZCEBBA5e7dvlprqh0Hah1VU+89hv1o37aV7lEb9RkDXXbk6ZvFUlEcSqRHVs/mvzGHClYVrKZWDpa7NyaBLCpYiTS9jgm8bmbHkJ7yl1xLmj3gbORpl8sIyyukEVIGVNeGtY8e0qPpPZ3KuPdjysOzHzkuaduSA6X+3uGhVY0W0hftEh/tBaKCz+Cle5b1rKIBwSBBxDHiYy0ybPq+yPRkB2i24idEAmdtW35zCYg0JwY1HzJSoJXKrzocsXrNp7R81gehXB7Uc8WFFcPA0hoLxNJ17x+S4Hpz9eoJh7CIKULv9jM2wI0tmPZTEs0SqbSsCaV8eyDnpj5LvR6PGtlVf6pOZi/9jaHht3k372AIb0NOPNcV4xNau5Y96VdfEPsOkQYWAl+URnSnAcTUnFdxmgCYW/1j4s4gtQ85akrl5FQPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4732.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(110136005)(2906002)(86362001)(53546011)(55016003)(316002)(33656002)(52536014)(7696005)(26005)(38100700002)(38070700005)(186003)(5660300002)(30864003)(66446008)(8676002)(71200400001)(66476007)(66946007)(9686003)(76116006)(83380400001)(508600001)(6506007)(66556008)(122000001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ljeALxs2HwrkhiQGN1a3rvg3WcP/i9msh1W/MziKb5fP3WmqMIMiHRv70eRq?=
 =?us-ascii?Q?HXVIHmPFeF+9i3ZFNQ1Q0bkYWWG7uvj8aDy5mR9Domh9phH5WCdrv+741/kb?=
 =?us-ascii?Q?UtugTQcG4bn64zK4xw9ixMyc6MJ4tVE9bxvW6WyZmeVS62AqU5Mz2hYGQVVz?=
 =?us-ascii?Q?7koLaIiUnQ9YPA/vla5IodyxqEQE+UncIJBgNoLnYr5X5VFv+NvblLZJiPqM?=
 =?us-ascii?Q?VWEqxJ/tkSIUJYkLn8IExsjCDnS8GrCf50d9ti/5yApq+JWqE9cPbqnxJt8t?=
 =?us-ascii?Q?Tt8cEmp7MLYVcKWDogjPL+e0sXks91bpwhFgb84Bt0MbBBa4BD94904nyr1L?=
 =?us-ascii?Q?vUcxF3JxpA/j+jTAlAjlozSySMbUym834Ar4+WhVcesXQ3GBc3JsKfPK/zVS?=
 =?us-ascii?Q?sle3aqVilZBdIAtKZwFthh1P1Wdw5nSBcBECDJhySOfSEPz0Jx4iGRehNwjj?=
 =?us-ascii?Q?LqHIPx5uvZLVeVNVgOA5o9ESpQRJi7yFbIEpDm6hUOLFIrqwqvZ6Vck05c9+?=
 =?us-ascii?Q?906f/XfIPvQPQNRhtldofbsJCzNTKYbAX2FaPU5WK3DK/JGLd+NvIe0vpsXy?=
 =?us-ascii?Q?qFSchjqqA81p1SmHPYzVQluX9/AGj2t7e5WSjAz3RP7XkIXzshXVdZvefvEZ?=
 =?us-ascii?Q?bZ43QP7sxuxsSBw+Kl8AEqfySvCIn/4NQRA6HnFE+OfqpgU9j106oo0w0DuM?=
 =?us-ascii?Q?8OCh2Qnbr44rjDE1cib0j7vzjocmQVf9qTMh0mL9aDsWsqCERiq6mjpLey5m?=
 =?us-ascii?Q?g7ye7OvMB1oDKczW6Xr/WrM+rt9N63hqKnHwaA7FZ9wZkjIist0IQbn3W9Kb?=
 =?us-ascii?Q?Xk6zNkp0WU5c4TFqbTLY1nX9YJ6mz3Nv29glF9iAOQ5vb14ZF/y4WSwiyeMJ?=
 =?us-ascii?Q?YEtrkHE0bvarR83PtTWTKfvX5V8vSIbXaQkSQuG0FsdWNfi9S8qCxgmJeaUn?=
 =?us-ascii?Q?E9eJj+vv02rHiM4164RnEV6YrexxRpuMplrgaEFInH5/5uegIrR/di3ZMww4?=
 =?us-ascii?Q?cGuwWJDmzbK5AxBeiIQUqLmebqswVusI0Cr46XGrrS11Xt1KETI3skGolbCn?=
 =?us-ascii?Q?/FVWXe1fAiY6FV+S0x6Yp1i83oa2iY5mG0/iWtIqO+kNEUC1fM3HTgcu4Z2V?=
 =?us-ascii?Q?CAMUpZul9w+a4i3AU7osH5g7EhjjLXE4TdmAY1TQ6mpwWITe4nvCKuk1x3PO?=
 =?us-ascii?Q?a5sinPIEIxb2zU7mWcmKIKIQ3HVAx4nAH2MacUWPnc+NCLk7of+q0fraoNM/?=
 =?us-ascii?Q?4rrSPh+gdEuhrUaNtAJyfS/OxKCtEMePNwTzeNk0+VnoUwQdLAfEi91/sXHG?=
 =?us-ascii?Q?/Yof6JnIhcUSKRMTpA+nQzcGHWf+oYWFlye7P4hCQkzbPnRnTzG65ZlS68kN?=
 =?us-ascii?Q?2JF0u7yAr1+BFXrBRsUZBh6lDt7NFb97Z/2Ld79sEwapeJWSfb826AmVqO5G?=
 =?us-ascii?Q?nd9+RZhT30ucVhlkqL+XUNqz/EWB/vmp2FmTPJAnsdWnfwvdB4BlLjUmFm/X?=
 =?us-ascii?Q?OsN7d6p+2t3ynLhq5c5ytTG+AKm2v4MUP0IqWk1GHrbxiQaOrWYj19i3eyok?=
 =?us-ascii?Q?4cgSW3VL8WbarZePsB+4PMvJaifs6zGkK1sFTN7zSnCgnRo6klTb4xDKvYIF?=
 =?us-ascii?Q?XQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4732.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01309324-e490-4af0-6b14-08d9be6f11a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 19:30:49.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FCd3uvXx3LmEeD6bwAF0+wdYBRR+fLExvil6a/bbnUj2J7zs4NqziwPdEJs4mxa5VvbI5if8XbnpDNu8XZwikg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4763
X-Proofpoint-GUID: UrehkrCXO5pAuLpA-QIbUkgH5xCJq0BJ
X-Proofpoint-ORIG-GUID: UrehkrCXO5pAuLpA-QIbUkgH5xCJq0BJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_09,2021-12-13_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Radha Mohan Chintakuntla <radhac@marvell.com>
> Sent: Monday, December 6, 2021 10:26 AM
> To: netdev@vger.kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; linux-kernel@vger.kernel.org
> Cc: Radha Chintakuntla <radhac@marvell.com>
> Subject: [PATCH v2] octeontx2-nicvf: Add netdev interface support for SDP
> VF devices
>=20
> This patch adds netdev interface for SDP VFs. This interface can be used =
to
> communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
> mode.
>=20
> Signed-off-by: Radha Mohan Chintakuntla <radhac@marvell.com>
> ---
> Changes from v1:
> - fixed formatting issues happened due to email client
>=20
>  .../ethernet/marvell/octeontx2/nic/cn10k.c    |  4 +--
>  .../ethernet/marvell/octeontx2/nic/cn10k.h    |  2 +-
>  .../marvell/octeontx2/nic/otx2_common.c       | 32 +++++++++++++------
>  .../marvell/octeontx2/nic/otx2_common.h       | 14 ++++++--
>  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |  1 +
> .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 16 ++++++++--
>  6 files changed, 51 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
> index fd4f083c699e..2262d33a7f23 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
> @@ -72,7 +72,7 @@ int cn10k_lmtst_init(struct otx2_nic *pfvf)  }
> EXPORT_SYMBOL(cn10k_lmtst_init);
>=20
> -int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
> +int cn10k_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura)
>  {
>  	struct nix_cn10k_aq_enq_req *aq;
>  	struct otx2_nic *pfvf =3D dev;
> @@ -89,7 +89,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
>  	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
>  	aq->sq.smq =3D pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
>  	aq->sq.smq_rr_weight =3D mtu_to_dwrr_weight(pfvf, pfvf-
> >tx_max_pktlen);
> -	aq->sq.default_chan =3D pfvf->hw.tx_chan_base;
> +	aq->sq.default_chan =3D pfvf->hw.tx_chan_base + chan_offset;
>  	aq->sq.sqe_stype =3D NIX_STYPE_STF; /* Cache SQB */
>  	aq->sq.sqb_aura =3D sqb_aura;
>  	aq->sq.sq_int_ena =3D NIX_SQINT_BITS;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
> index 8ae96815865e..28b3b3275fe6 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
> @@ -26,7 +26,7 @@ static inline int mtu_to_dwrr_weight(struct otx2_nic
> *pfvf, int mtu)
>=20
>  void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);  void
> cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx)=
; -
> int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
> +int cn10k_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16
> +sqb_aura);
>  int cn10k_lmtst_init(struct otx2_nic *pfvf);  int
> cn10k_free_all_ipolicers(struct otx2_nic *pfvf);  int
> cn10k_alloc_matchall_ipolicer(struct otx2_nic *pfvf); diff --git
> a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 66da31f30d3e..e46c24171597 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -233,6 +233,9 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
>=20
>  	req->maxlen =3D pfvf->netdev->mtu + OTX2_ETH_HLEN +
> OTX2_HW_TIMESTAMP_LEN;
>=20
> +	if (is_otx2_sdpvf(pfvf->pdev))
> +		req->sdp_link =3D true;
> +
>  	err =3D otx2_sync_mbox_msg(&pfvf->mbox);
>  	mutex_unlock(&pfvf->mbox.lock);
>  	return err;
> @@ -243,7 +246,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
>  	struct cgx_pause_frm_cfg *req;
>  	int err;
>=20
> -	if (is_otx2_lbkvf(pfvf->pdev))
> +	if (is_otx2_lbkvf(pfvf->pdev) || is_otx2_sdpvf(pfvf->pdev))
>  		return 0;
>=20
>  	mutex_lock(&pfvf->mbox.lock);
> @@ -622,6 +625,11 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lv=
l)
>  		req->num_regs++;
>  		req->reg[1] =3D NIX_AF_TL4X_SCHEDULE(schq);
>  		req->regval[1] =3D dwrr_val;
> +		if (is_otx2_sdpvf(pfvf->pdev)) {
> +			req->num_regs++;
> +			req->reg[2] =3D NIX_AF_TL4X_SDP_LINK_CFG(schq);
> +			req->regval[2] =3D BIT_ULL(12);
> +		}
>  	} else if (lvl =3D=3D NIX_TXSCH_LVL_TL3) {
>  		parent =3D hw->txschq_list[NIX_TXSCH_LVL_TL2][0];
>  		req->reg[0] =3D NIX_AF_TL3X_PARENT(schq); @@ -638,11
> +646,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
>  		req->reg[1] =3D NIX_AF_TL2X_SCHEDULE(schq);
>  		req->regval[1] =3D TXSCH_TL1_DFLT_RR_PRIO << 24 |
> dwrr_val;
>=20
> -		req->num_regs++;
> -		req->reg[2] =3D NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw-
> >tx_link);
> -		/* Enable this queue and backpressure */
> -		req->regval[2] =3D BIT_ULL(13) | BIT_ULL(12);
> -
> +		if (!is_otx2_sdpvf(pfvf->pdev)) {
> +			req->num_regs++;
> +			req->reg[2] =3D NIX_AF_TL3_TL2X_LINKX_CFG(schq,
> hw->tx_link);
> +			/* Enable this queue and backpressure */
> +			req->regval[2] =3D BIT_ULL(13) | BIT_ULL(12);
> +		}
>  	} else if (lvl =3D=3D NIX_TXSCH_LVL_TL1) {
>  		/* Default config for TL1.
>  		 * For VF this is always ignored.
> @@ -779,7 +788,7 @@ static int otx2_rq_init(struct otx2_nic *pfvf, u16 qi=
dx,
> u16 lpb_aura)
>  	return otx2_sync_mbox_msg(&pfvf->mbox);  }
>=20
> -int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
> +int otx2_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura)
>  {
>  	struct otx2_nic *pfvf =3D dev;
>  	struct otx2_snd_queue *sq;
> @@ -799,7 +808,7 @@ int otx2_sq_aq_init(void *dev, u16 qidx, u16
> sqb_aura)
>  	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
>  	aq->sq.smq =3D pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
>  	aq->sq.smq_rr_quantum =3D mtu_to_dwrr_weight(pfvf, pfvf-
> >tx_max_pktlen);
> -	aq->sq.default_chan =3D pfvf->hw.tx_chan_base;
> +	aq->sq.default_chan =3D pfvf->hw.tx_chan_base + chan_offset;
>  	aq->sq.sqe_stype =3D NIX_STYPE_STF; /* Cache SQB */
>  	aq->sq.sqb_aura =3D sqb_aura;
>  	aq->sq.sq_int_ena =3D NIX_SQINT_BITS;
> @@ -822,6 +831,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qi=
dx,
> u16 sqb_aura)
>  	struct otx2_qset *qset =3D &pfvf->qset;
>  	struct otx2_snd_queue *sq;
>  	struct otx2_pool *pool;
> +	u8 chan_offset;
>  	int err;
>=20
>  	pool =3D &pfvf->qset.pool[sqb_aura];
> @@ -864,8 +874,8 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qi=
dx,
> u16 sqb_aura)
>  	sq->stats.bytes =3D 0;
>  	sq->stats.pkts =3D 0;
>=20
> -	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
> -
> +	chan_offset =3D qidx % pfvf->hw.tx_chan_cnt;
> +	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, chan_offset,
> sqb_aura);
>  }
>=20
>  static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx) @@ -1590,6 +160=
0,8
> @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
>  	pfvf->hw.sqb_size =3D rsp->sqb_size;
>  	pfvf->hw.rx_chan_base =3D rsp->rx_chan_base;
>  	pfvf->hw.tx_chan_base =3D rsp->tx_chan_base;
> +	pfvf->hw.rx_chan_cnt =3D rsp->rx_chan_cnt;
> +	pfvf->hw.tx_chan_cnt =3D rsp->tx_chan_cnt;
>  	pfvf->hw.lso_tsov4_idx =3D rsp->lso_tsov4_idx;
>  	pfvf->hw.lso_tsov6_idx =3D rsp->lso_tsov6_idx;
>  	pfvf->hw.cgx_links =3D rsp->cgx_links;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 61e52812983f..386fd7f95944 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -28,6 +28,7 @@
>  /* PCI device IDs */
>  #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
>  #define PCI_DEVID_OCTEONTX2_RVU_VF		0xA064
> +#define PCI_DEVID_OCTEONTX2_SDP_VF		0xA0F7
>  #define PCI_DEVID_OCTEONTX2_RVU_AFVF		0xA0F8
>=20
>  #define PCI_SUBSYS_DEVID_96XX_RVU_PFVF		0xB200
> @@ -191,6 +192,8 @@ struct otx2_hw {
>  	/* HW settings, coalescing etc */
>  	u16			rx_chan_base;
>  	u16			tx_chan_base;
> +	u8			rx_chan_cnt;
> +	u8			tx_chan_cnt;
>  	u16			cq_qcount_wait;
>  	u16			cq_ecount_wait;
>  	u16			rq_skid;
> @@ -314,7 +317,7 @@ struct otx2_tc_info {  };
>=20
>  struct dev_hw_ops {
> -	int	(*sq_aq_init)(void *dev, u16 qidx, u16 sqb_aura);
> +	int	(*sq_aq_init)(void *dev, u16 qidx, u8 chan_offset, u16
> sqb_aura);
>  	void	(*sqe_flush)(void *dev, struct otx2_snd_queue *sq,
>  			     int size, int qidx);
>  	void	(*refill_pool_ptrs)(void *dev, struct otx2_cq_queue *cq);
> @@ -403,6 +406,11 @@ static inline bool is_otx2_lbkvf(struct pci_dev *pde=
v)
>  	return pdev->device =3D=3D PCI_DEVID_OCTEONTX2_RVU_AFVF;  }
>=20
> +static inline bool is_otx2_sdpvf(struct pci_dev *pdev) {
> +	return pdev->device =3D=3D PCI_DEVID_OCTEONTX2_SDP_VF; }
> +
>  static inline bool is_96xx_A0(struct pci_dev *pdev)  {
>  	return (pdev->revision =3D=3D 0x00) &&
> @@ -794,8 +802,8 @@ void otx2_ctx_disable(struct mbox *mbox, int type,
> bool npa);  int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);  =
void
> otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
> void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue
> *cq); -int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura); -int
> cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
> +int otx2_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura);
> +int cn10k_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16
> +sqb_aura);
>  int otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq,
>  		      dma_addr_t *dma);
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> index 1b967eaf948b..6ef52051ab09 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> @@ -140,6 +140,7 @@
>=20
>  /* NIX AF transmit scheduler registers */
>  #define NIX_AF_SMQX_CFG(a)		(0x700 | (a) << 16)
> +#define NIX_AF_TL4X_SDP_LINK_CFG(a)	(0xB10 | (a) << 16)
>  #define NIX_AF_TL1X_SCHEDULE(a)		(0xC00 | (a) << 16)
>  #define NIX_AF_TL1X_CIR(a)		(0xC20 | (a) << 16)
>  #define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> index 254bebffe8c1..bc2566cb2ec1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -21,6 +21,7 @@
>  static const struct pci_device_id otx2_vf_id_table[] =3D {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM,
> PCI_DEVID_OCTEONTX2_RVU_AFVF) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM,
> PCI_DEVID_OCTEONTX2_RVU_VF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM,
> PCI_DEVID_OCTEONTX2_SDP_VF) },
>  	{ }
>  };
>=20
> @@ -361,7 +362,7 @@ static int otx2vf_open(struct net_device *netdev)
>=20
>  	/* LBKs do not receive link events so tell everyone we are up here */
>  	vf =3D netdev_priv(netdev);
> -	if (is_otx2_lbkvf(vf->pdev)) {
> +	if (is_otx2_lbkvf(vf->pdev) || is_otx2_sdpvf(vf->pdev)) {
>  		pr_info("%s NIC Link is UP\n", netdev->name);
>  		netif_carrier_on(netdev);
>  		netif_tx_start_all_queues(netdev);
> @@ -681,6 +682,16 @@ static int otx2vf_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
>  		snprintf(netdev->name, sizeof(netdev->name), "lbk%d", n);
>  	}
>=20
> +	/* To distinguish, for SDP VFs set netdev name explicitly */
> +	if (is_otx2_sdpvf(vf->pdev)) {
> +		int n;
> +
> +		n =3D (vf->pcifunc >> RVU_PFVF_FUNC_SHIFT) &
> RVU_PFVF_FUNC_MASK;
> +		/* Need to subtract 1 to get proper VF number */
> +		n -=3D 1;
> +		snprintf(netdev->name, sizeof(netdev->name), "sdp%d-
> %d", pdev->bus->number, n);
> +	}
> +
>  	err =3D register_netdev(netdev);
>  	if (err) {
>  		dev_err(dev, "Failed to register netdevice\n"); @@ -691,7
> +702,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  	if (err)
>  		goto err_unreg_netdev;
>=20
> -	otx2vf_set_ethtool_ops(netdev);
> +	if (!is_otx2_sdpvf(vf->pdev))
> +		otx2vf_set_ethtool_ops(netdev);
>=20
>  	err =3D otx2vf_mcam_flow_init(vf);
>  	if (err)
> --
> 2.17.1
Hi David,
Could you please accept this ?

- Radha=20


