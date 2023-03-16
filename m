Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290FD6BCA5A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCPJID convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Mar 2023 05:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCPJIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:08:02 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCE11DBAD;
        Thu, 16 Mar 2023 02:08:00 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id x8so767915qvr.9;
        Thu, 16 Mar 2023 02:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678957679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/fl31BBlVFJAi6oH9xn+WckZTbTlMlbEViLMRe3e+w=;
        b=0szR45tNqrftj18TJiYyqxg2to9DUmN3cnUiZridEXwlOlU6utvCdPPBV3BK7hjhbV
         wOnVRfmfGRKdMgnt5g94Y8OOuEL6YqxITOPCw/ZvBW5+DB252RuAO888QOccEcEKqyc5
         3R/bel0WnS4aRk91DzwnVZgJVEObWlSq1NS63Gc+Mlv9unBDMz/pDtjbGzrkcPriFx+m
         OhLZLNxm7Rx8TqGLLoqLFRsODd2J0y7vuQ3zrR7ltXhXLcvmaHONcD9EpTvgA3IvTesh
         wuhGfaVVUc+cIbckiyUJoHovo+FYqUeyig1ypSXlAwP6AVcQampUpVfDVnccF/vXIqGR
         oZdA==
X-Gm-Message-State: AO0yUKVhwx3ojh0fURLMgyshDg/bEkt3czqD+hj/nc8Kq82O0BPmUosC
        P2u+NWLOGRe7dZq/tFiZlghAPZmtkSMrEQ==
X-Google-Smtp-Source: AK7set8V2i1TgK3/eDysnUUWfPSsknps6IzFV/7DG2LFp7e/qrk4SuUajYq4B24+0DXgt7Pr5Ronsw==
X-Received: by 2002:ad4:5f0d:0:b0:56e:a7cc:ea82 with SMTP id fo13-20020ad45f0d000000b0056ea7ccea82mr35078656qvb.39.1678957679393;
        Thu, 16 Mar 2023 02:07:59 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id b25-20020ac844d9000000b003b9a73cd120sm5358071qto.17.2023.03.16.02.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 02:07:59 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id r1so1013445ybu.5;
        Thu, 16 Mar 2023 02:07:58 -0700 (PDT)
X-Received: by 2002:a5b:68c:0:b0:b30:d9c:b393 with SMTP id j12-20020a5b068c000000b00b300d9cb393mr13541385ybq.12.1678957678454;
 Thu, 16 Mar 2023 02:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230316074558.15268-1-wsa+renesas@sang-engineering.com> <20230316074558.15268-2-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230316074558.15268-2-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Mar 2023 10:07:47 +0100
X-Gmail-Original-Message-ID: <CAMuHMdURZ-nC-yZua1wGCcW++fDhgd-U93KP3PT5v6cbm8305A@mail.gmail.com>
Message-ID: <CAMuHMdURZ-nC-yZua1wGCcW++fDhgd-U93KP3PT5v6cbm8305A@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "net: smsc911x: Make Runtime PM handling more fine-grained"
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Thu, Mar 16, 2023 at 8:46 AM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> This reverts commit 1e30b8d755b81b0d1585cb22bc753e9f2124fe87. Running
> 'ifconfig' with the interface down BUGs. This is the culprit:
>
>         smsc911x_get_stats from dev_get_stats+0xe4/0xf4
>
> The above function is called with the clocks off, so register read
> fails. Enabling clocks in the above functions does not work, because it
> is called in atomic context. So, let's return to the simple and working
> PM we had before.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Thanks for your patch!

In sh_eth this was fixed differently, by adding a check for
mdp->is_opened to sh_eth_get_stats() [1].
I believe the modern way would be to add a check for netif_running()
instead.

Would adding such a check to smsc911x_get_stats() work for you, too?

[1] 7fa2955ff70ce453 ("sh_eth: Fix sleeping function called from
invalid context")

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
