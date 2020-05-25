Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582E21E0963
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbgEYIyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:54:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21959 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388375AbgEYIyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590396845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8odSAtExjHVb0V8pWsu7iIovweKekeCsY5xpR2JkHNw=;
        b=WikjVrWLHoXKtswBhfmdDW3esgGwoHurqqxogKMauyUuquilq6laOmfkgpx57RT18UJ8tD
        +dEz16cN10b1RVB/VEeHtqAhiaw5nsjCbyW4VFH5yLdC6Fv8diGwKPuX34ANR+rQS7FZmN
        8Y5c/cD0icC/UKUYixTxDUaUnw3aIy8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-a101bhVdMq6463rMJGfPeg-1; Mon, 25 May 2020 04:54:03 -0400
X-MC-Unique: a101bhVdMq6463rMJGfPeg-1
Received: by mail-ej1-f69.google.com with SMTP id f17so6199430ejc.7
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 01:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8odSAtExjHVb0V8pWsu7iIovweKekeCsY5xpR2JkHNw=;
        b=DTLLRnJutTs/VzLhgxWSGjBnsc7yVRcQ5NjGrsdbd8JFhOvr3ruT84W6jFMQNcC7S0
         izQ3LBvcq6x153ac0xmO8coC3h1lYGAGd07spsL06vuUXFuY2wv/ZXPxtqvEZDlzcSpN
         bOd/rlVxkkUhvch/Jpn4h7yeyhdYxLxz+Cg1rRJ1aJewx1t7oeV+wtlGw3ig3yUEF4c0
         V7mSXS2BBYplSkEwZPDg5uzY54LD/o4BuhiN6DRRsEYIZauKpNqbEwhC7K05XLty0o0Y
         Ruxlspbddvam5TMYr0m7hDq11DLHY8BPRcATJ01H8yO8zjZycHHVUU3XMDzTd6D8KJvM
         JuZA==
X-Gm-Message-State: AOAM532vfb58N2yn0gSMF0KE2J9zY9Zc3AmM544psfDOu64aUTq4T24w
        ntptwltOaXqH5PjR/61ydt9ucGYmIhWPhi3Yqm5KONMRahGZYKfY3nI3V8909L1DNhCfFsS+Yt1
        TG7aypdl0DDe4h9M0PyRCPdX/k3ua3J//
X-Received: by 2002:aa7:c6c6:: with SMTP id b6mr13945264eds.53.1590396842146;
        Mon, 25 May 2020 01:54:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLQ8FOzIxHSatRx5ks9Ub0gLWWugFErJWNSo0KqFbEJsaBcqc9G7e4sysm4Rv+WNEOL+Mq0R3+E9T9FT7Bjec=
X-Received: by 2002:aa7:c6c6:: with SMTP id b6mr13945255eds.53.1590396841967;
 Mon, 25 May 2020 01:54:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200423175857.20180-1-jhs@emojatatu.com> <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
 <1d1e025b-346b-d5f7-6c44-da5a64f31a2c@mojatatu.com> <e192690f-ad1a-14c1-8052-e1a3fc0a1b8f@iogearbox.net>
 <f18653bd-f9a2-8a87-49a5-f682038a8477@mojatatu.com>
In-Reply-To: <f18653bd-f9a2-8a87-49a5-f682038a8477@mojatatu.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Mon, 25 May 2020 10:53:50 +0200
Message-ID: <CAPpH65zTiy-9WxoK=JzUj2eR8pNu8Mf4xqMmmHtjVVfwTSgydA@mail.gmail.com>
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, asmadeus@codewreck.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 12:32 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-05-22 9:33 p.m., Daniel Borkmann wrote:
> > On 5/18/20 3:00 PM, Jamal Hadi Salim wrote:
> >> ping?
> >>
> >> Note: these are trivial bug fixes.
> >
> > Looking at c0325b06382c ("bpf: replace snprintf with asprintf when
> > dealing with long buffers"),
> > I wonder whether it's best to just revert and redo cleanly from
> > scratch.. How much testing has
> > been performed on the original patch? We know it is causing regressions,
> > and looking Jamal's
> > 2nd patch we do have patterns all over the place wrt error path that go
> > like:
>
> Reverting c0325b06382c would work as well..
>
> Note: I believe Andrea's original goal was to just get rid of a
> compiler warning from sprintf(). Stephen suggested to use
> asprintf. Andrea's original solution to get rid of the compiler
> warning would suffice. Maybe then an additional code audit to
> ensure consistency on usage of s[n]printf could be done and
> resolved separately.
>

Reverting c0325b06382c will for sure fix the segfault identified by
Jamal and get rid of the problems highlighted by Daniel and others.
To fix the s[n]printf truncation warning we can simply check for its
return value. From the snprintf man page:

"a return value of size or more means that the output was truncated."
(caveat: until glibc 2.0.6 ret value for truncation is -1)

Jamal: if this works for you, I can submit an alternative to this
patch series doing what I proposed above. What do you think?

Regards,
Andrea

> Thanks for taking the time Daniel.
>
> cheers,
> jamal
>

