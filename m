Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16B86A62A8
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjB1Wkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB1Wki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:40:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119762E0CB;
        Tue, 28 Feb 2023 14:40:09 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso7300962pjb.2;
        Tue, 28 Feb 2023 14:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677624007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1M39pp6BOTJLqCwHMILP4cFGR727Jpzqg5ju78BWx8=;
        b=Oz6li5x7qu54218EoqDEzjLgff3Vj2grOCtgtsoWTNgT6AYnNiUcIuRQiqcJOEA5gZ
         lokkfjPyQ+w2r3I5ruEt9DFdVy3H+AEbsZWNRLJfP9IrivZCulnotDP2dkKjCHW2jezd
         oH/1GsAf3wBT5OLBNz4wyDvwXNa1SJ1QxHOLzEYf1Kl89mujGFgm28uhD1qlomCjEflr
         bCeRRfAqUwJtDDixVCbany7a9KpomAINGpJM705L2yJVBZK4mK9qrIQDIxc6JJIFd9yF
         tjQFz536hqsfFmqM8whmhUnWETcCHagKQ8gjozlmnJvIEERWUuH+zGpWm83+hejyxPyb
         WJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677624007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1M39pp6BOTJLqCwHMILP4cFGR727Jpzqg5ju78BWx8=;
        b=I7cIpliuWGRGqFKm2A1s8ZUg4Jc5n6dHM/3e9ZtF6BcBzO1IITWjl4OuMl5P5dv4FJ
         7ONEXzuv/jR/twhujq4lDNtYJMrNyRC38iq+ae6y5CesvFcXYhTOHWhsMuB6fW97p41p
         3vWDN7kkxBxphtO6XzW5nwN5QNlzjDw2ul7OhCCttl4GANVBVJexGy8Q1C39SenUSHBW
         fA+Ko4aBMJuNxd2oS2aLO62x1kQwcP+Mbo1RnY3vDHJL5EseOT/CAN47vdQgVCaTtawl
         0TVPbsXt9EL96vzv7xQCz0svBzfiiDxGUaval8Ln64eRjC1kapMVDhi1gNKoYh2QnvwJ
         XJdg==
X-Gm-Message-State: AO0yUKWekz0uoPRulgFUu0JZ2WZm1qXZQFZfo8xsBt/gtJXbBSSn4gyG
        yUrkiv/N58OmHGJs4gAMzPw=
X-Google-Smtp-Source: AK7set/cI3/YGAgHbDcqpXTyWxlPEBObsGXe9DTePwqU5sY2tx6bSstbGZUhiztB9D0VuAUQRYFuKA==
X-Received: by 2002:a17:903:187:b0:199:1996:71ec with SMTP id z7-20020a170903018700b00199199671ecmr4957460plg.16.1677624007358;
        Tue, 28 Feb 2023 14:40:07 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b0019cb8ffd209sm7029866plk.229.2023.02.28.14.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 14:40:06 -0800 (PST)
Date:   Sat, 18 Feb 2023 07:25:41 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, kvm@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Song Liu <song@kernel.org>, Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Hao Luo <haoluo@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 1/3] vsock: support sockmap
Message-ID: <Y/B9ddkfQw6Ae/lY@bullseye>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
 <20230227-vsock-sockmap-upstream-v3-1-7e7f4ce623ee@bytedance.com>
 <20230228163518-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228163518-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 04:36:22PM -0500, Michael S. Tsirkin wrote:
> On Tue, Feb 28, 2023 at 07:04:34PM +0000, Bobby Eshleman wrote:
> > @@ -1241,19 +1252,34 @@ static int vsock_dgram_connect(struct socket *sock,
> >  
> >  	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> >  	sock->state = SS_CONNECTED;
> > +	sk->sk_state = TCP_ESTABLISHED;
> >  
> >  out:
> >  	release_sock(sk);
> >  	return err;
> >  }
> 
> 
> How is this related? Maybe add a comment to explain? Does
> TCP_ESTABLISHED make sense for all types of sockets?
> 

Hey Michael, definitely, I can leave a comment.

The real reason is due to this piece of logic in sockmap:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/core/sock_map.c?h=v6.2#n531

And because of it, you see the same thing in (for example)
unix_dgram_connect():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/unix/af_unix.c?h=v6.2#n1394

I believe it makes sense for these other socket types.
