Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD3697E80
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjBOOiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjBOOhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:37:55 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BDE39BA9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:37:47 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id 65so7145917iou.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ULJNJgqVkKkqm/xPKSXLcU4te5AE7o8RLfilNMH+/zs=;
        b=SefQv7Oy/OjjwtWgx+5M4+nY3keturD1rFz3Rf8o0SNeRlPAKGB6PvEgL/ZILyD0at
         xRe67rJnOkMyu2hgFk19w7B0KcjKKbbyZmRdrDS6x67X/N/IxfHcq1TevSIPlIu/v8FT
         2m4XI0vzXTo2FRYNVUW5TaHmDrbWAFpb19mUS9cgQPR3yCy/4YnatTuXENq3HwY2LjPh
         IgCNgPCU5V5BzU3mgdGRsbQIgMhFhi24gXM/L7qauryUuIvLk7W2Zwa2cUY77Y3xlwmt
         GXOWZzljYj9NJX/J5YNAMG7I73+FtOQ5vIAnop2Caj/GLftLyPb7dqkpPDOV4A9Sv0qR
         TjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ULJNJgqVkKkqm/xPKSXLcU4te5AE7o8RLfilNMH+/zs=;
        b=TA5hPc93zRrKc/1i9s3DamvdDliFkaC8nvFhZaItE2kmr4DGYMD63dRu2LQqO6Fhcb
         Uwg60/LUCwA5xjGEIlBGqT6KgVAId6F9cJEPVxD/0I34OS4bH8oqB6w90KVLSWtow0qs
         Zg62Sc+akwGsty93N0AjA9363YCdDaCaJeRFsT5tGWvRIovyXJyYjnm9BerWFm9CTIOm
         Sn9eUs7qXiTLmBBDDAOK5rtLm4wkKx1+790trd47Qbp1OkumgrkRQy3Px30Ai0RJ6Vby
         lZ0Or5en7Q0jODcWJhj8YO3J8P+5Qyi9dS7M9BTM5ggotdYBjPUhK+QXGtlsFH7MSIjA
         XZgQ==
X-Gm-Message-State: AO0yUKW1GooCUAvDwC7CW4HINolIPfJKfygZliy3u5pS8k5gtpcjTanI
        lqD5QOWNVJdbHZQ1UY9BAuoQqhE/JN3kJSLy94bDrQ==
X-Google-Smtp-Source: AK7set+EG6PD2pgyAB/W+WPGI/yBe3xT/5pmvJ7UtQCDNXyGUgdqF61n0VNNpkFl9qd7t+uE7ejahRMQQMVQh1ghcsU=
X-Received: by 2002:a05:6638:1924:b0:3c4:e84b:2a40 with SMTP id
 p36-20020a056638192400b003c4e84b2a40mr757976jal.6.1676471866689; Wed, 15 Feb
 2023 06:37:46 -0800 (PST)
MIME-Version: 1.0
References: <20230215034444.482178-1-kuba@kernel.org> <20230215094332.GB9908@breakpoint.cc>
In-Reply-To: <20230215094332.GB9908@breakpoint.cc>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 15 Feb 2023 09:37:09 -0500
Message-ID: <CA+FuTSfjCvMAD9hf1JGOrSa57NZQ01n01-up3DF_bsf52N9MJw@mail.gmail.com>
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
To:     Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 4:43 AM Florian Westphal <fw@strlen.de> wrote:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
> > This is a bit more crazy than the previous patch. For drivers
> > which already use build_skb() it's relatively easy to add more
> > space to the shinfo. Use this approach to place skb_ext inside
> > the head. No allocation needed.
> >
> > This approach is a bit slower in trivial benchmarks than the recycling
> > because it requires extra cache line accesses (12.1% loss, ->18.6Gbps).
> >
> > In-place skb_ext may be shorter than a full skb_ext object.
> > The driver only reserves space for exts it may use.
> > Any later addition will reallocate the space via CoW,
> > abandoning the in-place skb_ext and copying the data to
> > a full slab object.
>
> I think the cleaner solution would be to move the new extension ids
> into sk_buff itself (at the end, uninitialized data unless used).

Grow struct sk_buff?

> Those extensions would always reside there and not in the slab object.
> Obviously that only makes sense for extensions where we assume
> that typical workload will require them, which might be a hard call to
> make.
>
> I concur with Paolo that the napi-caching is nicer/less intrusive,
> I think we have to wait and see if it helps with psp (async crypto
> needed?) when it lands.

How much data does psp need? The google version [1] embeds structs
psp_skb, which may include a 256b key. If on tx the key is looked up
from skb->sk, then on rx the only truly required field is the 32-bit
SPI, to match a decrypted packet's session key to the socket. With a
pointer hack on the lowest bits of skb->extensions such a tiny
extension could perhaps be embedded in the pointer field itself.

https://github.com/google/psp/blob/linux-v5.15-psp-v1.0/include/net/psp_defs.h
