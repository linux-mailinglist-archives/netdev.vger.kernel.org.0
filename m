Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF81EEE35
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 01:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgFDXSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 19:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgFDXSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 19:18:23 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE4CC08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 16:18:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z5so7972584ejb.3
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 16:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/EtRKWLet4ug0Pd50D48eoo++AMYSG47mCvAH0awhA=;
        b=cHE4XgHfIJE2U/QjGq2dyU7+DL+HBy3mU7Qp7VBqq0DiKGQT7goQSCyEc7hz0Ffe9G
         7jMpsokM1//E+UxsrO266PazX86SPsKQeCAUbPT2xEF/SPHfi9SMWS/yOiGUKeck7fAI
         pUg1tmEepV1IotcMNAY0BPBQUhdAQKz0x5Ht/GvAPNH8ZKBrlupZDDfx4dwA1RPoXGs3
         voMQP5IAKrnyerwud7mH90xbFnfYIR4D3TSUDDttI9VXjkXJTbx54+f2oBzyR6tAxINH
         mY9vwL3Tt/DZ7hQsVV2+JojsD64bjYSkdYUG0yIQTPqjfM/iQpEh0sD8I9uls9PqLM1k
         zZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/EtRKWLet4ug0Pd50D48eoo++AMYSG47mCvAH0awhA=;
        b=jAxEXYfEnfm+PcnrYtxoTWJVYpC5NlJP5q0XkcapLyanyqNc2/g7oAfZiRC/J7eVE1
         GXU7hfgf0YFZrVG9uR9AhJrLG/F0j7CoScF4bi+6LhAN8gM9Tui0O1ml0pZTAK89WQxI
         qT7gYkhHX+VHJU2Ovvua30UwjaNu6KNnqq+nzO+j14E5WFnU5gr3A4JBp/Tc6OmP423D
         W56yQNCsXUf6WjrrJ/dj2noJZ09ZRwTgsKSku3gDHDdjX9vHYi2oQ8ASpt6X95bZtnCu
         +REg/o+wziAJsa7JeSiuFlpv0LQ7tumt8Cg6zbTdS3Zf4R7nvafSTmSET2z/SvkGHb8S
         KRkA==
X-Gm-Message-State: AOAM5334n5yxeD+Q+oEgvrGYHtavYrmOdJfijj5OcI42kMGlXatXlQpK
        Z88Z2Coc+vFoMl1l242692Yx82DwoUq0PjAGp47cQQ==
X-Google-Smtp-Source: ABdhPJznhIwey9djMQH/Dnq2/LbhTrfREPsu04uZ2/5v4N+dKR38CbLMmCrUFRMZy7prt9Vo36p1vLOuGsYDIoprSYw=
X-Received: by 2002:a17:906:c7da:: with SMTP id dc26mr6311070ejb.500.1591312700434;
 Thu, 04 Jun 2020 16:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <538FB666.9050303@yahoo-inc.com> <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg>
 <5397A98F.2030206@yahoo-inc.com> <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
In-Reply-To: <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Thu, 4 Jun 2020 16:18:09 -0700
Message-ID: <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
To:     Julian Anastasov <ja@ssi.bg>, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Eric & Leif

Hello,


(digging out an old thread ... ;-) )

