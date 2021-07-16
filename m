Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D873CB008
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 02:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhGPARy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhGPARx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 20:17:53 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0232C06175F;
        Thu, 15 Jul 2021 17:14:58 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id e20so11531713ljn.8;
        Thu, 15 Jul 2021 17:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5N+1xB7M+FK6tjSxxxfs+r5H8YqAHzk748qaOQI6T+I=;
        b=JuwSDeF7uI0VbxShuAoe4pHuk2CFonoNk9kcBRXexdnA1hecNFeHwprk1NpL4G+CFm
         goSj+o9raFmTBk732JFhaku5/U/+X5X8JgBrQjN/dAanXKSj6OC6BvVDhvaLzpK0Q1ds
         g5/DzMx/VagC49kgDXEyc6uxoIKplu4+3PtY/wshYJSfF2doxmegZrmnmcR4ZbrM4iL8
         YttVrq3kevxST/OtsTxFKoYnusvaQcYalIntq86okEZirI6TxtDAiIU/qr05oTFS9OFC
         f9HrWUpYj7ZUJHy8opp8xBRlD3WhCS8g9SDzWszBQ1Js2cvfWsKYheiY9xImJjTiEzAr
         6RpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5N+1xB7M+FK6tjSxxxfs+r5H8YqAHzk748qaOQI6T+I=;
        b=HaJdjdw6GPLVZUZOzUUqR8QTKzcGxX62ng1mCTZdXYUdFVg8DaQJzYJqB/Z0JaKKD0
         au5LufgbddDqZTp2adXnE5X/VwxBcpfmthyuTLbFMap2Kgr/3Ak4tvoHHG/TxRATkuM5
         /J5P9EqOkodauWq2CWNIAGa8EZj8I8lynDbeVuIJsSSZQ25gv+wrarN+wZTrkRqaY7Yz
         QBRAeKG7B8j4xB9QIjgY3iOuZycfhENLzpHDzYxc5kWu3tX35AX6zyNQv6pir++OLulZ
         bU7sf7VAv9v4BQWnqYzDq3r2Dv013OV8W9GS9tkuMrUDUL1YMfqJZOnIxCvC/ftyUBlS
         tiog==
X-Gm-Message-State: AOAM533E+6OikjCuSpM3VQyMVp4MGqFjFVdV4qDoGNR7GXXyHywpM85i
        BzSIhYGhfDVOX9wtFBMUfvowfzSHbezirJJjP6A=
X-Google-Smtp-Source: ABdhPJxhuQE4Nd4K1i3/jZWkVVJD46M46NgwBP40rUR5e2clVCtK0fU+CPF1zA2w6drMLegdHvBQ6BUOcRepEEyx9xw=
X-Received: by 2002:a2e:a887:: with SMTP id m7mr2574021ljq.236.1626394497152;
 Thu, 15 Jul 2021 17:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR11MB4173595C36B9876CBF2CCFA1A6189@MN2PR11MB4173.namprd11.prod.outlook.com>
 <CAADnVQJ9M6ip6uYb9ky=eH-Z1BO-cTeGOpYs0M3EZrgURWpNcQ@mail.gmail.com> <CABX6iNqj-ojymaPhPtgeOGxtUS6evyrvN69MrLD7s_+Z3xAK+w@mail.gmail.com>
In-Reply-To: <CABX6iNqj-ojymaPhPtgeOGxtUS6evyrvN69MrLD7s_+Z3xAK+w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Jul 2021 17:14:45 -0700
Message-ID: <CAADnVQL2zxCjq0AwTXVgrfs9Cem_7vyzTJj2novVJqObGFK52w@mail.gmail.com>
Subject: Re: How to limit TCP packet lengths given to TC egress EBPF programs?
To:     Sandesh Dhawaskar Sathyanarayana 
        <Sandesh.DhawaskarSathyanarayana@colorado.edu>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Lapukhov <petr@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 4:26 PM Sandesh Dhawaskar Sathyanarayana
<Sandesh.DhawaskarSathyanarayana@colorado.edu> wrote:
>
> Hi ,

Please do not top post and do not use html in your replies.

> I tested the new TCP experimental headers as INT headers in TCP options. =
But this does not work.
> Programmable switch looks for the INT header after 20 bytes of TCP header=
. If it finds INT then it just appends its own INT data by parsing INT fiel=
d in TCP,else it appends its own INT header with data after 20 bytes and if=
 any TCP option is present it will append that after INT.
> Now if we use the TCP options field in the end host as INT fields, the sw=
itch looks at TCP header options as INT and appends just the data. Now that=
 the switch has consumed TCP option as INT data, it will not find TCP optio=
ns to append after it puts its INT data as result the packets will be dropp=
ed in the switch.
>
> Hence we need a new way to create INT header space in the TCP kernel stac=
k itself.
>
>
> Here is what I did:
>
> 1. Reserved the space in the TCP header option using BPF_SOCK_OPS_HDR_OPT=
_LEN_CB.
> 2. Used the TC-eBPF at egress to write INT header in this field.

Hard to guess without looking at the actual code,
but sounds like you did bpf_reserve_hdr_opt() as sockops program,
but didn't do bpf_store_hdr_opt() in BPF_SOCK_OPS_WRITE_HDR_OPT_CB ?
and instead tried to write it in TC layer?
That won't work of course.
Please see progs/test_tcp_hdr_options.c example.

