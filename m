Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB1677503
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 06:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjAWFtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 00:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjAWFtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 00:49:31 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9367A1421D;
        Sun, 22 Jan 2023 21:49:28 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id r9so9450831oig.12;
        Sun, 22 Jan 2023 21:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xyJo8C/2H0gDpF4Y+52CY8J6fFUdtwXdZo9IpnszVOg=;
        b=cqPNfNPWPggJujEivra4tfr/ZQ/4CDx9rTbVPJjzi5BzFMc2Wrxe2vClEJesHxlkcl
         cQejl0JiOJ70XFBIdWjhZdGkYv1y7oeAESFMqJJ4eXfOZDOUYPJiTAEsWc5mGK2R7sbM
         BRzLPfxmzAAgZ9bXnPg1COBQdFAOjCUpmonXTnH4syHOMvI8Na1zrO14ctgviyW4OZUI
         vWAefpcRthtot7LWUnHElvyXXtGfRK7SzAtLplAcypGj5DBenv2D0e24pHPpjK1j8m+t
         wNcUv94BMQohWQpLk+zr6NNMUsO8IjKPsztCHzrOXJV/CPIaZXqVdItGjby1eiX/SNDb
         FcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyJo8C/2H0gDpF4Y+52CY8J6fFUdtwXdZo9IpnszVOg=;
        b=6+E0rOGC0p0z6XOrfLwAY90wFCG2ZMbJlChW6LLfNktUhMhJRBWS4fvWH+sGVoWc3J
         eJpE81diCCMuxPa8iVI237e62gqRkrs1FBmIbe42DfxUszhY7mhGvdl8UgHbNdxDuS1U
         0NdFERYj8b2LYpI7GhqqG2khg89RbZfns57/s5Rau8FosmErU4opSFKONcxcbF9lzw/D
         FYbKiYuRmEji4Z1HJIUNBDVY3ktl5yB4LaJROlRNBordKO7I6Z2Wuu3pEc2STXG3rLaT
         8Ylg4DMuhe9D7ngSZ1dnRhtbWo6y0wR84KslxoXfjwUAJD3r1EoHqGx1sPGLeCBpcELF
         b+fg==
X-Gm-Message-State: AFqh2kqiEL97bObzJvCK+Kfp8VAlnCs31mQKBVDFNGraJP5QUk2qXUCL
        b7Ghr4eoQ7xuEWaJnNSGLx4=
X-Google-Smtp-Source: AMrXdXuiWXYBYH920EFgsK0kjVtHpjlLtOe0O2Ntr/K3wFwYYMuueU6SjyG1flMlDHFvZQjHArI2hQ==
X-Received: by 2002:a05:6808:1b27:b0:36b:1834:4073 with SMTP id bx39-20020a0568081b2700b0036b18344073mr11085443oib.29.1674452967859;
        Sun, 22 Jan 2023 21:49:27 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:2b7f:8e37:c086:d585])
        by smtp.gmail.com with ESMTPSA id k10-20020a9d198a000000b006864b5f4650sm9416657otk.46.2023.01.22.21.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 21:49:26 -0800 (PST)
Date:   Sun, 22 Jan 2023 21:49:25 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7] net/sock: Introduce trace_sk_data_ready()
Message-ID: <Y84f5U2iz0M9J3w8@pop-os.localdomain>
References: <20221110023458.2726-1-yepeilin.cs@gmail.com>
 <20230120004516.3944-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120004516.3944-1-yepeilin.cs@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 04:45:16PM -0800, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> callback implementations.  For example:
> 
> <...>
>   iperf-609  [002] .....  70.660425: sk_data_ready: family=2 protocol=6 func=sock_def_readable
>   iperf-609  [002] .....  70.660436: sk_data_ready: family=2 protocol=6 func=sock_def_readable
> <...>
> 
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Looks good to me.

Thanks!
