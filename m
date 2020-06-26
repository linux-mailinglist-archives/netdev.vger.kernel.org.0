Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C47C20B03D
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgFZLLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgFZLLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:11:48 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FCBC08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:11:47 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 9so9888180ljc.8
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=fLyUyrnIraTTpfTBbRFScydYdf7yAcbWPMDOJapXD6U=;
        b=nvD+WbJ7WQ6b1NkW1bGU1bZkIG2ZBN2lsbGL7nzV9THvNmlvxxgQVMLVDz7UzJSuZs
         dZSndWr7PAzTeyRUyzwDXU49SyEQdL5fOyjtXXVdU770qB6N8aC0zpZpgImxIxm1kdOV
         0c63BZi2JMX+Sw1Tby6J1E00n5yrnNh0LJoyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=fLyUyrnIraTTpfTBbRFScydYdf7yAcbWPMDOJapXD6U=;
        b=XoqMLH6yFSvH0z0J+o6anuQKFrHHRQnBRJbuwWDKNhOTZ9ErItg/l3hiiHL7uwheGM
         Brq+GAhtiCKATij5NaFkEx9xVzTP7SA0+1NgnJB48hnp9lVRBLUxoZhWOD4IFn5Ut/5y
         AAQnGaEoWFd3KUablmWFcxE41usMqoviS4A/X1ivr+EoMyes/euAmkXfaBgHYXdwzEq6
         UiexVYL2o0COsAKgDWZCBcEtZ6BXhyT869R75R3b7+x2nD7RCQYAuIoUCSxEZyf+bLPD
         5svHPsH9+gm0ZSXWLVobNzqzwBkDpRn4U0Ul4Nl7koapjRpL24VI5v6i6E1mHhkwWqgM
         LMmQ==
X-Gm-Message-State: AOAM532+eq4kJA0Vx3Vt86+S/IsJjOexURL45fMGGl8S71YGgONtxHTT
        q8qXKQv4aS+dYUF1bco9xss55w==
X-Google-Smtp-Source: ABdhPJyY7grFB+FUHoAumppz78d55l3p8fs4cTmkW/pav2IKafYOmPI0jy6l8m6Kmh2sjhVORv+1iw==
X-Received: by 2002:a2e:6c17:: with SMTP id h23mr1241873ljc.48.1593169906097;
        Fri, 26 Jun 2020 04:11:46 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 15sm2212059ljj.104.2020.06.26.04.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 04:11:45 -0700 (PDT)
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370> <159312677907.18340.11064813152758406626.stgit@john-XPS-13-9370>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     kafai@fb.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 1/3] bpf, sockmap: RCU splat with redirect and strparser error or TLS
In-reply-to: <159312677907.18340.11064813152758406626.stgit@john-XPS-13-9370>
Date:   Fri, 26 Jun 2020 13:11:44 +0200
Message-ID: <87ftaim68f.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 01:12 AM CEST, John Fastabend wrote:
> There are two paths to generate the below RCU splat the first and
> most obvious is the result of the BPF verdict program issuing a
> redirect on a TLS socket (This is the splat shown below). Unlike
> the non-TLS case the caller of the *strp_read() hooks does not
> wrap the call in a rcu_read_lock/unlock. Then if the BPF program
> issues a redirect action we hit the RCU splat.
>
> However, in the non-TLS socket case the splat appears to be
> relatively rare, because the skmsg caller into the strp_data_ready()
> is wrapped in a rcu_read_lock/unlock. Shown here,
>
>  static void sk_psock_strp_data_ready(struct sock *sk)
>  {
> 	struct sk_psock *psock;
>
> 	rcu_read_lock();
> 	psock = sk_psock(sk);
> 	if (likely(psock)) {
> 		if (tls_sw_has_ctx_rx(sk)) {
> 			psock->parser.saved_data_ready(sk);
> 		} else {
> 			write_lock_bh(&sk->sk_callback_lock);
> 			strp_data_ready(&psock->parser.strp);
> 			write_unlock_bh(&sk->sk_callback_lock);
> 		}
> 	}
> 	rcu_read_unlock();
>  }
>
> If the above was the only way to run the verdict program we
> would be safe. But, there is a case where the strparser may throw an
> ENOMEM error while parsing the skb. This is a result of a failed
> skb_clone, or alloc_skb_for_msg while building a new merged skb when
> the msg length needed spans multiple skbs. This will in turn put the
> skb on the strp_wrk workqueue in the strparser code. The skb will
> later be dequeued and verdict programs run, but now from a
> different context without the rcu_read_lock()/unlock() critical
> section in sk_psock_strp_data_ready() shown above. In practice
> I have not seen this yet, because as far as I know most users of the
> verdict programs are also only working on single skbs. In this case no
> merge happens which could trigger the above ENOMEM errors. In addition
> the system would need to be under memory pressure. For example, we
> can't hit the above case in selftests because we missed having tests
> to merge skbs. (Added in later patch)
>
> To fix the below splat extend the rcu_read_lock/unnlock block to
> include the call to sk_psock_tls_verdict_apply(). This will fix both
> TLS redirect case and non-TLS redirect+error case. Also remove
> psock from the sk_psock_tls_verdict_apply() function signature its
> not used there.
>
> [ 1095.937597] WARNING: suspicious RCU usage
> [ 1095.940964] 5.7.0-rc7-02911-g463bac5f1ca79 #1 Tainted: G        W
> [ 1095.944363] -----------------------------
> [ 1095.947384] include/linux/skmsg.h:284 suspicious rcu_dereference_check() usage!
> [ 1095.950866]
> [ 1095.950866] other info that might help us debug this:
> [ 1095.950866]
> [ 1095.957146]
> [ 1095.957146] rcu_scheduler_active = 2, debug_locks = 1
> [ 1095.961482] 1 lock held by test_sockmap/15970:
> [ 1095.964501]  #0: ffff9ea6b25de660 (sk_lock-AF_INET){+.+.}-{0:0}, at: tls_sw_recvmsg+0x13a/0x840 [tls]
> [ 1095.968568]
> [ 1095.968568] stack backtrace:
> [ 1095.975001] CPU: 1 PID: 15970 Comm: test_sockmap Tainted: G        W         5.7.0-rc7-02911-g463bac5f1ca79 #1
> [ 1095.977883] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [ 1095.980519] Call Trace:
> [ 1095.982191]  dump_stack+0x8f/0xd0
> [ 1095.984040]  sk_psock_skb_redirect+0xa6/0xf0
> [ 1095.986073]  sk_psock_tls_strp_read+0x1d8/0x250
> [ 1095.988095]  tls_sw_recvmsg+0x714/0x840 [tls]
>
> v2: Improve commit message to identify non-TLS redirect plus error case
>     condition as well as more common TLS case. In the process I decided
>     doing the rcu_read_unlock followed by the lock/unlock inside branches
>     was unnecessarily complex. We can just extend the current rcu block
>     and get the same effeective without the shuffling and branching.
>     Thanks Martin!
>
> Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Thanks for the detailed explanation.

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
