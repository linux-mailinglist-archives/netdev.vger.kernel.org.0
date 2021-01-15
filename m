Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AB2F7307
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 07:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbhAOGxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 01:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbhAOGxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 01:53:33 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8500C061575;
        Thu, 14 Jan 2021 22:52:52 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id p13so9276916ljg.2;
        Thu, 14 Jan 2021 22:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GqKdkMAsAJ4/lqkrXFgBtXwq9o4GvD70WXrb83NTV/8=;
        b=pBQhBjNhadpwBOsDOSaQe8hszlEQl0y4pnP3pt92UTk//WZbR2G22EF6LdNovesGdg
         1/4EehehsDjkjDzESAKpt4UwH7E3EvppTCKzpqltcwyes6t4D6K0THQ2XbXf8be/MdNK
         QThdPb00qQenozL2YZb6IOYN7N7A1ICA/5mNpUHicPcMrwg4xQGWmuo/+98xV4opEWM3
         Nhp5JGHFnPQAcA63S5zGurnV6wcpAx5xq6xgruWT+nanAr+NQV/b+GR9d0vKxZ1pp+CQ
         c9df025lsgV1pnzFcmzquHwUAhzVnkHV1HzSPmuZW0aUwd0VZBJhal1gDIqIAsTVVuW6
         kEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqKdkMAsAJ4/lqkrXFgBtXwq9o4GvD70WXrb83NTV/8=;
        b=rwI6k5yA4y//6V0Bsei9pBcph79ahT/uBrEGKsjIchB5qxwMSad9xqwcf8U+GRD8wO
         QJBmNexVyJkb2NEmzTvGQfmQwBuKHtwiUo/4q4hczR0HPChZDGfBRgxN40ibhq1f0RZR
         xBiAQlbogdn+vELVx1NVlybT0IPgPh/LlFV1phcUF2dyrqFe6H5el854C0hadJcvQrdA
         crStMaAYXLyvSjV4K5lqi0yypdwrWfYXpa7f5pVSFEZUrWKA6/ubxbjzOGyBheK7NCHA
         8/mllmjnRsbc3g3iETcCgn4f7oIY4vHHOKwsUkbixaehWkar3D6FvOf/jiDpE1uzoSyN
         nNLw==
X-Gm-Message-State: AOAM530rokh/j1apWoWzbIw6UyPcAmUKzz459xPksFjpKF5W46QhkB08
        3C56xsg1D+HbS7UG6EdbBKEhHgrEg2xeJXxeKk0=
X-Google-Smtp-Source: ABdhPJz8hUSusRScsJ1e/jS/C4EdCbMVWMM3znbaWGhdIVOjZe8uaywbO9p44uAt6opRfY76OMylPdUcmMY31cZTJhk=
X-Received: by 2002:a2e:9792:: with SMTP id y18mr4682501lji.204.1610693571003;
 Thu, 14 Jan 2021 22:52:51 -0800 (PST)
MIME-Version: 1.0
References: <CAFSh4UwMr7t+R9mWUCjdecadJL6=_7jdgagAQK6Y1Yj0+Eu0sg@mail.gmail.com>
 <CAFSh4UwAmR+sdfbdyxHRDnDr8r+TXxo2bvWtY3gmLAJekWc3Sw@mail.gmail.com> <CAFSh4Uwsj5GfPRUe+oT8h=DBxHppqbE-zsDV8-J5rTK3-xyZFQ@mail.gmail.com>
In-Reply-To: <CAFSh4Uwsj5GfPRUe+oT8h=DBxHppqbE-zsDV8-J5rTK3-xyZFQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jan 2021 22:52:39 -0800
Message-ID: <CAADnVQ+tfm-k1Pz3bGm9oVJzayMgg=prenqhqrPfm3QnaCqL7Q@mail.gmail.com>
Subject: Re: cBPF socket filters failing - inexplicably?
To:     Tom Cook <tom.k.cook@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding appropriate mailing list to cc...

My wild guess is that as soon as socket got created:
socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
the packets were already queued to it.
So later setsockopt() is too late to filter.

Eric, thoughts?

