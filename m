Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B47119F4
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfEBNTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:19:51 -0400
Received: from mail-yw1-f47.google.com ([209.85.161.47]:37837 "EHLO
        mail-yw1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfEBNTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:19:50 -0400
Received: by mail-yw1-f47.google.com with SMTP id a62so1522741ywa.4
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 06:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LSZ6Xny4LZQUGhGFg3mYcBhhmn/IHd740K5h6icxRBg=;
        b=ejfAAHxEYeAPd+Oe9yGVG2tCYYs+BBJsHXum/PHpaT/re1ljiPJvRcMd5fsY9qwGL+
         O1Y6FuYx9XNWFsirqCMP2M5qQeliQDwxzRhVs4ow4ewpwFY+/aYJg20INx1VreY0RGMO
         XLSSYoPqBIVQbht4/aG5++NW+6KQ7PnxNGDSn+xoJwUtueAlF+OlNRRNqWEnapwb//vw
         pA03zh95B2oprdYHRP4vxSf1UB/9Hu/rnlC7qHVld+Xr8QpRMmFQSk5UkXeisg/lQPSK
         styXC5IwCtBSm9KPRY57rnTp00GEaxa75Uj9eA8WlWHoYld8t9I3cX3kCT+jJnrV5eWO
         oQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LSZ6Xny4LZQUGhGFg3mYcBhhmn/IHd740K5h6icxRBg=;
        b=uBWpO8hajGYFvPTeb99DJ2Y0jCbPDOjJYOiHT6Bqg1hzRC+z7HUyrmORbRwhkXvNSP
         43+Sh9Jp1/2o6b7qCc76xTCBWoxuf80guB4v0MfKElz3sMuC+L0LueaTgyrZbwCekTIW
         VtHobID4a7oZLp2DUpJZBGHNxS0DKDJY5GgfxGbzD82ql16XYv7pcrjCB4rhlpG5EWq/
         s0RlGe0VHlaNFZ3ZCt+clNTtUlvRwkc3JkuKFFAnbsgo8jD78erWhfJi4aC+mbGdHxxi
         IL8AZia7Gde3akUcrJVmkuYlvtrt7cxP1xt4s3SleWM6hR7rpYkjPhjYlBWYfKPUD/wy
         DcDw==
X-Gm-Message-State: APjAAAULoPSS1ITGTEQSwyMicO5zq6fY/O79TRS1zsmO9/zpnQz5mwdZ
        /Gm8Z17rLqzzjjCFsx7aozN/2rSw
X-Google-Smtp-Source: APXvYqxX4U/szx7iQcE4wBXnX/mnI9IlIoK7gARgSNsDB3XHwYofeAHl/zF6AULGXV1J3QX+NnxdVQ==
X-Received: by 2002:a25:b6c9:: with SMTP id f9mr3037240ybm.514.1556803189535;
        Thu, 02 May 2019 06:19:49 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id x12sm17451165ywj.76.2019.05.02.06.19.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 06:19:48 -0700 (PDT)
Subject: Re: ndisc_cache garbage collection issue
To:     Tom Hughes <tom@compton.nu>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
References: <7ebe8ec1-c407-d907-e99a-adcd89a8e16b@compton.nu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7b7bb95a-9940-54eb-94df-9085d269c431@gmail.com>
Date:   Thu, 2 May 2019 09:19:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7ebe8ec1-c407-d907-e99a-adcd89a8e16b@compton.nu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/19 5:42 AM, Tom Hughes wrote:
> I recently upgraded a machine from a 4.20.13 kernel to 5.0.9 and am
> finding that after a few days I start getting a lot of these messages:
> 
>   neighbour: ndisc_cache: neighbor table overflow!
> 
> and IPv6 networking starts to fail intermittently as a result.
> 
> The neighbour table doesn't appear to have much in it however so I've
> been looking at the code, and especially your recent changes to garbage
> collection in the neighbour tables and my working theory is that the
> value of gc_entries is somehow out of sync with the actual list of what
> needs to be garbage collected.
> 
> Looking at the code I think I see a possible way that this could be
> happening post 8cc196d6ef8 which moved the addition of new entries to
> the gc list out of neigh_alloc into ___neigh_create.
> 
> The problem is that neigh_alloc is doing the increment of gc_entries, so
> if ___neigh_create winds up taking an error path gc_entries will have
> been incremented but the neighbour will never be added to the gc list.
> 
> I don't know for sure yet that this is the cause of my problem, but it
> seems to be incorrect in any case unless I have misunderstood something?
> 
> Tom
> 

Hi Tom

This seems to match your report : https://patchwork.ozlabs.org/patch/1093973/
