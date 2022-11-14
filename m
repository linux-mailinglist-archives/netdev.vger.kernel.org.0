Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D1628119
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbiKNNS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbiKNNSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:18:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DD7140A4;
        Mon, 14 Nov 2022 05:18:15 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id cl5so18186336wrb.9;
        Mon, 14 Nov 2022 05:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RkCSUED9FhCNs428frFC68H05yt7fFNYb0gdzPYo+k=;
        b=ApcFtkYof2PfR/nalfvx6zDJCnF4d3GoglJdtbi0/XFzEPJYDsDfN0JjddQib/VoSq
         LUP3Tf9LXMs6FXBI0ecyaJp+ozrouJWKJUwHZuCmSgzPFV4p1p2HxO23oRIjUAT+X8tx
         0Wu85Z2LKYcWwZeL5r9D9RmOgNTOzqAb2YQtF8WuXzXeF94QVHYvUpvy3bxnJfqI28iP
         a8RQGO//tMxR+hm+6yyPtM93D7AroHB8n0zeQGQfOWgU1nyJM71VvxNF1LQ1pl8r4Sbb
         a7U46Bb4CPQOkUaiR9ovB7ZBqiMepFj1ysKi/H+BpfDkGhAY52EIsgfFzPbNpMJfYcjB
         bW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+RkCSUED9FhCNs428frFC68H05yt7fFNYb0gdzPYo+k=;
        b=zB34Hdd8aiwDZ/6OOOfkuSr+t0Y30zl4gQXa7Xb9fQekQmtv8X4m8ofc4mG/fy75My
         pGEch/7Ig7ZGsuaR+xe17SbNzNOvPDFqaM5sCcHcgK4Lga3keN9U7t7BjbupSrZ6cqP5
         xkCERtUD9++tBei5YlZ9yypWyDArRpTjM4q+winVSAsG5hyEL4/wqjpXOhvcpHSF9wsy
         nrYzVOWAq7bb+r7C/LMO/gNGvG5V7GRPbb0wUTOqVkeOf2EaowdasfnX3tALIE3Kz8J8
         Cck6mzgfvCWNWW804Ns//kk++jK7Iw6XZ7KKl9Y4ON/xsgxaCGW2sNrB2V/7e0iHNVgD
         N73g==
X-Gm-Message-State: ANoB5pmKiNy/dleveakY5adhvRPdaQVv63vPN/k5UimnaD4jw+wVKUWz
        bwAah61DF0PBVcdnouVneGtLSSGGgJiC7TmwosI=
X-Google-Smtp-Source: AA0mqf5Yn8y/PwGxV6uAoHXEBCvJ9yU69EsbquffmFXRNZ60KWZKc/1v2t7azgf61tPHTs5KIEvJpMeGj/i37pgnEQ4=
X-Received: by 2002:a05:6000:1183:b0:238:aa36:6b0d with SMTP id
 g3-20020a056000118300b00238aa366b0dmr7198267wrx.688.1668431894174; Mon, 14
 Nov 2022 05:18:14 -0800 (PST)
MIME-Version: 1.0
References: <20221110212212.96825-1-nbd@nbd.name> <20221110212212.96825-2-nbd@nbd.name>
 <20221111233714.pmbc5qvq3g3hemhr@skbuf> <20221111204059.17b8ce95@kernel.org>
 <bcb33ba7-b2a3-1fe7-64b2-1e15203e2cce@nbd.name> <20221114115559.wl7efrgxphijqz4o@skbuf>
 <8faa9c5d-960c-849b-e6af-a847bb1fd12f@nbd.name>
In-Reply-To: <8faa9c5d-960c-849b-e6af-a847bb1fd12f@nbd.name>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 14 Nov 2022 05:18:01 -0800
Message-ID: <CAA93jw4Z-fz_6gTxrjwsifcMy=oAcF0mPT6s=_aGdDU3UgCgcg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 4:21 AM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 14.11.22 12:55, Vladimir Oltean wrote:
> > On Sat, Nov 12, 2022 at 12:13:15PM +0100, Felix Fietkau wrote:
> >> On 12.11.22 05:40, Jakub Kicinski wrote:
> >> I don't really see a valid use case in running generic XDP, TC and NFT=
 on a
> >> DSA master dealing with packets before the tag receive function has be=
en
> >> run. And after the tag has been processed, the metadata DST is cleared=
 from
> >> the skb.
> >
> > Oh, there are potentially many use cases, the problem is that maybe
> > there aren't as many actual implementations as ideas? At least XDP is,
> > I think, expected to be able to deal with DSA tags if run on a DSA
> > master (not sure how that applies when RX DSA tag is offloaded, but
> > whatever). Marek Behun had a prototype with Marvell tags, not sure how
> > far that went in the end:
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg381018.html
> > In general, forwarding a packet to another switch port belonging to the
> > same master via XDP_TX should be relatively efficient.
> In that case it likely makes sense to disable DSA tag offloading
> whenever driver XDP is being used.
> Generic XDP probably doesn't matter much. Last time I tried to use it
> and ran into performance issues, I was told that it's only usable for
> testing anyway and there was no interest in fixing the cases that I ran
> into.

XDP continues to evolve rapidly, as do its use cases. ( ex:
ttps://github.com/thebracket/cpumap-pping#readme )

What cases did you run into?

specifically planning to be hacking on the mvpp2 switch driver soon.

>
> >> How about this: I send a v4 which uses skb_dst_drop instead of skb_dst=
_set,
> >> so that other drivers can use refcounting if it makes sense for them. =
For
> >> mtk_eth_soc, I prefer to leave out refcounting for performance reasons=
.
> >> Is that acceptable to you guys?
> >
> > I don't think you can mix refcounting at consumer side with no-refcount=
ing
> > at producer side, no?
> skb_dst_drop checks if refcounting was used for the skb dst pointer.
>
> > I suppose that we could leave refcounting out for now, and bug you if
> > someone comes with a real need later and complains. Right now it's a bi=
t
> > hard for me to imagine all the possibilities. How does that sound?
> Sounds good. I think I'll send v4 anyway to deal with the XDP case and
> to switch to skb_dst_drop.
>
> - Felix



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
