Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029752B5F68
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgKQMw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgKQMw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 07:52:57 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD496C0613CF;
        Tue, 17 Nov 2020 04:52:56 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id o71so18514648ybc.2;
        Tue, 17 Nov 2020 04:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=396qJVY6ErHdgJBEcIkB7PgsMbRLrKyXYL9zfaRd/qI=;
        b=ljuzswvwjOBJz6QVKdgFaDEJ//ZSe2x78P2n3bpFsDydu66PaCJZj9mm9rolc7GESg
         U+buqkde9mhtuDxCFvE0Z67DmE1W5N9rq2MY6RXx1Eds6Gl7Uw0MLBTFANRsv3e4UIKZ
         ijps7KojO+B+tR1aNLiSNZqGuB9Inswy0UqT2wpkXflfHi9bJG8Y6lKZFlsZ7SQhZ1fE
         EXbEgnG47XBehfKp06WLHyy0zj8hIAIGVpnGMWvPbqqPl9sFrknerdiovMTrNdOxdLMy
         RuARZhOcBwEL4che7mJupjD4aiGosuU6TslLUbliUHKSNKOOnSUyeVWuZDZIAV+khh4s
         11vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=396qJVY6ErHdgJBEcIkB7PgsMbRLrKyXYL9zfaRd/qI=;
        b=VfRYeaJbhyvC7WJdFYUiagTAiwtc7nJi5Gv1D7T2pExV38UKEzpe83R6vUqyH9PDma
         kp18Kl/TiTJ5vtltZWNMzGx1QZu0XGcEWYXOSxzgELOZ9dYi/zYLMPNf+fYJYK1ayKJa
         qjZCKdsuY8wHvwhXvOKMr/euG5/wwBRNBIRkKjUIMm8tOncX3obSSNHySOj/0zaq5oRW
         NBpnG7uiixGX0OEOGrrA3BsMDT0w5ZgqBcczQrr8SesYJI+MzNcXnQOedeq26xMAj2IY
         tM//a++0nFJ51DIYClVxlrs0vQ9ZLimUcKgerUBiVeEJocq4xuXOfk53ZmYKdGEJdeYe
         k1Lg==
X-Gm-Message-State: AOAM5319zPbVib355uEIDHCjpm5HT5CuyrUKUzFO+WYC72oJnqLrxMTx
        l1RqQzIidPng69UFiLWrRgnwRyA+eLb1NBuqja0=
X-Google-Smtp-Source: ABdhPJy+tdbnrh5Atxyg1T06ymJ1SZqSL1AyP5t5SJlfh8h5YbXSVsku5ZXdl158y5y1HDHNNXjPCviqAeJeZk41j5A=
X-Received: by 2002:a25:2d55:: with SMTP id s21mr23025144ybe.389.1605617576209;
 Tue, 17 Nov 2020 04:52:56 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
 <20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
 <20201117074207.GC3436@kozik-lap> <CAEx-X7epecwBYV7UYoesQ9+Q8ir+kjYGyysiyDtCa0BzKiCGtA@mail.gmail.com>
 <CAJKOXPdH49zOQ2caOvDDiZPkEptYiCjUmXw+O2dCC1tKHZgPag@mail.gmail.com>
In-Reply-To: <CAJKOXPdH49zOQ2caOvDDiZPkEptYiCjUmXw+O2dCC1tKHZgPag@mail.gmail.com>
From:   Bongsu Jeon <bs.jeon87@gmail.com>
Date:   Tue, 17 Nov 2020 21:52:45 +0900
Message-ID: <CAEx-X7eMXK5DuxEae2rbHaKOceUHNS3Ubx-2tpMET0ofSsy+pQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] nfc: s3fwrn5: Remove the max_payload
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 5:39 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Tue, 17 Nov 2020 at 09:14, Bongsu Jeon <bs.jeon87@gmail.com> wrote:
> >
> > 2020-11-17 16:42 GMT+09:00, krzk@kernel.org <krzk@kernel.org>:
> > > On Tue, Nov 17, 2020 at 10:16:11AM +0900, Bongsu Jeon wrote:
> > >> max_payload is unused.
> > >
> > > Why did you resend the patch ignoring my review? I already provided you
> > > with a tag, so you should include it.
> > >
> > > https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> > >
> > > Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> > >
> > > Best regards,
> > > Krzysztof
> > >
> >
> > Sorry about that. I included the tag.
>
> You need to reduce the rate of sending new patches. You sent v1. Then
> you sent again v1, which I reviewed. Then you send v2 without my
> review. So I provided a review. Then you sent again a v2 with my
> reviewed tags. So there are two v1 patches and two v2. Since I
> provided you the review tags for v2, no need to send v2 again. It
> confuses.
>
> Best regards,
> Krzysztof

Sorry to confuse you.
I made a mistake because I thought that you asked me
 to resend the patches with the new version(v2).
I think you intended that I need to version the patches and
describe changes when I update the patches next time.

Thanks a lot for reviewing my patches.
