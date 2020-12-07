Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2662D1C7F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgLGV41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgLGV40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:56:26 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B03C061749;
        Mon,  7 Dec 2020 13:55:40 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id l14so14314602ybq.3;
        Mon, 07 Dec 2020 13:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S09wxdnZINYcsTcIavXrOLQ3u++eor056wW5Mfdy2l4=;
        b=ol2uDEhtEUelh18QJ35NJZEb0JofyATfqxTvBCWc40TcBp9OsYgihb1jFReRJYbYJh
         drL4WNTgKs2pp3z6PEED7V8WLGUP+R6Zsh1DYSTrpKMPdcWHND+s6jo4GKpSr8VkN6Kl
         94z9F78fcGKswiuarcmYH0Rp+v8RhXXyC8ElYp8Lpd3TH7EQE1TTEfGB/ZGyaapEaRe3
         jriQVQ3Jc9u7vyrTLGIzTZA/iobQuHwhSRbn7LGDxPxqftwgW0F66olUxMmLVAGA8wt+
         Qr41iidva0xOLJ7NRig8AoufyMMcbT0w1jSgG8G/ejyoK+2I1AsuG4srOkW2lFBdjbBf
         wODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S09wxdnZINYcsTcIavXrOLQ3u++eor056wW5Mfdy2l4=;
        b=OvJRmfFlQqBLZS5HfKgO2jQzzdk1zIvU8cyD19BzQXzL8cbkJhyVKdcX2AoRenN/V4
         H3FxZNdOC8qb2HmF/BUm0fuFc4ihJ6xc+bHqATxQ7zs7H0k04rJqnnmtv1mmWiI4ycAx
         FFsDWoD4ifffAkiQwmmtwfhNH6grhggmkQQhX6uemRE+aTsyB9TPxVm+Q6wtoXd3fI/o
         ywLgFLs5IwxM2UYZlkODM/ZmIjWRaoz2N4i7L4+TI3IzjMoF5hc3avPgtC09khNHqbOZ
         xKpPobXH8tsh9SIyPTk0JiZ0XMlHqS82V9i2CU1UkSu5FyztISbCiYWCbh6Mm/Puvwzy
         8dmg==
X-Gm-Message-State: AOAM532Aqhq7TecfcF7dX+8LV+zdPss0w9tKlbuHTnfgdbEzKmjAU83k
        bmFdb2wFBvAU/rSOnBMaLxMC0dyq1p1JNv3+NhoKQIpBmD+zo3tq
X-Google-Smtp-Source: ABdhPJyEhSF/G71Z+XLVX65pkZGGwPh2F3F0SollSLy5yLecZSmNJeC21D1hR47dyEdRkwpcSy0kZKss2xv3hf9yVmk=
X-Received: by 2002:a25:ab31:: with SMTP id u46mr17921449ybi.179.1607378139552;
 Mon, 07 Dec 2020 13:55:39 -0800 (PST)
MIME-Version: 1.0
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-2-weqaar.a.janjua@intel.com> <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
 <1bcfb208-dfbd-7b49-e505-8ec17697239d@intel.com> <CAPLEeBYnYcWALN_JMBtZWt3uDnpYNtCA_HVLN6Gi7VbVk022xw@mail.gmail.com>
 <9c73643f-0fdc-d867-6fe0-b3b8031a6cf2@fb.com> <CAPLEeBZh+BEJp_k0bDQ8nmprMPqQ29JSEXCxscm5wAZQH81bAQ@mail.gmail.com>
 <b153b6af-6f75-d091-7022-999b01f553aa@fb.com>
