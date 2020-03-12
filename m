Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327A318375F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgCLRZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:25:30 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44957 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgCLRZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:25:30 -0400
Received: by mail-lj1-f194.google.com with SMTP id a10so7338661ljp.11
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 10:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=92SOxOC18i6ds6Akqzym0x0waRhKEJcWlmWFOz79/NM=;
        b=Vm/UODNL1cCp1DeobygEV9oz8iCVKwLZxSNuJX1LYHir8AsXsgIt1GFxZj6efgX1KH
         zBIilnMxYQxGT4rO9xEBZgbcWuyHLN98wgUo6fMW+01WyQBBtXB8KE9f14eJ1pwVtiEr
         zk+yg59VxyrI4XOmkKstZz7Fj0xs3r6IYSRl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=92SOxOC18i6ds6Akqzym0x0waRhKEJcWlmWFOz79/NM=;
        b=Rt0mUoMfson9JpqAtzWb5WajiY0EjGVPZNTm9qZO041WFhksKEst1OHO399S9k27K/
         6YBymH2LjNNPR47YLItxxG/TMwUytfjJViTFy7hvvB8k/ZnA2rQvQXH/LcYrXlpOZmxk
         7MD4vI5qhgbchrFIm6SOlz0VyLWN6FVXBbm/x0NiYe6MWdp6hjzQuj5ZYvu1sifYEfGR
         9639tzBMr2SVjeYAYjfBGRidXc0VtgdMGdUsGhZ6X5GzYgqual516B4UIzCM58gvQaHy
         iM0+zRMbITLjlxBoYKXvzDgK7i3bjJSJyrhz+95UYXlBROTOVGEIV+9ZTHkAa3HxJ/ax
         cbOQ==
X-Gm-Message-State: ANhLgQ0VF/q/H/E4pLgrzjD9veId7J6GUqWj1oiz7Nqb8AxGtbZ3bv1K
        wF8xeC4P7ImCwc26pmNGQdppsA==
X-Google-Smtp-Source: ADFU+vsNa6bA4DzWs4h9nx8AQPFFT5q3yyz8zsYF5Bb8Zn23qLnts4kjceprPYz7W8oTKbXw3jX4rg==
X-Received: by 2002:a05:651c:204:: with SMTP id y4mr5518757ljn.280.1584033926831;
        Thu, 12 Mar 2020 10:25:26 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 2sm15198060lfy.8.2020.03.12.10.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 10:25:25 -0700 (PDT)
References: <20200127125534.137492-1-jakub@cloudflare.com> <20200127125534.137492-13-jakub@cloudflare.com> <CAEf4Bzadh2T43bYbLO0EuKceUKr3SkfXK8Tj_fXFNj8BWtot1Q@mail.gmail.com> <87sgiey8mc.fsf@cloudflare.com> <CAEf4BzbSrnwq7ZC1j5YrqdJGO9bhgw=gpBmuTNP1UQFnDKABgA@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v5 12/12] selftests/bpf: Tests for SOCKMAP holding listening sockets
In-reply-to: <CAEf4BzbSrnwq7ZC1j5YrqdJGO9bhgw=gpBmuTNP1UQFnDKABgA@mail.gmail.com>
Date:   Thu, 12 Mar 2020 18:25:25 +0100
Message-ID: <87r1xxxz7e.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 10:02 PM CET, Andrii Nakryiko wrote:
> On Wed, Mar 11, 2020 at 12:49 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Wed, Mar 11, 2020 at 07:48 PM CET, Andrii Nakryiko wrote:
>> > On Mon, Jan 27, 2020 at 4:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> Now that SOCKMAP can store listening sockets, user-space and BPF API is
>> >> open to a new set of potential pitfalls. Exercise the map operations (with
>> >> extra attention to code paths susceptible to races between map ops and
>> >> socket cloning), and BPF helpers that work with SOCKMAP to gain confidence
>> >> that all works as expected.
>> >>
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> ---
>> >>  .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
>> >>  .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
>> >>  2 files changed, 1532 insertions(+)
>> >>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>> >>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
>> >>
>> >
>> > Hey Jakub!
>> >
>> > I'm frequently getting spurious failures for sockmap_listen selftest.
>> > We also see that in libbpf's Github CI testing as well. Do you mind
>> > taking a look? Usually it's the following kinds of error:
>> >
>> > ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
>> > connect_accept_thread:FAIL:733
>>
>> Hey Andrii,
>>
>> Sorry about that. Will investigate why this is happening.
>>
>> Can't say I've seen those. Any additional details about the test
>> enviroment would be helpful. Like the kernel build config and qemu
>> params (e.g. 1 vCPU vs more).
>
> It happens quite regularly for me, once every few runs locally. You
> can take a kernel config we use for Travis CI at [0].
>
>   [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/configs/latest.config

Reproduced it. This should help:

  https://lore.kernel.org/bpf/20200312171105.533690-1-jakub@cloudflare.com/T/#u

Thanks for bringing it to my attention.

[...]
