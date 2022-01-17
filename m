Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F874902E5
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 08:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbiAQHY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 02:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiAQHY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 02:24:28 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB42C06161C
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:24:28 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m1so54170949lfq.4
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=EKQKtl0HMrpVhiuwin/tzZY8SOxpyFb5Q17+Qj5KqcY=;
        b=viRDtpegzW5nXkSDQEsb2LFF906I4+LaV8BcpG+yhWa725oz2aFO0Yfjxl8GQ8cuiq
         de/Gu44z8OP8qLp8hnEPqo8UWhygdVP2oE2FYt1QDvo2DxoipYu4T6lWJE9us5+3fi1k
         5zXAj+eYACgGvSId1jOzED5zx686MrCJ07jm/gq7OkoEX17N4FlflKjqOChO9m7HnVy1
         MbyxvyeC2BxjUKj2ZBh80WljteA/ZxbEjaVojhtz2f2btHezvEYc95GRQq4wIHlKUX5V
         ddbIRPwSns32ofYzrcfdLiLtiFqa/Pr1fmvQ9HEEDmhNRV5S8tlVdxP28/WyDY5cLxPd
         gj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EKQKtl0HMrpVhiuwin/tzZY8SOxpyFb5Q17+Qj5KqcY=;
        b=ezPkextyXG8YfrwMX3esTb8/czN925pNGkEGDAMMeoNjIrsuN5K52jX8FhNjz2E8MA
         lZTyTgtExait4TELCU4We2WyikC/llsWFNKGciYC10nbYS855wekFyVQjh35N8LwiWeJ
         bCJqCv3Agofh/7I1DXZIZtpCZgaZnrpCmIjEN8qaeePlpRGA9yEpnjYNgSzC7Sx12wko
         XBD9YrBiMvDxIC7va+L7ZoDF28Jf3GuxpLp53nq3M19Z7PCH+njWRfLkH4dHubbxKL2v
         nsgbF6yAyLZ8Ok2p/u9c+yK7hDmuB+TZoRDZOd/CUbJZSVip6ptuQSIBrVIuFkSj/A2r
         qWdw==
X-Gm-Message-State: AOAM533wLF2eCRGZYlEtL2Aj0HC1gXXuzvbtebzucEojHJSKQ1EwFyI5
        GZQwdaDBFy1x22kWNZAAQOyPbA==
X-Google-Smtp-Source: ABdhPJydjGVwZwOYF3Sov6EeiRjKAo/leF5UAFrr0paBHQvdmk/Zax99dmMM9gu1iIGsj2j50Gdqfw==
X-Received: by 2002:a19:f616:: with SMTP id x22mr15969174lfe.618.1642404266369;
        Sun, 16 Jan 2022 23:24:26 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c5sm482267lfp.105.2022.01.16.23.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 23:24:25 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum
 A-009885
In-Reply-To: <YeSV67WeMTSDigUK@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-2-tobias@waldekranz.com> <YeSV67WeMTSDigUK@lunn.ch>
Date:   Mon, 17 Jan 2022 08:24:22 +0100
Message-ID: <87czkqdduh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 23:02, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Jan 16, 2022 at 10:15:26PM +0100, Tobias Waldekranz wrote:
>> Once an MDIO read transaction is initiated, we must read back the data
>> register within 16 MDC cycles after the transaction completes. Outside
>> of this window, reads may return corrupt data.
>> 
>> Therefore, disable local interrupts in the critical section, to
>> maximize the probability that we can satisfy this requirement.
>
> Since this is for net, a Fixes: tag would be nice. Maybe that would be
> for the commit which added this driver, or maybe when the DTSI files
> for the SOCs which have this errata we added?

Alright, I wasn't sure how to tag WAs for errata since it is more about
the hardware than the driver. Should I send a v2 even if nothing else
pops up, or is this more of a if-you're-sending-a-v2-anyway type of
comment?
