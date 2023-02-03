Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB06891BA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjBCIMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjBCILq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:11:46 -0500
X-Greylist: delayed 498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 00:11:09 PST
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F09953EC;
        Fri,  3 Feb 2023 00:11:09 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 9EB552B060A2;
        Fri,  3 Feb 2023 03:02:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 03 Feb 2023 03:02:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675411369; x=1675418569; bh=jMNVoa9gKw
        55vU4unYeVZ44RU46+1Ba6hlWIJchZw04=; b=M/azB01xSCNL0dVFFXXhUUrZ1J
        xxyAFJ5/QOMKVToH7P+sdG0wdk58Zz3cE9HwpWYBHTL/7GZTlAssDWiw3Y3Rd2DT
        Z3xXKyd9ufLT5bheY5jDc5znklf7q3H6EB/6e607kgfGBxVkHwPAhE6lDjlRzGma
        mQu/u67NeDR6pJy0OOoo2n/wa6veAjyootGh5sDezKwXHyCrdnT9jaqDPvddImTL
        9wz5bhFuuZVBsmY2uZXF/KqxeRInYQrWuwvJB6ApFVB+T51ZFkwxg6luxLa6Oktf
        GcVcgYfXkFYBFQC6x9AVjvLH7/YxINeoYlzAGqDQanoOMSSNDAYereDPdxFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675411369; x=1675418569; bh=jMNVoa9gKw55vU4unYeVZ44RU46+
        1Ba6hlWIJchZw04=; b=MVyoyvNsSdtKmETAp/lhuqiMCOf361FsKJX/fgwmLGjz
        GCXMPTVftGZRS5rWkDF3IvaWaYJducb95A0Rhago2RZfQ+DBAmGUYLWPzmCX8Ur4
        OdpwyLTZPNNFcPGso2xHHRK8DmPud87JICOt2PnP2rBhF39iEnouwmt5+sH5RJP0
        oluE9O+SkIC2e+MhD4GG+eunmlXAxw4t8RSgu1kUnDaXa1ACZgciUND7Six5pPD8
        Vq3Oo6MBhhMkw+a8B7S8h/kVKOM0I8mKoklmSk3uX+zYUIrzdNJ0GhGyjGCtLxFv
        8JMj63ObdKxJO67EQlj9IWR6TerR/AE1ZPX4KEIG9w==
X-ME-Sender: <xms:p7_cYwj2H2ApWxiWXFa-NfV0RETTS2yPBxFuJHiZuCfm3eDC5BGiHw>
    <xme:p7_cY5AN_avd_7jnBC0h6bc-z-nGFhN4F7xe4AnE-ms8duk-Ezmyba7bXbZrNt6N4
    DVNVYE8DK1nlg>
X-ME-Received: <xmr:p7_cY4F-Du1OoycKIijEWs9-hZ-DTu09Et-sCMqTp_Vtv66kTmGsNO1WvmanmgWybl1-VCX7MAkZPb_bUnx3AqNW2gdb7MND4KrpOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefledguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:p7_cYxQvo7aq9PKqcLhsnxuvehUBpL480xd5C0e0rAQFKuNiVcKn6A>
    <xmx:p7_cY9zHelrfzgM3S-pTqEzXaTqTMWouecS46kAtX_S7E_tXyh0x0g>
    <xmx:p7_cY_5cjV0KN8zgYYM-u6ixQA1hNzNBRU7Ew2kB3IyiaGeFp6CB7A>
    <xmx:qb_cYywLxYth8MDLcuLMwq1fUJQG6OfV2h59teJ3aldgf7BbZFffdVR5fj0>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Feb 2023 03:02:46 -0500 (EST)
Date:   Fri, 3 Feb 2023 09:02:44 +0100
From:   Greg KH <greg@kroah.com>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joneslee@google.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH][for stable {4.14, 4.19, 5.4}.y] ipv6: ensure sane device
 mtu in tunnels
Message-ID: <Y9y/pE4eusSxGGto@kroah.com>
References: <20230201095533.2628469-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201095533.2628469-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 09:55:33AM +0000, Tudor Ambarus wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]

Now queued up, thanks.

greg k-h
