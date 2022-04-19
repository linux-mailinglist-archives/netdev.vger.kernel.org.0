Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C77F506DF1
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352620AbiDSNpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352663AbiDSNmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:42:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8A738BE0;
        Tue, 19 Apr 2022 06:39:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNBF1lhARWz33HL+AOY1SMctG7zAUGqmyGxY1u6FcwwIEnQo7J2pXeVBayMsDWsuA54lwC2WLdcU0GaZS0lGi6uUmo4OXuxoLLhyFywbvkGs7KSRUJuTsN/KHsDFfEjtZaEpp3zghr4GvLEaAhk7yuSlFAt424Y9TBOR83pHepXtp7ClrpKS3ENc8o3VbspCiwGY4O2XTUcKQFx2+sRgIE+qDfK6zD1x/xA6lEOG/mjndVKaMGqEwiB9A/x9nisjRXo8acbQwe0HTAwmBgmACwe3yIa3KJa5SK0GJG/FIl7/qnUKskX8mO81PwAXBBQfhCiwVZwP77P2C8DB+XvKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VcH1a2Of9dqwCAZFZnVntrhLrq6naJJA9nYH1mHfG0=;
 b=HnFrZDKT5WGAQqPMBYX5nK105KJt33iT6Jfftembt9vOPepai1ecz0iEfK/6/KOzqk1Rzv9vFp0Wtvkk/HKL24uY2pO78ULMX38VAuWWatQJCkvD0d/BZXKfeGgdF+4/lpqkzSfuAgRhuo0YrolfWi+7ht5fu9VZB1ReaTsxaGWv0FvE+7GP6d/grMQ2vxrtNvBBeNjMJHuH0xtfr1lSul7jJlWdjK2IK9H7XnJ4AY81SjV6TmVHV8H/mSC0xTmQU2RKebYLxGoC2qgTEnz18riKlKIrrqGJu/LWFebjDsaJPKXvkgZ/n37wB7zzVh6NEFR91J8KgtUo1kz3blmklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VcH1a2Of9dqwCAZFZnVntrhLrq6naJJA9nYH1mHfG0=;
 b=Yp2iJiaxIFgaD+QxkUfziKBL8nlU4/j1VPxsb1q69TcN8WlUVD9NUvy3GpARY9YFnMJ54hDyELdZLSVKq1dZ4RUMdq8Uxy1yRIj9LSEtsKPRNDJ4IkNS6VWvawnjqKd2ljL0VDPKBfjts5PLl3nPjepR66IHi3hrAeelK4Pvvd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5783.namprd11.prod.outlook.com (2603:10b6:510:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 13:39:27 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::89b8:2d6e:d075:527]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::89b8:2d6e:d075:527%5]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 13:39:27 +0000
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
Subject: Re: [PATCH] wfx: use container_of() to get vif
Date:   Tue, 19 Apr 2022 15:39:19 +0200
Message-ID: <22643645.6Emhk5qWAg@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0286.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a45edf2-e982-407d-1b1b-08da220a062b
X-MS-TrafficTypeDiagnostic: PH0PR11MB5783:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5783AEB02D2AFDCC42C0E9F893F29@PH0PR11MB5783.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5BRC6YjKPXzPcXgTWKxYlMTUzlUqUsn/9GB068aHxx+5wAXklNe6q2Cf6dJOhjvWWmCNSGOaMQFsGViBSIEvbaVrlX1IGsqPkHi8qh5ZhYS/1puOgmW/0eitWy6o5YTQxuTGNa4HbmY/KsGwZf9gHSw1TqfaETfF2k242muvrp/VzS5jm8zF9slahmOlj+N3odP2WqUluyOFPxTrdTKuWAqhymNhy4njClfierRqZ+qTFXbDCmngyg2MWiAVfPGwal/OM3x2u8LcMuqGjOgh6S9CO3OSibbFP6+xtEKM8JUFrBbtl5jIhyePpG+3WvtcJMFLJqUk79PeBYPEYcPCayOgYomYjZ+YSAs1grGB8Wys026I/NyZ5KaSBnJ/Ap8A7y+CQ2dMdVToSNmY5SK0QIeeQmefA8/fgWEUGdwI8FeIkKy/poWoAxmnetCJOUYJunSShK2Rr/P+K3QdWDrzFHljb0Zt4WqweBJJWkv9oyrHMC6clFLuTPuCXlg+1ywASYGiISgKviiiIKvyGREeAW4v4IzuBoCJQpElXHvqBYOTGhrOmrMA1Js6hrdvTxEA9b3UiZglXFHsTZjmynuyrX4q87ypFoHM4GghYgAjYPw7dtHtQaabVlTShj8nhfHHTCejj4Az97Wsu2iqBAMAWlBr0Z/lQhfmmv1XKORkcl9XOGvltNUH47GMb94ynRTeY6KcKkDdOgDE1zSvNVjvuBab5HvxPAOryYwClSfb2VSH2MoMOo8QAIzNWxeM9+p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(8936002)(8676002)(26005)(66574015)(508600001)(33716001)(7416002)(5660300002)(9686003)(52116002)(6506007)(6512007)(6486002)(6666004)(36916002)(110136005)(316002)(86362001)(83380400001)(186003)(66946007)(66556008)(66476007)(38100700002)(38350700002)(921005)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?EPzW8Ra1kzYeEUmxHhYfyYxsBKnm0tjr3oOHE1+5xrPcc5mLRiXELY9guQ?=
 =?iso-8859-1?Q?S/euGbjqvEiHSsgHd0PcK3mzsCmG2v6omGYe1bIM9g8INCvMMPA2hrA3OB?=
 =?iso-8859-1?Q?wKe0qEevsPD2aLP0KLvm+xddKxSECOdI9rMkGZPV79wiuk1RRhAafjVYNJ?=
 =?iso-8859-1?Q?0Zk4fAQJYGUkpPTO5XgMy6fyB8G6p8d5deuVH1H+4puRoTkCWXt6C9Ahwv?=
 =?iso-8859-1?Q?AIvZ49GciKRj59iORDqtjZ72G81iR3J8SMuy1d3aZZWdK2iNATLa/De15O?=
 =?iso-8859-1?Q?Ut0S/Gr4wV71SjiRCZ7Yw/z+1FPvgAAVH7+PjbKt8Gom8SJWCwtHkk1kJz?=
 =?iso-8859-1?Q?/RluUJTddqZ5sn2PPdZACjZnHi0+yjeYA6pHm/vio16oiv6z7flQetn21a?=
 =?iso-8859-1?Q?mZ2rL/ricOqehlUTvwUe0I52s2wU6lk0CcuRHcKKuuwI6ptT9nJk+kTsvA?=
 =?iso-8859-1?Q?AVJqMzWXR5GQrk6DSRWvtYRlOprHkV3AeQHpxEI8eICbj+SZPfS6PdICQL?=
 =?iso-8859-1?Q?CZ8hjYdH/bnqgS4KOe61Nb26nuKBTR9nCmAq3rPzmxxg8xNDSXdhl5SPwr?=
 =?iso-8859-1?Q?6W4yL21+Br3vmPPZXdnng4qE0g1sSHwQFd/BGIBic79vSMucmgNrZDyukx?=
 =?iso-8859-1?Q?nFpXKnhTQid7H5aWPyBgZZGesTww75ANQrJ06unDd0cdN2mbuTSt0eezKK?=
 =?iso-8859-1?Q?SDvD8CmRyzqjICEqu5hs1B+tM4eram2+YSpG1a9trVdYAfWpET6V5jxxBV?=
 =?iso-8859-1?Q?MQY/JBbPSP8VnLR2uQ0EVf0TB8P9voL5vpHsIBvIQuunK6a4t3mGC55U4X?=
 =?iso-8859-1?Q?Ak6a9u3mdIJfgt7WQ5CSoM61VocRAju+icbOJHLtSLGE803alOHMpYtP3L?=
 =?iso-8859-1?Q?FhQCLwZ/Beme+wcoyqbYqPFwl8qCUNyKmQwhWTbJLPFQ4heLDhMbSGqNcX?=
 =?iso-8859-1?Q?SQXszhVnWXuCmp941XN2KhGFNkR4QMduQ1dA4Am3QJIzwwtGyjaDhrO9A6?=
 =?iso-8859-1?Q?QBFhfyoYWS0+Gutr95czhgDWAFdK/Wpo69/r/AsE6zb366EQ7LPhia9gxm?=
 =?iso-8859-1?Q?OURW22lGZsO11zGBRv0ddMMfOact0mytepo0D7mmlw/Y2xObRAcDt5sV0B?=
 =?iso-8859-1?Q?EcAt1vYobYDzcmAjUZ6gv6bsQXncCptxi0Z0rF2R3gSRWLsHuWSYBcm8j0?=
 =?iso-8859-1?Q?CDQ2pDGeIzPOHKVTD8+Ol8X54fjBgAuaITDXHfe01T12QqtoBNFggB71aN?=
 =?iso-8859-1?Q?oqBjX6poUhrKo8iiqzjELwVknXJPIHccjgs7IxDNUpZhdTw8cXrkLuUBhj?=
 =?iso-8859-1?Q?cg/mBUgD2535IdK+zSrMBr3D/ynDF4TfIOYx8m9xAzJrdQU85MXAoLOV8w?=
 =?iso-8859-1?Q?5PYdvo0RIe6XF14aHBeodgVm2QqfQ0tys7X9Z9zfPUymHJQiMuAhRpAJ4b?=
 =?iso-8859-1?Q?2wjF1rAMGgVp42yC40eljJ/tmX8ORNWxvBZKnf34OHmVAi3sM0AtgA8y5a?=
 =?iso-8859-1?Q?tmB9pvowiciCZZs3jC0EJ9RdO+fi3hMn175EfZkLwQU8zCuDbMSzh1YMoq?=
 =?iso-8859-1?Q?LpnRMRTzN+GBK9iaz/MwrDcmft6f3If8apsDwZwyEZMLIdyU53d39w2ihO?=
 =?iso-8859-1?Q?5biaBgABUMcCQviC8nddCgJ0wzYudA6jUhvRWx37nJPMVbOGquiUs8F7cP?=
 =?iso-8859-1?Q?ylSd7BmfmsLlse6IivEeD6hiClmC70XN0LVwP41cGWknpV4l5YNXk4zGp6?=
 =?iso-8859-1?Q?Rs57zejWyn58Gme+Edb48J9nltZ8LZ04FLHQf6lDJhabstx2oxyOxnMMb+?=
 =?iso-8859-1?Q?RiVGkeC4DA=3D=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a45edf2-e982-407d-1b1b-08da220a062b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 13:39:27.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ph7CGwYQAFe0oEXuw0L7xqC3gGRt9akor1w23coSSSHYG9X0TAF1mllQ1127YORxHrlGcXBm+3jDY5YQoS5JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5783
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 18 April 2022 05:51:10 CEST Jaehee Park wrote:
>=20
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
>=20
> Changes from staging to wireless-next tree
> - changed macro into function and named it back to wvif_to_vif
> - fit all lines in patch to 80 columns
> - decared a reference to vif at the beginning of the functions
>=20
> NOTE: J=E9r=F4me is going to be testing this patch on his hardware

