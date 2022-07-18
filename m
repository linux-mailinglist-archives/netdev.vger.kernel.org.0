Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90705789A8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiGRSkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGRSkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:40:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319702CDF8;
        Mon, 18 Jul 2022 11:40:22 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l23so22931478ejr.5;
        Mon, 18 Jul 2022 11:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YQZ4hkmofUhfG0hpaOlmyoB24uIldHkWpuCcbjQxnPE=;
        b=mE6wPL2iVcfqpPq/bbW79XZTpuNGGC5aJJETfs1MUf/dxxisb2NozYSEJcSsy0Vu9d
         acS22sZcx4arjRg/OcIa43PEttTu6VoHz1C1Yr98WS4JETSpuXRy5KCRKg5Vbye88bXm
         VE43MIQFvXjnkrAtUM/qwCJO+hONECTenCUT0gTZvoAprTC1+89xBIC+vD1uhLi2PN1V
         JQVliRiWyiLWQik1/9kJFWXLxxooic6bOgOQiBKax1zUaU7Ix1OJDer2AexKdj2M0Sbw
         z5izHsi1udeI84ig5FPQN+iN8UWY+C5BdgwMktsDEo1Y1bjSt9ZKFXL/uZSuF7I9ebnL
         vrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YQZ4hkmofUhfG0hpaOlmyoB24uIldHkWpuCcbjQxnPE=;
        b=xezzCIIhbAChMzrTn46dJHxKnXgYIRu7LDznKzY5popI022iDYHwYSLNkeUZQItbbf
         ISooFnYgcsTUkDOwPNcEz+x2hb78Snv4t50Li2n5E0v7a1sCnGT77p1n8A2gOz46Pt/Y
         swEDrFP1hQECQFXI6BjJxtY7GoLZ9El8Le3rmmPsJVPaSJ4ETQuC4hmsl3QSnkBXVWMb
         hxnVDfgHVP3Cx6qsamTyVmRhYjd20QyMd0pXxGDChe4el0zZO9MV54RLbvkA1127q1MC
         Chy3Dw11L4JdKFg0CrJqZMaSe3Bnzxo3EmuYN1JUyKyfwlt3Hj3bAMFepELyYaUia1RT
         kW8g==
X-Gm-Message-State: AJIora+bQKyWN1VoSyPqwlP5dU8cWyYSmOn5izS1HZuQ9H1A4eWjCYKV
        QNELKmJmRzmTEWQ5TRqHIa4=
X-Google-Smtp-Source: AGRyM1uq0RdKdIa8KzAwQkfOG7kjQ9Ytt8ivRmAQhd/r4F2J//WgAo1812A/mQZpl5pBBnG/ck9ptA==
X-Received: by 2002:a17:906:cc5a:b0:72b:1459:6faa with SMTP id mm26-20020a170906cc5a00b0072b14596faamr27383948ejb.221.1658169620561;
        Mon, 18 Jul 2022 11:40:20 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id ev18-20020a17090729d200b0072abb95eaa4sm5773747ejc.215.2022.07.18.11.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:40:19 -0700 (PDT)
Date:   Mon, 18 Jul 2022 21:40:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
Message-ID: <20220718184017.o2ogalgjt6zwwhq3@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 07:55:26PM +0200, Christian Marangi wrote:
> Sure.
> When the regmap conversion was done at times, to limit patch delta it
> was suggested to keep these function. This was to not get crazy with
> eventual backports and fixes.
> 
> The logic here is:
> As we are moving these function AND the function will use regmap api
> anyway, we can finally drop them and user the regmap api directly
> instead of these additional function.
> 
> When the regmap conversion was done, I pointed out that in the future
> the driver had to be split in specific and common code and it was said
> that only at that times there was a good reason to make all these
> changes and drop these special functions.
> 
> Now these function are used by both setup function for qca8k and by
> common function that will be moved to a different file.
> 
> 
> If we really want I can skip the dropping of these function and move
> them to qca8k common code.

I don't really have a preference, I just want to understand why you want
to call regmap_read(priv->regmap) directly every time as opposed to
qca8k_read(priv) which is shorter to type and allows more stuff to fit
on one line.

I think if you run "make drivers/net/dsa/qca/qca8k.lst" and you look at
the generated code listing before and after, you'll find it is identical
(note, I haven't actually done that).

> An alternative is to keep them for qca8k specific code and migrate the
> common function to regmap api.

No, that's silly and I can't even find a reason to do that.
It's not like you're trying to create a policy to not call qca8k-common.c
functions from qca8k-8xxx.c, right? That should work just fine (in this
case, qca8k_read etc).

In fact, while typing this I realized that in your code structure,
you'll have one struct dsa_switch_ops in qca8k-8xxx.c and another one in
qca8k-ipq4019.c. But the vast majority of dsa_switch_ops are common,
with the exception of .setup() which is switch-specific, correct?

Wouldn't you consider, as an alternative, to move the dsa_switch_ops
structure to the common C file as well, and have a switch-specific
(*setup) operation in the match_data structure? Or even much better,
make the switch-specific ops as fine-grained as possible, rather than
reimplementing the entire qca8k_setup() (note, I don't know how similar
they are, but there should be as little duplication of logic as possible,
the common code should dictate what there is to do, and the switch
specific code just how to do it).

> So it's really a choice of drop these additional function or keep using
> them for the sake of not modifying too much source.
> 
> Hope it's clear now the reason of this change.

If I were to summarize your reason, it would be "because I prefer it
that way and because now is a good time", right? That's fine with me,
but I honestly didn't understand that while reading the commit message.