On Wed, Jan 6, 2021 at 6:55 AM Tom Cook <tom.k.cook@gmail.com> wrote:
>
> Another factoid to add to this:  I captured all traffic on an
> interface while the test program was running using
>
> tcpdump -i wlo1 -w capture.pcap
>
> observing that multiple packets got through the filter.  I then built
> the bpf_dbg program from the kernel source tree and ran the same
> filter and capture file through it:
>
> $ tools/bpf_dbg
> > load bpf 1,6 0 0 0
> > load pcap capture.pcap
> > run
> bpf passes:0 fails:269288
>
> So bpf_dbg thinks the filter is correct; it's only when the filter is
> attached to an actual socket that it fails occasionally.
>
> Regards,
> Tom
>
> On Wed, Jan 6, 2021 at 10:07 AM Tom Cook <tom.k.cook@gmail.com> wrote:
> >
> > Just to note I have also reproduced this on a 5.10.0 kernel.
> >
> > On Tue, Jan 5, 2021 at 1:42 PM Tom Cook <tom.k.cook@gmail.com> wrote:
> > >
> > > In the course of tracking down a defect in some existing software,
> > > I've found the failure demonstrated by the short program below.
> > > Essentially, a cBPF program that just rejects every frame (ie always
> > > returns zero) and is attached to a socket using setsockopt(SOL_SOCKET,
> > > SO_ATTACH_FILTER, ...) still occasionally lets frames through to
> > > userspace.
> > >
> > > The code is based on the first example in
> > > Documentation/networking/filter.txt, except that I've changed the
> > > content of the filter program and added a timeout on the socket.
> > >
> > > To reproduce the problem:
> > >
> > > # gcc test.c -o test
> > > # sudo ./test
> > > ... and in another console start a large network operation.
> > >
> > > In my case, I copied a ~300MB core file I had lying around to another
> > > host on the LAN.  The test code should print the string "Failed to
> > > read from socket" 100 times.  In practice, it produces about 10%
> > > "Received packet with ethertype..." messages.
> > >
> > > I've observed the same result on Ubuntu amd64 glibc system running a
> > > 5.9.0 kernel and also on Alpine arm64v8 muslc system running a 4.9.1
> > > kernel.  I've written test code in both C and Python.  I'm fairly sure
> > > this is not something I'm doing wrong - but very keen to have things
> > > thrown at me if it is.
> > >
> > > Regards,
> > > Tom Cook
> > >
> > >
> > > #include <stdio.h>
> > > #include <sys/socket.h>
> > > #include <sys/types.h>
> > > #include <arpa/inet.h>
> > > #include <linux/if_ether.h>
> > > #include <linux/filter.h>
> > > #include <stdint.h>
> > > #include <unistd.h>
> > >
> > > struct sock_filter code[] = {
> > >     { 0x06,    0,    0,    0x00 }  /* BPF_RET | BPF_K   0   0   0 */
> > > };
> > >
> > > struct sock_fprog bpf = {
> > >     .len = 1,
> > >     .filter = code,
> > > };
> > >
> > > void test() {
> > >     uint8_t buf[2048];
> > >
> > >     int sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
> > >     if (sock < 0) {
> > >         printf("Failed to open socket\n");
> > >         return;
> > >     }
> > >     int ret = setsockopt(sock, SOL_SOCKET, SO_ATTACH_FILTER, &bpf, sizeof(bpf));
> > >     if (ret < 0) {
> > >         printf("Failed to set socket filter\n");
> > >         return;
> > >     }
> > >     struct timeval tv = {
> > >         .tv_sec = 1
> > >     };
> > >
> > >     ret = setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
> > >     if (ret < 0) {
> > >         printf("Failed to set socket timeout\n");
> > >         return;
> > >     }
> > >
> > >     ssize_t count = recv(sock, buf, 2048, 0);
> > >     if (count <= 0) {
> > >         printf("Failed to read from socket\n");
> > >         return;
> > >     }
> > >
> > >     close(sock);
> > >
> > >     uint16_t *ethertype = (short*)(buf + 12);
> > >     uint8_t *proto = (unsigned char *)(buf + 23);
> > >     uint16_t *dport = (uint16_t *)(buf + 14 + 20);
> > >
> > >     printf("Received packet with ethertype 0x%04hu, protocol 0x%02hhu
> > > and dport 0x%04hu\n", *ethertype, *proto, *dport);
> > > }
> > >
> > > int main() {
> > >     for (size_t ii = 0; ii < 100; ++ii) {
> > >         test();
> > >     }
> > > }
