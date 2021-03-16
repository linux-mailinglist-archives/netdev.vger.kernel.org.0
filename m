Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5730433D540
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 14:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhCPNyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbhCPNyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 09:54:18 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28327C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 06:54:16 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id s7so35221745qkg.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 06:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=85W+EVBYgCZ/tsFDr60z3mczv1scXmHs0CNrJPCUNnw=;
        b=M2LuhdeQ6fBDiTapLlFhn8vCB+YavsTApyNPiR4aiD9222eXJlqfmEEfHN1U3NaDZn
         ilbiRVMJkCfVkpJ+0Rr3v+HNbOxTomsuTO0e2DWuL7RlbyxSMDJnJrqn435utmk4DxkA
         ECVnopNBJ3L6bxsSxtGWjYV+pYetOar5/ZwfLqtb6+bw64MhX1teki1jrBLqhD98n9w9
         zO4lKom4+LjWkwJZkOiU/hVQIrWI0zqhaqAWE0sKgxWcbEX8YEcCqtBQQebObF7F47/d
         BTzv4AjXFlbWRkOCbHLwRo87wQYAjAdBZ83VkyCYTM+XHjf95mw4YUJA+YWu8QJGtshn
         U8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=85W+EVBYgCZ/tsFDr60z3mczv1scXmHs0CNrJPCUNnw=;
        b=iGm/RBAZtg/ESuLc3uUJOLqW4BHQTCXhYFIYVIAY9LBVowgckH4OnRcQCPsDaRiSex
         JvkNnLRT5PLPgiZuMT1hEcXrj6Qx0+VqCm/pr6fZeL3muvbAlysPpPCMs6V2Eb9mYB+D
         cTR8rvvTYNoQsPOgVETido+khKXBC+3hgdON6Qo9vt3ofFdlgEfm3Fo7zHHTY5wj0l0q
         cbREJj2F81fy2PYzLsZy58xFTQauAly9o12+qk60yujIrpVhYcVjO/1foEL0mIRfeqLl
         W8fmiNt5NOLo6DMviT6Wqyr7RGsGtj23IRwlJHhTqmODYtF0fErI/TG6XOV6noOwIwr3
         zpyw==
X-Gm-Message-State: AOAM532PCw7M1whL1SDUEE7TRZpXmEcE8tWcap0X9Yp+JCHgizJ5RPHg
        4BlRDJag3e8VedZeQQ80x7kdrA==
X-Google-Smtp-Source: ABdhPJy/E0kzUXuAdYwO3JyyL9OUVAarG+plM2N9CSYsUNKUDGn3CLJS1rmWRW7sKQHu/g3XxWkHYA==
X-Received: by 2002:a05:620a:993:: with SMTP id x19mr29593082qkx.77.1615902855374;
        Tue, 16 Mar 2021 06:54:15 -0700 (PDT)
Received: from [192.168.2.61] (bras-base-kntaon1617w-grc-09-184-148-53-47.dsl.bell.ca. [184.148.53.47])
        by smtp.googlemail.com with ESMTPSA id g11sm15367496qkk.5.2021.03.16.06.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 06:54:14 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
To:     Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
 <20210312142230.GA25717@netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <2e241510-9020-cf85-4a17-c5f74a59b8a8@mojatatu.com>
Date:   Tue, 16 Mar 2021 09:53:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210312142230.GA25717@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-12 9:22 a.m., Simon Horman wrote:
> On Fri, Mar 12, 2021 at 03:08:28PM +0100, Simon Horman wrote:
>> This series enhances the TC policer action implementation to allow a
>> policer action instance to enforce a rate-limit based on
>> packets-per-second, configurable using a packet-per-second rate and burst
>> parameters.
> 
> ...
> 
> Sorry, I missed CCing a number of interested parties when posting
> this patch-set. I've added them to this email.
> 
> Ref: https://lore.kernel.org/netdev/20210312140831.23346-1-simon.horman@netronome.com/
> 

For 2/3:
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

If you submit one or two testcases to tools/testing/selftests/tc-testing
you'll be both a hero and someone committing an act of kindness.

cheers,
jamal
