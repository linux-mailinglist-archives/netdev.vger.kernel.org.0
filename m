Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD388E53D4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfJYSh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:37:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45483 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfJYSh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:37:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id c7so959122pfo.12
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=BLLCwHMQ5We6Q/bLQkcproI1u8+Pax/YlVnfJU7kb/0=;
        b=NTbeSXJKFZ9n2M12mw8Q8CAINCk/xj33cVAxM8CZ72d4Uq9w81oO3chxLVZfemxwQ8
         1vu/WcxFJwigCiDoZJ0hyLAOuLjXmP3WYh4gcnAkq6xHzGviH6A/bqM7TmLvZQv5Gzuv
         WrMPRAr+hht9lfk7UJOvx8B6vmiduFVIUsj5apzJ8ILZlxEvm2uWcO6O20RgNkoEdGwr
         E5DM/ZzT26nvspjPloqKmGbYs23/LUIKvsUDei61TAqVT7HJixD84BbFomlBYDF2TjJ3
         CaiAvVCBUmAqvtt8IjPslJiZMOdOW5aKpEcfKfrHp5f7ucA0I+A0AXeBO6iqdXEDPiHp
         QwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=BLLCwHMQ5We6Q/bLQkcproI1u8+Pax/YlVnfJU7kb/0=;
        b=rT6spMk97T2WdWVnr6jfotoub0GwcE94x4ILaY90aUdkIYLn0gLQIPThbASOGu8f/p
         bDd+aYKXb0LmtknB+xcVHeghdijo9nSI/nnCrGDC2NZrhk8iP9uNsCqeR5KQHGiv6dsR
         qE82utHd/+LsBYrUEWDrpbXWEIdhEhJlMotBvt+a7eCDsEPtjAs/LUz2mH6OGS5yPJmp
         OGG9ZzNM7uIjWxo7zAE5onSpK27sh2ekUU+TEJUQSEB987NgTX0zTVc95JvO7OCD1gwG
         HAVTDWgkoeopNH//fVKHMRRub45bDsimy61ELY1msOtnx238o0EIYgoIENCxDN7+epHm
         b48Q==
X-Gm-Message-State: APjAAAVi+VyJBYNr2gfhTq3TwKWAfp3BV+A6tX7pVYqQhY13yUa/gnIP
        eGeiywjblGmRraw/YpneY8o=
X-Google-Smtp-Source: APXvYqwo8PIqKG9BL3tqOynfvIlRAyMXw3yu7FgEyYOhrt6xt1aC3rB7puIEt1GUY5b510gnuxWABA==
X-Received: by 2002:a17:90a:b946:: with SMTP id f6mr5728064pjw.69.1572028646608;
        Fri, 25 Oct 2019 11:37:26 -0700 (PDT)
Received: from [172.20.54.239] ([2620:10d:c090:200::1:4b93])
        by smtp.gmail.com with ESMTPSA id 26sm2993631pjg.21.2019.10.25.11.37.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 11:37:24 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Saeed Mahameed" <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-nex V2 2/3] page_pool: Don't recycle non-reusable
 pages
Date:   Fri, 25 Oct 2019 11:37:23 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <D051105A-B206-46E4-BD3C-BE3FE3D7BB9F@gmail.com>
In-Reply-To: <20191025153353.606e4b0d@carbon>
References: <20191023193632.26917-1-saeedm@mellanox.com>
 <20191023193632.26917-3-saeedm@mellanox.com> <20191025153353.606e4b0d@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Oct 2019, at 6:33, Jesper Dangaard Brouer wrote:

> On Wed, 23 Oct 2019 19:37:00 +0000
> Saeed Mahameed <saeedm@mellanox.com> wrote:
>
>> @@ -292,7 +303,8 @@ void __page_pool_put_page(struct page_pool *pool,
>>  	 *
>>  	 * refcnt == 1 means page_pool owns page, and can recycle it.
>>  	 */
>> -	if (likely(page_ref_count(page) == 1)) {
>> +	if (likely(page_ref_count(page) == 1 &&
>> +		   pool_page_reusable(pool, page))) {
>
> I'm afraid that we are slowly chipping away the performance benefit
> with these incremental changes, adding more checks. We have an extreme
> performance use-case with XDP_DROP, where we want drivers to use this
> code path to hit __page_pool_recycle_direct(), that is a simple array
> update (protected under NAPI) into pool->alloc.cache[].

The checks have to be paid for somewhere.  mlx4, mlx5, i40e, igb, etc
already do these in determining whether to recycle a page or not.  The
pfmemalloc check can't be moved into the flush path.  I'd rather have
a common point where this is performed, moving it out of each driver.
-- 
Jonathan
