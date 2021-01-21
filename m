Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0580D2FEF83
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbhAUPwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731165AbhAUPvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:51:50 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FD8C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:51:10 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id a31so798585uae.11
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ne+dbRTh0RCBJExU0F/HHyjnuTlluZPqXNtK9D1d2Gg=;
        b=Cd0q3gjsb56e0PkOwqKUxmnt7fjEYOVl6dAvwDtMZ3xi4XtdsvAWbwev+/nwsJbCtS
         04YTO708G89nX6Xe7gsvK6yXoyOqB5GJuCk46yBSY4GCgM11FQUGY4MXkywsOB1se1GS
         swmIjr9cACDqTqVut/wHoTjtStd2dlemjqGdBA8+0hVrg7y+2Gzf8GKmgld2CO/rGScp
         OAedoDv4N4S6Y8XIbTUtML3/1zkZDlXpPm0qjlio7guJu7lGmCNEMft2/ppQF1XSvio6
         S7ZWi5HqR7N2qTWrh0K0xl+y/VA/VGTdCYbZMSNqPLFLKVcsvBlt9h8eAuXsiBMSh2f5
         H/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ne+dbRTh0RCBJExU0F/HHyjnuTlluZPqXNtK9D1d2Gg=;
        b=H4fSd4KKsiFA6OGSUDX/uve9gM0usauC0nE5buki0ewCPPnlr6Yap64Xk5/cV8KLtx
         nJXsci3BVoON0vSj6QH2yZJIu5lmgSaaHGB5hF31iFjHxW+XObU1mNZAic5Dz1vHwpIo
         +AeYdIUP9Eeksgwnh6bDmuLJAl1WN9e1rtRx9rVHgsGu1gSrRD5fZgSynplM04boLabm
         sBo7dmcbvB5ShsdGS2G0jL7IobOUeNMef7qB0hojppYx9YQUJvKI9SWcijg6FziMH9Tz
         0OLC76FF/z3hPgSQqxKgKZF9uipmP87pzmrgG1HmlFdOI1E4fq2fGq2wzwgN2/i7N+S6
         BRag==
X-Gm-Message-State: AOAM530zx+ZEx3dpKXOoQ9OnJpeq3RUqW8XSOhk3+ZTZylJFujw5zqjq
        mOveJCRcx4WAjTkBidrzAL0whsMuKH+tvYSOMHRI3w==
X-Google-Smtp-Source: ABdhPJzI8jX+tee5y+Ym1mKEpiDtBZCs1sMP99XjSeJiv6YvwnmkV0YAyqd0AnOSbjFd9YzLImGSgRuvA6V75Rij7ww=
X-Received: by 2002:ab0:2b94:: with SMTP id q20mr381654uar.46.1611244269278;
 Thu, 21 Jan 2021 07:51:09 -0800 (PST)
MIME-Version: 1.0
References: <1611139794-11254-1-git-send-email-yangpc@wangsu.com>
 <CADVnQykgYGc4_U+eyXU72fky2C5tDQKuOuQ=BdfqfROTG++w7Q@mail.gmail.com>
 <CAK6E8=e1sdqntpLzeaGKhFB_DhhcNrJmPBQ3u9M44fSqdNTg_Q@mail.gmail.com> <022d01d6effc$0ccd0c50$266724f0$@wangsu.com>
In-Reply-To: <022d01d6effc$0ccd0c50$266724f0$@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 21 Jan 2021 10:50:52 -0500
Message-ID: <CADVnQy=jwBHg_Pf+puzxTCOCKxZJU2uThAuXU9CtkWFxtqU69w@mail.gmail.com>
Subject: Re: tcp: rearm RTO timer does not comply with RFC6298
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 9:05 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> On Thu, Jan 21, 2021 at 2:59 AM Yuchung Cheng <ycheng@google.com> wrote:
> >
> > On Wed, Jan 20, 2021 at 6:59 AM Neal Cardwell <ncardwell@google.com> wrote:
> > >
> > > On Wed, Jan 20, 2021 at 5:50 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > > >
> > > > hi,
> > > >
> > > > I have a doubt about tcp_rearm_rto().
> > > >
> > > > Early TCP always rearm the RTO timer to NOW+RTO when it receives
> > > > an ACK that acknowledges new data.
> > > >
> > > > Referring to RFC6298 SECTION 5.3: "When an ACK is received that
> > > > acknowledges new data, restart the retransmission timer so that
> > > > it will expire after RTO seconds (for the current value of RTO)."
> > > >
> > > > After ER and TLP, we rearm the RTO timer to *tstamp_of_head+RTO*
> > > > when switching from ER/TLP/RACK to original RTO in tcp_rearm_rto(),
> > > > in this case the RTO timer is triggered earlier than described in
> > > > RFC6298, otherwise the same.
> > > >
> > > > Is this planned? Or can we always rearm the RTO timer to
> > > > tstamp_of_head+RTO?
> > > >
> > > > Thanks.
> > > >
> > >
> > > This is a good question. As far as I can tell, this difference in
> > > behavior would only come into play in a few corner cases, like:
> > >
> > > (1) The TLP timer fires and the connection is unable to transmit a TLP
> > > probe packet. This could happen due to memory allocation failure  or
> > > the local qdisc being full.
> > >
> > > (2) The RACK reorder timer fires but the connection does not take the
> > > normal course of action and mark some packets lost and retransmit at
> > > least one of them. I'm not sure how this would happen. Maybe someone
> > > can think of a case.
>
> Yes, and it also happens when an ACK (a cumulative ACK covered out-of-order data)
> is received that makes ca_state change from DISORDER to OPEN, by calling tcp_set_xmit_timer().
> Because TLP is not triggered under DISORDER and tcp_rearm_rto() is called before the
> ca_state changes.

Hmm, that sounds like a good catch, and potentially a significant bug.
Re-reading the code, it seems that you correctly identify that on an
ACK when reordering is resolved (ca_state change from DISORDER to
OPEN) we will not set a TLP timer for now+TLP_interval, but instead
will set an RTO timer for rtx_head_tx_time+RTO (which could be very
soon indeed, if RTTVAR is very low). Seems like that could cause
spurious RTOs with connections that experience reordering with low RTT
variance.

It seems like we should try to fix this. Perhaps by calling
tcp_set_xmit_timer() only after we have settled on a final ca_state
implied by this ACK (in this case, to allow DISORDER to be resolved to
OPEN). Though that would require some careful surgery, since that
would move the tcp_set_xmit_timer() call *after* the point at which
the RACK reorder timer would be set.

Other thoughts?

neal
