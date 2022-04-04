Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D584F1B2F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379488AbiDDVTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380667AbiDDUyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 16:54:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0516A2D1F3;
        Mon,  4 Apr 2022 13:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649105533;
        bh=BRKu84tk/JvDo38djPwWov/dR2ILWXWhz5k0A0S7YxU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=NjjsN5DTj0nPw4L1Ik74rVE35L1w1U32M/99gYi0opd0MsznEcZvKi/h+tZGBbUMH
         KVOnrG6pd4xJp1tta5bw+0S+MeB80gYMrJatKQX9I9CNJNaZERA79GbpXHWtYmv633
         lrItyuAK97GCdZnHvLw8dlrP3NXk+ayUkEtcRVA0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.4]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQ5vW-1nOBzB3Hbk-00M32k; Mon, 04
 Apr 2022 22:52:13 +0200
Date:   Mon, 4 Apr 2022 22:52:12 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ath9k: fix ath_get_rate_txpower() to respect the
 rate list end tag
Message-ID: <20220404225212.2876091a@gmx.net>
In-Reply-To: <87ilroemo4.fsf@toke.dk>
References: <20220402153014.31332-1-ps.report@gmx.net>
        <87ilroemo4.fsf@toke.dk>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NnPRZIjfNaVJZkTj7ApVieAk1MB2agUzzNV92mwZAI+hi5wjXJS
 jXCOhQXmMkBnmA8a6EDqUodUItITKqTePCSDfD/C0oTbzpg9SuZfWNaV41go8A9cJzyPxN1
 LKabCB9n+YuWnOECdwZ9jqua5cI3qDgSSIS+Uhg5wBofAem10ndrzZrVqZKyxx/VSauoE1k
 40e/m6+fDRIIEMawHmSRg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WwctLXs7RJo=:8ukKxlh0/t1eW2vnPQLVZE
 8e1had8xvP0OL0tFnV5qXHRWSTxwk4O3YP7CBnvJ2moBYpvwNhDnnGyzreIDugHLbWFqsHvpE
 OLpDQj5wby7wkzPqr9iDRTNUY96lTcAMq6z8nHQNtvYuxUW6gXkV1lzlrnbMTu4xKqJTwBWSs
 199cHzaBCCiJ63qvuI8SsnB0OivkeOznG1/9l9z6f/6OE/Y8PqhR4gon6NhRPnPNUUhJw03GV
 hnTpBzGfTWowaEqChXrRM8uiDrDUS8Qa53inyULcc7eiO08hb+YBdTkQ5WBY7+dLyCQUeZjEC
 tP/qXPaHABq7doy1v28EG6zjewSIV2ClND+mR8Jp8CkAK4exBfQUKsAnby4g9dS4jvIApFLB7
 COQH4Q6fGyg6ddpAiFkWvmK4kPwWsnbI5Io5ECOJ2e/shgwD6iCh6AhZCDS7gh+FV+cvZbBrB
 pm3A//PzqnNbWB2TatArebUxVmlGLiDjiVu4yfPkajQjbV15A2yUuYrj6U8gB1dEdBvJn24CN
 Cp73w6TtwH1oWtnnL07NRO9eS5cfY4JhJi3nzNJDmiLLs6wUoa90xCHtuiKVO16RVwGxj/M9G
 g3bd1+uJouwcx09w0aSKOu564BWHVQhtWmCdCiOa0Yxs0gSRiFRRcC2BXs3Z2FtCRz8FeWLTO
 CyofkFDZCqWeGy5jg193fHMcEqtP9//J0UvsgEdMd5zBlT3QhmD6cgLN6w4xiDEvJ23k/idtq
 Xg/IHhbkqQHRxulde8QpwRMiFncur3yRMIYUu3mdDZhZAZqYGCFaYf2t6URE3StrEVb2Rmx1L
 uLAqG5F3r0/RHlYuoFplFl605bwh8t9csic35YcAxTdm/BnX+m7s46+dlRGR3TzCE/1VSo4+a
 SSXkEJi3cTBCQy7pXB/GFld/21EWJ/FDYO8rXLTtEfqPr37rCbg/StC50cJvG5QiAwvPPJOCm
 82GaXuSOFvlIwg0AwETSW4sUPLaEQbfVLRwZV3h9k7oqaqshgfS7b+RuPh++ac+OuD8v/GkFl
 ag9nAiv0sf3lpqIOlQnpG5Otc+UONeePTMNk8zihAVBuuVlArnJbgE/y2qDV8/tN+7YY/WcxB
 42bLxPrumSJz5U=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Toke,

On Mon, 04 Apr 2022 20:19:39 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:

> Peter Seiderer <ps.report@gmx.net> writes:
>=20
> > Stop reading (and copying) from ieee80211_tx_rate to ath_tx_info.rates
> > after list end tag (count =3D=3D 0, idx < 0), prevents copying of garba=
ge
> > to card registers. =20
>=20
> In the normal case I don't think this patch does anything, since any
> invalid rate entries will already be skipped (just one at a time instead
> of all at once). So this comment is a bit misleading.

Save some (minimal) compute time? Found it something misleading while
debugging to see random values written out to the card and found this
comment in net/mac80211/rate.c:

 648                 /*
 649                  * make sure there's no valid rate following
 650                  * an invalid one, just in case drivers don't
 651                  * take the API seriously to stop at -1.
 652                  */

and multiple places doing the same check (count =3D=3D 0, idx < 0) for vali=
dation
e.g.:

 723                 if (i < ARRAY_SIZE(info->control.rates) &&
 724                     info->control.rates[i].idx >=3D 0 &&
 725                     info->control.rates[i].count) {

or=20

 742                 if (rates[i].idx < 0 || !rates[i].count)
 743                         break;

>=20
> Also, Minstrel could in principle produce a rate sequence where the
> indexes are all positive, but there's one in the middle with a count of
> 0, couldn't it? With this patch, the last entries of such a sequence
> would now be skipped...

According to net/mac80211/rc80211_minstrel_ht.c:

1128 static bool
1129 minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct minstrel_ht_=
sta *     mi,
1130                          struct ieee80211_tx_rate *rate)
1131 {
1132         int i;
1133=20
1134         if (rate->idx < 0)
1135                 return false;
1136=20
1137         if (!rate->count)
1138                 return false;
1139=20

minstrel although evaluates a rate count of zero as invalid...

Regards,
Peter

>=20
> -Toke

