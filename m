Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04A24AD034
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346789AbiBHENP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346775AbiBHENO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:13:14 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DE2C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:13:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso1400059pjm.4
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UmyIY7GPikpTtfOdUuQRwYAu+VYwPa6FYfTuBuonGBQ=;
        b=HqZ2KaBJidMF/UYapq5IKFh6V/IC9yVpjVjjIhTc3uH/E+ZGOXiSq7yZXHZS3fpqLU
         P7oRCdHeVIQbmasJGso3vxc//ilczVlLcesM/26TxieznUW6fRypFU4f+PYbm1cW7/HF
         RH64mwRT7rU09U4w94LUSUkrAvUz7WpRbyxGer0Y/apsRTk2uUfxMVQmz8g+P5koolwd
         MEMJ8EaTsegFhZe5Moe0N3sijjw/ECL3pS9CGY59AqINFVqISQKK8arX+YTgzJmhYPzr
         WifYD3DTrs+IHuKXpEU5gDnOaroacpy7mhdiAeRhSyOsBhUxTj21MgJjj8sHUSFBj2V3
         zT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UmyIY7GPikpTtfOdUuQRwYAu+VYwPa6FYfTuBuonGBQ=;
        b=itEPfJpaxmwqSykdWNwrFQCX24s1g8AdjdA7TA+MwM2DXl6+32J7zrKE5O9zHVLonj
         v13q7ca3iZlNo/cUiNV2ImJga1AYrkZ60zbqO8f+7TAXhLL6mmAbRgc4Qq7YfpJ8wSfR
         NIKHCMLzIOJkurItROeY+lgE0KOmVwk4pKIGO4yrGi7kelCbfEMgU/8RbGkQJ54XtGVc
         9EfqTWlpf7bwm3y2QHz8xTdvuFIKTY8X98rxA8kLEh1HSTIuDUQC1aeor65Ys0ouWsvm
         8M2xClIB15ip8cXzhbeqWoJncHsqSZW070EOl+vLrgtiGKmdOeUGVUTJsc1jmvPwEGu8
         t2+A==
X-Gm-Message-State: AOAM531qzHPVNL3JtpoMzkzhIuddqtrCxf0RjdXO0H49EArAR/2CUAE0
        eu8cDr08J968NhSnGRG3bmA=
X-Google-Smtp-Source: ABdhPJxdhH2fbKjfydfJbZYkA8DrcaOh9TAmDK51W6mcdZQy7PLbrCVbpb/JSY0h5xfIPKLLV2kxiA==
X-Received: by 2002:a17:902:d484:: with SMTP id c4mr2820084plg.106.1644293592653;
        Mon, 07 Feb 2022 20:13:12 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id c26sm9452650pgb.53.2022.02.07.20.13.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:13:12 -0800 (PST)
Message-ID: <cd19f446-662c-2210-5e4c-817a5025fad1@gmail.com>
Date:   Mon, 7 Feb 2022 20:13:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 04/11] nexthop: change nexthop_net_exit() to
 nexthop_net_exit_batch()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-5-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-5-eric.dumazet@gmail.com>
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
> cleanup_net() is competing with other rtnl users.
> 
> nexthop_net_exit() seems a good candidate for exit_batch(),
> as this gives chance for cleanup_net() to progress much faster,
> holding rtnl a bit longer.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv4/nexthop.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


