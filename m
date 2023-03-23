Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F026C6A5A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjCWODS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCWODR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:03:17 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9EC35269
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:02:02 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id s8so6289874ois.2
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 07:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679580118;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VZ04UTUU1G/XlIwBlwTwtH4v0PIBgdYEeRYbRTJbWMo=;
        b=7E20F3UM7NbXkQx+dvIQEiADhvn60Kl5pYDGfBcq8nj6AxvajUFP5FHSCh0IRfx7Xq
         LcXGvOxY6Puk4cxE55mroz7udxRUcQMty2w7uSp3QtzT4lBhYQSnfr/tnCiMU4OwhO3+
         O8Nmwzoww+dkBw1fTyvhn2bdlKLdetcGp2DEE5zhEMPJyKCSaKx1Bgbna8hTzlgxID16
         ge8EdaRDQLIUfVTxiNKlY5AQKV17wIFxBZlzCgNGxTtlxh9jv7HbNx10KaReFy+rwGeP
         qyCIBuYrSVVfXy79ohpJzatutC0SEBUM8l3Frq+XvVIpbe4Oa+bpCcL9HaaQG8EAnT07
         awIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679580118;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VZ04UTUU1G/XlIwBlwTwtH4v0PIBgdYEeRYbRTJbWMo=;
        b=38zNLT5G7NqShdpefLZd8SS6h42oSCs3cOEeI9SzqrRtAykOuz4SpD+QghvNGcdPtV
         XpxZ8cEkeAML4QFgaSjq/dzudpjNUT8bLpP3tLi1uTQ8uS3oqc27+nXvY7+NVEfptGIW
         VmPZC/sMp47GmlNi8gYw8f5NHh3h6i72ZyuMPxhg09wBsHpXZld3vPdAugD6hzKwXS2a
         DqlFK/gkKEpD5EV7ZZPkNAIKUKm/wsuoKM0vbuB0qGMmHZCmO1SMZY1E7IBHRCXQEyyt
         057xX8TNsBQR18OCmrYinnrUxFWlzWgenT3Y5XoouBWsO3GOFIaGzGUZw8L6bn5JLD9r
         17ow==
X-Gm-Message-State: AO0yUKXJTfwm+NADNVyYU7Uw5oDZmdGVF4SsqqQmjEOqYONBFoZDCITc
        e/6RsoA6Gcef3xjaempI5J78tg==
X-Google-Smtp-Source: AK7set+5N3UeHOr4CvSdvLa2V/DJIyn/I/iimfv9FMz/IMsRm0OFkgunJVveEF2TBbaMRPISRLQMGw==
X-Received: by 2002:a05:6808:229e:b0:386:db84:a26e with SMTP id bo30-20020a056808229e00b00386db84a26emr2846487oib.26.1679580116830;
        Thu, 23 Mar 2023 07:01:56 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:9ae8:6c99:7a3b:9698? ([2804:14d:5c5e:4698:9ae8:6c99:7a3b:9698])
        by smtp.gmail.com with ESMTPSA id y184-20020aca32c1000000b0037841fb9a65sm7134216oiy.5.2023.03.23.07.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 07:01:56 -0700 (PDT)
Message-ID: <b6ed0c28-248c-e383-cf05-a8a9bec73b20@mojatatu.com>
Date:   Thu, 23 Mar 2023 11:01:53 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 2/4] selftests: tc-testing: extend the "skip"
 property
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1679569719.git.dcaratti@redhat.com>
 <29e811befea5e751f938e3bf46ca870ec214d53d.1679569719.git.dcaratti@redhat.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <29e811befea5e751f938e3bf46ca870ec214d53d.1679569719.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2023 10:34, Davide Caratti wrote:
> currently, users can skip individual test cases by means of writing
> 
>    "skip": "yes"
> 
> in the scenario file. Extend this functionality by allowing the execution
> of a command, written in the "skip" property for a specific test case. If
> such property is present, tdc executes that command and skips the test if
> the return value is non-zero.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>


I saw the use case in patch 3 but I didn't understand how it can happen.
Shouldn't iproute2 at least match the kernel version? I know it's not a 
hard requirement for 99% of use cases, but when running tdc I would 
argue it's the minimum expected.

