Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7351DF6D1
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 13:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387753AbgEWLUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 07:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgEWLUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 07:20:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBCAC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:20:42 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l17so12798866wrr.4
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+QiHpqyLRxlFO99vLph44CkZ6eUq4NmNyUJXl1NAoYU=;
        b=R0sXHMKfzmO0i0rvUxkVhQvDk6fK0XiHxO6Mx191A2FKGN81FsUefSqmCnZGCfnq0y
         QorgHctBPCP6N5LolmBSTwLx0pMhjaBA9W87iu67+wRbk8mHZnw1ncMeDJngZQwWav4u
         EVh1P0aanBei7GZObTGegDiI2NMgyQCeQCGuEPdiykpdk8p0Hw068L1NHJXq+iWMIaGP
         xTwU4I+RtvPMyOTw82trLGyQtvhc0XL3KUizMu6lTwl/dBt+Sd5FvVUdkr9rMwKgk8yr
         al8pS/zOAG/YzctgvYl5bJqzf8e1X2xEnSqLwvS7rVdj6nBMC0L0bn9JoUL9wuJ3zPrA
         KkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+QiHpqyLRxlFO99vLph44CkZ6eUq4NmNyUJXl1NAoYU=;
        b=L88CG6Gwey/vCfYYsFDE9324Gj5PfAlhvd0LtgMr+ctgwAPk7hkB5qO4OMCwygAp8Z
         bNyfYCxxKtF1YoNLB3e6Edmsc57NFR7Adf6nPU2a7jvryX0Vc36NUg367Yv943LAtiLe
         RrrTdmf/kSFUGZ0Rlps0hWqFMbJd25domX3hokF693MCpn42biG1hCAD9IHlVj6fYzkB
         lxNtXMu9qYzV5o1cU3GvG6FmXqM+1zNfNHKb7qo5ppsvaiP+Kmpi+ytOB1zoFdxw67/i
         FOQ/GZhf5oSHwEJXBO+qejhKoaKK0Gxo0kL1LBim33nJm6U2iOza+Ew3hdXFcG95sfd/
         SFHA==
X-Gm-Message-State: AOAM5303HSD4L1sT+Ajs4M7m7g54iYhyg57Kwh3joqq7wXZ8qF8s9Iyx
        jFjWwxs6SXIhUn2iwGVysCf+wQEX
X-Google-Smtp-Source: ABdhPJydr6TSemQEWM64XvPCuNC+TK9UGZ/1CD9rKNJM5+lWjBDN0XHqTQMzkV6Ue+DDLkGpaB7umw==
X-Received: by 2002:a5d:654a:: with SMTP id z10mr6794329wrv.234.1590232840766;
        Sat, 23 May 2020 04:20:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:69db:99aa:4dc0:a302? (p200300ea8f28520069db99aa4dc0a302.dip0.t-ipconnect.de. [2003:ea:8f28:5200:69db:99aa:4dc0:a302])
        by smtp.googlemail.com with ESMTPSA id x186sm3832610wmg.8.2020.05.23.04.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 04:20:40 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: remove mask argument from few ERI/OCP
 functions
Message-ID: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Date:   Sat, 23 May 2020 13:20:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few ERI/OCP functions have a mask argument that isn't needed.
Remove it to simplify the functions.

Heiner Kallweit (3):
  r8169: remove mask argument from rtl_w0w1_eri
  r8169: remove mask argument from r8168dp_ocp_read
  r8169: remove mask argument from r8168ep_ocp_read

 drivers/net/ethernet/realtek/r8169_main.c | 86 ++++++++++-------------
 1 file changed, 39 insertions(+), 47 deletions(-)

-- 
2.26.2

