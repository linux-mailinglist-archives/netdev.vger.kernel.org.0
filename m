Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA85682B5B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjAaLYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAaLYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:24:38 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3BA49552;
        Tue, 31 Jan 2023 03:24:36 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qw12so24706253ejc.2;
        Tue, 31 Jan 2023 03:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5yhShQTG17uzw0WRoXPw0Cx2D1Z/lYVkEvXp799OzEk=;
        b=pENnLJ5+AHsRKrjLpgfnlpghuAYhJOh8LmAs3tw43gQRXZnb4Ch3gAOOdytE0L50E3
         4N1x6xOqpQwmqVEHHnlhd1dwTmn3WsdMYL9cIyt38MMwDBNpMSzog6wwbzbp7uYMCnl3
         h7CfsRUO7GPsODB7ADvzThOMeomLPK7J+SexEnpKbsz1M32eMp3JiHeUieYs5lZ9oi7L
         3IAXZepJ4R+VC13lwz7Km0UzbOmxA37w6qSEmdgmiq43lkaQf4SFG+OnQqPFl7tmr/QW
         L0Ea3ECrE6e2UgYFXhIgfUqlYX+q/pQQP4NyJBI9rQzQmXumvl87uA3uSKp9/3QQkIfX
         LpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5yhShQTG17uzw0WRoXPw0Cx2D1Z/lYVkEvXp799OzEk=;
        b=L+k7GgYmd+2hZLON1DBdMA9G134F56Dp1hxh8cS71d4ikNflTQI212XUyVv2b7+eH+
         +xDnv24CE7+ocH9VM9wRz8oDRh7YswNxdlOIuTl8apUi2apO75zfJO+w1edQAYXmxxZ5
         XX17oZY03Ux5wGn1Su9k6lV9hZDliPvtq6yTOMcChVJ1zf+v7dHnmXjSbVHvZTvoKtKc
         NflwrDsgPl6lXzoRaRzpfjGIYDwIkEq1UepYvAnDKUmLxpiZuMuUrsJy3Z0TB8AnFbfp
         3SJyaSmS2EdrTlA3yZCvliL9/Vci22GqB9Mw86S2BhpNEkra3dvUSyf+wow5URRbygQr
         L4aA==
X-Gm-Message-State: AO0yUKUFVnMmmN9C6ROH+bQGpLJCna8VOOtQ+7HRNBHQa9fFv1Q+ktZR
        OE/R245nAQnZG1aXDcmM3QPLDVGVdcLnknzpNv4=
X-Google-Smtp-Source: AK7set/Br25oHnhXcuU3UgLhXFHoDyj2IW9wCy+5Mxurk/M9p97GAhQXkCtB/oAnHGLT2tZlN85FUXWQQfctaNgZsbU=
X-Received: by 2002:a17:906:7108:b0:87b:d4df:32bc with SMTP id
 x8-20020a170906710800b0087bd4df32bcmr3543288ejj.303.1675164275273; Tue, 31
 Jan 2023 03:24:35 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
 <Y9fdRqHp7sVFYbr6@boxer> <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
 <192d7154-78a6-e7a0-2810-109b864bbb4f@intel.com>
In-Reply-To: <192d7154-78a6-e7a0-2810-109b864bbb4f@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 31 Jan 2023 19:23:59 +0800
Message-ID: <CAL+tcoBtQSeGi5diwUeg1LryYsB2wDg1ow19F2eApjh7hYbcsA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 7:08 PM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Jason Xing <kerneljasonxing@gmail.com>
> Date: Tue, 31 Jan 2023 11:00:05 +0800
>
> > On Mon, Jan 30, 2023 at 11:09 PM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> >>
> >> On Fri, Jan 27, 2023 at 08:20:18PM +0800, Jason Xing wrote:
> >>> From: Jason Xing <kernelxing@tencent.com>
> >>>
> >>> I encountered one case where I cannot increase the MTU size directly
> >>> from 1500 to 2000 with XDP enabled if the server is equipped with
> >>> IXGBE card, which happened on thousands of servers in production
> >>> environment.
> >>
> >
> >> You said in this thread that you've done several tests - what were they?
> >
> > Tests against XDP are running on the server side when MTU varies from
> > 1500 to 3050 (not including ETH_HLEN, ETH_FCS_LEN and VLAN_HLEN) for a
>

> BTW, if ixgbe allows you to set MTU of 3050, it needs to be fixed. Intel
> drivers at some point didn't include the second VLAN tag into account,

Yes, I noticed that.

It should be like "int new_frame_size = new_mtu + ETH_HLEN +
ETH_FCS_LEN + (VLAN_HLEN * 2)" instead of only one VLAN_HLEN, which is
used to compute real size in ixgbe_change_mtu() function.
I'm wondering if I could submit another patch to fix the issue you
mentioned because the current patch tells a different issue. Does it
make sense?

If you're available, please help me review the v3 patch I've already
sent to the mailing-list. Thanks anyway.
The Link is https://lore.kernel.org/lkml/20230131032357.34029-1-kerneljasonxing@gmail.com/
.

Thanks,
Jason

> thus it was possible to trigger issues on Q-in-Q setups. AICS, not all
> of them were fixed.
>
> > few days.
> > I choose the iperf tool to test the maximum throughput and observe the
> > behavior when the machines are under greater pressure. Also, I use
> > netperf to send different size packets to the server side with
> > different modes (TCP_RR/_STREAM) applied.
> [...]
>
> Thanks,
> Olek
