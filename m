Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0124FA061
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 02:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiDIACi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 20:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240117AbiDIAC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 20:02:27 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3264346E9C;
        Fri,  8 Apr 2022 17:00:22 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w21so15083106wra.2;
        Fri, 08 Apr 2022 17:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=M4fK1yo1NBIHG/5W6ZdoT+jscsUpt52urbAtX6EHweY=;
        b=Kbnf+OTmmmZ25Py7KZVEogMix9TXNLbqSs+Rby4Mck4nWKvGBvMG0Yu2oTCcjsopxe
         tac9vGLoQEqTba+57ySJl6CUS1A6BZRfBgzMYRR8hAbHS4wtx3oQCU0T6hEeF8h3Wljb
         p+UQLEGEkM6V1/rISJRGHb/h1YLXES7qXMHhPMOgiTRwGCT6g3mjF7XMWDXnqmX1KcCf
         5t92VacE8vcq5J0j4lKxfq/44xUYXoNAVfxhlKmHVeFvv/MrkmHedjUiuMd7R6ykF5Go
         jYmTt7ztJv9nQIMfoTzEGMD+MIMTr7RyTmna9GZkjOGr866lASWUreb/L/vHg0ygsbM9
         xMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=M4fK1yo1NBIHG/5W6ZdoT+jscsUpt52urbAtX6EHweY=;
        b=fJ7uNtVGTEJ55Cy3hwbQNzDqqIqwCslHmRCgXOFnhoC9aWGYJPdffaOASuFQihKSvE
         57d9SxHWVBRRXAwIhFRgtmWsxXOmglzExLbIwdLs5O5nrLwvc3m0UDXkn86PFCENWVMm
         /8IoFMBH1HxrdwbJX1KSgnFN3SginB31ucoVjf7tr4SlQTyEwVmuy+QGfIT6wxaOM95X
         Ni84ptKkoFOagDn9Ji2AX3lVaEE6KLmcKAXz6l9LNW1O9caQ407kbzr1z4FxnnXVLoMU
         g5wS6ykf9VkpM6UKn2SleQNhl8GRiJGQoGOHuXyGO/SUynUxge8joK3qonGzi68ZP8E1
         sQLw==
X-Gm-Message-State: AOAM531IGejP4ImILI1r4829/FqivV3ZPO4MJcgGOG895KxWUD0URVK7
        AZ7v5RXhT+o8FtzoAdfCPro=
X-Google-Smtp-Source: ABdhPJwsgzMxfu8oKABBvDjW9kco9sUI3QmbrtC5b9hgDi2efhG+oHaYpnT8EByLRhIHH6Va2p0drA==
X-Received: by 2002:a5d:6989:0:b0:206:1517:9b66 with SMTP id g9-20020a5d6989000000b0020615179b66mr16236897wru.583.1649462421298;
        Fri, 08 Apr 2022 17:00:21 -0700 (PDT)
Received: from smtpclient.apple ([185.238.38.242])
        by smtp.gmail.com with ESMTPSA id w7-20020a1cf607000000b00389a5390180sm11277078wmc.25.2022.04.08.17.00.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 17:00:20 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 03/15] net: dsa: mv88e6xxx: Replace usage of
 found with dedicated iterator
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220408235051.2a4hh7p3lee3a3xv@skbuf>
Date:   Sat, 9 Apr 2022 02:00:18 +0200
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
Content-Transfer-Encoding: 7bit
Message-Id: <56F3A9DE-C80A-4932-AFEA-BB82251C1199@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-4-jakobkoschel@gmail.com>
 <20220408123101.p33jpynhqo67hebe@skbuf>
 <C2AFC0FB-08EC-4421-AF44-8C485BF48879@gmail.com>
 <20220408235051.2a4hh7p3lee3a3xv@skbuf>
To:     Vladimir Oltean <olteanv@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 9. Apr 2022, at 01:50, Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> On Sat, Apr 09, 2022 at 01:44:00AM +0200, Jakob Koschel wrote:
>>> Let's try to not make convoluted code worse. Do the following 2 patches
>>> achieve what you are looking for? Originally I had a single patch (what
>>> is now 2/2) but I figured it would be cleaner to break out the unrelated
>>> change into what is now 1/2.
>> 
>> I do agree with not making convoluted code worse, but I was reluctant with
>> e.g. introducing new functions for this because others essentially
>> have the opposite opinion on this.
>> 
>> I however like solving it that way, it makes it a lot cleaner.
> 
> Yeah, I think 'just adapt to the context and style and intentions of the
> code you're changing and don't try to push a robotic one-size-fits-all
> solution' is sensible enough for an initial guiding principle.
> 
>>> If you want I can submit these changes separately.
>> 
>> Sure if you want to submit them separately, go ahead. Otherwise I can
>> integrate it into a v2, whatever you prefer essentially.
> 
> If you're moving quickly feel free to pick them up. I have lots of other
> things on my backlog so it won't be until late next week until I even
> consider submitting these.

I'm planning to send a v2 earlier than that, so I'll just integrate it there.

Thanks,
Jakob

