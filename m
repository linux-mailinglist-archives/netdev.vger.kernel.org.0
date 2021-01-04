Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA5C2E9B45
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 17:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbhADQqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 11:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADQqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 11:46:52 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB11C061574
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 08:46:11 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p187so25518458iod.4
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 08:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xgWqESCBVqMnXnGPAxKowMhp+UIvBjqm1WR2CemoJCk=;
        b=jlUmtFVXjvUOSqR8pe6bpgfBCN6GpN/h60/YfzhwUbbAhATuOw/czwE44IkUW9wx4o
         8cjcerFoPI1dPg1jqAOXiASm8veiGAN+KwOsuJ6UtzVK3iuWLvgE4PsaD4WgFJnTMZ8k
         1SAiCBH09ieQLFBREAVh8QvJBcm2ljf4TMWJecaBf1VxPiDThkZI9ibiJpqREcjxry3y
         Kfl8yAqHYkEIspOJQNjBTsO4OcSkNh/T2FW919+NmFGab/jWIvXRhs73rbzdrS/g/Rl4
         9FEmjlWXVSa+nwP2k1voaZgkhsa8mAV0qZFK3m/oEL0iH/ZznSenFI05EEQGQ0RCjS8u
         38yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xgWqESCBVqMnXnGPAxKowMhp+UIvBjqm1WR2CemoJCk=;
        b=Lo3uZmaJMZO/VDtssul5MENe+z1fEL1TjaAEr4lZSfgSSfU0DQENTWCXrpWvYdofoZ
         awi6O2pXGoS2P9qddNOJxlH78zbk96NsbGAljeK6DepGoidtrYtHNnsR0NV0G/hUzOva
         PpAqOT2Fa8xli2/XJ9YUWEfXKTU9nX4eqiQF85vo58TIPyWzPwr2E3Mop1bKCvLQQSXw
         qQd/BhLu0AtKDnyX/zWYBjWfC9dHNnm751byAkpnVKl6HGIDpnjp/e52ewiPOKsijZXf
         eOcW4srcbSJmiVZ3FNSVDhfOCtjpt/fw6U5MWvTMlTG4zN+f3f8iVsRS1Q9BPn6XL2K9
         k34Q==
X-Gm-Message-State: AOAM531mtxfbUSIQOufxAsX4Laqj1yHwY1+xQY44/BxjIrMeAHNErf9E
        Fq/ZkWUt1jlo0yMJU1ljExGooUtOWlcsJg==
X-Google-Smtp-Source: ABdhPJycUC5ECPxcV/Kxf8bfxGI5NWZKTW8InvLPSuqltCbAuT0q6KAiM6pVhwaTbk5EBY0VjUseGA==
X-Received: by 2002:a02:ce8a:: with SMTP id y10mr60414465jaq.102.1609778770872;
        Mon, 04 Jan 2021 08:46:10 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l6sm43545889ili.78.2021.01.04.08.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 08:46:10 -0800 (PST)
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>
From:   Alex Elder <elder@linaro.org>
Subject: Missed schedule_napi()?
Message-ID: <475bdc3b-d57f-eeef-3cdf-88c7b883d423@linaro.org>
Date:   Mon, 4 Jan 2021 10:46:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a question about whether it's possible to effectively
miss a schedule_napi() call when a disable_napi() is underway.

I'm going to try to represent the code in question here
in an interleaved way to explain the scenario; I hope
it's clear.

Suppose the SCHED flag is clear.  And suppose two
concurrent threads do things in the sequence below.

Disabling thread	| Scheduling thread
------------------------+----------------------
void napi_disable(struct napi_struct *n)
{			| bool napi_schedule_prep(struct napi_struct *n)
   might_sleep();	| {
                         |   unsigned long val, new;
                         |
                         |   do {
   set_bit(NAPI_STATE_DISABLE, &n->state);
                         |     val = READ_ONCE(n->state);
                         |     if (unlikely(val & NAPIF_STATE_DISABLE))
                         |       return false;
			|	. . .
   while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
      msleep(1);		|
        . . .		|

We start with the SCHED bit clear.  The disabling thread
sets the DISABLE bit as it begins.  The scheduling thread
checks the state and finds that it is disabled, so it
simply returns false, and the napi_schedule() caller will
*not* call __napi_schedule().

But even though NAPI is getting disabled, the scheduling thread
wants it recorded that a NAPI poll should be scheduled, even
if it happens later.  In other words, it seems like this
case is essentially a MISSED schedule.

The disabling thread sets the SCHED bit, having found it was
not set previously, and thereby disables NAPI processing until
it is re-enabled.

Later, napi_enable() will clear the SCHED bit, allowing NAPI
processing to continue, but there is no record that the
scheduling thread indicated that a poll was needed,

Am I misunderstanding this?  If so, can someone please explain?
It seems to me that the napi_schedule() call is "lost".

Thanks.

					-Alex
