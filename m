Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B1A2745
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 21:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfH2T1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 15:27:25 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40382 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbfH2T1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 15:27:25 -0400
Received: by mail-yb1-f195.google.com with SMTP id t15so1589379ybg.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 12:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQOj6BbuL8gltwL5tVv1aLVyp4tadzEBc6dYMGGH+48=;
        b=VxOwFL15Md3N3DY/H6L3wNnxsukpqDHlo5vLkD17S1KiHOFNg/DomqGDC7DAmBpruG
         FPWSN/mR4b9EpaGOsAwMqUbRXfSZG+2y+xPFd3hq/vlfU273NbdDkfECyAVS1eP38BnB
         nAwuWNbndCmHhX94nX6uwnSRAJMDYlhfo/EfHTkak1vcWbchcfD7C6elEMm2B6GSuTy8
         jsM5oHHNXsSH/jjZCfdzI6ewyUmfMOwu/T2Y62yUOKkfJz+0frTI/RctHMOc3OCfvU28
         YhxEu359uDCXRfKW40i35hAVXe0JLv1jIEjTggY5n9+5tVSHzeuGW6gypZrNAetNPAEu
         IzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQOj6BbuL8gltwL5tVv1aLVyp4tadzEBc6dYMGGH+48=;
        b=MMuRIMbzoZISmXA5RSFCUC6n2he3o1sdftX51z8qbg1YFBmKnGqNsJDhaqVol0ShfG
         UxK/sYcg9jJmyrEd5tOhqKmxxUwQRAn/fViSGm8zZyq6dCIz/G9nv/oDQohFFgVEegDL
         yL0lt4hcuhhK39nCPsb1BArLGXuxvLIme7bHYbw2UM5WD1o+PosriWOJvGiv0OqZaKki
         l7AmWtyCtUs7QW95vNsdFI/EyD9Tm+kptD8I0GmvsXmHWnsMVnM2oPdCzb0odYji5iG+
         pUKK15gPHreRYmMGLewkHJino1U3lcC6aUzk3TQ8yMd4+1zqdXRHWmS/3QGcv/Ol+zf0
         lR1Q==
X-Gm-Message-State: APjAAAVOUaqMtN8MSPPD6AtZgXQ9MFetHDc8AAcuYH9KQVDQKuLu5nZn
        W/Vw5iE7ZPhskaeke/4JsgmqRso+
X-Google-Smtp-Source: APXvYqwJ31nf9ZfwhUu9N170EzwWL7BVQlgig0Eg8NuQJonEemDvmqZkBb+LIvAbuMrRuvFSS06Ijw==
X-Received: by 2002:a25:778f:: with SMTP id s137mr8259307ybc.245.1567106843728;
        Thu, 29 Aug 2019 12:27:23 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id b138sm718855ywe.62.2019.08.29.12.27.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2019 12:27:21 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id z64so1545711ywe.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 12:27:20 -0700 (PDT)
X-Received: by 2002:a81:2849:: with SMTP id o70mr4076901ywo.389.1567106840129;
 Thu, 29 Aug 2019 12:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net>
In-Reply-To: <01db01d559e5$64d71de0$2e8559a0$@net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Aug 2019 15:26:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
Message-ID: <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
To:     Steve Zabele <zabele@comcast.net>
Cc:     Network Development <netdev@vger.kernel.org>, shum@canndrew.org,
        vladimir116@gmail.com, saifi.khan@datasynergy.org,
        saifi.khan@strikr.in, Daniel Borkmann <daniel@iogearbox.net>,
        on2k16nm@gmail.com, Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 3:11 PM Steve Zabele <zabele@comcast.net> wrote:
>
> Hi folks,
>
> Is there a way to find out where the SO_REUSEPORT bug reported a year ago in
> August (and apparently has been a bug with kernels later than 4.4) is being
> addressed?
>
> The bug characteristics, simple standalone test code demonstrating the bug,
> and an assessment of the likely location/cause of the bug within the kernel
> are all described here
>
> https://bugzilla.kernel.org/show_bug.cgi?id=200755
>
> I'm really hoping this gets fixed so we can move forward on updating our
> kernels/Ubuntu release from our aging 4.4/16.04 release
>
> Thanks!
>
> Steve
>
>
>
> -----Original Message-----
> From: Stephen Hemminger [mailto:stephen@networkplumber.org]
> Sent: Tuesday, July 16, 2019 10:03 AM
> To: Steve Zabele
> Cc: shum@canndrew.org; vladimir116@gmail.com; saifi.khan@DataSynergy.org;
> saifi.khan@strikr.in; daniel@iogearbox.net; on2k16nm@gmail.com
> Subject: Re: Is bug 200755 in anyone's queue??
>
> On Tue, 16 Jul 2019 09:43:24 -0400
> "Steve Zabele" <zabele@comcast.net> wrote:
>
>
> > I came across bug report 200755 trying to figure out why some code I had
> > provided to customers a while ago no longer works with the current Linux
> > kernel. See
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=200755
> >
> > I've verified that, as reported, 'connect' no longer works for UDP.
> > Moreover, it appears it has been broken since the 4.5 kernel has been
> > released.
> >
> >
> >
> > It does also appear that the intended new feature of doing round robin
> > assignments to different UDP sockets opened with SO_REUSEPORT also does
> not
> > work as described.
> >
> >
> >
> > Since the original bug report was made nearly a year ago for the 4.14
> kernel
> > (and the bug is also still present in the 4.15 kernel) I'm curious if
> anyone
> > is on the hook to get this fixed any time soon.
> >
> >
> >
> > I'd rather not have to do my own demultiplexing using a single socket in
> > user space to work around what is clearly a (maybe not so recently
> > introduced) kernel bug if at all possible. My code had worked just fine on
> > 3.X kernels, and appears to work okay up through 4.4.
> >
>
> Kernel developers do not use bugzilla, I forward bug reports
> to netdev@vger.kernel.org (after filtering).

SO_REUSEPORT was not intended to be used in this way. Opening
multiple connected sockets with the same local port.

But since the interface allowed connect after joining a group, and
that is being used, I guess that point is moot. Still, I'm a bit
surprised that it ever worked as described.

Also note that the default distribution algorithm is not round robin
assignment, but hash based. So multiple consecutive datagrams arriving
at the same socket is not unexpected.

I suspect that this quick hack might "work". It seemed to on the
supplied .c file:

                  score = compute_score(sk, net, saddr, sport,
                                        daddr, hnum, dif, sdif);
                  if (score > badness) {
  -                       if (sk->sk_reuseport) {
  +                       if (sk->sk_reuseport && !sk->sk_state !=
TCP_ESTABLISHED) {

But a more robust approach, that also works on existing kernels, is to
swap the default distribution algorithm with a custom BPF based one (
SO_ATTACH_REUSEPORT_EBPF).
