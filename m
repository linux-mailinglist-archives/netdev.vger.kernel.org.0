Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3148F2AF46D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgKKPHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:07:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:54106 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgKKPHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 10:07:20 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcrhs-0003zw-D0; Wed, 11 Nov 2020 16:06:44 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcrhs-0003Jh-28; Wed, 11 Nov 2020 16:06:44 +0100
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
 <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
 <20201111004749.r37tqrhskrcxjhhx@ast-mbp> <874klwcg1p.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net>
Date:   Wed, 11 Nov 2020 16:06:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <874klwcg1p.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25985/Wed Nov 11 14:18:01 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/20 12:02 PM, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> On Mon, Nov 09, 2020 at 09:09:44PM -0700, David Ahern wrote:
>>> On 11/8/20 6:45 PM, Alexei Starovoitov wrote:
>>>>
>>>> I don't understand why on one side you're pointing out existing quirkiness with
>>>> bpf usability while at the same time arguing to make it _less_ user friendly
>>>
>>> I believe you have confused my comments with others. My comments have
>>> focused on one aspect: The insistence by BPF maintainers that all code
>>> bases and users constantly chase latest and greatest versions of
>>> relevant S/W to use BPF
>>
>> yes, because we care about user experience while you're still insisting
>> on make it horrible.
>> With random pick of libbpf.so we would have no choice, but to actively tell
>> users to avoid using tc, because sooner or later they will be pissed. I'd
>> rather warn them ahead of time.
> 
> Could we *please* stop with this "my way or the highway" extortion? It's
> incredibly rude, and it's not helping the discussion.
> 
>>> - though I believe a lot of the tool chasing
>>> stems from BTF. I am fairly certain I have been consistent in that theme
>>> within this thread.
>>
>> Right. A lot of features added in the last couple years depend on BTF:
>> static vs global linking, bpf_spin_lock, function by function verification, etc
>>
>>>> when myself, Daniel, Andrii explained in detail what libbpf does and how it
>>>> affects user experience?
>>>>
>>>> The analogy of libbpf in iproute2 and libbfd in gdb is that both libraries
>>>
>>> Your gdb / libbfd analogy misses the mark - by a lot. That analogy is
>>> relevant for bpftool, not iproute2.
>>>
>>> iproute2 can leverage libbpf for 3 or 4 tc modules and a few xdp hooks.
>>> That is it, and it is a tiny percentage of the functionality in the package.
>>
>> cat tools/lib/bpf/*.[hc]|wc -l
>> 23950
>> cat iproute2/tc/*.[hc]|wc -l
>> 29542
>>
>> The point is that for these few tc commands the amount logic in libbpf/tc is 90/10.
>>
>> Let's play it out how libbpf+tc is going to get developed moving forward if
>> libbpf is a random version. Say, there is a patch for libbpf that makes
>> iproute2 experience better. bpf maintainers would have no choice, but to reject
>> it, since we don't add features/apis to libbpf if there is no active user.
>> Adding a new libbpf api that iproute2 few years from now may or may not take
>> advantage makes little sense.
> 
> What? No one has said that iproute2 would never use any new features,
> just that they would be added conditionally on a compatibility check
> with libbpf (like the check for bpf_program__section_name() in the
> current patch series).
> 
> Besides, for the entire history of BPF support in iproute2 so far, the
> benefit has come from all the features that libbpf has just started
> automatically supporting on load (BTF, etc), so users would have
> benefited from automatic library updates had it *not* been vendored in.

Not really. What you imply here is that we're living in a perfect world and that
all distros follow suite and i) add libbpf dependency to their official iproute2
package, ii) upgrade iproute2 package along with new kernel releases and iii)
upgrade libbpf along with it so that users are able to develop BPF programs against
the feature set that the kernel offers (as intended). These are a lot of moving parts
to get right, and as I pointed out earlier in the conversation, it took major distros
2 years to get their act together to officially include bpftool as a package -
I'm not making this up, and this sort of pace is simply not sustainable. It's also
not clear whether distros will get point iii) correct. It's not about compatibility,
but rather about __users__ of the loader being able to __benefit__ of the latest
features their distro kernel ships from BPF (& libbpf) side just as they do with
iproute2 extensions. For the integrated lib/bpf.c in iproute2 this was never an
issue and for multiple years in the earlier days it was much further ahead than
libbpf which was only tracing-focused before we decided to put focus on the latter
as a more general loader instead. But if you ever want to start a deprecation process
of the lib/bpf.c then users should not need to worry whether iproute2 was even linked
to libbpf in the first place, they should be able to have a guarantee that it's
__generally available__ as with lib/bpf.c, otherwise they'll always just assume
the latter as the minimal available base when writing code against iproute2 loader.
Hypothetically speaking, if Hangbin would have presented patches here to extend the
existing lib/bpf.c to the point that it's feature complete (compared to libbpf),
we wouldn't even have this whole discussion here.

Thanks,
Daniel
