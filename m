Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4623551E212
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445014AbiEFXif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 19:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359057AbiEFXid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 19:38:33 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A53712D2;
        Fri,  6 May 2022 16:34:49 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id s4so7037869qkh.0;
        Fri, 06 May 2022 16:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AFw9PXyBSk/WNkQIM3l5UfsVFeJWVnrr4Za7pgabACc=;
        b=XO+OHpIjgPeTs/y///sf+ed3H32QFspI/ckdPQ+QuOhooD5MNPjBdU66FwQDXUuQ2I
         At/QbJu5ueSV0RrUanXBv7/1ynR75kUoKOIUKW3tfslQDHaatj6qb3pRZEvZloMKZ5O/
         rwEFt3D7Js/BScdZV6PS37tjaXOTTee4ht/seY8HilobY04ZiEW+g6SyOe0CMcOg+fBh
         DpXQHLmzZn3h+YxXWYo0qtlwsAPTVYn0oliWbgOScUBJVWUBy9fXmiJadxDmXGnzKGnc
         HxK2dpDOSYNmOhszaSxjWKjHutnU7p8TVh4UiHONtuxRm/Bl2nIA0ruLhW8pIXAkdl45
         AoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AFw9PXyBSk/WNkQIM3l5UfsVFeJWVnrr4Za7pgabACc=;
        b=cMknAGeWAdbqdVZE1rLqbIgFgddIlb3UsOsm1W8TF7Ueua8QlYF+949DkBv/cK3zPX
         /MBbPei8tQVGY5VPj00gADwnsq9h5DrGrDevI/tAW6lia+iKbsTNuGLcYMXNZkR30l41
         wlYDH9rwVDvJMt4qSjbkNhSw6NMAarLYznKoosyMdaKBGSOWq7SOPh80rRAeyDhHJsBv
         jl9d8ksGkR5crWjfbRPjsfA6O4PCT2CuV/YevpaQomBebvReCZeRsSfeFNO2GoGBTmnQ
         kFfa64l5NjslAskpg4EERt65dA+1LYtS1+l4tGGL5XcvKFIM8Ytd2MPRU56Mx0b23EcX
         3cSw==
X-Gm-Message-State: AOAM533NUl8CE2P1enpf0kExX3BFW5mwN+flIcizqXi3eVt7/JiVld0U
        VBT5gtf+AH/W5KEgN7/K4vBi+l5tIA==
X-Google-Smtp-Source: ABdhPJyW0u2IEPNyfZ1AaxvJac8N/QkiUyIlNj69PTP9P8cWFQX+Q59bi//nFWRJ+XMXdClogtWHHA==
X-Received: by 2002:a05:620a:c52:b0:648:d550:5583 with SMTP id u18-20020a05620a0c5200b00648d5505583mr4259248qki.232.1651880088270;
        Fri, 06 May 2022 16:34:48 -0700 (PDT)
Received: from bytedance (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id 18-20020a05620a06d200b0069fc13ce213sm3119420qky.68.2022.05.06.16.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 16:34:47 -0700 (PDT)
Date:   Fri, 6 May 2022 16:34:43 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC v1 net-next 1/4] net: Introduce Qdisc backpressure
 infrastructure
Message-ID: <20220506233443.GA3336@bytedance>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <f4090d129b685df72070f708294550fbc513f888.1651800598.git.peilin.ye@bytedance.com>
 <20220506133111.1d4bebf3@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506133111.1d4bebf3@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Fri, May 06, 2022 at 01:31:11PM -0700, Stephen Hemminger wrote:
> On Fri,  6 May 2022 12:44:22 -0700, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > +static inline void qdisc_backpressure_overlimit(struct Qdisc *sch, struct sk_buff *skb)
> > +{
> > +	struct sock *sk = skb->sk;
> > +
> > +	if (!sk || !sk_fullsock(sk))
> > +		return;
> > +
> > +	if (cmpxchg(&sk->sk_backpressure_status, SK_UNTHROTTLED, SK_OVERLIMIT) == SK_UNTHROTTLED) {
> > +		sock_hold(sk);
> > +		list_add_tail(&sk->sk_backpressure_node, &sch->backpressure_list);
> > +	}
> > +}
> 
> What if socket is closed? You are holding reference but application maybe gone.

Thanks for pointing this out!  I just understood how sk_refcnt works
together with sk_wmem_alloc.

By the time we process this in-flight skb, sk_refcnt may have already
reached 0, which means sk_free() may have already decreased that "extra" 1
sk_wmem_alloc, so skb->destructor() may call __sk_free() while I "hold"
the sock here.  Seems like a UAF.

> Or if output is stalled indefinitely?

It would be better to do a cleanup in sock destroying code, but I am
trying to avoid acquiring Qdisc root_lock there.  I will try to come up
with a better solution.

Thanks,
Peilin Ye


