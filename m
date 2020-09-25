Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0073279458
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgIYWqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgIYWqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:46:20 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA19C0613CE;
        Fri, 25 Sep 2020 15:46:20 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lo4so738761ejb.8;
        Fri, 25 Sep 2020 15:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lrVKWzlDcGFhCrWgMifQZRLCGQ0NtpunSOEi48viSH8=;
        b=aNXJTlRNvZq5vFI7352QqBShKwE+D0YCXNgufsf0zU5cxvnSadfe/RttWPBqBdSjlp
         w7VrhUPHAKSQmmFMTjSWmwUmsg9ZqoB1kdhzk3b5mIrhaLtdXNKyH+U20iyfTpYtSmim
         wcI/e7JPqPPaVYOTaiNfGgNSb9ff2rts5FTpbkhH5h+V72M6z4A3mhDT2HjGBdvAlY3g
         6y09YGie1G8Irk6wf5/Rzf3QCU5vwdQPzLDi/GWWgurYpYPUGMATQGC+C+09GUtcEglQ
         VhRnwgl8GCw1VPbqasMr0TjfEsA+6ajnzoeF3SDlwZJVQj+VdVAFvwQFzK1XXdAJlO5B
         k+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lrVKWzlDcGFhCrWgMifQZRLCGQ0NtpunSOEi48viSH8=;
        b=eo8wCvVt6j+M+t55xIO7IMR32PhAVCwfsJ4a/gdJtI3BbRxOJX4158KVfaJpRPJG3G
         HbSGOWCrPdRBOUq3Rufm2Y8tGQCy1DwXkAJXVTP2ZXk9IKY/m5cqJp7AzajP6nGkmdEX
         fFTm0Ma183//LdZSlXSoBIuZ59DHJ9He2x3YPPrhERYLg5rp7rzjPOAy8MfX0aQGmHfP
         U0etxuuOSSK59qT5t91MDf2QqLkLXIu3jw4RWi4Fgdufl4igxILz0M0Kfya00xwiWkw6
         7eL5u75KyHGdrC1MLXAF/LlSShpDJReQKfvLhAqb0qRdh076ExMOps3g9suZQjCrXsy6
         MKQg==
X-Gm-Message-State: AOAM531DOY2PJAznQtkKVSXBtz4yO7Fg6bSiFkyus12GOUuVoYCGw1k7
        AzRSyzjhPelRABut1AKgDGY=
X-Google-Smtp-Source: ABdhPJwVwZ0jezDaQdRB6TwC5/deAJ5D6Lv5vjVPupgSdS91PARaHHgvQ06C6wY5XEH+1quAeU52Ug==
X-Received: by 2002:a17:906:1f42:: with SMTP id d2mr4816511ejk.407.1601073979139;
        Fri, 25 Sep 2020 15:46:19 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id s7sm2744100ejd.103.2020.09.25.15.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:46:18 -0700 (PDT)
Date:   Sat, 26 Sep 2020 01:46:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
Message-ID: <20200925224616.fetyq4aiiwpspe7g@skbuf>
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
 <20200925220329.wdnrqeauto55vdao@skbuf>
 <CAFBinCB4woR1sZfT3tvCkHiR2eRgQfXg3jsD+KO0iMzyQRAGDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCB4woR1sZfT3tvCkHiR2eRgQfXg3jsD+KO0iMzyQRAGDQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 12:15:59AM +0200, Martin Blumenstingl wrote:
> I do not need the auto-detection of the phy-mode nor any RX/TX delay
> (these are fixed values)
> however, from that patch-set I would need most of
> phy_rgmii_probe_interface() (and all of the helpers it's using)

So if it's not clock skews and it probably isn't equalization either,
since to my knowledge RGMII MACs won't have because they are parallel
and relatively low-speed interfaces, then we need to know what exactly
it is that you calibrate.

As you know, in a serial interface you are likely to find a BIST
function implemented in the SERDES, this would basically offload to
hardware the task of sending and decoding test patterns such as PRBS-11.
With RGMII, you are less likely to see a BIST in hardware, hence the
manual injection of packets that you need to do from software. Whatever
solution you end up choosing, it would be nice if it created a nicely
structured UAPI that could be extended in the future for other types of
electrical interface selftests.

> also I'm wondering if the "protocol" 0x0808 is recommended over ETH_P_EDSA

It probably doesn't make any difference.
