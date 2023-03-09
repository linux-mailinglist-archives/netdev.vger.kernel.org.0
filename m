Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE256B26A7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjCIOV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjCIOVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:21:24 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6429AF283
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:21:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e13so2018737wro.10
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678371665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ifA5PJWbGjxuHHo5qmZE9zYqnMunamYsTKPZY7MkYwM=;
        b=Xfke2rp9mXAmDgEH6p5bbxKBuLteVvvp4QlUYtnLm5WmRMfYPsgPCLYj4npNmeZNPh
         kz+BH81+BekUn7B4cAbMG+tNfMzT+NWy6gLQL0Gl5pJYI2cvGJ5BlatIhhE+tzWZeFD8
         mWi6Kc0cWgRNbgTW2pudOtUq3nsk5Odgw5PduiKlWy96i2N/6OAdSuCywo6MmZf7+eFK
         k4jDRkP20T17L48rl8SLzGTU3lOgm1q3+7feJEgkW8d9W25xcWavuYw73Whp3sBndiJ4
         Qusw4G8jNLdiGNUN6b/oR199FhPpu2QLL6ywn16iYjUuLMplKJcNWXrSPvoLj7XXvT4K
         bEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678371665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifA5PJWbGjxuHHo5qmZE9zYqnMunamYsTKPZY7MkYwM=;
        b=rKOzIyzn1tsHVjmnNllHiPS9xWra5h51oZfAcI+o1FgT3wohXdiSB2JJ9i2g9+1MLs
         QJumB9X+yO2YpxEqzYfluizso3HhEqoV6HW0JJOvpkoMUjduHWatwicTmcZ/UVOWdB8e
         PElGh10MsXbYLgEU7p2MeleQHEFZsmsM/CDll7YLgeNYpE3ru/VizgFYE8FlbjbsCvgv
         iFY40MloLNFJQN9nVJ86OjgP7QbBwfxhjgJHq/yJLcGeP5itiam4aH0va0JvcLKIL3uF
         pRbO/tBzBCO+JXdo2oJmWZKEaSPQKvmlosKzkxPdoRDNPjHVtJGRoJPjaEMh66FR+NgY
         IjqQ==
X-Gm-Message-State: AO0yUKUYtK7f+WGYK5dWVh7BYmRaYd+s8wm+k7NE+hjrel6DuoW2o6Di
        7vGfXuNjlOp/rxhl1IPDKJKjMUX9OZqxzw==
X-Google-Smtp-Source: AK7set9wFVlI5pqpHVip6rW9nuxdf/kMpQlZ8NeC18b6GnvR7hNo/sl+ZDgyrQFves5Kt8c1fF1zwA==
X-Received: by 2002:adf:f184:0:b0:2ca:72af:5ab2 with SMTP id h4-20020adff184000000b002ca72af5ab2mr12601884wro.39.1678371665330;
        Thu, 09 Mar 2023 06:21:05 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b8-20020a5d4d88000000b002c70e60eb40sm18026023wru.11.2023.03.09.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:21:05 -0800 (PST)
Date:   Thu, 9 Mar 2023 16:21:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Qingtao Cao <qingtao.cao.au@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Question: DSA on Marvell 6390R switch dropping EAPOL packets
 with unicast MAC DA
Message-ID: <20230309142103.dg4qfksz4k2itotd@skbuf>
References: <CAPcThSFCN7mKP2_ZhqJi9-nGNTYmV5uB23aToAudodZDEnunoA@mail.gmail.com>
 <20230309110639.lvbhzexnim7vrkwx@skbuf>
 <CAPcThSH0Lp7ZNp4rhce3tFCjqPUZSuuySBFwv4sVvHKHFmy77Q@mail.gmail.com>
 <20230309131601.wxfsfo2dbfyj3ybe@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309131601.wxfsfo2dbfyj3ybe@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:16:01PM +0200, Vladimir Oltean wrote:
> Speaking of bridging, is the net2p9 interface under any bridge during
> your testing, or does it operate as a standalone interface? If it's
> under a bridge, could you repeat the experiment with it as standalone?

Ah, I shouldn't have asked this, because the information you've provided:

> > if (trunk)
> >     skb->offload_fwd_mark = true;
> > else if (!trap)
> >     dsa_default_offload_fwd_mark(skb);
> > 
> > will set skb->offload_fwd_mark = 1.

is enough for me to determine that yes, net2p9 *is* under a bridge.
This is because of the implementation:

static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
{
	struct dsa_port *dp = dsa_slave_to_port(skb->dev);

	skb->offload_fwd_mark = !!(dp->bridge);
}

if it wasn't under a bridge, then skb->offload_fwd_mark would have never
been 1.

Ok, so having this said, now I have a pretty strong suspicion as to what
the issue is.

The RX handler of the software bridge layer - br_handle_frame() - steals
packets from the bridge port interface (net2p9) before those packets
ever reach the PF_PACKET socket opened by wpa_supplicant. "Steals" means
"returns RX_HANDLER_CONSUMED and not RX_HANDLER_PASS".

There is a netfilter hook through which you can tell the bridge
"hey, don't steal this kind of traffic, leave it on the bridge port!"
The command, applied to EAPOL, would look something like this:

/sbin/ebtables --table broute --append BROUTING --protocol 0x888e --jump DROP

Would you mind giving this a try (and do the rest of the debugging later)?
