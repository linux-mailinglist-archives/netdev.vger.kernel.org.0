Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE36209E6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiKHHPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiKHHPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:15:02 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3030712634;
        Mon,  7 Nov 2022 23:15:01 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 8868E804D1;
        Tue,  8 Nov 2022 07:14:58 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667891700;
        bh=XCWz6ScmoIObKuRId785vIH8+G9yaE9O8IRbUT0edwM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tG0wKmr24hD/A6Kf5NjxnSW7rbmUBchYFUbCOPBd9KLArSbAwyPYRUvQraBT2Vck3
         qCiLqe/0pPJrTsN0uF6LepmfHai4T9HbFAXp2y4ZZrJ3CIAT7vU24nsmhaMWilXgoe
         yqKR3vz9nlse7/umllcDwu5xqEsPyp6JhXMwj1HYADTj4ETak/D+A2rdpyNVx2FAvk
         Ys1XE299CZWOJufcTW6ZEk6H5eAWo7fMicmOVRKWJcE0rBErqgLSeZO3RBQ/F6bFxC
         eujTl9vDch31McNdq2uCpX9oxR7RjCC/mAtPnjVbWt97KKZEZHIPF6GVRWJVM/DD5J
         kqbg4aNIwMn+Q==
Message-ID: <b507be5c-1669-57ee-d16e-964e326309f9@gnuweeb.org>
Date:   Tue, 8 Nov 2022 14:14:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH v2 1/4] liburing: add api to set napi busy poll
 timeout
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221107175357.2733763-1-shr@devkernel.io>
 <20221107175357.2733763-2-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221107175357.2733763-2-shr@devkernel.io>
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

On 11/8/22 12:53 AM, Stefan Roesch wrote:
> diff --git a/src/liburing.map b/src/liburing.map
> index 06c64f8..793766e 100644
> --- a/src/liburing.map
> +++ b/src/liburing.map
> @@ -60,6 +60,8 @@ LIBURING_2.3 {
>   	global:
>   		io_uring_register_sync_cancel;
>   		io_uring_register_file_alloc_range;
> +		io_uring_register_busy_poll_timeout;
> +		io_uring_unregister_busy_poll_timeout;
>   		io_uring_enter;
>   		io_uring_enter2;
>   		io_uring_setup;
> @@ -67,3 +69,9 @@ LIBURING_2.3 {
>   		io_uring_get_events;
>   		io_uring_submit_and_get_events;
>   } LIBURING_2.2;

I don't understand this part. You add:

     io_uring_register_busy_poll_timeout
     io_uring_unregister_busy_poll_timeout

in the LIBURING_2.3 section.

What are they? I don't find their declaration and definition.

How do they differ from:

     io_uring_napi_register_busy_poll_timeout
     io_uring_napi_unregister_busy_poll_timeout

that you add in the LIBURING_2.4 section?

-- 
Ammar Faizi

