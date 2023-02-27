Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2576A4F0C
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 23:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjB0W6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 17:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0W6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 17:58:52 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD7765B4;
        Mon, 27 Feb 2023 14:58:50 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so8315091wms.2;
        Mon, 27 Feb 2023 14:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6xWs38kFFRDAh0TFymIbiQKfi/uzaXf1tagUWDeIW0=;
        b=Dq6vHEXxVniMMEpmWwFKAkW+Zc2x83TVWydAdMc3glHrI0mwLUgp5yzfANsu0QEKnG
         0ZJJB7b3+19u/s77805CpMG5TsShphc7wFKJT/uLFtdr+rLRcn5vPShcCUMl8BtQa6h0
         wh3KHNSIR3xfINBdaKRCRkFdAl3FwskI63Ce4H5ctJ2IN9CHLiW6zcDo+Nsl8yxlvbIX
         rfmGaWz118gk//ZxJH61pp3BJavGZqsOaIIsP3ULVvPl6vKXrrrXzp4CuzUp75AlP8Qp
         FD8xHmsXNDy5M2Vv1It+2zuUFcry8wOmxxXcKeneRJmMIEatx+qeDSJO92on4CEDbNPT
         dpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H6xWs38kFFRDAh0TFymIbiQKfi/uzaXf1tagUWDeIW0=;
        b=CLet/afrIdZN5qn3YzDUNjk1kqhq8Ak6kDNQWTrcc2qg7L6xCuVl6SpQJ1pZyl6fcB
         Xr8FCKrVGNKq1h8b4EzGWNJxGKbTO0vL+/cXl9APRwGoUJLPZ5iyBnQKilKUoDXBkQY0
         RvGul4cDVj5QwxyKkp72UHtFQlVmMZ9MKdLTSACW6DJYRNGHuSeRw/v2FgqM9ngdc0on
         zH+nLMoAZ/AEZQ+6zqdbZSJgWyMeAg16gZUN60vtV90A+qtkAyNL2MhWPAfY2orGKYbw
         mAvTScJbKQRvnmhLAgqpnj+Yd5WIxSu0pywzNpzicMpO7rCMHHNSPq0ra45gLv8IPgTk
         h1Og==
X-Gm-Message-State: AO0yUKVfimPOzmZf5RVNVIrxezY+0xkUxEfcQu7kZJwdDLK3R0/WLokf
        g/lTVtPR7uNScw8A+b9aEEhhVopwmq4=
X-Google-Smtp-Source: AK7set8xecthH7WDnyqAS2Sx3sy62KG6JBF5aaG2pGLKBeVULhlH0EvAwOxFgOkVbSAZcaYZav/yQQ==
X-Received: by 2002:a05:600c:3b28:b0:3eb:3104:efe7 with SMTP id m40-20020a05600c3b2800b003eb3104efe7mr606906wms.23.1677538728724;
        Mon, 27 Feb 2023 14:58:48 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id u17-20020adff891000000b002c553e061fdsm8115016wrp.112.2023.02.27.14.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 14:58:48 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in
 BPF
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <cf49a091-9b14-05b8-6a79-00e56f3019e1@gmail.com>
 <20230227220406.4x45jcigpnjjpdfy@kashmir.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <cc4712f7-c723-89fc-dc9c-c8db3ff8c760@gmail.com>
Date:   Mon, 27 Feb 2023 22:58:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230227220406.4x45jcigpnjjpdfy@kashmir.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/02/2023 22:04, Daniel Xu wrote:
> I don't believe full L4 headers are required in the first fragment.
> Sufficiently sneaky attackers can, I think, send a byte at a time to
> subvert your proposed algorithm. Storing skb data seems inevitable here.
> Someone can correct me if I'm wrong here.

My thinking was that legitimate traffic would never do this and thus if
 your first fragment doesn't have enough data to make a determination
 then you just DROP the packet.

> What I find valuable about this patch series is that we can
> leverage the well understood and battle hardened kernel facilities. So
> avoid all the correctness and security issues that the kernel has spent
> 20+ years fixing.

I can certainly see the argument here.  I guess it's a question of are
 you more worried about the DoS from tricking the validator into thinking
 good fragments are bad (the reverse is irrelevant because if you can
 trick a validator into thinking your bad fragment belongs to a previously
 seen good packet, then you can equally trick a reassembler into stitching
 your bad fragment into that packet), or are you more worried about the
 DoS from tying lots of memory down in the reassembly cache.
Even with reordering handling, a data structure to record which ranges of
 a packet have been seen takes much less memory than storing the complete
 fragment bodies.  (Just a simple bitmap of 8-byte blocks — the resolution
 of iph->frag_off — reduces size by a factor of 64, not counting all the
 overhead of a struct sk_buff for each fragment in the queue.  Or you
 could re-use the rbtree-based code from the reassembler, just with a
 freshly allocated node containing only offset & length, instead of the
 whole SKB.)
And having a BPF helper effectively consume the skb is awkward, as you
 noted; someone is likely to decide that skb_copy() is too slow, try to
 add ctx invalidation, and thereby create a whole new swathe of potential
 correctness and security issues.
Plus, imagine trying to support this in a hardware-offload XDP device.
 They'd have to reimplement the entire frag cache, which is a much bigger
 attack surface than just a frag validator, and they couldn't leverage
 the battle-hardened kernel implementation.

> And make it trivial for the next person that comes
> along to do the right thing.

Fwiw the validator approach could *also* be a helper, it doesn't have to
 be something the BPF developer writes for themselves.

But if after thinking about the possibility you still prefer your way, I
 won't try to stop you — I just wanted to ensure it had been considered.

-ed
