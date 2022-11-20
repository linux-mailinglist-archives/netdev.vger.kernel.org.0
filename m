Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3156315DE
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 20:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKTTek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 14:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTTej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 14:34:39 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831F1B9E3
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 11:34:35 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id h206so7307586iof.10
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 11:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LuePv/pavw21XE4iMWsDDj/UT/RcPgcTxx/EYf0wgNo=;
        b=2LbDvZeCzMQf+P5ITKvzG/alvHoENlcZxJVBWppphQyviNbMAdEiOHQfmQQ2q7e7wn
         bXIfhEGsiPzZCowNBx6qzbX4gEcflH4syAqTyKZ9TDoN7Z6txYI6rBPyTE68ZMIDgHrp
         /SyacBCj7x6D6rUOPRdDhaGz5rlUMAr4C23U9YLQ5lNnBbAqOrvwlpHo2uUBdAkoytbI
         GhaEAW3NBv7OEKp8NoVm44vb6mWN+H9NlXU/V94xHVEFcOo7nTspqhf/xEfgn9wOnJ0y
         wbIKP8VCzNXA6S7bY+gNykOt5B+P1sJ7Is6FAnYl1RAG5bLEmREi6zS7Yr8D7P+n4i7O
         LC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LuePv/pavw21XE4iMWsDDj/UT/RcPgcTxx/EYf0wgNo=;
        b=uOHjV6OTVEo6/a9GjXHyEG1A1wVOFgglD3o6Rm4OoaXLiyLFFWwgnW+nzZALVJh7oS
         7s/c1XFMhaL053AjNDnmGA6GjHyCp4cswXAAnTA9gemq/CYvHxpCFBhkHUnRIlgFrYuW
         SU03X9d0QbsbS7Ny5Y8Ps4wxqNPJgPUCJDyjsOn0C8l+UGLKgaxKf+SYGW45FzrCbYq+
         d5UDAnrz18AQvt6N7XQ1JBonI7yeD8XGqMkAv3fyFTBc0TUhXM6CJ19FQy4ARF3zDb3y
         TFSAuCnIAXxxJ/s59sKe/1EN3ce+u+sjE3Bp+i7OXT3CPFMs5vQwBB4ATqLnoHzvQoWK
         S7CA==
X-Gm-Message-State: ANoB5pnJ8smZN9If/Uj28DWtnIDVVYVFZdsdbRjQxBl+inUUHkPUWu9b
        suJrrF/IKnwdgThe8ulNhT3q+Q==
X-Google-Smtp-Source: AA0mqf5YQQ2Un68mfLlzW+f6DFLgFdW8JJwAOoWq25x3jVdIoMd/Qg7KkHokf94fApfGWK4RFvhyeQ==
X-Received: by 2002:a02:5d45:0:b0:375:da4e:ae77 with SMTP id w66-20020a025d45000000b00375da4eae77mr6980172jaa.303.1668972874997;
        Sun, 20 Nov 2022 11:34:34 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x13-20020a026f0d000000b0037cb59b5c28sm860100jab.52.2022.11.20.11.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Nov 2022 11:34:34 -0800 (PST)
Message-ID: <fead96f7-dfc4-9ffc-c665-7b2dc870d69f@kernel.dk>
Date:   Sun, 20 Nov 2022 12:34:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC PATCH v4 0/4] liburing: add api for napi busy poll
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, ammarfaizi2@gnuweeb.org
References: <20221119041149.152899-1-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221119041149.152899-1-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/22 9:11 PM, Stefan Roesch wrote:
> This adds two new api's to set/clear the napi busy poll settings. The two
> new functions are called:
> - io_uring_register_napi
> - io_uring_unregister_napi
> 
> The patch series also contains the documentation for the two new functions
> and two example programs. The client program is called napi-busy-poll-client
> and the server program napi-busy-poll-server. The client measures the
> roundtrip times of requests.
> 
> There is also a kernel patch "io-uring: support napi busy poll" to enable
> this feature on the kernel side.

Did you post the kernel side, because I don't see it? That's the most
important one to get sorted first.

-- 
Jens Axboe


