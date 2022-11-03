Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F405618AE4
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiKCVzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiKCVzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:55:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176D0220F4;
        Thu,  3 Nov 2022 14:55:31 -0700 (PDT)
Received: from [10.7.7.5] (unknown [182.253.183.90])
        by gnuweeb.org (Postfix) with ESMTPSA id 11A7280632;
        Thu,  3 Nov 2022 21:55:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667512530;
        bh=z4l09QT9BO60bLRVaCjoFY1Zg9uimCVNZFX3iak+llw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eXas09cf4A+KJGqPdh0dc7lZVusH2IXypHQ5dmp7e6gXdnr1IaeYqRZTD2mfAu48Z
         X6257Xu7QYPIJHs+beuAPDoRld73o+sI/CpsPAnRRo18SI9/aSiSmLine1NwddPpmG
         17uK4d+TWBnqXvVEA4n2dZzY2/tCna7cddx94l0j1hIHSf767wZ/YBoz/dtJnxWDRO
         4H48vk3Dw85v14dEpplQ/sutzChHNPr7moJB4y9R0Kqe4ffeOVal5zn7TLXW/aQqHq
         lGjr45tjNEZPdE3/6SKPbh6u/ZIxdgR3ONPjHFgyZ73Z1QGOaI4N5tTua2CCx6QJy4
         iige3pYUm1RGw==
Message-ID: <478e464b-0dbf-82fb-ce86-8a796019584b@gnuweeb.org>
Date:   Fri, 4 Nov 2022 04:55:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH v1 1/3] liburing: add api to set napi busy poll
 timeout
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-2-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221103204017.670757-2-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 3:40 AM, Stefan Roesch wrote:
> This adds the two functions to register and unregister the napi busy
> poll timeout:
> - io_uring_register_busy_poll_timeout
> - io_uring_unregister_busy_poll_timeout
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>
> ---
>   src/include/liburing.h          |  3 +++
>   src/include/liburing/io_uring.h |  4 ++++
>   src/register.c                  | 12 ++++++++++++
>   3 files changed, 19 insertions(+)
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 12a703f..ef2510e 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -235,6 +235,9 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
>   int io_uring_register_file_alloc_range(struct io_uring *ring,
>   					unsigned off, unsigned len);
>   
> +int io_uring_register_busy_poll_timeout(struct io_uring *ring, unsigned int to);
> +int io_uring_unregister_busy_poll_timeout(struct io_uring *ring);
> +

If you export a non inline function, you should also update the liburing.map
file.

-- 
Ammar Faizi

