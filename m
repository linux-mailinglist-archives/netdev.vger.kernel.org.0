Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2EB1DF01F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgEVTlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgEVTlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:41:16 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00231C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 12:41:15 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id d7so9106255ote.6
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9ObJ8QwqXruga0MOShtora2MWAN1lSnLSZ4b8PI1Yo=;
        b=K4tbr2ou/f64TqneAxiA4BSLlIxaEpO75GvESj9OkVeMhX82QurhjkfoTfZjjLMzkP
         Ky81xMQrWO99hSZVJjaElzKZP6F9vRRUp8IFzhxl/xO9MMs/eeKOZRKYS6JI0NDFyyql
         Ky/l2xaBm46WOM2qopHRYteA8zsCqrVC2sJVs2Dm6OHh5YYyeeHuSplEx3jYJVbiDYSc
         MC6xlfXmxaMm8CbEm5189HWdraJZWoOVJt/PguP79jrugg+xP7f2ZqugGvwY9BaCRb3T
         8W2rkuGCJx+p+bmZZEx+hobOir/+f2yQLGIhGKYqE3RIshK3z2b5O/6goMnnRjm4ED5z
         KxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9ObJ8QwqXruga0MOShtora2MWAN1lSnLSZ4b8PI1Yo=;
        b=NfCzfpXnNKkP3HoH++UFIXwaVdm614D//jyVdC69L0yNLG70f936wg+ZgcOWfkHzNk
         mKWWCVcWnH73Y903/PoSe9S8WkoXZKuId/uPCptVg9xiOEGHKuSZ0uWBmaCWP7WTLYE1
         Zn3S2V6bX5yf2S6UNJebrLINuagIIDzzxCQXbZaZTtoqEut0Z3eZolH1dj5l9ms6QIbl
         jYa36MYwNBlPrJ/54Q8Rpfu3VSde2flAVE6GrAljT79VBV0tS3EqAMRpbZQ8Jn63G6wh
         XylA71vVS2meI9lQyU6WlrGJCkjNlEiRUfzvkA/PcKZq8u2UIDth9p63zlrxV86JJVFH
         G2vw==
X-Gm-Message-State: AOAM531XQK0pPjdFXy2oiuwEnzP0mQlx5VmQrYLGw+WNaW2+6zu+jHgj
        BuatfwLMOUf93lun9si2YrAgjMQwlriSeDHwU3cP+Egf
X-Google-Smtp-Source: ABdhPJy5Kan1mEuSgaqltLgTsnCE0XU+Rfacrryiez6e5ARMSvHFCFpdvKqo4/m3rHWHmIn5/CTVwFCu3cUz8nSsm2Q=
X-Received: by 2002:a9d:64d3:: with SMTP id n19mr11768276otl.189.1590176475252;
 Fri, 22 May 2020 12:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
 <vbf1rndz76r.fsf@mellanox.com>
In-Reply-To: <vbf1rndz76r.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 22 May 2020 12:41:04 -0700
Message-ID: <CAM_iQpVB64www8pArKpUhKKSkNapZU1p0n7Tgg3E8SR0PCgKfQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 7:36 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
> Hi Edward, Cong,
>
> On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
> > On 15/05/2020 12:40, Vlad Buslov wrote:
> >> In order to
> >> significantly improve filter dump rate this patch sets implement new
> >> mode of TC filter dump operation named "terse dump" mode. In this mode
> >> only parameters necessary to identify the filter (handle, action cookie,
> >> etc.) and data that can change during filter lifecycle (filter flags,
> >> action stats, etc.) are preserved in dump output while everything else
> >> is omitted.
> > I realise I'm a bit late, but isn't this the kind of policy that shouldn't
> >  be hard-coded in the kernel?  I.e. if next year it turns out that some
> >  user needs one parameter that's been omitted here, but not the whole dump,
> >  are they going to want to add another mode to the uapi?
> > Should this not instead have been done as a set of flags to specify which
> >  pieces of information the caller wanted in the dump, rather than a mode
> >  flag selecting a pre-defined set?
> >
> > -ed
>
> I've been thinking some more about this. While the idea of making
> fine-grained dump where user controls exact contents field-by-field is
> unfeasible due to performance considerations, we can try to come up with
> something more coarse-grained but not fully hardcoded (like current terse
> dump implementation). Something like having a set of flags that allows
> to skip output of groups of attributes.
>
> For example, CLS_SKIP_KEY flag would skip the whole expensive classifier
> key dump without having to go through all 200 lines of conditionals in
> fl_dump_key() while ACT_SKIP_OPTIONS would skip outputting TCA_OPTIONS
> compound attribute (and expensive call to tc_action_ops->dump()). This
> approach would also leave the door open for further more fine-grained
> flags, if the need arises. For example, new flags
> CLS_SKIP_KEY_{L2,L3,L4} can be introduced to more precisely control
> which parts of cls key should be skipped.
>
> The main drawback of such approach is that it is impossible to come up
> with universal set of flags that would be applicable for all
> classifiers. Key (in some form) is applicable to most classifiers, but
> it still doesn't make sense for matchall or bpf. Some classifiers have
> 'flags', some don't. Hardware-offloaded classifiers have in_hw_count.
> Considering this, initial set of flags will be somewhat flower-centric.
>
> What do you think?

This looks like a reverse filtering to me, so essentially the same.
Please give me some time to think about this, it is definitely not
easy.

The only thing I worry is that once you add terse dump, we cannot
simply remove it any more. (Otherwise I wouldn't even want to push
you on this.)

Thanks.
