Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9152DC5A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243589AbiESSFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243151AbiESSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:05:11 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F947DE31F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:05:07 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p74so2948911iod.8
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yfRu9r5AyRU+LW73IK5OB+8eWccTNvQKHuxGKupA8sQ=;
        b=drkIJjeZ1SdAhd+/NtdqbacK3oaUcx4lRbAYaTPJXghh4ct585F7AGYS/R84bVMuNV
         lhTk80O3pQZ5L7aCUWE5PGHYKsEQKTo3aFjG49BLL+WJF2gqD/qvmLgsMrZ60NKh7n43
         7cwapR8fzLAh+Wtnfw55NLcmkUa0yGeDO5Vbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yfRu9r5AyRU+LW73IK5OB+8eWccTNvQKHuxGKupA8sQ=;
        b=PdT+PTwjUv6zbQbSX2loGYp1zsIzB2Y+z+sSjKz0Wz5JyeE6JGMam3o5kLFKkE0jtl
         S9Kg6QhFqlLm7RItd+k4oromv9841oCEzGnrQTpe6CWyJrtktNTiniIZ+gWGcoK4lQ8o
         +X0Bl4FR4xvyrTvx12Ze0EulY5M8fGJXngTH+eGaupBcaTdXUDnLUU4/q4KtHWa8h/Vi
         uiV7vssw6ZJd4QY3sRTHbkVu9zBOaFEmzRwjfPuAcXbk+9RqOT0g6fj6w//ETiXsHXDF
         6UGZG1HRRxO0gLAqDSujZRRnEWApQp0/pP/8IeDkpNk2Z+Q86n16OuubmBQ2teRFcFs8
         D4cQ==
X-Gm-Message-State: AOAM530rQJchNbx8HSU+7lxHV7thJ1Pg2hYcDAhoDlSzVpdntsbE0x3T
        haETGQv7SY79IULNtq54W2TyVg==
X-Google-Smtp-Source: ABdhPJygNwMG6b2VmZCVIG/zRoIo5y6Ozs/LgR9aVHTqBvi1o1tmcpkpfsg4WL5cMNd8/dZVHsb7ZA==
X-Received: by 2002:a05:6638:616:b0:32e:614:9c4b with SMTP id g22-20020a056638061600b0032e06149c4bmr3371570jar.203.1652983506380;
        Thu, 19 May 2022 11:05:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d137-20020a6bcd8f000000b0065b2fd94d2bsm928693iog.5.2022.05.19.11.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 11:05:05 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make ping timeout
 configurable
To:     Amit Cohen <amcohen@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220519070921.3559701-1-amcohen@nvidia.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2eac9d43-ff3e-6c0c-ee2b-60037bca6182@linuxfoundation.org>
Date:   Thu, 19 May 2022 12:05:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220519070921.3559701-1-amcohen@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/22 1:09 AM, Amit Cohen wrote:
> Commit 49bb39bddad2 ("selftests: fib_nexthops: Make the test more robust")
> increased the timeout of ping commands to 5 seconds, to make the test
> more robust. Make the timeout configurable using '-w' argument to allow
> user to change it depending on the system that runs the test. Some systems
> suffer from slow forwarding performance, so they may need to change the
> timeout.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> ---

Thank you.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
