Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68E76AE4A0
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCGP10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCGP1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:27:08 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0F91BEF
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 07:25:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l1so13551778pjt.2
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 07:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678202700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EXUdt2f8St/8i9PlevprO/yPreFB1GGsVjZEDQ4VuFw=;
        b=2r0N4IpCKhHpnLwxvMAbB2IHwA9VeS4lk60DKy8VCEdFCOng1i35hfql+JaHPa5Rbf
         0muR4yZsv9Z4Dc09WI7iHufxZk0umQgoAnd0hBVOaOa1Tb4CuykP+D3WxgESB85Yi3ka
         0HUHbTVDi/Ggc+HbpOs+eRbZJbmowm5RC+JhwRp8PE4q7Yt3BpL0SW2ctvLGB5PmskSN
         DhVjb0zF70nh8zOiDCbrP3ViOQ2loCNpObQViniDKQ01zjUXYAhwzZvEb/kgtcKvLWTu
         l9SdU8tNTLIPmWsVrYf/KYH6CAvOzpnKKpsc6rx5dtSIuRTo8QLga5wmnBhiUjhpKH/b
         sCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678202700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EXUdt2f8St/8i9PlevprO/yPreFB1GGsVjZEDQ4VuFw=;
        b=Y3RBuGrdMH2c8Y32sxFuywqT2lk5Q252AsHJnStRJzLMkcxIzB/NHyv4f1f7jK7i5D
         cV8uVESv4Ge0S143YHPB/WlEY4BCPO+RPJlZ7UmcKP6r0GHISK9O13aspKHyiCVp5467
         glT6NLZNiPyDsWj3iD5Nvt/SzhFd0sms+W9qkJf0F3c+Z/WBU8J1JmWCGL/m8cN4Uwtq
         z738uMLNO4jjirmiH4zetVi+4AdPiPPBYiTIOMqYhlx5Lh/Gv1MtWAPsVUgHyjaHA3FJ
         /SffKgW2NXYj6go2UpgaBPGJ9aRcS04siXqbjJiYYgoUM1rU/is9/oYpXIKgnTn3IP6t
         H6Ww==
X-Gm-Message-State: AO0yUKU9dyhM+bm17lt5ivflrtw+YU1AHMPsROkAoRV1Q4CeddmV3a8N
        LmBqwNtaCdGU3KBEBOJFhm8MGw==
X-Google-Smtp-Source: AK7set8guo/bS98UkXhyentGJiEUfcZeiy8tfTbEFuNThINYuWNfB0P2aEzTLf3tT8+jZxpcRzZgVg==
X-Received: by 2002:a17:902:d483:b0:19a:f556:e386 with SMTP id c3-20020a170902d48300b0019af556e386mr16619433plg.0.1678202700567;
        Tue, 07 Mar 2023 07:25:00 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id kq14-20020a170903284e00b0019cf747253csm8581257plb.87.2023.03.07.07.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 07:25:00 -0800 (PST)
Message-ID: <bad4c222-de52-625e-e73d-5997a7553a57@kernel.dk>
Date:   Tue, 7 Mar 2023 08:24:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: reclaim skb->scm_io_uring bit
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20230307145959.750210-1-edumazet@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230307145959.750210-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 7:59 AM, Eric Dumazet wrote:
> Commit 0091bfc81741 ("io_uring/af_unix: defer registered
> files gc to io_uring release") added one bit to struct sk_buff.
> 
> This structure is critical for networking, and we try very hard
> to not add bloat on it, unless absolutely required.

Understandable.

> For instance, we can use a specific destructor as a wrapper
> around unix_destruct_scm(), to identify skbs that unix_gc()
> has to special case.

Looks fine to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


