Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1D72F2735
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 05:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbhALEkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 23:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbhALEkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 23:40:40 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7955C061575;
        Mon, 11 Jan 2021 20:39:59 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id d37so990549ybi.4;
        Mon, 11 Jan 2021 20:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tGZClHUpaj3Cm/gs9dDdIPBw4DYUZttzUeth9TUTOKc=;
        b=D58cdCKfLXyaUNVojpEvgJqfjWt11W5JTvHcqLp6/qketMD8EsQwfGqQxHVF1o4gd7
         s9VqM6UVlQvttf8ZnitstC+teOq63QHCxeOamyPl2XS2nGJgq00lLpL2bUjAAtCmb3/2
         es7nOslgha1HvUrXPo2mPN3DzazJ+3rWUlM0x8/wHs5+/QBYdW2iOc7pEp93RPfeqZvR
         T4Mlf4eQ3Sq0WMWBO5mePL9hlwYwEeosHdoX88FfhoNB3W+Dpn037JCuYxpUTZYhTbl6
         8JTD3Ycbkuu59eXrijz+5bH3e/KHNSzclrXHKarr/dieRpdEea/tupmxoE/Q/QIeUKse
         lhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tGZClHUpaj3Cm/gs9dDdIPBw4DYUZttzUeth9TUTOKc=;
        b=ZkcE3iANQElt9IM5gLS7HV8yBrUCDDbroiSoUsTspuJFzB7avdFRz2CI3Ig8SxYUOa
         lIQjCBR19kagueuTWR17sNxo6ASuQxG0mxe63bQ+kXnHplg+uqvuQ7ZVBtkBg67Wyv3Y
         ZMkjtuZTTlhQjyMV8Yzfa+pJX+DO8eTPh2b2B0RpXFsa6v3mThgxhZCYUn0gZXBzLoMf
         nKekAOMiCO5Z8MsvyYdzd6cr7DcswjhCTClkvZ5Crss8TUF8XNd7EkCiDOETa7O684LV
         9pVhxJqltkWkNQjAbw7tw6bKpczdYDYkbUAxlkKEeuEectn6t26w9UZXnOJ2VJFsbl8L
         vzfA==
X-Gm-Message-State: AOAM533c8vpiZ0rDasmrdkZfYtlEFiXDoFL+EERgoAzAWAixJD24s4yU
        gno+8Gljb4HRrIhJdPo7dcgdePVpc5AZp4BySI1hbBDKP0G/BH4Z
X-Google-Smtp-Source: ABdhPJzwnAVKcwOnr1e+p/BrL8XtIrv1gNtL4nnHrOLh/rkuCQ3pRU0yvQj6om2KRGt8+9cDCn7M9o3m/6HyTbURKjU=
X-Received: by 2002:a25:df05:: with SMTP id w5mr4554207ybg.477.1610426399217;
 Mon, 11 Jan 2021 20:39:59 -0800 (PST)
MIME-Version: 1.0
References: <CAD-N9QWDdRDiud42D8HMeRabqVvQ+Pbz=qgbOYrvpUvjRFp05Q@mail.gmail.com>
 <20210112032713.GB2677@horizon.localdomain>
In-Reply-To: <20210112032713.GB2677@horizon.localdomain>
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Tue, 12 Jan 2021 12:39:33 +0800
Message-ID: <CAD-N9QUap9JpVe3Fm=dAxe6EeHHh99MJctisSyE=JSNutk=xKA@mail.gmail.com>
Subject: Re: "general protection fault in sctp_ulpevent_notify_peer_addr_change"
 and "general protection fault in sctp_ulpevent_nofity_peer_addr_change"
 should share the same root cause
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, vyasevich@gmail.com, rkovhaev@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:27 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 10:18:00AM +0800, =E6=85=95=E5=86=AC=E4=BA=AE wro=
te:
> > Dear developers,
> >
> > I find that "general protection fault in l2cap_sock_getsockopt" and
> > "general protection fault in sco_sock_getsockopt" may be duplicated
> > bugs from the same root cause.
> >

I am sorry that the above description is for another bug group -
https://groups.google.com/g/syzkaller-bugs/c/csbAcYWGd2I. I forget to
modify this paragraph. Embarrassing :(

The correct description here should be, "I find that general
protection fault in sctp_ulpevent_notify_peer_addr_change" and
"general protection fault in sctp_ulpevent_nofity_peer_addr_change"
should share the same root cause, like the title.

> > First, by comparing the PoC similarity after own minimization, we find
> > they share the same PoC. Second, the stack traces for both bug reports
> > are the same except for the last function. And the different last
> > functions are due to a function name change (typo fix) from
> > "sctp_ulpevent_nofity_peer_addr_change" to
> > "sctp_ulpevent_notify_peer_addr_change"
>
> Not sure where you saw stack traces with this sctp function in it, but
> the syzkaller reports from 17 Feb 2020 are not related to SCTP.
>
> The one on sco_sock_getsockopt() seems to be lack of parameter
> validation: it doesn't check if optval is big enough when handling
> BT_PHY (which has the same value as SCTP_STATUS). It seems also miss a
> check on if level !=3D SOL_BLUETOOTH, but I may be wrong here.
>
> l2cap_sock_getsockopt also lacks checking optlen.
>

Please ignore my mistake, and discuss the issue of
sco/l2tp_sock_getsockopt in the thread - "general protection fault in
l2cap_sock_getsockopt" and "general protection fault in
sco_sock_getsockopt" may share the same root cause
(https://groups.google.com/g/syzkaller-bugs/c/csbAcYWGd2I)


>   Marcelo
