Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9A3076F1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhA1NRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbhA1NRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:17:04 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97904C06178B
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 05:16:04 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id f16so4266461wmq.5
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 05:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a7Kay7oniLiASWWlX9LUAiXElA2SneepAxnVvZ1j9Bg=;
        b=wm0m6q9c7pI2ykqugyIea0bijD0AIdx00BSXxbwNf9QgYWvNFw8u7g0iVVYt98tN+R
         rjUkKmn08QsrSjMYYgeB/BE1Z1aUcapp6QCqdf7hvy5gUsofxEMHByci4Zfw9lL29/yX
         oERUPPJs1zliyHYpPI9tgDdQ0U+aR/L6LMdXAFCyGjUEwkh375xDDu0Y0Bv4A4fL7iLF
         WKss8uZbIloYg2uibFiXWPDP07PR9t8pLYs6U7cPey3J49wkb2Z0K5VlUIsjNVzOJEjJ
         ODqonk+oM9Rgkn7zZM8koJsQ5l0anC8Mqu4tvy1VyRhac92NyvLy31OJvRvDCWk1V+ok
         /jUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a7Kay7oniLiASWWlX9LUAiXElA2SneepAxnVvZ1j9Bg=;
        b=iwzcOi5/LMmfr9os6yppTvcpy/OWOML3cgqRadAd/O9C+sSqziCU85MuA2U7gT6WTI
         6fUgYvyM10KtE03XX2LumlrERFlVzjwnn36uCtwzsAro2rqmvjeP1bydfxYpAlczwZlV
         vJppwpZ0D06LU+KK7VLBB+XfCQ3rN2kJ0zMqkGDzXGpW0W9SYXn6dF8lhDJdxzzpWpQB
         jx672KgVy4WcH3dGa1KYwqf32AW7PvaLnwYc/kjToq9GDLUI0GCtJQY0rQ2Vj8XSBck+
         dwDTP0ugMgqza2x92BA2Y7VCR3j6GJRFTQvwrL5PV9JKQHqBMDwhsf4KhNcCKgLgEI5J
         AXlg==
X-Gm-Message-State: AOAM530RdVlxSnUvLG/VVhWtchf/jV7O02IM67CO75bGmbuEagYapQCe
        GU7AF5WAdut77XkhY1AgUuFrvw==
X-Google-Smtp-Source: ABdhPJy/2U8YYV4YNHpz7d82RHXpW6/38q6C4Nxk6SHw0fG6egfg8QiynFbs+Y23UmRWLv4Pm6w1rw==
X-Received: by 2002:a05:600c:19cc:: with SMTP id u12mr8573435wmq.26.1611839763291;
        Thu, 28 Jan 2021 05:16:03 -0800 (PST)
Received: from dell ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id s25sm5861961wmj.24.2021.01.28.05.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 05:16:02 -0800 (PST)
Date:   Thu, 28 Jan 2021 13:16:00 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        netdev@vger.kernel.org, Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH 00/12] Rid W=1 warnings from Thunderbolt
Message-ID: <20210128131600.GK4774@dell>
References: <20210127112554.3770172-1-lee.jones@linaro.org>
 <20210128110904.GR2542@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210128110904.GR2542@lahna.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021, Mika Westerberg wrote:

> Hi Lee,
> 
> On Wed, Jan 27, 2021 at 11:25:42AM +0000, Lee Jones wrote:
> > This set is part of a larger effort attempting to clean-up W=1
> > kernel builds, which are currently overwhelmingly riddled with
> > niggly little warnings.
> > 
> > Only 1 small set required for Thunderbolt.  Pretty good!
> > 
> > Lee Jones (12):
> >   thunderbolt: dma_port: Remove unused variable 'ret'
> >   thunderbolt: cap: Fix kernel-doc formatting issue
> >   thunderbolt: ctl: Demote non-conformant kernel-doc headers
> >   thunderbolt: eeprom: Demote non-conformant kernel-doc headers to
> >     standard comment blocks
> >   thunderbolt: pa: Demote non-conformant kernel-doc headers
> >   thunderbolt: xdomain: Fix 'tb_unregister_service_driver()'s 'drv'
> >     param
> >   thunderbolt: nhi: Demote some non-conformant kernel-doc headers
> >   thunderbolt: tb: Kernel-doc function headers should document their
> >     parameters
> >   thunderbolt: swit: Demote a bunch of non-conformant kernel-doc headers
> >   thunderbolt: icm: Fix a couple of formatting issues
> >   thunderbolt: tunnel: Fix misspelling of 'receive_path'
> >   thunderbolt: swit: Fix function name in the header
> 
> I applied all of the changes that touch static functions. For non-static
> functions I will send a patch set shortly that adds the missing bits for
> the kernel-doc descriptions. I also fixed $subject lines of few patches
> ("switch:" instead of "swit:").

Oh, that's odd.  This must be a bug in my script.

As I strip [ch], as in *.c and *.h.

Thanks for noticing.

> Please check that I got everything correct in
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/westeri/thunderbolt.git next
> 
> Thanks!

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
