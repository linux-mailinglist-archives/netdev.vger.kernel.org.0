Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB46D5303
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjDCVF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjDCVF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:05:28 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AB51990;
        Mon,  3 Apr 2023 14:05:27 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z18so18341537pgj.13;
        Mon, 03 Apr 2023 14:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680555926;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tbm/1Z7pscrBG0ZZhn1hbEou8eY1g5LF47B9DlKafFI=;
        b=LUb4aRBx/1cQAXYbj6jJH8rVYd62Hn/D67ltQAVDOHDepio3qyEhuwpgSlF2Cp+2/y
         /AetyTGyl/dgvyjzwnqFb1FbfXLAYoGUHquuJSYgByhG3Ue+fd1JUHOidYdvcLWJcm95
         8GeNerJ7dQxkMNw4KAZ+XGGc9YuVlZnZGiWK6+Sjr0LU06lQJOSOkDvrVgEzOxHfKSEA
         tpV6M5VHcweZI8mOZ7EQuVSrlLqGCqvAzIE99CC4uVWpLT/Rc1sN6YKaTydEk2WhaFyE
         4geToD+fe2gZ5Lrs+rNHiXET5/HXQFdUvF8/+UagUrZEwSJ4fMpHOz0DbYgGe66rWZ4z
         wDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680555927;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tbm/1Z7pscrBG0ZZhn1hbEou8eY1g5LF47B9DlKafFI=;
        b=7gNFL9Kmoglru/irI4DVOLa4A/3vG0eSr+kSj+5nWLdIiOWC/CoakcVatSEZhloT7m
         i3YNgnKfEoXQz+fZK8B3xgm4XXM9Xm9+USME+adUf8K4o3l7jWiklYZgqTu9TF4Gbp0o
         13dZZ1WvM9vpJLY2KhCHMjF3Y6IORmMUYte87tx1MhfmUtZd0qFiAfYmo0vowAxAxJT+
         NFCWhaTcOvwgOtaJrQy8Tx//q07LnrQy9ZA/Ku/1nYcWEM3DiS8cCRrJYlxrL89TX0DI
         SHdW0z0t63r1G6XUe497HaWX856ULJBYergc2+0okMnKmpi34xl4xZaRUT6RfipeHWgr
         aIcw==
X-Gm-Message-State: AAQBX9eFlcr1kyvDU8lZ/205VyFbMyjqGpVfBBBEuYPPh2yzb8V/4+il
        t+KJKS3738Lr+WbLzVjS/hE=
X-Google-Smtp-Source: AKy350atusfAtVwRYzds1wLB2Qf94oSUsoqAp9rWmwhdmQprXnxWNmrvkXCiXS9bTyy7NiBAPVszyQ==
X-Received: by 2002:a62:19c8:0:b0:625:9055:3bc9 with SMTP id 191-20020a6219c8000000b0062590553bc9mr31773061pfz.27.1680555926586;
        Mon, 03 Apr 2023 14:05:26 -0700 (PDT)
Received: from localhost ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id z8-20020aa791c8000000b005a8dcd32851sm7586895pfa.11.2023.04.03.14.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:05:26 -0700 (PDT)
Date:   Mon, 03 Apr 2023 14:05:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Message-ID: <642b3f94f13df_e67b72086@john.notmuch>
In-Reply-To: <87a5zpdxu7.fsf@cloudflare.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-5-john.fastabend@gmail.com>
 <87a5zpdxu7.fsf@cloudflare.com>
Subject: Re: [PATCH bpf v2 04/12] bpf: sockmap, handle fin correctly
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Mon, Mar 27, 2023 at 10:54 AM -07, John Fastabend wrote:
> > The sockmap code is returning EAGAIN after a FIN packet is received and no
> > more data is on the receive queue. Correct behavior is to return 0 to the
> > user and the user can then close the socket. The EAGAIN causes many apps
> > to retry which masks the problem. Eventually the socket is evicted from
> > the sockmap because its released from sockmap sock free handling. The
> > issue creates a delay and can cause some errors on application side.
> >
> > To fix this check on sk_msg_recvmsg side if length is zero and FIN flag
> > is set then set return to zero. A selftest will be added to check this
> > condition.
> >
> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > Tested-by: William Findlay <will@isovalent.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/ipv4/tcp_bpf.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index cf26d65ca389..3a0f43f3afd8 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> 
> [...]
> 
> > @@ -193,6 +211,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
> >  	lock_sock(sk);
> >  msg_bytes_ready:
> >  	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
> > +	/* The typical case for EFAULT is the socket was gracefully
> > +	 * shutdown with a FIN pkt. So check here the other case is
> > +	 * some error on copy_page_to_iter which would be unexpected.
> > +	 * On fin return correct return code to zero.
> > +	 */
> > +	if (copied == -EFAULT) {
> > +		bool is_fin = is_next_msg_fin(psock);
> > +
> > +		if (is_fin) {
> > +			copied = 0;
> > +			goto out;
> > +		}
> > +	}
> >  	if (!copied) {
> >  		long timeo;
> >  		int data;
> 
> tcp_bpf_recvmsg needs a similar fix, no?

Yes, I had lumped it in with follow up fixes needed for the
stream parser case but your right its not related.

Mind if I do it in a follow up? Or if I need to do a v4 I'll
roll it in there.

Thanks!
John
