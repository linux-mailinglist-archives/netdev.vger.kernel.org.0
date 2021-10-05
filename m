Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BA942207C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhJEITe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:19:34 -0400
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:9056
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232511AbhJEITb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 04:19:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftp0XLntKiv6o1osXULF+vlIjCW2B6vw326X2ysvVmJyxNB1AK0hA2k/gmgh0gLPf6Ja2KVPl65mUAz/AfKs1mL2KMRfsGv4mvhV5yVCAQr+Fl/gcws6HEeRgslGeGGw35kqRKJ/WfSm+n3jETuA3j/yNtPX61BH7QFHXA10ObNA7RgWmIQMUELz/gGF8flezFbRNGnAR/5o1h+Djsk475Dpbg1EfyyNs6PbNYnXw9QltG7uGWG3N7vGTBePhfFGTQPsErTYJnPne62F8ys6oxwyH2iUVGbFpQ7EtHcK1Gn8NdtN/RL6qOLim56heibmWusAbnMHFF8jd0OhXi6h2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOGjEkx/v+C1TFy5tZZ5zQm6Yfn571UtnzElhfm+X1c=;
 b=Jf5SWe0oCEWb4GvNNSGeXpN1rd5R3KecS/hcuK/uKl0jH1KSQ2UB8L49D5ZqBj6JhcP7D/wZoU81Nqs2CHDNOgfuaiK7oLCyJvJV9wHg1kUqlnnGj06D/B50Ifb9TClQz+9fRpggIi0X3I/ArhMrM7p019DEPgs4Sa2cC2fATaekKMl35VHO29V7hbCYBi3/7LSQvfwYOEruaF+ZbHqdTvsbolRymxXun9Y0OlRcPVr1/7gHRdmXN/bw+QASA1l4q4Bh2EEnvwy+eHq2wsFMTMYrXEUaqgkv0Xs9d7YNlm6heuAjf4iHYMrgXjHHs1qyTbLut8UMBjgDuLpuMGqIuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOGjEkx/v+C1TFy5tZZ5zQm6Yfn571UtnzElhfm+X1c=;
 b=VZT7STjcqHDFLClT7KZsjM+yXKhS0DPmoLR6cZ0TOWkb7WrigF2q3rZqSS2SIzKXAiM14oX0yQ6SiQH+tZF3GjqnEM9WkL+GPbBK9wNh/KqQG+DQwaT1qvskYhG9l7NSGruHjlQh8kCZviWPr9cQCPCaJ5tWdWjZyvwO0Wvhqow=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 08:17:40 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 08:17:40 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
