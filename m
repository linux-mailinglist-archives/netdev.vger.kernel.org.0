Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B3920EA53
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgF3AhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgF3AhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:37:11 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0C6C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:37:10 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so18723266ejb.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oTe2gNWswRUUhm7dbYrh27eAzJGPirzZ56H26Rzxdn8=;
        b=Yl0KBFizuQFvHCDc/mywWXO0dmY7PkLMg0LTzzV7fC6l84I3P0Uxl/BBYpbLbTOPxT
         JX00zu/9Xl4OLwfHuds08DrOWm7d8hkZ2U1Ox2N1qWAs+HCgh4zTFXHDh2rDPDuA2flf
         27H0QKzLeeJyPfZV+jljmZvJSbVWDGr75uoSnf7ICGC83ddyebg71iNzHONBUHkBZeRU
         Ic4UmiN/Ig75vjNdF4/4WXgiyAT+k2lybCh5FNMy1Ok/TniHIpBc84T0Wsg4tU24jwd4
         kpQ5vVYbpUZzhQ5GwPZLUk5b1ahdvu/F++qEIu9zRwqh7zs5PueShHF515DaTvvegUN/
         76Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oTe2gNWswRUUhm7dbYrh27eAzJGPirzZ56H26Rzxdn8=;
        b=P7kFJ3kxq8MC56NVaHYfLCPMPGLAMnGAGV+H8Q0zXGblTtdJaIoaIPo6sE60JyoAj7
         ciJnyPNTD8AidIBrVXlWbXUswwR9qShg6Zz+85/427kf4ADZY6ucg+5IDwphD7RmASEi
         hCfejAGoIy/UZ5MEf3Tkx1J3NZ/s/DqGIlAvZaNMWLo7DcBc47vGlGCgnILI+glxaoMq
         yOFE9/jYytEUEBDD3/bI0P5pjg45ZEFVSE1JwxCJM7zmxOBRL7r8t/TNoOqZx8oFlKUI
         exKMNQhpashe8hd0i8wI4V5v0ZaA21wpotHLYtIoNbPiYg/zDa4/D92OTaOef/ABYm+l
         3jkw==
X-Gm-Message-State: AOAM531rUAMgeaY7h/1hFwgVU3TBBmh+7ZbXU0Fn8vBx4dLK92jER1YM
        fh6WJ7dVrEpUvQAZRiasJjUsSh8wI0WPUd7SeLKctEzu
X-Google-Smtp-Source: ABdhPJyNPwIJJu+sjB4fDoQM96s4qaLHzYwb5LQUzi5k1YzYXEPWxDfuB4wcRS/RjkuQYe7YHmKP4lPCoTeADYYPQuA=
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr16173149ejy.138.1593477429125;
 Mon, 29 Jun 2020 17:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com> <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
 <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com>
In-Reply-To: <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 29 Jun 2020 17:36:58 -0700
Message-ID: <CALx6S37vDy=0rCC7FPrgfi9NUr0w9dVvtRQ3LhiZ7GqoX4xBPw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 4:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/29/20 2:30 PM, Willem de Bruijn wrote:
> > On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> >>> From: Willem de Bruijn <willemb@google.com>
> >>>
> >>> ICMP messages may include an extension structure after the original
> >>> datagram. RFC 4884 standardized this behavior.
> >>>
> >>> It introduces an explicit original datagram length field in the ICMP
> >>> header to delineate the original datagram from the extension struct.
> >>>
> >>> Return this field when reading an ICMP error from the error queue.
> >>
> >> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
> >> second word of icmp header.
> >>
> >> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
> >>
> >> Should we add an element in the union to make this a little bit more explicit/readable ?
> >>
> >> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> >> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
> >> --- a/include/uapi/linux/icmp.h
> >> +++ b/include/uapi/linux/icmp.h
> >> @@ -76,6 +76,7 @@ struct icmphdr {
> >>                 __be16  sequence;
> >>         } echo;
> >>         __be32  gateway;
> >> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
> >>         struct {
> >>                 __be16  __unused;
> >>                 __be16  mtu;
> >
> > Okay. How about a variant of the existing struct frag?
> >
> > @@ -80,6 +80,11 @@ struct icmphdr {
> >                 __be16  __unused;
> >                 __be16  mtu;
> >         } frag;
> > +       struct {
> > +               __u8    __unused;
> > +               __u8    length;
> > +               __be16  mtu;
> > +       } rfc_4884;
> >         __u8    reserved[4];
> >    } un;
> >
>
> Sure, but my point was later in the code :
>
> >>> +     if (inet_sk(sk)->recverr_rfc4884)
> >>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
> >>
> >> ntohl(icmp_hdr(skb)->un.second_word);
>
> If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
> reading linux kernel code to understand why we do this.
>
It's also potentially problematic. The other bits are Unused, which
isn't the same thing as necessarily being zero. Userspace might assume
that info is the length without checking its bounded.

>
