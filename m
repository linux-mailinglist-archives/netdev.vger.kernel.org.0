Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D8E31926
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfFAC6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:58:37 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42430 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFAC6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:58:37 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so248372lje.9;
        Fri, 31 May 2019 19:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eDJPKBJvnZIRQnVeU5Lb59LIyt1tkURiT5wO7mlIN2g=;
        b=MuvYnZ9XPAUOZtr1DQPs2ZYe/V+if7M4fgGPF9KyRogW1ExivLd9GX8YhgorfW7lKA
         8nYfqY52S9/WE233IrA9c34eVWFJnw2Za0nS3oirRbYh0k6AS8aCvUd3X/h7akTgn+uy
         UEa42RfzfaMaxAfeO4xUkRAmHsZ65fLRqWJccJg2/iuGioOBIaa4joTqf9vVVwyheOOb
         z2zfwCqrvs9heMOWsKyMk5GB9tHf86qakbVzG+6Io6gRSsmzI1P1ZzaVHAO/IqeBXeBx
         P9dSnZNpfiTZUfq3S0uekMzv5vRnC0w75Bi9HJGkHI12Od7waq2B1bl0XlyfhCq4rwoC
         975w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDJPKBJvnZIRQnVeU5Lb59LIyt1tkURiT5wO7mlIN2g=;
        b=JU9uCX/uLN2bG6lrXhJA/Sk2/j++gmG6q4bS8Ol5wdstBCejDDV3NjAwLs4bj5LX2+
         jfUmgNdIiMxF2Jt7gi7LRbbpCeB7vLAeRm3JCdGMZ0O/NW1zEagAFYRGJkicYMec45SS
         Z5VWcHCSFEs0mDeu0fvU9K9TabUUaPxpJl7Y2RVEuI17lX6fIXQ9z9xZ3VyCnsvFKBPU
         VFwIg+xB84URsFZxB+g1UxZHZJ8gdeFUXFcjoOK5cx1LuHCHOwFtSY2/z//4q4fcezgc
         7CORgIFQeAhtFqJITH3Mmre9HDz/7gx2+MpFbLuRDYUevHlCYmwiBFSonJvcbto7n4Wv
         VA8Q==
X-Gm-Message-State: APjAAAWawsSm7g7HV2UYjWkWKsMMTYYAcDbRgjSmvbL2epoUS02ZoUbw
        HHX6gBgAhn08NM/oGRC8/jzpEF3jqiy6D8g8UgY=
X-Google-Smtp-Source: APXvYqyreNdEHm79xwC9JivNNbNhJN4VOgT69fXZdX4ZtalnKX7JmwEccg3O7i6gmGhljZxUilzx4sxMisjuDvKS9nc=
X-Received: by 2002:a2e:9c09:: with SMTP id s9mr7590038lji.74.1559357913798;
 Fri, 31 May 2019 19:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <1559324834-30570-1-git-send-email-alan.maguire@oracle.com> <ACCC49B3-7A81-45D4-9AB8-C91B487FD22A@fb.com>
In-Reply-To: <ACCC49B3-7A81-45D4-9AB8-C91B487FD22A@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 19:58:22 -0700
Message-ID: <CAADnVQJsyCJAfH4ioBkRWdaeSJiXxE5bT39jhpo9sL2CSxf6eQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] selftests/bpf: measure RTT from xdp using xdping
To:     Song Liu <songliubraving@fb.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 6:37 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On May 31, 2019, at 10:47 AM, Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > xdping allows us to get latency estimates from XDP.  Output looks
> > like this:
> >
> > ./xdping -I eth4 192.168.55.8
> > Setting up XDP for eth4, please wait...
> > XDP setup disrupts network connectivity, hit Ctrl+C to quit
> >
> > Normal ping RTT data
> > [Ignore final RTT; it is distorted by XDP using the reply]
> > PING 192.168.55.8 (192.168.55.8) from 192.168.55.7 eth4: 56(84) bytes of data.
> > 64 bytes from 192.168.55.8: icmp_seq=1 ttl=64 time=0.302 ms
> > 64 bytes from 192.168.55.8: icmp_seq=2 ttl=64 time=0.208 ms
> > 64 bytes from 192.168.55.8: icmp_seq=3 ttl=64 time=0.163 ms
> > 64 bytes from 192.168.55.8: icmp_seq=8 ttl=64 time=0.275 ms
> >
> > 4 packets transmitted, 4 received, 0% packet loss, time 3079ms
> > rtt min/avg/max/mdev = 0.163/0.237/0.302/0.054 ms
> >
> > XDP RTT data:
> > 64 bytes from 192.168.55.8: icmp_seq=5 ttl=64 time=0.02808 ms
> > 64 bytes from 192.168.55.8: icmp_seq=6 ttl=64 time=0.02804 ms
> > 64 bytes from 192.168.55.8: icmp_seq=7 ttl=64 time=0.02815 ms
> > 64 bytes from 192.168.55.8: icmp_seq=8 ttl=64 time=0.02805 ms
> >
> > The xdping program loads the associated xdping_kern.o BPF program
> > and attaches it to the specified interface.  If run in client
> > mode (the default), it will add a map entry keyed by the
> > target IP address; this map will store RTT measurements, current
> > sequence number etc.  Finally in client mode the ping command
> > is executed, and the xdping BPF program will use the last ICMP
> > reply, reformulate it as an ICMP request with the next sequence
> > number and XDP_TX it.  After the reply to that request is received
> > we can measure RTT and repeat until the desired number of
> > measurements is made.  This is why the sequence numbers in the
> > normal ping are 1, 2, 3 and 8.  We XDP_TX a modified version
> > of ICMP reply 4 and keep doing this until we get the 4 replies
> > we need; hence the networking stack only sees reply 8, where
> > we have XDP_PASSed it upstream since we are done.
> >
> > In server mode (-s), xdping simply takes ICMP requests and replies
> > to them in XDP rather than passing the request up to the networking
> > stack.  No map entry is required.
> >
> > xdping can be run in native XDP mode (the default, or specified
> > via -N) or in skb mode (-S).
> >
> > A test program test_xdping.sh exercises some of these options.
> >
> > Note that native XDP does not seem to XDP_TX for veths, hence -N
> > is not tested.  Looking at the code, it looks like XDP_TX is
> > supported so I'm not sure if that's expected.  Running xdping in
> > native mode for ixgbe as both client and server works fine.
> >
> > Changes since v4
> >
> > - close fds on cleanup (Song Liu)
> >
> > Changes since v3
> >
> > - fixed seq to be __be16 (Song Liu)
> > - fixed fd checks in xdping.c (Song Liu)
> >
> > Changes since v2
> >
> > - updated commit message to explain why seq number of last
> >  ICMP reply is 8 not 4 (Song Liu)
> > - updated types of seq number, raddr and eliminated csum variable
> >  in xdpclient/xdpserver functions as it was not needed (Song Liu)
> > - added XDPING_DEFAULT_COUNT definition and usage specification of
> >  default/max counts (Song Liu)
> >
> > Changes since v1
> > - moved from RFC to PATCH
> > - removed unused variable in ipv4_csum() (Song Liu)
> > - refactored ICMP checks into icmp_check() function called by client
> >   and server programs and reworked client and server programs due
> >   to lack of shared code (Song Liu)
> > - added checks to ensure that SKB and native mode are not requested
> >   together (Song Liu)
> >
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> Note: I am Ack'ing it as a test. It needs more work, if we would
> distribute it as a tool (maybe we really would).

Agree. I think it works fine as a test.
./test_xdping.sh passed in my test setup.
Applied to bpf-next. Thanks
