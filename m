Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F305197FE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345323AbiEDHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345341AbiEDHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:25:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7587023153;
        Wed,  4 May 2022 00:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzEb43ABQ3ddRTHXyR9mkGSYD3j/thZkYuAjW3DedRosbbvZ/NNF7Bk180txwhxH4NwpJh0LGZViF7OMqMg7KBQLXLvyBlHsxAZGJIw2P+ooQ7alXYQnbkOJTTasOkyQsLARtX6I2kt5S4pBgOm2BMvIWuj/7DjT7+qXM7/rB+gRCsvkWlxPHgfKrVjY6SYjPZmzWQoyOB1nvakheUxxY6w2JyLlM7SELaueiH6/hd8h/+ac0LFNpoZwBYxnEwsfiBhIyLmzHwcGSiy7IV40TrPyMAsbUetF5rob1sAGOGzgi+hlzewuLpPOEQhm/PxfmKaGLinNlq0rwWrLZ8NzVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60YjqTa2+342NhJqstej3/N9FKl3FxD9uzekDxGCKik=;
 b=F73Q/fhkjPQ+ZHbbTvQkiCP1+nOa/dbZsYbDT2viTxxfiy56p00KjARpfGQzb7QEuYaGdQJY/N+Uf4mxSxIqQbiro64fdZu3PGz7k+NvCvA0KbFHFq6FKt/x+ZAAM/160Zj6Exb4bR3YRb1BCv1fEIrLww/jMNo1Vuhk41suGmQ8FUK05vFJSg4xUgxcJ+NiUOSe9LQp1a9Y8ASO1u5mMPkFOzKI+EuaLUh09Wvmot/jvH+mf1y5BLP5XJ2OecoDSW5wPnYo9iDCSLHeSW559CT+6ZU/DcDZrd/k38QVbpTWIL52StuxMQNZJHoz3nR1DprsUUd9iI4O4eVSMSvqOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60YjqTa2+342NhJqstej3/N9FKl3FxD9uzekDxGCKik=;
 b=Usv2ePNeNloLLwYt5VFrsnVG3eG5ZAG+QUx4nHOR6mni+G9qgXfn1ctYji0Upe9ziWcRk6Gh7iH4/XS6FcXdm2KpLeJhrLo2EPJFUlRXNjzqk+xp1So84bQcfv1XEwN8JBeby4ay7Qolzfz2ndlEdaUrhcCNZi87bqJRRYBW84c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from CO6PR11MB5650.namprd11.prod.outlook.com (2603:10b6:5:35a::9) by
 BN6PR11MB1521.namprd11.prod.outlook.com (2603:10b6:405:e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Wed, 4 May 2022 07:21:27 +0000
Received: from CO6PR11MB5650.namprd11.prod.outlook.com
 ([fe80::f4a6:5ef8:6a66:3251]) by CO6PR11MB5650.namprd11.prod.outlook.com
 ([fe80::f4a6:5ef8:6a66:3251%8]) with mapi id 15.20.5206.024; Wed, 4 May 2022
 07:21:27 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        outreachy@lists.linux.dev, Jaehee Park <jhpark1013@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jaehee Park <jhpark1013@gmail.com>
Subject: Re: [PATCH v5] wfx: use container_of() to get vif
Date:   Wed, 04 May 2022 09:21:21 +0200
Message-ID: <16415431.geO5KgaWL5@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220503182146.GA886740@jaehee-ThinkPad-X1-Extreme>
References: <20220503182146.GA886740@jaehee-ThinkPad-X1-Extreme>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SA1P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::11) To CO6PR11MB5650.namprd11.prod.outlook.com
 (2603:10b6:5:35a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3974d25f-be9c-4daf-9c45-08da2d9eb3c9
X-MS-TrafficTypeDiagnostic: BN6PR11MB1521:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1521FE342151F4C5DD97B1B093C39@BN6PR11MB1521.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcQQ9LS8NDiZsar5UtySNh2W2ugFWOQjU3qT8Kpb1VY9sdYfOSI1oxG7gdCT6rVCct1X0LiPCAB2qwpahtkwNaMBkGY7HpaaU36GbP+1QBCBL7FLh89hqwVVRf0rmGjQfdb1hiX1nj1RT3g/Sj7hzSfQ594CCj+K/GAvaPjKh11lt/ukWalYq6zDymZMDY3DKJAjVMV1ZHNNo16BSY6bNljjtzRoG/riue610nzbZefZInOt2b1TLDHhAkRp7IPE048MhKeeTgcvNrqD35um2yhpeBd7Ay2h+cLT7s7mkRj2jqDlmFQi37JIWues+U7b8BOqHmko4wl2pRNSxkZ1pGPMMcEuN2I3WoJiWJH2PebUg9jtwSWjzp6FJh6QKJRZUB/+cmauEdAZ8EaygbTD8FtVHfpJX8dkNaMzBGlXqCDg2zM4D3hQoacqqZ5l9zuxpyV0CjvsaN0YHYZuzuL9VUGVWKx9JLxfXXG2uIQp+4yZ5omh3uSNvMSIyNXG7uAdgQBLeAtG2XxpzyQ8QctDS1RdfoTZLZbiCiFX6/6pkz9FwyGqJd9GgtuurhRVCkA0l051PaIAgxM0imyQZpgHW4ny8jE84sWamZjTQqHwwaBfvymWsqL9xJG1lKpEUQBX6PEsAYVg7qGwskQfV391VHiEhuJ6XC4ozhec4wfFCNcsEOGopQ5KCt7cwFlmQXregsKODlJA0MKbFzjNYurFvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(5660300002)(33716001)(7416002)(36916002)(66476007)(66946007)(66556008)(508600001)(8936002)(8676002)(921005)(6506007)(316002)(6666004)(38100700002)(2906002)(6486002)(110136005)(83380400001)(6512007)(9686003)(186003)(86362001)(66574015)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?QXLNWOu0w3s72ekf2ht//bFtQvb5diDgeWnVJc5FqNnlmEu8eBzcO6r5wl?=
 =?iso-8859-1?Q?ltIZ1NHGXjIMfsTxO1751Ig+2wHpdjKmjK7bRyqrZfrkEI0nJrpjjK36+S?=
 =?iso-8859-1?Q?HGBEKGKGERhn5Ev7RFOd6K/HPwp2CwCFgbx0SauVTDefc0n3CTYv9CVhDZ?=
 =?iso-8859-1?Q?VSazdhBhJ9vzFMhgNlBVVvdVkabjjo4VVpwTa2ACdWBOWenK0fdPcRmcgv?=
 =?iso-8859-1?Q?EIYVu/e/8R1pk/4cwR0oXGkZlu2j2/0xeB7ByaB5Cijfiur6JbwSFK/2PC?=
 =?iso-8859-1?Q?/8mIuRjbMH01+PGALI2v8vbujtwbeNDvtFrSXNbNrVmZOGvRUyj4D0OQr4?=
 =?iso-8859-1?Q?kVR0xCXYVI0SmPWGMQBXqMjqQpa6eJJ6XAtbSo1RJ04RaQmCyu6OfjnWPG?=
 =?iso-8859-1?Q?DLJCE0L3cMBTcDxAkB2QOk5EOmvO4hlOm0s4tCrqvgPsJeiFQMSFFOOxuo?=
 =?iso-8859-1?Q?PUYneJYPp91Juv8Kmf+/K69oHCMM4QNGSHnOMy7mvU0xAtiw8F/z7tFEXe?=
 =?iso-8859-1?Q?Ub6t53MnH+2i7Y+P3NGpi4lLHhsIUpxouKjfdc6snII1MmdbswoAdFk2/P?=
 =?iso-8859-1?Q?42/79H9UI1zByplhg6ds0fCtO898UkXOnIogAzKsAGSsRgGaQtBFVFMN+T?=
 =?iso-8859-1?Q?N6jArqXRt/63MxXbpsDa0/OGxgFRdhHkE9p6CXG/fSrHkNivcACApfermK?=
 =?iso-8859-1?Q?E9ndiKV7nJYWtwo1zIjlSWbDrA/anfRFmba/S6bHpQdlhZ8TFuLDghdgUM?=
 =?iso-8859-1?Q?yYp+uT+VlPRx/Ngk7mslNZ8OhJMppfrLHwdjS+7edEGzwZiLvwMzcE4XM/?=
 =?iso-8859-1?Q?UKOEDEBtWTSqZ0ALBqyTrDFWvTXkYEeh1U0y4kgHkx18Ka57pZPzCha2/Q?=
 =?iso-8859-1?Q?wmJCH+7+xHbdpfoFMdELNyG8qyWPRdR7JQLugfrhBBJrO5p6fEy1Y10lo1?=
 =?iso-8859-1?Q?mO88lX6M2ykgWjhY5wS7KOzxeU3svGPhMLMuNrKDkpGBdM7PEQmXym+DvH?=
 =?iso-8859-1?Q?c0LW5BLwYOiw75kyMxo31RLLUsidW4wTi3VDdYAvoItIser13bkgh/A5fo?=
 =?iso-8859-1?Q?OLKo0NN01rW9901gfWY4/7GwuNtsVigF4PMusTDNGMBGiiWDwjylkCnS4s?=
 =?iso-8859-1?Q?aD71GR8MIdl95eUQsRGspTrVf/10/NYIzFRWSpSse+XJd4GYzMV6lgWMsE?=
 =?iso-8859-1?Q?UfdKL35ErWGBf2JQEfOzXIE31cuF+5H0LiQcsJMhen+GAUaS7egEjPTSsc?=
 =?iso-8859-1?Q?ZSikngGTkWsb9Bkbn9Q7ijT8KNMji4bZSlda15Vun+MpO18vHRDTG7TQw2?=
 =?iso-8859-1?Q?L2yegZ2X6zTjeWPvihxexStI40jMecqluYtwjZKlfuc88dbB79kKZ8Y7Jb?=
 =?iso-8859-1?Q?WE5IfSYhg1sGdY3MTYzJJ+1yovmEw1lwJX175R4xuwL+d2ExqiYBcqBDpG?=
 =?iso-8859-1?Q?8iyrc/fXCKk3I5zhQDzfUM5oj5fiVXqZThIKNwNfS7EwmVDrzR1XR/Vn26?=
 =?iso-8859-1?Q?1qxG8zTHqP3+3Amp14ITE9RJgAxYVLPLnHDb01WJllayRYlFCS3Rp0Vpcq?=
 =?iso-8859-1?Q?eEF4wwaq7mf/g2UD1vLspzAlhPGWcttO59Ai1GyFr5v1Y77uJcacngrm0y?=
 =?iso-8859-1?Q?uYUjlGKZ/lSXWDzcjpe708ZSu/1Yrqz/KGwYCnWagl9hqtRrsQa2KCWnJp?=
 =?iso-8859-1?Q?Sq3OdTZsxcqLJqwjGnLfkdr4LpEpObyM2J5StZKiug0bLYy39eBhhMONP5?=
 =?iso-8859-1?Q?wK7mU8dSab1Bl8jw+V779joEND/qiB3ikfQt+znQ0Aced/vf8LVS1c1kAo?=
 =?iso-8859-1?Q?F3KDE26QlYxnX0aF/FCHndjiwI4zJkqLjZaX++9tnCg3704nxmoCGg/V4O?=
 =?iso-8859-1?Q?Qy?=
X-MS-Exchange-AntiSpam-MessageData-1: BqzBol5WKt7J9A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3974d25f-be9c-4daf-9c45-08da2d9eb3c9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:21:27.3419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aomd2tuGN2i0z7gdexZj6zBpudofVx3oFGQK7mfRM0MuqFRT6CZSJvV45k1Q7LmSFLFIyzIpy3RXDR3lmDi2iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1521
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 3 May 2022 20:21:46 CEST Jaehee Park wrote:
> Currently, upon virtual interface creation, wfx_add_interface() stores
> a reference to the corresponding struct ieee80211_vif in private data,
> for later usage. This is not needed when using the container_of
> construct. This construct already has all the info it needs to retrieve
> the reference to the corresponding struct from the offset that is
> already available, inherent in container_of(), between its type and
> member inputs (struct ieee80211_vif and drv_priv, respectively).
> Remove vif (which was previously storing the reference to the struct
> ieee80211_vif) from the struct wfx_vif, define a function
> wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> the newly defined container_of construct.
>=20
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---
> v2
> - Sequenced the wfx.h file (with the new defines) to show up first on
> the diff, which makes the ordering of the diff more logical.
>=20
> v3
> - Made edits to the commit message.
> - Shortened the macro name from wvif_to_vif to to_vif.
> - For functions that had more than one instance of vif, defined one
> reference vif at the beginning of the function and used that instead.
> - Broke the if-statements that ran long into two lines.
>=20
> v4
> - Changed macro into function and named it back to wvif_to_vif
> - Fit all lines in patch to 80 columns
> - Decared a reference to vif at the beginning of all the functions
> where it's being used
>=20
> v5
> - Placed longest declarations first
>=20
>=20
>  drivers/net/wireless/silabs/wfx/wfx.h     |  6 +-
>  drivers/net/wireless/silabs/wfx/data_rx.c |  5 +-
>  drivers/net/wireless/silabs/wfx/data_tx.c |  3 +-
>  drivers/net/wireless/silabs/wfx/key.c     |  4 +-
>  drivers/net/wireless/silabs/wfx/queue.c   |  3 +-
>  drivers/net/wireless/silabs/wfx/scan.c    | 11 ++--
>  drivers/net/wireless/silabs/wfx/sta.c     | 71 ++++++++++++++---------
>  7 files changed, 65 insertions(+), 38 deletions(-)
>=20
[...]
> diff --git a/drivers/net/wireless/silabs/wfx/sta.c b/drivers/net/wireless=
/silabs/wfx/sta.c
> index 3297d73c327a..040d1f9fb03a 100644
> --- a/drivers/net/wireless/silabs/wfx/sta.c
> +++ b/drivers/net/wireless/silabs/wfx/sta.c
> @@ -101,6 +101,7 @@ void wfx_configure_filter(struct ieee80211_hw *hw, un=
signed int changed_flags,
>         struct wfx_vif *wvif =3D NULL;
>         struct wfx_dev *wdev =3D hw->priv;
>         bool filter_bssid, filter_prbreq, filter_beacon;
> +       struct ieee80211_vif *vif =3D wvif_to_vif(wvif);

wvif is modified later in the function, so this one is not correct.


--=20
J=E9r=F4me Pouiller


