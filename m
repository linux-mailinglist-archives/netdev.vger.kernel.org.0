Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32D930F3CC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhBDNVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbhBDNVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 08:21:31 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F32C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 05:20:50 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id x201so1747682vsc.0
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 05:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/hiAWODlHRq/hh7f1ucWvSrSst2f1xH5hskFyLCl0MA=;
        b=OXWFlO8TE+q6/CZZOysJVRBo1HsI+hN+CM5jRCjYoMo2pA8lt+Ik2W8pLNt2pEnDRd
         7W3qOEI7wT/H/qNF/WT2iQtVnDCFzEUQX0ms/eOHuJv0ghI0uY9DUgl7GCJz+e8dVCIt
         ysjZIzoqkZV2xBuetFpcQnWVP2CStP5FruRSW9z7X9+ah4WiDOocZBXksFnqidRQPrlH
         KmTwVf/ta+iymt06PrhgRGnVsFDDU7N3CJRkPb7etrrpY17kFZqhU+no99kWz+espLMj
         ZkyUsKqkLAe3Q8a+jgPrgIwEFl9jKMDHA6fWIWwp/F5tVe89aOXoAsOOdNGTuUyDE/77
         Na6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/hiAWODlHRq/hh7f1ucWvSrSst2f1xH5hskFyLCl0MA=;
        b=EmftcrDpvYPmFScc6VD3BRoHdiC7EZqc2dx4BBsAloTy3wFl9cB9RJ3ql+a4G1TUiy
         q5IHPgZQDiNclFNnDLv0nhTN1jlfeJk/Fhr/ar+QrhvwqpnYpnXjyJluWg3MpyS3LQ/m
         1LqlEmFqX9SAs/5ABQdSV7I9li1r0hTRo+xccUK2hJztsjLkSkLco/gNvx1fmGuIGMx8
         9j354JfEZWQ3Pff3jezz+yj7iqhAD84Saoayst59uH9Ttk+KW4CsGre5DKeefTMdLIYG
         SRo/jo1NnCEwY8FqW9LwKVzIUa3RD8mOwtnvOW9vZhNDCzxCcn9FWj9lpsc1dgTzOjnt
         uKbw==
X-Gm-Message-State: AOAM5323wbxYzAOtamvAFCvDx0wytQkrTl5ObhCiRI3GvkmiSOPyqdZ+
        XAylFazSH52Kg213Qp9hEHDokIiV1So=
X-Google-Smtp-Source: ABdhPJzlBIIEXJPCk+ki2rYnug1PyON7r1W3PZve1vvS0HIfzGKtwm6QYio65+c2rn8hlWnhNNufuQ==
X-Received: by 2002:a67:fad5:: with SMTP id g21mr5234796vsq.29.1612444849736;
        Thu, 04 Feb 2021 05:20:49 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id y189sm670778vky.21.2021.02.04.05.20.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 05:20:48 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id e10so669258vkm.2
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 05:20:47 -0800 (PST)
X-Received: by 2002:a1f:2c4c:: with SMTP id s73mr5166808vks.3.1612444846575;
 Thu, 04 Feb 2021 05:20:46 -0800 (PST)
MIME-Version: 1.0
References: <20210204101550.21595-1-qiangqing.zhang@nxp.com> <20210204101550.21595-3-qiangqing.zhang@nxp.com>
In-Reply-To: <20210204101550.21595-3-qiangqing.zhang@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 08:20:09 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdxk3V5oqPTOfsBpB18KiO4MGGm2FrU4RCdD-T6ssCL5g@mail.gmail.com>
Message-ID: <CA+FuTSdxk3V5oqPTOfsBpB18KiO4MGGm2FrU4RCdD-T6ssCL5g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: stmmac: slightly adjust the order of
 the codes in stmmac_resume()
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 5:18 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
>
> Slightly adjust the order of the codes in stmmac_resume(), remove the
> check "if (!device_may_wakeup(priv->device) || !priv->plat->pmt)".
>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

This commit message says what the code does, but not why or why it's correct.
