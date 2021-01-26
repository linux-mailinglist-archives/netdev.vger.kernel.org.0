Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839AE305C7C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbhA0NHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S313800AbhAZWq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:46:28 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE9C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:45:41 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id u14so4079189wmq.4
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6uEDqbP5GBGYUP7F64oBhLErel+Fpma3Eqxu2AemvaQ=;
        b=uaezocJcJ44aLIxEa8+99hIP0zmrMw5sTeR0a/3Bvj+5iwPv9MIfcXEEBhZt3qejAq
         NcFgpgi99IWHcWdjURU5WlGGFDZC0+F0JLVID6lOCZG6qTLau/FTQv4A0wpg3S88Udsf
         igv5lpckSxyjRaFp4t6R4FFvx7ExmSjYyVeXaltGuRKcM0zr6KRCskFB16MeoHW8KWQ+
         WBfv7jGQ1SIaG+YDYjqmaVJYuw3rRu9fXRyd7fokSCNL5MNmqOAxC9Vx/y/LuSIpqM2N
         SavwLj8j/EjMGQS1mp6QSQ9A/T7QPu8VY9WlsIpz07HUl+3S41VCYv51PcAr9keERuk2
         ROSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6uEDqbP5GBGYUP7F64oBhLErel+Fpma3Eqxu2AemvaQ=;
        b=rU69h9UvSak5Ha9CQuiS6f2/pR1xXWYHyodCsAG0hknKdT7K674bwq19S/9k8lmi4k
         zB0Td2SOHkmCWFauwPxNkafS2Gc3Z+Ujb8uqB+VAtwGcjTW2s9cLyGMooUzQwUgrTb4W
         Pg77BXcgiIbzv0WZCnGRZzaiiT5uPWJ0O9Q170+ZkO2t2q8z4CVmhgEYip3AkznPptWk
         l1KrLU1XQl8ZQKBZL4NFF41xK4bosYdKvOcVx778sCNChM9ckqHcQrdFjYa1A2L60/Gy
         ZHuSP36+Eo/ZJTWOP/xooKKanrrmTRSD5jHUlybWnjk+ODEtZ0cY1u/Rkvpti5vcNE1O
         yYUg==
X-Gm-Message-State: AOAM531J5Z5NVrLiq3xcQ1PZgLrGsk2/HSKlAdFy1FyLWxdcp3jBQiUM
        ofwY4BUAnKolYewZNPCLecJEM7AaoiI=
X-Google-Smtp-Source: ABdhPJySKPkjXk1+/mR8HrDkBKMuGle1mrMwwuiZJxJWmAKxxPW2SgLf8d/Y5qqFtVrAnipI1D+zhQ==
X-Received: by 2002:a7b:cd97:: with SMTP id y23mr1602514wmj.0.1611701139878;
        Tue, 26 Jan 2021 14:45:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:5935:bd94:7662:5c2c? (p200300ea8f1fad005935bd9476625c2c.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:5935:bd94:7662:5c2c])
        by smtp.googlemail.com with ESMTPSA id 17sm19208wmk.48.2021.01.26.14.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 14:45:39 -0800 (PST)
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
Message-ID: <e7f22b01-589b-102c-cce4-4a5851f0d107@gmail.com>
Date:   Tue, 26 Jan 2021 23:45:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2021 10:02, Heiner Kallweit wrote:
> It was reported that on RTL8125 network breaks under heavy UDP load,
> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> and provided me with a test version of the r8125 driver including a
> workaround. Tests confirmed that the workaround fixes the issue.
> I modified the original version of the workaround to meet mainline
> code style.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
> 
> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> Tested-by: xplo <xplo.bn@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Patch is against net-next, not net. I'll rebase and resubmit.
