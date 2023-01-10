Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A21664348
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbjAJObo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbjAJObZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:31:25 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFEF1788C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:31:24 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9so13328512pll.9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7djpQYuEQ4rutFY3aCumcUbXeK4jm4WEKYMSgQ9wfMc=;
        b=8TmJZuAH3X7R8qMXAkO0Mj7ON3o4/LjwW6PwSMlxs9ko4RIejtKuU/qM1xLpzKL6Ne
         Ho/le0CrNNyb0yAHrrCjTa5hAqJOoJn2QpiTecF81G91OB/7kxuQhn4LlvD6FmZlqlDs
         k6pa9r1iSD7WmhkDjv6EYu0hJGC9jUyyUmfpR1/OycNjMIKAmok+llBXwPOF1cUd3vsX
         mu53OaORbrTL4YdQDW8ugS4Sr0hgf0mljQ0vAuO107FbopzTjo9vAdlC/AETF0AqIVBL
         SZjWxghfAzJAgD1zgYf33HBV5rn0gYHJSWhkRFlFFAFTfQg/HegMFUeIXXv1CNORMegR
         +Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7djpQYuEQ4rutFY3aCumcUbXeK4jm4WEKYMSgQ9wfMc=;
        b=sIOvVPPvLVMEV+IE1fNu+iWtp5O8T2vyq1tr8tv7V1arsGxIgGPKqrCR4A8I9gN0A7
         WnyEjLYN7F3xRSah7MgRwUNVXyBrVzmze+kH2JkCY2T3oEqOtfeY3dgrTte69CWbutbx
         +6VjvGtRNUL2S2B5TL3X0Kiwf196J8O0STyLgslI5iX9rAndZfjvpmMzAwYklPvfng+f
         /ozY7ERcxAZqNF0z4mChKvqpnMUMsqfMr+rpYCvPs0wey0+4KduDYaDymugeOzsNBJct
         sk813tiwR1kEBQ50QpAxs3jGRqgsZH6qqCDmYi9DfGac7NYi1T9LhAPVbfLrw4th6sGN
         2/Ng==
X-Gm-Message-State: AFqh2kp/oUriM1rVyQjXVJIkFDPpCJDkaNe9mjuk9+39ihKsZiOiUhGO
        0CLyqvCOLMJNsXgxIrfVpUpX8fGemJ/K30GaYriiBg==
X-Google-Smtp-Source: AMrXdXv0OLHn5s+JOegsbBUw9y6zO6hCeYEtoqhF5VT3Ii3AhJsJn2+QalPYW1qVrLSo2nrSqWBUGA==
X-Received: by 2002:a17:903:22c7:b0:192:ee6c:e28d with SMTP id y7-20020a17090322c700b00192ee6ce28dmr30801112plg.38.1673361083802;
        Tue, 10 Jan 2023 06:31:23 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b001782aab6318sm8218308pla.68.2023.01.10.06.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 06:31:23 -0800 (PST)
Date:   Tue, 10 Jan 2023 15:31:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <Y712uDIgr/f1vveL@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org>
 <Y7WuWd2jfifQ3E8A@nanopsycho>
 <20230104194604.545646c5@kernel.org>
 <Y7aSPuRPQxxQKQGN@nanopsycho>
 <20230105102437.0d2bf14e@kernel.org>
 <Y7fiRHoucfua+Erz@nanopsycho>
 <20230106131214.79abb95c@kernel.org>
 <Y7k6JLAiqMQFKtWt@nanopsycho>
 <20230109114949.547f5c9e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109114949.547f5c9e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 09, 2023 at 08:49:49PM CET, kuba@kernel.org wrote:
>On Sat, 7 Jan 2023 10:23:48 +0100 Jiri Pirko wrote:
>> Hmm.
>> 1) What is wrong of having:
>>    .dumpit = devlink_instance_iter_dumpit
>>    instead of
>>    .dumpit = devlink_instance_iter_dump
>>    ?
>>    How exactly that decreases readability?
>
>The "it" at the end of the function name is there because do is a C
>keyword, so we can't call the do callback do, we must call it doit.
>
>The further from netlink core we get the more this is an API wart 
>and the less it makes sense. 
>instance iter dump is closer to plain English.

Hmm, I guess if you are not happy about the callback name, you should
change it, to ".dump" in this case. My point the the naming consistency
between the callback name and the function assigned. But nevermind.
