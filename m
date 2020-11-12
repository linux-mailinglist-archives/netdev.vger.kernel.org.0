Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB2D2B12AA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKLXVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:21:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:43166 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgKLXVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:21:12 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdLtd-0000xI-55; Fri, 13 Nov 2020 00:20:53 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdLtc-000ACF-Qb; Fri, 13 Nov 2020 00:20:52 +0100
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
 <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net> <871rgy8aom.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <da82603a-cea9-7036-9d9a-4e1174cfa7c0@iogearbox.net>
Date:   Fri, 13 Nov 2020 00:20:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <871rgy8aom.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25986/Thu Nov 12 14:18:25 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 11:36 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>>> Besides, for the entire history of BPF support in iproute2 so far, the
>>> benefit has come from all the features that libbpf has just started
>>> automatically supporting on load (BTF, etc), so users would have
>>> benefited from automatic library updates had it *not* been vendored in.
>>
>> Not really. What you imply here is that we're living in a perfect
>> world and that all distros follow suite and i) add libbpf dependency
>> to their official iproute2 package, ii) upgrade iproute2 package along
>> with new kernel releases and iii) upgrade libbpf along with it so that
>> users are able to develop BPF programs against the feature set that
>> the kernel offers (as intended). These are a lot of moving parts to
>> get right, and as I pointed out earlier in the conversation, it took
>> major distros 2 years to get their act together to officially include
>> bpftool as a package - I'm not making this up, and this sort of pace
>> is simply not sustainable. It's also not clear whether distros will
>> get point iii) correct.
> 
> I totally get that you've been frustrated with the distro adoption and
> packaging of BPF-related tools. And rightfully so. I just don't think
> that the answer to this is to try to work around distros, but rather to
> work with them to get things right.
> 
> I'm quite happy to take a shot at getting a cross-distro effort going in
> this space; really, having well-supported BPF tooling ought to be in
> everyone's interest!

Thanks, yes, that is worth a push either way! There is still a long tail
of distros that are not considered major and until they all catch up with
points i)-iii) it might take a much longer time until this becomes really
ubiquitous with iproute2 for users of the libbpf loader. Its that this
frustrating user experience could be avoided altogether. iproute2 is
shipped and run also on small / embedded devices hence it tries to have
external dependencies reduced to a bare minimum (well, except that libmnl
detour, but it's not a mandatory dependency). If I were a user and would
rely on the loader for my progs to be installed I'd probably end up
compiling my own version of iproute2 linked with libbpf to move forward
instead of being blocked on distro to catch up, but its an additional
hassle for shipping SW instead of just having it all pre-installed when
built-in given it otherwise comes with the base distro already. But then
my question is what is planned here as deprecation process for the built-in
lib/bpf.c code? I presume we'll remove it eventually to move on?
