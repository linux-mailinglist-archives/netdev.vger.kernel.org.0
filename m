Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1592252898
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 09:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHZHsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 03:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgHZHr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 03:47:59 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAE2C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 00:47:58 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so169332wmb.4
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 00:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A7vR2LD4lvtbA3/ZJYKkFyETwCKd8pN+h2F64pD/NX4=;
        b=XOqPh+NgKql/Mv2a2cBkxxMoMmFiEkRHXN1lfg159DrVZZxU95KL+M5R6CtM1Nhlix
         HqGzjkEp4uaf+0Os0jYiFL4m/16PmHUTbTxfic5XjadZjA5xSRkAwDnZDkejGPIF1jVd
         0OqhraIR4FDjgR3CBj/rn5BN7c9ggmP42K/wPsn2TIpN4vx55x/13rJoABvY7sV1XQr0
         G7c6uvb3pqpiMrUOz+WiF2wt+yGCqt3gRbObzvUXTZXuexN7wArj50jCGv50huW+CJWk
         KNlPezxHCgaZOU8aUAc++WkqZhf9FP/fqKDr05aPeoWcguHMi14nXtQ/+19e4GD6Mkbt
         T4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=A7vR2LD4lvtbA3/ZJYKkFyETwCKd8pN+h2F64pD/NX4=;
        b=YiHrBZNiMNSgoiKzcQvkm7iWTjn4d83OdXdGM4t59jvLow2SkJyNZ35wPhUgObJQuN
         6rUSM6h9yYCHJKDLn4NJd8ujkrTifmHht2brbMUL/RkRrxjNkOREjwxgyIwtdfwr0PNl
         yPkqm6VDnbisORR4KErHNnUC0aPlr6bsIq7sjv967LYfphYmBh+H9o3w4EQoyx343zR+
         EASvZmj1KqDuntZE48Sr338xAiTQnALesh/JT1xOaT8TcmuMu4qiBB+Pgn5tzgy3QRVL
         ZLeKL5VfqmUZKYtceTKH5zkKk8Gg28u8xNtUawqLGimGS6jUJXCtRrZ8kUUYWVXKnVNB
         AvWw==
X-Gm-Message-State: AOAM5322gZg/ljbdQA6/juaFILebG6wqehfyA2eaImSUNxJPQW0yXcY4
        a59e4DCnifhl6wHEHgTMztGtmw==
X-Google-Smtp-Source: ABdhPJyeSS3dMl9hAnA02SlmnrDf9cvFg175LneIQbQBmBWImTeppF1RJJxaJwZDRm3ddlq6gt7RdA==
X-Received: by 2002:a05:600c:21cd:: with SMTP id x13mr6038791wmj.155.1598428076245;
        Wed, 26 Aug 2020 00:47:56 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:304d:64e9:99ee:68e4? ([2a01:e0a:410:bb00:304d:64e9:99ee:68e4])
        by smtp.gmail.com with ESMTPSA id u6sm3320011wrn.95.2020.08.26.00.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 00:47:55 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2] gtp: add notification mechanism
To:     Harald Welte <laforge@gnumonks.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        Gabriel Ganne <gabriel.ganne@6wind.com>
References: <20200825143556.23766-1-nicolas.dichtel@6wind.com>
 <20200825155715.24006-1-nicolas.dichtel@6wind.com>
 <20200825170109.GH3822842@nataraja>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <bd834ad7-b06e-69f0-40a6-5f4a21a1eba2@6wind.com>
Date:   Wed, 26 Aug 2020 09:47:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825170109.GH3822842@nataraja>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/08/2020 à 19:01, Harald Welte a écrit :
> Hi Nicolas,
> 
> thanks a lot for your patch.
> 
> On Tue, Aug 25, 2020 at 05:57:15PM +0200, Nicolas Dichtel wrote:
>> Like all other network functions, let's notify gtp context on creation and
>> deletion.
> 
> While this may be in-line with typical kernel tunnel device practises, I am not
> convinced it is the right way to go for GTP.
> 
> Contrary to other tunneling mechansims, GTP doesn't have a 1:1 rlationship between
> tunnels and netdev's.  You can easily have tens of thousands - or even many more -
> PDP contexts (at least one per subscriber) within one "gtp0" netdev.  Also, the state
> is highly volatile.  Every time a subscriber registers/deregisters, goes in or out of
> coverage, in or out of airplane mode, etc. those PDP contexts go up and down.
> 
> Sending (unsolicited) notifications about all of those seems quite heavyweight to me.
There is no 'unsolicited' notifications with this patch. Notifications are sent
only if a userspace application has subscribed to the gtp mcast group.
ip routes or conntrack entries are notified in the same way and there could a
lot of them also (more than 100k conntrack entries for example).
