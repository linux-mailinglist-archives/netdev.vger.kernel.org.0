Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688FC2D2A23
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLHMAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:00:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbgLHMA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:00:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607428743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X3UiVLhoBn0QxGbQIaE3lfbb23sxxLlKxWSYI9eyG3I=;
        b=WI0tPlPpwQqVLAG1ZBN3eMt5E6lU49km6u++zpqh1VIzPUiU9EFsVXf2WRNWkn9LRGU/+P
        KlLofhl07B12uJHJOTfybovumPx6yI15/raw7QqnIdrdWm6yQLytc4DsiKXPCZDNmqcF7s
        8Sk0zQJyRx8251QEKuEVuTVRb3sWzKM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-2C89UgkSNlio9m1yyKLWJw-1; Tue, 08 Dec 2020 06:59:00 -0500
X-MC-Unique: 2C89UgkSNlio9m1yyKLWJw-1
Received: by mail-wr1-f72.google.com with SMTP id p18so6010238wro.9
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 03:58:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X3UiVLhoBn0QxGbQIaE3lfbb23sxxLlKxWSYI9eyG3I=;
        b=PDyxtcAYoMknIRYFvcFZfvQYiZG1JuaK5RYLwkS9sOAgQ+Jh/XkFxwnVr4UnbMTqzX
         Tu9Ug9f04uMQhXdz4PLMRRLDif/tI6I6XqVjlEodxIUNNmGTlFjYYSAn44pC/26W5MD9
         rjr4d68QayJvO+Rrh7N6wFVC+rYGo7rGg9kIcwcut2zusGAFTTtVJ/BvVWppbleWBi1U
         GKGYHeARd3+QD98hu6M1kPp5CayJg8KAqLNr+xy44rKL2cEj21EDZ+qYS9iSUIhrN0ux
         B3VCzrKgXCc8aX6nzn5ZMdA2L3p9E5d6EQIbJ3Bk8OzeLFdzT4jXGQwD0YL26UV2UNk8
         17yg==
X-Gm-Message-State: AOAM533RyzCZuPs8msKkHVUjbBSB4HmAXtmIdD/da3KcQe0VpPXJWCL/
        wznSMorQMComovGMlpcoXbpbbi1xkQreAFVaOG08qu8UQCOpBvsJUyvU0YfaenkZqRGYbU5exWA
        rr61Ahg3JSYFpf+/h
X-Received: by 2002:a7b:c145:: with SMTP id z5mr3532626wmi.164.1607428738543;
        Tue, 08 Dec 2020 03:58:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztnhlMopB/tBeUjOLv6knn4JP4rwNtEk3g6zzAXTDTjNarHkAPjHiVgYn2NYy0BbdBqs0ZzA==
X-Received: by 2002:a7b:c145:: with SMTP id z5mr3532576wmi.164.1607428737875;
        Tue, 08 Dec 2020 03:58:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 94sm11113339wrq.22.2020.12.08.03.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 03:58:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E42118060F; Tue,  8 Dec 2020 12:58:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        David Ahern <dsahern@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
In-Reply-To: <20201208092803.05b27db3@carbon>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk> <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <431a53bd-25d7-8535-86e1-aa15bf94e6c3@gmail.com>
 <20201208092803.05b27db3@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Dec 2020 12:58:55 +0100
Message-ID: <87lfe8ik5c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <jbrouer@redhat.com> writes:

> On Mon, 7 Dec 2020 18:01:00 -0700
> David Ahern <dsahern@gmail.com> wrote:
>
>> On 12/7/20 1:52 PM, John Fastabend wrote:
>> >>
>> >> I think we need to keep XDP_TX action separate, because I think that
>> >> there are use-cases where the we want to disable XDP_TX due to end-user
>> >> policy or hardware limitations.  
>> > 
>> > How about we discover this at load time though. 
>
> Nitpick at XDP "attach" time. The general disconnect between BPF and
> XDP is that BPF can verify at "load" time (as kernel knows what it
> support) while XDP can have different support/features per driver, and
> cannot do this until attachment time. (See later issue with tail calls).
> (All other BPF-hooks don't have this issue)
>
>> > Meaning if the program
>> > doesn't use XDP_TX then the hardware can skip resource allocations for
>> > it. I think we could have verifier or extra pass discover the use of
>> > XDP_TX and then pass a bit down to driver to enable/disable TX caps.
>> >   
>> 
>> This was discussed in the context of virtio_net some months back - it is
>> hard to impossible to know a program will not return XDP_TX (e.g., value
>> comes from a map).
>
> It is hard, and sometimes not possible.  For maps the workaround is
> that BPF-programmer adds a bound check on values from the map. If not
> doing that the verifier have to assume all possible return codes are
> used by BPF-prog.
>
> The real nemesis is program tail calls, that can be added dynamically
> after the XDP program is attached.  It is at attachment time that
> changing the NIC resources is possible.  So, for program tail calls the
> verifier have to assume all possible return codes are used by BPF-prog.

We actually had someone working on a scheme for how to express this for
programs some months ago, but unfortunately that stalled out (Jesper
already knows this, but FYI to the rest of you). In any case, I view
this as a "next step". Just exposing the feature bits to userspace will
help users today, and as a side effect, this also makes drivers declare
what they support, which we can then incorporate into the core code to,
e.g., reject attachment of programs that won't work anyway. But let's
do this in increments and not make the perfect the enemy of the good
here.

> BPF now have function calls and function replace right(?)  How does
> this affect this detection of possible return codes?

It does have the same issue as tail calls, in that the return code of
the function being replaced can obviously change. However, the verifier
knows the target of a replace, so it can propagate any constraints put
upon the caller if we implement it that way.

-Toke

