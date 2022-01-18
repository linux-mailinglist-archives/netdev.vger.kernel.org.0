Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ABE492164
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 09:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344674AbiARIkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 03:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240048AbiARIkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 03:40:52 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F61C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 00:40:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id p27so55958012lfa.1
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 00:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=eFp60zM566fMUXfSuCkgCFAYaA/B6xtn0oTLQVf7dtY=;
        b=GYa/Ng60uMnUXuIDsrjGTxhPGC6+q3PUPOg6wzsKhejSjAJgS+AppUgZauK/wSefFR
         wuf3WAw2VJeHrpX1HXmc8Gg6tTnHC5RFk4HuIXSK7z8E93IWaznwicN5FCsXtWzg4jH3
         AtpLVYb+Cj2kfAe+wuQ8VrjtL0DPJ0yWlm2Ayw6dYtpqJRjbBT8N0Yyu3Bp+2rQ1dytW
         8XVlYTIia4l3MC+mkolW/+Jf7lWx2y8UKzwz5GJFmFndBK+OHCbBv9qigDtcdzESHyVt
         SO02zWQ5iqyr2WNizeTmkvr0L7sA4e34abMqhKC4tKkHbHD9pDEzNa5w10tVc8tNqNY9
         QHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eFp60zM566fMUXfSuCkgCFAYaA/B6xtn0oTLQVf7dtY=;
        b=musSPqQsIAawgzH5ggWtfmurfGWYBy69kp1iWlr7imQgG5p53QlM7jr5U9P/VFtQte
         NygbJowPqEv8nBOkInG9w9JjEsyU5GaZlHif4tIBogbyYKjdLW9nF9O6C4we6bSqYs+6
         WMMEEhGO73O++qgE724CU6NkRU13RBjaMukxYw9g6s5iPrmKoP8J04XHIJiC+UXrGu5+
         1GMGABNWwJgzLLJaNZpIAoYR1kHjZuODK6Z1Ktu3PAHtqiSKU4zuB9UmwDwv0xoCWAgC
         01FtUFPQkifdrMER6eO4P5OcxUyt61HbI+IGBWPH7dJ0i7Gt9a4WUHAYauqQFFZKHJFW
         lC4A==
X-Gm-Message-State: AOAM530tcpA4ZQgy1cqgJah6Cgte+B2ZhOa6+tVrDXAVYb/tvHvoa6wn
        K42Y9+D9T8ZZj/pDC2J37wwEsDDJlerFpQ==
X-Google-Smtp-Source: ABdhPJxH3hWdGIoDEmjUyMLh7W6a1jE2bVAw+f9XKolwCCvlMjdgnS9W7TYYx+CF3BL9/Bzm2BImhw==
X-Received: by 2002:ac2:4d86:: with SMTP id g6mr21321927lfe.682.1642495250673;
        Tue, 18 Jan 2022 00:40:50 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i15sm1615158lfu.108.2022.01.18.00.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 00:40:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum
 A-009885
In-Reply-To: <20220116211529.25604-2-tobias@waldekranz.com>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-2-tobias@waldekranz.com>
Date:   Tue, 18 Jan 2022 09:40:48 +0100
Message-ID: <877daxcu7j.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 22:15, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> Once an MDIO read transaction is initiated, we must read back the data
> register within 16 MDC cycles after the transaction completes. Outside
> of this window, reads may return corrupt data.
>
> Therefore, disable local interrupts in the critical section, to
> maximize the probability that we can satisfy this requirement.
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
