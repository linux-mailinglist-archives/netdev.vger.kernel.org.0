Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29D3E4247
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhHIJQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbhHIJQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:16:09 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F145C0613CF;
        Mon,  9 Aug 2021 02:15:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n12so10375294wrr.2;
        Mon, 09 Aug 2021 02:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+dRsZNTP7hBF9O82Mp5K6R2KwdyHxlKrtq2XNd8dBbc=;
        b=RiSa1w2pj40FFrdW+a0+Svl6/iqdVncof6QGTr3hMSLQczBAQBDKg0RnemcU7YM4kx
         pul3VlL91ziIfrEQBO4ytVFJN1scLW5LKxV/ce9zI6U/0sU6dutgNpSO0dHlO3Od6hcL
         5j6y7Mr7EBdwzYqAghuOkyRwNanT32Y6YwwFzpVBXbpxrqw1D8lDLQStLM3gWIKozfSg
         Ov5nxOu6I617l/4noZQMCQ4YbvRYGL3QFNRVDFLoNPTnXYi4ofLWvrwDLpkpOX8yx4tI
         +WxKqwgZ3tIwkr5VnRvRZJqPlnMT/W80OWm9pISThKk4RO2o04XfYxT5Mb5ooFQaH9yR
         C8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dRsZNTP7hBF9O82Mp5K6R2KwdyHxlKrtq2XNd8dBbc=;
        b=dsd1ZUj20rZ0f3/ozIE928biXS3l9ssyFH8EPcaPwXFRcyOhx7eZfQj9/umvoRTJvF
         bnGqvJ+D+IDU1aZrKtdGJOP4RrVya2c8mbJztBGEFI30+RWQ/lgjEgkbm0LBLIdydj+U
         fAX4G6SYzb80yHWEbt/qcKP+mda4m8va6lxCpapMqidcT8CMQ/FkNUqR4CeBGXfxgbBP
         R6kFFze77eiEF03ig7+p3GpfxUCczIMrF2kIOvpMQ7sedlxo3l/XgnYQfmWhU4LTwzaW
         scIE2FhAYMcHc94TlQI5/P1puEsXI+VuuhGot4SXsKITDegFdYvCuwjyPsH0B/6sl/vl
         lmAQ==
X-Gm-Message-State: AOAM530aoY1QWgVIvAvJbkR4pHuRx77iNrmoSEdy9JonZ1vV7Z+bDuQ3
        dyFhnV3EnsgWpWAjJnwXdOBZofy5CUo=
X-Google-Smtp-Source: ABdhPJw6RhFEgIjkbaWmgAH77tAwQUKbxE7OclmftfOo0HWeeB2V+S9wAldhJw00QOSGhp1Rs43RxA==
X-Received: by 2002:a5d:428f:: with SMTP id k15mr10011455wrq.73.1628500547365;
        Mon, 09 Aug 2021 02:15:47 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.146.152])
        by smtp.gmail.com with ESMTPSA id c15sm19222413wrw.93.2021.08.09.02.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:15:46 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sock: add the case if sk is NULL
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210806063815.21541-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d5973390-72cf-a7be-0319-72f1b2d200f9@gmail.com>
Date:   Mon, 9 Aug 2021 11:15:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806063815.21541-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/21 8:38 AM, Yajun Deng wrote:
> Add the case if sk is NULL in sock_{put, hold},
> The caller is free to use it.
> 

Can we please stop adding code like that all over the places ?

This is wrong, fix the callers that are lazy, or fix the real bug
if this is a syzbot report.

