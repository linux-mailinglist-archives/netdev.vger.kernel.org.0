Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA01359F67
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhDIM4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhDIM4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 08:56:15 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392C1C061761
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 05:56:02 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w23so6436018edx.7
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 05:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citymesh-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=kvoch3I7dH1Borope1QoU/3kV19MJ6NYyNXR2koLaZQ=;
        b=Ofh9yB9b3ptIysHXeCvSt4gLfRa231Qv/0DfeDuqTTxOBFD9MXOXA9G8ZA2pCvXW0B
         WeH58xd9IO7WHPic7gQlGm/WVzBEq/6jqDfVmiGUuRpK4ff6VGB8l8yMTt3LzOB/K2Gv
         I9HsdkWrkdz3pxf/KaHzFL2md8B/Xsn8eua0KxJA7YRBy9/7dyzBEkkl/4hisspieaVH
         V6Kxo2ss2p/zUoQigfBaXOm2SfDtm/zVjhMtcwiNpc1EgBtIMBJmgKAQjdYBM64bzKW+
         +MPS0fbBjETb6fiVb9XXbLU0XYZycarw/5HRkFeqN+tGTkN1tD4hFzbOP+/nP7LELZ86
         KIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kvoch3I7dH1Borope1QoU/3kV19MJ6NYyNXR2koLaZQ=;
        b=aPFo229fY0bUDEONidhmOJ4Q7P64OYRaqrIVLnai2vIJHOBIYajDozhns6oO+tpmCz
         w7zpIAMlDI+1e4+3sSh09DMNfj7bh1/U/d0//TcBLztnRxehoEzBtEUmPYPBfhA7gn4w
         xFya1trS63oRkhX6dRjsUV3b7GGMYaiIKs01UosevgtfyY9XEJDFJ9GFzHeJDS7emin/
         XGriqsWbOrYamQX1mXyIaHPqgY7flkakbLXqM94AVeawbSJj/xKdphxD4L4dBGbAxs9T
         2+FFeyF3sxiGbkN6dNV/n1lI5TYvpn5gWKaED2xSH0UkXBZp5JsrRhG+FMN3nnjkSYmb
         BrOA==
X-Gm-Message-State: AOAM5301QFcLQEXgP6k1jwrgWj+VyFemtabDBUWczKSsj+Ttjyv7BKF1
        a7arAi4Z+X3Rt20DM1YZkzmJZ2YtmSileJHg
X-Google-Smtp-Source: ABdhPJxXuyERTLCe84nRJRD0IMXBvhEwcKd1tM/u03fdGXcXchboST8Um+NAuTRcZkFjI3/gpwAaAA==
X-Received: by 2002:aa7:c683:: with SMTP id n3mr6269330edq.214.1617972960926;
        Fri, 09 Apr 2021 05:56:00 -0700 (PDT)
Received: from [10.202.0.7] ([31.31.140.89])
        by smtp.gmail.com with ESMTPSA id h24sm1217935ejl.9.2021.04.09.05.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 05:56:00 -0700 (PDT)
Subject: Re: flexcan introduced a DIV/0 in kernel
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     wg@grandegger.com, netdev@vger.kernel.org, qiangqing.zhang@nxp.com,
        gregkh@linuxfoundation.org
References: <5bdfcccb-0b02-e46b-eefe-7df215cc9d02@citymesh.com>
 <27f66de1-42bc-38d9-8a1c-7062eb359958@pengutronix.de>
From:   Koen Vandeputte <koen.vandeputte@citymesh.com>
Message-ID: <f7ba143a-58c8-811a-876e-d494c4681537@citymesh.com>
Date:   Fri, 9 Apr 2021 14:55:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <27f66de1-42bc-38d9-8a1c-7062eb359958@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09.04.21 13:21, Marc Kleine-Budde wrote:
> On 4/9/21 12:18 PM, Koen Vandeputte wrote:
>> Hi All,
>>
>> I just updated kernel 4.14 within OpenWRT from 4.14.224 to 4.14.229
>> Booting it shows the splat below on each run. [1]
>>
>>
>> It seems there are 2 patches regarding flexcan which were introduced in
>> 4.14.226
>>
>> --> ce59ffca5c49 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
>> --> bb7c9039a396 ("can: flexcan: assert FRZ bit in flexcan_chip_freeze()")
>>
>> Reverting these fixes the splat.
> This patch should fix the problem:
>
> 47c5e474bc1e can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing
> bitrate
>
> Greg, can you pick this up for v4.14?
>
> regards,
> Marc
>
Checking kernels 4.4 & 4.9 shows that this fix is also missing over there.


Marc,

Can you confirm that it's also required for these?


Thanks,

Koen

