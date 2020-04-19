Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB51AFEC2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgDSWyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgDSWyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 18:54:45 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B04DC061A0C;
        Sun, 19 Apr 2020 15:54:45 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e25so7906864ljg.5;
        Sun, 19 Apr 2020 15:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntM046E5HJcxfBlLPk1ijgLAx/PfjNLAWCb2+sKhF6g=;
        b=T5Vdob4uZO1ZuUEwYJZdWwf9Lecw6L4+jWONz47OoLBNhf+qzdvkT+F9D36N/UmBEp
         6x5aWGTfUaJlFF3CNnFU1gC3MpKROP+zL6qfY4YWU3zlDCYQVa1YeoA7YTZcWJB9ppCO
         J+uVJ0jDiWBvrctM8GsM8/iD8oWfj+KQymjM/CKqdCVaMOneTEfkO8dWVVdquCXENnLt
         N9COwt2yuyHqkASkZQZ18Pojgdvq5KtwlAIUNfZ9oQpn+4BX7Q2+0Hm9hZKM1Z/jhr2G
         +HyuYZ752pEqCZXBgKtrNTzWi/4SMBPX/Xrrwz+dC0PTSygUAOXk1acOEl3gQR9RMfpK
         uyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntM046E5HJcxfBlLPk1ijgLAx/PfjNLAWCb2+sKhF6g=;
        b=kF1b1I6DIgvliGIa9BJfL8fRUK8V8gIiLmT7maJr2BvSPCgI5vLplDbCb/OgeqND7v
         N029bN0Ng2X40Szq9AQD7UWoF7XihzqjDHCLvIelV5HdRppaNdaEfYAQoFOpddjN+6mP
         ISWyZT78HnF7siO4SpE355dKCMSA5rVu1EOyBm/CRAtNdzxuJCcqVVrwgcsU4dukKYn+
         DPUhp5j3nxUk4PF+6jyiLxsXdpcu3jIdFS414WMRDpEcI0HcvvrriA/EWKVw/Ik/yk1y
         NQ96drK+2UxLUMmE2NAiapZv8gHLBxocYNZJmqjrJ1XmpsNoaCFuDsef79H8gb5q3ysG
         h9ng==
X-Gm-Message-State: AGi0PuYNA3HS8l08fQpJ2nI/HujiDoQW9Hwq7eZEWrhUtrSuJBPebOlr
        7C1RZekUIU6PwbKRYLPF4V7sPhiY8m1tsmJApZE=
X-Google-Smtp-Source: APiQypJTq9Ajt1NL5ar5ugl7gEQC+QRSCd1RbxDw+TPEaCRakCE8oAn8GdSGBHBSzrHu/bfQp10eWfYCm0WhLDod7T4=
X-Received: by 2002:a2e:9011:: with SMTP id h17mr8598280ljg.138.1587336883900;
 Sun, 19 Apr 2020 15:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com> <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
 <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
In-Reply-To: <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 19 Apr 2020 15:54:32 -0700
Message-ID: <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
To:     Yonghong Song <yhs@fb.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 12:02 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/20 5:45 AM, Eelco Chaudron wrote:
> >
> >
> > On 23 Mar 2020, at 23:47, Yonghong Song wrote:
> >
> >> On 3/18/20 6:06 AM, Eelco Chaudron wrote:
> >>> I sent out this RFC to get an idea if the approach suggested here
> >>> would be something other people would also like to see. In addition,
> >>> this cover letter mentions some concerns and questions that need
> >>> answers before we can move to an acceptable implementation.
> >>>
> >>> This patch adds support for tracing eBPF XDP programs that get
> >>> executed using the __BPF_PROG_RUN syscall. This is done by switching
> >>> from JIT (if enabled) to executing the program using the interpreter
> >>> and record each executed instruction.

sorry for delay. I only noticed these patches after Yonghong replied.

I think hacking interpreter to pr_info after every instruction is too
much of a hack.
Not working with JIT-ed code is imo red flag for the approach as well.
When every insn is spamming the logs the only use case I can see
is to feed the test program with one packet and read thousand lines dump.
Even that is quite user unfriendly.

How about enabling kprobe in JITed code instead?
Then if you really need to trap and print regs for every instruction you can
still do so by placing kprobe on every JITed insn.
But in reality I think few kprobes in the prog will be enough
to debug the program and XDP prog may still process millions of packets
because your kprobe could be in error path and the user may want to
capture only specific things when it triggers.
kprobe bpf prog will execute in such case and it can capture necessary
state from xdp prog, from packet or from maps that xdp prog is using.
Some sort of bpf-gdb would be needed in user space.
Obviously people shouldn't be writing such kprob-bpf progs that debug
other bpf progs by hand. bpf-gdb should be able to generate them automatically.