cc-ing Martin for further questions.

> But these packets get dropped at switch as the TCP length doesn;t match.
>
> Also another challenge in appending the INT in the end host at TC-eBPF (c=
urrently no support for TCP) is it breaks the TCP SYN and ACK mechanism res=
ulting in spurious retransmissions.  As kernel is not aware of appended dat=
a in TC-eBPF at egress.
>
> If anyone has suggestions please do let me know. Currently I am just thin=
king of creating the space in the kernel TCP stack itself when sk_buff is a=
llocated.
>
> Thanks
> Sandesh
>
> On Tue, Jul 13, 2021 at 5:52 PM Alexei Starovoitov <alexei.starovoitov@gm=
ail.com> wrote:
>>
>> On Fri, Jul 9, 2021 at 11:40 AM Fingerhut, John Andy
>> <john.andy.fingerhut@intel.com> wrote:
>> >
>> > Greetings:
>> >
>> > I am working on a project that runs an EBPF program on the Linux
>> > Traffic Control egress hook, which modifies selected packets to add
>> > headers to them that we use for some network telemetry.
>> >
>> > I know that this is _not_ what one wants to do to get maximum TCP
>> > performance, but at least for development purposes I was hoping to
>> > find a way to limit the length of all TCP packets that are processed
>> > by this EBPF program to be at most one MTU.
>> >
>> > Towards that goal, we have tried several things, but regardless of
>> > which subset of the following things we have tried, there are some
>> > packets processed by our EBPF program that have IPv4 Total Length
>> > field that is some multiple of the MSS size, sometimes nearly 64
>> > KBytes.  If it makes a difference in configuration options available,
>> > we have primarily been testing with Ubuntu 20.04 Linux running the
>> > Linux kernel versions near 5.8.0-50-generic distributed by Canonical.
>> >
>> > Disable TSO and GSO on the network interface:
>> >
>> >     ethtool -K enp0s8 tso off gso off
>> >
>> > Configuring TCP MSS using 'ip route' command:
>> >
>> >     ip route change 10.0.3.0/24 dev enp0s8 advmss 1424
>> >
>> > The last command _does_ have some effect, in that many packets
>> > processed by our EBPF program have a length affected by that advmss
>> > value, but we still see many packets that are about twice as large,
>> > about three times as large, etc., which fit into that MSS after being
>> > segmented, I believe in the kernel GSO code.
>> >
>> > Is there some other configuration option we can change that can
>> > guarantee that when a TCP packet is given to a TC egress EBPF program,
>> > it will always be at most a specified length?
>> >
>> >
>> > Background:
>> >
>> > Intel is developing and releasing some open source EBPF programs and
>> > associated user space programs that modify packets to add INT (Inband
>> > Network Telemetry) headers, which can be used for some kinds of
>> > performance debugging reasons, e.g. triggering events when packet
>> > losses are detected, or significant changes in one-way packet latency
>> > between two hosts configured to run this Host INT code.  See the
>> > project home page for more details if you are interested:
>> >
>> > https://github.com/intel/host-int
>>
>> I suspect MTU/MSS issue is only the tip of the iceberg.
>>
>> https://github.com/intel/host-int/blob/main/docs/Host_INT_fmt.md
>> That's an interesting design !
>> Few things should be probably be addressed sooner than later:
>> "Host INT currently only supports adding INT headers to IPv4 packets."
>> To consider such a feature of Tofino switches IPv6 has to be supported.
>> That shouldn't be hard to do, right?
>>
>> https://github.com/intel/host-int/blob/main/docs/host-int-project.pptx
>> That's a lot of bpf programs :)
>> Looks like in the bridge case (last slide) every incoming packet will
>> be processed
>> by two XDP programs.
>> XDP is certainly fast, but it still adds overhead.
>> Not every packet will have such INT header so most of the packets will b=
e
>> passing through XDP prog into the stack or from stack through TC egress =
program.
>> Such XDP ingress and TC egress progs will add overhead that might be
>> unacceptable in production deployment.
>> Have you considered using the new TCP header option instead?
>> https://lore.kernel.org/bpf/CAADnVQJ21Tt2HaJ5P4wbxBLVo1YT-PwN3bOHBQK+17r=
eK5HxOg@mail.gmail.com/
>> BPF prog can conditionally add it for few packets/flows and another BPF =
prog
>> on receive side will process such header option.
>> While Tofino switch will find packets with a special TCP header and fill=
 them in
>> with telemetry data.
>> "INT report packets are sent as UDP datagrams" part of the design can st=
ay.
>> Looks like you're reserving a UDP port for such a purpose, so no need
>> for the receive side to have an XDP program to process every packet.
>>
>> With TCP header option approach the MTU issue will go away as well.
>>
>> > Note: The code published now is an alpha release.  We know there are
>> > bugs.  We know our development team is not what you would call EBPF
>> > experts (at least not yet), so feel free to point out bugs and/or
>> > anything that code is doing that might be a bad idea.
>>
>> Thank you for reaching out. We're here to help with your BPF/XDP needs :=
)
>>
>> > Thanks,
>> > Andy Fingerhut
>> > Principal Engineer
>> > Intel Corporation
