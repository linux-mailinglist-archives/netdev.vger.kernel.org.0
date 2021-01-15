Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8BA2F7DF4
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbhAOORb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730727AbhAOORb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:17:31 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D82C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:16:50 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id n2so1201255iom.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6iKe/3mTMg7FO5SdPVi/NG/RVuaa5nifbLr7KD4v9M=;
        b=JT+GylXyIv/4MuWNokuqUWLsDYG7D2ClOUy8hqi9Ls50nNgAoLhKD4yQ/gX/a7PV3Z
         fgR3+DKzteNeZt8MJF4tFWFRwZdt+KY6+Laek3XYLPx/4ZDvocQPhU+c16ezD5Xsziht
         +e0ZkOTTbKs0HTBFdrQ2DY/1CaOzII7WEmCirsRx9D8UuFqTo5N7lrBScLdIH7MihSV6
         DzZjZHqYRd4sUVnD689CbS4Y3tgDCFPHWXaRIwdR9FdA1aRQ7y2BFAIszowbPVfFgLUO
         ATWwNX4FtKU8TlgXBpSM7slenms96WmEgQKHvyeB1+qXpRMj0V8aQDZwar0qs4pcG2gf
         yF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6iKe/3mTMg7FO5SdPVi/NG/RVuaa5nifbLr7KD4v9M=;
        b=iFBaGKdU5NB9yB92Moaz+J7jg/aSVkC70Ea2Vea4uQKiEL3p3p4GW5mC8f0kUqLPlf
         QnOgsNrTjER4khaKTio2rvZJP0X1OYMDybW+KToIREs7lu7or12ZIfTyLAHvaw0QUuGJ
         IxMhHNnwUIvKb1IKpSIS61VT1kHINe2hpmU95+yoJmSlP0sTQ11oyAqmaQl2fQarcNXV
         F3J5kCPxoS0JdZBF+XwSHVusP8lIm54WCVg5MNUyLSYCKIN89F2c/8/rAJxude4lNCsv
         qPU6XY4N3cboOQLTpwNcMAPNHZgDMR09ww3pUpHzmpHMmORmnQ5Q7w+xpk9NTZdCKMFV
         h/hg==
X-Gm-Message-State: AOAM531IisdR60y0kivtttIBgCWcCGSI6nAgumzuRuUgiSNIlgu2daDb
        30doJf6hR1JfC1mEVa2vfaS+O8C07XEitDcWpEf72Q==
X-Google-Smtp-Source: ABdhPJxmJL/jWUoNf2pcPZx9OAXR7chO2G3tmQOdB8Y+HPtxcQbAP+Sk+IqNq0S8Gpv0mqSgCUmpZQZkQKbCoVkyytw=
X-Received: by 2002:a02:4049:: with SMTP id n70mr2077339jaa.6.1610720209950;
 Fri, 15 Jan 2021 06:16:49 -0800 (PST)
MIME-Version: 1.0
References: <CAFSh4UwMr7t+R9mWUCjdecadJL6=_7jdgagAQK6Y1Yj0+Eu0sg@mail.gmail.com>
 <CAFSh4UwAmR+sdfbdyxHRDnDr8r+TXxo2bvWtY3gmLAJekWc3Sw@mail.gmail.com>
 <CAFSh4Uwsj5GfPRUe+oT8h=DBxHppqbE-zsDV8-J5rTK3-xyZFQ@mail.gmail.com> <CAADnVQ+tfm-k1Pz3bGm9oVJzayMgg=prenqhqrPfm3QnaCqL7Q@mail.gmail.com>
In-Reply-To: <CAADnVQ+tfm-k1Pz3bGm9oVJzayMgg=prenqhqrPfm3QnaCqL7Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 15 Jan 2021 15:16:37 +0100
Message-ID: <CANn89iL87E65sYSP0JTa8_WmKsOySM1NQqxg0Ot8+ggZ73F+vg@mail.gmail.com>
Subject: Re: cBPF socket filters failing - inexplicably?
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Tom Cook <tom.k.cook@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 7:52 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Adding appropriate mailing list to cc...
>
> My wild guess is that as soon as socket got created:
> socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
> the packets were already queued to it.
> So later setsockopt() is too late to filter.
>
> Eric, thoughts?

Exactly, this is what happens.

I do not know how tcpdump and other programs deal with this.

Maybe by setting a small buffer size, or draining the queue.

