Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7F74F1ED6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiDDVyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386311AbiDDVmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 17:42:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8345BAE7E;
        Mon,  4 Apr 2022 14:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649108034;
        bh=7pBH/QTJ4K2fdCD9q+U67btQCRzR9hRO991I2DZKjOg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=fPiI8WSIvhnY2eYzKH3G+8kOIH69YAbJLtEAz1x3F7p5LFTZPTj5/cMgttplO59FA
         +F5jkqUHuogpsPMrpzoD3KLdwiELqbohuibbuz4FZD58yBY3pJp8iAXsgh82JlUBRd
         alVAgJygCNjKIjf24/0xmDIBsina6AEGE5O5iVrI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.4]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MhU9Z-1oEQ3W3oG3-00eaxt; Mon, 04
 Apr 2022 23:33:54 +0200
Date:   Mon, 4 Apr 2022 23:33:52 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v1] mac80211: minstrel_ht: fix where rate stats are
 stored (fixes debugfs output)
Message-ID: <20220404233352.015c466d@gmx.net>
In-Reply-To: <20220404165414.1036-1-ps.report@gmx.net>
References: <20220404165414.1036-1-ps.report@gmx.net>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cgac7zs78FX8fY5Aa49qEpPlxy5uOGFoENtF+BbX9fV7jWveeVe
 3KGFnIjV1+SsvHQzxW9/YjP4MpxEogFZu4SkirmkahXVhke9yn7camcSlO6selYHh8Or5kq
 59vwB86Ch7NRfdKH2u9f55GMJ7QsvX8V0QKLUUJ6nxecX1RH56qj/z+8TdGBMeH6aGoEVZK
 /VQZZlbPHISWwpyNzW/Wg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LzUmXy3axEo=:XHAx0L/RxKqYFylh5BsEYG
 IX3NqFxW1SQ3vtVl9d6OzpZWhK6hJ+4Ggv3avalmawWGzFh+htjm54+dKsmicY8VaLSw8mZsj
 zly0SluDHPeL97EWfxwVzMmlUQtRRpDmss2CWYz7AK00O8i+U+QBI6vE8ou501IWsnIo9xP7O
 q3ljSHobd1YXz35e3jzMepVfYki3rNdvluRxV38SZo8iG8aP4iqaplMDih3jMcVuz8fQuJTwV
 vJXE6d3mRtQ8jmYHMe6TxiPwstfaEdsZpVYMcH9YwOiSB4VCTLV3wCcGGZlrPAumdA5RW/Mpp
 LJsmMg1ly0V2gkcJxew/rC8x7tmjr7MeWaVPCyB7YAxQu9r+IVgbMYCEcXYzjhMfZBliJS7wK
 QYDL3brzRsqN8VO7T8nmc8aLy5AbgYCa2O+wj9LeuKO9vBcVEDeUWS2WKvUSqPBunRuAvIhfG
 vTV+rWSZ+/T+dMKL+xsVrVPdE646CWx/rXrQRuqKQobrYYFKjHFlSBGgOad9I9Megv8n/2ohS
 JLW8opSEF6f0mRGycIYSJSwaZId7Wfjl8QPRK5FMG30ccECTV3TE94dD17tFiA81iFsv3TMGi
 Zca7rIDXRh/0lrmSp1muC1roxPEmN/aG6RDHDLvIlcQ7bTJ9BUPKJfVQwHFqA7I8ZpNudcSXE
 i36LCVm7Sr+Tqa7GplW1YJhbE+AZ2Wo2wJvD2ABH8rrrfIvXaEuk4puyFqf0CimZRO8/U506b
 BI58vqhMfSjHVxq5tjMPFR9N+RTjxtLvmICLPMjybAF4h+jcdSMfiN+kDQEfLwiNgOsVzNzy0
 QRrgXBXGhqSZVJ3XmI7N3SN7wuzLEnUPHkl5ZVNkskigowenT0Jt/1m1jEBvDB9SSxpt+Y6so
 Wxid+S/KvY4cTuOTAlknJeQvWAI3pKGCAp5ug6d9gkgMEiQGo8jRlx8s1riaj3han6VgkTfV8
 Dzf0AxuZsrXLaUWZMxZc2OR7AG5QBJGwFHQDdMfVQNsfVq8rmXpadGUnBZh1egtYWIOqSeolf
 0j9wd+DzZfTVboBoTWm5y9t1RROvwYBsQlz8ctOCwMKs6SFQJKHoMsQFDOdeZBTfPcQytI28/
 80/XUlHor1bFgs=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


