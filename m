Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0003614BE3
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 14:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiKANjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 09:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiKANjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 09:39:22 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BE85598
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 06:39:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b29so13448389pfp.13
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 06:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IgfK+afh3rWWhupfKFQN3ji3l6rgqyTDFB+Q+sF49JI=;
        b=eMQBWWwlYwLlo0TJ77fuaiuj0xxBaKZSd87kWPtGLFhUoqXgmZD+fY3LjofH0OYSnF
         nbXIRWMQXL0gmRMrVjJkLM0loVchrpHIPy9z9HVU0C0t6JxvVC2DM26YQihL1srmA6J+
         /v9y9NNqHWEmVdv0rqFGZWdVNDFvLPP7meSMhpZAhF+fzoDt4zdyr9DR9KcHexnvx2jX
         aHKP05VknbjLBLGvLwbEdJwyQxOJn9ySJ2DNOVbIvtD1QgMDo4oVWo7JKmyf226tGcTt
         3BPZrQ5Lm9wuGBp/X0E9ecsZm2OOoZYgX+TSzvjgIAynmmgHEH9X9DDKUHbPlVnHRD54
         X2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgfK+afh3rWWhupfKFQN3ji3l6rgqyTDFB+Q+sF49JI=;
        b=pFLZVbPzY4RliRXlMINzDoLn+Wtt99mtZ6ejx77cKRLcVklJqRoLup3rZO1tuxfBAj
         nF6Stxxf6I7+TzfgFE3xcCvyR9G7O0mtKEejFxMmCLqCLEbUDvb8lXCdaYsmvQdGiZR6
         WlpQq/T327zjrVIc7cNYqhQ0TYvNJKegX+Pzzqkwam5Uc9ZOeFLThjmxs8lTX+wZUufm
         HvHAI7ce3ShGKFiZp31/OazlgkVHwXaRD+ocWIKcSbZfOT4Zw+e1MnB6xosh53NZx7cR
         86jpCs60q+WXhpS0tSOWr24Us7XQ0EFgzqPHQu7uHQUNnmNvYOQqXHKMMgRSb9sY4tEZ
         7ZCw==
X-Gm-Message-State: ACrzQf2M/a4CqsgYy+4J63NaF2Jb4cYxsRAwPscpFnducRnoF1rhQR9F
        VP1BQPH+NcvrrtFcCqshxbs=
X-Google-Smtp-Source: AMsMyM5+ZSJU2uJwf3NSQNqj6vM2HvrqyoPTkkkzZv87Hx10UXI8bBOFlu29iqzlg8+9Wl1PXj0e1w==
X-Received: by 2002:a63:38e:0:b0:46f:f400:d1fd with SMTP id 136-20020a63038e000000b0046ff400d1fdmr1989606pgd.153.1667309961864;
        Tue, 01 Nov 2022 06:39:21 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h28-20020aa79f5c000000b0056c058ab000sm6530198pfr.155.2022.11.01.06.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 06:39:21 -0700 (PDT)
Date:   Tue, 1 Nov 2022 21:39:15 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y2Ehg4AGAwaDRSy1@Laptop-X1>
References: <20221101091356.531160-1-liuhangbin@gmail.com>
 <72467.1667297563@vermin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72467.1667297563@vermin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 11:12:43AM +0100, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >Some drivers, like bnx2x, will call ipv6_gro_receive() and set skb
> >IPv6 transport header before bond_handle_frame(). But some other drivers,
> >like be2net, will not call ipv6_gro_receive() and skb transport header
> >is not set properly. Thus we can't use icmp6_hdr(skb) to get the icmp6
> >header directly when dealing with IPv6 messages.
> 
> 	I don't understand this explanation, as ipv6_gro_receive() isn't
> called directly by the device drivers, but from within the GRO
> processing, e.g., by dev_gro_receive().
> 
> 	Could you explain how the call paths actually differ?  

Er..Yes, it's a little weird.

I checked if the transport header is set before  __netif_receive_skb_core().
The bnx2x driver set it while be2net does not. So the transport header is reset
in __netif_receive_skb_core() with be2net.

I also found ipv6_gro_receive() is called before bond_handle_frame() when
receive NA message. Not sure which path it go through. I'm not very familiar
with driver part. But I can do more investigating.

Thanks
Hangbin
