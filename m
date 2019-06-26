Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EE855CC8
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFZAFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:05:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44528 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFZAFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:05:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so245373pfe.11
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j+XcJIMVM4uEkav1jYKM8jg1O0IYdyLWsof36nok6Kg=;
        b=n9y6cStZ7/BACW9n1RkJ/Pbjw/mm2bLY29FV70FGx8RR71wNZY4SgdO4a86caX4zxd
         mQW+Rk3SE/V7RGtYpxt9jI5YpS0M9m3NlWC4siuDbdEQDlLYbFbPsrB0VgFm0wDAsvRW
         yIFktOrEgHRzxvkTN2p0MM1R/gakIsNM2SEOCSmzbTPfW8B3fMMp009Cr3ATUI/M6Cd0
         Y4iS4trWeS3lMGVAPCaGoXhgv9kCUp5mVw1ImU2lJG4DE8r+Ow62xmoHGogat/B6dn9y
         usdHsPGbb4kqoSxlHcPY2COFqxzBKorEL10+R6Fr3FK6xNPLDzaDOk2ufLPECtTzFliZ
         4hWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j+XcJIMVM4uEkav1jYKM8jg1O0IYdyLWsof36nok6Kg=;
        b=cfapleJ2/VdDFt3kEVJgHtR2wcwHPe2+xCMa9jDxAX0phJk38XbCJSlqRvaScxgmLc
         bE4OKDYFst0OdpxtTmQaGKGFJMAL/1aG5p/kGZyLqIeK0M8Hg5uW5RIk9oVAXSeibYdD
         sOI3dLUgJ0xaGmJRSP+ADCJXD+hWSg5JhZ0fXMkavjmnwbLC50yumgh4PDKL5GDladmP
         s6gjr0fgyzaYVePfBELGUSZwLAaONwviFuRMwVjZVwc/x6SYPPUyQZtJzh4yEKQzoBJb
         PzFZTlpFUCW7rSqwGJJrCZTxfwaMhqkj3T93qeV6mcga4YXtjMGY7XO/IUlti2CCnHSB
         aQOw==
X-Gm-Message-State: APjAAAXnSuxSHykkthNucEYGrTyj0dL9BRBDiKyfKW6MQwXlJDfrS65+
        YxkAfQaF4eM2e3T2tXcBpgl2dyCEdqLxb3oaIPk=
X-Google-Smtp-Source: APXvYqwm5HRbPxxdHKlTlvSzZGP5cU118CHcWjSt3kF6wsiQKJa3iQK3xQXMpkoLCjwHXr/2H28fuTmwUk18mlgyzJk=
X-Received: by 2002:a63:fa4e:: with SMTP id g14mr41437706pgk.237.1561507546991;
 Tue, 25 Jun 2019 17:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
 <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
 <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
 <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
 <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
 <CAM_iQpW_-e+duPqKVXSDn7fp3WOKfs+RgVkFkfeQJQUTP_0x1Q@mail.gmail.com> <CAM_iQpXj1A05FdbD93iWQp9Tcd6aW0BQ3_xFx8bNEbqA00RGAg@mail.gmail.com>
In-Reply-To: <CAM_iQpXj1A05FdbD93iWQp9Tcd6aW0BQ3_xFx8bNEbqA00RGAg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 25 Jun 2019 17:05:34 -0700
Message-ID: <CAM_iQpVT3dUKoZjeZDE3Mmk8C8OMtOE4_05Wq19C7VWDTQeSSw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Jun 25, 2019 at 11:07 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On one hand, its callers should not need to worry about details
> > like overflow. On the other hand, in fact it does exactly what its
> > callers tell it to do, the problematic part is actually the
> > incremented id. On 64bit, it is fairly easy, we can just simply
> > know 'long' is longer than 32bit and leverage this to detect overflow,
> > but on 32bit this clearly doesn't work.
> >
> > Let me think about it.
>
> Davide, do you mind to try the attached patch?
>
> It should handle this overflow case more gracefully, I hope.

Well, it looks like it would miss UINT_MAX... Let me see how this
can be fixed.
