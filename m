Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7485A65DB39
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjADRZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbjADRZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:25:31 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8256DA8
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:25:29 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id ay40so26193553wmb.2
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 09:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYTqlTMa7OaKM8EnlV1GHijz+59dud21LTQYnBqbZnc=;
        b=YU7vK89i2Ljn9iGmYPQDwQs481um/HhmvAnsfCjEIbRG2K3/oC/1+B9/2w7vzF94y2
         uqcM4Pg+Me6ELu7M+e/eA5RRg+gCiBhhMAo3l4QAUnDw9B3hxFa0tGFXpkSKhSVzWq3v
         YQgifUUtwn+dypcLdLbIWCf60xNIIv0apw0rBfzRdVl7OnB/SXKGAoNUWhXD0W340MHL
         vDWrNygG8GQ6WEf5rurC7xSneQhzHg8EEH8Oxafw3QqNYk/zL5dcYpvjsJT+ZqN3IWy5
         M0l1hi6N0Eo/Wj72JWa13gBuk9OhVYPWZ3u5UAz2kfSXCLjoWhO1jZMI2xRbdoB1ZVCG
         xS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYTqlTMa7OaKM8EnlV1GHijz+59dud21LTQYnBqbZnc=;
        b=LRnmabLTL2dXTmYVjJw1MVRlLfDbIiIA/VPcQdJw8nsS8kqFJb1SPMKjf0weQii3QU
         ZrvpVZX/+VzPqDutXKX/mXRqEwGQdARvNK2K0VD+GXVHCMgJ0z30Mh6hFjv6VpiuTY93
         zkTtliHWu8B5uaxxlkdVqXkxkBO44SoD3UDnE/jYiqjLvUixR2GP4++077NwI9k1dk0p
         8csUAEfHSqZVasGRkDDaJ8RwrAq72w48zWE75TnQ4eJr988bqNNPGa3Kaj1OEStCbH3H
         p2ryBK/xRwC0Qf548dQrS87/Ye3BKfXwA/7Hn4DFmyNQQb7ywpvn4rOUldGI/OCvyfzM
         yHyg==
X-Gm-Message-State: AFqh2kp3vH9rOgwr/+a7ILtQNKREwvkWaRb/KWc0g6Dk/ala1gr56Lqz
        qwxn2iygl9y5gQdMt/rRXQwc2w==
X-Google-Smtp-Source: AMrXdXuCGFJHUUrd+rmGKVwjXMV6r9kpTOtodeQgwrSZpPncEjJKDtvMcPetHqw8OY7422kJjfZN6g==
X-Received: by 2002:a05:600c:42d5:b0:3d6:e790:c9a0 with SMTP id j21-20020a05600c42d500b003d6e790c9a0mr41888935wme.10.1672853128194;
        Wed, 04 Jan 2023 09:25:28 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c444900b003d997e5e679sm32725013wmn.14.2023.01.04.09.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:25:27 -0800 (PST)
Date:   Wed, 4 Jan 2023 18:25:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com, sjur.brandeland@stericsson.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] caif: fix memory leak in cfctrl_linkup_request()
Message-ID: <Y7W2hlf5+rhc93Uy@nanopsycho>
References: <20230104065146.1153009-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104065146.1153009-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 07:51:46AM CET, shaozhengchao@huawei.com wrote:
>When linktype is unknown or kzalloc failed in cfctrl_linkup_request(),
>pkt is not released. Add release process to error path.
>
>Fixes: b482cd2053e3 ("net-caif: add CAIF core protocol stack")
>Fixes: 8d545c8f958f ("caif: Disconnect without waiting for response")
>Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
