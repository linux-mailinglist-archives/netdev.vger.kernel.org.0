Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1576F26335A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbgIIPsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730526AbgIIPr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:47:26 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC6DC06137A
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 07:21:31 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id h11so2457064ilj.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 07:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mtr65x6fK5IlIQRtZLNh/NxFbA0Ukhq43XJmWOA2CUc=;
        b=1kTWQ0Rx17CB3a3l6zRYbeWVNhCtQNdeO1Nyt31G782X3qOLON4LuUwU2Tfa2HcPBh
         eo2G7kbcA/xqYT4dUkojSxg3+vNGmZt2EyubttIOhQWjesQdymM00mjaHjpLaShFMpCn
         61y8hoz4MVq8xiOPf9zkqwlAvhn2qYSfAPRjcDSAc5CspVC43c4n4VpfDyNYwdPamoJz
         3A4tvoOXFutN7GNfYhYGLEIamInVZSviooYPkuI1G9U0ii130k/rjOPPzldqxP1mJCqV
         nyFrsR/dfjygylN1VDNcS5jSBh1M2gvITzl/AbNA5+8HifN1lQdBIlmucO5fQ/pzz1+Y
         LMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mtr65x6fK5IlIQRtZLNh/NxFbA0Ukhq43XJmWOA2CUc=;
        b=bXl5SV0bBJU10sRSUmlI4CkqBShfbHbcFHDfoFTU0HPtEHGQ6K3kYqt2C5WGRYcHbn
         BiDiPn4Zl7F0cLdOkq6GWen1manUfTi/s9LTbW2I0Cwe/QSm2guHVrrx3n94IWGwf+Wl
         GOQUYPkVIIIsdM7XBlQmpG9Q+MRGrWsDuOStZA/PIxmHR+9m5nmx/Qc0Uxb8brvGTEwY
         jIY3uUZDlFVhKPpxO42x5aq1zKDN6mPx6FNhLCHjEhO4lY5PprxNOhXEVOPqcz3MIBBA
         ARnk4uLjWNOToslHDyOCnEMXdzAI+463pJmqw36FVhb4F9CsbJggFp77Oa0nc9+wgjzf
         /jIA==
X-Gm-Message-State: AOAM533iWI5F8GVf4TVnqB7AHG+5N0kItBZk43A9uOrxfgVWYJZva4PX
        o4W+lA2KEEqjLbO8xvAxisagnw==
X-Google-Smtp-Source: ABdhPJweYTpuCpa5hQXVyCKu1HNYd1h5alEfQqDr7iNE+D2ODqGnoa1Ri0/JOkdr4eXiKi7PQPRmEw==
X-Received: by 2002:a05:6e02:d2:: with SMTP id r18mr3681539ilq.303.1599661290531;
        Wed, 09 Sep 2020 07:21:30 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j62sm1286878iof.53.2020.09.09.07.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 07:21:30 -0700 (PDT)
Subject: Re: [PATCH] block: remove redundant empty check of mq_list
To:     Xianting Tian <tian.xianting@h3c.com>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200909064814.5704-1-tian.xianting@h3c.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <466b8c40-9d53-8a40-6c5b-f76db2974c04@kernel.dk>
Date:   Wed, 9 Sep 2020 08:21:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909064814.5704-1-tian.xianting@h3c.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 12:48 AM, Xianting Tian wrote:
> blk_mq_flush_plug_list() itself will do the empty check of mq_list,
> so remove such check in blk_flush_plug_list().
> Actually normally mq_list is not empty when blk_flush_plug_list is
> called.

It's cheaper to do in the caller, instead of doing the function call
and then aborting if it's empty. So I'd suggest just leaving it alone.
Right now this is the only caller, but it's nicer to assume we can
be called in any state vs not having the check.

-- 
Jens Axboe

