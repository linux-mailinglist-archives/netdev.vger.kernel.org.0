Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C90A4FC0E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfFWOju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 10:39:50 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39059 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWOju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 10:39:50 -0400
Received: by mail-ed1-f67.google.com with SMTP id m10so17465927edv.6
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 07:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AoP0j7GGMudZVyo55fz2b+mM5P3BKT6FnEPw7slyIHM=;
        b=NfW9286rIpDV7ttPMjY6g7kZeIlmnQ+d6xwbfIszm+psGXWEqZzvITQZPKRwgdBPqd
         p9ANyu/kzanwWwpIKN2pwTl3Hy/pb66jcRrcabUpsWbPEQ5WuJd5EstJ7DU1YxX02wUp
         TMvILj+wov+rBxCJRIMzpxTIpCIa5NHU80GvL5yxaWiYWH8pYZZB2LLHOt8+PV1iavkZ
         kLKUgxCBdkAwAG+W39tBvnT48TaluBfcrBLh+z2Ske4CXnvbt5kGeJEYFjV8AiEP2240
         HdTG0r2NeOcmNNVi1vHT/ReyNM9EGDm8B8fwPBOUoaBnzB65eD7w/UsYxbmDmb/ACzzZ
         /TWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AoP0j7GGMudZVyo55fz2b+mM5P3BKT6FnEPw7slyIHM=;
        b=r9nKhCO54mFrBvP9gyeg6GEeIggncDf20gTivM/uryFXwQAOjZ9QBBpYxOJKerMSno
         1Ry8/8s2BaEr/8sScdqAMEkZ3/7/uASP5SUsHgTs0vh8LAzj87RHZWU7mSv34JNnT1SG
         TfFdUMAlfBYan8nzK+b4zurnmiM7HnmLr4yU6OIr0r54g08gzUn9hvO6sh55G7GNbcfe
         E7lQGA/344+chJULrcrOe0XMhW2lD2zAg/5v707xyilkNEbcQnLoC5/+SWJjAYKFCc2o
         /Tu2F0puOSHCJlK2DzNAJv3zSMo5v4RL8EOOKuHkNNzFhh/23KLCuQZA8lpANdGsH6AJ
         K1lw==
X-Gm-Message-State: APjAAAUVC4FdQDVDwHryfGlHIAgN4NgWMKPviRn5BVEQZbrbEspdwDv5
        h7m9vexaKUYwWQf2HwqcPe4FAcdlJuZbOIzUXLA=
X-Google-Smtp-Source: APXvYqxLfU5rPLzlFypLCRCXuJoeqtINJESSDpIVDQIo1pCkEKMAX9K9tzDHl5+SndRJD2c7ZOgNxIyN6g/WW4XhtlQ=
X-Received: by 2002:aa7:d30b:: with SMTP id p11mr119742754edq.23.1561300788115;
 Sun, 23 Jun 2019 07:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190622174154.14473-1-nhorman@tuxdriver.com>
 <CAF=yD-JC_r1vjitN1ccyvQ3DXiP9BNCwq9iiWU11cXznmhAY8Q@mail.gmail.com>
 <CAF=yD-+8NDiL0dxM+eOFyiwi1ZhCW29dW--+VeEkssUaJqedWg@mail.gmail.com> <20190623114021.GB10908@hmswarspite.think-freely.org>
In-Reply-To: <20190623114021.GB10908@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 23 Jun 2019 10:39:12 -0400
Message-ID: <CAF=yD-L5Lu6L4Ji=OZgAkDb28zL=BVsM5HgqWMxMTiJ1YUZJDw@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 7:40 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Sat, Jun 22, 2019 at 10:21:31PM -0400, Willem de Bruijn wrote:
> > > > -static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > > > +static void __packet_set_status(struct packet_sock *po, void *frame, int status,
> > > > +                               bool call_complete)
> > > >  {
> > > >         union tpacket_uhdr h;
> > > >
> > > > @@ -381,6 +382,8 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> > > >                 BUG();
> > > >         }
> > > >
> > > > +       if (po->wait_on_complete && call_complete)
> > > > +               complete(&po->skb_completion);
> > >
> > > This wake need not happen before the barrier. Only one caller of
> > > __packet_set_status passes call_complete (tpacket_destruct_skb).
> > > Moving this branch to the caller avoids a lot of code churn.
> > >
> > > Also, multiple packets may be released before the process is awoken.
> > > The process will block until packet_read_pending drops to zero. Can
> > > defer the wait_on_complete to that one instance.
> >
> > Eh no. The point of having this sleep in the send loop is that
> > additional slots may be released for transmission (flipped to
> > TP_STATUS_SEND_REQUEST) from another thread while this thread is
> > waiting.
> >
> Thats incorrect.  The entirety of tpacket_snd is protected by a mutex. No other
> thread can alter the state of the frames in the vector from the kernel send path
> while this thread is waiting.

I meant another user thread updating the memory mapped ring contents.

> > Else, it would have been much simpler to move the wait below the send
> > loop: send as many packets as possible, then wait for all of them
> > having been released. Much clearer control flow.
> >
> Thats (almost) what happens now.  The only difference is that with this
> implementation, the waiting thread has the opportunity to see if userspace has
> queued more frames for transmission during the wait period.  We could
> potentially change that, but thats outside the scope of this fix.

Agreed. I think the current, more complex, behavior was intentional.
We could still restructure to move it out of the loop and jump back.
But, yes, definitely out of scope for a fix.

> > Where to set and clear the wait_on_complete boolean remains. Integer
> > assignment is fragile, as the compiler and processor may optimize or
> > move simple seemingly independent operations. As complete() takes a
> > spinlock, avoiding that in the DONTWAIT case is worthwhile. But probably
> > still preferable to set when beginning waiting and clear when calling
> > complete.
> We avoid any call to wait_for_complete or complete already, based on the gating
> of the need_wait variable in tpacket_snd.  If the transmitting thread doesn't
> set MSG_DONTWAIT in the flags of the msg structure, we will never set
> wait_for_complete, and so we will never manipulate the completion queue.

But we don't know the state of this at tpacket_destruct_skb time without
wait_for_completion?
