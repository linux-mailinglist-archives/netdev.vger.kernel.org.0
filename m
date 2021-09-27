Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8E941A33A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 00:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbhI0WqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 18:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbhI0WqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 18:46:13 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F3FC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 15:44:35 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id q14so21117334ils.5
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 15:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vNH3bpx2Xfls0gbV7CgZ54eN2zRp9Y6is4yoJRUG+as=;
        b=DPs//CPDUsX8gvoEODurtiIrNPG3VBaO3GrMlVxQoSqm4Ra7DPTYT4ptiwC/WaQ9Q1
         ALewy1dEYpmh2/S3KAwUD2zCUp/gAOpJji6XbA+4O5ACrNiOI0msjmz49iubwzO4l31L
         ZOPRbfuQfEdPZisErWyGnbLvAMyRN4eVLp4C2xiNm+FYO0SlQ4cl5XEEIm6MOLJ05oOf
         cDZqxSARFDdI8w3SR7sR++Cw4osU99GNJaWrFHDwuXwI16n9YNW3arXQ2AhzxpdU/UsN
         faLD8iYIpO/fXw3wdE5zB4FRjTCtHm8fcs27NKB7nZPB6I3FKXJUNAJkc3IxEYxeVZwI
         twLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vNH3bpx2Xfls0gbV7CgZ54eN2zRp9Y6is4yoJRUG+as=;
        b=A9hsJ05rr995x8kmOfkbPfcSgg4zAv4+Tkjiqk3y899PRcf/JKkOrY5AvA2W7qxzK8
         rUW6Kes6dI4HnYJA/kHwV9m4o6YAt6ZJXRM0NnjUvwRxx0379rnDRsiVH7ozLmkb3ZPz
         KRF71YJRSXk56lZQkowpuPgkZTvQmxbmWzckO7ZbZMs1UvKkIaUSOBpLXbghn86YXw5O
         158XCtkV6tloxqg8VKTV3+tWIdyHxgX5c7sqCh2/Or3pZTNqGtujYxB6XEGIiVxUKvsp
         MA8j4qyoR6TKpqCruNB3KitgWT5ycr8bWHruMRwrcndlVV+a7musrVhjAbiGAFCab3jI
         QnPg==
X-Gm-Message-State: AOAM533/A36s4+HndxDecHWiatKsYpqEBUgUTtjGt6LvtgkNiPX5hVex
        FOK0CvzVNcw4CZq5shDRwAA4iKq/+3zimQ==
X-Google-Smtp-Source: ABdhPJz6yf2buVwQcun2ytcSxDtr1FdLuI8OroaPJLVEM1m77aZimt9X9SX6ZSt7Y+iHOkE8Iru3HQ==
X-Received: by 2002:a92:ce48:: with SMTP id a8mr1877662ilr.115.1632782674633;
        Mon, 27 Sep 2021 15:44:34 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id 12sm10002570ilq.23.2021.09.27.15.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:44:34 -0700 (PDT)
Subject: Re: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
To:     David Ahern <dsahern@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
 <e0da1be9-e3d4-f718-e2c6-e18cda5b3269@gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <eca394ee-04c3-2d33-2c82-1f3360211845@linaro.org>
Date:   Mon, 27 Sep 2021 17:44:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e0da1be9-e3d4-f718-e2c6-e18cda5b3269@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 8:48 AM, David Ahern wrote:
>>   		} else if (matches(*argv, "help") == 0) {
>>   			explain();
>>   			return -1;
> use strcmp for new options. Also, please use 'csum' instead of 'chksum'
> in the names. csum is already widely used in ip commands.

On the csum remark, I agree completely.

On the other:  Are you saying to use strcmp() instead of
matches()?

That seems strange to me because matches() is used *much*
more often than strcmp(), and handles an empty *argv
differently.

I don't disagree with your suggested change, but upon
looking at the other code it surprises me a bit.  Can
you provide a little more explanation?  If you mean
something else, please clarify.  Thanks.

					-Alex
