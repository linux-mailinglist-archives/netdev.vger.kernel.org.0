Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0404221FF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhJEJUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:20:45 -0400
Received: from mail-dm6nam08on2044.outbound.protection.outlook.com ([40.107.102.44]:31994
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232478AbhJEJUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 05:20:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFzx7VpTp7mvRMiWcYzA0dEJmNp5ygNKfY7qGNxG3i65hLr7SR2swueGdPUbg2BQmPPfL9k2b3pAC5C1Ya7aET9jNmPvHwR38YciD+E63LAgD3UL2322kXh7/IG76cEkNZKwV51exTIq0e2ZaEd+f60cABbVpee+OBOoFIInaaZT4ZwJ35ZQ+ZpFi/LUpC/jDGFUnGJavmIzzvGEevMnSPx6LXbuwmDUs0zQBNndWfREG9uW7MHkzBkabUDE4lN4e+6AcIiKmO9DxiAUOSBT9mB9A2fakAQDZgh6SMN7VpwnmAqVvxZXsNKrkGZEa9eIAynuHqQcftYRWQ+fLcU2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xd2rc9Rns02J4L6pGxUEphajjqcaDZYT4pLBUhrMfPM=;
 b=GA7K/DmDV+unjvnEfn+E3yA+aqBi40Q5pH7Utk4Dza2opEC67tpCUJGxtfrsCBXHAxZWFs1PHTc2U2Zn8JbUVRx3W39SKusByEFw08tEaRwfmtQurIVxRJim0GFZQFS1LHVkobFhehi+ycC26SWhrWAfPMP99EHDPnRzS3+mVyFwo8zlg/xSPv9ayRCPsnCBUAPWU9oZeRGhekSJHBcONazMuV2b4Gb0Wx7WvWOefzmEJOGakl8P2srwd4504Jz0nFAUeOXEFy/wRDJTVd+aZ6EqFV395Nwex5Q2CLfFbG8BVAyQQRfYFvcrkhMN32+PFiJHfjw3geZr5tLhLgUv5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xd2rc9Rns02J4L6pGxUEphajjqcaDZYT4pLBUhrMfPM=;
 b=DgVBUyNgKC6LSig19JAJhKNAlQeHRFKVCFfVpus0r45cVpORtqOc2681g4zwUxBne4DjzfHqP71WjKd3zz8gtW5kcADDMvazeCwXI6LM8imbZ13Qb3yktFtqJ0Tb1xCdMScce0SpW4iqa8CbShMU9b8wVYppw9qLcD3rTJSSLnA=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5595.namprd11.prod.outlook.com (2603:10b6:510:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 09:18:51 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 09:18:50 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
Date:   Tue, 05 Oct 2021 11:18:42 +0200
Message-ID: <3256127.6qxvVGrUKR@pc-42>
Organization: Silicon Labs
In-Reply-To: <YVwLB02y67JOvoth@kroah.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <36155992.WRNEVsFkd7@pc-42> <YVwLB02y67JOvoth@kroah.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAYP264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11f::11) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAYP264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 09:18:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1871129-d99c-4406-694c-08d987e124dc
X-MS-TrafficTypeDiagnostic: PH0PR11MB5595:
X-Microsoft-Antispam-PRVS: <PH0PR11MB559565BC9D2FB72797C42BC193AF9@PH0PR11MB5595.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c36K92m55EoogVbWT5G56VIoBXdS1paiG+wgKfeimJ5lEb9O9nPPnXxUB5BZtSQAqKxrqXouOhNN+DJ6EiNZORmAm8oazL61iXFvd6L/6S/SWKdOG/ZdA7OE+M0uDw0wB+epNtgJ+EH0W19tNfPcOB2+QNeOOe6RoYxACQzIdp0VFaZNQtIsxFD4ri6I8HKKyUh8d0kS0PD6BXheUOSK5E7u2dFdfdLpW446wUjepNxoKRCSWTp5iH6QWrgDlfPNvcdHHWCtXk03DvPcK2oOW+k0bj5cLnoebxmWxNH0ze4mOnso0umXazQg28ILrtmaPEp/8W4+67hiMstBl61GRkTq5rau+ZavHS2sLMwbL35d4E27OmFkhQN2wvDCWZDG4ieUe/dRw5oYB6acbqfIfUVNAfKvIcmXPfMLMMoJgVFpFMjV0gsVeJdLxrLbAyq0MEwNDIS5ctZra1zo90JvxTwFGi751GwFYFBjudEggFReyqPjWP43A/eBO9CdwMFGB0NQ6hXEnIqFmTDFriI3hsMDCurWdaWRW3KoOrtcnCMV5GcI3Hw9QvP8sE6t0pj64KU9yXG0pjaXCDEh3Tx5RLzMr1w3ElAl2YprwvhjWXSAG56BgKE6ICKjnZLhC82vE0niyKSqF9juciaXPZaF6Ulv6qSsFkdh/dMhChSwsdBu2/drEbXFA0I4zsIDx+ekIHqpWZvn5jA+LykW8fMBmW6OgJHxKs7n3MDXBT3ay2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(38100700002)(83380400001)(9686003)(8676002)(7416002)(6512007)(316002)(86362001)(4326008)(66574015)(5660300002)(26005)(52116002)(956004)(33716001)(54906003)(66476007)(6666004)(2906002)(6486002)(66946007)(6916009)(66556008)(38350700002)(8936002)(6506007)(508600001)(36916002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?maPzBPMe9fT79zwzjoS703gkfM+/zVQfucN1U6+ZUK1fzjRCaX5YjlTJtN?=
 =?iso-8859-1?Q?QZScueNi9o15IIltN78YSCHsW9A0tr5XrUGwBnYwkM/tnTAGUU6n6IL2W+?=
 =?iso-8859-1?Q?MRAnqnKOIH10eXgmddWTC7TakjYFOvVhTUs06FlsSPvCbxFcIZar7v8gJZ?=
 =?iso-8859-1?Q?oXymhhz31soqdevC/MImBjqo/cEbw6RoZvQZ4CLcs3QXJ9HwFWAk0Y/78R?=
 =?iso-8859-1?Q?43wd4qBZPv+qi+LY8EWZQGQyfQrvSsjLcCgO5jErjpHBUyGYMiB4caO4Bz?=
 =?iso-8859-1?Q?dgGF1OdKF+TbeU7Wc9pFxBiPAhuQ48xLlAPz7TZaY9ku4TUMrEcB3tCO89?=
 =?iso-8859-1?Q?AnQfBXhE13rkdrZZuz/YhruJJJj3JGIHq0RjPbWIzRGDzKK/lJdJXL4XF3?=
 =?iso-8859-1?Q?XJGulQPrRRlrM/S4C2Ih7PukdYJvGEBHbC8qsNk0PTcOzMkAMAdzaBw6n3?=
 =?iso-8859-1?Q?FdTmmuNA/2ZKKXgZQ8cjSRjMAE/pxkDtT5eD6R+0z1CtE7Nl2ASBqpI2qh?=
 =?iso-8859-1?Q?5xFP0uaZzHwAapwMMjE+mhwPvdCCv/OBzCRjnA4oh9/WSpGCdUHBSZCOSX?=
 =?iso-8859-1?Q?8vpQEH52ygPsPfFtImKmG6F34+V/8XhV4xNhrDGQ7B4u3IlabE95JoxYh/?=
 =?iso-8859-1?Q?p31Zv9ug94wTco2oE8HqpmXC73OaF08qHVXPRCNKU1HWGaYiCo4fVChc2M?=
 =?iso-8859-1?Q?ndQo9++QTuXnFONJTqcu1fec4zDPIhxfU3uRnlMkWvZy7JSNNeml5RZzQW?=
 =?iso-8859-1?Q?3ypZ7PD4ipe172WQo8rRhTgXx5A7qdhZZVpIXEu9kQH07wtYcAAvm4fu2c?=
 =?iso-8859-1?Q?K0J6zjyQRpG4blLt4pSKCVowboddY2yHe9ziffYW7xT7Xs+l7Jwm+ohGkF?=
 =?iso-8859-1?Q?lUPDs5/0SIg9EzKIIIbBXDCxVcazJYw6T1CY3ZHFrhNBy9hHyVDhNdtMmN?=
 =?iso-8859-1?Q?b7uEwbpERnx7KkeovWNKCKkR+KH2D/119AYs/aagpK0vBbTMIAXjoyjx0+?=
 =?iso-8859-1?Q?518/ixd5GduAaQVzNtnb6UMMJam76FNiWk3PlMQLMfUNCec2F6uqQl/HUl?=
 =?iso-8859-1?Q?ouRpr9C9vQ1jrR7ChhjkoC8wXhZlURGH4RmwZuv6wf0ZEr0m6J5VTXnK2x?=
 =?iso-8859-1?Q?2FfaHqFBij2R0PGVgLvwbEppeC0Sz8+NYmsPx8hviKXWoCDh63RGKQ9oFv?=
 =?iso-8859-1?Q?km89FchVsor1V0dJhphI/ruqKtmnNwtLSLsVtXZ4sPu1LTzj/PcNEWVrW/?=
 =?iso-8859-1?Q?kHQa2u0YIF7Xw8XDiOcQ1PfDGKKiU/2zdVlzTcDU2UbAgo4hhiUDoIYBcc?=
 =?iso-8859-1?Q?7sq4qBo4nsN+2s21sdRzUCIaD5W2gT23APfwiKr7ZZA9BZHTzAc1AjyEha?=
 =?iso-8859-1?Q?N0t7CsDoUW?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1871129-d99c-4406-694c-08d987e124dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 09:18:50.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o2/eETphrUEf/qvZiU6mpWrH1HuA+serCWVA/YW1yrFGcOkRRyHySTYeXIFejqUVjmci8c3uFtIyomtYz+oVig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 5 October 2021 10:21:27 CEST Greg Kroah-Hartman wrote:
> On Tue, Oct 05, 2021 at 10:17:32AM +0200, J=E9r=F4me Pouiller wrote:
> > On Tuesday 5 October 2021 08:12:27 CEST Kalle Valo wrote:
> > > Pali Roh=E1r <pali@kernel.org> writes:
> > > > On Friday 01 October 2021 17:17:52 J=E9r=F4me Pouiller wrote:
> > > >> On Friday 1 October 2021 11:55:33 CEST Kalle Valo wrote:
> > > >> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > > >> >
> > > >> > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > >> > >
> > > >> > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com=
>
> > > >> >
> > > >> > [...]
> > > >> >
> > > >> > > --- /dev/null
> > > >> > > +++ b/drivers/net/wireless/silabs/wfx/hif_tx_mib.h
> > > >> > > @@ -0,0 +1,49 @@
> > > >> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > >> > > +/*
> > > >> > > + * Implementation of the host-to-chip MIBs of the hardware AP=
I.
> > > >> > > + *
> > > >> > > + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> > > >> > > + * Copyright (c) 2010, ST-Ericsson
> > > >> > > + * Copyright (C) 2010, ST-Ericsson SA
> > > >> > > + */
> > > >> > > +#ifndef WFX_HIF_TX_MIB_H
> > > >> > > +#define WFX_HIF_TX_MIB_H
> > > >> > > +
> > > >> > > +struct wfx_vif;
> > > >> > > +struct sk_buff;
> > > >> > > +
> > > >> > > +int hif_set_output_power(struct wfx_vif *wvif, int val);
> > > >> > > +int hif_set_beacon_wakeup_period(struct wfx_vif *wvif,
> > > >> > > +                              unsigned int dtim_interval,
> > > >> > > +                              unsigned int listen_interval);
> > > >> > > +int hif_set_rcpi_rssi_threshold(struct wfx_vif *wvif,
> > > >> > > +                             int rssi_thold, int rssi_hyst);
> > > >> > > +int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
> > > >> > > +                        struct hif_mib_extended_count_table *=
arg);
> > > >> > > +int hif_set_macaddr(struct wfx_vif *wvif, u8 *mac);
> > > >> > > +int hif_set_rx_filter(struct wfx_vif *wvif,
> > > >> > > +                   bool filter_bssid, bool fwd_probe_req);
> > > >> > > +int hif_set_beacon_filter_table(struct wfx_vif *wvif, int tbl=
_len,
> > > >> > > +                             const struct hif_ie_table_entry =
*tbl);
> > > >> > > +int hif_beacon_filter_control(struct wfx_vif *wvif,
> > > >> > > +                           int enable, int beacon_count);
> > > >> > > +int hif_set_operational_mode(struct wfx_dev *wdev, enum
> > > >> > > hif_op_power_mode mode);
> > > >> > > +int hif_set_template_frame(struct wfx_vif *wvif, struct sk_bu=
ff *skb,
> > > >> > > +                        u8 frame_type, int init_rate);
> > > >> > > +int hif_set_mfp(struct wfx_vif *wvif, bool capable, bool requ=
ired);
> > > >> > > +int hif_set_block_ack_policy(struct wfx_vif *wvif,
> > > >> > > +                          u8 tx_tid_policy, u8 rx_tid_policy)=
;
> > > >> > > +int hif_set_association_mode(struct wfx_vif *wvif, int ampdu_=
density,
> > > >> > > +                          bool greenfield, bool short_preambl=
e);
> > > >> > > +int hif_set_tx_rate_retry_policy(struct wfx_vif *wvif,
> > > >> > > +                              int policy_index, u8 *rates);
> > > >> > > +int hif_keep_alive_period(struct wfx_vif *wvif, int period);
> > > >> > > +int hif_set_arp_ipv4_filter(struct wfx_vif *wvif, int idx, __=
be32 *addr);
> > > >> > > +int hif_use_multi_tx_conf(struct wfx_dev *wdev, bool enable);
> > > >> > > +int hif_set_uapsd_info(struct wfx_vif *wvif, unsigned long va=
l);
> > > >> > > +int hif_erp_use_protection(struct wfx_vif *wvif, bool enable)=
;
> > > >> > > +int hif_slot_time(struct wfx_vif *wvif, int val);
> > > >> > > +int hif_wep_default_key_id(struct wfx_vif *wvif, int val);
> > > >> > > +int hif_rts_threshold(struct wfx_vif *wvif, int val);
> > > >> >
> > > >> > "wfx_" prefix missing from quite a few functions.
> > > >>
> > > >> I didn't know it was mandatory to prefix all the functions with th=
e
> > > >> same prefix.
> > >
> > > I don't know either if this is mandatory or not, for example I do not
> > > have any recollection what Linus and other maintainers think of this.=
 I
> > > just personally think it's good practise to use driver prefix ("wfx_"=
)
> > > in all non-static functions.
> >
> > What about structs (especially all the structs from hif_api.*.h)? Do yo=
u
> > think I should also prefix them with wfx_?
>=20
> Why would they _not_ have wfx_ as a prefix if they only pertain to this
> driver?

hmmm... to keep identifiers small and readable? I find
"wfx_hif_set_tx_rate_retry_policy" a bit long.

Don't worry, I don't want to debate the rules. I am going to apply them.

--=20
J=E9r=F4me Pouiller


