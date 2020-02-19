Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C234165192
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgBSV1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:27:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34328 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgBSV1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:27:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id n10so2316156wrm.1
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 13:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zgJNy1KN5aZ3jMvMKrXLxUkXUfdBKayzMP92yT7iHAE=;
        b=FGXmWU8bAD8kS9TpjALm6lTDIzKEM9meY5HeNSkKJPkzHzhg/k09WFkAsVEGRUyTBD
         J9UXjrhWBuyfw42dewC3J234eI7aSOqCqUAdKciYUisPy2wBTL6B6Yz/LbPzQQMMs2z7
         7OEBSxlj6X/ESkBO5VcghYzI9VU3ifW+GihV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zgJNy1KN5aZ3jMvMKrXLxUkXUfdBKayzMP92yT7iHAE=;
        b=K/CCzJk19LGpavPFGv7K4gXF398mKRWpA3OvCLwPcCKwLyMwPEj2X7MeWwalr246eg
         Vn2k5/pmkkil/u28o18Th9uK1f8h1lefBaTNQAHkRwVPOxPU/h1AzZw+hZz6HHx1RTCS
         GJ2FXrRXI9tFyEdceRSVuID+24QG4j7pJ5ir2gHrgIYRePp1GzSlHl0gVLbCjGvWI0T/
         vWjwcFLxXORAvrxwmGOh6ju/3iWvkLnqEFE0mp3ZaWBiFnIxH9tOqh7x/IXtZBln07yb
         XsmWh1uZl7F58CK4cPmr8i6dbUfQuR6tKoJOgZfgV9Wfv9aFtR7cCobGTE8itKYdyopg
         5UDQ==
X-Gm-Message-State: APjAAAVFTPJRLpgPhkS6MxWaQaA97zaKl3xAxZVzo/rIEokTmqJQE1Jf
        8iLooXLS9uXfNX8vD7iYD7TqRw==
X-Google-Smtp-Source: APXvYqwePhEgOkvM/EIQNB+HOs5OjzPgzhV4uhXr5jSWIDSHJI7kwYeIriKLGeciYkhfL7O+/YNc2w==
X-Received: by 2002:adf:ea48:: with SMTP id j8mr40049378wrn.363.1582147665137;
        Wed, 19 Feb 2020 13:27:45 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id f1sm1356611wro.85.2020.02.19.13.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 13:27:44 -0800 (PST)
Subject: Re: [PATCH] cfg80211: Pass lockdep expression to RCU lists
To:     Johannes Berg <johannes@sipsolutions.net>,
        Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20200219091102.10709-1-frextrite@gmail.com>
 <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <407d6295-6990-4ef6-7d36-e08a942607c8@broadcom.com>
Date:   Wed, 19 Feb 2020 22:27:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/2020 10:13 AM, Johannes Berg wrote:
> On Wed, 2020-02-19 at 14:41 +0530, Amol Grover wrote:
>>   
>> -	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
>> -
>> -	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
>> +	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list,
>> +				lockdep_rtnl_is_held()) {
> 
> Huh, I didn't even know you _could_ do that :)

Me neither ;-). Above you are removing the WARN_ON_ONCE() entirely. 
Would it not be good to keep the WARN_ON_ONCE() with only the 
!rcu_read_lock_held() check.

Regards,
Arend
