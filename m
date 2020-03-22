Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88618EB4C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgCVSBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:01:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37444 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVSBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:01:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id d1so12054621wmb.2
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 11:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=l8SPnuKEsvYP+4lDTDqzHp84L4NjY0xOGJLSat7Lat0=;
        b=ByHpWwS9xTJMXNrWD2Gs6nfYx5YKQiTha90mSWEvhRRcfhuT231YLWNoZifMKN0KDj
         ++kFj3La5QZ6sPWKRO0jFWFATEuS8AkR89erfEpEjMTfAKQvfJDAFy8KgBUvH4SDh4iC
         XWNcj4WW73IRhWberOJGZqDI6UA2NVdUqtmYpi2Z4qdrz/4DTgvfThMq6Oleis1/cVZD
         SkA8KkWbLCZVa1fscGJOJQL90AKQWpCHjYyzAQojvb/8X3thcxw4f3Ks6cPw9aDrVYBc
         mjiLZkd5pZKTlnJizM7puaq12YxKkZ/dvOhcOlHr4IQKPyxJff4i7MUeuQUgcfzinHKk
         tlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=l8SPnuKEsvYP+4lDTDqzHp84L4NjY0xOGJLSat7Lat0=;
        b=lPG/BBwpccZ2uX8D7Dg6iX19QvUIvjL1tT4q9ChNsBJe70E2hLlHD5tN7flHykOlfJ
         sWkAMVp9qnHu3kFX24Bs3VGSHz+vAcM8LL2q9WuNw+qw2jMuKNX64cfWyE6pWIdlzLHx
         KuG5Crs55JrfCFQ+vMCOhVo/TXyo9mm/hK8mS2OmLiwY13wttQerA82/xE6DAOrjeYg2
         IuVAEexFNMRJr26vvAcXFD3bWN9ODJStYWmni0MRdkulTDspru5FkebwPN5ZYc81QXS6
         gQO5UEA4hp4y8FdNkqZFnet+nS2OxI7JE38mGoJ2VScKHFfoEGNpX984xpuKsHP0hH9Z
         Sm4g==
X-Gm-Message-State: ANhLgQ252NJiekS9qqhJKXOpougpSw6dZWnKKpDhBP0ge06tjP8Bevu2
        JXKs/VMFyXk85ugoohq2q8ioGBAD
X-Google-Smtp-Source: ADFU+vt3RQroeV4a95iQ2SeElqkyJuEl+bJlIKcBG5Rx7hcAHtIBYVIMl2s2wHD2+2YRct+7TCybmQ==
X-Received: by 2002:a1c:7701:: with SMTP id t1mr8988017wmi.69.1584900099166;
        Sun, 22 Mar 2020 11:01:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1055:511c:c4fb:f7af? (p200300EA8F2960001055511CC4FBF7AF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1055:511c:c4fb:f7af])
        by smtp.googlemail.com with ESMTPSA id v11sm592819wrm.43.2020.03.22.11.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:01:38 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: improvements for scheduled task handling
Message-ID: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
Date:   Sun, 22 Mar 2020 19:01:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some improvements for handling of scheduled tasks.

Heiner Kallweit (3):
  r8169: simplify rtl_task
  r8169: improve rtl_schedule_task
  r8169: improve RTL8168b FIFO overflow workaround

 drivers/net/ethernet/realtek/r8169_main.c | 27 +++++------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

-- 
2.25.2

