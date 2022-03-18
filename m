Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B534DD903
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiCRLgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiCRLgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:36:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5EF20C187
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 04:34:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h1so9895510edj.1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 04:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7Vsx1O3ZE0erPRGw1F/SDJoi6n0+3wA7RndYVxGvgu0=;
        b=2gThkbf8h0EXaDAo2KxDjcBDMcKUx9Bavoq5aQWn4WaTV/ILGHsZHYN0kS7HWDi50e
         aIe9KMfyAg1/BREaoMa7Y6UTn5eam9OoQkf45CetyMq9Kgbi8RJChuM2QQU4Mj5VOS8B
         8cKisLLajUM+JshKXp6/N5AN/GjirEnJfeZ+V1t5bD9u9NRP5FN9MFV0uPZzfgKpT9QK
         12Dq7iv0HISYGcuIy2i+f8HjQRicXT4EEGAN84dIq0Ghl9XGsg9k0l1M8DWHALtBboiI
         b5Vx1NuyaBpSXzExzhzyS6v4gHWe9bJSPA4PWCCLtayPqzFWkShTAVhCmrPNL89INRkG
         6JRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7Vsx1O3ZE0erPRGw1F/SDJoi6n0+3wA7RndYVxGvgu0=;
        b=mZxRXrDM5awI13f+WEvjGKDYF9gInGundlDX304K7bLeexnareN0EuYZ+/AifeBXl/
         z/jLbegUBflAK9H16np7iX7oiE6T97aKk9LqlXtUujUFHADYfSp5is4zXZCQFgm+Acwd
         L4UnBYqtiKxeQGtPtCCHPwOoi3y1DpMZosNuBL+MQeJnPRz4pfwf0rli32fvvNWObdy8
         z0DUa7OXw45Mta0DZEEH9wFpf2cPeowdHcXB1GGzed2UEANf3ZYqZWwvoIZHFd+KV4PY
         F3Qk/Np98JHvbKutY1OFukBxTNLcPWmINZSOKxTGgplNs287xSo63C0F1q+NrvOWRa2b
         CFkw==
X-Gm-Message-State: AOAM531G/yv4dXmw13pkegKkgYU0tMyCj8AjTQqwVwm7zfvu/t1D0MZy
        PEGjqMv2Tj8UEEAbEj2kgtSwMw==
X-Google-Smtp-Source: ABdhPJznjKparJZUW0yeV6RL1SNF8ap7H0fZJWAJXvRusO3+YXv8ovBoGc/RiPUPrEYTyFQ8EEIBow==
X-Received: by 2002:a05:6402:2811:b0:419:12:abd0 with SMTP id h17-20020a056402281100b004190012abd0mr6100097ede.143.1647603294065;
        Fri, 18 Mar 2022 04:34:54 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s7-20020a170906778700b006df7e0e140bsm3436195ejm.140.2022.03.18.04.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 04:34:53 -0700 (PDT)
Date:   Fri, 18 Mar 2022 12:34:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     =?utf-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v4] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
Message-ID: <YjRuXPJzp2fKvMst@nanopsycho>
References: <20220317061521.23985-1-sunshouxin@chinatelecom.cn>
 <YjLtLdH9gmg7yaNl@nanopsycho>
 <1f7b15a6-861f-9762-a159-73d16c95eebc@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f7b15a6-861f-9762-a159-73d16c95eebc@chinatelecom.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 18, 2022 at 10:49:02AM CET, sunshouxin@chinatelecom.cn wrote:
>
>在 2022/3/17 16:11, Jiri Pirko 写道:
>> Thu, Mar 17, 2022 at 07:15:21AM CET, sunshouxin@chinatelecom.cn wrote:
>> > This patch is implementing IPV6 RLB for balance-alb mode.
>> > 
>> > Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> > Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> 
>> Could you please reply to my question I asked for v1:
>> Out of curiosity, what is exactly your usecase? I'm asking because
>> I don't see any good reason to use RLB/ALB modes. I have to be missing
>> something.
>> 
>> This is adding a lot of code in bonding that needs to be maintained.
>> However, if there is no particular need to add it, why would we?
>> 
>> Could you please spell out why exactly do you need this? I'm pretty sure
>> that in the end well find out, that you really don't need this at all.
>> 
>> Thanks!
>
>
>This patch is certainly aim fix one real issue in ou lab.
>For historical inheritance, the bond6 with ipv4 is widely used in our lab.
>We started to support ipv6 for all service last year, networking operation
>and maintenance team
>think it does work with ipv6 ALB capacity take it for granted due to bond6's
>specification
>but it doesn't work in the end. as you know, it is impossible to change link
>neworking to LACP
>because of huge cost and effective to online server.

I don't follow. Why exactly can't you use LACP? Every switch supports
it.
