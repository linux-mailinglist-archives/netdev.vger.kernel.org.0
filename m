Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EBC48B8C9
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244102AbiAKUm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiAKUm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 15:42:56 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B89EC06173F;
        Tue, 11 Jan 2022 12:42:56 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id q8so383464wra.12;
        Tue, 11 Jan 2022 12:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VbynRfVLNK84/t0eJlwghbR8r9mR46wfAVOe8pGCiW8=;
        b=E9vjXnFFhdjfiKeRN77wV7BgukDWXVrWLq0z+xGOVSyfoLLoLg1REwjos7l40v/q8V
         AoW4+OuQliT9XZv1Toqa0sARUzmveSE8A52x4hwTkCapPSTBmzG7J4TZQ/vQ7kI5m1If
         6iVJozb+rOHoAHAmhciOKTd7g5BYrzwrfXt2T59cRUGTbWclLdw6+CjWM1mTo2M5Ptzf
         K/NbgaAipuGftYc42agwfeSh9lH5n58iraSr42S9ekLNzakb0e57/On+bPWOQSTBbCK4
         Qml2+NB+hjesUzTVtRGynwz2NPCLQpT2t4oZ4oaK3sA6nosJc81k71fY7TBm/zV09adq
         zvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VbynRfVLNK84/t0eJlwghbR8r9mR46wfAVOe8pGCiW8=;
        b=eqNCsSIBAQv/rEC09CLE94M/oP+FZHJLsdqMFUdVznJCicEEXELSOIpk8lfGJ9veJn
         aG43B4HsFsZxi51IZErurAAGUIzj2FANOyZErfVoGIOfL/p6nadpiIKRenhxj/QBkeGu
         j1QIFNHgeWcmKe4GXMVw1K70gNT5IzWKOp7WbmjSx5g631/6z+zctKOMyoT/+gM/8v2j
         fFuztcld+T1I9zv/GSw43hFQMj8DIn3qeMuodzJQP1lmqhMGaqa0SemY0XKEhNobFac3
         30O6m5V67PDZHlGV4qoCbTE+LVCazrlcKEUt8Q0fB9tRE339xY68XzofeA9Gf0t5UEDR
         Wxiw==
X-Gm-Message-State: AOAM533HU2sF0ZVt5FrFSR1B2jFQXO6JyLG5sQGgEyhQrfzT6RNv0e7T
        nDR9lWEirujsAHx522ENvtQ=
X-Google-Smtp-Source: ABdhPJxeR7GANkBhNDGq4Vd5Bc/wRjE1y1lR4wjizP9vAN+N8/RNyapu93mbY9rnphpU5+5CEo1t6Q==
X-Received: by 2002:a5d:47ad:: with SMTP id 13mr5292335wrb.268.1641933774981;
        Tue, 11 Jan 2022 12:42:54 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id e12sm10944885wrg.110.2022.01.11.12.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 12:42:54 -0800 (PST)
Message-ID: <9e3bb558-ecb1-a6aa-35e4-a2771136b3fe@gmail.com>
Date:   Tue, 11 Jan 2022 20:39:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 09/14] ipv6: hand dst refs to cork setup
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
References: <cover.1641863490.git.asml.silence@gmail.com>
 <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
 <48293134f179d643e9ec7bcbd7bca895df7611ac.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <48293134f179d643e9ec7bcbd7bca895df7611ac.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 17:11, Paolo Abeni wrote:
> On Tue, 2022-01-11 at 01:21 +0000, Pavel Begunkov wrote:
>> During cork->dst setup, ip6_make_skb() gets an additional reference to
>> a passed in dst. However, udpv6_sendmsg() doesn't need dst after calling
>> ip6_make_skb(), and so we can save two additional atomics by passing
>> dst references to ip6_make_skb(). udpv6_sendmsg() is the only caller, so
>> it's enough to make sure it doesn't use dst afterwards.
> 
> What about the corked path in udp6_sendmsg()? I mean:

It doesn't change it for callers, so the ref stays with udp6_sendmsg() when
corking. To compensate for ip6_setup_cork() there is an explicit dst_hold()
in ip6_append_data, should be fine.

@@ -1784,6 +1784,7 @@ int ip6_append_data(struct sock *sk,
  		/*
  		 * setup for corking
  		 */
+		dst_hold(&rt->dst);
  		err = ip6_setup_cork(sk, &inet->cork, &np->cork,
  				     ipc6, rt);


I don't care much about corking perf, but might be better to implement
this "handing away" for ip6_append_data() as well to be more consistent
with ip6_make_skb().


> udp6_sendmsg(MSG_MORE) -> ip6_append_data() -> ip6_setup_cork()
> 
> what if ip6_setup_cork() errors out in that path?

-- 
Pavel Begunkov