On Wed, Jun 11, 2014 at 11:05 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Tue, 10 Jun 2014, Wayne Badger wrote:
>
> > On 6/7/14, 10:41 AM, Julian Anastasov wrote:
> > >
> > >     This discussion (http://marc.info/?t=125541062900001&r=1&w=2)
> > > has some hints about using TCP_SYNCNT.
> >
> > Thanks for the pointer.  I have read through this discussion, but I
> > can't see how it helps with the current implementation.  TCP_SYNCNT
> > (or sysctl.tcp_synack_retries if TCP_SYNCNT is unused) allows you to
> > set the number of retries, but inet_csk_reqsk_queue_prune essentially
> > ignores the TCP_SYNCNT value if TCP_DEFER_ACCEPT is in use.
> >
> >         if (queue->rskq_defer_accept)
> >             max_retries = queue->rskq_defer_accept;
>
>         You are right, I missed that. So, we send just
> one SYN+ACK when period is about to expire.
>
> > I have so far been unable to obtain the behavior documented for
> > TCP_DEFER_ACCEPT, even with various settings of TCP_SYNCNT.  No setting
> > of TCP_SYNCNT can make it be used in the calculations in favor of the
> > TCP_DEFER_ACCEPT value.  No matter which value I choose for TCP_SYNCNT,
> > the connection is always promoted to a full socket and moved to the
> > accept queue.
> >
> > Would you verify whether a server ever accepts the socket if data is
> > not sent?  I've been using v3.14.0 with default sysctl settings and a
> > TCP_DEFER_ACCEPT value of 30 and don't see that behavior.
>
>         syn_ack_recalc() schedules SYN+ACK, so under
> normal conditions, it triggers ACK from client and
> child is created, even without DATA. Request will
> expire only when last SYN+ACK or the following ACK
> is lost (or not sent).
>
> > The behavior that we want is for the receipt of the duplicate bare
> > ACK to not result in waking up user space.  The socket still hasn't
> > received any data, so there's no point in the process accepting the
> > socket since there's nothing the process can do.
>
>         One problem with this behavior is that after first ACK
> more ACKs are not expected. Your RST logic still relies on the
> last SYN+ACK we sent to trigger additional ACK. I guess,
> we can live with this because for firewalls it is not worse
> than current behavior. We replace accept() with RST.
>
> > I would prefer that we send a RST upon receipt of a bare ACK for a
> > socket that has completed the 3way handshake, waited the
> > TCP_DEFER_ACCEPT timeout and has never received any
> > data.  If it has timed out, then the server should be done with the
> > connection request.
>
>         I'm ok with this idea.

Is there any specific reason as to why we would not want to do this?

API-breakage does not seem to me to be a concern here. Apps that are
setting DEFER_ACCEPT probably would not expect to get a socket that
does not have data to read.


Any thoughts?


Thanks,
Christoph


>
> > >     The best place would be to send this reset in
> > > inet_csk_reqsk_queue_prune() after the /* Drop this request */
> > > comment if inet_rsk(req)->acked is set because we are not
> > > sure if our SYN+ACKs after the period will lead to new packets
> > > from client. But we have no skb to reply, not sure if
> > > the open request contains data to build a reset.
> >
> > We could drop the connection in inet_csk_reqsk_queue_prune, but we have
> > to ensure that the receipt of the bare ACK response from the duplicate
> > SYN-ACK doesn't promote the socket as it is doing now.  We'll also have
>
>         Agreed. I'm just not sure for the implementation
> needed for inet_csk_reqsk_queue_prune. TCP experts
> can help here.
>
> > to do something for syncookies because a valid bare ACK received for
> > a socket that doesn't even have a minisock should behave similarly.
> > The code to handle this can't go in inet_csk_reqsk_queue_prune because
> > there is no socket of any type to prune so we'll at least need to have the
> > code in two places but we could easily commonize it in a function.
>
>         I don't know the syn-cookie code. Even now
> inet_csk_reqsk_queue_prune() expires acked requests,
> isn't inet_csk_reqsk_queue_drop sufficient?
>
> > Was it the intent with commit d1b99ba41d to change the semantics
> > of TCP_DEFER_ACCEPT such that sockets were always promoted to full
> > sockets and moved to the accept queue?  I want to make sure that we
> > are all on the same page with what the semantics mean because if we
> > have a disagreement there, then nothing else matters.  I'm just trying
> > to get a socket to stay in the kernel and not wake up the listener before
> > there is any data.
>
>         IIRC, the main idea is to remove connection from
> firewalls, the idea with triggered ACK was the easiest
> solution.
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
