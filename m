Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5212ED5CB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbhAGRjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbhAGRjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:39:46 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C611C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:39:06 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q25so8201933oij.10
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jLmM96kg2VBYgesrpJCh2pt16H8McmMCogSZFU4j/UM=;
        b=erehM9vigMAUWAJdkwO/c81hE2j5J6kjKqdojBO8KQfL6msHmHA71ToV5h/XytKHRp
         t4mktXY3C/x6HdakMDGgYkmQ3RZm5h6AeHXm/6QMDCd1y2VOxBhp4xyAweKDXHWjPtkW
         xQopR4xRPHqKl+LIt/nYiv1Pe/wYY/RWxM7nRBmcFSaioUgUsETIqNHnVTkBRp7fu6iE
         RF8QYm7swEKHFBwAsEjU6lYwvDuO9+g/yfHzDY0y3KY+Ej3Np6hj4OZ7Iri1sEa1HpVd
         E1GPxHP8oQgWVONwutheRLKnMHUwEZZE+88JeJoNTEbFTBIBhsRiF3zOLWKnpgWnDZJ9
         Caig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jLmM96kg2VBYgesrpJCh2pt16H8McmMCogSZFU4j/UM=;
        b=ZKlrMnSizKm/x9yx9MJXGvnnD930mBNzP+HRZTK1v/Hvui6Z0T8IldFXkEFpZN78h+
         26mBvgk2Xhla82BGmrGlk4vO1SHGi2meYmJAwWLOYfpteaoy8sayrTzlovUXXHrgVDZg
         lWYajoqX7vO1+kPiePKmARA8E82QcN6J70EYHrvtQUcQZwTy6n6Xj1g/fBV/ADV+NI1e
         FxtGq6a9Nq2IeIyt8kS3PJfHp8jX6Ij2l92/w1du7rUV1MCB4MfvDe15IArhizloM8xt
         VwlE3o913yjcw4+zHjX0RPL+hAnZTJTz/6/Jc8Sd7gvDjGdS3J/1KQc6q2aWtarU+M6W
         9XIg==
X-Gm-Message-State: AOAM532/l28bGdCFhyJ6WmQ8cpijHio+pK0cgDzz7lhR0ydgYTPsLG2R
        NxqcjEGOMiGyp+1Zv5ZnHIEz7R8MT/o=
X-Google-Smtp-Source: ABdhPJzfeClHWwPcQpgV/e780ce+rQJUSreNvQL0zHx2SbZGeFyxvxNPRr2n4rA53xPlVbzQXdB5yg==
X-Received: by 2002:aca:c5c8:: with SMTP id v191mr7035887oif.67.1610041145297;
        Thu, 07 Jan 2021 09:39:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:800d:24b4:c97:e28d])
        by smtp.googlemail.com with ESMTPSA id r8sm1253442oth.20.2021.01.07.09.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 09:39:04 -0800 (PST)
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
To:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
 <20210107164856.GC17363@linux.home>
 <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
Date:   Thu, 7 Jan 2021 10:39:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 10:13 AM, Jakub Kicinski wrote:
> On Thu, 7 Jan 2021 17:48:56 +0100 Guillaume Nault wrote:
>> On Fri, Dec 18, 2020 at 11:25:32PM +0100, Guillaume Nault wrote:
>>> The json output of the TCA_FLOWER_KEY_MPLS_OPTS attribute was invalid.
>>>
>>> Example:
>>>
>>>   $ tc filter add dev eth0 ingress protocol mpls_uc flower mpls \
>>>       lse depth 1 label 100                                     \
>>>       lse depth 2 label 200
>>>
>>>   $ tc -json filter show dev eth0 ingress
>>>     ...{"eth_type":"8847",
>>>         "  mpls":["    lse":["depth":1,"label":100],
>>>                   "    lse":["depth":2,"label":200]]}...  
>>
>> Is there any problem with this patch?
>> It's archived in patchwork, but still in state "new". Therefore I guess
>> it was dropped before being considered for review.
> 
> Erm, that's weird. I think Alexei mentioned that auto-archiving is
> turned on in the new netdevbpf patchwork instance. My guess is it got
> auto archived :S
> 
> Here is the list of all patches that are Archived as New:
> 
> https://patchwork.kernel.org/project/netdevbpf/list/?state=1&archive=true
> 
> Should any of these have been reviewed?
> 


Interesting. I thought some patches had magically disappeared - and some
of those are in that list.
