Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417011F8605
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 02:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgFNAdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 20:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFNAdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 20:33:13 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1534FC03E96F;
        Sat, 13 Jun 2020 17:33:13 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id v79so12534537qkb.10;
        Sat, 13 Jun 2020 17:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C/gN5QvuZVItaz+X97RNteBVgSNHJhCVxtlFAT4qa5c=;
        b=CbX/GLJ7z6qr63wjT6VYP4YyuT3Kls2y8xO6EiGWtDKETU5lYMcCm9w9aY+bLfCdK5
         dbVewLJr415Kjzr71SrBhtVb4ZiRAMJnRH4sSo+G5LrRtVaf0aXcCL3OhWuHjPuJ0q6q
         MD/jq7kwE8SHqKAJsn/R+x3C76/lYxWpMkIT+FVat/YWowmxYTl/qj/bMm3TkpJostHK
         WUUkzeyfI105AL1bTmDr64F+pEzbo9iacO2ek4d7xPiEYbw7Y+bVmFO1ml/73uimDViS
         Y6jsORc6JRVfidsa+5QC1WAFKR+Ln51vIsRtfYaJFfKUJBn7jPbza1rSLLEX301Q82Y/
         YLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C/gN5QvuZVItaz+X97RNteBVgSNHJhCVxtlFAT4qa5c=;
        b=QA9S/Fly07x0RNKw1rkUH+y0TpgdiiFbAe4XNbJgM2BHLZwAB4UzvMeBAg3sXQ1BS5
         FwAo/PwstpgXNXLPn2lpyzjFaRmHQhG5ocuFwxIUvhC3pstNCBVSmlmHqkTgtV2PxSiy
         Lp2I3tUStvIKwMrXCOP2leVCm9Ugp3wgJ/mYtUseGXkOBnl2f6KmjSBmG3SMCBgRbz/9
         MABw/CfX0+OwWMh0gPOoJo/HQCSSkzHvnlwY3GtnZYHalHzFn6QqYbBljeG6tcu0fE51
         z18dWW1ZYH8bKHuhspVjZ8keDKl6vusjmVFWI7LfL8OKDxjVWSrAxdXMIzYlIRnZckbb
         fbwQ==
X-Gm-Message-State: AOAM531BKYkWUyk5WrXDVb55kYicaopylyYcvtEG0ZVS8G/Tw/HPQ37u
        u6vpY1ePx66nUit75ouz2b8nNpkF
X-Google-Smtp-Source: ABdhPJwFybvKGT3uSa5VzZxPuDOcoZa7kgVrXzgsap1sI7boInmcBGHtZF0T2/TvZHeySs5NMvbVZg==
X-Received: by 2002:a37:7ac4:: with SMTP id v187mr9875564qkc.65.1592094791538;
        Sat, 13 Jun 2020 17:33:11 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c0a6:d168:a4bb:a408? ([2601:284:8202:10b0:c0a6:d168:a4bb:a408])
        by smtp.googlemail.com with ESMTPSA id 124sm7884475qkm.115.2020.06.13.17.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2020 17:33:11 -0700 (PDT)
Subject: Re: [RFC,net-next, 0/5] Strict mode for VRF
To:     Dinesh Dutt <didutt@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
 <34a020ef-6024-5253-3e14-be865a7f6de1@gmail.com>
 <20200614002935.3a371a8be63f9424ffdb745c@uniroma2.it>
 <3099cf72-d54c-494c-b11a-0131138f6d41@Spark>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <920434b5-f557-2ee3-d64a-6aa08d861297@gmail.com>
Date:   Sat, 13 Jun 2020 18:33:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <3099cf72-d54c-494c-b11a-0131138f6d41@Spark>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/20 4:39 PM, Dinesh Dutt wrote:
> Understand Andrea. I guess I didn't say it well. What I meant to say was
> that the strict mode is the default expected behavior in a classical router.
> 

it has to be off by default for backwards compatibility.
