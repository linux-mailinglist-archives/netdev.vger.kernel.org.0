Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386D9189247
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 00:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgCQXo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 19:44:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:43000 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgCQXo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 19:44:57 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jELtD-00028U-Lt; Wed, 18 Mar 2020 00:44:51 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jELtD-000KY2-8K; Wed, 18 Mar 2020 00:44:51 +0100
Subject: Re: [PATCH bpf-next v5] bpf: Support llvm-objcopy and llvm-objdump
 for vmlinux BTF
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Fangrui Song <maskray@google.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>
References: <20200317211649.o4fzaxrzy6qxvz4f@google.com>
 <20200317215100.GC2459609@mini-arch.hsd1.ca.comcast.net>
 <20200317220136.srrt6rpxdjhptu23@google.com>
 <CAKwvOd=gaX1CBTirziwK8MxQuERTqH65xMBHNzRXHR4uOTY4bw@mail.gmail.com>
 <CAKH8qBteBDQp_Jw2RhM5u6x2q75+PtRwX6jZZQggjpeohWQEzg@mail.gmail.com>
 <CAKwvOdkVtDjXNM1pA=sZvrGhxK3amYbLmsQvQWKnTtXyvxaR3w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <112e0e48-7dd6-d209-bd17-65c30d30a984@iogearbox.net>
Date:   Wed, 18 Mar 2020 00:44:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkVtDjXNM1pA=sZvrGhxK3amYbLmsQvQWKnTtXyvxaR3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 12:14 AM, Nick Desaulniers wrote:
> On Tue, Mar 17, 2020 at 3:13 PM Stanislav Fomichev <sdf@google.com> wrote:
>> On Tue, Mar 17, 2020 at 3:08 PM Nick Desaulniers
>> <ndesaulniers@google.com> wrote:
>>> On Tue, Mar 17, 2020 at 3:01 PM Fangrui Song <maskray@google.com> wrote:
>>>> On 2020-03-17, Stanislav Fomichev wrote:
>>>>> Please keep small changelog here, for example:
>>>>>
>>>>> v5:
>>>>> * rebased on top of bpfnext
>>>>
>>>> Thanks for the tip. Add them at the bottom?
>>>
>>> "Below the fold" see this patch I just sent out:
>>> https://lore.kernel.org/lkml/20200317215515.226917-1-ndesaulniers@google.com/T/#u
>>> grep "Changes"
>>>
>>> $ git format-patch -v2 HEAD~
>>> $ vim 0001-...patch
>>> <manually add changelog "below the fold">
>> BPF subtree prefers the changelog in the commit body, not the comments
>> (iow, before ---).
>> Add them at the end of you message, see, for example:
>> https://lore.kernel.org/bpf/a428fb88-9b53-27dd-a195-497755944921@iogearbox.net/T/
> 
> Sigh, every maintainer is a special snowflake.  In our tree, you're
> only allowed to commit on Thursdays under a blood moon. /s
> 
> But thanks for the note.

For every commit into bpf/bpf-next we automatically put a 'Link:' tag pointing
to the lore.kernel.org/bpf long-term archive, so there is always an easy way to
retrieve additional information or discussions ([0] as one example). So whether
you put it above or below the '---' line I personally don't mind either way. All
crucial information that helps a reader later on to understand /why/ we ended up
exactly with the current change should be part of the main commit log though.

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=483d7a30f538e2f8addd32aa9a3d2e94ae55fa65
