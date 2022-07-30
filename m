Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74789585B68
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 19:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiG3R3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 13:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiG3R3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 13:29:42 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7049617598;
        Sat, 30 Jul 2022 10:29:41 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z16so9254157wrh.12;
        Sat, 30 Jul 2022 10:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jXNl2nAbqMTGsUENmWvJuMRNyD8yYg6etmCEbWy+v6M=;
        b=gcFZsKVJXC3IcY1kslaV3C6NiufA2f/Tv/GDJIsowX8kCCNXfHM0h9957lKOuhNDY1
         lSqA0zoqBYCscFugaCm6XyxRlGOvBOrybBFFZZMMAW46UcJKWFbCkk24DHEZhYYNl1lL
         fYljWQzhvNpOQk+zOYu7bQ27iTr1wzZfDW6gRMK3/9g86Ob8cKWAmY0ueXhuvBZoz50l
         Y5U5zFQrryN8UbPEhTORaRNVOJuHPQApAz+DVjIdWF6lWCVsMiGBWcsDSBOt64TWwuGf
         rEoyBPmubFYc8isQGH5aCYNiiy0Vhyu5gS1lXZ23AZS7wvKoLn4qRpVl2V8PoDTlkwSe
         7cbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jXNl2nAbqMTGsUENmWvJuMRNyD8yYg6etmCEbWy+v6M=;
        b=M59DlZEEh+HoKZdPtyjEy4pGJmdFccxnGOJuJ4aZxt4JvpAkTN5Rv/n/lmtgpZzIiQ
         DkpQlVGcy+hmOg3C/T36HKLNymYwpkPn15PzDpLsEaQJO8jet8+nBXjAI3C3XqMw2d9z
         4lHAujYKkmReLSfItO4emiYXALNJEq93IBCsH3LtAhJ2nzy8GvSBiuhOyx9oAXMytn+r
         6DRXRfLRhVuZXSOfdft1TlulhSSgjzUpI+KAwoReKKHDpez5vNpAzhLOCpkN78UiKXiU
         HxmyoqeRAjq0z1yGbv9kbUgX8OM5ZcExYjl+dwNGtG+Dk6DQclDMEuMCIp3mveDBjWKr
         7UlA==
X-Gm-Message-State: ACgBeo2FIPxtI1w8nEUk+Lz3W1qYIJ7t55OKkrON8KiKZsmKSOQd/36Q
        VXzgxv1fHbrcWbG+oL92rQo=
X-Google-Smtp-Source: AA6agR44PKiUxmMFxKJsokauJr7GaxKtpUT0yC/DBr1QO7BMiSWk8ehv3nqC5jNWcSmX47F9fEdyQA==
X-Received: by 2002:a5d:63cb:0:b0:21e:b81d:8b0d with SMTP id c11-20020a5d63cb000000b0021eb81d8b0dmr5558142wrw.526.1659202179617;
        Sat, 30 Jul 2022 10:29:39 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d6388000000b002205b786ab3sm1516348wru.14.2022.07.30.10.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jul 2022 10:29:39 -0700 (PDT)
Message-ID: <7f1ab968-cc10-f0a7-cac8-63dd60021493@gmail.com>
Date:   Sat, 30 Jul 2022 20:29:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
Content-Language: en-US
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ben Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220728191203.4055-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2022 10:12 PM, Tariq Toukan wrote:
> Implement and expose API that sets the spread of CPUs based on distance,
> given a NUMA node.  Fallback to legacy logic that uses
> cpumask_local_spread.
> 
> This logic can be used by device drivers to prefer some remote cpus over
> others.
> 
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   include/linux/sched/topology.h |  5 ++++
>   kernel/sched/topology.c        | 49 ++++++++++++++++++++++++++++++++++
>   2 files changed, 54 insertions(+)
> 

++

Dear SCHEDULER maintainers,

V3 of my series was submitted ~12 days ago and had significant changes.
I'd appreciate your review to this patch, so we could make it to the 
upcoming kernel.

Regards,
Tariq
