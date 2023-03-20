Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A496C1F3B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjCTSNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjCTSNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:13:04 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E1A3B233;
        Mon, 20 Mar 2023 11:07:16 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id m6so8182007qvq.0;
        Mon, 20 Mar 2023 11:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679335618;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rw6MWePbQ5O8TKvCsfkhlgjoKZONM+KtRz7LuBO6zPg=;
        b=G+Sk+NarnqqkLb/kJ71yFOvplIcH8Zg53t6Wa1V39yywvKLFusVVtBNB5tIIgdd0gj
         B+7KL2eQlro0cdxYOnoWh3kPZ3PWEVmfo9iOa4V4+/ce2aRuMaq59Z039/+rwiBLZx8q
         Nj+u2sUrX2KtMUK/Z4Gw5r7sVMDoYP14m9NYitG8pJDPozLuJqj20wl4ThtLE7uD8EJA
         /ApETeodeDf3nXaWFAgXy5uWGnwSRIeleLipcO4oqNkLfMMeRFbzej3xmLU0YsfmG564
         tLZVBmHXClSZsGgMogqT6qkw+4q/hzVHN6di1r/iQe7wGT0SwArjU3ID5hQzCUPg45NI
         J85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335618;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rw6MWePbQ5O8TKvCsfkhlgjoKZONM+KtRz7LuBO6zPg=;
        b=U6ExtExLQwVv6eZYtiY9JInOB8F/DMcv7AmbLhVBaUObPQ9Ao6X39Q7iZ4eDPzEbO+
         sotz3bYTS6wqIZRCeXU0nxDQT77sc3u1dJf3bg3b676Xciu4QLWeU/Y+MXV+d32/BsmV
         b3b4HEya9et1WB3ypCmbC/ksKCIz4932njgZqe1yhvWIR5lKGXv2TmchTM4BevNrt+VB
         0XOEsS8bfQ2msmaIWNh3HuRDwGWBaViNAEuQXn65Pwb32S8iIO5LJa4f7JuH610j5AQp
         imwTJmr79sGcRgj3JCy12NJKW/GoYT7eqbpHeJlDO6Waq4gJrlYfIg7+QpozJIc9z0wX
         Fsow==
X-Gm-Message-State: AO0yUKUDTskYki3T2863FouEtdLQi9lqZwpCvNohuFwvMJkqEq0oM1to
        JTVCPrGESf8/X/K4yeIv7DU=
X-Google-Smtp-Source: AK7set/tDmjevxk1U1SD/u0C+FIE4uDwF1Qlrq7L2T0PpRB3NmWNyfBkonWCC05D2lC3+9bPwQKrBQ==
X-Received: by 2002:a05:6214:248e:b0:5ae:371a:ab36 with SMTP id gi14-20020a056214248e00b005ae371aab36mr32817508qvb.50.1679335618404;
        Mon, 20 Mar 2023 11:06:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r140-20020a37a892000000b007468ad71799sm2102350qke.64.2023.03.20.11.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 11:06:56 -0700 (PDT)
Message-ID: <3b5ffccc-f1cd-b2f8-1e78-72997b43c12c@gmail.com>
Date:   Mon, 20 Mar 2023 11:06:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: dsa: report rx_bytes unadjusted for ETH_HLEN
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230317231900.3944446-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230317231900.3944446-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 16:19, Vladimir Oltean wrote:
> We collect the software statistics counters for RX bytes (reported to
> /proc/net/dev and to ethtool -S $dev | grep 'rx_bytes: ") at a time when
> skb->len has already been adjusted by the eth_type_trans() ->
> skb_pull_inline(skb, ETH_HLEN) call to exclude the L2 header.
> 
> This means that when connecting 2 DSA interfaces back to back and
> sending 1 packet with length 100, the sending interface will report
> tx_bytes as incrementing by 100, and the receiving interface will report
> rx_bytes as incrementing by 86.
> 
> Since accounting for that in scripts is quirky and is something that
> would be DSA-specific behavior (requiring users to know that they are
> running on a DSA interface in the first place), the proposal is that we
> treat it as a bug and fix it.
> 
> This design bug has always existed in DSA, according to my analysis:
> commit 91da11f870f0 ("net: Distributed Switch Architecture protocol
> support") also updates skb->dev->stats.rx_bytes += skb->len after the
> eth_type_trans() call. Technically, prior to Florian's commit
> a86d8becc3f0 ("net: dsa: Factor bottom tag receive functions"), each and
> every vendor-specific tagging protocol driver open-coded the same bug,
> until the buggy code was consolidated into something resembling what can
> be seen now. So each and every driver should have its own Fixes: tag,
> because of their different histories until the convergence point.
> I'm not going to do that, for the sake of simplicity, but just blame the
> oldest appearance of buggy code.
> 
> There are 2 ways to fix the problem. One is the obvious way, and the
> other is how I ended up doing it. Obvious would have been to move
> dev_sw_netstats_rx_add() one line above eth_type_trans(), and below
> skb_push(skb, ETH_HLEN). But DSA processing is not as simple as that.
> We count the bytes after removing everything DSA-related from the
> packet, to emulate what the packet's length was, on the wire, when the
> user port received it.
> 
> When eth_type_trans() executes, dsa_untag_bridge_pvid() has not run yet,
> so in case the switch driver requests this behavior - commit
> 412a1526d067 ("net: dsa: untag the bridge pvid from rx skbs") has the
> details - the obvious variant of the fix wouldn't have worked, because
> the positioning there would have also counted the not-yet-stripped VLAN
> header length, something which is absent from the packet as seen on the
> wire (there it may be untagged, whereas software will see it as
> PVID-tagged).
> 
> Fixes: f613ed665bb3 ("net: dsa: Add support for 64-bit statistics")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Already applied, but I agree with you that this is the simplest way to 
go about fixign this. Thanks!
-- 
Florian

