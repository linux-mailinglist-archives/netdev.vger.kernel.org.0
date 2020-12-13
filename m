Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641A42D90B9
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 22:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgLMVTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 16:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgLMVTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 16:19:13 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09AFC0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 13:18:32 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id r24so25197833lfm.8
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 13:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=U1hCiI5zagafo+HpTaqD+3MoDgz+uH8RSzQzQ0KvjFU=;
        b=sEO+GpZbc7/fGIrpPAD+XIJEiHjDJV7dHD+adWQE9vCGqnZhQuTbFc8W09f9gmXyWj
         o3Ad/pYm1Vr4t9D6ucCg7P/LhUR+Mm89H7WsG21dGe/X2Xs3weRtF8Z/94QBeXWd9APA
         dpXnbfsnEZckoTf59e8DeqloZvSuMSNvev3TzZfXrB9DVkriZKTg1+SbmZ6hX/u/iQfW
         JRqBuNeV/6L1bSkFU7kw/W0hetsjN6cKZtTVKA8gGnm0YjZQjsZP954Vmhj1E3o22RM6
         L1OB17ZfmO9KWI4j80aKPfvKhigEPHIPEWoIbPXgBg7VY1/AQOV4sfsJ6Dk2E4MX9w0s
         sBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=U1hCiI5zagafo+HpTaqD+3MoDgz+uH8RSzQzQ0KvjFU=;
        b=Qp92tgBFmvTPJGTwW3PwsdAvhZqWTHEMSoMImo0/Z6fGJ8SQ5UPiF/3RUi4lXKf2oN
         lbKJ2Az8Nc91Q26u8t4eB+x8j3i6tVL6DZXP2TPY1E+WE/dChZCMqy+Ufz/9TAhCkETh
         cHBBNFO3QZSFSGdgkermo1cZSi3sePVfctLWx32SUirc0AGyCAQquHS6Ax8wz1p9O22a
         9YUYaIuQepzthJv8+QAnB2nqR75BUcl1+pIBNrrwGaxA5d1v2pJ8C2TPU2u9iwUrMHpy
         FmDn/Xv3U5Kk1SxXpFVX6b0r7Tn8654H42Rt6P+5P71XQEvNuceQOnZWSNM+Y6elsRFc
         Ulvg==
X-Gm-Message-State: AOAM532zy/YJMTbtM+sKnXSW0jlB1OJ87WZ5p67dh4se+3vZZUehej3I
        bHWorCoG3fNc9N7fRFD9sQ/s+mpHJH9cIxL0
X-Google-Smtp-Source: ABdhPJwIMuCWz8gG0bTLMF3H94F245rNE7oxYpcUrP87IP5ixE53v2kKxPM5YZCAtNIsWkkqx4helw==
X-Received: by 2002:a2e:b1c9:: with SMTP id e9mr9831586lja.283.1607894309566;
        Sun, 13 Dec 2020 13:18:29 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id n8sm1495292lfi.48.2020.12.13.13.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 13:18:28 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201212142622.diijil65gjkxde4n@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87a6uk5apb.fsf@waldekranz.com> <20201212142622.diijil65gjkxde4n@skbuf>
Date:   Sun, 13 Dec 2020 22:18:27 +0100
Message-ID: <878sa1h0bg.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 16:26, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Dec 11, 2020 at 09:50:24PM +0100, Tobias Waldekranz wrote:
>> 2. The issue Vladimir mentioned above. This is also a straight forward
>>    fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
>>    never set for ports in standalone mode.
>>
>>    I am not sure if I should solve it like that or if we should just
>>    clear the mark in dsa_switch_rcv if the dp does not have a
>>    bridge_dev. I know both Vladimir and I were leaning towards each
>>    tagger solving it internally. But looking at the code, I get the
>>    feeling that all taggers will end up copying the same block of code
>>    anyway. What do you think?
>
> I am not sure what constitutes a good separation between DSA and taggers
> here. We have many taggers that just set skb->offload_fwd_mark = 1. We
> could have this as an opportunity to even let DSA take the decision
> altogether. What do you say if we stop setting skb->offload_fwd_mark
> from taggers, just add this:
>
> +#define DSA_SKB_TRAPPED	BIT(0)
> +
>  struct dsa_skb_cb {
>  	struct sk_buff *clone;
> +	unsigned long flags;
>  };
>
> and basically just reverse the logic. Make taggers just assign this flag
> for packets which are known to have reached software via data or control
> traps. Don't make the taggers set skb->offload_fwd_mark = 1 if they
> don't need to. Let DSA take that decision upon a more complex thought
> process, which looks at DSA_SKB_CB(skb)->flags & DSA_SKB_TRAPPED too,
> among other things.

What would the benefit of this over using the OFM directly? Would the
flag not carry the exact same bit of information, albeit inverted? Is it
about not giving the taggers any illusions about having the final say on
the OFM value?

>> As for this series, my intention is to make sure that (A) works as
>> intended, leaving (B) for another day. Does that seem reasonable?
>>
>> NOTE: In the offloaded case, (B) will of course also be supported.
>
> Yeah, ok, one can already tell that the way I've tested this setup was
> by commenting out skb->offload_fwd_mark = 1 altogether. It seems ok to
> postpone this a bit.
>
> For what it's worth, in the giant "RX filtering for DSA switches" fiasco
> https://patchwork.ozlabs.org/project/netdev/patch/20200521211036.668624-11-olteanv@gmail.com/
> we seemed to reach the conclusion that it would be ok to add a new NDO
> answering the question "can this interface do forwarding in hardware
> towards this other interface". We can probably start with the question
> being asked for L2 forwarding only.

Very interesting, though I did not completely understand the VXLAN
scenario laid out in that thread. I understand that OFM can not be 0,
because you might have successfully forwarded to some destinations. But
setting it to 1 does not smell right either. OFM=1 means "this has
already been forwarded according to your current configuration" which is
not completely true in this case. This is something in the middle, more
like skb->offload_fwd_mark = its_complicated;

Anyway, so we are essentially talking about replacing the question "do
you share a parent with this netdev?" with "do you share the same
hardware bridging domain as this netdev?" when choosing the port's OFM
in a bridge, correct? If so, great, that would also solve the software
LAG case. This would also get us one step closer to selectively
disabling bridge offloading on a switchdev port.
