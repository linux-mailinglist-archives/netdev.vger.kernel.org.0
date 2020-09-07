Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B4425F55F
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgIGIfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbgIGIfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:35:20 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82612C061573;
        Mon,  7 Sep 2020 01:35:19 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id x7so6089195qvi.5;
        Mon, 07 Sep 2020 01:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EErMYC4JfViV5BfDEglgpk4OsyZ2N7uas9vaEehe8rw=;
        b=du7cPAlIRzFvZhPr5hhCFzG5qFHIJWFmvskYvhz/YCVy0bER/1Ov54PVvwPG/pr5nw
         h1XEgvx+ql+ZMXRpS5P76r2NEx4F9msMZRO+ATfarhcWyLJFc2gBXDlI5inwMH9opFz3
         aRImWv3xKcm+kaQTIb71iXGVjPv6hmBFMsp439uAchFO6dGE4tufLhGTSyFPnuqQsryX
         /os9gKgWDWC5PhBkcoqEKyivvd8Nhq6d9UJX65jCCUbq1xnGchRxEbS5oNIAp1U6Fdt4
         tuGZOw8K5GPoCTamM+IoVui/06rW5D6nQBwTTEwhnFxtvKPT1lbbJVVJGaCYWr8ICv04
         bgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EErMYC4JfViV5BfDEglgpk4OsyZ2N7uas9vaEehe8rw=;
        b=kEi9uqiWSMWQwigDAlNSEqV1kEgwLHTY/djnk8Q8pC6JrPZ7mNnC0qk2wVwOr6FnYm
         zCPe810+jsl+7a0/VCjTJ+uzgFvJarwMC0a/lox16poDxrRqqzaLcd89oY+71htS18s+
         uQ33KfUJCmF3yZUrVrJ3OJXzZ7RJ+xn5gb7eCyqgb/jeFBnyh4Tq1rWDFFAjCtAgORva
         hWz+hT62lykZ29m7o9g84Cw2R+t6lvFReyXSEmEemWHBFB9tTNigiK4BfeVbUftxNnt/
         9WQbzXiho0lN9Fg2o05/rJPqLPKi8QTBQKL8HiWbG6Q5F7R5cCzkyGf73K9QpWhJau6O
         IINw==
X-Gm-Message-State: AOAM532JTI5IqFILRzHZdntr44kDskx9zg8H9VLsdxcmC0L+y6vTyI2i
        1jU9bF6mt5ZqoYJtGPNiqRZVxCvVPmqTCTm7LqI=
X-Google-Smtp-Source: ABdhPJyLx6zqF32XdZCFMfYfMOxfLXYp9jdq42Fu69Srh1p/roUusR6zuZXakTqxQgbNc+3vHDhOLBnpSszjSaPBlnk=
X-Received: by 2002:a0c:b2d4:: with SMTP id d20mr17929861qvf.1.1599467718055;
 Mon, 07 Sep 2020 01:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <CA+4pmEueEiz0Act8X6t4y3+4LOaOh_-ZfzScH0CbOKT99x91NA@mail.gmail.com>
 <87wo7una02.fsf@miraculix.mork.no> <CAGRyCJE-VYRthco5=rZ_PX0hkzhXmQ45yGJe_Gm1UvYJBKYQvQ@mail.gmail.com>
 <CAKfDRXg2xRbLu=ZcQYdJUuYbfMQbav9pUDwcVMc-S+hwV3Johw@mail.gmail.com> <87v9gqghda.fsf@miraculix.mork.no>
In-Reply-To: <87v9gqghda.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 7 Sep 2020 10:35:07 +0200
Message-ID: <CAGRyCJFcDZzfahSsexnVN0tA6DU=LYYL2erSHJaOXZWAr=Sn6A@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: Fix for packets being rejected in the
 ring buffer used by the xHCI controller.
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kristian and Bj=C3=B8rn,

Il giorno lun 7 set 2020 alle ore 09:45 Bj=C3=B8rn Mork <bjorn@mork.no> ha =
scritto:
>
> Kristian Evensen <kristian.evensen@gmail.com> writes:
>
> > Hi all,
> >
> > I was able to trigger the same issue as reported by Paul, and came
> > across this patch (+ Daniele's other patch and thread on the libqmi
> > mailing list). Applying Paul's fix solved the problem for me, changing
> > the MTU of the QMI interface now works fine. Thanks a lot to everyone
> > involved!
> >
> > I just have one question, is there a specific reason for the patch not
> > being resubmitted or Daniele's work not resumed? I do not use any of
> > the aggregation-stuff, so I don't know how that is affected by for
> > example Paul's change. If there is anything I can do to help, please
> > let me know.
>
> Thanks for bringing this back into our collective memory.  The patch
> never made it to patchwork, probably due to the formatting issues, and
> was just forgotten.
>
> There are no other reasons than Daniele's concerns in the email you are
> replying to, AFAIK.  The issue pointed out by Paull should be fixed, but
> the fix must not break aggregation..
>
> This is a great opportunity for you to play with QMAP aggregation :-)
> Wouldn't it be good to do some measurements to document why it is such a
> bad idea?
>

there was also another recent thread about this and the final plan was
to simply increase the rx urb size setting to the highest value we are
aware of (see https://www.spinics.net/lists/linux-usb/msg198858.html):
this should solve the babble issue without breaking aggregation.

The change should be simple, I was just waiting to perform some sanity
tests with different models I have. Hope to have it done by this week.

Regards,
Daniele

>
> Bj=C3=B8rn
>
