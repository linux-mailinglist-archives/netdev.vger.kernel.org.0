Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30462AFB20
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgKKWLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKKWLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:11:10 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72942C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 14:11:10 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id f16so3636091otl.11
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 14:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9x7wCbtY2INGT4mWRl0KvmqgIV/hjiwKY1LPvLcycNs=;
        b=NskwSL17Ngg/zzNNWEJ4Dvh0u4Ont+Nt6hU/Kso0zDKJMivzcN+ZqcYA2eK1AZs0Md
         bIkBveu4D8zel0q5dRG27kR+TKbx3F9gKg1GNJ5oyELXWCw40oIyOW2Nf0gz3TsVErGw
         ClPmzuSSVKYWfAmL0hFucD9rAsJ5tIcohc+VKX8XZY0GbEkFJsDwjW5KCdu8LaJZO7Ok
         rR3PZwrRO/I+EFFufevnpO1yTVy7HXc5xQtU44amR8lbZhQYO0AaMe0ONd5ImaF6OmB2
         SWbDJShZEMoOR0lbqYxK/ecpS4X+pAYDGSYd3It/3FcTR0ue11zVM9keXHJq9x5btCri
         PNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9x7wCbtY2INGT4mWRl0KvmqgIV/hjiwKY1LPvLcycNs=;
        b=hA9bZ/NnSV9Le0hAB1st9lKEe82A+/u1ItUPtz1Q8usbJvK352CIpLzFZheOQfyVq2
         yXrNSwhnGXHD0+NkEQIDXZ42eUToCNUiimEWbQH81yFyZ7F/n6k5GbP42ktSXp5Pszmc
         /E+VGMtB9J7EciBuy5xooKRCjdQeLF+9r4aYcaDX1zdzBi0gd16CRUdSkDoP/tnf8mtb
         cUn+fsxb+wnCNdd/KKK/JE451KDCqT8DQGkLypD6hFF8RsujLXTW7XRuWG5SeSAgHdaC
         IGRnhzK1geit99nVhJTZapEH1FM/QrQuG3yCqDZeHczlNg9seF3p0F34G/q68o/+jv6r
         wmuQ==
X-Gm-Message-State: AOAM533dr3pnMRE6ZMGhO7HUUW+Vh+6XzmqI+efNTuBB9WkfZ5mpgZKL
        Qs0B0kfLBPXB7bN4seJ4M3Oji+pybjpax7TmaHk=
X-Google-Smtp-Source: ABdhPJxTddlAk7xvzZ87gPyxScOwBI6pq3jZJ+Bgvpdz9UU87iK05vNC6RA8K3P6Yl8wfDek6SgqKoLZ96lVOFIg4ac=
X-Received: by 2002:a9d:7392:: with SMTP id j18mr19645898otk.288.1605132669149;
 Wed, 11 Nov 2020 14:11:09 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com> <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
In-Reply-To: <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Wed, 11 Nov 2020 23:10:58 +0100
Message-ID: <CAMeyCbiuQgZQTKFRbfciikTc5rSLmFCsSM9_7E73WHWRKEd6yg@mail.gmail.com>
Subject: Re: Fwd: net: fec: rx descriptor ring out of order
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 6:52 PM David Laight <David.Laight@aculab.com> wrot=
e:
>
> > On 11/11/20 3:27 PM, Kegl Rohit wrote:
> > > Hello!
> > >
> > > We are using a imx6q platform.
> > > The fec interface is used to receive a continuous stream of custom /
> > > raw ethernet packets. The packet size is fixed ~132 bytes and they ge=
t
> > > sent every 250=C2=B5s.
> > >
> > > While testing I observed spontaneous packet delays from time to time.
> > > After digging down deeper I think that the fec peripheral does not
> > > update the rx descriptor status correctly.
> > > I modified the queue_rx function which is called by the NAPI poll
> > > function. "no packet N" is printed when the queue_rx function doesn't
> > > process any descriptor.
> > > Therefore the variable N counts continuous calls without ready
> > > descriptors. When the current descriptor is ready&processed and moved
> > > to the next entry, then N is cleared again.
> > > Additionally an error is printed if the current descriptor is empty
> > > but the next one is already ready. In case this error happens the
> > > current descriptor and the next 11 ones are dumped.
> > > "C"  ... current
> > > "E"  ... empty
> > >
> > > [   57.436478 <    0.020005>] no packet 1!
> > > [   57.460850 <    0.024372>] no packet 1!
> > > [   57.461107 <    0.000257>] ring error, current empty but next is n=
ot empty
> > > [   57.461118 <    0.000011>] RX ahead
> > > [   57.461135 <    0.000017>] 129 C E 0x8840 0x2c743a40  132
> > > [   57.461146 <    0.000011>] 130     0x0840 0x2c744180  132
> > > [   57.461158 <    0.000012>] 131   E 0x8840 0x2c7448c0  132
>
> What are the addresses of the ring entries?
> I bet there is something wrong with the cache coherency and/or
> flushing.

