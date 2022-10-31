Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9705C613FCD
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 22:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiJaVRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 17:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiJaVR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 17:17:27 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9211403A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 14:17:21 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id k4so5549994qkj.8
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 14:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yradgPL/ByAxbPQMnqez5yUnx3OZ/BJsgva6K9y/eZM=;
        b=qgif2OgWz/eegfbs3K9teAoZh8jyjoJgum9u1n7rSqK1A/SZWlCq2SEVv2ED3LnwKD
         P39+E2pLSN5/AFm4O8mToJDTR6nb1GfyhQybHBiC1q4F02sqs/1wRZZMvIbH+04aDBbA
         VPcIKwCcwTFg1Tg4FxiykphTlZKNlnNbm9ax7Ow5tCZeEBa1efnWREsKSUmXs+ffS1yG
         YPW/t0FuBTdDdH5LfbQ3mfP2XhDGfiIuWZRrkakMJeGBpPitZe0tR8oXOi4t3vtZErjc
         WpPAhYt5MZQrKvcyE+dFdG+ZZp0M2n+HaIrAzyzjbuiPqf6vBtkor9vmkHmEvR8o7+ge
         eV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yradgPL/ByAxbPQMnqez5yUnx3OZ/BJsgva6K9y/eZM=;
        b=NyHFkwcDqVa8TKKe9Id1pLHqAb+dWQX1gtMjBoweH3q3ee+cjHeSfeh3by7FGkCE5W
         kHGM6+qrNSY8gf7EjR4zHWSqjTnM9hL1yJ7ZBUlj1zrXhG2CKttyBXUEMqvsSmq0AI0T
         yfcYRuItMlk5C2SZC6IO/jk2uJL2/zPr9D0W5s+52bnsntbWisWaUly57ZfKyCDdLtiJ
         lYE9JLpZrPfm1O1MVlCe16eKI1p2JZqy63mocOosTqlJSuWFMXobxIfcNnG80zae8KGh
         6JWEEaueHxg2dDsTH3KPrsCVSwoZFdY6n++JfgpQg5nT6KII36mVR5qbXw3mPxge1BvN
         fEXA==
X-Gm-Message-State: ACrzQf3ia40bglQ9yIi9DAFTI/ilm9cv0yf8pDvddAQ4wbmpGHDRa9OM
        1HSvNSb9GcRHNpTx2n9TWYMoxo39CPE=
X-Google-Smtp-Source: AMsMyM5+Tlu0EdkNFoB7Jg+5EBP0Nz2hXGBKNI4gjqSgt56AZlAJ3LnMng4J3T6T7z/mnBRFgo7aAA==
X-Received: by 2002:a37:6347:0:b0:6f8:e1c1:97c0 with SMTP id x68-20020a376347000000b006f8e1c197c0mr10863190qkb.308.1667251040374;
        Mon, 31 Oct 2022 14:17:20 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id g4-20020ac81244000000b0039cb9b6c390sm4151844qtj.79.2022.10.31.14.17.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 14:17:19 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-36ad4cf9132so119862257b3.6
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 14:17:19 -0700 (PDT)
X-Received: by 2002:a81:f04:0:b0:36a:d4bf:c187 with SMTP id
 4-20020a810f04000000b0036ad4bfc187mr14426623ywp.208.1667251039196; Mon, 31
 Oct 2022 14:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
 <20221029104131.07fbc6cf@blondie> <CA+FuTSdkOMBahoeLsXV8wnGdqNtmUHHDu-9xn9JX6zY3M4VmVw@mail.gmail.com>
 <20221031175206.50a54083@griffin>
In-Reply-To: <20221031175206.50a54083@griffin>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 31 Oct 2022 17:16:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSebSMp76U83RpGZVxf=p_Zb9FNH2kScB521x1Z+1zEu9g@mail.gmail.com>
Message-ID: <CA+FuTSebSMp76U83RpGZVxf=p_Zb9FNH2kScB521x1Z+1zEu9g@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: fix panic on frag_list with mixed head
 alloc types
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        alexanderduyck@meta.com, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 12:53 PM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Sat, 29 Oct 2022 10:10:03 -0400, Willem de Bruijn wrote:
> > If a device has different allocation strategies depending on packet
> > size, and GRO coalesces those using a list, then indeed this does not
> > have to hold. GRO requires the same packet size and thus allocation
> > strategy to coalesce -- except for the last segment.
>
> That's exactly what I saw: the last segment was different.
>
> However, I don't see anything in the GRO code that enforces that. It
> appears that currently, it just usually happens that way. When there's
> a burst of packets for the given flow on the wire, only the last
> segment is small (and thus malloced) and there's no immediate packet
> following for the same flow. What would happen if (for whatever reason)
> there was such packet following?

This is enforced. In tcp_gro_receive:

        /* If skb is a GRO packet, make sure its gso_size matches
prior packet mss.
         * If it is a single frame, do not aggregate it if its length
         * is bigger than our mss.
         */
        if (unlikely(skb_is_gso(skb)))
                flush |= (mss != skb_shinfo(skb)->gso_size);
        else
                flush |= (len - 1) >= mss;

        [..]

        /* Force a flush if last segment is smaller than mss. */
        if (unlikely(skb_is_gso(skb)))
                flush = len != NAPI_GRO_CB(skb)->count *
skb_shinfo(skb)->gso_size;
        else
                flush = len < mss;

That branch and the comment is very new, introduced with GRO support
for HW-GRO packets. But the else clauses are not new.

>
> > I don't see any allocation in vmxnet3 that uses a head frag, though.
> > There is a small packet path (rxDataRingUsed), but both small and
> > large allocate using a kmalloc-backed skb->data as far as I can tell.
>
> I believe the logic is that for rxDataRingUsed,
> netdev_alloc_skb_ip_align is called to alloc skb to copy data into,
> passing to it the actual packet length. If it's small enough,
> __netdev_alloc_skb will kmalloc the data. However, for !rxDataRingUsed,
> the skb for dma buffer is allocated with a larger length and
> __netdev_alloc_skb will use page_frag_alloc.

That explains perfectly.

> I admit I've not spend that much time understanding the logic in the
> driver. I was satisfied when the perceived logic matched what I saw in
> the kernel memory dump. I may have easily missed something, such as
> Jakub's point that it's not actually the driver deciding on the
> allocation strategy but rather __netdev_alloc_skb on its own. But the
> outcome still seems to be that small packets are kmalloced, while
> larger packets are page backed. Am I wrong?
>
> > In any case, iterating over all frags is more robust. This is an edge
> > case, fine to incur the cost there.
>
> Thanks! We might get a minor speedup if we check only the last segment;
> but first, I'd like to be proven wrong about GRO not enforcing this.
> Plus, I wonder whether the speedup would be measurable if we have to
> iterate through the list to find the last segment anyway.
>
> Unless there are objections or clarifications (and unless I'm wrong
> above), I'll send a v2 with the commit message corrected and with the
> same code.

Sounds good to me, thanks.

>
> Thanks to all!
>
>  Jiri
>
