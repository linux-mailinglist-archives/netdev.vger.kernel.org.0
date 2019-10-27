Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C128FE6564
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfJ0Uow convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 27 Oct 2019 16:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfJ0Uov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:44:51 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 209E5C057E9A
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 20:44:51 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id p14so1516552ljh.22
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=lDf35OnNc+dEfs3ni1XROGJ1OMpq3fUAusJfOdXq7w4=;
        b=t8j9rmyuwtV73dbHAs5o7nSqgYJT8Z62WPeov+ZglC3JDhtQcVIkf0jed5akTSOcEF
         fCeytzLC97SvA59gKxGpcFdom9vZFQ+jHP8oUU3NpFqdnmyvpgPrwasOJgEQoVGFumVL
         cS27wMBy0/5e32qkR+xeO0n7BRCelPklAIw0RHU3pjCHC43pUTvYCLmzJXjcLQH7NbsM
         41caJINhKElfXr68p+AyjhXyhjBIggB+ti9k3d2jyva75GXUC0wkJcIsQYWgeZXryBbn
         53FKSk9qGSOTF6sRT4CrqiQDm7772K1vlnbhtWrJKLz+m8DIPQTURLQLcFNz0bA90izY
         OuMg==
X-Gm-Message-State: APjAAAVSXLFYMyNlqaml2tI50qSPJHs/QPEai/mQgPuaM1bp206GCwmS
        LpU9QAImrsIEjC+4yzEU1R58BgVFhw0nfZPT25YcHjxcnC5Q2kFkn7aTg98UIG7981KGDBuky1o
        uIyMNtiPuBx0bq2jO
X-Received: by 2002:a05:6512:514:: with SMTP id o20mr2968337lfb.3.1572209089594;
        Sun, 27 Oct 2019 13:44:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqySe82Er/XZuksyKluWTS+TQwcbx9yPhOV2cIeCPAE9R+DRNGUPDOC4O7hhLuSIJINXDCCmrg==
X-Received: by 2002:a05:6512:514:: with SMTP id o20mr2968320lfb.3.1572209089237;
        Sun, 27 Oct 2019 13:44:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 12sm4175969lju.55.2019.10.27.13.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 13:44:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5A0811818B6; Sun, 27 Oct 2019 21:44:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Add option to auto-pin maps when opening BPF object
In-Reply-To: <CAEf4Bzbn-wFJdhn5DCss8J4d7HNpHjUTrGKQqppv+ykjVAqMCA@mail.gmail.com>
References: <157192269744.234778.11792009511322809519.stgit@toke.dk> <157192270189.234778.14607584397750494265.stgit@toke.dk> <CAEf4BzbBmm3GfytbEtHwoD71p2XfuxuSYjhbb7rqPwUaYqvk7g@mail.gmail.com> <87pniijsx8.fsf@toke.dk> <CAEf4Bzbn-wFJdhn5DCss8J4d7HNpHjUTrGKQqppv+ykjVAqMCA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 27 Oct 2019 21:44:47 +0100
Message-ID: <87tv7tsytc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sun, Oct 27, 2019 at 5:04 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Thu, Oct 24, 2019 at 6:11 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >>
>> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >>
>> >> With the functions added in previous commits that can automatically pin
>> >> maps based on their 'pinning' setting, we can support auto-pinning of maps
>> >> by the simple setting of an option to bpf_object__open.
>> >>
>> >> Since auto-pinning only does something if any maps actually have a
>> >> 'pinning' BTF attribute set, we default the new option to enabled, on the
>> >> assumption that seamless pinning is what most callers want.
>> >>
>> >> When a map has a pin_path set at load time, libbpf will compare the map
>> >> pinned at that location (if any), and if the attributes match, will re-use
>> >> that map instead of creating a new one. If no existing map is found, the
>> >> newly created map will instead be pinned at the location.
>> >>
>> >> Programs wanting to customise the pinning can override the pinning paths
>> >> using bpf_map__set_pin_path() before calling bpf_object__load().
>> >>
>> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> ---
>> >
>> > How have you tested this? From reading the code, all the maps will be
>> > pinned irregardless of their .pinning setting?
>>
>> No, build_pin_path() checks map->pinning :)
>
> subtle... build_pin_path() definitely doesn't imply that it's a "maybe
> build pin path?", but see below for pin_path setting.
>
>>
>> > Please add proper tests to test_progs, testing various modes and
>> > overrides.
>>
>> Can do.
>>
>> > You keep trying to add more and more knobs :) Please stop doing that,
>> > even if we have a good mechanism for extensibility, it doesn't mean we
>> > need to increase a proliferation of options.
>>
>> But I like options! ;)
>>
>> > Each option has to be tested. In current version of your patches, you
>> > have something like 4 or 5 different knobs, do you really want to
>> > write tests testing each of them? ;)
>>
>> Heh, I guess I can cut down the number of options to the number of tests :P
>>
>> > Another high-level feedback. I think having separate passes over all
>> > maps (build_map_pin_paths, reuse, then we already have create_maps) is
>> > actually making everything more verbose and harder to extend. I'm
>> > thinking about all these as sub-steps of map creation. Can you please
>> > try refactoring so all these steps are happening per each map in one
>> > place: if map needs to be pinned, check if it can be reused, if not -
>> > create it. This actually will allow to handle races better, because
>> > you will be able to retry easily, while if it's all spread in
>> > independent passes, it becomes much harder. Please consider that.
>>
>> We'll need at least two passes: set pin_path on open, and check reuse /
>> create / pin on load. Don't have any objections to consolidating the
>> other passes into create_maps; will fix, along with your comments below.
>
> for BTF-defined maps, can't we just set a pin_path right when we are
> reading map definition? With that, we won't even need to store
> .pinning field. Would that work?

We could, and I did actually try that. However, I think it is more
readable to have it be a separate step: init_user_btf_maps() parses the
map def, and after that is done we loop over things to build the pin
paths.

I'll send a v3 in a bit, you can see for yourself :)

-Toke
