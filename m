Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1025546C2E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346768AbiFJSOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244325AbiFJSOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:14:35 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C3F25FC
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:14:34 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h23so8460ljl.3
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5MK2TDwycSdBsqQ5dfnMewHJzaCUJm/CWEvAqLv7r4=;
        b=GQ2wuDnwa9/iCtH58xrjmY9Pvpd61ufsokyO/zAQMfQt92FG7hZGn25VpMaX7yEzrf
         0by40fB0ROkGs5lAUwgX77xUCjRm9w2bMmg5lfyniqmSuYWTxibVVbhOmEgg6MC9LzFm
         b+vV+CV9zyP+m/Ur7z3LpSCjSp27uDGPdC4iGAyedAW1fGvYX4uUYLi8wUZ38FrPcKKs
         kNMUpL/g3RdtY3HOhstT+2XVW3XxqZgV03twmgG0IY+CcGw2gywgsVmHdtNO0enB0fz5
         KB5usTGBugtWD1zGPknc1J1Dh9vxf0/a/xmQsZwFIo4h58YuXGhyjhBe1JQ7DpW4+kVW
         ipDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5MK2TDwycSdBsqQ5dfnMewHJzaCUJm/CWEvAqLv7r4=;
        b=sFgbXrn7Z/ME8vnCF/p5HQEQs36BYUPGfpMlnQjHPIZm/DUEEkrS3IFr2Z6ogsmvL7
         QEmaZfKoztHamig/avyPDxUt0wxLsgTNuyXvOx3LD4nOvT3v30FBBYi8FQpL31lghT8l
         SSTGc+fpynZI3OByoyOIty2SvgTPIL6MSYB+aOQXvAeKGqXd1JaRBRJJMostWx9rHOdH
         r8MLj7GoDUR0H6O9zm0/rG2n9Y4LrUEa1girQNu1NcdCX8hJM2wvU61x5cZVcayCnpON
         fH0dYoElK44347PgPvwXulWXDRYe2WjGQ/iA/eawBBQAEqe9zsM3GHPfLiN9JALdA+1Q
         hMaQ==
X-Gm-Message-State: AOAM530kiBTj4/MkfBTL7jTBGcCjBPMLP/vrjCEzdsJV21GcatagVwRB
        n6PZGKxSrEAXeSpUG9Hhu8QNWsnkVZxIsD+7Tfo=
X-Google-Smtp-Source: ABdhPJwHcXkchJ0XghE9DyXWh8W9/xCi2F337HT0N7qvuQ1Y7S+lJoF3+B9sQ2FoOm+oz6R8Jm2YS3pFGRZ8fipdOWg=
X-Received: by 2002:a2e:a884:0:b0:253:f2a8:81b0 with SMTP id
 m4-20020a2ea884000000b00253f2a881b0mr50017181ljq.60.1654884872378; Fri, 10
 Jun 2022 11:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAMJ=MEcPzkBLynL7tpjdv0TCRA=Cmy13e7wmFXrr-+dOVcshKA@mail.gmail.com>
 <f0f30591-f503-ae7c-9293-35cca4ceec84@gmail.com> <CAMJ=MEdctBNSihixym1ZO9RVaCa_FpTQ8e4xFukz3eN8F1P8bQ@mail.gmail.com>
 <0e02ea2593204cd9805c6ed4b7f46c98@AcuMS.aculab.com> <CAMJ=MEe3r+ZrAONTciQgU4yqtXTJJvXc0OFvJYwYg20kPGQtdA@mail.gmail.com>
 <20220610174201.GC19540@1wt.eu>
In-Reply-To: <20220610174201.GC19540@1wt.eu>
From:   Ronny Meeus <ronny.meeus@gmail.com>
Date:   Fri, 10 Jun 2022 20:14:21 +0200
Message-ID: <CAMJ=MEcOdB17WhYA6LNcoOReD0+8o3xs38qde2_FRhEfK1MqrQ@mail.gmail.com>
Subject: Re: TCP socket send return EAGAIN unexpectedly when sending small fragments
To:     Willy Tarreau <w@1wt.eu>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Op vr 10 jun. 2022 om 19:42 schreef Willy Tarreau <w@1wt.eu>:
>
> On Fri, Jun 10, 2022 at 07:16:06PM +0200, Ronny Meeus wrote:
> > Op vr 10 jun. 2022 om 17:21 schreef David Laight <David.Laight@aculab.com>:
> > >
> > > ...
> > > > If the 5 queued packets on the sending side would cause the EAGAIN
> > > > issue, the real question maybe is why the receiving side is not
> > > > sending the ACK within the 10ms while for earlier messages the ACK is
> > > > sent much sooner.
> > >
> > > Have you disabled Nagle (TCP_NODELAY) ?
> >
> > Yes I enabled TCP_NODELAY so the Nagle algo is disabled.
> > I did a lot of tests over the last couple of days but if I remember well
> > enable or disable TCP_NODELAY does not influence the result.
>
> There are many possible causes for what you're observing. For example
> if your NIC has too small a tx ring and small buffers, you can imagine
> that the Nx106 bytes fit in the buffers but not the N*107, which cause
> a tiny delay waiting for the Tx IRQ to recycle the buffers, and that
> during this time your subsequent send() are coalesced into larger
> segments that are sent at once when using 107.
>

The test is running over the loopback interface ...

> If you do not want packets to be sent individually and you know you
> still have more to come, you need to put MSG_MORE on the send() flags
> (or to disable TCP_NODELAY).

Like I said, TCP_NODELAY does not have an impact.

> Clearly, when running with TCP_NODELAY you're asking the whole stack
> "do your best to send as fast as possible", which implies "without any
> consideration for efficiency optimization". I've seen a situation in the
> past where it was impossible to send any extra segment after a first
> unacked PUSH was in flight. Simply sending full segments was enough to
> considerably increase the performance. I analysed this as a result of
> the SWS avoidance algorithm and concluded that it was normal in that
> situation, though I've not witnessed it anymore in a while.
>
> So just keep in mind to try not to abuse TCP_NODELAY too much.

Thanks Willy for the feedback.

>
> Willy
