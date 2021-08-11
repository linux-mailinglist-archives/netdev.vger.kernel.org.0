Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2988D3E929F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhHKN17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhHKN16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:27:58 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E9BC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:27:34 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a7so4538905ljq.11
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZuBd5enMO8h0t+yqn/QeRGMnrstN0G+f4xNSiW5/U/g=;
        b=pPng6oGEQXet4WeHs05MV4KAu5N2sQWAqvZ7w+n3F/AKyHyEDVgPxi6c3gNioAcSgS
         NIBqH0VV0KCROO11TH/BAXTY2yy1MSw6L7CzCcM6QWTevHyYIizv11QlWGF27FqZ6fgG
         t5xyig4dfPIx6JEYnw/MjJlq0mDEEx4qNWcwYLP5OUvQeUV0sDCJlkP3mGGQ8pgH/L3w
         E8JDODM55C0gvx6a6B/noUKo+JFYWohLw4Az453z02M0DY43IqLA+SxoP/dd1UWPjASE
         BYRZ1BpY0s3Bt7rd1bfngSiFV1Ra2tVhfzUm/CKESICaEl2pdv05S1XSmzIMXWi8pJsw
         JYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZuBd5enMO8h0t+yqn/QeRGMnrstN0G+f4xNSiW5/U/g=;
        b=l20e1Ub+jCCbmSwbJDd2pnTTMUvLELV+Eb8nR9nBwWiUsEOVowneeF/2b9DygCZARe
         IEay/cqPc1IgbXXKxHuJkg0ODzO2QozAdG7WZDv9X8XW1W36by1eDRaRqdEDSvOZkC+B
         skXfcT+XGwzCvBm+k/O3rica6rAHiwTArp/nGESKKxuT8nvkENFZX+7VhW/94XTK7Aaf
         LvI2sPR//s9uMz+pMLWFbc9PQbTUs+kCUedIw9YX+LlILqXcEUhE8jGJb5zL9LwldiLN
         9xYggVOVQFhBwG3yBsGZ6JgCqHT8H9jmiUBQkWv8X8GhWbAmOBcGaUQgmqzVn9FxW6Yw
         UylQ==
X-Gm-Message-State: AOAM532uMGWt7gXjV6OG/jmysspd824sWAf7BY7IpHaSixzvv5gUzoB2
        UuCMLxh1F0XTDbWGSbYe/GMfiYO21Xf2MjQDbV1gcg==
X-Google-Smtp-Source: ABdhPJx5rIX0LBDri1O1zKziGtcEwXue0qheyTh34nQgH70+eQbgbU5+YALbidGVcqkZ2+VquFCJpxkA9ynS5aq7Hs0=
X-Received: by 2002:a2e:a231:: with SMTP id i17mr12819700ljm.467.1628688452523;
 Wed, 11 Aug 2021 06:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210809115722.351383-1-vladimir.oltean@nxp.com> <20210809115722.351383-4-vladimir.oltean@nxp.com>
In-Reply-To: <20210809115722.351383-4-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 11 Aug 2021 15:27:18 +0200
Message-ID: <CACRpkdZW+ySvyQC_eaYJby+83=G+Wy7DW-C2arrJhwE1mqbBaQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/4] net: dsa: create a helper for locating
 EtherType DSA headers on RX
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 1:57 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> It seems that protocol tagging driver writers are always surprised about
> the formula they use to reach their EtherType header on RX, which
> becomes apparent from the fact that there are comments in multiple
> drivers that mention the same information.
>
> Create a helper that returns a void pointer to skb->data - 2, as well as
> centralize the explanation why that is the case.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
