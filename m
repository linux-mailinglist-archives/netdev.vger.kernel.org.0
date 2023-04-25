Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4749B6EDAD7
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 05:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjDYD61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 23:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjDYD6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 23:58:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA537B467
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 20:58:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a677dffb37so45314875ad.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 20:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682395100; x=1684987100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aj/TYDUJRlrqPOA0+J0bQEIspJpBt9nW1sYPtelJAvQ=;
        b=Th15uvckqAatnYxVOPiD4IGUahLD40jdeFM9kN0v99oMmRdan/fLbY+gJ5Ou4v0yrS
         11irrM2uiCBdXKvAPDZllZNBGk82tmVLuFPQLN8+GXJSUUPARshgTemtOtdsIvLDwA95
         JF2bUzC3y9Epvg2auNz06xI0NPW2qxALOcw7O1tDKnj0QEojJXVi4vxXbfWBdkFTncLJ
         JoHZbzn4pj5dvDePjhmvPrpke+asK9YpBMfw/8OJ8cKP+iZ1V+U66Tjs7FNuB4lOHvfK
         Y6f1MBGXy4iDZhFKm7RZhrEhCuLv4YcLVHnwjKdZzo67nwVhDKlYJtB1ridyJBBr0XVQ
         kT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682395100; x=1684987100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aj/TYDUJRlrqPOA0+J0bQEIspJpBt9nW1sYPtelJAvQ=;
        b=YytfgbwBYPXJlRXq53Wz2RLXdhXANurNEJk7eICO4Xm9GwzMZzCMArEwEBetZFqDXS
         VRjWDoxg+fiyHdJoWsD2C/QZVVNod43XykMQuFC2+vfY2GXb32O7mRt/TEWRrjnXUVyS
         y16l7uGoCeK4bYRyqc33SaGgzjrH4rCUlBe85uiN4txL1b58o8um+x7XkgrLgz0qIvnB
         hzFILMIAZ/Wf3qB3MHzoU4Y8CqIh6MfZj4vgdvMHkC7M6tfkKucb0eDT5nW/614gGEVo
         oNdT2sgoinDCgYgS6cyA8oepWDdstRuTiCnrNpk5jaH/ExrWKzKErzIfgZhI/ydiDfTv
         vdlw==
X-Gm-Message-State: AAQBX9cPYUUh9biTkA18LlvGOPCuaijhzwpuSiL/M8qFr1dXY0qP23Wk
        3Exfl73hLfk947eSKGUsS8A=
X-Google-Smtp-Source: AKy350YhFWX49xGgHympgSN5FC3OvZcgqJzdJ4iqYJstPY+pulmpaxMVMlPNTcziLIxkhnYhfvvMIA==
X-Received: by 2002:a17:902:ce84:b0:1a8:11d3:6b93 with SMTP id f4-20020a170902ce8400b001a811d36b93mr20351456plg.66.1682395100282;
        Mon, 24 Apr 2023 20:58:20 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id az11-20020a170902a58b00b001a1ed2fce9asm5746596plb.235.2023.04.24.20.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 20:58:19 -0700 (PDT)
Date:   Tue, 25 Apr 2023 11:58:14 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [Question] Any plan to write/update the bridge doc?
Message-ID: <ZEdP1tSiGAgvy7s8@Laptop-X1>
References: <ZEZK9AkChoOF3Lys@Laptop-X1>
 <20230424142800.3d519650@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424142800.3d519650@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 02:28:00PM -0700, Jakub Kicinski wrote:
> On Mon, 24 Apr 2023 17:25:08 +0800 Hangbin Liu wrote:
> > Maybe someone already has asked. The only official Linux bridge document I
> > got is a very ancient wiki page[1] or the ip link man page[2][3]. As there are
> > many bridge stp/vlan/multicast paramegers. Should we add a detailed kernel
> > document about each parameter? The parameter showed in ip link page seems
> > a little brief.
> > 
> > I'd like to help do this work. But apparently neither my English nor my
> > understanding of the code is good enough. Anyway, if you want, I can help
> > write a draft version first and you (bridge maintainers) keep working on this.
> > 
> > [1] https://wiki.linuxfoundation.org/networking/bridge
> > [2] https://man7.org/linux/man-pages/man8/bridge.8.html
> > [3] https://man7.org/linux/man-pages/man8/ip-link.8.html
> 
> Sounds like we have 2 votes for the CLI man pages but I'd like to
> register a vote for in-kernel documentation.
> 
> I work at a large company so my perspective may differ but from what 
> I see:
> 
>  - users who want to call the kernel API should not have to look at 
>    the CLI's man
>  - man pages use archaic and arcane markup, I'd like to know how many
>    people actually know how it works and how many copy / paste / look;
>    ReST is prevalent, simple and commonly understood

+1 for the obscure man page syntax. I can only do copy/paste when update it..

>  - in-kernel docs are rendered on the web as soon as they hit linux-next
>  - we can make sure documentation is provided with the kernel changes,
>    in an ideal world it doesn't matter but in practice the CLI support
>    may never happen (no to mention that iproute does not hold all CLI)

Yes. I saw bpf code add the doc in the header file (include/uapi/linux/bpf.h)
and generate to syscall page[1] or man page[2] directly. Another example is the
statistics.rst document, which takes *struct rtnl_link_stats64* description
drectly from the if_link.h. This should save a lot works to maintain another
file in Documentation. Maybe we can strive in this direction?

For example, we can just add descriptions for the enum in if_bridge.h and
if_link.h when add new features.
> 
> Obviously if Stephen and Ido prefer to document the bridge CLI that's
> perfectly fine, it's their call :) For new sections of uAPI, however,
> I personally find in-kernel docs superior.

I understand the hard work to maintain docs in 3 different places with
different syntax (ip-link, bridge, in-kernel). Since we will sync the uapi
headers from kernel to iproute2. Can we use the similar way like kernel does
in iproute2. i.e. Link the header file's description in a document and
convert it to man page via rst2man? With this way we only need to maintain
the doc in 1 place, the kernel uapi headers.

NOTE: there may still need some adjustment in the iproute2 man page when add
new arguments.

[1] https://docs.kernel.org/userspace-api/ebpf/syscall.html
[2] https://man7.org/linux/man-pages/man7/bpf-helpers.7.html
[3] https://docs.kernel.org/networking/statistics.html

Thanks
Hangbin
