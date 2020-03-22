Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298D718E969
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCVOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:40:42 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36323 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCVOkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 10:40:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id m33so9433521qtb.3
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 07:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbuzn9SLw2NUrqeprI9MBPQMWBaefdhL42AZ9dMd5wA=;
        b=s5VBw+AfjmQPlT58+yFQGkDe+SVKoZCGkJwmmWPie18VOyHUwBpyg2xDVY9HA5vEmG
         suE0IBpIkQwJ1kEZF9vUMBAID6MjmGlZnyajmUqu8W1StjyhyRX3qFHVv+6UIzKwbLia
         XYOAWe4oFtbCkZu4tWzIXO36HfwvH+V3brLP1QF7q1l4qIcsuqcLdMV79I6tNgPTopKc
         2uIhk2y3ldZ41CbcGdFOF7aQdeYIdoAxYNX0Ge8iDtAYB54ZL8b8YU4VhSKm+g6b9bOm
         zXA6Qzwenv+RDI99qyfFhpo1BQ0qfATOD3ZDGDp2fOhTZtY/kuvGaKdPYsyQTPWeIZFh
         bHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbuzn9SLw2NUrqeprI9MBPQMWBaefdhL42AZ9dMd5wA=;
        b=AWx0OhtcfXRjmhYea0mxcXEzbVU9qsQRHo83Ogy6maUiHDL0Lfd13wG3DVmn4G4E3x
         NbGc8v/b2wYjJVED23lREVTl0gWJjlw2WCLBhr660ktqcAMrQzgc5erN87055qxRT8K9
         7ZBtlDiK5t8hNkvmnZhyQIKNW0d2W6+nICvODrtxMJ3txI2VUKw9xKUsjygX3ECGl0ek
         U3HQXYRy4P2/r0xwo3RqzMr23yI8eIx4Exkdqsnlc8pZ/LTcLR/nQiuGJoJHV4kKgh3L
         hVxfb6vaOsZu0Sw49bdwPE4XUzIhFsx64b97htFbxd4Y/tAIdz8SnXOMc1+BYTLo5RN0
         VUrw==
X-Gm-Message-State: ANhLgQ3kp3uaIvikqgdIRKD4ExuNffTVvUv7M+mmLHkz+9xm59VwoZAV
        geBeZlJGpnmXO4KQSN9D4DYFJQNE
X-Google-Smtp-Source: ADFU+vup2+EecBsi+GIhjZRTWfaqka68QpMttlYp6J6znwOurJTWkIf6owW/XgO42Wmpk7iBeK6eog==
X-Received: by 2002:ac8:33d2:: with SMTP id d18mr16439536qtb.325.1584888038924;
        Sun, 22 Mar 2020 07:40:38 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id t43sm9911902qtc.14.2020.03.22.07.40.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 07:40:37 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id g206so5514467ybg.11
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 07:40:37 -0700 (PDT)
X-Received: by 2002:a25:ef06:: with SMTP id g6mr26300259ybd.53.1584888036856;
 Sun, 22 Mar 2020 07:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200313.110542.570427563998639331.davem@davemloft.net> <1584434318-27980-1-git-send-email-kyk.segfault@gmail.com>
In-Reply-To: <1584434318-27980-1-git-send-email-kyk.segfault@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 22 Mar 2020 10:40:00 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc0Acy4J8yTraD+_yS4juWVBFjOk4cgqaB7jzOuq_9sig@mail.gmail.com>
Message-ID: <CA+FuTSc0Acy4J8yTraD+_yS4juWVBFjOk4cgqaB7jzOuq_9sig@mail.gmail.com>
Subject: Re: [PATCH v3] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     Yadu Kishore <kyk.segfault@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 4:39 AM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
>
> > I think you can rebase and submit against net-next.
>
> > If your patch isn't active in the networking development patchwork instance,
> > it is not pending to be applied and you must resend it.
>
> Rebasing the patch on net-next and resending it.
>
> Problem:
> TCP checksum in the output path is not being offloaded during GSO
> in the following case:
> The network driver does not support scatter-gather but supports
> checksum offload with NETIF_F_HW_CSUM.
>
> Cause:
> skb_segment calls skb_copy_and_csum_bits if the network driver
> does not announce NETIF_F_SG. It does not check if the driver
> supports NETIF_F_HW_CSUM.
> So for devices which might want to offload checksum but do not support SG
> there is currently no way to do so if GSO is enabled.
>
> Solution:
> In skb_segment check if the network controller does checksum and if so
> call skb_copy_bits instead of skb_copy_and_csum_bits.
>
> Testing:
> Without the patch, ran iperf TCP traffic with NETIF_F_HW_CSUM enabled
> in the network driver. Observed the TCP checksum offload is not happening
> since the skbs received by the driver in the output path have
> skb->ip_summed set to CHECKSUM_NONE.
>
> With the patch ran iperf TCP traffic and observed that TCP checksum
> is being offloaded with skb->ip_summed set to CHECKSUM_PARTIAL.
> Also tested with the patch by disabling NETIF_F_HW_CSUM in the driver
> to cover the newly introduced if-else code path in skb_segment.
>
> Link: https://lore.kernel.org/netdev/CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com
> Signed-off-by: Yadu Kishore <kyk.segfault@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Given that there are multiple micro architectures on which this is
apparently a win, it makes sense (even if we should also optimize
those arch specific csum codes).

The tricky part here is not the basic operation, but how this behaves
with the skb_gso_cb infra for handling multiple checksums, some of
which may be computed in software, such as with remote checksum
offload.

In the case of CHECKSUM_PARTIAL the csum is not computed. Inner
most segmentation protocols (tcp/udp) will call gso_reset_checksum on
return from skb_segment to set up these skb_gso_cb fields. So this
looks correct to me.
