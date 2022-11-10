Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30680624437
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiKJO14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKJO1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:27:54 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F21029377
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:27:53 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id b124so1970918oia.4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/fH0HWuR3pLI/w2Hy5ltbqAgoCH82Df6Jyv57cfUI/0=;
        b=7cTmMxQUSIOLqWwcN+YbPWQ7T0OvlUPd0GXBV4wx65ICjBaILGHoXTuRWPpZYhP+7j
         ljWtc1GbIJkcbIhjX6MOfn1J6FoAisIGy9sCAxLh6PLeLFWFkVHU6A71UFWdMOJBX5LE
         KX+lGam/+QVgiJz7F8KF5aScFvo6Ck6jfXiwCodcTe2zUBr/vS+qDEXNLq0uxfIf+Elv
         OfFzcnWJB1bKbomCz+qxUPBlMbUmEii4s/u1JR28nLlQVKRJuNglFVbk0pcWgDm0VdQC
         KPWvyE0cBDqeqV4PGI8H59ysbGE1aIOZCpA5pyJQNOniMMdxJRyVpezs0gjROlbcYrS6
         3yAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fH0HWuR3pLI/w2Hy5ltbqAgoCH82Df6Jyv57cfUI/0=;
        b=RqEA3aVXhh8krD7FDbja808qZ/xEfPsxjQkg5aBtkqv/PqKoykQ0dTwf7dfD2Vc6Zr
         sl6LCZC8ODfo6Ri5MVI2INxnoPYNWmD4Z5sdr6rJ8v21Wr/SgnY4DCZkoFxDVa3n6H5J
         bJ7dOgAq0h0zuau/TVJpUBEX5cjfd+ily0occrpFITDgnnz+ISYVKJlh0i98zqWj062a
         Za8FQx3J4DGeJ81uZXNz1B+mGRxP9swAwW61dRLKUYnWO3Z5H4BC9uBzupFijBykVw+p
         b5psGmpEXjq6FnFuOIp1OEIJ1k7FiTbSC1drEWuw9zoCvFQyaYAe+1bpIOGFgtnKKsdN
         QOng==
X-Gm-Message-State: ACrzQf2UtzBlnn2tjhCJPVoL+XVUTLKwfABkntHJyHY3OxXaTlRwL0Ri
        zPejrx4tb2ryw6AcEUyi3efypy71+JQF/Nvz0okd8g==
X-Google-Smtp-Source: AMsMyM4FAa6uxRFadfxzuZYadl8r5TBNllfVUxNSZGIM3vn9t2vJNYxcLSwPidTxdWhg4MrHFiI2PmMJ699PKsz+bwA=
X-Received: by 2002:aca:2307:0:b0:357:765a:3ce5 with SMTP id
 e7-20020aca2307000000b00357765a3ce5mr1415126oie.2.1668090472615; Thu, 10 Nov
 2022 06:27:52 -0800 (PST)
MIME-Version: 1.0
References: <20220929033505.457172-1-liuhangbin@gmail.com> <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain> <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1> <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org> <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org> <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com> <20221109182053.05ca08b8@kernel.org>
In-Reply-To: <20221109182053.05ca08b8@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 10 Nov 2022 09:27:40 -0500
Message-ID: <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 9:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 9 Nov 2022 20:52:37 -0500 Jamal Hadi Salim wrote:
> > TCA_XXX are local whereas NLMSGERR_ATTR_MSG global to the
> > netlink message.
>
> "Global", but they necessitate complicating the entire protocol
> to use directly.
>
> Unless we want to create a separate netlink multicast channel for
> just ext acks of a family. That's fine by me, I guess. I'm mostly
> objecting to pretending notifications are multi-msg just to reuse
> NLMSG_DONE, and forcing all notification listeners to deal with it.
>

TBH, I am struggling as well. NLMSG_DONE is really for multi-message
(with kernel state) like dumps. Could we just extend nlmsg_notify()
callers to take extack and pass it through and then have  nlmsg_notify()
do the NLM_F_ACK_TLVS dance without MULTI flag? It would have to
be backward compat and require user space changes which Hangbin's
patch avoids but will be more general.

> > Does this mean to replicate TCA_NTF_EXT_ACK
> > for all objects when needed? (qdiscs, actions, etc).
>
> The more time we spend discussing this the more I'm inclined to say
> "this is a typical tracing use case, just use the tracepoint" :(

I understand your frustration but from an operational pov it is better to deal
with one tool than two (Marcelo's point). The way i look at these uapi
discussions
is it is ok to discuss the color of the bike shed(within reason) because any
decisions made here will have a long term effect.

cheers,
jamal
