Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267F9680DD2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbjA3Mge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbjA3Mgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:36:32 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6DAAD37
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 04:36:29 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id o66so9898592oia.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 04:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CSm3NJKWXyKbM+1myRdJ1gka7k4/gTO3OMz0aOMUekw=;
        b=SYcZ4busPhVuyPUJe315cbX1ZdK/10JBN3rpbdiF7WZ/L98TFctudEnczKLXiTz/5g
         bQZkHvKvMmFqHxOxGY79dqUYUNM++FhK3hV+LtApSdS7g1pxxB3zRXoE54wmA1rBomiE
         WQDRedXmDYCl+o/mpUQFa1KElp4ZL3zgsZstz85/8nZHaPdwpBILN3WdIhzUSL9g0Qpx
         eZL4zTjLebt+/ue1bKJUoPD91vbfYURVthWofEQTAgtBWHjPItWdEEyWnUJvwrZNcTte
         qAFhm+bOK2bU00XLpe573g72y1EYTs6DzFD1gBG1CvU+em6COb5S7cO2fRdm9jn57lx4
         LAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSm3NJKWXyKbM+1myRdJ1gka7k4/gTO3OMz0aOMUekw=;
        b=rb6VkLEYlsJWTkLNnSNO8F0eYwPC1Cefw/4rMxA2M902Agiu8GI89uNK1qnPW4DKdD
         BFsIrdcYrZqIIwXLKHwdzuJAO0iT8YiO8dW/vc024v6Cf5hY6KIckKDABymnma1AgURW
         re+zNeZ8ASjyV2K2N/zK7XFr29mQ8AxJLT+ucFK97N36PLIXjiQWfcFCdcFdGiUOSUIu
         yn5Ml9Ezj0X2VkCgyyTefGd/PBOZQIRJffFIGeEFsb/LDeKNi/LxCUtOmkQIbZ6majfM
         yC2wLHO29WFzKNATwnyn65kz8hVKl9+4A8vNQTJzoB2+p1+Itwt6n7CemsCpGI3X+7Po
         vGeg==
X-Gm-Message-State: AO0yUKUmb7ik3LDN4y1hnf0qs89aMMhty6kwb92sr+zFppcXyLP/io3O
        IAwEVIev7PIsZQPpkzOzU5k9GA==
X-Google-Smtp-Source: AK7set/L9r21xmLp3kBqHpzeerdSC/MQdjtWE4aPpCQ48ewfcn+d5LRFXxBrax7Lzr/6hAU0PzIgOQ==
X-Received: by 2002:a05:6808:d4a:b0:360:ba2b:d7e9 with SMTP id w10-20020a0568080d4a00b00360ba2bd7e9mr4442647oik.31.1675082188792;
        Mon, 30 Jan 2023 04:36:28 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:4d90:2cb6:4877:a4f4? ([2804:14d:5c5e:4698:4d90:2cb6:4877:a4f4])
        by smtp.gmail.com with ESMTPSA id a186-20020acab1c3000000b00363760f96dcsm4602682oif.42.2023.01.30.04.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 04:36:28 -0800 (PST)
Message-ID: <4d188568-c8d7-e48a-e0fe-0798f9ebeeea@mojatatu.com>
Date:   Mon, 30 Jan 2023 09:36:23 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3] net/sched: transition act_pedit to rcu and
 percpu stats
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230127192752.3643015-1-pctammela@mojatatu.com>
 <Y9UemKFXoekIISvC@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <Y9UemKFXoekIISvC@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2023 10:09, Simon Horman wrote:
[...]

Hi Simon,

Thank you for the review. I will address all of your comments in the 
next version.

Pedro
