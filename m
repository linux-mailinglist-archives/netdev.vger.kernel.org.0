Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546951C1F90
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgEAV0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAV0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:26:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD16C061A0C;
        Fri,  1 May 2020 14:26:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i10so13082246wrv.10;
        Fri, 01 May 2020 14:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JOH0fItTITIs39+numeUrXseWQMyJbcgZrHAP+cimTE=;
        b=SGFMB9zhhFAaqlWEjTYajAyach4csZy/ytVyPW3zHe2r3kZQUR13WN8vusEwKFG6MA
         BwLobj60xhZLlb9iRUZsXxyQWW1nV2nMQ73TEEx5rihpzV10YmTG996Y5llN4XgDf9/6
         G0ToBT2JWuQL/YEpThEEQphErRD3LcdR5gBmYm7SP9TJ0Lj5siCIRwDAQur0kYj35709
         xRJu/HktNa0Exy7wN9af8/EarEAAm9lkra8KN2M1IBeBYQZ8ZjsSK0VWI1mcv2t2EwNB
         geLGmqrBFWxbSthxh+Rc2SpnSUC3gvsulp9J5qvH3tGtv1GOEsQLrUEQKQiIfe0LYPU+
         PRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JOH0fItTITIs39+numeUrXseWQMyJbcgZrHAP+cimTE=;
        b=GLBSkNFN1/5FrJ4Mcr07t+8G8GM5UsbZ7mYLXKOoDqC6ln8h6G3EmmhJOu/QKlcLML
         qZEi9CJqCzmoj6lXDyzIdwOO9C/YBK20XTn2UTpYMZ3YSrYXuxqZPyPz1kjiWSyD3zrc
         p3ywrBlnP6dgphdg3lSZgHTENTI9+B3MvMwmz89ui1ELltVRkhP7GF12iihexcm0ku8I
         fH7NYPq6QGPm5d/0yNCkOez+UQnNLgbc7naKR+OV8xpXKtieXawONotXfKvnuKBj459M
         6IUDQxYDu65mdd2z3P8DwD11R5Pxr1d/SaWGTF7z0eVRyFjQcBDcF+I3nvX59qOaRmuO
         ZOiA==
X-Gm-Message-State: AGi0Pube6N8OBQSmhnoEJDArjEYSHrjWUYxmaI0OQDhNs6gQ7Q1JLTXZ
        +SN2Bz1tPCDJs14vrQwtnIO/USiN
X-Google-Smtp-Source: APiQypL23UwaAkxJFtARnSDV0JtYcxhhSH4y4yep71Eo+dDIu5o9qFVvB5kZYfZuS0GcMgkJe+Yt5w==
X-Received: by 2002:adf:e943:: with SMTP id m3mr5850885wrn.248.1588368389448;
        Fri, 01 May 2020 14:26:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:bcdf:534e:d44f:409? (p200300EA8F06EE00BCDF534ED44F0409.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:bcdf:534e:d44f:409])
        by smtp.googlemail.com with ESMTPSA id t2sm1157947wmt.15.2020.05.01.14.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 14:26:29 -0700 (PDT)
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] timer: add fsleep for flexible sleeping
Message-ID: <8e3c56ca-b43f-3877-0104-a1a279d5a6c5@gmail.com>
Date:   Fri, 1 May 2020 23:26:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleeping for a certain amount of time requires use of different
functions, depending on the time period.
Documentation/timers/timers-howto.rst explains when to use which
function, and also checkpatch checks for some potentially
problematic cases.

So let's create a helper that automatically chooses the appropriate
sleep function -> fsleep(), for flexible sleeping
Not sure why such a helper doesn't exist yet, or where the pitfall is,
because it's a quite obvious idea.

If the delay is a constant, then the compiler should be able to ensure
that the new helper doesn't create overhead. If the delay is not
constant, then the new helper can save some code.

First user is the r8169 network driver. If nothing speaks against it,
then this series could go through the netdev tree.

Heiner Kallweit (2):
  timer: add fsleep for flexible sleeping
  r8169: use fsleep in polling functions

 Documentation/timers/timers-howto.rst     |   3 +
 drivers/net/ethernet/realtek/r8169_main.c | 108 +++++++++-------------
 include/linux/delay.h                     |  11 +++
 3 files changed, 58 insertions(+), 64 deletions(-)

-- 
2.26.2