Date:   Tue, 05 Oct 2021 10:17:32 +0200
Message-ID: <36155992.WRNEVsFkd7@pc-42>
Organization: Silicon Labs
In-Reply-To: <87tuhwf19w.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20211001161316.w3cwsigacznjbowl@pali> <87tuhwf19w.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0065.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::12) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0065.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 08:17:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79323087-bec5-4288-b926-08d987d8991a
X-MS-TrafficTypeDiagnostic: PH0PR11MB5627:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5627A46C3DD9A588BC25794C93AF9@PH0PR11MB5627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjlkflE2fut+k3jlhJNtvgMsIGAqYFARStE7AwNDNB2tWW7JmWAejWLcUEdKh2ho4qfFeJyzYL1ZlSYA2fK/KHr5SvC4npLGN4shHGveObsk/jLqoc5NfJKaHHZcLP7dpLdx1SOCSxnw5xu9xNwPTi65Qh+C+oooV3f2wrVgPkjTQHM/RCZzmQMy5swGJYX9UmLrEicaj//b/ZV0MT/uUsjiNS9h8W5gSMm+YN2n5cJz9Ab5z7DgEyjfPM2U7zompoffJdD43fjcfajAgc3DLJtPxXYcVuwXk4APaOC3yvh5yYj958dM2QaWlmOlbZWeWbYhWw3kf++f7W/VWwNorOwT9fiyu+vtniiVPnNkxGA6WbVe7CVyX7yhDrkL3YELzMihpoy3JVUMhl1miwlRob+iGorHNOzD+nW0PnuengKUWRejErSrJRCV2hhVrWacckofwlhwZCEC7vNz/GVIY4Ayep40kAeFs95nphtvDnM1AQy5S+NX6CbhCYvkR0v7eVM6JTOHJb8NKZ5hM3PFTZKwQFO2JiVDGeft7RkkvVM3oift8bm7cG9WPIsWlDdYgdPU1OVpmByyG/XL9fMLgn+AbY7JbcxBbaMsSpBOWO3T0NWhNJL5YactLewT6CrGx8HnYC9eEnAWSIitAfPK74XdMopxSWGO4EUUxzpEHaxAF2txdr5V7MKeUotgnVtHK9xgtyLOHAb3FF18YryWO+I4lx4+DP4ZQrY8kA8wk6g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(33716001)(508600001)(66476007)(66946007)(8676002)(36916002)(66556008)(316002)(4326008)(26005)(6666004)(2906002)(5660300002)(186003)(956004)(54906003)(110136005)(6506007)(7416002)(6512007)(38350700002)(86362001)(6486002)(83380400001)(66574015)(8936002)(9686003)(38100700002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VPWDoRj52Ag4N5zDwyGM7Kc5nxb0rl//RyRqjDvXqqE3Ith9tmGCgzz6hW?=
 =?iso-8859-1?Q?4eddgd5uq/uRYzLd1I5v3CkECJ0A9bC1hzg1bp8BkfwBC9EtDxe1yNQYTx?=
 =?iso-8859-1?Q?oV9uZRIH5nX8VFIgYtCfzDa4bS5m5eeqNhWei6/7pnMVrFLZz430EyFjUG?=
 =?iso-8859-1?Q?6OYt/BBOcAwzw2S4YweEAyu28Lydrpw2o4fovM8L3LkWnhb08bnjI2JbP/?=
 =?iso-8859-1?Q?ODkuyk2RfZDwrFwnFe7br4lmiSMeUTANv3zRRfIsIExOUBpnSylCKj6Lmb?=
 =?iso-8859-1?Q?vkVqjXkwaZEEkI28ppijIv9NOcjFYeCuPRCp82RXEBj1WggBwbnphAVBuk?=
 =?iso-8859-1?Q?qspJ1gPyx1nNWrscnWvm7I3MZFIKp+Ge6xFK5FeLD+5en/ZDz+EO2trOHN?=
 =?iso-8859-1?Q?awRTEwsQUmxPBGf99fVkSB3S0TVYjWaBAiW6dNACVncdrOdkuFfyiFAN2R?=
 =?iso-8859-1?Q?R9+XP9I0i1aawZy8hPdvm+IUpl3lQr61o+GCsCYMU5jSgz/aptYII1KlK3?=
 =?iso-8859-1?Q?Qlu0hshG1d01VheMQulVG+mDbKFSbl407YY6fLPoBgbI6gbK3H55bw0YU5?=
 =?iso-8859-1?Q?i6+QuCxh5vEmCQAMSfrZ6Pgnk7XfN38pd4juAf36m2fd7K9xcXS3JLwLmZ?=
 =?iso-8859-1?Q?cbAaZ0S/Q1YAJlK4u06JkstrRB2UyjBbUGIwwO+LZhBC4T80a9jm8gWMy+?=
 =?iso-8859-1?Q?fqeqLlOMZowQqRRzqe7J1cEKSaYSuFFti4Er3OIBHRkrjurvCV9ZquN83O?=
 =?iso-8859-1?Q?DkiSBq41Kr4KMhV+L3Cuk/iwLkl3hLVnHQ1ohEdqBq+NDu5IwIBkX6iakE?=
 =?iso-8859-1?Q?XqKW1XO1QHUs5J3uxpBie92PZZH1JmFegKvfLtC8ONGURGklMM6pc3Erux?=
 =?iso-8859-1?Q?dmdcrlqEcjCpj0qL5M1tzXDkl33fiQ83Zwgvk+fn4eTBONAXf6nXdjKc04?=
 =?iso-8859-1?Q?3j8QhKvWTJarBpG1flI+TWJGooHCseQdtIv1PpNNmkeI4PBhNFopDdAHBW?=
 =?iso-8859-1?Q?hq3NX3/+ycNihXiOmvU039ovX5pzDrzHQB45ezePJyYT8fX2bGGkK5rCIu?=
 =?iso-8859-1?Q?MvUxHcPQWTX2zghVCQYwwo6Q6xCXrq/d5op+X+3G5F+2FjgPhXRP/8+O28?=
 =?iso-8859-1?Q?bZC14li6rvc4XTaAY7U5UjeBKgOAkm6lGmymbY4aNIr1wjdOx8TnBHR+2R?=
 =?iso-8859-1?Q?HWbYZltaZfR0NSXFgdd1NuwaHHXsKiRj34/qCY3l2PgUxBRtQZ2BhUYCJ3?=
 =?iso-8859-1?Q?2notQpcoOtamJaVvCzcs6zjP6KfBjdJ5l3Rzk4DvYMl+QYVh8X1uiTkowV?=
 =?iso-8859-1?Q?iu/rIHKM6KV2caEIAswes1eVptOZsU0geyN4BsINridTt8O8+R0Jeh8bZp?=
 =?iso-8859-1?Q?HcGVfXKJTj?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79323087-bec5-4288-b926-08d987d8991a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 08:17:40.4680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzIgkPypZ1O6iepLJK+p85Mg31BmcKq3f2cX7ezMHc3kSZ1KMeCwUOF7tIASe1UTIByOkcuS31DSwXHxcMf8ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 5 October 2021 08:12:27 CEST Kalle Valo wrote:
