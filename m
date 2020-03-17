Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14002188CF3
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgCQSQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:16:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33814 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgCQSQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:16:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id 23so12413064pfj.1;
        Tue, 17 Mar 2020 11:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GPligt8SZ4vmyiqPXrOfMISNtA3jKedmIN0OJu/cq/k=;
        b=au03j/eHp4oDf86PBtb0jkX/mGTVoyM379kX+93nx3wKMkf+la9MBZCaQsFD54cBCA
         aCV55pzqQ+X0/Ci8qp7nIqhkrn+TRb1G0t63II+SEcabyPgZWJllk7LkdwHk08f3QNpk
         zKEHpCr5jQ0fwm5kwnqBJJrNWUEnqnH9rVnL4eVnVV+YnVynHZtE8aychr1mRpcR89fo
         n9b8BtyC743GyKu0TwZY+DA3KT8L9EOJm06FjmPMDjhdc0Egqsvvp8TphMYm/lXw1FOf
         ZM7/hsxq4kl2H5MfhS+sun8PifDdwzRL/kVv0N+qXUWucLCC92J3hfsHv3ajaTjnZPGY
         Nj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GPligt8SZ4vmyiqPXrOfMISNtA3jKedmIN0OJu/cq/k=;
        b=oPvp06daiJL6e4KChmo9J5Nn3xp6+MXxugdjOoYgsBjfNZdC2aI3qSvuGOWi2iJG2T
         2VpBIjjKz35o//pmoO48Ua2KSi/XfI91BSrU9nw4lTrmYeTdbneQiAm8/albCi127Car
         UVEUD63lSryP/00UMg56O8oiYGQDSrjTKOXZ4IUWKwXjzAaTnYJ8JvCIx05iNkcHzrLw
         XJhhTeQszuFuI+MOn3R/3lsiXt7D/IO9sPy5T/CCABjGvaMGCkapry+YLqcAb16DOGLk
         dMxK7Gq9teGJjjMVIpUIAdNS+Mqxhom/GebuzkV+iHz6g+tchZObfHsQrl6aKxysRnrQ
         yX0Q==
X-Gm-Message-State: ANhLgQ3kLTpPt3ZsMbJyInmOeDHtaIelqs7Xn+qFxUYdITfzz15E5+iQ
        yldgQJY+TDwHUM1UvYWWKwY=
X-Google-Smtp-Source: ADFU+vtgIxIuv8CicRbTAz6PU9jTobQMQhzhVZ+qBAMcxLxoh5KdzoKvJN8QgYG1CkUPo0oSY57d1A==
X-Received: by 2002:a63:4c5d:: with SMTP id m29mr480393pgl.376.1584468986648;
        Tue, 17 Mar 2020 11:16:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x66sm3510220pgb.9.2020.03.17.11.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 11:16:25 -0700 (PDT)
Date:   Tue, 17 Mar 2020 11:16:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e7113f16e7c6_278b2b1b264c65b445@john-XPS-13-9370.notmuch>
In-Reply-To: <87imj3xb5t.fsf@cloudflare.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200310174711.7490-5-lmb@cloudflare.com>
 <87imj3xb5t.fsf@cloudflare.com>
Subject: Re: [PATCH 4/5] bpf: sockmap, sockhash: return file descriptors from
 privileged lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, Mar 10, 2020 at 06:47 PM CET, Lorenz Bauer wrote:
> > Allow callers with CAP_NET_ADMIN to retrieve file descriptors from a
> > sockmap and sockhash. O_CLOEXEC is enforced on all fds.
> >
> > Without this, it's difficult to resize or otherwise rebuild existing
> > sockmap or sockhashes.
> >
> > Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  net/core/sock_map.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 03e04426cd21..3228936aa31e 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -347,12 +347,31 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
> >  static int __sock_map_copy_value(struct bpf_map *map, struct sock *sk,
> >  				 void *value)
> >  {
> > +	struct file *file;
> > +	int fd;
> > +
> >  	switch (map->value_size) {
> >  	case sizeof(u64):
> >  		sock_gen_cookie(sk);
> >  		*(u64 *)value = atomic64_read(&sk->sk_cookie);
> >  		return 0;
> >
> > +	case sizeof(u32):
> > +		if (!capable(CAP_NET_ADMIN))
> > +			return -EPERM;
> > +
> > +		fd = get_unused_fd_flags(O_CLOEXEC);
> > +		if (unlikely(fd < 0))
> > +			return fd;
> > +
> > +		read_lock_bh(&sk->sk_callback_lock);
> > +		file = get_file(sk->sk_socket->file);
> 
> I think this deserves a second look.
> 
> We don't lock the sock, so what if tcp_close orphans it before we enter
> this critical section? Looks like sk->sk_socket might be NULL.
> 
> I'd find a test that tries to trigger the race helpful, like:
> 
>   thread A: loop in lookup FD from map
>   thread B: loop in insert FD into map, close FD

Agreed, this was essentially my question above as well.

When the psock is created we call sock_hold() and will only do a sock_put()
after an rcu grace period when its removed. So at least if you have the
sock here it should have a sk_refcnt. (Note the user data is set to NULL
so if you do reference psock you need to check its non-null.)

Is that enough to ensure sk_socket? Seems not to me, tcp_close for example
will still happen and call sock_orphan(sk) based on my admittddly quick
look.

Further, even if you do check sk->sk_socket is non-null what does it mean
to return a file with a socket that is closed, deleted from the sock_map
and psock removed? At this point is it just a dangling reference?

Still a bit confused as well what would or should happen when the sock is closed
after you have the file reference? I could probably dig up what exactly
would happen but I think we need it in the commiit message so we understand
it. I also didn't dig up the details here but if the receiver of the
fd crashes or otherwise disappears this hopefully all get cleaned up?

> 
> > +		read_unlock_bh(&sk->sk_callback_lock);
> > +
> > +		fd_install(fd, file);
> > +		*(u32 *)value = fd;
> > +		return 0;
> > +
> >  	default:
> >  		return -ENOSPC;
> >  	}
