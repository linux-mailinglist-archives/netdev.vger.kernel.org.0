Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411A34AD012
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiBHEET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiBHEET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:04:19 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0794C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:04:18 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d187so16646524pfa.10
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rbQTUagh3Idsh0rtcwxIuYHkWrAIhx+F/El2D5w6y04=;
        b=dGt+WPcAgNsCOw4EaoHUaj3yh8ubD4p2xA3VpmoZhfgPqdh5J2tF2C/4GMRyLWyL/m
         vccLtrrD4cQSdBn87dhagBzrpcSKjsQQqittpT/cmSRyPnTJyaR6rSM9GNFM+3ghqrLj
         BF0SiYRCMBiGSO1D7t/fKFj7ja2VCdYU4RDyf7fDnuvlqXYZd8YMco/7xG2asqeS0G4C
         VigWq7WzEaDN2fiuEUUBw4BlWbeHqjTyk1uTDfJLukFV0JwKoINrftKw8iellfztP8b/
         XmAljwHS40B0rlt+anpdXmTQC+tiRtX3Xo7kRomdFm3nnJBGsQn9cl3moCcPI2RMWLTa
         H1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rbQTUagh3Idsh0rtcwxIuYHkWrAIhx+F/El2D5w6y04=;
        b=qZiuhAxSphnKkuEFJ55Jl9gvo/qhjb9z705W5+VpmPKcNHpT1H2fapEPy5NIEw3Ban
         uvW7hRBYSqBbggBz7AYAx9wbonY0e50L/QGVYBIPbmhLBJ/mFH3GMHVdCgrs3oP/doWa
         /L/wwmPsXzFuklxId51cW6JaJLGxRFAELBHxDaytSIms9YF/lXHffmaf6EmdDxvQEEMX
         PVGStqzXMigxQKMm55wGeUb6PuV8JMyo2VOmUIqtbO2uSnLLtzyo/TSbKBDmQAOV2fFm
         do88Tjb9GvWw03oTWTWEBOqvL1/OHvBBJVUnlWf7YBSmAH+neao1Ym0bdkaKgJYM0KIX
         2heg==
X-Gm-Message-State: AOAM533ANPtDKr9g6wW9PR27Jjb0fEgJI3xe+mu1sr0df1euOJwROztW
        mnmTWDFLUvdycXfLuM4NfxU=
X-Google-Smtp-Source: ABdhPJyxLD8A0728/2yeHTMB7OcUowZSPs+eZAiIBczG80pCAMsP7MMESAXx52NOaF0Jh1gXaCzNIg==
X-Received: by 2002:a05:6a00:21c9:: with SMTP id t9mr2553714pfj.48.1644293058417;
        Mon, 07 Feb 2022 20:04:18 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id t15sm9792199pgc.49.2022.02.07.20.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:04:17 -0800 (PST)
Message-ID: <e86ef784-9dd4-8649-1979-423f3c0c2062@gmail.com>
Date:   Mon, 7 Feb 2022 20:04:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 01/11] ipv6/addrconf: allocate a per netns hash
 table
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-2-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Add a per netns hash table and a dedicated spinlock,
> first step to get rid of the global inet6_addr_lst[] one.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/netns/ipv6.h |  4 ++++
>  net/ipv6/addrconf.c      | 20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


