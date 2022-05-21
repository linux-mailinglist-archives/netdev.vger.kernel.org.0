Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0515B52F6AF
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354182AbiEUASk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236743AbiEUASh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:18:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC8D1900EF;
        Fri, 20 May 2022 17:18:36 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i27so18269388ejd.9;
        Fri, 20 May 2022 17:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kM3OJDwIslvJlnWNrIl5NE5xFr9ef8ObV315m3v55rA=;
        b=XjWgEUO9MyF/ovVLAe9j/svrxlMHsPZ2np9duDNqsWlwCogi89DiUAJ1fP+ZZ4fYyG
         H2RkczjFvHHmPu6kp4pmPtslZBkcYlzUJ8ZepRYj79FLe8GwOQiWIf+2dzZusy6LBuvY
         LzXFs7PVRPbn6kcrofliShbVIWfCYbXs1RmMMKNiR9jut1u0wZBoiNEijLnCcqQhxPSu
         xfxILYI1IxaLP45CZPS5lKnDYOuC+cEpFJbgRanqU6w7Laj+zzTbQSo6cHlOj5kvqo8L
         4yc9mU/hNor0sq2lL5CHXguAPHL35uGFeerlxcyDJPvW+StWOOI2qu8qewWFE5RgQJk/
         7+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kM3OJDwIslvJlnWNrIl5NE5xFr9ef8ObV315m3v55rA=;
        b=3OpeZ/elT7B2e7hE4LyC+RS1+r6d+KA8U09taMS8Rt6Rdtq/DzYC+joiQXKUxnWQNB
         YCBNHV+VxY07VCgds3StzHxUCInevhX9Q1OQDU1D6rwRRV6uQIoIQZxGpRw3K4qs+fdI
         DdvjOuYBV40dC1cPpJ6bZAMjwevhebOx28kT106nHH8Sbyo+A1URuuba1As3vHv2HB2j
         6L6NiFo/6FIWdzc+R4sP+epak8jjFehyIQRMuaaL7nCLv3n7+XKiktoamYL1JGo7aNnx
         0acFbUv2zRUS9/eop0TEQvcc61Gp2KG2QibxMA4juApYxy2X1Q7wIDdV74MmW2vUg/TU
         kp1g==
X-Gm-Message-State: AOAM530LWl17MfSmF7yNVSrBSlAYglsj8FS8L8LSTHZ5yEo/0uMPXU2E
        pr7DneuuuEBB/M+vLdgHXZ8L0OPqO15VnLwtnts=
X-Google-Smtp-Source: ABdhPJyAIwUtbMfms0jB0bpJ5a6HWEhVHfH/r19ZJ0jbxxU+WJCMlbdYTBoMYvJMVxmAehTN2HKurc6gf1A+eAK0/fg=
X-Received: by 2002:a17:906:9b8b:b0:6fe:55db:14e with SMTP id
 dd11-20020a1709069b8b00b006fe55db014emr10904327ejc.327.1653092314979; Fri, 20
 May 2022 17:18:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <YoX7iHddAd4FkQRQ@infradead.org> <YoX904CAFOAfWeJN@kroah.com>
 <YoYCIhYhzLmhIGxe@infradead.org> <CAO-hwJL4Pj4JaRquoXD1AtegcKnh22_T0Z0VY_peZ8FRko3kZw@mail.gmail.com>
 <87ee0p951b.fsf@toke.dk> <CAO-hwJKwj6H0Nc_gqsN5okT2ipLL3H6fqe23_vpO+xC3PnX5uw@mail.gmail.com>
In-Reply-To: <CAO-hwJKwj6H0Nc_gqsN5okT2ipLL3H6fqe23_vpO+xC3PnX5uw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 May 2022 17:18:22 -0700
Message-ID: <CAADnVQ+Qj9Farf-bp4STpe0P+=7Xr2Hqxm5Tru5bLCyPiBJMqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 4:56 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> As Greg mentioned in his reply, report descriptors fixups don't do
> much besides changing a memory buffer at probe time. So we can either
> have udev load the program, pin it and forget about it, or we can also
> have the kernel do that for us.
>
> So I envision the distribution to be hybrid:
> - for plain fixups where no userspace is required, we should
> distribute those programs in the kernel itself, in-tree.
> This series already implements pre-loading of BPF programs for the
> core part of HID-BPF, but I plan on working on some automation of
> pre-loading of these programs from the kernel itself when we need to
> do so.
>
> Ideally, the process would be:
> * user reports a bug
> * developer produces an eBPF program (and maybe compile it if the user
> doesn't have LLVM)
> * user tests/validates the fix without having to recompile anything
> * developer drops the program in-tree
> * some automated magic happens (still unclear exactly how to define
> which HID device needs which eBPF program ATM)
> * when the kernel sees this exact same device (BUS/VID/PID/INTERFACE)
> it loads the fixup
>
> - the other part of the hybrid solution is for when userspace is
> heavily involved (because it exports a new dbus interface for that
> particular feature on this device). We can not really automatically
> preload the BPF program because we might not have the user in front of
> it.
> So in that case, the program would be hosted alongside the
> application, out-of-the-tree, but given that to be able to call kernel
> functions you need to be GPL, some public distribution of the sources
> is required.

Agree with everything you've said earlier.
Just one additional comment:
By default the source code is embedded in bpf objects.
Here is an example.
$ bpftool prog dump jited id 3927008|head -50
void cwnd_event(long long unsigned int * ctx):
bpf_prog_9b9adc0a36a25303_cwnd_event:
; void BPF_STRUCT_OPS(cwnd_event, struct sock* sk, enum tcp_ca_event ev) {
   0:    nopl   0x0(%rax,%rax,1)
   5:    xchg   %ax,%ax
...
; switch (ev) {
  25:    mov    %r14d,%edi
  28:    add    $0xfffffffc,%edi
...
; ca->loss_cwnd = tp->snd_cwnd;
  4a:    mov    %edi,0x18(%r13)
  4e:    mov    $0x2,%edi
; tp->snd_ssthresh = max(tp->snd_cwnd >> 1U, 2U);
  53:    test   %rbx,%rbx
  56:    jne    0x000000000000005c

It's not the full source, of course, but good enough in practice
for a person to figure out what program is doing.
