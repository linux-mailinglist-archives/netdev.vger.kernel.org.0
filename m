Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A500B4B3E74
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 00:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiBMXsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 18:48:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiBMXsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 18:48:02 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1882B517FA
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 15:47:56 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id n14so8090325vkk.6
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 15:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMdB3u4ROFjRzsgy8InNHKRZxlZErZVsvxCE4drDBvw=;
        b=X3PfDIJvVXebofdph2ZD3VQJMeUX1ykJemsv0iNmBrPz4AEEdaM9CCvImZ9pmGhcNA
         HB+hLVVIWefdZ33F+ZF7RfF5BmJD1+HnKoiw+F9iimTWsaNiPTG6TsD8taFsOIK7qYCC
         kMr0tG9f7bPdLG0/yGfsuFerrnMSke8xPuDpygrYhb/5/QOoEaQAVoANMT7+J5YdCBk8
         gJUImySEMdSIDketVThCG76st9mRekoA9zp4P6iA38AzeWWF6J6ROAyhgrm8Y45GgR0j
         XU5mI5ceQF5UBZlay5+jXU2PounuaCWbUdFQQNfvm7WIlfLpkGs47LAUR89ogGXjBoCk
         aa4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMdB3u4ROFjRzsgy8InNHKRZxlZErZVsvxCE4drDBvw=;
        b=oGHgN/ZIxtFpV9UXgzRyxENFbrToVLFSQgmOfuBN+48h2/lCC+LavA05b2vu0uQDPo
         PqzRD4JmvPLdfvkT8Z68st0enHHUM1UjDsU5FmUQxJbBn7WD9MxqWbibs+2EzzSnAaCc
         VMMYM8mg4OkPK+LuXNUvl8vR6hxyWlr14eKEZB9WeOMxFdT7gwJQZaZVM+hqdWAHmvrR
         xarG4Zmn3EAUan4h1Q1Uwhk2JeEYDdzWu/V2X8IzoNg30j4BQfo9kRO0CGReo2wA2x5b
         ROAAl5kiCY4A5qr5lSlnxGdpsj9wIPVEobIhv/zt4NVdLGlSsuFqlKk8VUF0WkFfURz5
         BPMg==
X-Gm-Message-State: AOAM530WNjb7E4ZP/Mllq/xF3lqbkE/M8Lr8722zLaCTl39l/9qxpmHL
        CoN8QSzNAGyHkoBf+HfIRHemRTd+tnc=
X-Google-Smtp-Source: ABdhPJzByA22qV6ftTzTHjzCX0FLyUymKzSFG2cnOYpAcoVXfiw1RzKOBjXbHZtbBY08EBQdY2jwOw==
X-Received: by 2002:a1f:ac58:: with SMTP id v85mr3143595vke.29.1644796075118;
        Sun, 13 Feb 2022 15:47:55 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id q6sm5311258vkd.50.2022.02.13.15.47.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 15:47:54 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id j20so3026679vsg.5
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 15:47:54 -0800 (PST)
X-Received: by 2002:a67:ec43:: with SMTP id z3mr2991082vso.79.1644796074333;
 Sun, 13 Feb 2022 15:47:54 -0800 (PST)
MIME-Version: 1.0
References: <MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com>
 <CA+FuTSeY-GNfBCppjRwhWrOnUg9JDOaesjby2+QbuvPOO5g-=Q@mail.gmail.com>
In-Reply-To: <CA+FuTSeY-GNfBCppjRwhWrOnUg9JDOaesjby2+QbuvPOO5g-=Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Feb 2022 18:47:18 -0500
X-Gmail-Original-Message-ID: <CA+FuTScRGQV5ePxbu7LReuAUc_AU3sQd7Mb8KGVmu+X2jSQSCQ@mail.gmail.com>
Message-ID: <CA+FuTScRGQV5ePxbu7LReuAUc_AU3sQd7Mb8KGVmu+X2jSQSCQ@mail.gmail.com>
Subject: Re: BUG: potential net namespace bug in IPv6 flow label management
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Liu, Congyu" <liu3101@purdue.edu>,
        "security@kernel.org" <security@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 11:10 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Feb 13, 2022 at 5:31 AM Liu, Congyu <liu3101@purdue.edu> wrote:
> >
> >
> > Hi,
> >
> > In the test conducted on namespace, I found that one unsuccessful IPv6 flow label
> > management from one net ns could stop other net ns's data transmission that requests
> > flow label for a short time. Specifically, in our test case, one unsuccessful
> > `setsockopt` to get flow label will affect other net ns's `sendmsg` with flow label
> > set in cmsg. Simple PoC is included for verification. The behavior descirbed above
> > can be reproduced in latest kernel.
> >
> > I managed to figure out the data flow behind this: when asking to get a flow label,
> > some `setsockopt` parameters can trigger function `ipv6_flowlabel_get` to call `fl_create`
> > to allocate an exclusive flow label, then call `fl_release` to release it before returning
> > -ENOENT. Global variable `ipv6_flowlabel_exclusive`, a rate limit jump label that keeps
> > track of number of alive exclusive flow labels, will get increased instantly after calling
> > `fl_create`. Due to its rate limit design, `ipv6_flowlabel_exclusive` can only decrease
> > sometime later after calling `fl_decrease`. During this period, if data transmission function
> > in other net ns (e.g. `udpv6_sendmsg`) calls `fl_lookup`, the false `ipv6_flowlabel_exclusive`
> > will invoke the `__fl_lookup`. In the test case observed, this function returns error and
> > eventually stops the data transmission.
> >
> > I further noticed that this bug could somehow be vulnerable: if `setsockopt` is called
> > continuously, then `sendmmsg` call from other net ns will be blocked forever. Using the PoC
> > provided, if attack and victim programs are running simutaneously, victim program cannot transmit
> > data; when running without attack program, the victim program can transmit data normally.
>
> Thanks for the clear explanation.
>
> Being able to use flowlabels without explicitly registering them
> through a setsockopt is a fast path optimization introduced in commit
> 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases
> exist").
>
> Before this, any use of flowlabels required registering them, whether
> the use was exclusive or not. As autoflowlabels already skipped this
> stateful action, the commit extended this fast path to all non-exclusive
> use. But if any exclusive flowlabel is active, to protect it, all
> other flowlabel use has to be registered too.
>
> The commit message does state
>
>     This is an optimization. Robust applications still have to revert to
>     requesting leases if the fast path fails due to an exclusive lease.
>
> Though I can see how the changed behavior has changed the perception of the API.
>
> That this extends up to a second after release of the last exclusive
> flowlabel due to deferred release is only tangential to the issue?
>
> Flowlabels are stored globally, but associated with a netns
> (fl->fl_net). Perhaps we can add a per-netns check to the
> static_branch and maintain stateless behavior in other netns, even if
> some netns maintain exclusive leases.

The specific issue could be avoided by moving

       if (fl_shared_exclusive(fl) || fl->opt)
               static_branch_deferred_inc(&ipv6_flowlabel_exclusive);

until later in ipv6_flowlabel_get, after the ENOENT response.

But reserving a flowlabel is not a privileged operation, including for
exclusive use. So the attack program can just be revised to pass
IPV6_FL_F_CREATE and hold a real reservation. Then it also does
not have to retry in a loop.

The drop behavior is fully under control of the victim. If it reserves
the flowlabel it intends to use, then the issue does not occur. For
this reason I don't see this as a vulnerability.

But the behavior is non-obvious and it is preferable to isolate netns
from each other. I'm looking into whether we can add a per-netns
"has exclusive leases" check.
