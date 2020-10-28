Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117A929E25E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404304AbgJ2CNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgJ1VgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:36:04 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211D9C0613D1;
        Wed, 28 Oct 2020 14:36:04 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a9so661855lfc.7;
        Wed, 28 Oct 2020 14:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jZnHZxbemTK8Et5phPSlcBe8HI+ttdbLi+0KG+29+DI=;
        b=kELTI7roGcPazb/IHGW7WPvulAMIem/r2+jPs42DCacHKCvXLYg4uskBt1wR8Xwg01
         LYAgxVceCU1l8yNID0PBGyRhnVrJ9buuPoJUSsN7U1p3QLFIrti8ptrVb8d6AV5V9REQ
         CcZ7tC3c3IoIrzUijO4+CaQ6U5Ot4DRKf2jHp1wBXzYcfuE+ChSPUHW2PAvO1enQp7Gn
         ZSxO24VN0BjDrgoxXBN7ROo1hbF/DMB7rMxm/1RGMVO6qQWx3u53qEZ8Q1lvzpdc/p3S
         0y8kFXHRtS8E0dhwbvb2acEcvfR5E+N+uThKIJIggE4nyQuodC023kt5QENIBrU9Bb/t
         VgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jZnHZxbemTK8Et5phPSlcBe8HI+ttdbLi+0KG+29+DI=;
        b=r2VuuK07mAYEg3bwVXtHa6d5ZmgQE1ew4s6btD7lTkVmXYnO3wU5U+XuQ0ZC844k92
         dkOWSqFuUZ5YDaOiLgn/tJyjw1FSGecOfmQ7g1FVrK1k2XPEnIug2ft+VJ/Tkvdw7Dmg
         8p8Ky73Bc5odowL+CC3QzJHjvJVg7yo/r+CaTGsADJSoA1iTUYmsh5vUlOqFNLzG7lQg
         b11AplfbaakS+s6ve0//ZXJMFWId+CqBXcTHLBpvHzfFpNKLLqoE63LaTII1f8FRy+/h
         oElpUMXnQ11MhZyJQgQ3SphipEMQjh0to07Y2eQGLOyfxMrDrbzI+/lsvK3pfb1kDN0h
         lnHg==
X-Gm-Message-State: AOAM531UsINuWmCErpM8pqqzpKfEo0agMOgA4/PYslocBBEkSOvst/+7
        bbb/kQcChltpcPVuxDi1aw2IN+PN4UAAfpFo0UQuEUxM
X-Google-Smtp-Source: ABdhPJxCpPHrWHa/WqMXcxs4Lhtvg/33XhPAQiJ9AZnCNZmXAg08su2yr35YALMK70LBHTk2R8bPERS5NAODnOaxnYw=
X-Received: by 2002:a17:906:a250:: with SMTP id bi16mr804442ejb.265.1603917497258;
 Wed, 28 Oct 2020 13:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201028194148.6659-1-elder@linaro.org> <20201028194148.6659-6-elder@linaro.org>
In-Reply-To: <20201028194148.6659-6-elder@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 28 Oct 2020 16:37:41 -0400
Message-ID: <CAF=yD-J+qDcGnVkODTReK64Cr+RTVuT3uT8VfAHs-hm0+4arug@mail.gmail.com>
Subject: Re: [PATCH v2 net 5/5] net: ipa: avoid going past end of resource
 group array
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, evgreen@chromium.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 3:42 PM Alex Elder <elder@linaro.org> wrote:
>
> The minimum and maximum limits for resources assigned to a given
> resource group are programmed in pairs, with the limits for two
> groups set in a single register.
>
> If the number of supported resource groups is odd, only half of the
> register that defines these limits is valid for the last group; that
> group has no second group in the pair.
>
> Currently we ignore this constraint, and it turns out to be harmless,
> but it is not guaranteed to be.  This patch addresses that, and adds
> support for programming the 5th resource group's limits.
>
> Rework how the resource group limit registers are programmed by
> having a single function program all group pairs rather than having
> one function program each pair.  Add the programming of the 4-5
> resource group pair limits to this function.  If a resource group is
> not supported, pass a null pointer to ipa_resource_config_common()
> for that group and have that function write zeroes in that case.
>
> Fixes: cdf2e9419dd91 ("soc: qcom: ipa: main code")
> Tested-by: Sujit Kautkar <sujitka@chromium.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

Acked-by: Willem de Bruijn <willemb@google.com>
