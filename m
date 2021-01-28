Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F603079A7
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 16:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhA1P0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 10:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhA1PYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 10:24:20 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2944C0613ED
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 07:24:04 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id g3so8339533ejb.6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 07:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=oYXRH4S0AQzyJBnluPai1Eq4DS4B78I1/IalB9BGk2U=;
        b=QoTjYd0Por8LnPvply++Tbwx72+Px+As/SufKUX/6wbDnB5/gRPLBEW3w05aD6WD+D
         u6UxmpJBKHZv9rcla2bbgVrp4Ugt/7yT6A4/6DLGSNOg7UhBY338TTuBslMf848xCouS
         g+Vyx2hS9Dnv6VR5PFsZoLF8WKv/chtywTcwPr5qXtJNDJSvl8jfTgmm3gjTTMYeDQsT
         BI71vU1zjhTOg2r/gMlFPFM1NqIxCDg5wPl9EVhorYp0PdIN3ht3IfsDz7QlMQcTxiiL
         H3EC1ol2IhrAlRF6txDEvHz3GtQ/xqA7VcBkdGgDdKdFcdrjFXcwNISK+AWfHE3T0kXL
         S6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=oYXRH4S0AQzyJBnluPai1Eq4DS4B78I1/IalB9BGk2U=;
        b=IMRBaFD77j8NSkNGUfXZkKbNxQRFvOPfKd+qGZwToyXFyH23umyF0PLnTPN+51zxtj
         wfpvq6/y3qlxfiB0BORA2gzJ3Mntrollh5jAs750YSJL5e9bX8lVRXIntknrHumas5mI
         51iML1KK1C1MehtWaX+IHWthpWuwQNfzd5qIrhnyPloOduoAWcKrxdqM8bZeVgHnsgjs
         Ce4uh8ui22vQOJFXxls7f8CviHak0EigtaXtIFJKIJZC3K3KPmWt3FtiYCjkAcijxK6b
         T0fdrAqy80jMXCzf3ZJtQgfSV94PAoqIxAvIUsZgene2wBZUruCoMhsDs7xIEVSBn+4z
         aLSg==
X-Gm-Message-State: AOAM533H1pCHUAtL/DPkw8fzo4k8WplX9DmuZx3zeN23EP51HjwcKstn
        t0YIDDY3RuEv7CkN36LfcNs=
X-Google-Smtp-Source: ABdhPJwygG38pu7c3GUaQdWNT/xwF7fHyU50T3kZjz78lTUMDJVr8LrKZ4bjTVE8LbVZe2dVs20LzQ==
X-Received: by 2002:a17:906:3885:: with SMTP id q5mr11807898ejd.105.1611847443577;
        Thu, 28 Jan 2021 07:24:03 -0800 (PST)
Received: from localhost (dslb-002-207-138-002.002.207.pools.vodafone-ip.de. [2.207.138.2])
        by smtp.gmail.com with ESMTPSA id he38sm2315263ejc.96.2021.01.28.07.24.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Jan 2021 07:24:02 -0800 (PST)
Date:   Thu, 28 Jan 2021 16:23:53 +0100
From:   Oliver Graute <oliver.graute@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>, sagi@lightbitslabs.com,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: UDP implementation and the MSG_MORE flag
Message-ID: <20210128152353.GB27281@optiplex>
Mail-Followup-To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>, sagi@lightbitslabs.com,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210126141248.GA27281@optiplex>
 <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
 <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com>
 <CAF=yD-Ja=kzq4KaraUd_dV7Z2joR009VLjhkpu8DK2DSUX-n9Q@mail.gmail.com>
 <CAF=yD-+qFQHqLaYjq4x=rGjNZf_K9FSQiV-7Toqi3np+Cbq_vA@mail.gmail.com>
 <CAF=yD-JuHy8yf88RR_=K+r_3SwhwzqRtHrK08-WF4BkwMNk-LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAF=yD-JuHy8yf88RR_=K+r_3SwhwzqRtHrK08-WF4BkwMNk-LQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/21, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 9:53 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 10:25 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Tue, Jan 26, 2021 at 5:00 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 26, 2021 at 4:54 PM Willem de Bruijn
> > > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jan 26, 2021 at 9:58 AM Oliver Graute <oliver.graute@gmai=
l.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > we observe some unexpected behavior in the UDP implementation o=
f the
> > > > > > linux kernel.
> > > > > >
> > > > > > Some UDP packets send via the loopback interface are dropped in=
 the
