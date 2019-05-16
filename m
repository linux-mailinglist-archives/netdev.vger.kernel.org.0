Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EC01FF7D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 08:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfEPG0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 02:26:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32946 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfEPG0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 02:26:30 -0400
Received: by mail-lj1-f195.google.com with SMTP id w1so2005410ljw.0;
        Wed, 15 May 2019 23:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=wopevyOfrVcNgrs2OlRoJkSg1GME6xrc5gzsawzKoi4=;
        b=u4Bs2ZR9I5NiC3tUkHwro0NaNYQTer2meRxQ1f7i3QntTO6Uxe3PIsdl0hPJq7/tvI
         M4B9EalKq9eNCu7yK11e4OMIUCijrug2sTK9bWnm8qOF/eCn5OhtdHlsAMFOwW1ALlSO
         vy3GmdKhcLgEUeOCutt1snzGpRtLBTlvCCh+ERJkgFyanEBzuWG0auDZiJH+YlcvDlwq
         GOE7+0VY4aJI1hBAApc60LM33uCYXFd5Qj3zvkaT86rgZqXLyoUxqdioV6hO+vZGn4mq
         WrlCcXJa1Z7O/yDs4zOvrqJlQfMpfNhTHv6Wk1Qnm2xJmTNOtUrlBa9PX6u4x74aA0KF
         dlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wopevyOfrVcNgrs2OlRoJkSg1GME6xrc5gzsawzKoi4=;
        b=KZ8YWAzkXAWPLOh0djEKeedZql/C2T+hs1NOYVmr5c7j6zYDruiEHdlfjAwh1Z3am8
         rH68O7Gscn+4Jn2ZDDaP+PR4Pv+r974Fji0vRgRUrNToRLgBS+VFbU5Wkiy7Njr9cd0u
         AQ8nDp7DRLg25MCxxgcbYHqBQJ1sLQaQZcidJ9JJZ2ZA+JMsi2+fEk4W1N8afnednyvx
         NByx1GxJ57HZZ4wZl0DKyf1qOLkayDmazZGPi7otAQ8wCqWSrNwB2ncs402VO8pLK2F6
         UMxXpJN2VWdT3byFHZynfM3f92agjBBXNbRMbPM93maYppa8APt/uPoIjgGozIqDcmr3
         OmVw==
X-Gm-Message-State: APjAAAUKqPARZAFQQEoqUjKnvB7UTNmNvlt2hDSbz3YyItgFEtkHa5bv
        jUFTLeSiO2+TSFxTliPH3ug=
X-Google-Smtp-Source: APXvYqxmhwMESExMgBx/ncLaEXSu/aignZEYzcIQ7Rj5rRdJ0TG1Bikq8bj5GIrD/1hxKwfDs98pQQ==
X-Received: by 2002:a05:651c:150:: with SMTP id c16mr22906662ljd.65.1557987987979;
        Wed, 15 May 2019 23:26:27 -0700 (PDT)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id j10sm882748lfc.45.2019.05.15.23.26.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 23:26:27 -0700 (PDT)
Subject: Re: [Xen-devel] [PATCH] xen/netfront: Remove unneeded .resume
 callback
To:     Anchal Agarwal <anchalag@amzn.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>
Cc:     Anchal Agarwal <anchalag@amazon.com>,
        Munehisa Kamata <kamatam@amazon.com>,
        Julien Grall <julien.grall@arm.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
        Artem Mygaiev <Artem_Mygaiev@epam.com>
References: <6205819a-af39-8cd8-db87-f3fe047ff064@gmail.com>
 <ecc825e6-89d3-bbd5-5243-5cc66fa93045@oracle.com>
 <b55d4f90-100c-7a2a-9651-c99c06953465@gmail.com>
 <09afcdca-258f-e5ca-5c31-b7fd079eb213@oracle.com>
 <3e868e7a-4872-e8ab-fd2c-90917ad6d593@arm.com>
 <d709d185-5345-c463-3fd1-e711f954e58a@gmail.com>
 <435369ba-ad3b-1d3a-c2f4-babe8bb6189c@amazon.com>
 <fde362d0-dd48-9c9a-e71a-8fb158909551@epam.com>
 <20190325173011.GA20277@kaos-source-ops-60001.pdx1.amazon.com>
 <f5e824de-da57-9574-3813-2668f2932a6e@gmail.com>
 <20190328231928.GA5172@kaos-source-ops-60001.pdx1.amazon.com>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <48fedb13-5af2-e7cf-d182-0f2bb385dda2@gmail.com>
Date:   Thu, 16 May 2019 09:26:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190328231928.GA5172@kaos-source-ops-60001.pdx1.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Anchal!

On 3/29/19 1:19 AM, Anchal Agarwal wrote:
[snip]
>>>> Great, could you please let us know what is the progress and further plans
>>>> on that, so we do not work on the same code and can coordinate our
>>>> efforts somehow? Anchal, could you please shed some light on this?
>>> Looks like my previous email did not make it to mailing list. May be some issues with my
>>> email server settings. Giving it another shot.
>>> Yes, I am working on those patches and plan to re-post them in an effort to upstream.
>> This is really great, looking forward to it: any date in your mind
>> when this can happen?
> Not a specific date but may be in few weeks. I am currently swamped at work.
>
Any progress on this?

Thank you,
Oleksandr
