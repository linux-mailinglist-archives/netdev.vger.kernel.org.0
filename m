Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CF32B14FD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 05:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgKMEGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 23:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgKMEGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 23:06:44 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731CBC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 20:06:44 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m13so8421723ioq.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 20:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V7+QX2emMAd1YFMrI6A3ZRFkdoO50/trPP3fqDTmqWI=;
        b=PDYY8UinFCJvgB27AS28h4naLMSXcFRoMh+/bySQCmEWn+u0KR5p53nli4ZlDCCnU1
         vHImxmVbbwY3+oX2b83GW7/RSCQAJLo7vBMnULt5dEkDsfZypYpk2q8nquja6+GXCisB
         kw+PsFktNdd2ToeTRJlaXqX6T0TTmghhRTjgi/A5P+TjKdF4OgFldn6outNSYudb1DqX
         jXHKPBKWp7cOzgPRWQHj1doAckvDo7Zdg7xguLI4QZGUTm1HvYHTrc+UNRwGI5KSYRNN
         xDBj3kAD2G9h+E7BFlVGmeG7fdbZl4niKvul7dayimUZM5ic4zxiqTE5h6hG68VIJb8Z
         hqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V7+QX2emMAd1YFMrI6A3ZRFkdoO50/trPP3fqDTmqWI=;
        b=TDzZMksQfG6Ua/hV8vphF/C9JmksbyvVt9vVYChHRzLxucNT46PmxrHCPM6ho9ZtUq
         jpiI62tT1XNcV29T/RzIP414mpsBS6ReSaUiy/mD0FaG1VWi7h71FuqqRjwmlusOpdMy
         GfBXQLPz3R00Pyx5Ny5R5oWXrlkL9pUzBQcs8bBwtY3e66L9/armHIOY4irf7n/LtrZQ
         ncNwa+bjW/FSRdFP0l9BZ/b78DV28ZTlbwIWhxpBkLdGA14TZEhYL1A/mMBOCdf0Mj//
         GXVkCTpLDofr1hiZXPvm47p/Cv2OvgG+MhyhCqduEcZSzcLFYR7pw9V7Ob6O6Iyag7yz
         VGpA==
X-Gm-Message-State: AOAM532SshNISbRq+Krjur8x9gdZa8OqL+yPoJlQV1ovjzjMn5dEZhKN
        xcZCQwbCjSiBwY9cwwIKpHm2h8lMBck=
X-Google-Smtp-Source: ABdhPJwqBsj78eU+wk2F5Q4BZB8eAndE5DpQqUtPgcbIBRqcbehrOP9SYZs9ysHhOJ7LSRiztXXAdg==
X-Received: by 2002:a6b:7f47:: with SMTP id m7mr369551ioq.83.1605240403800;
        Thu, 12 Nov 2020 20:06:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:781e:c7e6:68f1:ffce])
        by smtp.googlemail.com with ESMTPSA id l4sm3636127ioj.41.2020.11.12.20.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 20:06:43 -0800 (PST)
Subject: Re: [PATCH net V4] Exempt multicast addresses from five-second
 neighbor lifetime
To:     Jeff Dike <jdike@akamai.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
References: <20201113015815.31397-1-jdike@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea21130f-74fe-2dfa-2d42-b9985c21e705@gmail.com>
Date:   Thu, 12 Nov 2020 21:06:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201113015815.31397-1-jdike@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 6:58 PM, Jeff Dike wrote:
> Commit 58956317c8de ("neighbor: Improve garbage collection")
> guarantees neighbour table entries a five-second lifetime.  Processes
> which make heavy use of multicast can fill the neighour table with
> multicast addresses in five seconds.  At that point, neighbour entries
> can't be GC-ed because they aren't five seconds old yet, the kernel
> log starts to fill up with "neighbor table overflow!" messages, and
> sends start to fail.
> 
> This patch allows multicast addresses to be thrown out before they've
> lived out their five seconds.  This makes room for non-multicast
> addresses and makes messages to all addresses more reliable in these
> circumstances.
> 
> Fixes: 58956317c8de ("neighbor: Improve garbage collection")
> Signed-off-by: Jeff Dike <jdike@akamai.com>
> ---
>  include/net/neighbour.h | 1 +
>  net/core/neighbour.c    | 2 ++
>  net/ipv4/arp.c          | 6 ++++++
>  net/ipv6/ndisc.c        | 7 +++++++
>  4 files changed, 16 insertions(+)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
