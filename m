Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B144C5789EA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiGRS53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiGRS5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:57:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146272F3A8;
        Mon, 18 Jul 2022 11:57:24 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d16so18372185wrv.10;
        Mon, 18 Jul 2022 11:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=oYTuc4/DRWvXe5SQe/vSL3YvfZj7x+zL85iy9BzZGls=;
        b=WN7b56VV0+j1LT2Sr8W8syKwr1u2FM7Q1ccbT7pNJZhSFv++Jh978Shq1vpU7/MtkV
         KE00/Xl49SOZvf/7fYVz1NhKFqcbkpzY5nIMQ1pICRjVJEx1v/6jKU5RTl96Z+s0bbV1
         BgxsAX1pOeFbh0zAlDucwenT6iB9MIcV5DMeVJVJxaQGXasitY2HBpoEUrh4tQNlbHEZ
         HhOrFQ5KQRQDVrHgWaxzwfODG4UACRu9QgWt+L1gC9Kc5yHB+F991RUeJsbZ4v5Xyi17
         VQF18K0C/7npf304PR20wPksMS6bK1OUV8pQpl77rFshkFmk9RMt0XiPfH7P51rMBxoa
         ZumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=oYTuc4/DRWvXe5SQe/vSL3YvfZj7x+zL85iy9BzZGls=;
        b=cAx+Ay8Ag4uO9u7I7HGNGdtaMsuJFNDCy/kHmtf6I804on9reiDV01o62DuKpGGAhk
         2P3JOWQpRhXQ7/vKbIhepNtVf9my1s3oVa8AOEZAGNYZTwMYx2dUitT8HzZZZztA7w+k
         CyDa3wteasvmDoNbBYuw/ud5abm40xeaW3GB/zTnHxzxJsKiO9xxoPBT/NLzI60iPtal
         ktUAJGhyf8VrRtNbMfG6v5kJ59jOFbVVQqkIPyxGrxZJN01PkI8Z8F0aXzdwaysPfjci
         Rk2XRQl0eCi4uT21bZFiFKnC/i0ylbiE25W4cXqpj1ijvfdAZgBbcUoI2nb/JW3o7Bnm
         3+Rg==
X-Gm-Message-State: AJIora8Ppe9w41WqfN3k3bcGvtWCHj89gcuLIII7EE+gbsvibcmGIjTb
        zTwum7UK7lmm2L1TQK58bA0=
X-Google-Smtp-Source: AGRyM1tYAyv13pwnqFuq+/MLxmvSnoutaAOgS27BzjGidoxBAlQjkGmawxVA/W0ZGO8mLI1JAanvhg==
X-Received: by 2002:adf:fe81:0:b0:21a:3574:ec8e with SMTP id l1-20020adffe81000000b0021a3574ec8emr24390868wrr.410.1658170642392;
        Mon, 18 Jul 2022 11:57:22 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id az36-20020a05600c602400b003a31ba538c2sm4518704wmb.40.2022.07.18.11.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:57:22 -0700 (PDT)
Message-ID: <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
X-Google-Original-Message-ID: <YtWpDt8FIHRi7tju@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 20:40:14 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718184017.o2ogalgjt6zwwhq3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:40:17PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 07:55:26PM +0200, Christian Marangi wrote:
> > Sure.
> > When the regmap conversion was done at times, to limit patch delta it
> > was suggested to keep these function. This was to not get crazy with
> > eventual backports and fixes.
> > 
> > The logic here is:
> > As we are moving these function AND the function will use regmap api
> > anyway, we can finally drop them and user the regmap api directly
> > instead of these additional function.
> > 
> > When the regmap conversion was done, I pointed out that in the future
> > the driver had to be split in specific and common code and it was said
> > that only at that times there was a good reason to make all these
> > changes and drop these special functions.
> > 
> > Now these function are used by both setup function for qca8k and by
> > common function that will be moved to a different file.
> > 
> > 
> > If we really want I can skip the dropping of these function and move
> > them to qca8k common code.
> 
> I don't really have a preference, I just want to understand why you want
> to call regmap_read(priv->regmap) directly every time as opposed to
> qca8k_read(priv) which is shorter to type and allows more stuff to fit
> on one line.

The main reason is that it's one less function. qca8k_read calls
directly the regmap ops so it seems a good time to drop it.

> 
> I think if you run "make drivers/net/dsa/qca/qca8k.lst" and you look at
> the generated code listing before and after, you'll find it is identical
> (note, I haven't actually done that).
> 
> > An alternative is to keep them for qca8k specific code and migrate the
> > common function to regmap api.
> 
> No, that's silly and I can't even find a reason to do that.
> It's not like you're trying to create a policy to not call qca8k-common.c
> functions from qca8k-8xxx.c, right? That should work just fine (in this
> case, qca8k_read etc).

The idea of qca8k-common is to keep them as generilized as possible.
Considering ipq4019 will have a different way to write/read regs we can't
lock common function to specific implementation.

> 
> In fact, while typing this I realized that in your code structure,
> you'll have one struct dsa_switch_ops in qca8k-8xxx.c and another one in
> qca8k-ipq4019.c. But the vast majority of dsa_switch_ops are common,
> with the exception of .setup() which is switch-specific, correct?

Phylink ops will also be different as ipq4019 will have qsgmii and will
require some calibration logic.

> 
> Wouldn't you consider, as an alternative, to move the dsa_switch_ops
> structure to the common C file as well, and have a switch-specific
> (*setup) operation in the match_data structure? Or even much better,
> make the switch-specific ops as fine-grained as possible, rather than
> reimplementing the entire qca8k_setup() (note, I don't know how similar
> they are, but there should be as little duplication of logic as possible,
> the common code should dictate what there is to do, and the switch
> specific code just how to do it).
> 

qca8k_setup will require major investigation and I think it would be
better to do do a qca8k_setup generalization when ipq4019 will be
proposed.

On the other hand I like the idea of putting the qca8k ops in common.c
and make the driver adds the relevant specific options.
Think I will also move that to common.c. That would permit to keep
function static aka even less delta and less bloat in the header file.

(is it a problem if it won't be const?)

> > So it's really a choice of drop these additional function or keep using
> > them for the sake of not modifying too much source.
> > 
> > Hope it's clear now the reason of this change.
> 
> If I were to summarize your reason, it would be "because I prefer it
> that way and because now is a good time", right? That's fine with me,
> but I honestly didn't understand that while reading the commit message.

I have to be honest... Yes you are right... This is really my opinion
and I don't have a particular strong reason on why dropping them.

It's really that I don't like keeping function that are just leftover of
an old implementation. But my target here is not argue and find a
solution so it's OK for me if I should keep these compat function and
migrate them to common.c.

-- 
	Ansuel
