Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEDB64EB1C
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiLPMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiLPMAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:00:45 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE9D9FD5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:00:41 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id tz12so5582942ejc.9
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ugpe2kOzYU6YxvFb8cpUEPgnHMRSp9hmOlRt7mw1q4c=;
        b=5N56PnK+/qs/BxwQib+N3sJR2IP+kq+kJZje6TEZDjOpquzHRPtovCGw5vv2aozH9D
         +on39T/P6NSKsYfcK7N9dPXuPsj8H4KUdwMWQNlntMZZQE2grxNgRnXTNs9NLCbzA1Ys
         3lLBWPlPM7UNUDz7pcAZTXq54d0+ZukCK4D/MKKxm+DTN47Fb25S70c8AYLMimr+QPX0
         fXkRh4Lj/N6Ncv3vBYlYjou6cHPMCnetESNxUp1DKe0UNDuocQcPC71HvBXoljDpY/OP
         2+TtqhU6FyCqZPIRHDKCDJEYvoipr7/jsypcv4eZMPbcxEk+wI8sT20KDjwPTrBebCJa
         v57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ugpe2kOzYU6YxvFb8cpUEPgnHMRSp9hmOlRt7mw1q4c=;
        b=slAJOi5rQlBVsnnxgYqIq4Ihna6TSHc2cpBysoul8ZeqUBrA0n/kSFFAnRbFbyZDSS
         H4KVUO9Yb+7xSbD4fsf/BhDrzqX8lRMfvNWJn8YvVc+DPn1Oyjt+nyLz4/JCYp+P7pJx
         zECVRuW41hPd8LuqQVNjx+ptCw5r2ArzoNMRnG1IIquWqqS/bkRi3724rSb2fSU5NoOo
         PfbYQi57dgAOHEwXWm2U0OeRv6s/ndlm61bVwL6mGAiUMB+6dURl+xGdos8v7MJ+PIC4
         KWu3chR4oCFwD5LI2xJpENGQjGywgRfLBIk/8UCVhhMv+yk1KrSeg0QkpytwcBNwDgRL
         0Nbg==
X-Gm-Message-State: ANoB5pmJVUAgYUmrvyLP6DKzl2UzNMZXGGkTjtLBU7wW2fZ1fe3BfUbj
        DU2kWlIDHAj/BYeCuI43AQW/sw==
X-Google-Smtp-Source: AA0mqf5dT9mEsq+bcg4X2l0Q2VIo+8D+/xY52Mb+sZXLS+zix2+/9ahFv15KI59msPAckBUGM8YHDg==
X-Received: by 2002:a17:907:c716:b0:7c0:e7a7:50b with SMTP id ty22-20020a170907c71600b007c0e7a7050bmr28003688ejc.48.1671192040412;
        Fri, 16 Dec 2022 04:00:40 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id 20-20020a170906311400b0073d81b0882asm784020ejx.7.2022.12.16.04.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 04:00:39 -0800 (PST)
Message-ID: <448243dc-fd2f-b2cc-e9d4-1db40035b84f@blackwall.org>
Date:   Fri, 16 Dec 2022 14:00:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 3/6] bridge: mdb: Add filter mode support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221215175230.1907938-1-idosch@nvidia.com>
 <20221215175230.1907938-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221215175230.1907938-4-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2022 19:52, Ido Schimmel wrote:
> Allow user space to specify the filter mode of (*, G) entries by adding
> the 'MDBE_ATTR_GROUP_MODE' attribute to the 'MDBA_SET_ENTRY_ATTRS' nest.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 27 ++++++++++++++++++++++++++-
>  man/man8/bridge.8 |  8 +++++++-
>  2 files changed, 33 insertions(+), 2 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


