Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577421825D5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgCKX1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:27:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32989 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731392AbgCKX1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 19:27:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id m5so2053012pgg.0;
        Wed, 11 Mar 2020 16:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5R3NN9uod3puJ0jWV50H8GmRPXUpheE41lirnX7p648=;
        b=pUb+BoV8jLVjeU16S4PEOg3tBCYrl5lqKfkvCxyc+ZfjKZgAaINNZ8KJ/1oTikFe8s
         mPDwEAOF5NDA0lxRp36m7kCFnwbrHMHhiYJxbiwcJ5Qljsv/chgvvzxjYblRFDayLY3s
         0RRjmrXiN+op5rNo9h1txoctx3RBu1uVQM3899eVOktFKtV+MZx4WEVNkCj8TNFZasE+
         oO7Uya6N8CwDWFMJaL9PzIkXIrQa+9nceOo2fRZ8IrJOdnKvZUtxb/2h8gEW2ynMfFew
         LdP3kLU3b2xGOILVhG0SzNi4c+/3oBFEp+ovA7zCLYW23q22bP2UgA3HI+tb3g2Gv/Lg
         Eh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5R3NN9uod3puJ0jWV50H8GmRPXUpheE41lirnX7p648=;
        b=k06GApmRV5i0kT8YZSSESuezdXZwFRvOW3Xlf7wjghVpfGJqMFgBZhikbR0axHmHq0
         NgriyldMbjLooZjJKY82ae1u+UWel6hQtGfr3N4vRLtYXwGbx8e7VADeGTaWUNoxlxS6
         Y9DrwSUsmtjAxyybRz4Mz3RQmmHJuGDyoxA5kKYPhc0oh43fxeI6mdeONqbTLbGBOtXg
         QBWWpfj2KDB+3a3gyyjsNYPTOo9OHdFPYPpknUi5KeBY86+yOV8os/6zDWBqma8iWw/e
         SvfUkn8aSs6HXNhpTka1hmxS9qIH9r0fO5ldzL/YYBH9r6qRZEBOPVywtM+B9edSBw2M
         8ExQ==
X-Gm-Message-State: ANhLgQ08mWuqKd9xq5SRPs8byTuxGOK5y7FVUifZDnuoPz3ClHqvJ8CK
        Op8rv679zPGvE8vpOusR2KQ=
X-Google-Smtp-Source: ADFU+vv6GiZ+6i0Ggxj8wOsDrW2Db/Q/QKiHSDPVYXlxRL+9oE8tICzz8OwXEDaeg2yNeK7CmNyYoA==
X-Received: by 2002:a62:cdcc:: with SMTP id o195mr3095617pfg.323.1583969271400;
        Wed, 11 Mar 2020 16:27:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s18sm6479240pjp.24.2020.03.11.16.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 16:27:50 -0700 (PDT)
Date:   Wed, 11 Mar 2020 16:27:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e6973ed90f8d_20552ab9153405b4ca@john-XPS-13-9370.notmuch>
In-Reply-To: <20200310174711.7490-5-lmb@cloudflare.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200310174711.7490-5-lmb@cloudflare.com>
Subject: RE: [PATCH 4/5] bpf: sockmap, sockhash: return file descriptors from
 privileged lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Allow callers with CAP_NET_ADMIN to retrieve file descriptors from a
> sockmap and sockhash. O_CLOEXEC is enforced on all fds.
> 
> Without this, it's difficult to resize or otherwise rebuild existing
> sockmap or sockhashes.
> 
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/core/sock_map.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 03e04426cd21..3228936aa31e 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -347,12 +347,31 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
>  static int __sock_map_copy_value(struct bpf_map *map, struct sock *sk,
>  				 void *value)
>  {
> +	struct file *file;
> +	int fd;
> +
>  	switch (map->value_size) {
>  	case sizeof(u64):
>  		sock_gen_cookie(sk);
>  		*(u64 *)value = atomic64_read(&sk->sk_cookie);
>  		return 0;
>  
> +	case sizeof(u32):
> +		if (!capable(CAP_NET_ADMIN))
> +			return -EPERM;
> +
> +		fd = get_unused_fd_flags(O_CLOEXEC);
> +		if (unlikely(fd < 0))
> +			return fd;
> +
> +		read_lock_bh(&sk->sk_callback_lock);
> +		file = get_file(sk->sk_socket->file);
> +		read_unlock_bh(&sk->sk_callback_lock);
> +
> +		fd_install(fd, file);
> +		*(u32 *)value = fd;
> +		return 0;
> +

Hi Lorenz, Can you say something about what happens if the sk
is deleted from the map or the sock is closed/unhashed ideally
in the commit message so we have it for later reference. I guess
because we are in an rcu block here the sk will be OK and psock
reference will exist until after the rcu block at least because
of call_rcu(). If the psock is destroyed from another path then
the fd will still point at the sock. correct?

Thanks.