+ CC: Felix Fietkau

On Mon,  4 Apr 2022 18:54:14 +0200, Peter Seiderer <ps.report@gmx.net> wro=
te:

> Using an ath9k card the debugfs output of minstrel_ht looks like the fol=
lowing
> (note the zero values for the first four rates sum-of success/attempts):
>
>              best    ____________rate__________    ____statistics___    =
_____last____    ______sum-of________
> mode guard #  rate   [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  =
[retry|suc|att]  [#success | #attempts]
> OFDM       1    DP     6.0M  272    1640     5.2       3.1      53.8    =
   3     0 0             0   0
> OFDM       1   C       9.0M  273    1104     7.7       4.6      53.8    =
   4     0 0             0   0
> OFDM       1  B       12.0M  274     836    10.0       6.0      53.8    =
   4     0 0             0   0
> OFDM       1 A    S   18.0M  275     568    14.3       8.5      53.8    =
   5     0 0             0   0
> OFDM       1      S   24.0M  276     436    18.1       0.0       0.0    =
   5     0 1            80   1778
> OFDM       1          36.0M  277     300    24.9       0.0       0.0    =
   0     0 1             0   107
> OFDM       1      S   48.0M  278     236    30.4       0.0       0.0    =
   0     0 0             0   75
> OFDM       1          54.0M  279     212    33.0       0.0       0.0    =
   0     0 0             0   72
>
> Total packet count::    ideal 16582      lookaround 885
> Average # of aggregated frames per A-MPDU: 1.0
>
> Debugging showed that the rate statistics for the first four rates where
> stored in the MINSTREL_CCK_GROUP instead of the MINSTREL_OFDM_GROUP beca=
use
> in minstrel_ht_get_stats() the supported check was not honoured as done =
in
> various other places, e.g net/mac80211/rc80211_minstrel_ht_debugfs.c:
>
>  74                 if (!(mi->supported[i] & BIT(j)))
>  75                         continue;
>
> With the patch applied the output looks good:
>
>               best    ____________rate__________    ____statistics___   =
 _____last____    ______sum-of________
> mode guard #  rate   [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  =
[retry|suc|att]  [#success | #attempts]
> OFDM       1    D      6.0M  272    1640     5.2       5.2     100.0    =
   3     0 0             1   1
> OFDM       1   C       9.0M  273    1104     7.7       7.7     100.0    =
   4     0 0            38   38
> OFDM       1  B       12.0M  274     836    10.0       9.9      89.5    =
   4     2 2           372   395
> OFDM       1 A   P    18.0M  275     568    14.3      14.3      97.2    =
   5    52 53         6956   7181
> OFDM       1      S   24.0M  276     436    18.1       0.0       0.0    =
   0     0 1             6   163
> OFDM       1          36.0M  277     300    24.9       0.0       0.0    =
   0     0 1             0   35
> OFDM       1      S   48.0M  278     236    30.4       0.0       0.0    =
   0     0 0             0   38
> OFDM       1      S   54.0M  279     212    33.0       0.0       0.0    =
   0     0 0             0   38
>
> Total packet count::    ideal 7097      lookaround 287
> Average # of aggregated frames per A-MPDU: 1.0
>
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_m=
instrel_ht.c
> index 9c6ace858107..5a6bf46a4248 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -362,6 +362,9 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, stru=
ct minstrel_ht_sta *mi,
>
>  	group =3D MINSTREL_CCK_GROUP;
>  	for (idx =3D 0; idx < ARRAY_SIZE(mp->cck_rates); idx++) {
> +		if (!(mi->supported[group] & BIT(idx)))
> +			continue;
> +
>  		if (rate->idx !=3D mp->cck_rates[idx])
>  			continue;
>

