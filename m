Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B050823C7B7
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgHEI1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgHEI1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 04:27:17 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EB2C06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 01:27:17 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id q68so10587747uaq.0
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 01:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F7LdPoSBmJ0LNYKoIcAeTECXL5JjnuRHLO7E4MYntPU=;
        b=Jvlc6idEfxu2+hFOqTFX8BBf1420XpkMTfq21cMY/yHXJEACSJBbrDTePXL+czaqwb
         lAGAalQYVHc6UFmzssJsX5cBnEQBW0tvNmom0vo8BsQgXBTmhBWsmrDj1pq3olDzcJ1I
         RLcby2T/PA5S7r0k1AF+LKIpouln9+XBCUNpYDQW+gBnddzkHWcOWQyszazQ/uYSToYW
         MzucpPKwFBoFBJEjpdgF+3TT6fZ7e8OGYu6znwGNQcDzT6YaCLrCG3kYFjIV5PHjXjeL
         0OuF5wJPpEkJ6hIN2Qmg8Bb0mpP3/186X5LWZohXoE1g74KLRu/27SzihL2CCdtpbJM9
         4t6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F7LdPoSBmJ0LNYKoIcAeTECXL5JjnuRHLO7E4MYntPU=;
        b=X7R9Qa2AuDrvg1c4nuBLODljshqDgBuWuSxDgdUxBCBgzYmsF+6pNa9APobw0hWvhO
         rP9wE1aZQTGoMkj0Y2EaPoiEWpgMlkjKIdi53imNtpb06w2inP4WqrqDyrz6cOjYo2Oc
         a2k/cj7GmRhrv0SUv3mdHRmGNKkggUylNHJB2p1RWSqoNuJP4kEQI1uKMoA3RaBZhUlq
         JjpTImmzW2yWYUQki2iTDcR22NDeLuO4ANSbimE0scFbPlXuXNaemwXs4yvjRxXAKkEC
         11oNnlM5pvYTboWNJbbzml/E+AnN+HYAvNEPem2oUNLAjha2lS7XKrw9Lth2mirzJG/s
         e5/Q==
X-Gm-Message-State: AOAM532JTyKJxLylIYFEuoEXK/qaTn6F0Rzl+VHVxo1JFRpnMnlklmhb
        JSmfnZbTUoVrXN9fL0Dm8NTYgK4oIiA=
X-Google-Smtp-Source: ABdhPJz7amtbq4xLJPWoYUDE0td9a+s0DVTndwjbc4kl6slEKIbzWVv8aMjxxwj6B10xQcGSWO0K1Q==
X-Received: by 2002:ab0:4282:: with SMTP id j2mr1216070uaj.132.1596616035872;
        Wed, 05 Aug 2020 01:27:15 -0700 (PDT)
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com. [209.85.221.179])
        by smtp.gmail.com with ESMTPSA id y6sm270836vke.35.2020.08.05.01.27.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 01:27:15 -0700 (PDT)
Received: by mail-vk1-f179.google.com with SMTP id x187so7672036vkc.1
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 01:27:14 -0700 (PDT)
X-Received: by 2002:ac5:ccdb:: with SMTP id j27mr1532302vkn.43.1596616034560;
 Wed, 05 Aug 2020 01:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200804155642.52766-1-tom@herbertland.com>
In-Reply-To: <20200804155642.52766-1-tom@herbertland.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 Aug 2020 10:26:37 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfw+XT9kQ4y-dY_M8zc2TksCSSEa-0WY+muyv_yr9_H=A@mail.gmail.com>
Message-ID: <CA+FuTSfw+XT9kQ4y-dY_M8zc2TksCSSEa-0WY+muyv_yr9_H=A@mail.gmail.com>
Subject: Re: [PATCH net-next] flow_dissector: Add IPv6 flow label to symmetric keys
To:     Tom Herbert <tom@herbertland.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 5:57 PM Tom Herbert <tom@herbertland.com> wrote:
>
> The definition for symmetric keys does not include the flow label so
> that when symmetric keys is used a non-zero IPv6 flow label is not
> extracted. Symmetric keys are used in functions to compute the flow
> hash for packets, and these functions also set "stop at flow label".
> The upshot is that for IPv6 packets with a non-zero flow label, hashes
> are only based on the address two tuple and there is no input entropy
> from transport layer information. This patch fixes this bug.

If this is a bug fix, it should probably target net and have a Fixes tag.

Should the actual fix be to remove the
FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL argument from
__skb_get_hash_symmetric?

The original commit mentions the symmetric key flow dissector to
compute a flat symmetric hash over only the protocol, addresses and
ports.

Autoflowlabel uses symmetric __get_hash_from_flowi6 to derive a flow
label, but this cannot be generally relied on. RFC 6437 suggests
even a PRNG as input, for instance.
