Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4BB18C6BF
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 06:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgCTFVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 01:21:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44700 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgCTFVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 01:21:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id b72so2622848pfb.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 22:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4xD0nUn8mXtE6yYJjLe65pyNK1INL6oN7KuUf+B9+vM=;
        b=MzYJj3S+oQvsZ/wqudKPzS1eeJ4BlWWe7DDGmuEBW0jJgKvqXOJU+WG39KhWZVNaVT
         kAWP3wtWWQ7LRlGxUQWlVWIYOQ3RFn8JKF51XTbOBv+izH8M2rVeTzuq2VIpjdO4je2t
         YsF8ACYwutW5eXqPFIqXFW1chWKe968dj1Vey9HW5AS6mhFexz+QK9K8jiYhFf3UPjTR
         OinrhTrfg3XEOEXMOO893B/bNKRHkJf/7/flLWi2AR6+jO1oxqNbDxbwD/N7F8BffDnf
         v2vaTCHP0mIj2VA+HFtYZsY2+FAO7siai5wx7tKazLG2crjxlkWj1pdRQECztgw0mHqo
         Cj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4xD0nUn8mXtE6yYJjLe65pyNK1INL6oN7KuUf+B9+vM=;
        b=YXcLRFrHGk157a/GTlj9Ur69k0FZ2Sxt9JodZOTRX0f9x6KvYvnfJAhS0pKXP+6O4D
         22nrNKrbk4bG+HBepL7CrV9szCzb9lHPlaOQFQ55ruyrmKZ6AmNV4l82MGYLfaaCJPj9
         UMNoO6LMe0wIa42PunApvs1/FUmnTJEoZPDeSE/RRi7si5PUO6qMNR8ne73E46ta4uXJ
         PLvJST8ZMUr7ZILKmbVR6OsRhEIgjfBuUmA73FLAC+67jAkzYmyNO04IyFR6KhOryhit
         ZNPHY0VuQ7Wadu976nU/5/H1ZZEEkf7n4sYr9eqEF2HpPVU5+o/n6M/iHp+t2im6BOqA
         gtJQ==
X-Gm-Message-State: ANhLgQ1cLvMXRv0XoLOQ+9o1CwQMy6mN/QzupXsT2liHTVS2cgouLVik
        XxhXGM/tFToQW70HZqWOHs07+g==
X-Google-Smtp-Source: ADFU+vsXf2R59wxtNj8ydb92PndqyPphka6SINocnqw+tH0FTQQRbyeQD6Pryfs/1/lRYy8aHr6GpA==
X-Received: by 2002:a62:e709:: with SMTP id s9mr7448151pfh.22.1584681708430;
        Thu, 19 Mar 2020 22:21:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r4sm3283818pgp.53.2020.03.19.22.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 22:21:47 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] ionic error recovery fixes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200320023153.48655-1-snelson@pensando.io>
 <20200319204640.36626901@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <63823ff6-9e63-6129-ce45-bf0dc95f0961@pensando.io>
Date:   Thu, 19 Mar 2020 22:21:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319204640.36626901@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 8:46 PM, Jakub Kicinski wrote:
> On Thu, 19 Mar 2020 19:31:47 -0700 Shannon Nelson wrote:
>> These are a few little patches to make error recovery a little
>> more safe and successful.
> Patches looks good to me, FWIW. Thanks for dropping the controversial
> one. I think this should have been v2 since we seen most if not all of
> these.

I suppose v2 would have been okay, but that patchset was specifically 
labeled as for firmware upgrade, and these are "merely" supporting 
fixes.  It didn't seem right to keep the firmware upgrade in the name, 
yet it didn't seem right to call something with a new name 'v2'.  I 
suppose it would have been good to call out in the cover letter that 
these were refugee patches from a previous patchset.

> I'm not sure why most of them have a Fixes tag, though. The
> AUTOSEL bot is quite likely to pull them into the stable trees once
> they land. Is this some intentional strategy on your part?
Because in my last patchset I had similar types of fixes without the 
Fixes tag and got reminded that I should have the tag.  These do fix 
"issues in a previous commit" as suggested in the 
submitting-patches.rst, so it seemed appropriate.  They aren't high 
priority issues, else I would have targeted them at net rather than 
net-next.  If accepted, they'll get there soon enough.

Meanwhile, thanks for the review time :-)

Cheers,
sln

