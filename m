Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739FD614C6B
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiKAORp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiKAORo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:17:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E4F11A32
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 07:17:44 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k7so3963589pll.6
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 07:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8o9kaW9QkfJ+1FdVdGc/KGQjzmnncW6FxL7tb7ZbCTk=;
        b=RjPIo9PFk/y1QZSIbg7+UIstrcrbrfIT9s2dAq20PKe5XpeZz4EaAN/9urDZjJWUAc
         pdL4KmY2+K51/37Y8q7uoXEi/caN8TB426lJzeGxBU1bamJuZ/BMAmGo9SeCtT9l7H5q
         oU+qqJd2J3rCkC7n6wI0tWJOV+sdwXPqIvRfO+73OtMVsFYCeSGGF8GaPR0k1NaRdmBd
         o6r5XdfORe78no8xnChBGBCwD86KSu9+GUen3tRAoL+BFWefp02xxF+cbwqFqzPcdomo
         0nntYTjKfzkPspsCg2bFHXm3qbpEoS5PwPgfdCiDVX6sMKj+N1Qeoj5AJ9dWQxFOr69w
         VXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8o9kaW9QkfJ+1FdVdGc/KGQjzmnncW6FxL7tb7ZbCTk=;
        b=ArieD48kg1cH46BfWywDKHQCWx0+UjbymaYxtpRgYo0M56n0CaP3FCrSqBU5rRjeSx
         K0/XODsm91nqs6VCEPeYTOO1JuGVAiDCiZpVd0V8c5ViLW95tvstnuptdYypSL3Ojk0+
         FU2YHrCSCN7u9D7yVotKfYDBuymVMgB2P/1d6jZIy9pj99bwZlAP1zyd0Cye2iP7Vg33
         Ul/K2Fhl+dxTwPiebW99SUfg2Z8SRyRYK12hDZdBLoizdlIWszt3J3NRSgv5wpZpQwqR
         yRkvGSu/lx9ObvF3sVxwDNKP4ziZ0qdiCX3l3a2Sx4hkGS8miZjp7BwS95YiND9fxcNi
         28VQ==
X-Gm-Message-State: ACrzQf2dPwRt4I39anqLtfMQn3bZNhH8EAaaaquUkU5g0ynKz3ob1LdF
        54LR9xhKQ2oRK7YiJRgA0jBrOS1x7gksbQ==
X-Google-Smtp-Source: AMsMyM58U4n/itYAGCcyEOog415PGnp/IxFV6qMeiQPl2fj4tZ8aCWfc7xdoLoxF4k8+XtKcxs7agg==
X-Received: by 2002:a17:903:120d:b0:179:d027:66f0 with SMTP id l13-20020a170903120d00b00179d02766f0mr19736279plh.61.1667312263738;
        Tue, 01 Nov 2022 07:17:43 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a10-20020a17090a688a00b00212d9a06edcsm6052343pjd.42.2022.11.01.07.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 07:17:43 -0700 (PDT)
Date:   Tue, 1 Nov 2022 22:17:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y2EqgyAChS1/6VqP@Laptop-X1>
References: <20221101091356.531160-1-liuhangbin@gmail.com>
 <72467.1667297563@vermin>
 <Y2Ehg4AGAwaDRSy1@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2Ehg4AGAwaDRSy1@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:39:22PM +0800, Hangbin Liu wrote:
> > 	I don't understand this explanation, as ipv6_gro_receive() isn't
> > called directly by the device drivers, but from within the GRO
> > processing, e.g., by dev_gro_receive().
> > 
> > 	Could you explain how the call paths actually differ?  
> 
> Er..Yes, it's a little weird.
> 
> I checked if the transport header is set before  __netif_receive_skb_core().
> The bnx2x driver set it while be2net does not. So the transport header is reset
> in __netif_receive_skb_core() with be2net.
> 
> I also found ipv6_gro_receive() is called before bond_handle_frame() when
> receive NA message. Not sure which path it go through. I'm not very familiar
> with driver part. But I can do more investigating.

With dump_stack(), it shows bnx2x do calls ipv6_gro_receive().
PS: I only dump the stack when receive NA.

[   65.537605]  dump_stack_lvl+0x34/0x48
[   65.541695]  ipv6_gro_receive.cold+0x1b/0x3d
[   65.546453]  dev_gro_receive+0x16c/0x380
[   65.550831]  napi_gro_receive+0x64/0x210
[   65.555206]  bnx2x_rx_int+0x44c/0x820 [bnx2x]
[   65.560100]  bnx2x_poll+0xe5/0x1d0 [bnx2x]
[   65.564687]  __napi_poll+0x2c/0x160
[   65.568579]  net_rx_action+0x296/0x350

Thanks
Hangbin