In-Reply-To: <b153b6af-6f75-d091-7022-999b01f553aa@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Mon, 7 Dec 2020 21:55:13 +0000
Message-ID: <CAPLEeBY_soGW66KE3U66_h2R3s0cFLjsektvYXCFb+5Uvc0YfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: xsk selftests framework
To:     Yonghong Song <yhs@fb.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 at 03:13, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/27/20 9:54 AM, Weqaar Janjua wrote:
> > On Fri, 27 Nov 2020 at 04:19, Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 11/26/20 1:22 PM, Weqaar Janjua wrote:
> >>> On Thu, 26 Nov 2020 at 09:01, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@inte=
l.com> wrote:
> >>>>
> >>>> On 2020-11-26 07:44, Yonghong Song wrote:
> >>>>>
> >>>> [...]
> >>>>>
> >>>>> What other configures I am missing?
> >>>>>
> >>>>> BTW, I cherry-picked the following pick from bpf tree in this exper=
iment.
> >>>>>      commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
> >>>>>      Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>>>>      Date:   Mon Nov 23 18:56:00 2020 +0100
> >>>>>
> >>>>>          net, xsk: Avoid taking multiple skbuff references
> >>>>>
> >>>>
> >>>> Hmm, I'm getting an oops, unless I cherry-pick:
> >>>>
> >>>> 36ccdf85829a ("net, xsk: Avoid taking multiple skbuff references")
> >>>>
> >>>> *AND*
> >>>>
> >>>> 537cf4e3cc2f ("xsk: Fix umem cleanup bug at socket destruct")
> >>>>
> >>>> from bpf/master.
> >>>>
> >>>
> >>> Same as Bjorn's findings ^^^, additionally applying the second patch
> >>> 537cf4e3cc2f [PASS] all tests for me
> >>>
> >>> PREREQUISITES: [ PASS ]
> >>> SKB NOPOLL: [ PASS ]
> >>> SKB POLL: [ PASS ]
> >>> DRV NOPOLL: [ PASS ]
> >>> DRV POLL: [ PASS ]
> >>> SKB SOCKET TEARDOWN: [ PASS ]
> >>> DRV SOCKET TEARDOWN: [ PASS ]
> >>> SKB BIDIRECTIONAL SOCKETS: [ PASS ]
> >>> DRV BIDIRECTIONAL SOCKETS: [ PASS ]
> >>>
> >>> With the first patch alone, as soon as we enter DRV/Native NOPOLL mod=
e
> >>> kernel panics, whereas in your case NOPOLL tests were falling with
> >>> packets being *lost* as per seqnum mismatch.
> >>>
> >>> Can you please test this out with both patches and let us know?
> >>
> >> I applied both the above patches in bpf-next as well as this patch set=
,
> >> I still see failures. I am attaching my config file. Maybe you can tak=
e
> >> a look at what is the issue.
> >>
> > Thanks for the config, can you please confirm the compiler version,
> > and resource limits i.e. stack size, memory, etc.?
>
> root@arch-fb-vm1:~/net-next/net-next/tools/testing/selftests/bpf ulimit -=
a
> core file size          (blocks, -c) unlimited
> data seg size           (kbytes, -d) unlimited
> scheduling priority             (-e) 0
> file size               (blocks, -f) unlimited
> pending signals                 (-i) 15587
> max locked memory       (kbytes, -l) unlimited
> max memory size         (kbytes, -m) unlimited
> open files                      (-n) 1024
> pipe size            (512 bytes, -p) 8
> POSIX message queues     (bytes, -q) 819200
> real-time priority              (-r) 0
> stack size              (kbytes, -s) 8192
> cpu time               (seconds, -t) unlimited
> max user processes              (-u) 15587
> virtual memory          (kbytes, -v) unlimited
> file locks                      (-x) unlimited
>
> compiler: gcc 8.2
>
> >
> > Only NOPOLL tests are failing for you as I see it, do the same tests
> > fail every time?
>
> In my case, with above two bpf patches applied as well, I got:
> $ ./test_xsk.sh
> setting up ve9127: root: 192.168.222.1/30
>
> setting up ve4520: af_xdp4520: 192.168.222.2/30
>
> Spec file created: veth.spec
>
> PREREQUISITES: [ PASS ]
>
> # Interface found: ve9127
>
> # Interface found: ve4520
>
> # NS switched: af_xdp4520
>
> 1..1
>
> # Interface [ve4520] vector [Rx]
>
> # Interface [ve9127] vector [Tx]
>
> # Sending 10000 packets on interface ve9127
>
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [59], payloadseqnum [0]
>
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>
> SKB NOPOLL: [ FAIL ]
>
> # Interface found: ve9127
>
> # Interface found: ve4520
>
> # NS switched: af_xdp4520
> # NS switched: af_xdp4520
>
> 1..1
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> # End-of-tranmission frame received: PASS
> # Received 10000 packets on interface ve4520
> ok 1 PASS: SKB POLL
> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> SKB POLL: [ PASS ]
> # Interface found: ve9127
> # Interface found: ve4520
> # NS switched: af_xdp4520
> 1..1
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [153], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV NOPOLL: [ FAIL ]
> # Interface found: ve9127
> # Interface found: ve4520
> # NS switched: af_xdp4520
> 1..1
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> # End-of-tranmission frame received: PASS
> # Received 10000 packets on interface ve4520
> ok 1 PASS: DRV POLL
> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> DRV POLL: [ PASS ]
> # Interface found: ve9127
> # Interface found: ve4520
> # NS switched: af_xdp4520
> 1..1
> # Creating socket
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [54], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> SKB SOCKET TEARDOWN: [ FAIL ]
> # Interface found: ve9127
> # Interface found: ve4520
> # NS switched: af_xdp4520
> 1..1
> # Creating socket
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV SOCKET TEARDOWN: [ FAIL ]
> # Interface found: ve9127
> # Interface found: ve4520
> # NS switched: af_xdp4520
> 1..1
> # Creating socket
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [64], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
> # Interface found: ve9127
> # Interface found: ve4520
> # NS switched: af_xdp4520
> 1..1
> # Creating socket
> # Interface [ve4520] vector [Rx]
> # Interface [ve9127] vector [Tx]
> # Sending 10000 packets on interface ve9127
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [83], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
> cleaning up...
> removing link ve4520
> removing ns af_xdp4520
> removing spec file: veth.spec
>
> Second runs have one previous success becoming failure.
>
> ./test_xsk.sh
> setting up ve2458: root: 192.168.222.1/30
>
> setting up ve4468: af_xdp4468: 192.168.222.2/30
>
> [  286.597111] IPv6: ADDRCONF(NETDEV_CHANGE): ve4468: link becomes ready
>
> Spec file created: veth.spec
>
> PREREQUISITES: [ PASS ]
>
> # Interface found: ve2458
>
> # Interface found: ve4468
>
> # NS switched: af_xdp4468
>
> 1..1
>
> # Interface [ve4468] vector [Rx]
>
> # Interface [ve2458] vector [Tx]
>
> # Sending 10000 packets on interface ve2458
>
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [67], payloadseqnum [0]
>
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>
> SKB NOPOLL: [ FAIL ]
>
> # Interface found: ve2458
>
> # Interface found: ve4468
>
> # NS switched: af_xdp4468
>
> 1..1
>
> # Interface [ve4468] vector [Rx]
>
> # Interface [ve2458] vector [Tx]
>
> # Sending 10000 packets on interface ve2458
>
> # End-of-tranmission frame received: PASS
> # Received 10000 packets on interface ve4468
> ok 1 PASS: SKB POLL
> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> SKB POLL: [ PASS ]
> # Interface found: ve2458
> # Interface found: ve4468
> # NS switched: af_xdp4468
> 1..1
> # Interface [ve4468] vector [Rx]
> # Interface [ve2458] vector [Tx]
> # Sending 10000 packets on interface ve2458
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [191], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV NOPOLL: [ FAIL ]
> # Interface found: ve2458
> # Interface found: ve4468
> # NS switched: af_xdp4468
> 1..1
> # Interface [ve4468] vector [Rx]
> # Interface [ve2458] vector [Tx]
> # Sending 10000 packets on interface ve2458
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV POLL: [ FAIL ]
> # Interface found: ve2458
> # Interface found: ve4468
> # NS switched: af_xdp4468
> 1..1
> # Creating socket
> # Interface [ve4468] vector [Rx]
> # Interface [ve2458] vector [Tx]
> # Sending 10000 packets on interface ve2458
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> SKB SOCKET TEARDOWN: [ FAIL ]
> # Interface found: ve2458
> # Interface found: ve4468
> # NS switched: af_xdp4468
> 1..1
> # Creating socket
> # Interface [ve4468] vector [Rx]
> # Interface [ve2458] vector [Tx]
> # Sending 10000 packets on interface ve2458
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [171], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV SOCKET TEARDOWN: [ FAIL ]
> # Interface found: ve2458
> # Interface found: ve4468
> # NS switched: af_xdp4468
> 1..1
> # Creating socket
> # Interface [ve4468] vector [Rx]
> # Interface [ve2458] vector [Tx]
> # Sending 10000 packets on interface ve2458
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [124], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
> # Interface found: ve2458
> # Interface found: ve4468
> # NS switched: af_xdp4468
> 1..1
> # Creating socket
> # Interface [ve4468] vector [Rx]
> # Interface [ve2458] vector [Tx]
> # Sending 10000 packets on interface ve2458
> not ok 1 ERROR: [worker_pkt_validate] prev_pkt [195], payloadseqnum [0]
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
> cleaning up...
> removing link ve4468
> removing ns af_xdp4468
> removing spec file: veth.spec
>
> >
> > I will need to spend some time debugging this to have a fix.
>
> Thanks.
>
> >
> > Thanks,
> > /Weqaar
> >
> >>>
> >>>> Can I just run test_xsk.sh at tools/testing/selftests/bpf/ directory=
?
> >>>> This will be easier than the above for bpf developers. If it does no=
t
> >>>> work, I would like to recommend to make it work.
> >>>>
> >>> yes test_xsk.shis self contained, will update the instructions in the=
re with v4.
> >>
> >> That will be great. Thanks!
> >>
v4 is out on the list, incorporating most if not all your suggestions
to the best of my memory.

I was able to reproduce the issue you were seeing (from your logs) ->
veth interfaces were receiving packets from the IPv6 neighboring
system (thanks @Bj=C3=B6rn T=C3=B6pel for mentioning this).

The packet validation algo in *xdpxceiver* *assumed* all packets would
be IPv4 and intended for Rx.
Rx validates packets on both ip->tos =3D 0x9 (id for xsk tests) and
ip->version =3D 0x4, ignores the rest.

Hoping the tests now work -> PASS in your environment.

Thanks,
/Weqaar

> >>>
> >>> Thanks,
> >>> /Weqaar
> >>>>
> >>>> Bj=C3=B6rn
