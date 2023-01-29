Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4DE67FE15
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjA2KLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjA2KLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:11:53 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A0D227BE
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:11:52 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id f7so1143171edw.5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XSjzv9oX4nqKyAAaAAV6s7LVl26vtY1MqzcjjUEwoXU=;
        b=rpYLywZnaMlJmLu9mHyM5dMzeRkzlOGR3mtnEM2wXnEr2w/x7OFBE6vTHX5mq8mmjA
         Cz47b6rzEg1PM+w7yCLri9Q2sJkbq906NkgQGQlrR6TWgfdsnsfisP1309pfRM0Xmwx4
         uEYVhUP93/RQnfNzrm0Ole4HSMaPb3G5nIqMmNUpeYJJm3I9Hn3YdAMI1K8vAczrO1d2
         FgeL699BFqxbXR6maryA7gMtqSwfMSIfpF1iwQ9UaX30Bj7FYvtPca4DM6LZFuqh3jDj
         mxeGzBxK8+Sl2lHUGFpYPSwE7xC878YmG5QuN9hehgpjp/cjaUnTYTJ9tu8khtus/lFo
         Y/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XSjzv9oX4nqKyAAaAAV6s7LVl26vtY1MqzcjjUEwoXU=;
        b=ald4t5ZYTaWNGf5enngkjsODjis/t8RhbaFd685Y2tZzjSdStL0kvP7bLouad9L8tT
         1lbrjV7qlfQ2/+3F7dJqV/sx2sYBBwQC/ahYldVIOqUCkWxnod5510Oe2cFgM9o5Z2Zo
         ufqOFBoQhw4YX850SjzvG1m8pAI1/ZEYbB8xlfhYVZdJRconctgG9HZWVOQ63wMH8SPB
         q71fR1YKS2GQCPvcX06DoPlnNZPgQ/YJl8rGbCo8P4sJPWKfw2eFJ+h4bhrvfhzw3D/4
         Plz+7lhuHB70uajZtFyCwUw+Gj/uFH7bSQkzHrpauN0CvuZ5sCp/z6ay4bTgyLTBt3xb
         j/Jg==
X-Gm-Message-State: AFqh2kqVXjKZMFMageNYtgJixsWTpvg9wlazdmClAG11YOKByU4atDrr
        fv7l7fGcQWaaFZBDe0OI09gBVQ==
X-Google-Smtp-Source: AMrXdXtGi7F7vkjwjzivED/4lcZNYtieF9vMDZyzU3iQM2/WoswJGnj2imIdadSNo1M3bSqTTL1vfw==
X-Received: by 2002:a05:6402:2419:b0:49d:2a42:b8c8 with SMTP id t25-20020a056402241900b0049d2a42b8c8mr52539933eda.26.1674987110665;
        Sun, 29 Jan 2023 02:11:50 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id h16-20020a50ed90000000b0049ef04ad502sm5070333edr.40.2023.01.29.02.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:11:50 -0800 (PST)
Message-ID: <dc268a07-7b85-6483-da2b-edc5a8f5f3b8@blackwall.org>
Date:   Sun, 29 Jan 2023 12:11:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 15/16] selftests: forwarding: lib: Add helpers to
 build IGMP/MLD leave packets
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <ade8275e8b812248effbfe5249d0116763340b3d.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ade8275e8b812248effbfe5249d0116763340b3d.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> The testsuite that checks for mcast_max_groups functionality will need to
> wipe the added groups as well. Add helpers to build an IGMP or MLD packets
> announcing that host is leaving a given group.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 50 +++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


