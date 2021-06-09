Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6C3A15BD
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhFINh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:37:29 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39687 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbhFINh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:37:27 -0400
Received: by mail-wm1-f54.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso4296952wmh.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 06:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4saDlChR+RuvHPGRsi4z0xuOYFPQYvYKCEMLsyCqzts=;
        b=mT8xmEwsva2RWOzg9GTBeuJ4HZupNdWelO0n8QJg+EU9VEOZ2CGcwVBkrdigkGIswq
         yUTV+H8x2P8BeRwEnGAIo0shA3xuNheHLaWAv7w1sBfVkhG47vxYmI7b76Z6/DpvQ0vX
         aUp9wkl1YP0YdLW+NrRkj32B9yVHPnPh/L5MwrvJCN7R1VXZ9+RTuc1WIGEvuirQkKzg
         0ZrhbLCyDcao7O/gmpwGwIEl/Kol4c8oRMjviylBoSFDJiBrWCP16stXJcseE7vfvi11
         wP5RsapFMxJu8EbSZ2IOt2gLZipP7jpfSKMxwQOu9LVqUhfiTyp6igYkujhdPq4ihZA2
         9kyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4saDlChR+RuvHPGRsi4z0xuOYFPQYvYKCEMLsyCqzts=;
        b=ol07cnSUwMbRuAi22wr2h0AFnxwgdxOoqacGQr6bh6V88nOgeRMI4agJeURYq2npou
         n4l0hcYBVKhnnwem5ycv2Bgf0oq/fyGkli2NUl1JKqBrN3ayQEUXSpkwp+I6HqGZ/zhj
         bw9WBMQWvnYBqrb+J5ZeduOqwl23exPRaKhv0M/toXYr4ai2MBV1TnvhsIN8fqYLRIx4
         5ZGyDCeLG2JZU/UECx9qnIGQzTuZRsFIqI/CFW7zVAPLRJF241NFkQQ/9UnZcpvEysCa
         O6l+ha3rMUFcz5Y/Fxh7DQKCx6yLaYFBErphQvjUaKJtywjJCSGFnW52xFqeCLeJZUsQ
         E1iw==
X-Gm-Message-State: AOAM532yd554J1K1COajqPufQmZhWUbKTfV+egdy0nMquNt+RjQZd1HJ
        uN5H31QdiYjCOIlNrPJl1pEIlM4YrU75sTpN
X-Google-Smtp-Source: ABdhPJwYtQRehX/ldUS18MDWwYYZ27ctlbQ1XpeEyR3fN4K2ALfBatOJhZqCN/XBWhZpl9xlA5By/Q==
X-Received: by 2002:a05:600c:ad2:: with SMTP id c18mr27456842wmr.93.1623245671854;
        Wed, 09 Jun 2021 06:34:31 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.73.197])
        by smtp.gmail.com with ESMTPSA id b62sm22153441wmh.47.2021.06.09.06.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 06:34:31 -0700 (PDT)
Subject: Re: [PATCH] tools/bpftool: Fix error return code in do_batch()
To:     Zhihao Cheng <chengzhihao1@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com
References: <20210609115916.2186872-1-chengzhihao1@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <7883956d-4042-5f6b-e7dd-de135062a2ef@isovalent.com>
Date:   Wed, 9 Jun 2021 14:34:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210609115916.2186872-1-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-06-09 19:59 UTC+0800 ~ Zhihao Cheng <chengzhihao1@huawei.com>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 668da745af3c2 ("tools: bpftool: add support for quotations ...")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thank you for the fix.
Quentin
