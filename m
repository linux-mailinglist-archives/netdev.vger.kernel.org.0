Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82272627D30
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiKNL6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiKNL6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:58:18 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E762655C;
        Mon, 14 Nov 2022 03:56:03 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id k2so27734946ejr.2;
        Mon, 14 Nov 2022 03:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sx1dIYFjLrvxTaKKCGmsahHaqyYCMsIk3QD22Jj4IE0=;
        b=ap3IIP6kYwzR8zTi0n666gkZBfrgYRUQ728UeXT7gyKEFhHHA8WIviHv+pSrUpZCmy
         U9c7LsnOhtqmc7Yt8dL1/n79XMb+SR82LZQF63qTm8yPm8TNesPkk/rgy6gcdgDYi2xl
         f/d4uNjdsgotlMhhYW7uUOce1uKqBPm4Tj7otJe43bcK07tpuj1MAqmSA4jYOVNXvxY3
         6z6iiFW3vsA7//cBGJwkfcLW1y3fmT390GkDSE7zKizafDBGBpX0ixL7Vl2c+QEKJ+3o
         TS8bxrpiwFTcIA1rNguWk2/0FCOmr3ztq/m1sD4Qpu5xI2MCSUQxBPqfpPk1vyEINyrO
         Hc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sx1dIYFjLrvxTaKKCGmsahHaqyYCMsIk3QD22Jj4IE0=;
        b=tfNFQ/zBHVNMciU5jh2sXDkABGRQFSRJ1yWbXW/BCt1wEIN6zYkg7wKGssECIYMOxk
         ZHSjedYKsXKlaYHzXipcjbYcUauHIvuck+atWxNAsDZ/EDRilU8T1T01M//sfLaDU1kQ
         +wmSbM3nRFhPmolxIdZiZ+reUlCQMq6N5L8F+DPxB4x8tbLp4BuhyE2il5LNet2dxZMz
         qFtUgzha2XM6bxve1+8GQRzSti0OACLKcnAG4AXxEZ9NNG7bKH9F/lb+OSJCG05dxQCl
         5Ol1UnXO6Z1Qzx3dEU/XxTfUQ18YFQ8exFmkchinrFeU4yFIiAifWhbP5iko3wHmBJsO
         t9aA==
X-Gm-Message-State: ANoB5pmQkCtmMan6OmD7RXeuIwExZEmRll3R8XCZ+SywjkU+oIPcEx1m
        utCPz6LVNmdrJjuZfn9m4lg=
X-Google-Smtp-Source: AA0mqf7anyq6y3fe5I40Jv8ZCBds9MHfDeO5Q+krop4LkNYAtufB24bzRTtp6c5c06vEkZmXy0QNpg==
X-Received: by 2002:a17:906:94d9:b0:7ac:a2b7:6c97 with SMTP id d25-20020a17090694d900b007aca2b76c97mr9459842ejy.497.1668426962111;
        Mon, 14 Nov 2022 03:56:02 -0800 (PST)
Received: from skbuf ([188.27.184.37])
        by smtp.gmail.com with ESMTPSA id r18-20020a1709061bb200b0077d37a5d401sm4126402ejg.33.2022.11.14.03.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 03:56:01 -0800 (PST)
Date:   Mon, 14 Nov 2022 13:55:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221114115559.wl7efrgxphijqz4o@skbuf>
References: <20221110212212.96825-1-nbd@nbd.name>
 <20221110212212.96825-2-nbd@nbd.name>
 <20221111233714.pmbc5qvq3g3hemhr@skbuf>
 <20221111204059.17b8ce95@kernel.org>
 <bcb33ba7-b2a3-1fe7-64b2-1e15203e2cce@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb33ba7-b2a3-1fe7-64b2-1e15203e2cce@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 12:13:15PM +0100, Felix Fietkau wrote:
> On 12.11.22 05:40, Jakub Kicinski wrote:
> I don't really see a valid use case in running generic XDP, TC and NFT on a
> DSA master dealing with packets before the tag receive function has been
> run. And after the tag has been processed, the metadata DST is cleared from
> the skb.

Oh, there are potentially many use cases, the problem is that maybe
there aren't as many actual implementations as ideas? At least XDP is,
I think, expected to be able to deal with DSA tags if run on a DSA
master (not sure how that applies when RX DSA tag is offloaded, but
whatever). Marek Behun had a prototype with Marvell tags, not sure how
far that went in the end:
https://www.mail-archive.com/netdev@vger.kernel.org/msg381018.html
In general, forwarding a packet to another switch port belonging to the
same master via XDP_TX should be relatively efficient.

> How about this: I send a v4 which uses skb_dst_drop instead of skb_dst_set,
> so that other drivers can use refcounting if it makes sense for them. For
> mtk_eth_soc, I prefer to leave out refcounting for performance reasons.
> Is that acceptable to you guys?

I don't think you can mix refcounting at consumer side with no-refcounting
at producer side, no?

I suppose that we could leave refcounting out for now, and bug you if
someone comes with a real need later and complains. Right now it's a bit
hard for me to imagine all the possibilities. How does that sound?