The ring descriptors are allocated via dma_alloc_coherent().  I will
extend the dump with their addresses.
The current output shows the dma_map_single() skb data buffer.
I tried calling  flush_cache_all() before reading the descriptors
status =3D> no change.
Are there any flush options to try?


> So the MAC hardware has done the write but (somewhere) it
> isn't visible to the cpu for ages.
It looks like that. After an error occured i will also read the skb
data (dma_sync_single() before) to check if the new data is already
there.
So I can prove that the status is wrong, because the data could be
already there.


> I've seen a 'fec' ethernet block in a freescale DSP.
> IIRC it is a fairly simple block - won't be doing out-of-order writes.
>
> The imx6q seems to be arm based.
> I'm guessing that means it doesn't do cache coherency for ethernet dma
> accesses.
> That (more or less) means the rings need to be mapped uncached.
> Any attempt to just flush/invalidate the cache lines is doomed.
The descriptors are allocated using dma_alloc_coherent(). So flushes
should not be needed? Synchronizing is done via barriers e.g. wmb()
before resetting the descriptor status.
The skb data itself is mapped using the DMA API.

> ...
> > > I am suspecting the errata:
> > >
> > > ERR005783 ENET: ENET Status FIFO may overflow due to consecutive shor=
t frames
> > > Description:
> > > When the MAC receives shorter frames (size 64 bytes) at a rate
> > > exceeding the average line-rate
> > > burst traffic of 400 Mbps the DMA is able to absorb, the receiver
> > > might drop incoming frames
> > > before a Pause frame is issued.
> > > Projected Impact:
> > > No malfunction will result aside from the frame drops.
> > > Workarounds:
> > > The application might want to implement some flow control to ensure
> > > the line-rate burst traffic is
> > > below 400 Mbps if it only uses consecutive small frames with minimal
> > > (96 bit times) or short
> > > Inter-frame gap (IFG) time following large frames at such a high rate=
.
> > > The limit does not exist for
> > > frames of size larger than 800 bytes.
> > > Proposed Solution:
> > > No fix scheduled
> > > Linux BSP Status:
> > > Workaround possible but not implemented in the BSP, impacting
> > > functionality as described above.
> > >
> > > Is the "ENET Status FIFO" some internal hardware FIFO or is it the
> > > descriptor ring.
> > > What would be the workaround when a "Workaround is possible"?
>
> I don't think that is applicable.
> It looks like it just drops frames under high load.
Hm ok.

> I've no idea what a 'Linux BSP' might be.
> That term is usually used for the (often broken) board support
> for things like Vx(no-longer)Works.
Hm ok.

> > > I could only think of skipping/dropping the descriptor when the
> > > current is still busy but the next one is ready.
> > > But it is not easily possible because the "stuck" descriptor gets
> > > ready after a huge delay.
>
> I bet the descriptor is at the end of a cache line which finally
> gets re-read.

Would have cache_flush_all() solved this problem?
