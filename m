Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B30A7BD1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfIDGjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:39:37 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:32930 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDGjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:39:36 -0400
Received: by mail-ot1-f66.google.com with SMTP id p23so19536917oto.0;
        Tue, 03 Sep 2019 23:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CiTEvMacHMcz5KgIJIStryb30Nvcfi9N11uorEQ1Wwc=;
        b=Jw2OqgO+BOi8+M5wPtkN1Td3wmkXhq0pvtEQiVpxk0H+Uis7Zlj2G/e7ukcInlKLe8
         A/RIGkhyMhy+kf20S/d6+jqTYyzITPw7iJ7F/OooswonKa7Y8ddaRdBbvVgcdQt091JS
         SItQaL2F8pfINvA58ogE4LSTti5RrYfEZKqxWNHYGt3m5QECA2dusgqUo8VbTTNdghJN
         vEHW4L1OzPjUdPcB4547MwMEFOSR7tbk1JwK5yT+r+LtABqRECrsgKgOdNlosdZW/sbY
         aHoXD3/J5s7W/tnQ9k1e48llA0ivjNvx5cjS3DA2b9aoRg4tL9h5ogqUNSvLtE2JfCft
         FAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CiTEvMacHMcz5KgIJIStryb30Nvcfi9N11uorEQ1Wwc=;
        b=LSgZooVfexceVGnA/ePrIk2Zzd8kIt1i4peXel6d+lW5GspG63obHQ2arIckzY/io2
         /4UUAO9gHEAi6Ypfu7N5Zv3jRPcH7J+TobGajohw7epSIJkSvCwrWx0XtYfeHosBhGgR
         9N5Er2P6zvgOvHRK3I6q2n/9lLaHM9nk32KyJeHny5C0Rwnmketb9XacFFBajcZ525Du
         TsPyHQk+OFY35074VJNijIjAzEjaMbHfnwlj6bravGPdtPZ/p+tawj0uFjJE1XYM1EvM
         IN4zmx/lnQUaaYeV/4DJvzp6rwVogUllP+uWqi4WZhTovL2C+3rhmuULRanZpH5Z2M1W
         dt1w==
X-Gm-Message-State: APjAAAXqBDt1Q5BtqxeHxxgtj1xAJ8bNP9O42SahnYdHQ+PV3mulL57O
        4iGxCFyCC5QBC1Sgnc4/TFQYVrgD09oIE64DgFM=
X-Google-Smtp-Source: APXvYqyrcgEk6qanS2YcMIOXi6IKymklHzxppBKvk02XBolrZOMr1uin0BCqVicxV/XjBSK3PjZ5WAv9PpPa5XrDWhI=
X-Received: by 2002:a9d:6256:: with SMTP id i22mr4151279otk.139.1567579175754;
 Tue, 03 Sep 2019 23:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <1554792253-27081-1-git-send-email-magnus.karlsson@intel.com>
 <1554792253-27081-3-git-send-email-magnus.karlsson@intel.com> <xunyo9007hk9.fsf@redhat.com>
In-Reply-To: <xunyo9007hk9.fsf@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 4 Sep 2019 08:39:24 +0200
Message-ID: <CAJ8uoz2LEun-bjUYQKZdx9NbLBOSRGsZZTWAp10=vhiP7Dms9g@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: remove dependency on barrier.h in xsk.h
To:     Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 7:32 AM Yauheni Kaliuta
<yauheni.kaliuta@redhat.com> wrote:
>
> Hi, Magnus!
>
> >>>>> On Tue,  9 Apr 2019 08:44:13 +0200, Magnus Karlsson  wrote:
>
>  > The use of smp_rmb() and smp_wmb() creates a Linux header dependency
>  > on barrier.h that is uneccessary in most parts. This patch implements
>  > the two small defines that are needed from barrier.h. As a bonus, the
>  > new implementations are faster than the default ones as they default
>  > to sfence and lfence for x86, while we only need a compiler barrier in
>  > our case. Just as it is when the same ring access code is compiled in
>  > the kernel.
>
>  > Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
>  > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>  > ---
>  >  tools/lib/bpf/xsk.h | 19 +++++++++++++++++--
>  >  1 file changed, 17 insertions(+), 2 deletions(-)
>
>  > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>  > index 3638147..317b44f 100644
>  > --- a/tools/lib/bpf/xsk.h
>  > +++ b/tools/lib/bpf/xsk.h
>  > @@ -39,6 +39,21 @@ DEFINE_XSK_RING(xsk_ring_cons);
>  >  struct xsk_umem;
>  >  struct xsk_socket;
>
>  > +#if !defined bpf_smp_rmb && !defined bpf_smp_wmb
>  > +# if defined(__i386__) || defined(__x86_64__)
>  > +#  define bpf_smp_rmb() asm volatile("" : : : "memory")
>  > +#  define bpf_smp_wmb() asm volatile("" : : : "memory")
>  > +# elif defined(__aarch64__)
>  > +#  define bpf_smp_rmb() asm volatile("dmb ishld" : : : "memory")
>  > +#  define bpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
>  > +# elif defined(__arm__)
>  > +#  define bpf_smp_rmb() asm volatile("dmb ish" : : : "memory")
>  > +#  define bpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
>  > +# else
>  > +#  error Architecture not supported by the XDP socket code in libbpf.
>  > +# endif
>  > +#endif
>  > +
>
> What about other architectures then?

AF_XDP has not been tested on anything else, as far as I know. But
contributions that extend it to more archs are very welcome.

/Magnus

>
>  >  static inline __u64 *xsk_ring_prod__fill_addr(struct xsk_ring_prod *fill,
>  >                                            __u32 idx)
>  >  {
>  > @@ -119,7 +134,7 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, size_t nb)
>  >      /* Make sure everything has been written to the ring before signalling
>  >       * this to the kernel.
>  >       */
>  > -    smp_wmb();
>  > +    bpf_smp_wmb();
>
>  >      *prod->producer += nb;
>  >  }
>  > @@ -133,7 +148,7 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
>  >              /* Make sure we do not speculatively read the data before
>  >               * we have received the packet buffers from the ring.
>  >               */
>  > -            smp_rmb();
>  > +            bpf_smp_rmb();
>
>  >              *idx = cons->cached_cons;
>  cons-> cached_cons += entries;
>  > --
>  > 2.7.4
>
>
> --
> WBR,
> Yauheni Kaliuta