Don't forget to increment the version number of your submission (option
-v of git send-email).

>  drivers/net/wireless/silabs/wfx/wfx.h     |  6 +-
>  drivers/net/wireless/silabs/wfx/data_rx.c |  5 +-
>  drivers/net/wireless/silabs/wfx/data_tx.c |  3 +-
>  drivers/net/wireless/silabs/wfx/key.c     |  4 +-
>  drivers/net/wireless/silabs/wfx/queue.c   |  3 +-
>  drivers/net/wireless/silabs/wfx/scan.c    |  9 ++-
>  drivers/net/wireless/silabs/wfx/sta.c     | 69 ++++++++++++++---------
>  7 files changed, 63 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/net/wireless/silabs/wfx/wfx.h b/drivers/net/wireless=
/silabs/wfx/wfx.h
> index 6594cc647c2f..718693a4273d 100644
> --- a/drivers/net/wireless/silabs/wfx/wfx.h
> +++ b/drivers/net/wireless/silabs/wfx/wfx.h
> @@ -61,7 +61,6 @@ struct wfx_dev {
>=20
>  struct wfx_vif {
>         struct wfx_dev             *wdev;
> -       struct ieee80211_vif       *vif;
>         struct ieee80211_channel   *channel;
>         int                        id;
>=20
> @@ -91,6 +90,11 @@ struct wfx_vif {
>         struct completion          set_pm_mode_complete;
>  };
>=20
> +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> +{
> +       return container_of((void *)wvif, struct ieee80211_vif, drv_priv)=
;
> +}
> +
>  static inline struct wfx_vif *wdev_to_wvif(struct wfx_dev *wdev, int vif=
_id)
>  {
>         if (vif_id >=3D ARRAY_SIZE(wdev->vif)) {
> diff --git a/drivers/net/wireless/silabs/wfx/data_rx.c b/drivers/net/wire=
less/silabs/wfx/data_rx.c
> index a4b5ffe158e4..342b9cd0e74c 100644
> --- a/drivers/net/wireless/silabs/wfx/data_rx.c
> +++ b/drivers/net/wireless/silabs/wfx/data_rx.c
> @@ -16,6 +16,7 @@
>  static void wfx_rx_handle_ba(struct wfx_vif *wvif, struct ieee80211_mgmt=
 *mgmt)
>  {
>         int params, tid;
> +       struct ieee80211_vif *vif =3D wvif_to_vif(wvif);

When you can, try to place the longest declaration first ("reverse
Christmas tree order").

[...]
> diff --git a/drivers/net/wireless/silabs/wfx/sta.c b/drivers/net/wireless=
/silabs/wfx/sta.c
> index 3297d73c327a..97fcbad23c94 100644
> --- a/drivers/net/wireless/silabs/wfx/sta.c
> +++ b/drivers/net/wireless/silabs/wfx/sta.c
[...]
> @@ -152,19 +153,28 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif,=
 bool *enable_ps)
>  {
>         struct ieee80211_channel *chan0 =3D NULL, *chan1 =3D NULL;
>         struct ieee80211_conf *conf =3D &wvif->wdev->hw->conf;
> +       struct ieee80211_vif *vif =3D wvif_to_vif(wvif);
>=20
> -       WARN(!wvif->vif->bss_conf.assoc && enable_ps,
> +       WARN(!vif->bss_conf.assoc && enable_ps,
>              "enable_ps is reliable only if associated");
> -       if (wdev_to_wvif(wvif->wdev, 0))
> -               chan0 =3D wdev_to_wvif(wvif->wdev, 0)->vif->bss_conf.chan=
def.chan;
> -       if (wdev_to_wvif(wvif->wdev, 1))
> -               chan1 =3D wdev_to_wvif(wvif->wdev, 1)->vif->bss_conf.chan=
def.chan;
> -       if (chan0 && chan1 && wvif->vif->type !=3D NL80211_IFTYPE_AP) {
> +       if (wdev_to_wvif(wvif->wdev, 0)) {
> +               struct wfx_vif *wvif_ch0 =3D wdev_to_wvif(wvif->wdev, 0);
> +               struct ieee80211_vif *vif_ch0 =3D wvif_to_vif(wvif_ch0);
> +
> +               chan0 =3D vif_ch0->bss_conf.chandef.chan;
> +       }
> +       if (wdev_to_wvif(wvif->wdev, 1)) {
> +               struct wfx_vif *wvif_ch1 =3D wdev_to_wvif(wvif->wdev, 1);
> +               struct ieee80211_vif *vif_ch1 =3D wvif_to_vif(wvif_ch1);
> +
> +               chan1 =3D vif_ch1->bss_conf.chandef.chan;
> +       }

I think this code could be simplified into:

       if (wvif->wdev->vif[1])
               chan1 =3D wvif->wdev->vif[1]->bss_conf.chandef.chan;

(If you choose this way, I suggest to place this change in a separate
patch)

[...]

--=20
J=E9r=F4me Pouiller


