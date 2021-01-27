Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2A3052B4
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhA0GBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhA0D1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:27:20 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5EC06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 19:26:32 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a10so630375ejg.10
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 19:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpTabSnbDfIH21NXdTJ9CwWWubIRMZHJIs69Lnefm+E=;
        b=N1DVa5fjiqOmQpU0uMDx5bhUrWMHolW3fUPPdB9nyx2y/YzYmBVrlEs4MTu7VuvIcO
         V96Q3QKr0Ox1gtVeFRzVktNdDE7u/PPuD/VN/u1G5dRZasuMc6fjhRSA+v4CEhIbRhL6
         h5uiuxxeNT37bSSQdr0neJWoIT5uCk6dcCwn768fMYVZSoyLBvLwByVVtNq8Kyo+5EPP
         GA6SDEuYGOR5jpyLpk9U8zovI0Cc9rxkkS7nh/5Uk0AElqG092dLPx7W861zNiWFe5c0
         yov8iyye6pzhuYnP44bSRjGz0aOW/7TgYTVo/Noy9c19nU2yhEbXmNr362r5E4++I4nd
         XPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpTabSnbDfIH21NXdTJ9CwWWubIRMZHJIs69Lnefm+E=;
        b=D2rl7eBvSz1F11QD7ufmO9brQ+WQENhUGFkYlgF1hdI4930fxzxaoIaB80isJtViqr
         DFkH6K88OxSq/uoDHqgIEPdyP5oe7eJO9568gz7twnSIlNRRNMCwl5h+nGPJcq3QaT4p
         lf+/cxMcE96gpgkSddEzFyen6aBxsf2jPjYfcVcDsUdxpmrFbEA+H0noRwN5GvT0miHV
         J+CuDuZ9QOqw2WnQ+/00FRDRgNmgSdiXhFr31eETq2ErilLR1tMbMCrlFGHEMYbRwlYw
         gEyrj4tXodbG6pgq1F7wDdI67FIUjvf7aPtoGtASzUqvzZmWEd0co8mgKQHKG4PciPDM
         nEwQ==
X-Gm-Message-State: AOAM532JOVEBSZZm+BhLKyBe9jgjOHUMtjxlClYRy7jy4WHS4eSjdIZe
        23QS2Snx6kDRcx25fzV04ktz/RfO7l3vJarjmfg=
X-Google-Smtp-Source: ABdhPJzJhq3+4DVgK8JB8aF6zCgAQmOVRSvw8h3k6xkgRrIgHPeaEmx6OHehyIIvyHqWheAGEnJFAZHaBUxuj5uTw2g=
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr5501566ejt.56.1611717990905;
 Tue, 26 Jan 2021 19:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20210126141248.GA27281@optiplex> <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
 <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com>
In-Reply-To: <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 22:25:53 -0500
Message-ID: <CAF=yD-Ja=kzq4KaraUd_dV7Z2joR009VLjhkpu8DK2DSUX-n9Q@mail.gmail.com>
Subject: Re: UDP implementation and the MSG_MORE flag
To:     oliver.graute@gmail.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>, sagi@lightbitslabs.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 5:00 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jan 26, 2021 at 4:54 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 9:58 AM Oliver Graute <oliver.graute@gmail.com> wrote:
> > >
> > > Hello,
> > >
> > > we observe some unexpected behavior in the UDP implementation of the
> > > linux kernel.
> > >
> > > Some UDP packets send via the loopback interface are dropped in the
> > > kernel on the receive side when using sendto with the MSG_MORE flag.
> > > Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
> > > example code to reproduce it is appended below.
> > >
> > > In the code we tracked it down to this code section. ( Even a little
> > > further but its unclear to me wy the csum() is wrong in the bad case)
> > >
> > > udpv6_recvmsg()
> > > ...
> > > if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
> > >                 if (udp_skb_is_linear(skb))
> > >                         err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
> > >                 else
> > >                         err = skb_copy_datagram_msg(skb, off, msg, copied);
> > >         } else {
> > >                 err = skb_copy_and_csum_datagram_msg(skb, off, msg);
> > >                 if (err == -EINVAL) {
> > >                         goto csum_copy_err;
> > >                 }
> > >         }
> > > ...
> > >
> >
> > Thanks for the report with a full reproducer.
> >
> > I don't have a full answer yet, but can reproduce this easily.
> >
> > The third program, without MSG_MORE, builds an skb with
> > CHECKSUM_PARTIAL in __ip_append_data. When looped to the receive path
> > that ip_summed means no additional validation is needed. As encoded in
> > skb_csum_unnecessary.
> >
> > The first and second programs are essentially the same, bar for a
> > slight difference in length. In both cases packet length is very short
> > compared to the loopback device MTU. Because of MSG_MORE, these
> > packets have CHECKSUM_NONE.
> >
> > On receive in
> >
> >   __udp4_lib_rcv()
> >     udp4_csum_init()
> >       err = skb_checksum_init_zero_check()
> >
> > The second program validates and sets ip_summed = CHECKSUM_COMPLETE
> > and csum_valid = 1.
> > The first does not, though err == 0.
> >
> > This appears to succeed consistently for packets <= 68B of payload,
> > fail consistently otherwise. It is not clear to me yet what causes
> > this distinction.
>
> This is from
>
> "
> /* For small packets <= CHECKSUM_BREAK perform checksum complete directly
>  * in checksum_init.
>  */
> #define CHECKSUM_BREAK 76
> "
>
> So the small packet gets checksummed immediately in
> __skb_checksum_validate_complete, but the larger one does not.
>
> Question is why the copy_and_checksum you pointed to seems to fail checksum.

Manually calling __skb_checksum_complete(skb) in
skb_copy_and_csum_datagram_msg succeeds, so it is the
skb_copy_and_csum_datagram that returns an incorrect csum.

Bisection shows that this is a regression in 5.0, between

65d69e2505bb datagram: introduce skb_copy_and_hash_datagram_iter helper (fail)
d05f443554b3 iov_iter: introduce hash_and_copy_to_iter helper
950fcaecd5cc datagram: consolidate datagram copy to iter helpers
cb002d074dab iov_iter: pass void csum pointer to csum_and_copy_to_iter (pass)

That's a significant amount of code change. I'll take a closer look,
but checkpointing state for now..
