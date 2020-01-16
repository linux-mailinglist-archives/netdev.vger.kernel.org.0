Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29313E673
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391610AbgAPRU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:20:28 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38026 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391362AbgAPRSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:18:05 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so19822239qki.5;
        Thu, 16 Jan 2020 09:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZHJNJzAFrt0uyyRdNsMrWMrSY7FsAQZj36UJfWF2nQU=;
        b=uKE/aGAqqXGSN8s+eDE4CAzAzR2AtXW9tzd+k5XeRXKQcW+eaNJZvBZZwrFIGWJRyu
         3hjiIr8ru5Dlc1QYU2Z0YYBb7lAlosZetIUrC/lFZQzqKja0FGSUxSI1QRBUUeczFPfh
         nPPW1XUE4qVgUcvYBpN8380/wdXR+xV1BA29a9I+JfXI0H0Hbw5HoJGuSuHrq/FZ2+Or
         ue7zj0GyFEKbPP/vbtcGVCwc0lanVffQuHrz8j+0NLBH9kKuK9Qsomi0Gn/Y/to+lHAx
         4CBLsBM5pmJ85IL5FstHN1P+pJSfJw4DWdfTGTHgQFcAmk+5ONRgSjJfkEuNahVYuhbZ
         EoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHJNJzAFrt0uyyRdNsMrWMrSY7FsAQZj36UJfWF2nQU=;
        b=FshGpK11LIM1rgRINmc3mIT0JQRzeZVaeUaGAn5mcLgYKeiig/FGNQnn/AuSxRMSl2
         DO3GVYHWXRvcTZKKwkkhE9h8LjNfyObuUhua2PKpyq7BemzvMJAIkwJq3cmpUTKuKStQ
         xXmdOA6P0GE0vXcsyjyKFMaR4o9hpIDKRuHFbxlQi7voD3JzmujP1FLnA0sk7f8l1nk8
         /vqwy0sHBZGJlnVb36LoGHgAG4PQSPdQ1AgxSk05vvJplxNT/tRKTTZhqTsDkvSMo0cu
         px4NDhH2qNgT311MASkoRIx1Hfz3EcJ1CLSe2nfAK89uwwt/RQcdeF66Pjw6xCQYe4gu
         6Zrg==
X-Gm-Message-State: APjAAAXJrnPNQbBO1s47xP+wuf1hpH9/rWb01/bD6zw0Yko/Fdv9d3xj
        atAsCRuSsWqt3RkLN6nmfBoZbnZw
X-Google-Smtp-Source: APXvYqx54nLoADteH2t6RZa5CCoOO72147cgZHbEE1AaCvcvNwAK60FdkbLOD0YenTbu7JF5eOMQeQ==
X-Received: by 2002:a37:684a:: with SMTP id d71mr31325170qkc.201.1579195084165;
        Thu, 16 Jan 2020 09:18:04 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:5c84:fd9a:6187:58f5? ([2601:282:803:7700:5c84:fd9a:6187:58f5])
        by smtp.googlemail.com with ESMTPSA id 68sm10567325qkj.102.2020.01.16.09.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 09:18:03 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 4.19 573/671] ipv6: Handle race in
 addrconf_dad_work
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200116170509.12787-1-sashal@kernel.org>
 <20200116170509.12787-310-sashal@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fc012e53-ccdf-5ac5-6f3f-a2ecdf25bc39@gmail.com>
Date:   Thu, 16 Jan 2020 10:18:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116170509.12787-310-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 10:03 AM, Sasha Levin wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> [ Upstream commit a3ce2a21bb8969ae27917281244fa91bf5f286d7 ]
> 

That commit was reverted by 8ae72cbf62d2c1879456c0c5872f958e18f53711 and
then replaced by 2d819d250a1393a3e725715425ab70a0e0772a71

