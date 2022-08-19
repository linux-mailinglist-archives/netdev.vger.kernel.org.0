Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B76E599616
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347016AbiHSH1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347004AbiHSH1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:27:47 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C202E1A9B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:27:47 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id h20-20020a056830165400b00638ac7ddba5so2586532otr.4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=d1YK3cHo/ht4IrV9YkvxdYQJevkGU+HT8R6IvDjzLLg=;
        b=VzaPrJTeFqlnsPLpa6T2qKpd8XOo6iOWnB3OTLzaxwDV3qpubco8arbS4a2mn8wOD1
         yrkTFxAhvAm1ZNbKAtwR0lRtDqjC6vfoVNlXljsbpnEQolgFJoJHgIPPJzlCctxLdip/
         W1k/VBYwcWmrGJ6D8AExMdFTiGLWtUAtCgJPvd814Vl0Qq4r+03v+I9GZ/Jp22WhPKt5
         AaUn5IJEkMjjycc0IdmnK0+1fhE7viEThCpTTmUTsXMjMovrnBFDalWoceuyOZxe5zsC
         2UAH/bgFoN41xB1wpslhnpIeEeX0g+u1/dbLnuBKqANuDxykok1XKBxQzq4XqwSNK2PI
         9dDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=d1YK3cHo/ht4IrV9YkvxdYQJevkGU+HT8R6IvDjzLLg=;
        b=8AdfFxji1tG0oN5WvN44OlUTzKp8kMDDdRBUzvGoNQ8apIoc6YDI2viy6/jyYJLP3S
         p6bG7Nphabo3TITDDUO2ADEDIA+tDSKfrNOOTzCPNrAAurrCv5saRy3s/NWlQ/LMu/GM
         mCV8GcC7C7XQ05IYIQC8ASMQNMrU5h2hLrxBbAT7oGrENKUrLeaFclBbxCaNeO2frrdg
         XYGN0lUjzKFAj3REbObcZhtW0RIMcpZSkyPiQWO46XcWf/8TTk2TH9VHSEM0t8D8x5IB
         9TWdj2daSlS41Lxc/c6A07SF1RKkW3s/8DbGNKimtRj2zl2tu0/TlM58yR9mjgD3Am5u
         ufSw==
X-Gm-Message-State: ACgBeo0KtwUJGoJ4ME/L1fhiwhW+SD6QxyqivtrPqBeAS5F99Icm+RaD
        40gV/fCoHgU1iyCdYuCXi8smD73bYkI63Pm+jRw=
X-Google-Smtp-Source: AA6agR5aUuWr+wPjsJYzpnW6qX0+iPl5PgRw0gXT8lKgbo8ltJ76WjK87XyXrcaDjLISHxTeHnRUd7FzkD+kY7kW+Lo=
X-Received: by 2002:a05:6830:630f:b0:61c:7c8b:ed18 with SMTP id
 cg15-20020a056830630f00b0061c7c8bed18mr2538064otb.168.1660894066529; Fri, 19
 Aug 2022 00:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220818182948.931712-1-saproj@gmail.com> <Yv6QenTMPkO6gSTI@lunn.ch>
In-Reply-To: <Yv6QenTMPkO6gSTI@lunn.ch>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Fri, 19 Aug 2022 10:27:35 +0300
Message-ID: <CABikg9zWrchOQdaQ-MTQe6kw6ocRxEgkeAvL4zhUOkwiNfSDtA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: moxa: do not call dma_unmap_single() with null
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 at 22:18, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Aug 18, 2022 at 09:29:47PM +0300, Sergei Antonov wrote:
> > It fixes a warning during error unwinding:
> >
> > WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:963 check_unmap+0x704/0x980
> > DMA-API: moxart-ethernet 92000000.mac: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=1600 bytes]
> > CPU: 0 PID: 1 Comm: swapper Not tainted 5.19.0+ #60
> > Hardware name: Generic DT based system
> >  unwind_backtrace from show_stack+0x10/0x14
> >  show_stack from dump_stack_lvl+0x34/0x44
> >  dump_stack_lvl from __warn+0xbc/0x1f0
> >  __warn from warn_slowpath_fmt+0x94/0xc8
> >  warn_slowpath_fmt from check_unmap+0x704/0x980
> >  check_unmap from debug_dma_unmap_page+0x8c/0x9c
> >  debug_dma_unmap_page from moxart_mac_free_memory+0x3c/0xa8
> >  moxart_mac_free_memory from moxart_mac_probe+0x190/0x218
> >  moxart_mac_probe from platform_probe+0x48/0x88
> >  platform_probe from really_probe+0xc0/0x2e4
> >
> > Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
> > Signed-off-by: Sergei Antonov <saproj@gmail.com>
>
> This looks correct as it is:
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> But i do wonder how it go into the situation:

An error during moxart_mac_probe() does "goto init_fail;" which calls
moxart_mac_free_memory(). And by that time, priv->rx_mapping[i] are
all zero yet.
