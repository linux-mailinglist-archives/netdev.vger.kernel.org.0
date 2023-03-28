Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFA6CB3FE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjC1C1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjC1C1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:27:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3A5E1;
        Mon, 27 Mar 2023 19:27:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i9so10636497wrp.3;
        Mon, 27 Mar 2023 19:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679970454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTFOlKsQkV752J0aCjyJ5GGCe6/bEDnLRu/pGjCsgdY=;
        b=GkZsiXQNOje8PndT2x/vNmh1LFcgWFEhYMp8YOHl0gERpk22+hG+brJC+XNkLC0ad2
         Wr1Kb/xvoa0oZX5mzAWHtwYSX6POm4amy9/ZKTOmwaO7tvUjeBCJGNkqMJNCyKbsn+vV
         oxWbZYvt00Lr6klQZR6v/3OXSnf3Hqx3uk+FefFMGH/UaUGbjgNqy4t7RWSgd+VhOcXK
         3PvHKQvCalZRH8BAvshq3n4XyMWpKvQRxJSXx6p4JH41euEK2uWXc6tF+h+2WXXOMG6o
         VJJxA6QTP7ALRsbmF+wdw37BTFs3nEygznIR/smYlOy4CLC5VczXC0bAvyfqX+rRuucN
         V0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679970454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dTFOlKsQkV752J0aCjyJ5GGCe6/bEDnLRu/pGjCsgdY=;
        b=b/c1R1Tp69T31Wha39EHtBs+CBt0meMPBw9B7QM1kk4rYDhIUyk5PsHd379d5EfumI
         /BL2dgfTwSc0z5JP1p2+Q4XFv59CDo/gYW7OujHH7MXQBkToTalE/CdJCAoe/hwRFdQr
         FITVJ5w0QzCeBVGnwugwCiXbe32pCoZ82MsDHJAnH9OYuedekalfI7hk51bwMgCJTuY8
         EnvtJ8oV+3Cfu9TpD+x7CmvMvKVaiQ+03W8t4J1bKNXZQTgwLYKtHFrTTqQ9oZI3xiQs
         b3txpbdDjNxMWeWe7Il7ycoVyUi8Utjmqx8YEKXk0+RBjk5HpnjwpcMdmCXeRkGCG9hf
         7h9w==
X-Gm-Message-State: AAQBX9dPd/i+JqETcDUVgZbi0HkcJYB1/NXlJ3jO8xwki7K993c1TxzD
        RL2lXemYDN+yxa4oWYX/Urm6Dtt0Zm65+7j9GKw=
X-Google-Smtp-Source: AKy350besLakIHgcW0IYQLohN28RsC9vf2hUcRjOp3oSAF8VNehNNMv2OpO+356z+SgYbjyLNAzAxSepU68pszownHs=
X-Received: by 2002:a5d:6606:0:b0:2de:9905:a46e with SMTP id
 n6-20020a5d6606000000b002de9905a46emr1865550wru.13.1679970453689; Mon, 27 Mar
 2023 19:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net> <20230327180950.79e064da@kernel.org>
In-Reply-To: <20230327180950.79e064da@kernel.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 27 Mar 2023 19:27:22 -0700
Message-ID: <CAA93jw5vFdySU-AMGYPpj0fDOHNe9O0aL_3N1kDk7UPTAs63Tw@mail.gmail.com>
Subject: Re: traceability of wifi packet drops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 6:32=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 27 Mar 2023 16:19:34 +0200 Johannes Berg wrote:
> > So I just ran into this problem with a colleague again; we don't have
> > good visibility into why in the wifi stack a packet is dropped.
> >
> > In the network stack we have skb drop reasons for (part of?) this, but
> > we don't really use this in wifi/mac80211 yet.
> >
> > Unfortunately we have probably >100 distinct drop reasons in the wifi
> > stack, so annotating those is not only tedious, it would also double th=
e
> > list of SKB drop reasons from currently ~75.
> >
> > Any good ideas? I even thought about just encoding the line number
> > wherever we use RX_DROP_UNUSABLE / RX_DROP_MONITOR, but that's kind of
> > awkward too. Obviously we could change the internal API to completely
> > get rid of enum ieee80211_rx_result and use enum skb_drop_reason
> > instead, but then we'd probably need to carve out some space to also
> > differentiate DROP_MONITOR and DROP_UNUSABLE, perhaps something like
> >
> >
> >       SKB_DROP_REASON_MAC80211_MASK           0x03ff0000
> >       SKB_DROP_REASON_MAC80211_TYPE_MASK      0x03000000
> >       SKB_DROP_REASON_MAC80211_TYPE_UNUSABLE  0x01000000
> >       SKB_DROP_REASON_MAC80211_TYPE_MONITOR   0x02000000
> >
> >       SKB_DROP_REASON_MAC80211_DUP            (SKB_DROP_REASON_MAC80211=
_TYPE_UNUSABLE | 1)
> >       SKB_DROP_REASON_MAC80211_BAD_BIP_KEYIDX (SKB_DROP_REASON_MAC80211=
_TYPE_MONITOR | 1)
> >
> >
> > etc.
> >
> >
> > That'd be a LOT of annotations (and thus work) though, and a lot of new
> > IDs/names, for something that's not really used all that much, i.e. a
> > file number / line number within mac80211 would be completely
> > sufficient, so the alternative could be to just have a separate
> > tracepoint inside mac80211 with a line number or so?
> >
> > Anyone have any great ideas?
>
> We need something that'd scale to more subsystems, so I don't think
> having all the definitions in enum skb_drop_reason directly is an
> option.

I am not going to comment on this idea directly, but I did want to
note that long on my round-to-it list was adding something like this
to the qdiscs generally:

QDISC_DROP_REASON_CONGESTIVE
QDISC_DROP_REASON_OVERFLOW
QDISC_DROP_REASON_GSO_SPLIT

since the wifi stack also has both of the former and for all I know,
the latter, whatever you come up with I applaud, with a better name
(QUEUE?)

>
> My knee jerk idea would be to either use the top 8 bits of the
> skb reason enum to denote the space. And then we'd say 0 is core
> 1 is wifi (enum ieee80211_rx_result) etc. Within the WiFi space
> you can use whatever encoding you like.
>
> On a quick look nothing is indexed by the reason directly, so no
> problems with using the high bits.
>
> Option #2 is to add one main drop reason called SKB_DROP_REASON_MAC80211
> and have a separate tracepoint which exposes the detailed wifi
> reason and any necessary context. mac80211 would then have its own
> wrapper around kfree_skb_reason() which triggers the tracepoint.
>
> Those are perhaps fairly obvious and unimaginative. Adding Eric,
> since he has been filling in a lot of the drop reasons lately.



--=20
AMA March 31: https://www.broadband.io/c/broadband-grant-events/dave-taht
Dave T=C3=A4ht CEO, TekLibre, LLC
