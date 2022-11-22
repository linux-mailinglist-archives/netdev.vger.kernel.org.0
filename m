Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED43B633335
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiKVCVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiKVCT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:19:57 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCFEE916A;
        Mon, 21 Nov 2022 18:16:48 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id j12so12278664plj.5;
        Mon, 21 Nov 2022 18:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAS10vxwv7eXxsatAar6JMchFKtCW7yFEYl7obtqE/Q=;
        b=PhHumDp24iZjIwP1SzSxcoJdLO73vynQdZuS7+Jlhgl+l3h8gEWKnBCKbtMGWHfTJE
         smXB1eZsOWKW5gb7aTsTbqz7Pg8Eo70FQtwCBfiNJbC1AFqGFiAu5+iHHoBcNN+v2XFI
         M2p5FC+Redqu5tMv81kxrClGtHdUPoD7ZvuuN96CVYcjL1sJ34rn3c5dBZlg9u1AquKj
         BWDe6oj3yPwZzeohQxz3k2wtCCm3X3RDh209a9CHa6VecL4+L1baHV7b9B4vyWKEYSxO
         vhWSQzdWidavys9Swg/JApk6V/rPGGuINg3gHRynK/sgSHV7dHm8FzWyOjmOEqnkmVPQ
         4MgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VAS10vxwv7eXxsatAar6JMchFKtCW7yFEYl7obtqE/Q=;
        b=CapX0W7+SkH0msxSmf8n6na6d4XGhHtyw8X3V5v73eGxpGfu5kjCoJVpM5r+hx3eTB
         hn3ELF08VdQjEvZL8bgig8AKWrb70uvAHuzo4SysWvBU1wZkUkixWvDwx4Pjd4INFZNu
         Od/tgFLsYoqL5ruqBYiyI2gLR0Jp9pkefIAMLA11qNDsS39ywqX7fg22ylqGYvO72jJR
         FPpUoCiZ9EKMjtAEgq/ueAfMPRpvqJrdNMmW9Nh388duGjLhS/IlirlmI7htzyVWs1bv
         G380v35TpapFZIaLrZzabgckPoHTGiydTfMbO8OCkU03CfD5IuNLUnzzpGCQAs5A3MuF
         PaWA==
X-Gm-Message-State: ANoB5pka3r3mkhWQnKgWzrhj6brZtvTeLyVKYOn74Ai5cOExSmLh1gcn
        oMaQ+dpttlsAJEMV4FmHEIs=
X-Google-Smtp-Source: AA0mqf70D6htIgCYzR7QYf6jyjB2/AEyH9Zz/qlL1Ju4zKoRwym9q9avRD/Z9HQyVc2sxwQtatqV8w==
X-Received: by 2002:a17:903:22d2:b0:17f:6758:6904 with SMTP id y18-20020a17090322d200b0017f67586904mr4969638plg.61.1669083407592;
        Mon, 21 Nov 2022 18:16:47 -0800 (PST)
Received: from localhost ([2605:59c8:6f:2810:f4d9:9612:b71b:8711])
        by smtp.gmail.com with ESMTPSA id g24-20020aa796b8000000b0056c814a501dsm9682477pfk.10.2022.11.21.18.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 18:16:46 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:16:45 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pengcheng Yang <yangpc@wangsu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Message-ID: <637c310d61447_18ed9208e5@john.notmuch>
In-Reply-To: <1668598161-15455-2-git-send-email-yangpc@wangsu.com>
References: <1668598161-15455-1-git-send-email-yangpc@wangsu.com>
 <1668598161-15455-2-git-send-email-yangpc@wangsu.com>
Subject: RE: [PATCH bpf 1/4] bpf, sockmap: Fix repeated calls to sock_put()
 when msg has more_data
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pengcheng Yang wrote:
> In tcp_bpf_send_verdict() redirection, the eval variable is assigned to
> __SK_REDIRECT after the apply_bytes data is sent, if msg has more_data,
> sock_put() will be called multiple times.
> We should reset the eval variable to __SK_NONE every time more_data
> starts.
> 
> This causes:
> 
> IPv4: Attempt to release TCP socket in state 1 00000000b4c925d7
> ------------[ cut here ]------------
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 5 PID: 4482 at lib/refcount.c:25 refcount_warn_saturate+0x7d/0x110
> Modules linked in:
> CPU: 5 PID: 4482 Comm: sockhash_bypass Kdump: loaded Not tainted 6.0.0 #1
> Hardware name: Red Hat KVM, BIOS 1.11.0-2.el7 04/01/2014
> Call Trace:
>  <TASK>
>  __tcp_transmit_skb+0xa1b/0xb90
>  ? __alloc_skb+0x8c/0x1a0
>  ? __kmalloc_node_track_caller+0x184/0x320
>  tcp_write_xmit+0x22a/0x1110
>  __tcp_push_pending_frames+0x32/0xf0
>  do_tcp_sendpages+0x62d/0x640
>  tcp_bpf_push+0xae/0x2c0
>  tcp_bpf_sendmsg_redir+0x260/0x410
>  ? preempt_count_add+0x70/0xa0
>  tcp_bpf_send_verdict+0x386/0x4b0
>  tcp_bpf_sendmsg+0x21b/0x3b0
>  sock_sendmsg+0x58/0x70
>  __sys_sendto+0xfa/0x170
>  ? xfd_validate_state+0x1d/0x80
>  ? switch_fpu_return+0x59/0xe0
>  __x64_sys_sendto+0x24/0x30
>  do_syscall_64+0x37/0x90
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: cd9733f5d75c ("tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>

I'll wait for the resend with all the patches but for this one.

Acked-by: John Fastabend <john.fastabend@gmail.com>
