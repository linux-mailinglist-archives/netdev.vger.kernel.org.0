Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD0339E93
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 15:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhCMOh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 09:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhCMOhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 09:37:36 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB6FC061574;
        Sat, 13 Mar 2021 06:37:36 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 16so3813145pfn.5;
        Sat, 13 Mar 2021 06:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RGxC/EbqAqWJoWig6i2s5eFWML9aDrIxAEI8FcL05fI=;
        b=RYftM/uXT/NCtd9TP2b1FQi5rHfPBVyoYrlPtJUJiT0ZaZBusuV74RYrJXF5vNvm/h
         L/cIbvyncaxhJVyVrRz/rLDf6sIfowbw2KAHJcSeoeVsFplKTwcHrW1dkhBY89yQk+dD
         z6Lhzk5w3Xx4TuJ713AvZ210HB9ojLnPNjoJFPgpnV7tzPRuCqKzeSPBRKY+V0FmoIbM
         HalRDuwTTEKaQhpDq0J2x+HbQfyPW+pR5Qyb7KMOLvWrD1GNVtIGhCdWjBueTHu+ut8I
         73BqO8J6u/6TRXzt5N8xmugYhbJRZfVLWavdprhoLL0tlb049MHQH/6iNVhCg8Ui7Nh/
         sIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RGxC/EbqAqWJoWig6i2s5eFWML9aDrIxAEI8FcL05fI=;
        b=bcMbt4sKMo/ZK0jgKGIzQ6GxeIkBtvNdoQ3E6MqnmP9U7xQQGcoTlH6sE/EyqYieuz
         7/ED48J4rBQEo+MZhlPYCAp0WE/1kYsv+aXk+rRqzmTq1AB12F/tgbOzTQowTvGLqd/9
         QVDytPDeXozzpYqRpucIUfmtYJEIVnFTkjTmK6VZ30nkc/wZDQZBln/otfXRg3AHGBgJ
         dtGpRYfCAjeX6vzb6MKkuk5UapXqUF560LADPa5CRzitalSBdFwfo8MdSe35HnE4CLlm
         NzQyCUoxnJ5v/9QKeMNqRD90jt8bJZqaV91B7oxOqXA2L0PzPgacP3eV+KecI2lyJb8f
         UX8g==
X-Gm-Message-State: AOAM533uqhecvtNljspjY17ZWwjEHO3RnJyXw9btUNLxG7VT1r9hsaDA
        4/TXR4pHI5ZXPK3FNK2fxEiIxkOyjds=
X-Google-Smtp-Source: ABdhPJzMVXk3IoT9X/k3RUK2mlVBANipf7KV6LalBaFaevVVe7lWCOrYRrxHrnoiVCqeoCtaUBYqFQ==
X-Received: by 2002:a62:3847:0:b029:202:ad05:4476 with SMTP id f68-20020a6238470000b0290202ad054476mr2998413pfa.67.1615646255453;
        Sat, 13 Mar 2021 06:37:35 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:29:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 22sm1996907pjl.31.2021.03.13.06.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 06:37:34 -0800 (PST)
Date:   Sat, 13 Mar 2021 06:37:32 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        IDT-support-1588@lm.renesas.com, Jakub Kicinski <kuba@kernel.org>,
        LAPIS SEMICONDUCTOR <tshimizu818@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Rid W=1 warnings from PTP
Message-ID: <20210313143732.GA31725@hoboy.vegasvil.org>
References: <20210312110910.2221265-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312110910.2221265-1-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 11:09:06AM +0000, Lee Jones wrote:
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Lee Jones (4):
>   ptp_pch: Remove unused function 'pch_ch_control_read()'
>   ptp_pch: Move 'pch_*()' prototypes to shared header
>   ptp: ptp_clockmatrix: Demote non-kernel-doc header to standard comment
>   ptp: ptp_p: Demote non-conformant kernel-doc headers and supply a
>     param description

For the series:
Acked-by: Richard Cochran <richardcochran@gmail.com>
