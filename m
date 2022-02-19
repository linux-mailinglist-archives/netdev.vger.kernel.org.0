Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95854BC8C0
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 14:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbiBSNyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 08:54:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiBSNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 08:54:22 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6517E40A02
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:54:03 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so8345387wmb.0
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=bk0wfs5+dLSTg4JL+5IvQNW5I3Kfgya1ULcXP2moi14=;
        b=JclM+F6LscAPXIruC8QphG7Tsil3yombT10xPl9DXbXloGx9QDETgGB9B9YqaEvAIu
         U84frB3/WwoW0QG3saiKe3ahspTBZVIVhha6BJ5kzIuulHbtAABvy1JeaG6Zidwa2lrP
         NWV0od12ka57NXi6q6Nr8hAiQjfK7aLVaKe2fWlk+kzOy981rzK5Nf92FoHrpMkJ386Z
         ZhGgMHLbzcI7JS26HU6WLRSbXP5dxzF5yepDZ7XHTZMG0bhe3aDs22HfR5NLBt2HWNku
         bjCIrRGte/USQdhhpl8eWgbljdg8HuaL3aVqiM+TwlTb0Owpx58+mYolKonzTr3Le3nN
         WmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=bk0wfs5+dLSTg4JL+5IvQNW5I3Kfgya1ULcXP2moi14=;
        b=5YUDMdKbU3cBel96Nxgo92UvtmF/H2NWG5tkT6/hk19dlQMca2HQqjqje6tS9d6wu0
         6WfrIyRek011I1GASqPkCmuxhj1wKikboiHnATpuOhognDIYwBMvZ1+9gRgy7VBxWdQ3
         lgmm1gdDn4fJMAcR9/GNoIZhun7bQ5m+LELIgqAlP8u9cwqClOcAQSP3HyKXTEFk8r+V
         fedTIAtDfX50s6KZ0Iy0WNI13sL6fGBObxuMjfCdUqG3+R9PzHHrBZ09kmikblFqz5va
         BbpXRukO0mfcZngyRpPBD44gmZSpMTBlsFJo0/qb/uvccaxIDn6b8T7B48BpI7x24I2D
         fmtg==
X-Gm-Message-State: AOAM531elaqTr6ewT16leQTtqJVLeqSMMKb2pRcG0L0hW+lKaW9sKmrt
        uQtM+6/AF4j2hDBchhoyOeE=
X-Google-Smtp-Source: ABdhPJyJnhZ7q4J/EZT+0Llg5QhzUGbD5L4XPgiVdR+Hb5N6IMqc8Hf1AaXv5JjDu5bpqd+xhNooTw==
X-Received: by 2002:a7b:c201:0:b0:350:de40:c295 with SMTP id x1-20020a7bc201000000b00350de40c295mr14878712wmi.103.1645278842018;
        Sat, 19 Feb 2022 05:54:02 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id g22sm2377978wmh.12.2022.02.19.05.54.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Feb 2022 05:54:01 -0800 (PST)
Date:   Sat, 19 Feb 2022 13:53:59 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
Message-ID: <20220219135359.ljmfnjo7xqn2h6ze@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20220128151922.1016841-1-ihuguet@redhat.com>
 <20220128151922.1016841-2-ihuguet@redhat.com>
 <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
 <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com>
 <20220210082249.0e50668b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4ouepk83kxTGd6S3gVyFAjofofwQfxsmhe97vGP+twkoW1g@mail.gmail.com>
 <20220211110100.5580d1ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220211110100.5580d1ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 11:01:00AM -0800, Jakub Kicinski wrote:
> On Fri, 11 Feb 2022 12:05:19 +0100 Íñigo Huguet wrote:
> > Totally. My comment was intended to be more like a question to see why
> > we should or shouldn't consider NUMA nodes in
> > netif_get_num_default_rss_queues. But now I understand your point
> > better.
> > 
> > However, would it make sense something like this for
> > netif_get_num_default_rss_queues, or it would be a bit overkill?
> > if the system has more than one NUMA node, allocate one queue per
> > physical core in local NUMA node.
> > else, allocate physical cores / 2
> 
> I don't have a strong opinion on the NUMA question, to be honest.
> It gets complicated pretty quickly. If there is one NIC we may or 
> may not want to divide - for pure packet forwarding sure, best if
> its done on the node with the NIC, but that assumes the other node 
> is idle or doing something else? How does it not need networking?
> 
> If each node has a separate NIC we should definitely divide. But
> it's impossible to know the NIC count at the netdev level..
> 
> So my thinking was let's leave NUMA configurations to manual tuning.
> If we don't do anything special for NUMA it's less likely someone will
> tell us we did the wrong thing there :) But feel free to implement what
> you suggested above.
> 
> One thing I'm not sure of is if anyone uses the early AMD chiplet CPUs 
> in a NUMA-per-chiplet mode? IIRC they had a mode like that. And that'd
> potentially be problematic if we wanted to divide by number of nodes.
> Maybe not as much if just dividing by 2.

Since one week Xilinx is part of AMD. In time I'm sure we'll be able
to investigate AMD specifics.

Martin

> > Another thing: this patch series appears in patchwork with state
> > "Changes Requested", but no changes have been requested, actually. Can
> > the state be changed so it has more visibility to get reviews?
> 
> I think resend would be best.
