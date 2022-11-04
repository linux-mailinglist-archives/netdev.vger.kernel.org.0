Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205996195A5
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiKDLun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiKDLul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:50:41 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672A22B614
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:50:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id k15so4320549pfg.2
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 04:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IpAV0jgwzifRjfxi0SXZaDTTOLxR0GMOqvsd9VIFL3Y=;
        b=krtC89DiazJslLPy8tfHxOiOfFjhl3Sn0mULhM5T86kQGpN+anQrt8Ug7peIZqis1z
         BDETHTw/YsvVclsFC9tD20G32gFPqOF7N+IORynZTh8tjaTX6f/PGPsx1zByFebe7gs3
         EOddczOgCnRH/WfrteyHaRpl1OkbvjzRcw9gw5q7le6fZJ5dKiD/yI+F0oeYTQPA7UIb
         K2AZlfWl1GEUAtQ+I/PZoPlI8eo8Uvfxeo9qgEaTRIy//3wMsv3OakoZ1/vCLOiMuU7C
         53p4TDDqV+IOye/czj5qYKr6PRafrRet97xFni3myO4epMpbwUIbLLxVxjapZhZ5IGEi
         2fQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IpAV0jgwzifRjfxi0SXZaDTTOLxR0GMOqvsd9VIFL3Y=;
        b=6Mho/ietN5XBwuHMTWrPO7nr0lCqQi4MyERIie7MNQyxCOqTvzvK3ErPxd/k9jQ2fR
         bp0tr3QIJPp1vTPK6pj/u34TmlsJMOek1Yj4RhXwM43UYbCgtDmEaBjvRXIyp0BvGOuA
         aZxHUMTLHffu4zLGJl3x0f2G2srzfSl2B+ozOUdhsWdROTZg5hMjqyGVZlpzlCjgksFg
         AZOgx4uBlPLA+HzOlLuJMwHu8Je3VmzG+y2tmQwAlY9Y3GTT5phh3zIGkVVA1GjEuieh
         mbDpvPndq/7amYDopqaS/OWcLBRHd2dSFiroaR78xCbL2m77zXgt73yC2YjEqKIt+3v5
         CF8g==
X-Gm-Message-State: ACrzQf3rCu4I1E5uWSbAiEaE2FolXhSblhYsz8vZxEBgVX//Z0tFFcI/
        S6TiSlnGiRcIPx0trd0evIo=
X-Google-Smtp-Source: AMsMyM4rj4fRIAisygYoZmj5aE3YhIHdzz2tD4x9ptYInKrUVg+3M4Cz+aBjs4pAHfpvMmp+tB2bmg==
X-Received: by 2002:a65:5583:0:b0:461:25fe:e982 with SMTP id j3-20020a655583000000b0046125fee982mr30327471pgs.4.1667562640856;
        Fri, 04 Nov 2022 04:50:40 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t23-20020a634457000000b0043b565cb57csm1755315pgk.73.2022.11.04.04.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:50:40 -0700 (PDT)
Date:   Fri, 4 Nov 2022 19:50:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y2T8isE8Y4jNT6Bh@Laptop-X1>
References: <20221101091356.531160-1-liuhangbin@gmail.com>
 <72467.1667297563@vermin>
 <Y2Ehg4AGAwaDRSy1@Laptop-X1>
 <Y2EqgyAChS1/6VqP@Laptop-X1>
 <171898.1667491439@vermin>
 <Y2TIeiI1s+hdBPlL@Laptop-X1>
 <182265.1667549932@vermin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <182265.1667549932@vermin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 09:18:52AM +0100, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >On Thu, Nov 03, 2022 at 05:03:59PM +0100, Jay Vosburgh wrote:
> >> 	Briefly looking at the patch, the commit message needs updating,
> >> and I'm curious to know why pskb_may_pull can't be used.
> >
> >Oh, forgot to reply this. pskb_may_pull() need "struct sk_buff *skb" but we
> >defined "const struct sk_buff *skb" in bond_na_rcv().
> 
> 	Perhaps you could use skb_header_pointer(), similarly to what is
> done in bond_3ad_lacpdu_recv() or rlb_arp_recv()?

Cool, Thanks Jay. This saves my lumbering checking.

Cheers
Hangbin
