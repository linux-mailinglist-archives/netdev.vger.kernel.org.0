Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1413C28A3D0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389832AbgJJWzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730875AbgJJTwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:52:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB7C05BD43;
        Sat, 10 Oct 2020 06:08:22 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u21so17025623eja.2;
        Sat, 10 Oct 2020 06:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IRzgnkzL+y6KxGnUDl6KgaiE0a2YhOVgP91PfZHg4Jo=;
        b=byvw0Fy4HVNaP4n7smhkuDqjTWMOiaFJVMkeRiZ3ec2F2chtyzQnuMP0wAlP3i+Pn2
         phJpF74wVI6sccENkGwj9rueqnRXQ/jl4aTHLB+8wqpm/+L5yVgbAOa3pQSsp+cK1pG1
         ftZm36sv696d5/c/iL7qbsxcglHZpjm4AilrMRrZyo2QEDOjAtAJQ0tUnQKevwGXOPr+
         7n/19bs7ClEXbaWInlMsQfTLf5Dbur8Ls0TqTXNQ5KYqijuvicyoqKCr2d4FsV0nJDUt
         W7cJpFY6AQ0TfOMZ7CEX7witi82v0jv7tJE82bwVSWTbTQbyiLVnMhGgqTc2w0ltbBF6
         jZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IRzgnkzL+y6KxGnUDl6KgaiE0a2YhOVgP91PfZHg4Jo=;
        b=QSWma9SKvUGCq19lpKIQigZDj11wJfuw52/KtFbvpijCjMH65kUe1iWktzEwIyjUr5
         Oe3cHPSPsVCmrnuPoH5kQEgHDcM7ALSM0l+a7epnqAxTuCIwyQA8hCJr92WjLdDGyJ6J
         0EtnJ/LQkjrzHutwhYOICKOvEcuhh9R5k8fMzMs3DE98gVGDrj7WIP5j+pqT0OoLUsth
         KL8WBeDIpylQwgLq+QxnFLsHeNEVHodl+HZgguHmucD+lIAWTH8mSxmZS2wbKZKFEdlL
         /6zwekcICbqA8wR5RN4DBb/WO8lotDXi2WVFjI4L3BxJojS1lso0kVpKOWBYSWRTK50u
         nK8g==
X-Gm-Message-State: AOAM5313ckUZ1HRFURoq8R/blOledTBdOVxM/5o1w8rMhs1SuIm38m34
        2cB7FB4OpGyVpidobAaOUwmB++V4LILfsw==
X-Google-Smtp-Source: ABdhPJxzUGEzr8/XiZNnjXysIPZx6Ugs44w2gLiyH/uHXdxmPOdrI+o1ulKAbcwE/CaIuoc86J7qfw==
X-Received: by 2002:a17:906:39ce:: with SMTP id i14mr20143131eje.170.1602335301421;
        Sat, 10 Oct 2020 06:08:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:14e2:2617:c2db:d1c8? (p200300ea8f006a0014e22617c2dbd1c8.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:14e2:2617:c2db:d1c8])
        by smtp.googlemail.com with ESMTPSA id gv10sm7888810ejb.46.2020.10.10.06.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 06:08:20 -0700 (PDT)
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Keeping <john@metanate.com>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
References: <20201008162749.860521-1-john@metanate.com>
 <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
 <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <725ba7ca-0818-074b-c380-15abaa5d037b@gmail.com>
Message-ID: <070b2b87-f38c-088d-4aaf-12045dbd92f7@gmail.com>
Date:   Sat, 10 Oct 2020 15:08:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <725ba7ca-0818-074b-c380-15abaa5d037b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.10.2020 18:06, Heiner Kallweit wrote:
> On 09.10.2020 17:58, Jakub Kicinski wrote:
>> On Fri, 9 Oct 2020 16:54:06 +0200 Heiner Kallweit wrote:
>>> I'm thinking about a __napi_schedule version that disables hard irq's
>>> conditionally, based on variable force_irqthreads, exported by the irq
>>> subsystem. This would allow to behave correctly with threadirqs set,
>>> whilst not loosing the _irqoff benefit with threadirqs unset.
>>> Let me come up with a proposal.
>>
>> I think you'd need to make napi_schedule_irqoff() behave like that,
>> right?  Are there any uses of napi_schedule_irqoff() that are disabling
>> irqs and not just running from an irq handler?
>>
> Right, the best approach depends on the answer to the latter question.
> I didn't check this yet, therefore I described the least intrusive approach.
> 

With some help from coccinelle I identified the following functions that
call napi_schedule_irqoff() or __napi_schedule_irqoff() and do not run
from an irq handler (at least not at the first glance).

dpaa2_caam_fqdan_cb
qede_simd_fp_handler
mlx4_en_rx_irq
mlx4_en_tx_irq
qeth_qdio_poll
netvsc_channel_cb
napi_watchdog
