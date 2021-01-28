Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12006306B48
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhA1CyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhA1CyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:54:23 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492E7C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 18:53:43 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id by1so5662393ejc.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 18:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aj9ZCfySY2yl96juq7xXfiBuV3c90DoKt+ad7NrTixs=;
        b=E+4WQspPZWl/MQfKxWyI/fHkxVUK4Bj9tfZjrzmONSAQMijLyvcwHIqPSo5XuFX0PI
         GfP5xz+G0nplMdUFsS2dI22Rta22Djh/8zAqN1eGAtvuYQzFOLDO2a0ITSChC1jaOhJg
         /guaDHFm1efFbAmii6SyyoUdyfnHVMazLOK/cPXnaHOiZ9S3s6/lDnozIMsCbvLMrbo8
         rIFExp/DUMbqTjExJakv2yKgCEx+eR9as9Eg9hCBp2ozLmSyRy1TrQK++G6OA85Wkn5L
         P2VyrFdIed9Vp3LSfK5iZMxjJ7eZOzXuAdmulZFfuokJi9TwsXCKzXtqdOdZJo0KNZ7o
         dujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aj9ZCfySY2yl96juq7xXfiBuV3c90DoKt+ad7NrTixs=;
        b=aFdwniOBAskt2jurkWGtYEL+/1hdaoKEuBc15yC7PvQrWGNsldWKe16+zRKPwDE3h+
         IFhGTYdpQnAHMda3xSSQie+wHJaBPklpp+x/xrfD9fyRrMLPP8VTczrYgP8liTAWXcA8
         4M36yMuherkgQvmN1rJN2xs8+DxdS6HRtjnjuywnRK4VSE38K7ldRVBsPop3ln1pVR21
         wdBxEcpNDVNNzwvyD2ise2KFW+TArcrJrVkMYfntFyMxnIA3gY6kOz7248wgVXfy08Lq
         GRN6cuNzNzLWiofIttGfLg7grwHJ6/qGiWoONydSmkinMsovznRln9bU19MnErrH18Kr
         157A==
X-Gm-Message-State: AOAM531+Bl5bsMmvgdVoYSYMCS3i7MlMLwfEhMmhgMP63KAPnu9I35mT
        imbp8Qf56AVHNEFnWOVcinYkTlO0SEEAaKtCgCE=
X-Google-Smtp-Source: ABdhPJxTOtuHH/Fn6dO/rI09dLl/bI/wMUyn/pwdf92eBbITxG7cGh5u4z8fWqBQW4PEIJayiW4Ox3JQoU2JWZO3TF8=
X-Received: by 2002:a17:906:44a:: with SMTP id e10mr8853782eja.265.1611802422079;
 Wed, 27 Jan 2021 18:53:42 -0800 (PST)
MIME-Version: 1.0
References: <20210126141248.GA27281@optiplex> <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
 <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com> <CAF=yD-Ja=kzq4KaraUd_dV7Z2joR009VLjhkpu8DK2DSUX-n9Q@mail.gmail.com>
In-Reply-To: <CAF=yD-Ja=kzq4KaraUd_dV7Z2joR009VLjhkpu8DK2DSUX-n9Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 21:53:05 -0500
Message-ID: <CAF=yD-+qFQHqLaYjq4x=rGjNZf_K9FSQiV-7Toqi3np+Cbq_vA@mail.gmail.com>
Subject: Re: UDP implementation and the MSG_MORE flag
To:     oliver.graute@gmail.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>, sagi@lightbitslabs.com,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:25 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jan 26, 2021 at 5:00 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 4:54 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Tue, Jan 26, 2021 at 9:58 AM Oliver Graute <oliver.graute@gmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > we observe some unexpected behavior in the UDP implementation of the
> > > > linux kernel.
> > > >
> > > > Some UDP packets send via the loopback interface are dropped in the
> > > > kernel on the receive side when using sendto with the MSG_MORE flag.
> > > > Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
> > > > example code to reproduce it is appended below.
> > > >
> > > > In the code we tracked it down to this code section. ( Even a little
> > > > further but its unclear to me wy the csum() is wrong in the bad case)
> > > >
> > > > udpv6_recvmsg()
> > > > ...
> > > > if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
> > > >                 if (udp_skb_is_linear(skb))
> > > >                         err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
> > > >                 else
> > > >                         err = skb_copy_datagram_msg(skb, off, msg, copied);
> > > >         } else {
> > > >                 err = skb_copy_and_csum_datagram_msg(skb, off, msg);
> > > >                 if (err == -EINVAL) {
> > > >                         goto csum_copy_err;
> > > >                 }
> > > >         }
> > > > ...
> > > >
> > >
> > > Thanks for the report with a full reproducer.
> > >
> > > I don't have a full answer yet, but can reproduce this easily.
> > >
> > > The third program, without MSG_MORE, builds an skb with
> > > CHECKSUM_PARTIAL in __ip_append_data. When looped to the receive path
> > > that ip_summed means no additional validation is needed. As encoded in
> > > skb_csum_unnecessary.
> > >
> > > The first and second programs are essentially the same, bar for a
> > > slight difference in length. In both cases packet length is very short
> > > compared to the loopback device MTU. Because of MSG_MORE, these
> > > packets have CHECKSUM_NONE.
> > >
> > > On receive in
> > >
> > >   __udp4_lib_rcv()
> > >     udp4_csum_init()
> > >       err = skb_checksum_init_zero_check()
> > >
> > > The second program validates and sets ip_summed = CHECKSUM_COMPLETE
> > > and csum_valid = 1.
> > > The first does not, though err == 0.
> > >
> > > This appears to succeed consistently for packets <= 68B of payload,
> > > fail consistently otherwise. It is not clear to me yet what causes
> > > this distinction.
> >
> > This is from
> >
> > "
> > /* For small packets <= CHECKSUM_BREAK perform checksum complete directly
> >  * in checksum_init.
> >  */
> > #define CHECKSUM_BREAK 76
> > "
> >
> > So the small packet gets checksummed immediately in
> > __skb_checksum_validate_complete, but the larger one does not.
> >
> > Question is why the copy_and_checksum you pointed to seems to fail checksum.
>
> Manually calling __skb_checksum_complete(skb) in
> skb_copy_and_csum_datagram_msg succeeds, so it is the
> skb_copy_and_csum_datagram that returns an incorrect csum.
>
> Bisection shows that this is a regression in 5.0, between
>
> 65d69e2505bb datagram: introduce skb_copy_and_hash_datagram_iter helper (fail)
> d05f443554b3 iov_iter: introduce hash_and_copy_to_iter helper
> 950fcaecd5cc datagram: consolidate datagram copy to iter helpers
> cb002d074dab iov_iter: pass void csum pointer to csum_and_copy_to_iter (pass)
>
> That's a significant amount of code change. I'll take a closer look,
> but checkpointing state for now..

Key difference is the csum_block_add when handling frags, and the
removal of temporary csum2.

In the reproducer, there is one 13B csum_and_copy_to_iter from
skb->data + offset, followed by a 73B csum_and_copy_to_iter from the
first frag. So the second one passes pos 13 to csum_block_add.

The original implementation of skb_copy_and_csum_datagram similarly
fails the test, if we fail to account for the position

-                       *csump = csum_block_add(*csump, csum2, pos);
+                       *csump = csum_block_add(*csump, csum2, 0);
