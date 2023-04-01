Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728C56D2C30
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 02:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjDAA7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 20:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDAA7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 20:59:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5781B7D5;
        Fri, 31 Mar 2023 17:59:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so27237307pjt.2;
        Fri, 31 Mar 2023 17:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680310790;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS/BPE64oP8UzI/jVCx4ABuYeNDgELL8aYJAuds5G/U=;
        b=FijOoNPtMDFRoF77ieBKgmcs7bHxbmk72RJ/agf6zZIAxmKhAYQKBcdWUdN05N1kZI
         2PiZmPsYDfV6tvOuoIvq/2A33lQifH5+FXO08sOaxNbSj2Aw7NUycJPHxef6vMFrwiCx
         I7aCdzEifhfR2m8EwbaNtNseYMF9VUNlT/obh2K28ufqEsdvx8ANJ7EnhvL1OK9pK09Z
         gsOOyZ/bOWrAd11S84YOdUCMetK2ZqpxnLxyHFJhPTVu4UBTk6p9OXUuUgHk+amLgljS
         XImjbp5LYIupzZdJYabVSov8PPES7z2pnPNJB4bwq+pr3m0g/Jlz34era6btcQ2ZIj0Q
         NsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680310790;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AS/BPE64oP8UzI/jVCx4ABuYeNDgELL8aYJAuds5G/U=;
        b=glNhACOcIBzgoaxai5aNxCKsPWpDutwtvm/DYM2SjhGQb8LZxTW9L8giI2xKLZuqWt
         +n5bml/evCM1pj+kfiHlm09MPdmpIqtkzyfxejc8jeCKPWjkxLtgyx61AafEOLXqd8+x
         9YDqSamDiEJnEnCinLuT0UVsBFPkVCiWnEHKZVJT28l/ipeAh+uwfRfTCC4Ot4StwdIE
         DRNSs3aXpDoosn9MNzu9wa5ZapifyQeAPGRGyona2i+4ce4+q0WmiYG6OHJkfAl/q3Vp
         igdDHo0MsWmLFfo5zftOhIfnjqKkpyLQFFKNZ40TfzVvfekTGIsj15B7uWtN9ho0TwtV
         LiXg==
X-Gm-Message-State: AAQBX9cDXx3s9aUWieKPNIsaD8o8f9K53ldoSDCveI8K3OgYnx7EjFqB
        5H+3TzRRsQ2tnqhg7wXHIQ4=
X-Google-Smtp-Source: AKy350aQVRvJtGKnT/aYeQcEVO/NCQ3gQTzxO6AZrtSud0ggIuO6b/ntFYFkkV48SvIQIvNhVxOikA==
X-Received: by 2002:a17:903:188:b0:19c:f096:bbef with SMTP id z8-20020a170903018800b0019cf096bbefmr36994360plg.49.1680310790332;
        Fri, 31 Mar 2023 17:59:50 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id a12-20020a1709027d8c00b001a19b6ccdd4sm2174366plm.84.2023.03.31.17.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 17:59:49 -0700 (PDT)
Date:   Fri, 31 Mar 2023 17:59:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Message-ID: <642782044cf76_c503a208d5@john.notmuch>
In-Reply-To: <87zg7vbu60.fsf@cloudflare.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-4-john.fastabend@gmail.com>
 <87zg7vbu60.fsf@cloudflare.com>
Subject: Re: [PATCH bpf v2 03/12] bpf: sockmap, improved check for empty queue
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
> > We noticed some rare sk_buffs were stepping past the queue when system was
> > under memory pressure. The general theory is to skip enqueueing
> > sk_buffs when its not necessary which is the normal case with a system
> > that is properly provisioned for the task, no memory pressure and enough
> > cpu assigned.
> >
> > But, if we can't allocate memory due to an ENOMEM error when enqueueing
> > the sk_buff into the sockmap receive queue we push it onto a delayed
> > workqueue to retry later. When a new sk_buff is received we then check
> > if that queue is empty. However, there is a problem with simply checking
> > the queue length. When a sk_buff is being processed from the ingress queue
> > but not yet on the sockmap msg receive queue its possible to also recv
> > a sk_buff through normal path. It will check the ingress queue which is
> > zero and then skip ahead of the pkt being processed.
> >
> > Previously we used sock lock from both contexts which made the problem
> > harder to hit, but not impossible.
> >
> > To fix also check the 'state' variable where we would cache partially
> > processed sk_buff. This catches the majority of cases. But, we also
> > need to use the mutex lock around this check because we can't have both
> > codes running and check sensibly. We could perhaps do this with atomic
> > bit checks, but we are already here due to memory pressure so slowing
> > things down a bit seems OK and simpler to just grab a lock.
> >
> > To reproduce issue we run NGINX compliance test with sockmap running and
> > observe some flakes in our testing that we attributed to this issue.
> >
> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > Tested-by: William Findlay <will@isovalent.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> 
> I've got an idea to try, but it'd a bigger change.
> 
> skb_dequeue is lock, skb_peek, skb_unlink, unlock, right?
> 
> What if we split up the skb_dequeue in sk_psock_backlog to publish the
> change to the ingress_skb queue only once an skb has been processed?

I think this works now. Early on we tried to run backlog without locking
but given this is now locked by mutex I think it works out.

We have a few places that work on ingress_skb but those are all enqueue
on tail so should be fine to peek here.

> 
> static void sk_psock_backlog(struct work_struct *work)
> {
>         ...
>         while ((skb = skb_peek_locked(&psock->ingress_skb))) {
>                 ...
>                 skb_unlink(skb, &psock->ingress_skb);
>         }
>         ...
> }
> 
> Even more - if we hold off the unlinking until an skb has been fully
> processed, that perhaps opens up the way to get rid of keeping state in
> sk_psock_work_state. We could just skb_pull the processed data instead.

Yep.

> 
> It's just an idea and I don't want to block a tested fix that LGTM so
> consider this:

Did you get a chance to try this? Otherwise I can also give the idea
a try next week.

> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