> Pali Roh=E1r <pali@kernel.org> writes:
> > On Friday 01 October 2021 17:17:52 J=E9r=F4me Pouiller wrote:
> >> On Friday 1 October 2021 11:55:33 CEST Kalle Valo wrote:
> >> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >> >
> >> > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> > >
> >> > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> >
> >> > [...]
> >> >
> >> > > --- /dev/null
> >> > > +++ b/drivers/net/wireless/silabs/wfx/hif_tx_mib.h
> >> > > @@ -0,0 +1,49 @@
> >> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> >> > > +/*
> >> > > + * Implementation of the host-to-chip MIBs of the hardware API.
> >> > > + *
> >> > > + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> >> > > + * Copyright (c) 2010, ST-Ericsson
> >> > > + * Copyright (C) 2010, ST-Ericsson SA
> >> > > + */
> >> > > +#ifndef WFX_HIF_TX_MIB_H
> >> > > +#define WFX_HIF_TX_MIB_H
> >> > > +
> >> > > +struct wfx_vif;
> >> > > +struct sk_buff;
> >> > > +
> >> > > +int hif_set_output_power(struct wfx_vif *wvif, int val);
> >> > > +int hif_set_beacon_wakeup_period(struct wfx_vif *wvif,
> >> > > +                              unsigned int dtim_interval,
> >> > > +                              unsigned int listen_interval);
> >> > > +int hif_set_rcpi_rssi_threshold(struct wfx_vif *wvif,
> >> > > +                             int rssi_thold, int rssi_hyst);
> >> > > +int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
> >> > > +                        struct hif_mib_extended_count_table *arg)=
;
> >> > > +int hif_set_macaddr(struct wfx_vif *wvif, u8 *mac);
> >> > > +int hif_set_rx_filter(struct wfx_vif *wvif,
> >> > > +                   bool filter_bssid, bool fwd_probe_req);
> >> > > +int hif_set_beacon_filter_table(struct wfx_vif *wvif, int tbl_len=
,
> >> > > +                             const struct hif_ie_table_entry *tbl=
);
> >> > > +int hif_beacon_filter_control(struct wfx_vif *wvif,
> >> > > +                           int enable, int beacon_count);
> >> > > +int hif_set_operational_mode(struct wfx_dev *wdev, enum
> >> > > hif_op_power_mode mode);
> >> > > +int hif_set_template_frame(struct wfx_vif *wvif, struct sk_buff *=
skb,
> >> > > +                        u8 frame_type, int init_rate);
> >> > > +int hif_set_mfp(struct wfx_vif *wvif, bool capable, bool required=
);
> >> > > +int hif_set_block_ack_policy(struct wfx_vif *wvif,
> >> > > +                          u8 tx_tid_policy, u8 rx_tid_policy);
> >> > > +int hif_set_association_mode(struct wfx_vif *wvif, int ampdu_dens=
ity,
> >> > > +                          bool greenfield, bool short_preamble);
> >> > > +int hif_set_tx_rate_retry_policy(struct wfx_vif *wvif,
> >> > > +                              int policy_index, u8 *rates);
> >> > > +int hif_keep_alive_period(struct wfx_vif *wvif, int period);
> >> > > +int hif_set_arp_ipv4_filter(struct wfx_vif *wvif, int idx, __be32=
 *addr);
> >> > > +int hif_use_multi_tx_conf(struct wfx_dev *wdev, bool enable);
> >> > > +int hif_set_uapsd_info(struct wfx_vif *wvif, unsigned long val);
> >> > > +int hif_erp_use_protection(struct wfx_vif *wvif, bool enable);
> >> > > +int hif_slot_time(struct wfx_vif *wvif, int val);
> >> > > +int hif_wep_default_key_id(struct wfx_vif *wvif, int val);
> >> > > +int hif_rts_threshold(struct wfx_vif *wvif, int val);
> >> >
> >> > "wfx_" prefix missing from quite a few functions.
> >>
> >> I didn't know it was mandatory to prefix all the functions with the
> >> same prefix.
>=20
> I don't know either if this is mandatory or not, for example I do not
> have any recollection what Linus and other maintainers think of this. I
> just personally think it's good practise to use driver prefix ("wfx_")
> in all non-static functions.

What about structs (especially all the structs from hif_api.*.h)? Do you
think I should also prefix them with wfx_?=20


> >> With the rule of 80-columns, I think I will have to change a bunch of
> >> code :( .
> >
> > I think that new drivers can use 100 characters per line.
>=20
> That's my understanding as well.

:)

--=20
J=E9r=F4me Pouiller


