Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB73378E1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhCKQLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhCKQL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:11:29 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C06BC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:11:29 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id x78so23690130oix.1
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E7UErmD2LeZ5D3B6hcNLUngsSe2cxjCps3PhJcX69zs=;
        b=pW1LLzzfIpHkUX3YxbBRBTHDawkIwbnU00Kd1j1gf8IkVYBlgPWUBRx1iqpvfCcqjF
         H7dZoCvE5XuafSsCaOFTLdZpB8ZpAiKtY3rgzRsd3bHUV0F29NNs1qMMCtuDRuxOzKiA
         g2go2U+6OXS1SiQPzfrACJBKGFvcxcpc7kYvscQfv+2MROCHq2mfhdzh6bL9p4G9tZQw
         DRAx5UFSE3jJ1U9ILdDf55mGyHvsaD8O0yNq9XANKU5RGjcwK+JiWeOsAPo46m0mSMBe
         5gBWz7BIlQn6e6gFof1gtH6wKAwFVmh03DQUaHQtNpzkb7A9xCGAIH4A416THUBMLekY
         g1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7UErmD2LeZ5D3B6hcNLUngsSe2cxjCps3PhJcX69zs=;
        b=jgQpC0/MOiTc0o+A/KPDrqtjUpWD9qNOow9TTT2mXE/oMYCuHwt2G+FM3AqvTTh3+L
         uFHgyNyMIB3qJF3o1UYkrnY0JsyPL0yt20NF9NU7yuaC+kW2wR4cRP+odIUC8rgnfaq8
         lM+Jv2EJ52wrrVzlnqPk71r1HWx+rT9pAGAEFnlzufG4KdaPjmQj9GP0r00dlrbL9tCM
         q0oCMgQk/fiIUyCc0Jd3GukiwOuGjWc/eArZpdgkvGEyGhPGiqI/0bYwA5rLjteCkz9C
         ooztTsE+7M9sNjpNSsaB05MwOTIEToYQUS3fBMVnhDaEI0fKTplOrUQbT+9eDLMHV61z
         YLow==
X-Gm-Message-State: AOAM531zzmzjzGpDfwBCwWAcV8+Mr5fQ0EGT3b0rm36SsyYeRFwoJWmD
        oXpA3bBsfHA9kNpws0GtiM0=
X-Google-Smtp-Source: ABdhPJzBn+4qjTDVMR0hja/zS1ObkPCAFJvCITyq9TfItivLDOt227xRKQdTEcC+3lob6Qj9i7Fzcg==
X-Received: by 2002:a05:6808:114e:: with SMTP id u14mr7076849oiu.156.1615479089121;
        Thu, 11 Mar 2021 08:11:29 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id y11sm628564oiv.19.2021.03.11.08.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:11:28 -0800 (PST)
Subject: Re: [PATCH net-next 10/14] nexthop: Add netlink handlers for
 resilient nexthop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <ab2c9b2de2d0454b38e81580fdc10866eb85aa9f.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <af4a4d22-ad2f-630b-0fd9-371205b30f4a@gmail.com>
Date:   Thu, 11 Mar 2021 09:11:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <ab2c9b2de2d0454b38e81580fdc10866eb85aa9f.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:03 AM, Petr Machata wrote:
> Implement the netlink messages that allow creation and dumping of resilient
> nexthop groups.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 
>  net/ipv4/nexthop.c | 150 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 145 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


