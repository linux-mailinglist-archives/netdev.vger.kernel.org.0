Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F36EECD82
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 06:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfKBFtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 01:49:03 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35936 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 01:49:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id d13so12797501qko.3;
        Fri, 01 Nov 2019 22:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9dgnU1S8Ate0n740VRCjAMnGysukD1lI/J/yhx09fKk=;
        b=Pm+pkUWkxfIpG6tjT6Iu1XVcs2u0WihelpEjZiAI25WQIe8A42wFJX4FP5seuSmQoL
         8jKvqiMQpqMJjUqQ3eujuXbrWdVDUFMWVFAGBjCw8P0PEYh6pObYyG0Wn9BIRlidlLhi
         BSLy0rUn5t/jFBzWBYqIl4iV3U9aat/kXTlYOOmHEjzfJfMiAhq3X9rL5M1oSlffky2A
         S9Gi9+eoX35vFzWrM0dwbkCOtAVTUGHbuI9eDS2mWbLd8UD08rHkH4KtHsRghb2clV/9
         mTi7FLMnM0nH4TuS1JqzCUw2zXmBKx3VeHbEkz8R7ekF246Gp9H58WWIMmvVqeHABql2
         nCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9dgnU1S8Ate0n740VRCjAMnGysukD1lI/J/yhx09fKk=;
        b=LoMl0tBn+ckjwbFEGCuQOCD/kf+MqV3/BpwcigdruzbyG4tm6xbym0UNPrUZ0r6NI5
         vJKQOXS/I17b76P9OnrFAOJYXYu+2FxYyg8IY4pYwUP19nDStRnNDmq40uKHEsk5R+Lu
         N4QlUuXnNExXAHKocjqA3RlaPnUjmIRW4faKdG6DHBOc+CXLTlrrGmTq7itN3GV6dMCM
         vUr95bch9sRbUdbd0HGfuLMQiR8FGUk3RY5hAXJ5VJ+si6jKuAQWxHROytlJZAoScnnu
         6By1ii/2tYowxKTQkVTY/v13PEc1476I4UBqVAzn8iAwUrX9WD6havnuTL4KpP8bOz5v
         lMvA==
X-Gm-Message-State: APjAAAXPmpOdJ2iyzTNzbjtopJ+ZIcPKytKCxEoCuLVIVFh5fXlyTlDe
        m1mQwqVFQKBPjrSwuGjbfwB5/c5BVh/ascDBZVI=
X-Google-Smtp-Source: APXvYqzA9SABwuYndBKdE8xecCEqfhthvgs/utvap5TuzkCLbhzJqKkfiQEYednAy7ASBa11Wdm9FCXokmIuqD7dsbk=
X-Received: by 2002:a37:7486:: with SMTP id p128mr3433337qkc.437.1572673740061;
 Fri, 01 Nov 2019 22:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191101130817.11744-1-ethercflow@gmail.com>
In-Reply-To: <20191101130817.11744-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Nov 2019 22:48:49 -0700
Message-ID: <CAEf4Bzand8qSxqmryyxMNg3FNL-pgokJ4taRrtGq07rdbEjsbA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: test for bpf_get_file_path()
 from raw tracepoint
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 6:08 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> trace fstat events by raw tracepoint sys_enter:newfstat, and handle events
> only produced by fd2path_loadgen, the fd2path_loadgen call fstat on several
> different types of files to test bpf_get_file_path's feature.
> ---

Unless there is a real reason for all this complexity (in which case,
please spell it out in commit or comments), I think this could be so
much simpler.

- you don't have to use perf_buffer to pass data back, just use global data;
- you can add a filter for PID to only capture data triggered by test
process and avoid the noise;
- why all those set_affinity dances? Is it just because you used
existing perf_buffer test which did that to specifically test
perf_buffer delivering data across every CPU core? Seems like your
test doesn't care about that...
- do we really need a separate binary generating hundreds of syscalls?
It's hard to synchronize with test and it seems much simpler to just
trigger necessary syscalls synchronously from the test itself, no?

I have a bunch of more minutia nits, but most of them will go away if
you simplify your testing approach anyway, so I'll postpone them till
then.

>  tools/testing/selftests/bpf/Makefile          |   8 +-
>  tools/testing/selftests/bpf/fd2path_loadgen.c |  75 ++++++++++
>  .../selftests/bpf/prog_tests/get_file_path.c  | 130 ++++++++++++++++++
>  .../selftests/bpf/progs/test_get_file_path.c  |  58 ++++++++
>  4 files changed, 269 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/fd2path_loadgen.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c
>

[...]
