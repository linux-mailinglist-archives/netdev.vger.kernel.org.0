Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485602683F7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgINFKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgINFKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 01:10:17 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DC7C06174A;
        Sun, 13 Sep 2020 22:10:16 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b124so11549568pfg.13;
        Sun, 13 Sep 2020 22:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3WLhLt0PwfR9OQF5tY/Lv2Pa4vaTznyMvtAVH8fVm9Q=;
        b=KxnWRLVKkq5rcnkFZOUupXe4pKRG+gabI5P+TliSFbrOddPX6JeRxMXfjPvs6B/F3w
         vWI1gmFDCtCV0qOOA0Sbu+vc8urYDCKXFLDggQLCahsA3CkiyfTcZyBEQHClU20/rTeo
         lATSCyGPViM2RIbASgimY1sd5UxFdARD+ywlfILl149PhQ1vnLG87V4blaJye0o0kCE0
         c0GmznbGid59xMvepLpn1cm5kgevLIFgG6EAl9DPQ64KOIh0mGaNR0GiIcQuF9JtZzw3
         liUVIzbGAGY/GR8S8JDQ32dlJcxtn5D4/LMoCl/b7q1+4x+kZ+238Uc6dPk3LbafW/EP
         GbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3WLhLt0PwfR9OQF5tY/Lv2Pa4vaTznyMvtAVH8fVm9Q=;
        b=XLDC1pvqNKoBfGyLqLpoOVoGDw10BQBoW2zHX2BOyTkULmbNzLByCOqo03PgisIMxE
         zeMF1yBjg8zGrCrmJzTyO15ZCe37ZPxYTnxeYp2wsZfLDBM04uWrxImlMXqPjaFtvhE4
         1JdKA59mXgvAZdPBOnE3fEJwurrcdPL6/wzktE8m5/OD2+it3S7Lirz3+J7rf6kpoTJE
         hPo/aLE8gZ6apfTlS/9GvH8FnrB0v+4WTMFtsR21o8MTBJD0WtUb36yTsgb78T3JdPMB
         Keu2TqFPlLDYQThSY6QT5X7EZTzzvVXxU8r+adWgzwJA557BEDm0CU1eCWfx6saordMv
         YaQQ==
X-Gm-Message-State: AOAM533vhpTyz833+EZgpT1S89FDgQlF+t7E8ysd4eJX66V4CEabS6LJ
        jbWz30Fv2fWZNMFr2pCuL7pi/l1PVCcmYAamUc8=
X-Google-Smtp-Source: ABdhPJwaa3Y5NEOD9ZnHkNvg1jMyGFXOHRss1Rp6qLtL3K8MHBMBOT9wB5KSGiT1F3rrDOYiSLXJbA==
X-Received: by 2002:a63:e249:: with SMTP id y9mr9722975pgj.117.1600060216008;
        Sun, 13 Sep 2020 22:10:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.61])
        by smtp.gmail.com with ESMTPSA id f12sm5264961pfa.31.2020.09.13.22.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 22:10:15 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     davem@davemloft.net
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH] net: fix uninit value error in __sys_sendmmsg
Date:   Mon, 14 Sep 2020 10:39:43 +0530
Message-Id: <20200914050944.29441-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200913.142522.1753407855743748880.davem@davemloft.net>
References: <20200913.142522.1753407855743748880.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I can assure you that when I said "I think", I meant it in an assertive manner,
and not an assumptive one, but I can understand how that could easily get lost 
in translation.
I wouldn't have sent in the patch if I had caught the build warning, and once 
again, my apologies for not fixing it sooner, like I should have.
I didn't mean to disrespect or offend anyone, and it definitely wasn't my 
intention to waste anybody's time. Needless to say, something like this won't 
happen again from my end. :)
I have sent in a v2 for this, which doesn't add a build warning to the system.
Thank you for your time, and once again, my apologies.

Thanks,
Anant
