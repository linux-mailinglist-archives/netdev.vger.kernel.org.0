Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B364A640B48
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiLBQyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiLBQx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:53:59 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E123BD159F;
        Fri,  2 Dec 2022 08:53:57 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id h4-20020a1c2104000000b003d0760654d3so5490685wmh.4;
        Fri, 02 Dec 2022 08:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4eDYB7izO2+mU8VAsQMFHb79zLnx9fUUMl79PfQKaVk=;
        b=HhrLyVX9SC0+SYfsKCTbyr7/lmb4mZGh6sjt7DqEcwRmTZOj89xYrdW46+q4I3UCgt
         L3JmHJUA8nEhTVteMFqfyOOMmjptbKmKSwjGA9tDtRrx8eFtWOPGdK4FIgeD9kzXuuEW
         vveB68FNbvrBk5BkiLYj1V9K4RwDSkToXCl3ZUtwT7Thg6GkX0vn9hW0jlw27v0yKj3f
         5bFsfMrAM8Ahzxyow1d9X2eWJNK2CPKfat2cjZzwn41WgxidBXGXGxh66erLxtrWhu0m
         e1UjKJ7uDYjmwmXm9HvsDbkRERixSKZrGZueDbD1tXmU22Uwd02JCcIEdRClzIeTju8V
         6TAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4eDYB7izO2+mU8VAsQMFHb79zLnx9fUUMl79PfQKaVk=;
        b=EUWGu80nyQTxCmbQi+OjnkfwHJJv92aGPilVEGMGgiKXW64aLBzrMVLVjsXK9L8V35
         MDefUcBYJ7337BKD55BMCWyQLzHzVqaZ6uw62ZhxG6IkTvp4WjgS5eWrD5DhfXbmGLpM
         foWqu38cz2LkRqZaOc8NhSYfo/ira8yXMZbfgubFusaK2fXS82C6XfcRpRVgYqN/AxZp
         LQ97nEioFt6c5SOrYBOSUeIjZCxwOFcoFwoJSujU4hfFXJHPeHB7D4iay8TR5dyoYvkd
         T4+pdot1oNGclWyZMWOfqY5336JmXmVtoEKMXbM7WsAZFw0EJNMHnAtwjgI91SqGR6VP
         JwfQ==
X-Gm-Message-State: ANoB5pnUXwa76Gt/s6+PNwOV3KzokpTEAvwZBFFVUC1p6VqeaQDSvYtz
        P2uMR2U8JQlmCSkJ8zElSolm4HDt63EzbdxkGIlOR6tQuY1LSQ==
X-Google-Smtp-Source: AA0mqf4UQ6oK7uRWtkwhBGChCWoTYJIad/Ihm1x7NfkVxPZgGtcbMBwnUZSt+XLdWrdZqzWG2xb8xJCTGXkgvYrEecQ=
X-Received: by 2002:a05:600c:4e46:b0:3d0:57ea:3188 with SMTP id
 e6-20020a05600c4e4600b003d057ea3188mr18818929wmq.28.1670000035865; Fri, 02
 Dec 2022 08:53:55 -0800 (PST)
MIME-Version: 1.0
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 2 Dec 2022 08:53:43 -0800
Message-ID: <CAA93jw6oECeUdqJTVZ3eVCAo5bPbHgAyNPBesRGwDHQ+qCtgcA@mail.gmail.com>
Subject: questions: LPM -> irq or queue mapping on the card for cake?
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org
Cc:     libreqos <libreqos@lists.bufferbloat.net>,
        Cake List <cake@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

all:

After a pretty long layoff from kernel development of any sort of
mine... we're pushing the limits again trying to get cake to support
10s of thousands of ISP subscribers, leveraging xdp for reads, and
ebpf "pping" for inline monitoring of TCP rtts, then a ton of htb bins
+ cake for each subscriber.

shameless plugs:

https://github.com/thebracket/cpumap-pping#cpumap-pping # everybody
needs kathie nichols and simon 's pping!!!
https://github.com/LibreQoE

(even more shameless plug - ask your isp to try libreqos.io out -
presently at 10k users, pushing 11gbit/sec, 24% of 16 cores! I'm
really, really amazed by all this, I remember struggling to get cake
to crack 50Mbits on a 600mhz mips box a decade back. Way to go
everyone! - love, rip van winkle)

Anyway... after adopting xdp fully over the past couple months... most
of the CPU time is now spent in htb, and while I see htb has been
successfully offloaded by the mlx5, it's not clear if that can pull
from from cake as an underlying qdisc (?), or only a pfifo, nor how
much buffering offloads like this introduce. ? Are there other cards
with an htb offload now?

Secondly -

The xdp path is marvelous, but in trying to drive this transparent
bridge to 100Gbit, I find myself wanting something old fashioned, and
in my mind, simpler than a match pattern - is there any ethernet card
that lets you do a TCAM mapping of a large (say, 128 thousand) set of
IP addresses to an irq or queue ?

1.2.3.4/29 -> irq 8 (or hw queue 8)
1.2.4.1/32 -> irq 9 (or hw queue 9)
a:b:c:d::/56 -> irq 8 (etc * 10s of thousands of other ip addresses, 1
or more LPM matches per subscriber)

Needn't be big enough to fill a bgp table...

This is different from RPS in that we don't want a rxhash to spread
the load "evenly", but to always direct a set of IP addresses to a
particular core, on a particular queue - which is setup to do all that
htb-ing (32k unique bins per core, e.g. 1.9m bins on 64 cores) and
cake-ing.

Other ideas for steppingstones on the march to 100gbit forwarding
through tons of cake gladly considered. We're going to be fiddling
with the metadata stuff in xdp as well - 3 hw hashes for cake, a rx
timestamp for codel will probably help there too.



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
