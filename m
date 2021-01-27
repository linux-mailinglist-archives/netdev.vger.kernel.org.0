Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7273066B8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhA0VtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbhA0Vrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:47:31 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4211AC06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:46:51 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id v15so911104ljk.13
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDziduizqKLpzoBTfR9X1C15EYhjGJSrZFRnbzR8wkE=;
        b=Sjt6qpSMjRGdPqWaG93wCYtNqxS14fnOJ/k6nu4XyAXGVIIv/rly30aKAzLT2OEj76
         cvVvrXZsa50vIIKIaYJv59R+A+jxNakDeJrrtUGKFDW8KpzNaW8R+riMZ8RhUxpHPvny
         jJKpCmHv804bJXjKvkkRUDaJtGTK5GHkMzvfnxnks1SI7cB094ppXqXY5wu7x0OfS6ky
         7oFZTJWqBgKvzmPOYNhaB8DiaeXohiaJB2efk+tmdNC3vLPXzbhWp/yeL1xVg6fntbtW
         ixCR3SK7tXP8EKE6fCpDzrF2ItCQieP3VDR7U4PRis+KQTJpTq6vcGjVYKNDSLus9SYd
         jO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDziduizqKLpzoBTfR9X1C15EYhjGJSrZFRnbzR8wkE=;
        b=aQ8WGMC/N1NN0X6zjTsfRK7vXouVag9Gr0evBgzM8gEkDRb0AJzbR8bzMfVBWYM2YV
         Da731MCPeq+FtxantrsTs1ejWFBNOGlMca1jx6eI7I6a2Fe+rvZH/Eg70cp0gwfTHZwq
         ZU9IpaEmUNvSyPZLxug9phY512O/M5fjNuUBTOiGG6G7UQNjbziwLdyRQ6NPljqTcnOA
         9PD9YB9GNv1OAsvNGMyjwSGDiC7PCAhbtJT9ijb8whzbgdogMWeLPoamoQaI6UVYH+ju
         oILFJUUvZtKjBQQSUewj6wwg0Ssw57ZTGt0PPzARLiDlwSr1QAamlpw1AcXdfuBOd+SG
         JoJw==
X-Gm-Message-State: AOAM533Em8vlh8qprIs2VVNYZlrxJDH0JMJlExMJEcE3WcYguQhH3bW/
        x5hlIkvUKjwyMiKk9fGol+TTSB8zG1rlddGF2dJsVw==
X-Google-Smtp-Source: ABdhPJyCmTCCSzw7dGMtP7E/QxrnYxSH8Krbn+QOkMv4I4lfvVReRswKKpGPvI05wTvW29MPrDaMXYqMAsWXiIe7sgM=
X-Received: by 2002:a2e:96c6:: with SMTP id d6mr1319826ljj.273.1611784007969;
 Wed, 27 Jan 2021 13:46:47 -0800 (PST)
MIME-Version: 1.0
References: <20210127010632.23790-1-lorenzo.carletti98@gmail.com> <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
In-Reply-To: <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 27 Jan 2021 22:46:37 +0100
Message-ID: <CACRpkdZuf1Zy8hSzZuGVt7DzmAj+FpC6aYd32CMrAN6EimEjMw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] net: dsa: rtl8366rb: standardize init jam tables
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 2:07 AM Lorenzo Carletti
<lorenzo.carletti98@gmail.com> wrote:

> In the rtl8366rb driver there are some jam tables which contain
> undocumented values.
> While trying to understand what these tables actually do,
> I noticed a discrepancy in how one of those was treated.
> Most of them were plain u16 arrays, while the ethernet one was
> an u16 matrix.
> By looking at the vendor's droplets of source code these tables came from,
> I found out that they were all originally u16 matrixes.
>
> This commit standardizes the jam tables, turning them all into
> jam_tbl_entry arrays. Each entry contains 2 u16 values.
> This change makes it easier to understand how the jam tables are used
> and also makes it possible for a single function to handle all of them,
> removing some duplicated code.
>
> Signed-off-by: Lorenzo Carletti <lorenzo.carletti98@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
