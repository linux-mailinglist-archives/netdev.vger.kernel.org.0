Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4A28868C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbgJIKHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJIKH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:07:29 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749DBC0613D2;
        Fri,  9 Oct 2020 03:07:29 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id h6so10112322lfj.3;
        Fri, 09 Oct 2020 03:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O6ukwqJEWQ6yr/pMd6fbdg+VpvxJvOj62gBipeVPJmI=;
        b=Mx05QbYiHRbwrS6Z46jd/WgwBRyTQWIOVq0D6MvRfRvQLhzGw9IylnisjNdELXpLVj
         zFJSTbwbCMGD/a8K7aCK7kqmIbaka35n0K3nXcZp20ztI95ol2lXyz/XrefDml/bW4Fm
         0U0aV498Am+AJ+W5VJ09OdWOn8Ou56kDkOfpVbrNeExCGGND9IW9yNuCoqQeV5md5ZA1
         dfSWhxRk2rsp9jofVc0U01/v5sseCMtb1K1B9QKoBYQ+DHhhEze2VKfChPs7Id8HGYAo
         uOHXWPDCKbTBALAUUXfMJjBVyzl52StLRhkIi4/fujgXIuz7iamVHH+xcWTSFp+flqwT
         zo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O6ukwqJEWQ6yr/pMd6fbdg+VpvxJvOj62gBipeVPJmI=;
        b=edXFyd25tem/HJJ/k+GpOAxh/92WsY/ZxZYilJTrkKq0AbS6kOyhA28EKBVCM3MfMv
         khG0kpgSvBbXoc1pPrrMn64gercp+T67Ag1MbOM3Dy0xy1dbFlDNQNEI3ZxGTRzLYVrQ
         iUl/IIg9FtIo1+/JODFiBg/qUzk5RgJlqI0AxZuKHo1Dj+ef0UO0jHH/Cc9BBR7DRiVF
         NrNwvVKqpViqxle+AYfUhEIhevHurD2Fb137v2UqTz79Pvtldzxdv7pdhWWUKYqW7JsZ
         fhPqAEncG3m3TU3BG2vmdcryNub/Ko1X9ryHBAiHJ6y5d/mZzEmyawMEKQwm9twN1UkE
         Z7Jg==
X-Gm-Message-State: AOAM530vDrTn1FEG6yu9cGKNlxXkWY63V2cfJ50i2irZb/esQuLMhZEW
        r+iKJKrb/MmJy2JUeyu7MdBhrh9BlIPbagbuYdI=
X-Google-Smtp-Source: ABdhPJyhjAwJPUWrDFg/tvDOHPo4oVGg9qMmLxuELBxFQp2OgX/pQ9sSqfxqsKMaAyItgswPbAXHyS3ixO2RrNsEDGc=
X-Received: by 2002:ac2:4203:: with SMTP id y3mr3875737lfh.52.1602238047777;
 Fri, 09 Oct 2020 03:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20201008155048.17679-1-ap420073@gmail.com> <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
 <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
 <CAMArcTUkC2MzN9MiTu_Qwouj6rFf0g0ac2uZWfSKWHTW9cR8xA@mail.gmail.com> <87r1q8gdqk.fsf@suse.de>
In-Reply-To: <87r1q8gdqk.fsf@suse.de>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 9 Oct 2020 19:07:16 +0900
Message-ID: <CAMArcTWBdqRG11XcFPvPTR2YpwfdDMuQ-_7WGow574QftUEGYA@mail.gmail.com>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its debugfs
 is being used
To:     Nicolai Stange <nstange@suse.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 at 14:39, Nicolai Stange <nstange@suse.de> wrote:
>

Hi Nicolai,
Thank you for the review!

> Taehee Yoo <ap420073@gmail.com> writes:
>
> > On Fri, 9 Oct 2020 at 01:14, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:
> >
> >> From: Taehee Yoo
> >> > Sent: 08 October 2020 16:49
> >> >
> >> > When debugfs file is opened, its module should not be removed until
> >> > it's closed.
> >> > Because debugfs internally uses the module's data.
> >> > So, it could access freed memory.
>
> Yes, the file_operations' ->release() to be more specific -- that's not
> covered by debugfs' proxy fops.
>
>
> >> > In order to avoid panic, it just sets .owner to THIS_MODULE.
> >> > So that all modules will be held when its debugfs file is opened.
> >>
> >> Can't you fix it in common code?
> >
> >> Yeah I was just wondering that too - weren't the proxy_fops even already
> >> intended to fix this?
> >
> > I didn't try to fix this issue in the common code(debugfs).
> > Because I thought It's a typical pattern of panic and THIS_MODULE
> > can fix it clearly.
> > So I couldn't think there is a root reason in the common code.
>
> That's correct, ->owner should get set properly, c.f. my other mail in
> this thread.
>

Thanks a lot for verifying it!
Taehee