>
> On Wed, Jan 6, 2021 at 6:55 AM Tom Cook <tom.k.cook@gmail.com> wrote:
> >
> > Another factoid to add to this:  I captured all traffic on an
> > interface while the test program was running using
> >
> > tcpdump -i wlo1 -w capture.pcap
> >
> > observing that multiple packets got through the filter.  I then built
> > the bpf_dbg program from the kernel source tree and ran the same
> > filter and capture file through it:
> >
> > $ tools/bpf_dbg
> > > load bpf 1,6 0 0 0
> > > load pcap capture.pcap
> > > run
> > bpf passes:0 fails:269288
> >
> > So bpf_dbg thinks the filter is correct; it's only when the filter is
> > attached to an actual socket that it fails occasionally.
> >
> > Regards,
> > Tom
> >
> > On Wed, Jan 6, 2021 at 10:07 AM Tom Cook <tom.k.cook@gmail.com> wrote:
> > >
> > > Just to note I have also reproduced this on a 5.10.0 kernel.
> > >
> > > On Tue, Jan 5, 2021 at 1:42 PM Tom Cook <tom.k.cook@gmail.com> wrote:
> > > >
> > > > In the course of tracking down a defect in some existing software,
> > > > I've found the failure demonstrated by the short program below.
> > > > Essentially, a cBPF program that just rejects every frame (ie always
> > > > returns zero) and is attached to a socket using setsockopt(SOL_SOCKET,
> > > > SO_ATTACH_FILTER, ...) still occasionally lets frames through to
> > > > userspace.
> > > >
> > > > The code is based on the first example in
> > > > Documentation/networking/filter.txt, except that I've changed the
> > > > content of the filter program and added a timeout on the socket.
> > > >
> > > > To reproduce the problem:
> > > >
> > > > # gcc test.c -o test
> > > > # sudo ./test
> > > > ... and in another console start a large network operation.
> > > >
> > > > In my case, I copied a ~300MB core file I had lying around to another
> > > > host on the LAN.  The test code should print the string "Failed to
> > > > read from socket" 100 times.  In practice, it produces about 10%
> > > > "Received packet with ethertype..." messages.
> > > >
> > > > I've observed the same result on Ubuntu amd64 glibc system running a
> > > > 5.9.0 kernel and also on Alpine arm64v8 muslc system running a 4.9.1
> > > > kernel.  I've written test code in both C and Python.  I'm fairly sure
> > > > this is not something I'm doing wrong - but very keen to have things
> > > > thrown at me if it is.
> > > >
> > > > Regards,
> > > > Tom Cook
> > > >
> > > >
> > > > #include <stdio.h>
> > > > #include <sys/socket.h>
> > > > #include <sys/types.h>
> > > > #include <arpa/inet.h>
> > > > #include <linux/if_ether.h>
> > > > #include <linux/filter.h>
> > > > #include <stdint.h>
> > > > #include <unistd.h>
> > > >
> > > > struct sock_filter code[] = {
> > > >     { 0x06,    0,    0,    0x00 }  /* BPF_RET | BPF_K   0   0   0 */
> > > > };
> > > >
> > > > struct sock_fprog bpf = {
> > > >     .len = 1,
> > > >     .filter = code,
> > > > };
> > > >
> > > > void test() {
> > > >     uint8_t buf[2048];
> > > >
> > > >     int sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
> > > >     if (sock < 0) {
> > > >         printf("Failed to open socket\n");
> > > >         return;
> > > >     }
> > > >     int ret = setsockopt(sock, SOL_SOCKET, SO_ATTACH_FILTER, &bpf, sizeof(bpf));
> > > >     if (ret < 0) {
> > > >         printf("Failed to set socket filter\n");
> > > >         return;
> > > >     }
> > > >     struct timeval tv = {
> > > >         .tv_sec = 1
> > > >     };
> > > >
> > > >     ret = setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
> > > >     if (ret < 0) {
> > > >         printf("Failed to set socket timeout\n");
> > > >         return;
> > > >     }
> > > >
> > > >     ssize_t count = recv(sock, buf, 2048, 0);
> > > >     if (count <= 0) {
> > > >         printf("Failed to read from socket\n");
> > > >         return;
> > > >     }
> > > >
> > > >     close(sock);
> > > >
> > > >     uint16_t *ethertype = (short*)(buf + 12);
> > > >     uint8_t *proto = (unsigned char *)(buf + 23);
> > > >     uint16_t *dport = (uint16_t *)(buf + 14 + 20);
> > > >
> > > >     printf("Received packet with ethertype 0x%04hu, protocol 0x%02hhu
> > > > and dport 0x%04hu\n", *ethertype, *proto, *dport);
> > > > }
> > > >
> > > > int main() {
> > > >     for (size_t ii = 0; ii < 100; ++ii) {
> > > >         test();
> > > >     }
> > > > }
