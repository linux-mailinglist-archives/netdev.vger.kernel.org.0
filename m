Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CA42412DF
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 00:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHJWNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 18:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgHJWNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 18:13:50 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144CBC06174A
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 15:13:50 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id y11so5050066qvl.4
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 15:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pra3SrFuKrdDDwFtqfJoHGXZJG0dtmjCDpaQK1r/zR0=;
        b=t83KnR3NjuzI9b2nxYCS/bFh3IIDaKSloFhL8qX3AkCwpslJjImZoYb6B/gnm3xt6p
         d1U3+DUqgTUknEgoClnCWdMeeYzc5qigVOvWeWGhK7yhkU47QYmU4wtzbjcnUQMXmf/e
         PVxpwnG7DUTshjxqgCCMaPsUU7BGlRPRabLxl941RJGCN3ZXTZ7UoVdss44NqAZMLvYj
         o0IvHfXz8/7MZ0u0obOLfDJXmi2eaTTcE2LH0E1bbnN9NIS1P3K35HvqsWSA1+5WLY+5
         YwOqI5WV6wGbWeSsG1vKnhyLGZXMKBBY3VntUdFamp0UCaNHB4wbSGzcWceA6kvfzg3Z
         XQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pra3SrFuKrdDDwFtqfJoHGXZJG0dtmjCDpaQK1r/zR0=;
        b=dZU2/DzFL47lKe1ESa4WRCED/uSMjVPFOnSDUuNh4i1H3TvkxIsPRTjA8qIN2hjMKb
         GHwQI2aq4ias+Bd9F3U89PZCarkXz7IdoBOf2yQ8liXyQjaTr1jh+DTC2xZTG0p7PGa9
         JENdKG0rrsHVVhoMd4uVabmJQ+qmmBCJFbrPvD/4gf8dHqbswM2U+41Zjul9tqhydnRN
         5YNSlR9W94MzmY98X2Gg3XST2OJSP7EW4OjxFU9IQt6ZJVmxIRm+vT7vIdhX3P+ZMttV
         Lkzv5xDhvKlPI6BsjWRhW1MIkYuQjnsT2TqENAbFeYJbAPQfvYLaAL4JqxP8KQvmhw6z
         cjHA==
X-Gm-Message-State: AOAM532UkzmwKVkVSdqBpS0dyYnEz4W0RfNM4NjDrv0ynEIsaBDYEyr3
        tj8ZtvanzU99x9vpF51w5LqBLo4V
X-Google-Smtp-Source: ABdhPJwUx5Tx/oPHEkYqnvLAPMSUWAc5AvVrfGqoYzs+vc1lHg7TAZbYQA8KYImdFWw192KDDjhLag==
X-Received: by 2002:a0c:9cc4:: with SMTP id j4mr29654626qvf.230.1597097628133;
        Mon, 10 Aug 2020 15:13:48 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:90d2:5bdd:2f7a:d7f2? ([2601:282:803:7700:90d2:5bdd:2f7a:d7f2])
        by smtp.googlemail.com with ESMTPSA id m26sm18088008qtc.83.2020.08.10.15.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 15:13:47 -0700 (PDT)
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     mastertheknife <mastertheknife@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
 <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com>
 <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com>
Date:   Mon, 10 Aug 2020 16:13:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 12:39 PM, mastertheknife wrote:
> In summary: It seems that it doesn't matter who is the nexthop. If the
> ICMP response isn't from the nexthop, it'll be rejected.
> About why i couldn't reproduce this outside LXC, i don't know yet but
> i will keep trying to figure this out.

do you have a shell script that reproduces the problem?
