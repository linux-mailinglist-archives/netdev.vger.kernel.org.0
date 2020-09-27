Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC4927A09F
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 13:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgI0LdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 07:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgI0LdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 07:33:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7028DC0613CE;
        Sun, 27 Sep 2020 04:33:11 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y15so3775464wmi.0;
        Sun, 27 Sep 2020 04:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJ1VLS0/uB1O1ogFvwazuXAShHBOl3yCdRkg2rUruVQ=;
        b=SFBkGlvhuRS1x6CYb3HCcKtDrRTnDaxzdO/Y8i8hxer0QhsABPWepQlEf7h0s1pr4h
         IvyOMafRyIeghnyihuboY15fNddld9O/DLwtgWabjUtO2JUwBtRlN+Gb/+OmjjD9oG5N
         rG4dYiJuX8vqt69ZzXj6wP3WXJjGEYj+gwt9FRjBDYdOYTrrWB0w/MKO97PNAXzyCjkw
         Uyq2Za3+u9TakMogzKiLnupVCEPVcgutvzDayKg8y1edAiKm7zgtIf/kWMfFVztDxUQE
         sHqo4Yw2bK38UH3vXKGYSmqW1HBsU6zuYU0Txx5SES9UHwF/MpyMZLmhUJPmrypzw+NH
         H84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJ1VLS0/uB1O1ogFvwazuXAShHBOl3yCdRkg2rUruVQ=;
        b=ln9+nIr2lvFYjumF4USlSlOF7NPY5xNSYvaqOeP2mL3/6HLKiAY9M7ZtZtvglGMYrS
         YBqj4qMltnYBQoMZOJfkkJbQ4NCrlqO2hki5pFnczgob/06ZIT/bhAchc/h+bKRCCZ7D
         ig2ywBqFPT7fdKfTswBdt0Jl16q4zraNyTLlH220DcF2tO3r6DyZOvpRtstSKPzo0X8k
         HXBraSIjEeD9jBJDvaOatjv0tGr36c2EHHxwHxWNFvIKQH8m0Xks+OIY+IxsewPK6efV
         GtopTKrEZ+GTE9mdJkYb/jmkFhHRUw+cDqIVuWTXYvicZYWn1aM+4EISY5vBfM/q2Ql7
         YFaA==
X-Gm-Message-State: AOAM532iqRI1hGri+BHoqnYRmFoSC9aK96VrKl0JnLo4Se6QFFqoy626
        ncHxGbDLIuKA8p2kEjy946U=
X-Google-Smtp-Source: ABdhPJw4JaacRb1FcdkxoHT0WUcDrylBN2V5m5JEDuQWfue1uLRC4EaaLYFjWkHgAMR2P+Qx1jZsxQ==
X-Received: by 2002:a1c:4187:: with SMTP id o129mr6546232wma.113.1601206390063;
        Sun, 27 Sep 2020 04:33:10 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d83sm5671565wmf.23.2020.09.27.04.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 04:33:09 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] net/mlx5e: Fix some static analysis warnings
Date:   Sun, 27 Sep 2020 12:32:51 +0100
Message-Id: <20200927113254.362480-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Coverity has flagged up some warnings for this driver, which I address
in this patch series. All the fixes are fairly trivial and have been
build-tested.

Best,
Alex


