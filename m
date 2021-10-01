Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01141F10B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355001AbhJAPTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:19:47 -0400
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:48993
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354795AbhJAPTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:19:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9vmhg6ajxOBiea4sk477ZGXYkavyJSnGS30qV4Y/XHPFAf0cJhh2RF8jkIKdFLRUK+4hfqLju5GJaLRsMzkPyVxZBCr5jf0ZlbFrnrYihcQlA54ruFD6oZyYIhcpTPIqYm9dNGOP21JHE2FiQ38CJnS89UBK2DdYN8JBkQfaqQjKDoTSNr91qNZT97Jgl4s/8d8ElZCN2OKE7C1lXH6FMeF7OSxmDRcSyHSG+qyk6fUKQIrosp3olYb+Q8hMzNDaWhNrysVEJql9j/BDhcDqBAE7NKpvOIEzrIEkXluIY3hQJTF352r4eGm/T71RuPKisUSEDe2qKY+ftkiJimcLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMIFRQ/IWo0Y3J+P8HZhFyVVZaZVe0kcKzzxEBHRElA=;
 b=EBhdVz0B+8+aOzxHZT7Byfq9BqBf+MZ8HZfOPa4LBQD0jLscZyfcdYkt36dBTnP/k0DRIvZ4luyfQUk+3/OGbeB0tOcsO8KHS5BnOPwjwDx0nkosj/+6stQNgdvtl7dx04LGs4fLjickKLBNMbCJgprwbkCUMrzbq8FjFk7Lc8QoFZ4Lgw7SUco9aHD3PNMx4/bA6xp1Z1yS0B9b2NUt/abRKOIuVRmyryqZhFsEP37jvGZuCCcKP8klr5PGZTNuMEd0Nncr+8VC0Cyrlhf7f32z4MzpGu5InMyvKt4H3qX6im89uJw32n7K4ME4Z0kYKMi1fGwR9BVRdjfe+L7wfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMIFRQ/IWo0Y3J+P8HZhFyVVZaZVe0kcKzzxEBHRElA=;
 b=n8WE1eMYkhSQ7fgoW6sWMGP3XV2l0jwnLVb4owlEPEYlHa18Jafo4rQ80NrF09FMbyReKcSUY/oIjFHrZDf7LPsYvAGj6mYjAgajoPbDtBwyuFn8prNwv105mWlU0V5YV2gEW93PSS8PV4NWpE5TdPEGlnPA+vwJuXidirLxZls=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5593.namprd11.prod.outlook.com (2603:10b6:510:e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 15:18:00 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:18:00 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
Date:   Fri, 01 Oct 2021 17:17:52 +0200
Message-ID: <2873071.CAOYYqaKbK@pc-42>
Organization: Silicon Labs
In-Reply-To: <87fstlkr1m.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210920161136.2398632-14-Jerome.Pouiller@silabs.com> <87fstlkr1m.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR2P264CA0047.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::35) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR2P264CA0047.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:17:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 796c1a53-4aa4-459f-27a0-08d984eea79c
X-MS-TrafficTypeDiagnostic: PH0PR11MB5593:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5593ACA806DCC23DBEF3DD4993AB9@PH0PR11MB5593.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2X9emKt7NsGOsW4oz9/a3guSWNRZevV566YculdA4TbyomU8q/S1xH1CEeCDHeWk2nRLsHGwFhrWKQJhhgBZX9pu/nzkimmLoRfOyRiopbmdde+c80Ehj+qfB7en62g8ipuwfWgHSzHsuNi9TWyU+NaY+ypTkXib8Y2RUD1/xf86BBeYP8gj5AOuM2pDDvqkFid2V+I7dsqb3J6zUj1PX1fZADSZ1ChSqu8Xkqx25LaiAyJTZVrCUWqLl9QQy8hWwDw2vSB5ixIKDpQ8f4RBUVwiXPaAk4JHEYjQN0AqlY7C8kMVPnflDdaSrhteWRtwDGv/doMpKiBG2G4fEG0arcG6G/xI5SVKQy7Ofxa6dfrkRBRKbKEbUs6x/yzV5wjfjlIKuS8wiT1ysFlGMZccuE8LFcJJH/Hgk3mLLrD/PLO7671Q76tz2NeV7s79iciHaPBgZl+v8c3JRO0a0BpB9gfTSO+mp5z3RLS9UntirGy2muASQoDJd+jkGSvgB8DjI3XHVpcGPy31o3ftOiV56XzDfZhRi4LDAbJoLCrCmhDQ4+71gRNwU6IjrR9e9HMfrWYf7YihieG6xhRmIZ1PjoJsA1h+yU5h6oULc0ZezZ52tNg79R2qRGPi6kZet0R7Ie7Jy0eXgQQ3Q0Vp4LFNYGvzvUXp1U6M4aPmSeWkXAZLCgjhCMsv2TSfH9YMak+1lZihM3mpAhrADKU+6cwopQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(7416002)(86362001)(83380400001)(66476007)(66556008)(4326008)(66574015)(8936002)(54906003)(36916002)(52116002)(316002)(6486002)(508600001)(6512007)(9686003)(26005)(66946007)(6916009)(33716001)(2906002)(186003)(5660300002)(6666004)(8676002)(6506007)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6W+CVtm+h3vaegmZ8//M6rJNVaagkTEedXdBdPT282vKCY6WIiNAoBDpO6?=
 =?iso-8859-1?Q?4wv6Mcm+GBArjdmKrNebz9ZjK9TS5QyUQeCBEG9Hay59KJoFTSn49YBdMR?=
 =?iso-8859-1?Q?JdvyMMF5gJa9WFQDhmAYzLLJFHqDLvcfAsgpIdHtBpJULSamswwOepFUa6?=
 =?iso-8859-1?Q?NsbDQu/fr3PhmA32k7zEYxLzsQTedPN8k5+Dq9O6fm6Ei4ev+r9mXBzmJy?=
 =?iso-8859-1?Q?/540T2L9kZdXtXiQa3HkDa5jGYFGBbuzthfV6cDjnRCok4zZZ4ZeWLZ36l?=
 =?iso-8859-1?Q?2HyJLE3KoBfuDXWdOELjS1WsjUO4mnv8Lxzb+wEWt+NpAbW2cGl+QRZaN+?=
 =?iso-8859-1?Q?Cy5u2h6ZSDYgmRJG2e1SC7+gm55d3/2r0T0opRUGukg53/cmk75oCPIHZh?=
 =?iso-8859-1?Q?StvkCfDr+eqsQMvTr5rT2z5BCFaPKGNxFVwcjgTnnkAjpzmdRKdrGCQAoe?=
 =?iso-8859-1?Q?fCjMmOrfagLNVwIhxcnQHW50gYCLK1X7ly97qsQ9SyMYBPO1VgU8oCddof?=
 =?iso-8859-1?Q?KVpJZXxPiQD91CATM2BThnQKjNNsXqGj4k0vxCyD1RTCSuuNrO9EiA9jg4?=
 =?iso-8859-1?Q?gHL5LuOpgj1oMR5u3kRp3GkXFSXV6gr67ulrD8uqt+0cwwO5cN4MABbOBb?=
 =?iso-8859-1?Q?JHRerLJVVg5lJEIGPJ4qOfIhPNPvTK2aTvSeGen5pD3qFprsBcheEr3J8I?=
 =?iso-8859-1?Q?Z4kzV79KUIg8ZrMfYX9CdtDu6ndV9zIBvrNb42k5D/Kv/+j8azNVioTQ42?=
 =?iso-8859-1?Q?yylUoCSs/uzlOuCTPuvyamvnPcIriJsito8d2X1Fo8m17Z9XiykFJcAjwl?=
 =?iso-8859-1?Q?kclBsUjQqdP92F1N6P3Wiq/nUzY6fkPNDYkQaLKO8+Qy7MURUANSObP/a4?=
 =?iso-8859-1?Q?U/Qln0nKkL8r9Z/kEoETatNmAm7Wb4KpAfBWiMOl4AKe88RPCUwglrJRo6?=
 =?iso-8859-1?Q?t2VdcFfV6H9v4j4FFoqHxTru+BTElphK7GGCBwj8yJO03ZyKFlvc31jFgZ?=
 =?iso-8859-1?Q?x5lKleX5ctQZOaXkBgAWxEoWNBVyd9VjBxvXG2rF/HTHEjvOGRJ/b81wNF?=
 =?iso-8859-1?Q?BFX7MB7XmVDcuLUq8rPaTrVrhaRME1sNgTt2luay47vuvXmrFjfo7J9rU/?=
 =?iso-8859-1?Q?bTwppz+bRyKQWuhOGhNMq4gOz+ValCXD6agDQlUMVuGJk7Av/1pQ/lc8yL?=
 =?iso-8859-1?Q?aCGs2pSdKoIY5RZ7j//r7bpVB/KzGrDBCDS9bdALgMIdkGpmPfQSvytL4i?=
 =?iso-8859-1?Q?HMmiJr03Po/Mjf+OCp+oTuE9OoOxeF2DoBo+SJqHh23WjVxO4608SrMvdf?=
 =?iso-8859-1?Q?DBhSa3R1aJwzjzr7IVbzqpILXncPPgmzwmOGvIUf+EhunYFwEDUdA47mtK?=
 =?iso-8859-1?Q?GjwaXu4rVr?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796c1a53-4aa4-459f-27a0-08d984eea79c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:18:00.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZH/uR9DzKeKwfTmQrwSGlTPey9MLEFHIrZ0JGcp3mhxfqoXBN1/MK0AxsK6HCpA5VcSQHG9nUw2nAgJJog8rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5593
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 1 October 2021 11:55:33 CEST Kalle Valo wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> [...]
>=20
> > --- /dev/null
> > +++ b/drivers/net/wireless/silabs/wfx/hif_tx_mib.h
> > @@ -0,0 +1,49 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Implementation of the host-to-chip MIBs of the hardware API.
> > + *
> > + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> > + * Copyright (c) 2010, ST-Ericsson
> > + * Copyright (C) 2010, ST-Ericsson SA
> > + */
> > +#ifndef WFX_HIF_TX_MIB_H
> > +#define WFX_HIF_TX_MIB_H
> > +
> > +struct wfx_vif;
> > +struct sk_buff;
> > +
> > +int hif_set_output_power(struct wfx_vif *wvif, int val);
> > +int hif_set_beacon_wakeup_period(struct wfx_vif *wvif,
> > +                              unsigned int dtim_interval,
> > +                              unsigned int listen_interval);
> > +int hif_set_rcpi_rssi_threshold(struct wfx_vif *wvif,
> > +                             int rssi_thold, int rssi_hyst);
> > +int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
> > +                        struct hif_mib_extended_count_table *arg);
> > +int hif_set_macaddr(struct wfx_vif *wvif, u8 *mac);
> > +int hif_set_rx_filter(struct wfx_vif *wvif,
> > +                   bool filter_bssid, bool fwd_probe_req);
> > +int hif_set_beacon_filter_table(struct wfx_vif *wvif, int tbl_len,
> > +                             const struct hif_ie_table_entry *tbl);
> > +int hif_beacon_filter_control(struct wfx_vif *wvif,
> > +                           int enable, int beacon_count);
> > +int hif_set_operational_mode(struct wfx_dev *wdev, enum hif_op_power_m=
ode mode);
> > +int hif_set_template_frame(struct wfx_vif *wvif, struct sk_buff *skb,
> > +                        u8 frame_type, int init_rate);
> > +int hif_set_mfp(struct wfx_vif *wvif, bool capable, bool required);
> > +int hif_set_block_ack_policy(struct wfx_vif *wvif,
> > +                          u8 tx_tid_policy, u8 rx_tid_policy);
> > +int hif_set_association_mode(struct wfx_vif *wvif, int ampdu_density,
> > +                          bool greenfield, bool short_preamble);
> > +int hif_set_tx_rate_retry_policy(struct wfx_vif *wvif,
> > +                              int policy_index, u8 *rates);
> > +int hif_keep_alive_period(struct wfx_vif *wvif, int period);
> > +int hif_set_arp_ipv4_filter(struct wfx_vif *wvif, int idx, __be32 *add=
r);
> > +int hif_use_multi_tx_conf(struct wfx_dev *wdev, bool enable);
> > +int hif_set_uapsd_info(struct wfx_vif *wvif, unsigned long val);
> > +int hif_erp_use_protection(struct wfx_vif *wvif, bool enable);
> > +int hif_slot_time(struct wfx_vif *wvif, int val);
> > +int hif_wep_default_key_id(struct wfx_vif *wvif, int val);
> > +int hif_rts_threshold(struct wfx_vif *wvif, int val);
>=20
> "wfx_" prefix missing from quite a few functions.

I didn't know it was mandatory to prefix all the functions with the
same prefix. With the rule of 80-columns, I think I will have to change
a bunch of code :( .

--=20
J=E9r=F4me Pouiller


