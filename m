Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8163658D7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhDTMZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhDTMZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:25:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028C4C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:24:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e7so28436330wrs.11
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XZYb4XL70BdbZgUD9rYYBnAI9WaI8GWwdF85rUbbLi8=;
        b=izwJZRu/rqz8mYA2KJqPwUMEvmllufhu8RVV1tlReupJnYE+Viqrzwh86TydLcffpG
         9Ybbx8bD2JtghFySp5e62Cc5VMeQPUzY2na23z+ngjPKSTDWa/4fpqAQGzXG/UDa79GM
         j1Iu2s4OY0B6ozJoxq+NxOl/Wlxrm1+ANkNlUrtjuOtTqqFq8zsj0qJBLbCTlyDzNUtK
         lUJsTHG+vSi/w5ISxDgxRVuhZ2gMxlNJ33FH1wOUNrA2WyhjYPpXwUxrKv0l3hIj5kk5
         noEPS6CyPmyTSDh+8PdSaMO9IIeLLsVxRWmNlkaa29pEveYXBb0R/m3YeM+fm/YuItHR
         JKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XZYb4XL70BdbZgUD9rYYBnAI9WaI8GWwdF85rUbbLi8=;
        b=cmEUY7539XezxYFKFZc1QKTzfccAwp8ujZ3Fc47JNWUYJdCE4KIm9RppxFRxYJSnSD
         qnxY84FX5pP/k/6djrbXuIA7uT7mD/eHLPuyQIM7v++4i1E9khPYkQ6uvdiw679Dtkfd
         hdu4QvuR4db3DYao5j4BLnL2eNVmE3qWYbaJszxQkfazKPuYfDgYzElRxY8+OfCxLkUd
         g21n7rz9P+URbHqUqsVAqKN6SSleo4VDADEhF3HIx4dUMJQ/iK9C+hogFSKQxGW7qROP
         A4Orh+vfdpZJPGWb3cyGBDiXGvaMI/e+hpLUO5yAo9FXbUjo4VLPJwFAYdQbrL64svVk
         BZBw==
X-Gm-Message-State: AOAM533vOv3qQ45wmMRANyU+RZw6LvxGRAv8DKpr1ZADjXsag5SNOAoo
        eUoFBUQavrPU53SdGXygyco=
X-Google-Smtp-Source: ABdhPJwsa54KNsi+Ie3Sx07BNTYkNjq8mSvZNVnA5FvC2aD3i76qLJWHcizPnYgzSjd64mJPkOuRMw==
X-Received: by 2002:a5d:524d:: with SMTP id k13mr21090906wrc.113.1618921495775;
        Tue, 20 Apr 2021 05:24:55 -0700 (PDT)
Received: from [10.108.8.69] ([149.199.80.129])
        by smtp.gmail.com with ESMTPSA id m17sm31617034wrq.63.2021.04.20.05.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 05:24:55 -0700 (PDT)
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, themsley@voiceflex.com
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net 0/3] sfc: fix TXQ lookups
Message-ID: <6b97b589-91fe-d71e-a7d0-5662a4f7a91c@gmail.com>
Date:   Tue, 20 Apr 2021 13:24:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TXQ handling changes in 12804793b17c ("sfc: decouple TXQ type from label")
 which were made as part of the support for encap offloads on EF10 caused some
 breakage on Siena (5000- and 6000-series) NICs, which caused null-dereference
 kernel panics.
This series fixes those issues, and also a similarly incorrect code-path on
 EF10 which worked by chance.

Edward Cree (3):
  sfc: farch: fix TX queue lookup in TX flush done handling
  sfc: farch: fix TX queue lookup in TX event handling
  sfc: ef10: fix TX queue lookup in TX event handling

 drivers/net/ethernet/sfc/ef10.c  |  3 +--
 drivers/net/ethernet/sfc/farch.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

-- 
1.8.3.1
