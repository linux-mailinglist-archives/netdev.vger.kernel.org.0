Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83772C65B6
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 13:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgK0M0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 07:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgK0M0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 07:26:48 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5F8C0617A7
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 04:26:48 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id z23so858979oti.13
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 04:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=INnUE0sM05L2oreqITOkcAXoqFYcu3Qaos8NOOfhOTQ=;
        b=RbEhXeDCcLG6KFDkofW6vC2lhXZqLixRKztRPhHHADZRxFmCHKdxew/X6buNWyeQPm
         SYTCpiakjEpW+R8ggJqq0BhGj1sINRcXMaxNZK9Tk6K2uGLRZup8ZfiiYKo5zWSddhXs
         ZkaMa3TBB4WEa3vG8H4QlHbg76bimbJQoWPGEYk33YfOdQ1tFIC0mZRG4eyAW1mh6P1T
         kfYL+YsACuuilf3sSPfHlVGeAWtM+oyTeQkb3wiXYjHLho1D1p33cNvAaGnZapYl8OaB
         X8jFOlYbYYiWOAx24QFMufWRlk5KCUEDVZhTzFQN0nL0KeuP9RNuurTu6UfQWwl0y9oc
         hPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=INnUE0sM05L2oreqITOkcAXoqFYcu3Qaos8NOOfhOTQ=;
        b=T2jxWQOKL1YuMChT87abF5JVjVi4l2FeoTGsl8IsnUSzncrfdoVQSScJ7rEHZ/oHsC
         L1pXFI6WiuNr5/NJyxFJNHe445yb6UwfQG0M9Q76tH3K2I+B2/N5BCX5R8RYykGS7FUA
         X6S1XhE0PIZc0Xa2QSaW1TH2vZ0tAe9fbzGh2hCe6qqCCgCNFiS2VY04VNOp8s5zP2/W
         NZtLQG0+BMrT7tMH7vshW96KUf8Pzhh+/43R1yx9m5Bny+91iJGwNRYLmS9N7LdZ77SP
         XGXimGC4X2o3jpeviZPyGpg6S04qrTnpST3NHojbTJMmJrvoxagtKNosB789bTXYvgV5
         kt8A==
X-Gm-Message-State: AOAM531UnBeIN1pE9dsWTvZ/v8p4QXBrIfj6kPlfUkQlh3dZ9jW/ndsi
        dW0UK4JPKyGoV/Ci5IhoJAUxxpUXBlyVR5fqEP5Jtg==
X-Google-Smtp-Source: ABdhPJwdkvpfZpec4AJHnHkvroUWUD22bNL8+btJPZre9LvmpggYaMzTkVMfQJdGNDxedL3NGUqUi0acSmkdra7e+ek=
X-Received: by 2002:a9d:7d92:: with SMTP id j18mr5921417otn.17.1606480007166;
 Fri, 27 Nov 2020 04:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20201125173436.1894624-1-elver@google.com> <20201125124313.593fc2b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANpmjNP_=Awx0-eZisMXzgXxKqf7hcrZYCYzFXuebPcwZtkoLw@mail.gmail.com> <CAF=yD-JtRUjmy+12kTL=YY8Cfi_c92GVbHZ647smWmasLYiNMg@mail.gmail.com>
In-Reply-To: <CAF=yD-JtRUjmy+12kTL=YY8Cfi_c92GVbHZ647smWmasLYiNMg@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Fri, 27 Nov 2020 13:26:35 +0100
Message-ID: <CANpmjNO8H9OJDTcKhg4PRVEV04Gxnb56mJY2cB9j4cH+4nznhQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: switch to storing KCOV handle directly in sk_buff
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Aleksandr Nogikh <a.nogikh@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Florian Westphal <fw@strlen.de>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 at 17:35, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> On Thu, Nov 26, 2020 at 3:19 AM Marco Elver <elver@google.com> wrote:
[...]
> > Will send v2.
>
> Does it make more sense to revert the patch that added the extensions
> and the follow-on fixes and add a separate new patch instead?

That doesn't work, because then we'll end up with a build-broken
commit in between the reverts and the new version, because mac80211
uses skb_get_kcov_handle().

> If adding a new field to the skb, even if only in debug builds,
> please check with pahole how it affects struct layout if you
> haven't yet.

Without KCOV:

        /* size: 224, cachelines: 4, members: 72 */
        /* sum members: 217, holes: 1, sum holes: 2 */
        /* sum bitfield members: 36 bits, bit holes: 2, sum bit holes: 4 bits */
        /* forced alignments: 2 */
        /* last cacheline: 32 bytes */

With KCOV:

        /* size: 232, cachelines: 4, members: 73 */
        /* sum members: 225, holes: 1, sum holes: 2 */
        /* sum bitfield members: 36 bits, bit holes: 2, sum bit holes: 4 bits */
        /* forced alignments: 2 */
        /* last cacheline: 40 bytes */


> The skb_extensions idea was mine. Apologies for steering
> this into an apparently unsuccessful direction. Adding new fields
> to skb is very rare because possibly problematic wrt allocation.
