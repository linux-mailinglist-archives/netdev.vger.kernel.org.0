Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4FA1A25A4
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgDHPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:40:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728795AbgDHPkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586360417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BwE0KT9Q2rjk3YzYy8UNLeZQzIQlzHOMHy1Y/W1+zY=;
        b=HQKfuCAks8YzRv8z5r9YWqfyFDd7kRX5SXM10luHHrDE6xcKWEzisLZy4JgI9qQcB3UftB
        VmHKTaiYiULORhiHPQkK9YCpGThzmy4HjE4ydlfC+ywUUZNSpZ9AR8cH1DJ0hEBMENWStI
        Z28iJ0uzoz1ecOgW7s2gYEL52HcfqVw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-d8cE3TukMC6Obpd5ri3GIw-1; Wed, 08 Apr 2020 11:40:16 -0400
X-MC-Unique: d8cE3TukMC6Obpd5ri3GIw-1
Received: by mail-lf1-f70.google.com with SMTP id h12so198155lfk.22
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 08:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2BwE0KT9Q2rjk3YzYy8UNLeZQzIQlzHOMHy1Y/W1+zY=;
        b=Z1lyXYwX6YykuEx2HmoQjmNnzUSlmwvCf074tWtKubSmvFHRasL+Ofq4lJIOj/0yXx
         LVhQ3JWkul8/uPqqnZW4CHMxWZ7jGY4X0t+DoGq+6b5VvoFOte5VRPiy24q7r0IQqcMD
         uX2WJUOxVW512uQtnuPpT17EMFfOKv51cHJZmS5KSKOaiEUFbuO6NwQm1mCscPUUaWok
         VyTYxR2jZX314R4Ia/E/4yPOdxk8qsgSp+QOyRhPoHvVL3bMVX5m2MlISXTJsvUVoWMT
         rllOx3T3vW9qKCgaXKnDgV7kFsJUtKqXUoYX9o6e9yJohncMnrjKZl7qrGps+ezh9VM9
         6J/A==
X-Gm-Message-State: AGi0PubgL+xjML7Udd5Hhdmvlq/7mQM7LGdAvUJMvFNdKrAo9WQofMqe
        gk0Cf1ky5eV/E8H0FXkLfS9cmBbV3mLGffW/XgBHixW9S4exgpSaKX3BXNu/vuzwQAKLxvinYtR
        W5yUE7CVPOpGUsRW7
X-Received: by 2002:a2e:6e0f:: with SMTP id j15mr5068830ljc.230.1586360414545;
        Wed, 08 Apr 2020 08:40:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypJJroi0n/uGtuc5zx+HA3W8TuAIaZQ1OKcxjc72XIm15CyQetrXx4jphld/jAxjiY+IP3QybA==
X-Received: by 2002:a2e:b8c1:: with SMTP id s1mr5538800ljp.0.1586358872084;
        Wed, 08 Apr 2020 08:14:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c22sm13660442lja.86.2020.04.08.08.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:14:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 755431804E7; Wed,  8 Apr 2020 17:14:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
In-Reply-To: <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com>
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com> <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 08 Apr 2020 17:14:27 +0200
Message-ID: <877dyq80x8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Apr 6, 2020 at 4:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > Add support to look up bpf_link by ID and iterate over all existing bp=
f_links
>> > in the system. GET_FD_BY_ID code handles not-yet-ready bpf_link by che=
cking
>> > that its ID hasn't been set to non-zero value yet. Setting bpf_link's =
ID is
>> > done as the very last step in finalizing bpf_link, together with insta=
lling
>> > FD. This approach allows users of bpf_link in kernel code to not worry=
 about
>> > races between user-space and kernel code that hasn't finished attachin=
g and
>> > initializing bpf_link.
>> >
>> > Further, it's critical that BPF_LINK_GET_FD_BY_ID only ever allows to =
create
>> > bpf_link FD that's O_RDONLY. This is to protect processes owning bpf_l=
ink and
>> > thus allowed to perform modifications on them (like LINK_UPDATE), from=
 other
>> > processes that got bpf_link ID from GET_NEXT_ID API. In the latter cas=
e, only
>> > querying bpf_link information (implemented later in the series) will be
>> > allowed.
>>
>> I must admit I remain sceptical about this model of restricting access
>> without any of the regular override mechanisms (for instance, enforcing
>> read-only mode regardless of CAP_DAC_OVERRIDE in this series). Since you
>> keep saying there would be 'some' override mechanism, I think it would
>> be helpful if you could just include that so we can see the full
>> mechanism in context.
>
> I wasn't aware of CAP_DAC_OVERRIDE, thanks for bringing this up.
>
> One way to go about this is to allow creating writable bpf_link for
> GET_FD_BY_ID if CAP_DAC_OVERRIDE is set. Then we can allow LINK_DETACH
> operation on writable links, same as we do with LINK_UPDATE here.
> LINK_DETACH will do the same as cgroup bpf_link auto-detachment on
> cgroup dying: it will detach bpf_link, but will leave it alive until
> last FD is closed.

Yup, I think this would be a reasonable way to implement the override
mechanism - it would ensure 'full root' users (like a root shell) can
remove attachments, while still preventing applications from doing so by
limiting their capabilities.

Extending on the concept of RO/RW bpf_link attachments, maybe it should
even be possible for an application to choose which mode it wants to pin
its fd in? With the same capability being able to override it of
course...

> We need to consider, though, if CAP_DAC_OVERRIDE is something that can
> be disabled for majority of real-life applications to prevent them
> from doing this. If every realistic application has/needs
> CAP_DAC_OVERRIDE, then that's essentially just saying that anyone can
> get writable bpf_link and do anything with it.

I poked around a bit, and looking at the sandboxing configurations
shipped with various daemons in their systemd unit files, it appears
that the main case where daemons are granted CAP_DAC_OVERRIDE is if they
have to be able to read /etc/shadow (which is installed as chmod 0). If
this is really the case, that would indicate it's not a widely needed
capability; but I wouldn't exactly say that I've done a comprehensive
survey, so probably a good idea for you to check your users as well :)

-Toke

