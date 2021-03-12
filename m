Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02028339496
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhCLRWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhCLRWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:22:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E52AC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:22:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id t18so5461401pjs.3
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HSgovXlFuf3oII4jBV5BuUbUiKSbfnPrvleZN+S/i+o=;
        b=Vnd/o60S6d2uaPXHs1aRShaY48YP5BRJQYt/UtIOhINMHho5WPAas1dzs2desqcYva
         oEipN4Uuv3bHmMlvsJTmuExHP6CXZWgu9KrhAmdU8K7uCKGuyol5h+m0cUrVsTajz/nY
         2AVq+aQPJ6S+UHZ1oDqrAWg0uJnyn8VmQz9bqA5eds3BO0OOFkWDWxW+LW863Eo5KQ1v
         itzCB9CQBb5NhvZyZhaK/9fsrQG/pVXT7NNjJxx/RWJtfFf0BldTgzJYQCH2yxqLJ/so
         /p1BuRnGaDrE3JF2nAbXBiVruwgdWL9IPoQAlwNLEjyVfu8wunNlZu/+uIO9NjXnpB/y
         hl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HSgovXlFuf3oII4jBV5BuUbUiKSbfnPrvleZN+S/i+o=;
        b=OCBcwFpIiL20KrXH73++vHJFAB1MVGE+nIZAqGkrd9GBRwwoyKxViPT3sUndeQv8fK
         TQEA+QaF7bOlSyFzPoHWo96UsVLb23fEtoRUdDkVUf8qKxqM1Fy89bI1HLG98qEpScn1
         C/Ai9hEY+gYOpwaFN8uf87ZkE6LXUchTBAav+wYAT/v5XhHW3cTb69n/ZonPxWy3NXWd
         x6RHcy1zTDVbjpka668UwApnUjAFrgF1L09LwbCBHWOQcNuE1kjTKh75Rwxt2sREfsHk
         9O1hGS4783EPwLE8nL8ZgScx/vSsq2gJr02/gX4Bf2fBgUGszIPdSlADXsFkbnrB2tkt
         qKJQ==
X-Gm-Message-State: AOAM533d1C6remIRvhHhEUm8XtiGU+9lprCX2nkNmMRk+cEMRBOkkRCc
        ZPggGRiYR82aUJCKWfPRE+Z7C3jKtGc=
X-Google-Smtp-Source: ABdhPJwCFtnDy56lTpGefDPkRFTk3iIhSYFUxffNIdBRy+WOgCDyDMIyjWLVEkth7TvMzlvnr5W65g==
X-Received: by 2002:a17:902:7686:b029:e5:e6ae:3ef7 with SMTP id m6-20020a1709027686b02900e5e6ae3ef7mr105208pll.26.1615569720998;
        Fri, 12 Mar 2021 09:22:00 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y19sm6562086pfo.0.2021.03.12.09.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 09:22:00 -0800 (PST)
Subject: Re: [PATCH V2 net-next 1/2] net: dsa: bcm_sf2: store PHY
 interface/mode in port structure
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210312104108.10862-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cf6cd249-87fd-16a2-1f6a-07d76968e3e5@gmail.com>
Date:   Fri, 12 Mar 2021 09:21:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210312104108.10862-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 2:41 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It's needed later for proper switch / crossbar setup.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
