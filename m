Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102C13C995A
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 09:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbhGOHKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 03:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhGOHKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 03:10:02 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4ACC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 00:07:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o30-20020a05600c511eb029022e0571d1a0so2907292wms.5
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 00:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5TddEsx9AaNz5LCQXxnH154vyrz8GHXag1KBeTokSBM=;
        b=MzFqItdCvx1k3dt4lnHINlpIQ9z9xpVraq4NvN5HkmS3LIYGfo98ov3caQSMMwxLor
         KcMAkCb1xcMB+4Q0MSwmUv/rNo2xvYQjiTjBO+TTF7LMzmg+SExYl82Jvox0/OVq5jx7
         hvsyDgV9W6tqe2HeRyke3EKXDgjdEkb0t9s9sfS401I0wiI6glFhqnnafNiRzr9aWSSM
         NRJXKpeBAapsbYHEcytMOR04Zb918tNQxG2GJQdbedEY4992gV+7yW18Z3ilG8QgIO+a
         6jTfW+R7lxGZQQj43qeIo4/REqkIp0p+SI5LGNQgE+j4+UX0xjkqYSAMdtClrKWcbzSw
         PINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5TddEsx9AaNz5LCQXxnH154vyrz8GHXag1KBeTokSBM=;
        b=tO3kH9cQAC8rZL5exVyq/iPY1pvSFqiFkyOnXhfPxPEkg6nUmnE9jO5+DRYv5nKAWL
         VyDT4/h3LOtcYS5xjF6W4Y2w7/kjT8gukvhHqIVwuAR/x62Ew/ylJrN2K7/QW6MRqvWG
         nflpaBp42Oiu4KdlTBJLeO/NCf5BgeHYn8/+bFRx9bR8Ls/lNFgMgAGakfK6fYWC10nt
         udC7NgXtEnxmjTkvSPLUqf+FWfGY8dyLpL1kzgmf0tmUxzXUM7HPXtvNvDWFkhXdMV0y
         F8058U76RXKylNpzVLG36QkmkqVEoJdBT9YvfuPS46VtP6qN2B8Gh6r7f3thG3S4rfOa
         N4JA==
X-Gm-Message-State: AOAM533q4WgGJvLJxmt+Lcx0Gxvm5oSjD48H1+JLDGk73ETUalx01ZSK
        mZ8hTBeTUID6kcBLz1C2cpd7g1LDays0ow==
X-Google-Smtp-Source: ABdhPJwys445lGZEJEpOz6auP5J82oUq+Rl6ejPC/JpaFrmJF7oXsXCFRbNUlhDyxiT6oiaq6fTikg==
X-Received: by 2002:a1c:720f:: with SMTP id n15mr8574213wmc.172.1626332827935;
        Thu, 15 Jul 2021 00:07:07 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:c510:a4d3:52d6:e2e? ([2a01:e0a:410:bb00:c510:a4d3:52d6:e2e])
        by smtp.gmail.com with ESMTPSA id a8sm5265261wrt.61.2021.07.15.00.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 00:07:07 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Patch to fix 'ip' utility recvmsg with ancillary data
To:     Lahav Daniel Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0644F993-A061-4133-B3AD-E7BEB129EFDD@drivenets.com>
 <8e3cbedf-0ac8-8599-f713-294733301680@gmail.com>
 <D2E7CEEB-B195-4A02-8D09-6595D74A5812@drivenets.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <ed9a4beb-1984-42c2-5cca-3101d285baf7@6wind.com>
Date:   Thu, 15 Jul 2021 09:07:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <D2E7CEEB-B195-4A02-8D09-6595D74A5812@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/07/2021 à 10:48, Lahav Daniel Schlesinger a écrit :
> Hi David, thanks for reviewing the patch!
> Here is the updated patch, I hope it's okay now:
> 
> ipmonitor: Fix recvmsg with ancillary data
> 
> A successful call to recvmsg() causes msg.msg_controllen to contain the length
> of the received ancillary data. However, the current code in the 'ip' utility
> doesn't reset this value after each recvmsg().
> 
> This means that if a call to recvmsg() doesn't have ancillary data, then
> 'msg.msg_controllen' will be set to 0, causing future recvmsg() which do
> contain ancillary data to get MSG_CTRUNC set in msg.msg_flags.
> 
> This fixes 'ip monitor' running with the all-nsid option - With this option the
> kernel passes the nsid as ancillary data. If while 'ip monitor' is running an
> even on the current netns is received, then no ancillary data will be sent,
> causing 'msg.msg_controllen' to be set to 0, which causes 'ip monitor' to
> indefinitely print "[nsid current]" instead of the real nsid.
> 
> Fixes: 449b824ad196 ("ipmonitor: allows to monitor in several netns")
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[snip]

>> patch looks right. Can you send it as a formal patch with a commit log
>> message, Signed-off-by, etc. See  'git log' for expected format and
>> Documentation/process/submitting-patches.rst in the kernel tree. Make
The format is still unexpected. Please, consider using git send-email.


Regards,
Nicolas
