Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9DB3D006E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhGTRBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhGTRBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 13:01:00 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674A1C061574;
        Tue, 20 Jul 2021 10:41:38 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r16so19833521ilt.11;
        Tue, 20 Jul 2021 10:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VzEhlXuPIig3XvgXhLsDpAhNny6hVe14Hrn4Hr2l/EY=;
        b=mMbsK+2UWIOEYn5GvvcJwd6Eglp3ceJFrCu68N4aKGGoejhU1YaG8m2i7wI0SeWCQc
         BaCN2c0gNrH7MrJ6WFay7a+TUBMyoLqhpze6dRH/4+N1s55IKeslxdFeDcwI6OKtpzty
         IuFGf+6GB+SWOh8wkHGU7to+lGgiQYXJ+vx9srucsjj/HSbsrVFdy7nau5can7aoCULU
         wjm1LNv3PVboDMjpDUUsFM0MCiWDxqtwh+pgsBzijqGGt1H8423hbvNOsJNFBX/h0Rku
         gNTdT52o59tRRdkc/4tyPY1tOyUEDIeve6zMyC+NzvOFJfj+EavfV8FxZ3DlydnYgcNx
         jTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VzEhlXuPIig3XvgXhLsDpAhNny6hVe14Hrn4Hr2l/EY=;
        b=Vi+gFKFkDVbhp2mKfZaTO1RUlTD+IR1P5sHvSwwkb4Jz28WSm+MK/OO5AZF/H53FZb
         E+oS9l2p+pM3ss9unJdPIbzb7KQYfM5JsFEfM8RBd4mS6DedS744NQLzsj4DNcyYNUTD
         oy+6VI6sm31QvCW5LKMxKZ/M+pEUc6APZgXM2HYhaMLlBdJvnhMyl8AqgoNOY/v5wLf1
         UXeHdBslFjuel+iUnxyZbuIChro1ApJk7daowErIk9WGNLEctHw6hQiG+GKOp3w29mkb
         zarmSz/f5aOSGjSm1Nj8OFm6NVSrXk3Es1GStWgox7e/RmsbdLrxtGgN9jtQPysR2w3F
         7x9A==
X-Gm-Message-State: AOAM533QrmsGRSERhRY9ld5onpH63dDj3faCVvg0eZlaapJ6GzPYKQCO
        QP3NqQTHKVAiwxh6AulsoRc=
X-Google-Smtp-Source: ABdhPJzvt1dvtkXKrKgZ2OwasppJxCTQeIUriAz81e940OR3X1Mil5q6QAgXTTbLh4WmfFJ5jMrd5w==
X-Received: by 2002:a92:dc8e:: with SMTP id c14mr21973371iln.91.1626802897763;
        Tue, 20 Jul 2021 10:41:37 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id v18sm11872639iln.49.2021.07.20.10.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 10:41:37 -0700 (PDT)
Date:   Tue, 20 Jul 2021 10:41:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, xiyou.wangcong@gmail.com,
        alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <60f70ac727c2d_6600820855@john-XPS-13-9370.notmuch>
In-Reply-To: <87v955qnzp.fsf@cloudflare.com>
References: <20210719214834.125484-1-john.fastabend@gmail.com>
 <20210719214834.125484-2-john.fastabend@gmail.com>
 <87v955qnzp.fsf@cloudflare.com>
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: zap ingress queues after stopping
 strparser
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Mon, Jul 19, 2021 at 11:48 PM CEST, John Fastabend wrote:
> > We don't want strparser to run and pass skbs into skmsg handlers when
> > the psock is null. We just sk_drop them in this case. When removing
> > a live socket from map it means extra drops that we do not need to
> > incur. Move the zap below strparser close to avoid this condition.
> >
> > This way we stop the stream parser first stopping it from processing
> > packets and then delete the psock.
> >
> > Fixes: a136678c0bdbb ("bpf: sk_msg, zap ingress queue on psock down")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> 
> To confirm my understanding - the extra drops can happen because
> currently we are racing to clear SK_PSOCK_TX_ENABLED flag in
> sk_psock_drop with sk_psock_verdict_apply, which checks the flag before
> pushing skb onto psock->ingress_skb queue (or possibly straight into
> psock->ingress_msg queue on no redirect).


Correct. If strparser hands a skb to the sk_psock_* handlers then before
they enqueue the packet the flag is checked and the packet will be
dropped in this case. I noticed this while testing. So rather than
letting packets get into sk_psock_* handlers this patch just stops the
strparser.
