Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A73677A04
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjAWLUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjAWLUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:20:08 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF1FCC3C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:20:07 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l8so8706690wms.3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dte00Cs5taQ1Qcd1343GMcHZxcEkoS8hVoN3z1iezzA=;
        b=NYA1yF1vivAGzHM1Qt5jhNUw8YNQAj6Qb6f5VtKrgZ1jInek3W+PPluVjCaSCijUsK
         CfzTEMrZg4uYFGQVfFQpYp/fuz00E7su9ifLpSu50qkCEuulS9QUSFbGCeIru6oSSVgj
         1cwDTrZCJyZH0frbd2l6ZhfbapJPvxjWVmviWib7Z61NP1O2TZsOPWUIUFs6cThYX6qA
         JuaPzelOHe2y5Z/YYxVqpFNLFvcX5SzQl77QLcoyyim8wEwgLUqsu87tJ5xo0cfn2kLO
         iL5Uje2TWGKrdoLnaG+KP2/UsKpOpJq9ucWCZ+XnSHcCO3ofhK8xSr3FNYT/f92aZgoO
         u7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dte00Cs5taQ1Qcd1343GMcHZxcEkoS8hVoN3z1iezzA=;
        b=BciNHyBeUEjH8ypmSxasOpNdNQ9AWH83GYXpJltgbpCvlmUhS7cldmexwAVqgs7bcQ
         u968jYDQFVBHxmL+4uw0BU2k818HZ8VXOp0SBfwR1yqQr9OWh/BJnl+UpdIT++gAbn4u
         X74OKz69OaAGOQkQAkqFW1Nj6hmrzk8vXxdLynjSD22vt2YlCrwC9HdsO8tu3tvx6bGF
         e2R5YgXW+16WsWgZsF8sZPocmebnq7PI/rFqSUEcNJZzRhefuoFagbh1+lJvZ+KIUK+8
         gkKVncDRJnYCFunxLCE+T85KP2Lck/XbI4ixArKvApf0/ePKrerPSdkHh+vOiaFvTtHU
         W6zg==
X-Gm-Message-State: AFqh2krH7Gv4yzryokmYO3KmsGm+gF5SzETA54yE6GZiPEAUjdZ7gitq
        btoToZvfz8QY7vnBXCUWCXQ=
X-Google-Smtp-Source: AMrXdXs7YZFxUZ7yd7pDfzATM/d0mnp1PjC8uwsLlIghjYHOchq4DKE0FDvZ9lJi99JQnU/DJLPktg==
X-Received: by 2002:a05:600c:1c9c:b0:3d3:49db:9b25 with SMTP id k28-20020a05600c1c9c00b003d349db9b25mr20473175wms.26.1674472805828;
        Mon, 23 Jan 2023 03:20:05 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id l7-20020a7bc447000000b003dafa04ecc4sm10279287wmi.6.2023.01.23.03.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 03:20:05 -0800 (PST)
Message-ID: <7a39540a-99c8-34f6-e090-9f3660b0db81@gmail.com>
Date:   Mon, 23 Jan 2023 13:20:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/2] ethtool: netlink: convert commands to common
 SET
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        piergiorgio.beruto@gmail.com, gal@nvidia.com, dnlplm@gmail.com,
        sean.anderson@seco.com, linux@rempel-privat.de, lkp@intel.com,
        bagasdotme@gmail.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com
References: <20230121054430.642280-1-kuba@kernel.org>
 <20230121054430.642280-2-kuba@kernel.org>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230121054430.642280-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/01/2023 7:44, Jakub Kicinski wrote:
> Convert all SET commands where new common code is applicable.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: piergiorgio.beruto@gmail.com
> CC: gal@nvidia.com
> CC: tariqt@nvidia.com
> CC: dnlplm@gmail.com
> CC: sean.anderson@seco.com
> CC: linux@rempel-privat.de
> CC: lkp@intel.com
> CC: bagasdotme@gmail.com
> CC: wangjie125@huawei.com
> CC: huangguangbin2@huawei.com
> ---
>   net/ethtool/channels.c  |  92 ++++++++++++++----------------------
>   net/ethtool/coalesce.c  |  93 ++++++++++++++++--------------------
>   net/ethtool/debug.c     |  71 ++++++++++++----------------
>   net/ethtool/eee.c       |  78 ++++++++++++-------------------
>   net/ethtool/fec.c       |  83 +++++++++++++--------------------
>   net/ethtool/linkinfo.c  |  81 ++++++++++++++------------------
>   net/ethtool/linkmodes.c |  91 +++++++++++++++++-------------------
>   net/ethtool/module.c    |  89 ++++++++++++++---------------------
>   net/ethtool/netlink.c   |  39 ++++++++++------
>   net/ethtool/netlink.h   |  13 ------
>   net/ethtool/plca.c      |  75 +++++++++--------------------
>   net/ethtool/privflags.c |  84 ++++++++++++++++-----------------
>   net/ethtool/pse-pd.c    |  79 ++++++++++++-------------------
>   net/ethtool/rings.c     | 101 +++++++++++++++++-----------------------
>   net/ethtool/wol.c       |  79 +++++++++++++------------------
>   15 files changed, 474 insertions(+), 674 deletions(-)
> 


Acked-by: Tariq Toukan <tariqt@nvidia.com>

