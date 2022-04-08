Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4752E4FA046
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbiDHXxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbiDHXxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:53:04 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F5FD0A8D;
        Fri,  8 Apr 2022 16:50:56 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i27so20164477ejd.9;
        Fri, 08 Apr 2022 16:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SUqMtItyQZq0VImWzHlQNyf9xOR5YZgjl7HG7ggaASA=;
        b=nJriARLQYTMhH8chWXt44TKYI93PSDPUJtZYNgzWWUVvzVxPGiCZEEj1or0iOTefo6
         cFscWaA85nZ2Y/kClhUqsgDfbrhKPUZDkkzyM5PK+amxjD4B9bkaMfh3UvILoEcBIGVp
         pD9y/wuXRsQe30azkivrcgDlMms0jSrgpc0B4YRML0nOkZ8W8oa2xa3dmJEJI48q7Lph
         hERaCN4LvyngWLcE/nNTdaJoURQxBLZ0UWrRoEU5cNkW9BTCN6Tydlp6kYyBV95RnXZw
         p2O6zP4x77KUbOQ1olKZSBNoc7+rWVjcHZXqzKdeMH9GniNs2g4IkkVS8/3XGbjIDWwo
         0yJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SUqMtItyQZq0VImWzHlQNyf9xOR5YZgjl7HG7ggaASA=;
        b=8DPEZRpXJWWK2l766VV0YM7MbJPzXNZcKhKEtBwwll0TVZ6RXYkEiMUwBqKywHkwId
         QrULu6Q2HkRO5VL9BZFp5ObTBAKkq4nVdAqrafVV0+KZ0RbijlxbfCjpYKmX9aFofvdl
         3TALe/aUsSoZMPs9j3UHlqYrUGSHas2X6OXc5r87siL17KZ4WYyJrco9fEI9DxckRX2e
         sV/GTb/BtaTIU9JwdaRLmek+JOq/FG7IKh+aCSRJv7EUOSTBRnYcgQy+x3QtLp27Ozdk
         sEpDnvP/+wUB7rjmzfb5qKqoY5sT/nOToqlQq8ATTFmF8xmb1Y4262FF4DQBpFrGsNaF
         BSbA==
X-Gm-Message-State: AOAM533FUz76f6oZV7KItkI9wr477PfSkyg0kWcuNtCcQx/3Y/14UzAZ
        tvfiBHtcAB03jqWEF6RxH30=
X-Google-Smtp-Source: ABdhPJx48I6qNVXy5JRlDDppagH8Z8UT68EDC0Z1VNqIiGnngdmjei8lBxcmBqvnL8jnUCdrueVd4Q==
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr20667399ejc.762.1649461854531;
        Fri, 08 Apr 2022 16:50:54 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id w14-20020a509d8e000000b0041cd217726dsm7443672ede.4.2022.04.08.16.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:50:54 -0700 (PDT)
Date:   Sat, 9 Apr 2022 02:50:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 03/15] net: dsa: mv88e6xxx: Replace usage of
 found with dedicated iterator
Message-ID: <20220408235051.2a4hh7p3lee3a3xv@skbuf>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-4-jakobkoschel@gmail.com>
 <20220408123101.p33jpynhqo67hebe@skbuf>
 <C2AFC0FB-08EC-4421-AF44-8C485BF48879@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2AFC0FB-08EC-4421-AF44-8C485BF48879@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:44:00AM +0200, Jakob Koschel wrote:
> > Let's try to not make convoluted code worse. Do the following 2 patches
> > achieve what you are looking for? Originally I had a single patch (what
> > is now 2/2) but I figured it would be cleaner to break out the unrelated
> > change into what is now 1/2.
> 
> I do agree with not making convoluted code worse, but I was reluctant with
> e.g. introducing new functions for this because others essentially
> have the opposite opinion on this.
> 
> I however like solving it that way, it makes it a lot cleaner.

Yeah, I think 'just adapt to the context and style and intentions of the
code you're changing and don't try to push a robotic one-size-fits-all
solution' is sensible enough for an initial guiding principle.

> > If you want I can submit these changes separately.
> 
> Sure if you want to submit them separately, go ahead. Otherwise I can
> integrate it into a v2, whatever you prefer essentially.

If you're moving quickly feel free to pick them up. I have lots of other
things on my backlog so it won't be until late next week until I even
consider submitting these.
