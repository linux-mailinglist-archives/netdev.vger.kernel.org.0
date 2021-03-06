Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F2832F831
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 05:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCFEY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 23:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFEYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 23:24:05 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E20C06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 20:24:05 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t25so2699917pga.2
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 20:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nl+6n3qNRTiYfGjtP7B6oZJallCsb6ruhF4yER8iPb0=;
        b=rrbycugRR8j4VxE9QCq9V37814WGBxPbFmh4PqMVPAzF6SaXqGXhzeO5Oe5CU+xSTs
         7YkQBSmhSIW5/n22LEo7mcGwJcc4uPnoSPZDRsSh1hy6oKDm+k/Gse8VcUln4sMt0voD
         /lKK4cXK3o1sbZWgKBO/FGkk/geub1oYabGD1C2IZUUMY8FZrNPsXJ1JWLNzBBDXP0sb
         EX1gjyzZCghbEzRwkqPGmhft+C6foYL3UXHBaYNp84wWLOIA44pYAkMlka3mlTVGwPMy
         HTsn8HcQSqbAOcONvHG32WfmRGzZNKVAgtnjls1epPPvgr1PGKc0AjBOovQ89vXp8pf3
         YjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nl+6n3qNRTiYfGjtP7B6oZJallCsb6ruhF4yER8iPb0=;
        b=Pr+T0FD6U/garrnm0/bCMbop6h9EOyXbUWGStE6Oq/W2BRnCgCIVveosRqrvHucl4x
         tlKZs1p6BuOQvuKYEQg82zuzgVuRkMoTg0znl9ykZEUoH1c4NKovQHPTfLmb8EGpieyD
         5o9D2+i75/kE5TjTpYlyaHQbQkIft7oJI6YV3/sm4oQahI/ZfSemOf0/6wBq2plUXQiZ
         oz4Btd8ApjdE98J4ER0f+6KrSLQhXhxDBBFnRxsBYVTC2wvPDg6/Y43r7mWfay2qHEEX
         gUlNDldJBmeEdeItDiCC0G2LCxxk5ihBPgpEbHZ/0nXOsjMJVz9NcoKkmgcoeXRigYKC
         1avg==
X-Gm-Message-State: AOAM5300UC8Jz/hvv6Z4SvCvt7/5J5zBfiwVEyp4tufafEgDMDNheFzm
        RBuBapqKpPHp1YcnGO1M7mk=
X-Google-Smtp-Source: ABdhPJyS7uMuqY1m4raL71wDYjy0NwdEvewtSLuG3jQFxjA1Ujf78WlXZiIZyYJ3LzkPdg6vNy3sqw==
X-Received: by 2002:a65:610f:: with SMTP id z15mr11572456pgu.360.1615004644842;
        Fri, 05 Mar 2021 20:24:04 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b15sm3739387pgj.84.2021.03.05.20.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 20:24:04 -0800 (PST)
Subject: Re: [PATCH] net: dsa: bcm_sf2: simplify optional reset handling
To:     Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210305091448.19748-1-p.zabel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <996c17ea-642c-2c94-5380-ce12508e4050@gmail.com>
Date:   Fri, 5 Mar 2021 20:24:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305091448.19748-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/2021 1:14 AM, Philipp Zabel wrote:
> As of commit bb475230b8e5 ("reset: make optional functions really
> optional"), the reset framework API calls use NULL pointers to describe
> optional, non-present reset controls.
> 
> This allows to unconditionally return errors from
> devm_reset_control_get_optional_exclusive.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
