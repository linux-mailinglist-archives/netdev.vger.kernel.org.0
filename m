Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF27C137A80
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgAKASO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:18:14 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37626 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgAKASO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:18:14 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so1911027pfn.4;
        Fri, 10 Jan 2020 16:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8efEnNmzA1N34DiX1i5g0/D4PtX+ChPTrW8NgfMJMxk=;
        b=fJP3/JBUbABlyAOJK24rhtqFWmXQ91yDB8VXbmxaMbktMlEPOiYrapML+maSezo2DE
         +7aIFjXTCOIOl/9kPfordh+F9PzA9pPxM5W3TH//ZDSuolba9ep9kJX8RvQNbh1q0skd
         kCtliNk37SIgTb2nF3zzvjQ33v4DDn4w44+8mFSTrDMXwDGT5x8Napbg3+5J4ys++4Mu
         G73LVSgQZaf3p9CaJYhKtpbN27lZE1gQX+Yqk5oGZOEsJ5qfXk4xFbbHD5jlNMj+MdVF
         SIvlVji+UnZOAwYq6ZNgQ6lwVCaboweazmKo2OK1VTAFqiKNXIfTv1GhRHFcdGSbDa+n
         1hLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8efEnNmzA1N34DiX1i5g0/D4PtX+ChPTrW8NgfMJMxk=;
        b=NN3jQGr7fvKfQExkOvTiS6IQJBTchpPWgfcl7mAVn9wij7hMw44osbO5O/kVmiWtUU
         8sKrk5yN/byaB+W4tW0iPD+Jxaa5tlP/2YQ//oSWOd5M0iIq5Sq1/IayR7eQN1K/DmfW
         JINzzDQ2PUtDtz2Ti9SNvCUoI1Y/qPHWalOtDFY87WpRePnbW7JP+9GS3B1ShiZSd4mZ
         AH5qITATHa3ZWLv5hK06RzNmorvhfM8+CKM0haPboNRB1vjrQl8XTkxT+BCug1Q+P2Hl
         jNShqR3BCU9pJSwCgEavurEKtCH6dIEoEu8XAteWgi8ouUAcecBRXZTt/Vf1VL0e9h87
         p0Sw==
X-Gm-Message-State: APjAAAXIDQFzErPr6Vc340v5kkzdBa1Xk7ntrxqVe1WUOPK6nI0e1OTC
        KsApKGta21rk1UxpGf+VU7U=
X-Google-Smtp-Source: APXvYqzUuCGHem5pHYNs3sl6igcsdAwmZdUH1CblsLJEt+ANiyEVDkKucNwa5IwsVayUgGk7Bkh2Dg==
X-Received: by 2002:a63:26c4:: with SMTP id m187mr7696609pgm.410.1578701893290;
        Fri, 10 Jan 2020 16:18:13 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:ba5e])
        by smtp.gmail.com with ESMTPSA id y62sm4692965pfg.45.2020.01.10.16.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jan 2020 16:18:12 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:18:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 00/11] Extend SOCKMAP to store listening
 sockets
Message-ID: <20200111001809.uznbax2rr6peexkl@ast-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:50:16AM +0100, Jakub Sitnicki wrote:
> With the realization that properly cloning listening sockets that have
> psock state/callbacks is tricky, comes the second version of patches.
> 
> The spirit of the patch set stays the same - make SOCKMAP a generic
> collection for listening and established sockets. This would let us use the
> SOCKMAP with reuseport today, and in the future hopefully with BPF programs
> that run at socket lookup time [0]. For a bit more context, please see v1
> cover letter [1].
> 
> The biggest change that happened since v1 is how we deal with clearing
> psock state in a copy of parent socket when cloning it (patches 3 & 4).
> 
> As much as I did not want to touch icsk/tcp clone path, it seems
> unavoidable. The changes were kept down to a minimum, with attention to not
> break existing users. That said, a review from the TCP maintainer would be
> invaluable (patches 3 & 4).
> 
> Patches 1 & 2 will conflict with recently posted "Fixes for sockmap/tls
> from more complex BPF progs" series [0]. I'll adapt or split them out this
> series once sockmap/tls fixes from John land in bpf-next branch.
> 
> Some food for thought - is mixing listening and established sockets in the
> same BPF map a good idea? I don't know but I couldn't find a good reason to
> restrict the user.
> 
> Considering how much the code evolved, I didn't carry over Acks from v1.
> 
> Thanks,
> jkbs
> 
> [0] https://lore.kernel.org/bpf/157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2/T/#t
> [1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
> 
> v1 -> v2:
> 
> - af_ops->syn_recv_sock callback is no longer overridden and burdened with
>   restoring sk_prot and clearing sk_user_data in the child socket. As child
>   socket is already hashed when syn_recv_sock returns, it is too late to
>   put it in the right state. Instead patches 3 & 4 restore sk_prot and
>   clear sk_user_data before we hash the child socket. (Pointed out by
>   Martin Lau)
> 
> - Annotate shared access to sk->sk_prot with READ_ONCE/WRITE_ONCE macros as
>   we write to it from sk_msg while socket might be getting cloned on
>   another CPU. (Suggested by John Fastabend)
> 
> - Convert tests for SOCKMAP holding listening sockets to return-on-error
>   style, and hook them up to test_progs. Also use BPF skeleton for setup.
>   Add new tests to cover the race scenario discovered during v1 review.

lgtm
Martin, John, please review.
