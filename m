Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2A130F526
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhBDOh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbhBDOgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:36:48 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC54C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 06:36:07 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id x81so3490864qkb.0
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 06:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6RtfBmp5iFyymwr8vLWdWJ3Av67p05ChvjTAL4mU6/E=;
        b=tC/5NcmzKTEZKAJtZ+7vDyEUga9D64mdzoLi/CMVAh1pGht5ufw0KG0dGnHQ886R2D
         71r4oNBtJmJO/B3eTecBDTfsYwc0ctkRDT8rgrS7L16s7aS4XGUVoyGgMCmXzSCSrK93
         Mid7LcT89RL7S9HBNfSe+dBEVfaIhxwQPoswp4dP++0cShpi4CJeoVuw4D8NOVliDmtg
         K1AusAl2MsjTxmtv08b8oI6Fc2NOrlZQaG8Nau71/6fHbjiFyO6+Hy+TbJ8EqYCpwmJR
         fhFTTzDyq+iwjKdgkEI0mn0rDsWjxXZuXExf+AuaRhcwFwf/nMc2//wsqGmQdwcKvRxl
         e0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RtfBmp5iFyymwr8vLWdWJ3Av67p05ChvjTAL4mU6/E=;
        b=hFsQm15aCNVpI29DIbK0gDXlKHAnYeKWFuf7mWUHoGgBf21t8nvSzvErTGDqNsVkEz
         U+3kAe2uU8tGT6CdPZ0ggMMDcmsRZD0JpvtvDs2w8PxGAy7idY8SXzyGFSzbkDyh8BrM
         XKZnTuT42+DPU4rMf88TZSW0jGgnHoIZSEEwtqbPu/1k39LaNx/4T4emAA07cYBpfyOC
         FOCDzE5kOMZDYYXCqEToNYToufCoJUCBZenukl8NhNHbuqbtKxwcicqriPA9fQ/wByZB
         4duyBw1t5DJbAG+FGAjGNYQ0gvQqveN9BsQysEk5xR6rk9F1zkl3MPDaN2CCUjGZzwqy
         FYLg==
X-Gm-Message-State: AOAM531+0qk2cxDdpumMwwhwx5rvHyic8QNdwknX14aUcHDTMGxcab6I
        VoAb9ZQY3TggVMx26C1aM989gQ==
X-Google-Smtp-Source: ABdhPJxYdEqpcysc+KTwsEQEaFz9xKmjzUK/dcqE+WxTDqAxaGVw9B6SWFf7zSKKSR3mZVcb57+FuA==
X-Received: by 2002:a37:b1c2:: with SMTP id a185mr7927400qkf.95.1612449366932;
        Thu, 04 Feb 2021 06:36:06 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id v15sm5436753qkv.36.2021.02.04.06.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:36:05 -0800 (PST)
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
References: <20210202183051.21022-1-phil@nwl.cc>
 <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
 <20210204140450.GS3158@orbyte.nwl.cc>
 <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
Message-ID: <eb8bdfbb-d973-8022-d16f-44ffcb73ff44@mojatatu.com>
Date:   Thu, 4 Feb 2021 09:36:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry - meant to say, tdc is in kernel tree:
tools/testing/selftests/tc-testing

cheers,
jamal

