Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9391A1D9ED8
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgESSIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgESSIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:08:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B61C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:08:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so34242pjb.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BsS3qKtfCM0g5g/2astPSpl1s1vVR6PmrIeZ4WbI+TU=;
        b=cnHG1XyPo6vACJwLeCNHA78UTVMAa9gyq+FLqzFjl2ci1ZVD5dneTNG2pwmYtzeW1t
         688cFpHRvPd9sfPPnUDRwki4eNvF2c/OD8I9OoVXSobpiABgdYfpmcgG59VU0RaDoPQV
         6Lc4C3U7zs6a/jJM10gkvh9RLt98FaQasppjAs4516IeTZJb09pksext6y/CVPvzk2yu
         h4U3dzLVn/iITGI/4FTXgymEmkNYRvBbnc+rWuk8iMXXhCGHhMGgcmq0vXHH6IOebNKz
         Kr6p1I7wdaWy4ZwxKe/jfWwW9/C7gacu5oAHsmrjM1eNk8CI2kUkJa7wfKKZWEMfEEBg
         awDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BsS3qKtfCM0g5g/2astPSpl1s1vVR6PmrIeZ4WbI+TU=;
        b=Xzh0YYmTMskBiTPk0byvjfM6qiDyFNIIv0fUV1W5nXRg6gMrtUnBh7Nf/XylV5Uu2Q
         qO01mD0eLjvS/n8lKixMcR2ZhfOqjb+57H38IP0o8wIMjKqTOScY3rkODLtXqDE4YtX5
         hxyzj9tk/grsaQc9Q7pHtUeG5nk5/LAM/TvTw0X1poKVtUj+fPfPzxBkiImZAPVpQBqu
         TLD4A+3F8ipZrXnMqgiLpgTJK5ULmsNQCM+L8XgbBMVrbQ6dmn6Q7sri4Y3AXfimn/9q
         Q3WGyV2alMHrFoO6WA6OTOQ94OajI17he4En6kcj4guu9VpKxAID1RNw8MVuAg3pHaU3
         nddA==
X-Gm-Message-State: AOAM530uVBcvbQRAJgrk2FPgiGvjCgBljJl5GbKwWyJICtyPEiT497OY
        zrByKKWYtG27+ye/I4B52m96NvZV9b4o4A==
X-Google-Smtp-Source: ABdhPJyZPADoIGsCfQ/UxM5/9phkpYcfnxwai/SuNDgn2C/HhtJcLBAOgRmmgFhZHGcG3Qn80YR3xw==
X-Received: by 2002:a17:902:d70a:: with SMTP id w10mr698759ply.256.1589911719631;
        Tue, 19 May 2020 11:08:39 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m14sm121251pgn.83.2020.05.19.11.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 11:08:39 -0700 (PDT)
Date:   Tue, 19 May 2020 11:08:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
Message-ID: <20200519110835.2cac3bda@hermes.lan>
In-Reply-To: <85pnb1mc0p.fsf@mojatatu.com>
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
        <8f9898bf-3396-a8c4-b8a1-a0d72d5ebc2c@gmail.com>
        <85pnb1mc0p.fsf@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 12:41:10 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> David Ahern <dsahern@gmail.com> writes:
> 
> > On 5/17/20 7:28 AM, Roman Mashak wrote:  
> >> Have print_tm() dump firstuse value along with install, lastuse
> >> and expires.
> >> 
> >> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> >> ---
> >>  tc/tc_util.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >> 
> >> diff --git a/tc/tc_util.c b/tc/tc_util.c
> >> index 12f865cc71bf..f6aa2ed552a9 100644
> >> --- a/tc/tc_util.c
> >> +++ b/tc/tc_util.c
> >> @@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
> >>  		print_uint(PRINT_FP, NULL, " used %u sec",
> >>  			   (unsigned int)(tm->lastuse/hz));
> >>  	}
> >> +	if (tm->firstuse != 0) {
> >> +		print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
> >> +		print_uint(PRINT_FP, NULL, " firstused %u sec",
> >> +			   (unsigned int)(tm->firstuse/hz));
> >> +	}
> >>  	if (tm->expires != 0) {
> >>  		print_uint(PRINT_JSON, "expires", NULL, tm->expires);
> >>  		print_uint(PRINT_FP, NULL, " expires %u sec",
> >>   
> >
> > why does this function print different values for json and stdout?  
> 
> It prints times in jiffies for json mode, and in seconds otherwise. This
> inconsistency is likely a bug, and a subject for another fix.
> 
> Last time this function was touched in commit
> 2704bd62558391c00bc1c3e7f8706de8332d8ba0 where json was added.

iproute commands are not supposed to expose the jiffies version of
times in input or output. 