> > > > > > kernel on the receive side when using sendto with the MSG_MORE =
flag.
> > > > > > Every drop increases the InCsumErrors in /proc/self/net/snmp. S=
ome
> > > > > > example code to reproduce it is appended below.
> > > > > >
> > > > > > In the code we tracked it down to this code section. ( Even a l=
ittle
> > > > > > further but its unclear to me wy the csum() is wrong in the bad=
 case)
> > > > > >
> > > > > > udpv6_recvmsg()
> > > > > > ...
> > > > > > if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
> > > > > >                 if (udp_skb_is_linear(skb))
> > > > > >                         err =3D copy_linear_skb(skb, copied, of=
f, &msg->msg_iter);
> > > > > >                 else
> > > > > >                         err =3D skb_copy_datagram_msg(skb, off,=
 msg, copied);
> > > > > >         } else {
> > > > > >                 err =3D skb_copy_and_csum_datagram_msg(skb, off=
, msg);
> > > > > >                 if (err =3D=3D -EINVAL) {
> > > > > >                         goto csum_copy_err;
> > > > > >                 }
> > > > > >         }
> > > > > > ...
> > > > > >
> > > > >
> > > > > Thanks for the report with a full reproducer.
> > > > >
> > > > > I don't have a full answer yet, but can reproduce this easily.
> > > > >
> > > > > The third program, without MSG_MORE, builds an skb with
> > > > > CHECKSUM_PARTIAL in __ip_append_data. When looped to the receive =
path
> > > > > that ip_summed means no additional validation is needed. As encod=
ed in
> > > > > skb_csum_unnecessary.
> > > > >
> > > > > The first and second programs are essentially the same, bar for a
> > > > > slight difference in length. In both cases packet length is very =
short
> > > > > compared to the loopback device MTU. Because of MSG_MORE, these
> > > > > packets have CHECKSUM_NONE.
> > > > >
> > > > > On receive in
> > > > >
> > > > >   __udp4_lib_rcv()
> > > > >     udp4_csum_init()
> > > > >       err =3D skb_checksum_init_zero_check()
> > > > >
> > > > > The second program validates and sets ip_summed =3D CHECKSUM_COMP=
LETE
> > > > > and csum_valid =3D 1.
> > > > > The first does not, though err =3D=3D 0.
> > > > >
> > > > > This appears to succeed consistently for packets <=3D 68B of payl=
oad,
> > > > > fail consistently otherwise. It is not clear to me yet what causes
> > > > > this distinction.
> > > >
> > > > This is from
> > > >
> > > > "
> > > > /* For small packets <=3D CHECKSUM_BREAK perform checksum complete =
directly
> > > >  * in checksum_init.
> > > >  */
> > > > #define CHECKSUM_BREAK 76
> > > > "
> > > >
> > > > So the small packet gets checksummed immediately in
> > > > __skb_checksum_validate_complete, but the larger one does not.
> > > >
> > > > Question is why the copy_and_checksum you pointed to seems to fail =
checksum.
> > >
> > > Manually calling __skb_checksum_complete(skb) in
> > > skb_copy_and_csum_datagram_msg succeeds, so it is the
> > > skb_copy_and_csum_datagram that returns an incorrect csum.
> > >
> > > Bisection shows that this is a regression in 5.0, between
> > >
> > > 65d69e2505bb datagram: introduce skb_copy_and_hash_datagram_iter help=
er (fail)
> > > d05f443554b3 iov_iter: introduce hash_and_copy_to_iter helper
> > > 950fcaecd5cc datagram: consolidate datagram copy to iter helpers
> > > cb002d074dab iov_iter: pass void csum pointer to csum_and_copy_to_ite=
r (pass)
> > >
> > > That's a significant amount of code change. I'll take a closer look,
> > > but checkpointing state for now..
> >
> > Key difference is the csum_block_add when handling frags, and the
> > removal of temporary csum2.
> >
> > In the reproducer, there is one 13B csum_and_copy_to_iter from
> > skb->data + offset, followed by a 73B csum_and_copy_to_iter from the
> > first frag. So the second one passes pos 13 to csum_block_add.
> >
> > The original implementation of skb_copy_and_csum_datagram similarly
> > fails the test, if we fail to account for the position
> >
> > -                       *csump =3D csum_block_add(*csump, csum2, pos);
> > +                       *csump =3D csum_block_add(*csump, csum2, 0);
>=20
> One possible approach:

very thx for your analysis and your patch proposal. After a first quick
test this patch proposal solves the problem.

Best regards,

Oliver
