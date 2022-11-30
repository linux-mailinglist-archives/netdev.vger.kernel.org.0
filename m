Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80E63D695
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiK3NWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiK3NW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:22:29 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDBD27FFF;
        Wed, 30 Nov 2022 05:22:27 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 82so8555076pgc.0;
        Wed, 30 Nov 2022 05:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=gIR1B57sG32Q6BaEtfiufxFGGFeXy7wbZX9GDO4FCdQ=;
        b=FsTqhqzfiIFw2RcD7UUXmeZ8vh1cJ9X0IMc9qQV1OPP4AWIL+bSEQ1U1SRcAVVjsjp
         TJuagojnh7kjO9ag/ctnu2aiXofUVnvDYx8FEDKOl6fjH1d9PDCzOJK7rj8spfiv2+lr
         wWbEp2jdCxPZcPDfD7ZdmYpSswN29gihNJdkR26VDSwWMzcJuN8iKTtbUeWSC+5vcGkq
         +Eds8G2onZc8+d2bVCGJ7DluWt8T9xG0uQezCuLl2Z/J6HqH9n1bZmuMUn55owxyM4PP
         dwmKNVY5W+NNB7zdPVL1BM8G7WaXeRNibwIXT7ZBeAqKeCfKxdMXnGQoIydllEMlHe5X
         zdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIR1B57sG32Q6BaEtfiufxFGGFeXy7wbZX9GDO4FCdQ=;
        b=e3ilhoADecgoD72Bn9L/h6boD4tqjX4BpzozKEYERwuvuX3CQR9jcN4+ovZevLbnH8
         5eUX6UYLgQK+exBfSjTZh8PaBQvYElwj4apGOwlmTG4mUL9ikUmSG+E9fT8cDwDmvqEy
         MIeT7OPQoSRfVvdpM+mOjTFP+XoVw3a7V4fFHq3paGtcDfuaFVTDDGLFOa5Nk8JwzIdt
         KQ82w0AzbmmN7+4gxamt0JQNnIgO+sCDOlivDWuLu+oZBUvkVZi0W/IQZTcQ+IfGM5Ph
         hxkumSZ3O5SIkboxrNygjhD2lZwy0jJASzdnPsqFw6tDljpAZMPQpeJ5cdIQrXCsJiQC
         iVsg==
X-Gm-Message-State: ANoB5pmrm4qpzb9+qcjZcqjbQRgUbMDpe1kjhT/rqMyWsbrc8COp8qyf
        Bphp2NgJ0vOlQRtnhadwufs=
X-Google-Smtp-Source: AA0mqf5MWIBTLkJGoApQdBkYKO67SZD/1DSocER0gcLkKOph67tCE315jhJAw2gAJEGIRu/4dgk2ug==
X-Received: by 2002:a63:f406:0:b0:477:cc1f:204 with SMTP id g6-20020a63f406000000b00477cc1f0204mr28290048pgi.592.1669814547061;
        Wed, 30 Nov 2022 05:22:27 -0800 (PST)
Received: from MBP (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id fa13-20020a17090af0cd00b00218abadb6a8sm1226030pjb.49.2022.11.30.05.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 05:22:26 -0800 (PST)
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org> <m2r0xli1mq.fsf@gmail.com>
 <Y4b1MQaEsPRK+3lF@codewreck.org> <m2o7sowzas.fsf@gmail.com>
 <Y4c5N/SAuszTLiEA@codewreck.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Schspa Shi <schspa@gmail.com>
To:     asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Wed, 30 Nov 2022 21:15:12 +0800
In-reply-to: <Y4c5N/SAuszTLiEA@codewreck.org>
Message-ID: <m2a6487f23.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


asmadeus@codewreck.org writes:

> Schspa Shi wrote on Wed, Nov 30, 2022 at 04:14:32PM +0800:
>> >  - reqs are alloced in a kmem_cache created with SLAB_TYPESAFE_BY_RCU.
>> >  This means that if we get a req from idr_find, even if it has just been
>> >  freed, it either is still in the state it was freed at (hence refcount
>> >  0, we ignore it) or is another req coming from the same cache (if
>> 
>> If the req was newly alloced(It was at a new page), refcount maybe not
>> 0, there will be problem in this case. It seems we can't relay on this.
>> 
>> We need to set the refcount to zero before add it to idr in p9_tag_alloc.
>
> Hmm, if it's reused then it's zero by definition, but if it's a new
> allocation (uninitialized) then anything goes; that lookup could find
> and increase it before the refcount_set, and we'd have an off by one
> leading to use after free. Good catch!
>
> Initializing it to zero will lead to the client busy-looping until after
> the refcount is properly set, which should work.

Why? It looks no different from the previous process here. Initializing
it to zero should makes no difference.

> Setting refcount early might have us use an re-used req before the tag
> has been changed so that one cannot move.
>
> Could you test with just that changed if syzbot still reproduces this
> bug? (perhaps add a comment if you send this)
>

I have upload a new v2 change for this. But I can't easily reproduce
this problem.

> ------
> diff --git a/net/9p/client.c b/net/9p/client.c
> index aaa37b07e30a..aa64724f6a69 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -297,6 +297,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
>  	p9pdu_reset(&req->rc);
>  	req->t_err = 0;
>  	req->status = REQ_STATUS_ALLOC;
> +	refcount_set(&req->refcount, 0);
>  	init_waitqueue_head(&req->wq);
>  	INIT_LIST_HEAD(&req->req_list);
>
> ----- 
>
>> >  refcount isn't zero, we can check its tag)
>> 
>> As for the release case, the next request will have the same tag with
>> high probability. It's better to make the tag value to be an increase
>> sequence, thus will avoid very much possible req reuse.
>
> I'd love to be able to do this, but it would break some servers that
> assume tags are small (e.g. using it as an index for a tag array)
> ... I thought nfs-ganesha was doing this but they properly put in in
> buckets, so that's one less server to worry about, but I wouldn't put
> it past some simple servers to do that; having a way to lookup a given
> tag for flush is an implementation requirement.
>
> That shouldn't be a problem though as that will just lead to either fail
> the guard check after lookup (m->rreq->status != REQ_STATUS_SENT) or be
> processed as a normal reply if it's already been sent by the other
> thread at this point.
> OTOH, that m->rreq->status isn't protected by m->req_lock in trans_fd,
> and that is probably another bug...

Yes, I aggree with you, another BUG.

-- 
BRs
Schspa Shi
