Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C302F698104
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjBOQiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBOQiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:38:04 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7478B2128
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:37:49 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-52ee632329dso210267847b3.6
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s5VbWwYtKdRRrW1M0gJD9knIVnQjg91bqLKu3QxuOTI=;
        b=IAn6ZmopsOTu/Y5EAnR86YCpZXRb/c+PnmaAm2ZHnSEN98GCRAfalp/r3sPtqrMTKD
         g96EnXHXgAHpRZKa5CGwIKYbaZLxbaABJLmRVov+iEzsBVMwykH9MrpBI2N2VWmTh5fT
         NTs79h4WKQR9x3lIYykd0RBWd3dUCKZRyQydCJB5UbDgdqpeyV1q+1Kg1VebdsG5ZpNA
         +EWtS6jt70ycAMMtR1Fbx3HVSoopF8H2D0ffEJNZo+rtX5IeJbcetkT5mtPXT1xE+76a
         xD8ZGLQPTV8bByf56rA81kqOJ8F2fa0FB7aZTYXppxq2X49qjRM71TR0MMcdJcgJQXb8
         lSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s5VbWwYtKdRRrW1M0gJD9knIVnQjg91bqLKu3QxuOTI=;
        b=taKLcPIlCliszIZLC+o8ZAP8f6gN5p8+rDCdtEvUsYRmsxukP8DnFqYE99zc6twMnv
         82MmqKYGf8YiWIR3DUE26Eb7X+13oMIUb58aWqSRsOjSZbu6I+Ax4rOxtVctypqTu7be
         8tWlUk5uLMGXTeigO0QvQ/BNH/SOCegsS13DVS8wCqAO//g1OAabRToIFOZ7KXQK9OQR
         OKFbw3WIgu/ZaP17awXDFd/doaJ2uShm1IeS+TgrXNJd0hjYivLXHP+5+WVjLEdtogSZ
         yjn+eQPSyleoLD7b2C4wVsEChiQ+lwnO8seSDzwfQ9EUIjb3h6UYqyoBE4enBmXt7cDP
         YWoA==
X-Gm-Message-State: AO0yUKXuWguFzxzr2b7nQE258pYy/WZg4FmXnK60dp8s9omHrQeLzl6t
        zsYiE/Wc9Byemmtyocx8A6Ch+LrQHYhw/2j8AcriVA==
X-Google-Smtp-Source: AK7set+J9AaIgMEkL7rnUCsb4CauI0IqTFVA3Am7RXF/e8QaGvCJR0b8fjFlRSfE4Z2c1HbPd9Sxzk+GP+CWjc8GC8c=
X-Received: by 2002:a81:4fcd:0:b0:52e:cd64:1b58 with SMTP id
 d196-20020a814fcd000000b0052ecd641b58mr264023ywb.346.1676479068346; Wed, 15
 Feb 2023 08:37:48 -0800 (PST)
MIME-Version: 1.0
References: <20230214134915.199004-1-jhs@mojatatu.com> <Y+uZ5LLX8HugO/5+@nanopsycho>
 <20230214134013.0ad390dd@kernel.org> <20230214134101.702e9cdf@kernel.org>
 <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
 <Y+yOsYSRSZV1kwpq@nanopsycho> <4bb0d7d2-1793-ef57-bebc-11b4867ac158@mojatatu.com>
In-Reply-To: <4bb0d7d2-1793-ef57-bebc-11b4867ac158@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 15 Feb 2023 11:37:37 -0500
Message-ID: <CAM0EoM=FseCqxJD1X5vJHw3PHHSJxGAaFvV4n6njCmPq2cxP6g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and classifiers
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        stephen@networkplumber.org, dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 8:42 AM Pedro Tammela <pctammela@mojatatu.com> wrote:
>
> On 15/02/2023 04:50, Jiri Pirko wrote:
> > Wed, Feb 15, 2023 at 12:05:23AM CET, jhs@mojatatu.com wrote:
> >> On Tue, Feb 14, 2023 at 4:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>>
> >>> On Tue, 14 Feb 2023 13:40:13 -0800 Jakub Kicinski wrote:
> >>>>> I think we have to let the UAPI there to rot in order not to break
> >>>>> compilation of apps that use those (no relation to iproute2).
> >>>>
> >>>> Yeah, I was hoping there's no other users but this is the first match
> >>>> on GitHub:
> >>>>
> >>>> https://github.com/t2mune/nield/blob/0c0848d1d1e6c006185465ee96aeb5a13a1589e6/src/tcmsg_qdisc_dsmark.c
> >>>>
> >>>> :(
> >>>
> >>> I mean that in the context of deleting the uAPI, not the support,
> >>> to be clear.
> >>
> >> Looking at that code - the user is keeping their own copy of the uapi
> >> and listening to generated events from the kernel.
> >> With new kernels those events will never come, so they wont be able to
> >> print them. IOW, there's no dependency on the uapi being in the kernel
> >> - but maybe worth keeping.
> >> Note, even if they were to send queries - they will just get a failure back.
> >
> > Guys. I don't think that matters. There might be some non-public code
> > using this headers and we don't want to break them either. I believe we
> > have to stick with it. But perhaps we can include some note there.
> >
>
> I don't know the compilation requirements for uapi, but it could
> leverage the deprecated attribute, when available as a compiler
> extension (it's queued for C23 as well[0]).
>
> E.g. https://godbolt.org/z/d535jh9j8
>
> Essentially anytime someone uses one of the Netlink attributes they will
> get a harmless warning like:
> <source>:22:18: warning: 'TCA_TCINDEX_CLASSID' is deprecated
> [-Wdeprecated-declarations]
>
> [0] https://en.cppreference.com/w/c/language/attributes/deprecated

That would work well actually. So iproute2 pulling these headers from
the kernel will get warned.
I think the outstanding question is still: How long do we keep the
headers around?

cheers,
jamal
