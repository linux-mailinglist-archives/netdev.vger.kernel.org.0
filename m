Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DBC536896
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354783AbiE0Vhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 17:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239691AbiE0Vhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 17:37:32 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B791D31D;
        Fri, 27 May 2022 14:37:31 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id b200so6299761qkc.7;
        Fri, 27 May 2022 14:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yv1zNLR8PeZtnM4mVUSdmqV0yp76B0CpgvPT4SsUTvc=;
        b=DP5S5ubV7ufPZ2oXCQcY4WksErBRKnh/hqqrsm/fqf+iUiLThqeI1VtcXWrdGSPYKX
         4M6kk5efOQgSfdfkZXk9scpiUnUP2XIfAeNwYBGeKq9qK23jKL/Lqzx6Mb5umfW7rNQo
         LGwe1RPok11NPQecMK5YrQ/itX45eCHZRA9TbKQi37MyN5EmBsCRn36KnqXNeyeJuspH
         4COGA8zhRg49OXDJDZYEtuXqFGMB2H25O1Qwk9Gba1TAAgvdlQikqMrsqUkPNVYSToDc
         Hlp2r6mPpvBRsjiw+7VcyGelyytyemkjub/nynWtkKrL7XIiuiemYxIZBvBZvN9qaB4q
         msbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yv1zNLR8PeZtnM4mVUSdmqV0yp76B0CpgvPT4SsUTvc=;
        b=p3q2rou+dHMdv+iteimdf4ecf/KCWmmXre87eby7daPlSnsauHVsPXsvJ5jgy2m0Xh
         +r7p6xlHzV2jyOiDxxL/LHLGz88OXAyVc8lzZ4ayb0c2OiY1AoOsia1FaNmGT7VTgHTu
         jp22Md4iodxTRuumf+dl43BNj9XF88e10OFd2KQL8ikmpwhIjI9sgjMHflpVa2UVhn9b
         s6knNnTYqppjtWMObcuuqQWXIt61BmWCiofIbeXBv1wNwrMXSFAYqtTGZIOn+5v7tmm6
         oTyvpSrwPWNs9JFlYyBTk01NRb1WO5mCC7oEhQ26MKAQwRGYtMJF6uaPfFq1tVRft6L5
         1wUA==
X-Gm-Message-State: AOAM532I3HodWrCd+6Bl0HaCu8EkQWe9tpjd6ONjmOGURNgJKfIRwNdC
        ziAMUXHDBlwx60FIhk+fCO8=
X-Google-Smtp-Source: ABdhPJwxg0cK8yX3vs90xVuXcuzmxpkLLedv3v14vo1trKDrxCDKAEcdBi2ZEFJW846FslkOvj29+Q==
X-Received: by 2002:a05:620a:bc6:b0:67d:1870:8b35 with SMTP id s6-20020a05620a0bc600b0067d18708b35mr29763959qki.85.1653687450543;
        Fri, 27 May 2022 14:37:30 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:22b3:9ef2:6e70:6f4d])
        by smtp.gmail.com with ESMTPSA id cp8-20020a05622a420800b002f39b99f6a4sm3042982qtb.62.2022.05.27.14.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 14:37:30 -0700 (PDT)
Date:   Fri, 27 May 2022 14:37:28 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kafai@fb.com, dsahern@kernel.org,
        kuba@kernel.org, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on
 in sk_stream_kill_queues
Message-ID: <YpFEmCp+fm1nC23U@pop-os.localdomain>
References: <20220524075311.649153-1-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524075311.649153-1-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 03:53:11PM +0800, Wang Yufen wrote:
> During TCP sockmap redirect pressure test, the following warning is triggered:
> WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queues+0xbc/0xd0
> CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         5.10.0+ #9
> Call Trace:
>  inet_csk_destroy_sock+0x55/0x110
>  inet_csk_listen_stop+0xbb/0x380
>  tcp_close+0x41b/0x480
>  inet_release+0x42/0x80
>  __sock_release+0x3d/0xa0
>  sock_close+0x11/0x20
>  __fput+0x9d/0x240
>  task_work_run+0x62/0x90
>  exit_to_user_mode_prepare+0x110/0x120
>  syscall_exit_to_user_mode+0x27/0x190
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The reason we observed is that:
> When the listener is closing, a connection may have completed the three-way
> handshake but not accepted, and the client has sent some packets. The child
> sks in accept queue release by inet_child_forget()->inet_csk_destroy_sock(),
> but psocks of child sks have not released.
> 

Hm, in this scenario, how does the child socket end up in the sockmap?
Clearly user-space does not have a chance to get an fd yet.

And, how does your patch work? Since the child sock does not even inheirt
the sock proto after clone (see the comments above tcp_bpf_clone()) at
all?

Thanks.
