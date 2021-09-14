Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1018440A25A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 03:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhINBMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 21:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbhINBMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 21:12:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D51DC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 18:11:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y8so5177915pfa.7
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 18:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ivan-computer.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=z2lOZGZdanpaYVRAt/kvSmIvYXxBB8qSaA1o9kisjMg=;
        b=Xt0ZPlRVNLKoo7f/9go3VQniX80+aRjOr3TNjoHcqY5VbakNlBn65Ufxe1U1HX9BXo
         KLCBdzaE3tcqQezis8ZrR7yyG+i8he02WyzB3fzpticQI52MIDnkOK3FeWBEkFkelDiZ
         8z0FJPwvunszsa6/Nm5Us8uZEcPyw9PFUHqnYe2Gy4O1vbBFGCVcZsOhiIyjbQFiw21J
         FtlM70CKKLusdtTaqU5Xg6ZMxicEdN8zn1fDpCOvTv8EMXXc58hCRQmg1jnzvz9ymq8v
         U4SNUEFjLQhbkjrsfS6PjkAbTrjs2HxVfNHMhFKktiR1j24tTNPkm0hQz7+5LFyZ4Cga
         tqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=z2lOZGZdanpaYVRAt/kvSmIvYXxBB8qSaA1o9kisjMg=;
        b=MoXoiK3SdlA9hKCUvZybkgjdJEXwjgB4EusgKcOmGqrcd6+kT+Eph67QDOL22b2Smq
         9rLl9NmHXYBxQFDFzylhjlOm0U2jhx4Srljm4WY826C9S12dm7u1Nq1oNGMdglw+KcDq
         +LZmoXq6r8NEq5V9/kzPqr2GWVEJSofloqCpKN7ZArCjC4GYUzkhxZvaochg+LeHnEMC
         m8f2438ibjkZfqFC6Jg8hc254ZyooT+j048nT5S+wrtAC6phfR2EVeGyYrtUJwx6oefb
         qg8WCCps3DfmwatnOpcjpa2xHZ+u6TP7GqeH99xvjF5OvMs/H79RmkOi9WcoPDkmtzvF
         5eRQ==
X-Gm-Message-State: AOAM533ehcW72bjxfqXvhNinrmt4h99sDuH0WxWfwGJMW23BRka/Dr0q
        xSDzYhFY6L7h0orM9EInewJzEGJZteeB+e1BNX32tw==
X-Google-Smtp-Source: ABdhPJxZLMOzU++Yr534PIvgmvPLqoY0wiy/m/5MqekCrmsD3aOr7SJTtlFVAA6QQu5SqxWHHHr0DfSDwMlxti/zU0Y=
X-Received: by 2002:a62:2905:0:b0:3f3:d4ce:443d with SMTP id
 p5-20020a622905000000b003f3d4ce443dmr2213624pfp.44.1631581865674; Mon, 13 Sep
 2021 18:11:05 -0700 (PDT)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@ivan.computer>
Date:   Mon, 13 Sep 2021 18:10:55 -0700
Message-ID: <CAGjnhw920kNaJ9Vkg54WR8vh2TaomuTtA3WwR3eieD4v6iEJDw@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings
To:     sashal@kernel.org
Cc:     alexandre.torgue@foss.st.com, davem@davemloft.net,
        joabreu@synopsys.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, michael.riesch@wolfvision.net,
        netdev@vger.kernel.org, peppe.cavallaro@st.com, wens@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is it possible to revert the patch from the 5.14 and 5.15 as well?
I've tried upgrading my rockpro64 board from 5.13 to 5.15-rc1 and
ended up bisecting the issue to this commit like the others. It would
be nice to spare others from this exercise.
