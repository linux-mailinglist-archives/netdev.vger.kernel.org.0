Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3731F686E
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 14:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgFKM6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 08:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgFKM6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 08:58:03 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1BAC08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 05:58:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p5so5306503ile.6
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 05:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L4FmGBeOqb7XHmV2su2Hlr1yuXc/ftlMBpAtmSul0aY=;
        b=iN1AZcZlv5iRcZ8ELgmWpm5NDm89/CA0vnSJH7TavV0gbT6NdbPMg/s1O0TF/kA8tU
         mMIoumF4qi29fC0mCpkZdcmPXxSsa89axQiuWpsRyaEnTGNnPfvc4gIlQ35pfOkmL5ix
         2eOHy8Jj/nTGdozcGHNNlq6N5bReaU/oSAS/XvYT/ahWE+KC/L1IdWp0U6TEjUQgb0+A
         3EY+hTkKWwMBdEXnuxKvPXOy0+brccnSvTMxJiqPIv0xJLy2cCpmXhfUf6f9BdPZrUFK
         UBbBfjzqSLeaHFIb3wldD2iAAlwjHpu3YesOdrhONpAjO+YVfPvX1VoQicE/THjTFsN2
         Zknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4FmGBeOqb7XHmV2su2Hlr1yuXc/ftlMBpAtmSul0aY=;
        b=ZuRMGpcdn4kB9Cp/CBRRttT6u2VAVxUrWsexAinz9JEYnkp1K3UoDGyyncOEcSj33w
         gStYoCL3xMdfmS9i4isxn1mPOa2WMzdas/l+RdxMtL6EpQwk313nA8hYz/UVqws7ePjC
         PjtPNt0sdEbFZaOCUlHPEHo5L3kdwaveRxuKE9SKRxKkZ0okt+1u7OvB6tAkJP3yVDlA
         LsCgiVB4BS8PIURnHVzcfAvjpSQXCiSiJ9l0C13kEk5fdz4n/nKk9ZIcI4YQLs57OPen
         CnKasPn7Pv6EMgheLW13wPunjRCFeLlq1IS5YZp1iht++gexSqRCr1IzCJgSs2TMIEP0
         ch+Q==
X-Gm-Message-State: AOAM532CYr5KtRhMkjTsJsHLAKCiZjvqyR/QiWYpr88H3e9DyEIGLjmG
        FGzpBu8ZTcbYPxptJ8wIQ1C2mw==
X-Google-Smtp-Source: ABdhPJymwQMdZhFaSyjGDnlt+menDtwzQQADglIsXXECW6hndG5cCdTG68VLPtru0r96t/v1fmFy2g==
X-Received: by 2002:a92:290c:: with SMTP id l12mr7549411ilg.279.1591880282837;
        Thu, 11 Jun 2020 05:58:02 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id a10sm1513662ilb.31.2020.06.11.05.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 05:58:02 -0700 (PDT)
Subject: Re: [PATCH net 5/5] net: ipa: warn if gsi_trans structure is too big
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200610195332.2612233-1-elder@linaro.org>
 <20200610195332.2612233-6-elder@linaro.org>
 <20200610.163658.2043816131147701638.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <448830d1-c19e-b8d6-169a-a114baae133f@linaro.org>
Date:   Thu, 11 Jun 2020 07:58:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200610.163658.2043816131147701638.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/20 6:36 PM, David Miller wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Wed, 10 Jun 2020 14:53:32 -0500
> 
>> When the DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC config options are
>> enabled, sizeof(raw_spinlock_t) grows considerably (from 4 bytes
>> to 56 bytes currently).  As a consequence the size of the gsi_trans
>> structure exceeds 128 bytes, and this triggers a BUILD_BUG_ON()
>> error.
>>
>> These are useful configuration options to enable, so rather than
>> causing a build failure, just issue a warning message at run time
>> if the structure is larger than we'd prefer.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> Please fix the problem or prevent the build of this module in such
> configurations since obviously it will fail to load successfully.

It will not fail to load; this really shouldn't have been treated as
a BUG to begin with.  The condition can be detected at build time but
I'm not aware of a BUILD_WARN_ON() (which would probably break the
build anyway).  The check should at least have remained under the
control of IPA_VALIDATE, because it's really there for my benefit
so I'm told if the structure grows unexpectedly.

Your pushback on this has made me think a bit more about how much
of a problem this really is though, so I'll omit this last patch
in version 2 of this series that I will post today.  Then after a
little more consideration I'll post a revised version of this one
(or not).

Thanks.

					-Alex

> It is completely unexpected for something to fail at run time that
> could be detected at build time.
> 

