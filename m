Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E044B63970
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfGIQdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:33:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45178 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbfGIQdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:33:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so9701123pgp.12
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 09:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7S3YI9ol+VGCvBnkAP8WR+geiMetqGQ7b+ZI5IylQfc=;
        b=PBZ04sAKAYeZetvElobenJ68/97CKHbOQt7FK+xn5ZkhQAkadJAm7ScHhL90Q3zX+a
         jJcvNafMok25QZjX4sL3ZOttQx2aBZqql6/EpR7pT6b3kYVUyJ/fL3aGmosVxQFk09pi
         nvL/Xc7XF9YvwZ0SGQOMtJ/tKOfwnQWWGy9HEHYTFMa4JH3RdazCYl7LE2gu+MZZsTzB
         Xy0Wk9sE4ka4V9rBc+eD2r0f2VvLHI4Efub7bWSLBr4pTxK/EwWgvwT4+aa0qSsc0HuL
         tpqZragG7oyFtbIBSojIOToXYSk8ZS8P6J5DkHQXY89m4ikQfMN3xFLAbrowVH3qVhVz
         fSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7S3YI9ol+VGCvBnkAP8WR+geiMetqGQ7b+ZI5IylQfc=;
        b=DT3JW9Z3YFCXdAucOLx73bbNAK7gU1blnjk6KyuoP3Yw6NBLh4fHX4vQF0+rKTAr67
         fOiqdJWq25RhE2pjrBwAGgUdIC89ob8x2EzNxi3W8R2jdrmvqz+tcepcAS5mvXltZnTs
         815V1Cu1BSV0Asg9jznuYzOuQnZrFGtmKFd8ZxJz0W6LxTlI42Iz3lZSntlIWLN88sj5
         PwNutO3Lnl3lJJKQuKQ2esSDDkcCIKuhmFpOrvcp9dxoLPN+nAw/GXfzb5bo2DUlScEu
         LOEGmyYSzdCtzZX8PY6PN/1BmbZYOYZMQ/vxgH/i5AUlbKmHzi3ArSc7i/4hkyDGNegz
         UlbQ==
X-Gm-Message-State: APjAAAXeGLvMI3Afepuwwsk+cjAQx0KsELe6JSOIuPdaB0XpE7SJDLzg
        XJUtEAL/AYFFULVfcp5U+KeqVw==
X-Google-Smtp-Source: APXvYqynNYQNkDncLwuBfsq3Bp5Pjx8d/Rc4U0oIOfp/aURJZuwvOvFsc0TQYVpYXbi2CIlrlwYx7Q==
X-Received: by 2002:a63:5a0a:: with SMTP id o10mr32199007pgb.282.1562690003602;
        Tue, 09 Jul 2019 09:33:23 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id i7sm2855400pjk.24.2019.07.09.09.33.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 09:33:22 -0700 (PDT)
Date:   Tue, 9 Jul 2019 09:33:21 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned
 sk
Message-ID: <20190709163321.GB22061@mini-arch>
References: <20190611214557.2700117-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611214557.2700117-1-kafai@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/11, Martin KaFai Lau wrote:
> The cloned sk should not carry its parent-listener's sk_bpf_storage.
> This patch fixes it by setting it back to NULL.
Have you thought about some kind of inheritance for listener sockets'
storage? Suppose I have a situation where I write something
to listener's sk storage (directly or via recently added sockopts hooks)
and I want to inherit that state for a freshly established connection.

I was looking into adding possibility to call bpf_get_listener_sock form
BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB callback to manually
copy some data form the listener socket, but I don't think
at this point there is any association between newly established
socket and the listener.

Thoughts/ideas?

(Btw, sorry for digging up this old mail, but it feels relevant).

> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/core/sock.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 2b3701958486..d90fd04622e5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1850,6 +1850,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>  			goto out;
>  		}
>  		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
> +#ifdef CONFIG_BPF_SYSCALL
> +		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> +#endif
>  
>  		newsk->sk_err	   = 0;
>  		newsk->sk_err_soft = 0;
> -- 
> 2.17.1
> 
