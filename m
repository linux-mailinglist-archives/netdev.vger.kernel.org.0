Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424E430B44C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhBBAu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBBAuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:50:25 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DC7C061573;
        Mon,  1 Feb 2021 16:49:45 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h192so21006599oib.1;
        Mon, 01 Feb 2021 16:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZ3KGl0h1neaojkBgg4SZbESMR55ZNhc/UsqdvzAY2o=;
        b=ND4SR2LkIHuqIOZ4WzjpzLdlT/v69Qr6LzJ+vCOXf8nQlxqZFcMnc+19h7XRphwcTT
         dCJLHlU7rzjwV7y3RndGmKXY6rS3THLVJOKI0FDD1JwsyUKeRupec8eL3NA4RGzV475O
         CfSgTqAWKXmXSRfu/k+ggbIlEKae2suKJcT9PAt/b+WpwCLA9eAvIupn3JcrYyeQ6vhk
         O+Z9EgaZv3faqnowLWK9BL6aauZ+yutDyatwv587UvGulANdW18Wxk/gjJCg8yEyQhj8
         DXxaiPAbuwAG5joes055zItBl8D1KXTaCisBeMtUhDvYh/ldZs8WYBS6czaFzSaybVvR
         1fIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZ3KGl0h1neaojkBgg4SZbESMR55ZNhc/UsqdvzAY2o=;
        b=KGnKuSOJCvhAgoS5Ww5NxSsUG0syBuWs5brxDxVoKQ/qPNGQEiaglKilWgl2NDZbFu
         Gh43It3STvPYhrso9hPuJ5k1XpdFvnEAJp8pCTBMk7+/1Xb+jvZl8RBcS18WFh0ixPud
         hMObMMRmYsItfMR6rsP9mIMZTIqCgGN90q6uPBsw8v8NumyUhMK+Gf6AhU8/PUeF9J1M
         sBVQnDEtizP8lHQYtA42In187vZ5iRZDHDUUx6t/b2720iJ4RrLV3OeqYmP8MTv51+zZ
         nYVwbDnX3G2Z3tk9NDtSYYI5gSNlaALND9yLpdh+rj1TWk8WD6qAuu5wRT31hqBCnoTf
         4p1w==
X-Gm-Message-State: AOAM533K3u/PQdySQjpQAblA5uFeV2XYNt23FY/sedE+DAP4aPnfy5Yf
        s9IJFyVNkLr8woBvF1hiV2lqeY8yzKg67+/LpkI=
X-Google-Smtp-Source: ABdhPJwoIdYkGn6frhtqu3acbFk7/QCamM09W36YbaetbA7rzgrbBvmCH3/GTny6FBt0cJr/7g+3mw13g+2lUj1ifLg=
X-Received: by 2002:a05:6808:1290:: with SMTP id a16mr989423oiw.161.1612226984490;
 Mon, 01 Feb 2021 16:49:44 -0800 (PST)
MIME-Version: 1.0
References: <20210201232609.3524451-1-elder@linaro.org> <20210201232609.3524451-4-elder@linaro.org>
 <CAE1WUT6VOx=sS1K1PaJG+Ks06CMpoz_efCyNhFQhD83_YNLk5A@mail.gmail.com> <5a415ba4-9d69-5479-3be0-c5e6167b0f8a@linaro.org>
In-Reply-To: <5a415ba4-9d69-5479-3be0-c5e6167b0f8a@linaro.org>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Mon, 1 Feb 2021 16:49:33 -0800
Message-ID: <CAE1WUT4nGrNXEOFNRygFHie6dZVCQTXAgFvVDzW7hgf6W-UVkw@mail.gmail.com>
Subject: Re: [PATCH net 3/4] net: ipa: use the right accessor in ipa_endpoint_status_skip()
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 4:15 PM Alex Elder <elder@linaro.org> wrote:
>
> On 2/1/21 6:02 PM, Amy Parker wrote:
> > On Mon, Feb 1, 2021 at 3:32 PM Alex Elder <elder@linaro.org> wrote:
> >>
> >> When extracting the destination endpoint ID from the status in
> >> ipa_endpoint_status_skip(), u32_get_bits() is used.  This happens to
> >> work, but it's wrong: the structure field is only 8 bits wide
> >> instead of 32.
> >>
> >> Fix this by using u8_get_bits() to get the destination endpoint ID.
> >
> > Isn't
>
> (I saw your second message.)
>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >>   drivers/net/ipa/ipa_endpoint.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> >> index 448d89da1e456..612afece303f3 100644
> >> --- a/drivers/net/ipa/ipa_endpoint.c
> >> +++ b/drivers/net/ipa/ipa_endpoint.c
> >> @@ -1164,8 +1164,8 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
> >>                  return true;
> >
> > A few lines above this, endpoint_id is initialized as u32. If we're
> > going for "correctness", endpoint_id should be a u8. But of course,
> > this would contrast with ipa_endpoint having it as a u32.
>
> You are correct, endpoint_id is *defined* as type u32.
>
> But the issue here is that the field status->endp_dst_idx
> has type u8.  u32_get_bits() assumes the field it is
> passed has type u32; while u8_get_bits() takes a u8.

Ah, missed that bit. Thanks for clarifying.

>
> The return value of u8_get_bits() is u8, as you might
> suspect.  The C standard guarantees that the u8 value
> will be promoted to the u32 target type here.

Yes, it does, and so it wouldn't be a theoretical issue - just an
issue of developer confusion at first when working with it. But the
above outlined point of the types taken is more important.

>
> >>          if (!status->pkt_len)
> >>                  return true;
> >> -       endpoint_id = u32_get_bits(status->endp_dst_idx,
> >> -                                  IPA_STATUS_DST_IDX_FMASK);
> >> +       endpoint_id = u8_get_bits(status->endp_dst_idx,
> >> +                                 IPA_STATUS_DST_IDX_FMASK);
> >>          if (endpoint_id != endpoint->endpoint_id)
> >>                  return true;
> >>
> >> --
> >> 2.27.0
> >>
> >
> > As far as I see it, using u32_get_bits instead of u8_get_bits simply
> > eliminates confusion about the type of endpoint_id. Perhaps instead of
> > this patch, send a patch with a comment that while u32_get_bits is
> > used, the field is only 8 bits?
>
> No.  We really want to extract a sub-field from the u8
> value passed to u8_get_bits() (not u32_get_bits()).
>
> Does that make sense?
>
>                                         -Alex

Yes, it does. Thank you.

Best regards,
Amy Parker
(she/her/hers)
