Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0BD634E06
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 03:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiKWCuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 21:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiKWCux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 21:50:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A539E14CF;
        Tue, 22 Nov 2022 18:50:53 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q1so15632430pgl.11;
        Tue, 22 Nov 2022 18:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHGF/ykk51i2UlVpNk6Rt9E+TZjhn2CSrjWeKRLbxTs=;
        b=otvEt7OoBr6hVMSsMEeT21QXZbqOt2vimzHQ+GUZKwj1zENtAP6wr4E+nAcjoUJe7C
         bVrnj9io+nkVu8sGvELWeWypZneD3odlhfvvbQB7WOH+dpLt1FD329q7Mz2sEChBCPgw
         +CeYTZBMxtiw9UwHn6RmlBddn3jh5nNCzT4VKhfCIjsqeMOXAJbCHns2rKPr82PlIDwW
         L/57XNCPlv+eBM7W4VWKfVReQ2v74+Q95RLnrEsFhpd/1IV5IGvNtVTz1KIi+umhHQxa
         DN8rWrykEkVqCbpJAf5CcrCg9e1kH+8R7Cdw+aIB22b/j9uI+KshjqxjoCCUOmjIRpry
         NvQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zHGF/ykk51i2UlVpNk6Rt9E+TZjhn2CSrjWeKRLbxTs=;
        b=S9uceG3AewYM79psObbvnGEAYxyqZx/fhislt8vzabmEbAqSgVz6Lk60Zw5we2c4rA
         CRDcK2bGsbRh9lTU63Bl64i4zB0yD8mhhqg4ojA1v8TsjM5u18o/gbrKxP6VJ+ZV7AB1
         BVeDa7Of7n/Alh+qv7a/aqIR2atKDTv6BTefFhR1oQruN2ZvgQ0/ERP70/YX4cYCp0QG
         LDDIVrKtAvxN8h7DaXpE8Q1248bL5E+/+XqG/++4WU8Ytyij1opUBtY5UK8MiEtNBa2L
         qD0+DeAFNjS+SRzMjKoH7eatedQ4HYQoEzpvcnDoZaJl4zaNl+qzvSLAAOHpTQm8fBR+
         DMhA==
X-Gm-Message-State: ANoB5pn/i2VqrL+wUu9+qvrZ17wkyMPA4AWl5SdAbbLYUr+LsQH3wCqH
        9twt9TdI0Cv3H9hpXTFJv+Y1BXdDxqM=
X-Google-Smtp-Source: AA0mqf41CEu3K3rrHloihmxdHrqTjBvxC6FzkQxbM5RkFc38xviBzREsGEHtwk0TXEg0MyzI+mRSrA==
X-Received: by 2002:a62:4e96:0:b0:56d:a89d:fb9b with SMTP id c144-20020a624e96000000b0056da89dfb9bmr7981991pfb.24.1669171852434;
        Tue, 22 Nov 2022 18:50:52 -0800 (PST)
Received: from localhost ([129.95.226.125])
        by smtp.gmail.com with ESMTPSA id i1-20020a632201000000b00477a442d450sm1693257pgi.16.2022.11.22.18.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 18:50:51 -0800 (PST)
Date:   Tue, 22 Nov 2022 18:50:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pengcheng Yang <yangpc@wangsu.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Message-ID: <637d8a89335ec_2b649208ca@john.notmuch>
In-Reply-To: <1669082309-2546-2-git-send-email-yangpc@wangsu.com>
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com>
 <1669082309-2546-2-git-send-email-yangpc@wangsu.com>
Subject: RE: [PATCH RESEND bpf 1/4] bpf, sockmap: Fix repeated calls to
 sock_put() when msg has more_data
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

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
