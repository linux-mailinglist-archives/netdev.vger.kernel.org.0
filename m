Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219812212F9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGOQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgGOQtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:49:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D87C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 09:49:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so3386922wrs.11
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 09:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hUz/UVXmFj5gZkksWixwGiXAm29+FzSoDE9Tp4/NL1g=;
        b=XrZxDHa2amTrRfCa2T5Rp/q84MXJ1I7b+U90J1WhsNps3hWZdjZbsa02bucGaUTHBg
         mEU3a1Bw6aEH6emRRQ8GFwROQJTPl18NYZKVKG9O2Mw9qhF596sToQvTQ0L2BvkL3uVn
         Av2PBRokopzC+dq6d/9GEbgbYI+2m6Aj+xV0cLwOciEG9+R9cfDxT+AzOEFO2v+Z16df
         9S5Q+yIWynYnu/0krW4BKngKk9I1xFRVrMBT00E2a90hfYYq2f1TahWze3GSwQ1f4FUK
         iV/w0R6LawIh0SjtOOBoLF+67ZkBN43rOWo7Sxh/hwYqhKrCMNSZqOdtA+OXKSUqryCc
         fomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hUz/UVXmFj5gZkksWixwGiXAm29+FzSoDE9Tp4/NL1g=;
        b=coQ1upYpI96WPNWfBoNN2W3eEmPfMOyujYelvmDu1ALqScxRXvNzNMq8SuRXWBubzC
         150eyqIrmhjeUODjz+PioZsHinj25RhDVFKEvx1v81A0RsA048VQS+MC/AQsJDBUvM29
         LzxjzVPq4YjQUXb+WRLQCZODMDjJ0xhR2wDyWYHCIVLSf88Jpbb0iMYzWA5RaJ1AajVz
         AEBE+q9Lht8CmiDKc4dw/pkhWKXIfJdLfKrO6o3l28Nfb66PgIE5V3dGc1Sa9PQ4sj4p
         paXZqqqqxNy+/+X9pCFEO4DnG9EQjeIoqeWEKpUy2EwtMnVYzZEsZTcctFspM5K+CGjU
         fg6A==
X-Gm-Message-State: AOAM530C0qKF4INIrcjpXV4OkrS12FdiNZETwh9gPGCKTPFymAQ1LX1E
        lg0sk/fC6mRIedozh6LYBZI6bw==
X-Google-Smtp-Source: ABdhPJz20Mxi0oSIWkoJNQFwJ7mmOvvCgI7hszvgLA57LfanXcsC/k6Sp0CzUZdQool/5nzby8X8DA==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr271208wrp.412.1594831745783;
        Wed, 15 Jul 2020 09:49:05 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.124])
        by smtp.gmail.com with ESMTPSA id f15sm4170272wmj.44.2020.07.15.09.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 09:49:05 -0700 (PDT)
Subject: Re: [PATCH] tools/bpftool: Fix error return code in do_skeleton()
To:     YueHaibing <yuehaibing@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200715031353.14692-1-yuehaibing@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <51033bf4-c718-2939-cf18-e5e219e7beb1@isovalent.com>
Date:   Wed, 15 Jul 2020 17:49:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715031353.14692-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-07-15 11:13 UTC+0800 ~ YueHaibing <yuehaibing@huawei.com>
> The error return code should be PTR_ERR(obj) other than
> PTR_ERR(NULL).
> 
> Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>


Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!
