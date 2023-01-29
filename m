Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701E967FE11
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbjA2KK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2KK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:10:58 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE83227A6
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:10:55 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cw4so3240647edb.13
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YyZWoCWCuhaAegyJlnJA2n0EhH8BXV78ivTv80i7qUw=;
        b=CY12R16J+6I+jZG/tz3yrqkXZ/R0wQIgZOY+pFvr3txbAGDFftuli6eu0AA8cqi3Sz
         ThrDY7xLGZOu2qCTIQ60FCT/cyzC9IQHBUymuGI/OClE9xMNzwP1tIu4vMcqT3S8zzNb
         cU9+E/Bb8a0SouB9ndb6NQnvJjNWttkPNvH3LrUmzz05tOEkruSVlxauCOQp+3Wa/yTb
         TJ0usyImkssNaezwq4+KBi64Z5nC1r5VG0gPpc5YO51jMq24SdFVs9TG80sDb13JlFW5
         gDWgaLxVfF/XgO0Y9qZqMaTi6XepKRNB05OjU46vZgzLJ6/ekzm+V0czxVWOkyXPA4Ve
         w5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YyZWoCWCuhaAegyJlnJA2n0EhH8BXV78ivTv80i7qUw=;
        b=dEdICETu+a0j936ad8fJM9ZJcxoblqwuO6m0etPvYGmGU+/mh71qlGmroNayqdHHNo
         cx4jIkPY6g4yIr2Guuvjw8zuZPhKv+3KBcIk9wL5XibK7fP+SN1mHJCecSslaOfTJCzX
         F8n6YX9cetVIF2ayyUUtB1AwwdMClm1lKs0E7e+hzJHZxLCeyB6rMVPjJGzCqsh86mGs
         8hWORZYGPxO2H8oqrt0Pv0bmYwgyAD4olJ5hN1tyfN9qtSqfntAaagUdOTE/Cgr/L35B
         mjXOVSLFSpPsZxvLczfRDCnm0GIfZnKBDb2bBdeTMZM6/kIvjtDul+mrZFoP1yXCAvqZ
         jWqw==
X-Gm-Message-State: AO0yUKUAE7fOIeM/xGTAqWn2Sv7Acgzs5pbM/ucuOW+GpjqKGxKWUKE9
        K7fqcgeEQoyr8hz+NBMWxe/nPQ==
X-Google-Smtp-Source: AK7set+eZIMlh6EIwMlLVBYg1AWUuNLxXBcupM8m5xfZQmwVw30fcD/tds5xPBx0dtBE/e7+6LFB+w==
X-Received: by 2002:a05:6402:510d:b0:4a0:b601:4a74 with SMTP id m13-20020a056402510d00b004a0b6014a74mr20609475edd.28.1674987054288;
        Sun, 29 Jan 2023 02:10:54 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id g5-20020a056402320500b0048a31c1743asm5041607eda.25.2023.01.29.02.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:10:54 -0800 (PST)
Message-ID: <c937fe7a-7b63-9b09-7714-3a3536899007@blackwall.org>
Date:   Sun, 29 Jan 2023 12:10:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 13/16] selftests: forwarding: lib: Parameterize
 IGMPv3/MLDv2 generation
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <a2a17da9f91c3648fbcbc2890c961c9a9b70d61d.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <a2a17da9f91c3648fbcbc2890c961c9a9b70d61d.1674752051.git.petrm@nvidia.com>
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
> In order to generate IGMPv3 and MLDv2 packets on the fly, the
> functions that generate these packets need to be able to generate
> packets for different groups and different sources. Generating MLDv2
> packets further needs the source address of the packet for purposes of
> checksum calculation. Add the necessary parameters, and generate the
> payload accordingly by dispatching to helpers added in the previous
> patches.
> 
> Adjust the sole client, bridge_mdb.sh, as well.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  .../selftests/net/forwarding/bridge_mdb.sh    |  9 ++---
>  tools/testing/selftests/net/forwarding/lib.sh | 36 +++++++++++++------
>  2 files changed, 31 insertions(+), 14 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


