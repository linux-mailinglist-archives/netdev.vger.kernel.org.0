Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999A81F503A
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgFJI0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgFJI0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 04:26:11 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B052EC03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 01:26:10 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x6so1186542wrm.13
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 01:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wIu6h48N6izevCPKdcY0ePVmCk36mEfxgfJP1/z8jYg=;
        b=I/wL68yoOntoqYE8DSpYVqbGHEcgycrC21zkoe7wqiRSYCDA6/3F4DR/LfU3+yTP9J
         pR2npGazj4+8U4l+cu9yGQJz3Cari5qJtNebtgTevfmISzop4GAFw/YYlRvGgbTayuqy
         eUE5nAFUqO/RRP4FoSomiu3TtETkflfr7LXpGG405nSNcf1oLK7OLRQlIWsi5eOEkOqM
         EA7yrJUZRktO/ZPhq3oOfIr010nEd/CngmVwEyvCBKf9lZBRKaljyk0rROx2dYvXBq5t
         pKGQQmT3YDdpj+8efbvBuS2egMf1UpG2eI00MsAqeff8VYIM18NwHML3FpDR7koHsEf/
         HtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wIu6h48N6izevCPKdcY0ePVmCk36mEfxgfJP1/z8jYg=;
        b=l1jejYWEiuibr2gcY8llhEVo46pSd6WG6IwUufLHXZqz1eBSFG3qbCVEOhq8331Vk7
         5qf6mJkRBFc1+lVwRt91I7p9VoC3in+MNfhURSC6pmkRPVhV3E3QZJLeccUsRjEnhYIt
         +BSCDHfW17mZ68aTw4qXvkhT5XP4eyw1K3Gp9OBx4AUPd0A4qPdt6FLKemSfEPqjHHRv
         kU1VvoWttDFIZTc0IHe5rmQfG6PnRvVxA06CJz4mqCnp7epx1MbN3+cxzEwU/jKW4JiE
         DzTAdYYvaelApMJuRVKtYxndBND664XCSZ3PDGds2hxdsGbjZoAeyIUHRkcoz37Txkgm
         gRjw==
X-Gm-Message-State: AOAM5330xeHZVClkVPGUnyCvOTA3imaFg5EaxzDqYXQuz3wnQbHwJzkT
        XQCRPmdjVjI7thxRUUy22pmUCR/t
X-Google-Smtp-Source: ABdhPJzo7WWA3DNhVHfm4tWarGECxY5sZBPE2NNhmHTE9nm8dprpHvg3sA57c3UDnEcpNfZ84zIzAg==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr2471007wru.124.1591777568752;
        Wed, 10 Jun 2020 01:26:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8de0:f6e2:666:9123? (p200300ea8f2357008de0f6e206669123.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8de0:f6e2:666:9123])
        by smtp.googlemail.com with ESMTPSA id d24sm5811368wmb.45.2020.06.10.01.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 01:26:08 -0700 (PDT)
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: ethtool 5.7: netlink ENOENT error when setting WOL
Message-ID: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
Date:   Wed, 10 Jun 2020 10:26:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ethtool 5.7 following happens (kernel is latest linux-next):

ethtool -s enp3s0 wol g
netlink error: No such file or directory

With ethtool 5.6 this doesn't happen. I also checked the latest ethtool
git version (5.7 + some fixes), error still occurs.

Heiner
