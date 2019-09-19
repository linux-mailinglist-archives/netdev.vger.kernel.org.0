Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446E6B71A2
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfISCls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:41:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40010 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388284AbfISClr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 22:41:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so858656pll.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 19:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WMTS9AboLcRoehZDUcNLaIdyp+1u6YWwRLg1uLK5kzg=;
        b=eGdZxch9++CWNFokf5kAaajnT2HGibGj4OjWtsG+UV/sbhfmBeS805xzxwknsF4Kr7
         xNl2k7zlETv1trqVfl78W2mB5xqvRCgxx8BPVogHiGjOOGf5F7vwQCLwBwvrWCYuUzb6
         GJoEXvYq3kTfVmP+W/Ol8O/m25dQPifijgolZ6pO8gYV2P4xbvR9jH0eHg0g476plqUp
         EIk91ymrqVh+JJxtLNeE05e2XnJTInNfHKAkIrFnrjZnNwud5bMTvJGkH1yVssyG2za3
         ycLmkrM2juLUSDO6Dda8Ax2hrNpriVN3XIOnYP4jgKFTkpMrMopDISXsVzF3m3F/OOJ5
         yJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WMTS9AboLcRoehZDUcNLaIdyp+1u6YWwRLg1uLK5kzg=;
        b=TqlVG+kRs/ONGRT8ev0qEu70pltqQXoYwjX0R4qCQzYYoVqDYomZyQHinDftiorn+1
         r7svxjOrw7jim6Cys/A5V+Q2F7ausWV90fc6KShPXAhek1MOUO/nYO1k9bYpw9IZ6vxg
         kopsAZqpsORt9l5YhoYRedRGoRUQSnSJA5qa46aLTe3iFh6hoOkPesKxkFN3uMRt/Yig
         Il2Sy6nBGqU1goV7oTlqbX2WSPMEs93mMI6zPFeI/JBJZ0ZHXk1glnsBMTbWqJGKxINs
         v1GTZOIF/CYM5SG/AV+3cBnepxWfkhsdU0oXCYIRXZuZLIvqIrDYSzMSigd8VUqRW2/M
         3frA==
X-Gm-Message-State: APjAAAWDjGbGl6QlszLGLdYGhNyeqF9Qli4F6+iolBK0lsxw0FWVU/CD
        QTekh+YiOS7yUR/+MSKDoyM=
X-Google-Smtp-Source: APXvYqxJXtFKNYo6LOwsoDJ8fAsnkymGLx5/gapfsNwEwVcfYG4iZSnblVPNvCctZCp26W/qZblPpg==
X-Received: by 2002:a17:902:aa92:: with SMTP id d18mr1856434plr.58.1568860905908;
        Wed, 18 Sep 2019 19:41:45 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:5d8f:d810:4b26:617b])
        by smtp.googlemail.com with ESMTPSA id 21sm2033196pgx.49.2019.09.18.19.41.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 19:41:44 -0700 (PDT)
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
Date:   Wed, 18 Sep 2019 20:41:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 5:24 PM, Cong Wang wrote:
> The TCA_KIND attribute is of NLA_STRING which does not check
> the NUL char. KMSAN reported an uninit-value of TCA_KIND which
> is likely caused by the lack of NUL.
> 
> Change it to NLA_NUL_STRING and add a max len too.
> 
> Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")

The commit referenced here did not introduce the ability to go beyond
memory boundaries with string comparisons. Rather, it was not complete
solution for attribute validation. I say that wrt to the fix getting
propagated to the correct stable releases.

> Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com

What is the actual sysbot report?

> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/sch_api.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 1047825d9f48..81d58b280612 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1390,7 +1390,8 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
>  }
>  
>  const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
> -	[TCA_KIND]		= { .type = NLA_STRING },
> +	[TCA_KIND]		= { .type = NLA_NUL_STRING,
> +				    .len = IFNAMSIZ - 1 },
>  	[TCA_RATE]		= { .type = NLA_BINARY,
>  				    .len = sizeof(struct tc_estimator) },
>  	[TCA_STAB]		= { .type = NLA_NESTED },
> 

This is a better policy so for that:
Reviewed-by: David Ahern <dsahern@gmail.com>
