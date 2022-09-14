Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB665B85A9
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiINJzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiINJzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:55:33 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE49565CD
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:54:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id ay7-20020a05600c1e0700b003b49861bf48so1997497wmb.0
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=z8ft3PpcYLSSDlefFp41hGzqG6F7Z5xBGO/VksPPHfU=;
        b=wVp+Il2bDLqp4qnKTecRTfBWkGk78cu2cojZ0dFYNvRBFQKnbv8nuGvR+KeUen10kd
         0MaN2ZuuHekeFWopCFCnOlhmf9vQ6RvglHT6F2yDMgONcxAmpbRIpdgDOIp7XWm3xyxn
         Whg6+SLZllXgUILAmke+WD857Pm5iYzwRI38iGhNqHZgJNu3dQSAnn4rvGc/yujBIT0J
         vTvtU6bhYIW/9sh59/UscupkO8wC4d1a5F/s7z37cXM1+Qq70O0sQFbMPJCJ1jrIL6gS
         kuyv5TTNrODflxUFiPDkkDe5zRMxcWM04CjVYwePzlXJEfHI7Nw86JxIpXdn7ZlCp10O
         wFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=z8ft3PpcYLSSDlefFp41hGzqG6F7Z5xBGO/VksPPHfU=;
        b=nTUCQ9+mUTDRF4aSAEKaT1jS6FcEX6u7Z6QlzQwfKDE/Lx3wkPDuaZE3Qaxr8s8Ntu
         ln7xNNE/vvahKVtX3jNwh9KXEnnrRLQ80UYnh+TDb5FkrC6SgtDWFLtCdiSe3N/KxhEx
         c6gDJb6SyrY268ZR+eixdXWJJQeEaFNzd/ne2zWtX0w+S3ZEwbrb2rk/n1Cs+XT3YpTd
         /akGQ80PuvjiarDeBpgXO4KWlXqqeemzcZw9y7dFmCaTfWwSbNs/8AQP6DU2KAY/Dty/
         KViWsc7zhQH/H2cug6jSEtdN0k8/IgSEbqEXRV/e8kbYPJRGiBBqJ1UR3sgy/1du8h8Q
         WrEQ==
X-Gm-Message-State: ACgBeo2P4R1QEY74oZOcTVj9B0dcNpLXwT12QEGLKESARH5vB7pz1yie
        F3SPDDv1JQSnqNlZYSPtkEeqgA==
X-Google-Smtp-Source: AA6agR5ASSGBuPd4avCF2+ig0jnc3qy4SO4/AZVdoJvx89E9yNFUnZ5VaF1UbW0W8HLv4g36Sbcs6g==
X-Received: by 2002:a7b:cd91:0:b0:3a8:5262:6aa9 with SMTP id y17-20020a7bcd91000000b003a852626aa9mr2281455wmj.143.1663149286794;
        Wed, 14 Sep 2022 02:54:46 -0700 (PDT)
Received: from [172.16.38.121] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id d22-20020a1c7316000000b003b492b30822sm7221782wmb.2.2022.09.14.02.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 02:54:46 -0700 (PDT)
Message-ID: <26a1465a-3ab6-9c30-8461-788f46cdb8a2@kernel.dk>
Date:   Wed, 14 Sep 2022 03:54:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net: clear msg_get_inq in __get_compat_msghdr()
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>
References: <d06d0f7f-696c-83b4-b2d5-70b5f2730a37@I-love.SAKURA.ne.jp>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d06d0f7f-696c-83b4-b2d5-70b5f2730a37@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/22 3:51 AM, Tetsuo Handa wrote:
> syzbot is still complaining uninit-value in tcp_recvmsg(), for
> commit 1228b34c8d0ecf6d ("net: clear msg_get_inq in __sys_recvfrom() and
> __copy_msghdr_from_user()") missed that __get_compat_msghdr() is called
> instead of copy_msghdr_from_user() when MSG_CMSG_COMPAT is specified.

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


