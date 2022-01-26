Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02F049CEE3
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiAZPum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiAZPul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:50:41 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80586C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 07:50:41 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id y23so272397oia.13
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 07:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S+p1Iywa9n94TMWqx82eHf+AAl5G14Vk7TQnejY8W+M=;
        b=LU/12S0D9x6hcvnEX+v4m2tRYADhKIg3Rw04GlL4cwnBNzXJWNO+UiFA9TH8xHot4R
         TWIWrLAnE/xU6WmMFk1Ba4Sl5/jdkm+rW6d6RvjG3bHm1HLKoTCT2bWYLzq+O+HgsA4L
         wbai55v5vCaQzJmLKo91mkweV9/wnhQGqZOS2HyarpF6IihgI4PM/UiqTrUgQi570Df4
         qs8dnBiAPC+oa5gZxTXIyE/nUAKtY7ycJbTQGk9YDm4vUQpqnUH/OdMcmSGxUmfMUf2s
         JB1GqMIDZN4TaUYQrfCVCnFi+d44hk5tYUdQ3ppKhSxV8nxu9FtTp28i/eM73wQ+e2Xb
         A4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S+p1Iywa9n94TMWqx82eHf+AAl5G14Vk7TQnejY8W+M=;
        b=ze/2JhhdNaDd3c41Tj31P0kLuWuSye71bMoe7086YVR+TY05S3YObyoAXtf7v+77wZ
         yo96sk3UAikpGuZhtTgEMb86U/ree6tq2SHfFkAyDwiGVK7EpmpvTnh50mEy83XCiEh+
         6IyeRhA4zkXKNbCBFMz4Nfu67cBRGlEyznR4ozDJSZlj/X0Xl1mGZACFE1Tuf3dWNdiz
         Xbth+e/178SdQyJowoVvEzhjJI75bdxq2qlzt3FZvEjG32DtfXPdZkIVFDyNItQhd1ay
         jO7iTEqgBLiWV9EYDFzWpt1rr9/bhd58kDqi9mH8m/hu3cE8aTJAGOlYTryZOVfJmI6C
         T4fA==
X-Gm-Message-State: AOAM532dL5dPBbPdIn8yA4SKOfcGrK9QjO5Ibkxoxqw61W2DEHQkk0S5
        7LAAxUALNo5CfxHel1h2xPY=
X-Google-Smtp-Source: ABdhPJwAE6CJcU9EYJY4mAhQWrH2zkVEHSXiP9s2ShpEl6HFEDuWbew/dTfc42Eds39RLr4ltWYVXw==
X-Received: by 2002:a05:6808:124c:: with SMTP id o12mr4108115oiv.314.1643212240958;
        Wed, 26 Jan 2022 07:50:40 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id h1sm3559834otl.37.2022.01.26.07.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 07:50:40 -0800 (PST)
Message-ID: <a7ec49d5-8969-7999-43c4-12247decae9e@gmail.com>
Date:   Wed, 26 Jan 2022 08:50:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local> <Ye7vAmKjAQVEDhyQ@tc2>
 <20220124105016.66e3558c@hermes.local> <Ye8abWbX5TZngvIS@tc2>
 <20220124164354.7be21b1c@hermes.local>
 <848d9baa-76d1-0a60-c9e4-7d59efbc5cbc@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <848d9baa-76d1-0a60-c9e4-7d59efbc5cbc@mojatatu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 6:52 AM, Jamal Hadi Salim wrote:
> 
> Makes sense in particular if we have formal output format like json.
> If this breaks tdc it would be worth to fix tdc (and not be backward
> compatible)
> 
> So: Since none of the tc maintainers was Cced in this thread, can we
> please impose a rule where any changes to tc subdir needs to have tdc
> tests run (and hopefully whoever is making the change will be gracious
> to contribute an additional testcase)?

I can try to remember to run tdc tests for tc patches. I looked into it
a few days ago and seems straightforward to run tdc.sh. The output of
those tests could be simplified - when all is good you get the one line
summary of the test name with PASS/FAIL with an option to run in verbose
mode to get the details of failures. As it is, the person running the
tests has to wade through a lot of output.

> Do you need a patch for that in some documentation?
> 

How about adding some comments to README.devel?
