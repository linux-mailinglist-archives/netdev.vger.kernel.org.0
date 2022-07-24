Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4AD57F4E1
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 14:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiGXMJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 08:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGXMJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 08:09:17 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360AC175B1;
        Sun, 24 Jul 2022 05:09:16 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u14-20020a05600c00ce00b003a323062569so4825085wmm.4;
        Sun, 24 Jul 2022 05:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TuaZlSjI8Gr3uFZtjKix4F/O72z/L1CxsKBvamkDb9g=;
        b=CIczQQVHcpEMDUwb1mJxLsQHu5bxF1+/HtkEgx98+M5WdLQDNxUccwaY44QO0VZHkl
         oDe8+ugM9HUAdQ8vdSgfMAijNDqKQScCoQMGJb+UYylC8v482tzvLHlm421BeqTdREeu
         ViDLkDKh0fNpEqQDDjBMR4tHyvWVC5Q5YCVSnAx+fNki/tvMmxU8tut0vvWAwpfHiesi
         vx/p4IUwPN0dwiuOcI4n3NCzCqnJzra+JAM9EPAcwmxT7gHZF9mzfYu8rpssZQIYr9pF
         3QnNMCnG3qap0FvpW7MgniWsUrzAS7T3JMOqkMesuv+fK5l1cZBPNf5TCKVQ6TiayHJU
         BEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TuaZlSjI8Gr3uFZtjKix4F/O72z/L1CxsKBvamkDb9g=;
        b=sdAMGrFmkDUzYJy5t22xJB51HB/mdSxtkE6PB/BudMsvSQwLPf9UTBhMWndBQCOwdI
         6fq/MzcUJBjX+p2kFjWP77FnCdRGBjTd20Wz1uat9Iq/Usta8TfDShISgN54xgCEjojJ
         HgFIDNRvs3g8SmnKRfD8sEXH9R26+jfKSmPrEYwN6Wd1fg0hmzz3u7FHiit6frkKcZ25
         D8SMXheUOPPuQqSTneN30ol8K/bq1gMB/6wLiwZuTUNGi3apiSLKtGWPGXPUPw/um8Iz
         Zv6UyF7iq1KB/3o7Vxlxv+Xxe8vIcJmRG6lWPs3S53S8JIdcj+AWGTk8qdlCAN+j6Hlr
         lL2A==
X-Gm-Message-State: AJIora/FSsfzrseKr9pW1heZCBrVggcaEhvPvIKbu5AN7zdPqo/5jvh6
        LH4l06moNpuep8hevGLkmXM=
X-Google-Smtp-Source: AGRyM1sABbJX/NfOxdyBYbEO9fabdBu0ikYoMRVKH4vkAHdYfEBZkk6/Dk9c48z/ijU8ylWsRa4FgA==
X-Received: by 2002:a05:600c:3582:b0:3a3:3b00:cb25 with SMTP id p2-20020a05600c358200b003a33b00cb25mr5374622wmq.170.1658664554661;
        Sun, 24 Jul 2022 05:09:14 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id n186-20020a1ca4c3000000b003a32438c518sm14509967wme.6.2022.07.24.05.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jul 2022 05:09:14 -0700 (PDT)
Message-ID: <09038324-65ed-8529-2f6c-671a15a8fb84@gmail.com>
Date:   Sun, 24 Jul 2022 15:09:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next V3 0/3] Introduce and use NUMA distance metrics
Content-Language: en-US
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
References: <20220719162339.23865-1-tariqt@nvidia.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220719162339.23865-1-tariqt@nvidia.com>
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



On 7/19/2022 7:23 PM, Tariq Toukan wrote:
> Hi,
> 
> Implement and expose CPU spread API based on the scheduler's
> sched_numa_find_closest().  Use it in mlx5 and enic device drivers.  This
> replaces the binary NUMA preference (local / remote) with an improved one
> that minds the actual distances, so that remote NUMAs with short distance
> are preferred over farther ones.
> 
> This has significant performance implications when using NUMA-aware
> memory allocations, improving the throughput and CPU utilization.
> 
> Regards,
> Tariq
> 
> v3:
> - Introduce the logic as a common API instead of being mlx5 specific.
> - Add implementation to enic device driver.
> - Use non-atomic version of __cpumask_clear_cpu.
> 

Comments on V2 were addressed.
Please let me now of any other comments on this V3.
