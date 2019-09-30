Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A56C220B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfI3NeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:34:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40896 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfI3NeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 09:34:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id l3so11352895wru.7
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 06:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kz2fxUlf4eTQETa2pSYICOnSK6lvhYbu2mRqocFFuq0=;
        b=sWshrZoc8+DWAAGxX4Bv5eBjDQXPjlr8R4Rz0DcF0yO5O4fA2IsSemdVH8kWJl4lpL
         Iv1nyutYE46ur+bn54vWLfBkBPCe62eZI0axakfL8M57xnzOHTEGu8xP6H6j0d6TnN5a
         rYfU1TQLi2oUZDYTvF9TKLRbqApiOFkm4TPoF+IAygPdcLMj+sz8NQukpXNMIrM1PP7F
         yT5MzuRWVvIDRHme03IWKzX+hOLjM6KQUp12i1MqnmRtk+cCZNY1V4z3vAG/u9ybbXOf
         +ezgiaHiDt5x63gFavgfHDun4M9Vm8z2umLqwzkv1mxJc09JLpGshT6r8e4zzwY9xhkb
         GMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kz2fxUlf4eTQETa2pSYICOnSK6lvhYbu2mRqocFFuq0=;
        b=UEeqUebl9AmJ5IDXZCqNNiXu7dZYQb5huDucsbALrYE4JyZYTDnDdrSvNdvvhfv0G7
         cIGeLRqHfxX7sZI7JmBT84wv6kCmuCKDkB8I2Iteq1f/xWcV5fE36G546DiVfaaGSnNC
         UqYvCgOKjkNnkMBv/QrIIVNlVvUBNJ3n9MEbVnohwgYla76j1sUdtLND0P9KXgNM8Y9a
         rNF39Yasbsi3CNrrZMji4ciUSZPo+vwthDTBh/p/cNPeDoaTFbh46GGm5CJDmFIpbigp
         rWm4K2hjpKyP8DWLbqf2CcuJnWbL4POdfwijEn3V7QCdoMY07pQPkPscflxKHe9CyK+f
         Pjiw==
X-Gm-Message-State: APjAAAXarVTb6YCMzG4Q4eGJ0tCZObpDqk92RbF1IMncSf9L9QAFZLWr
        wD+UF2IJJW4I8F8qUDlGKBezBXTyVb8=
X-Google-Smtp-Source: APXvYqz32n5J+/2tt+TYybvTS94kTxAlJN5i/l2lc4WjFtYRnyw4T4Sg5SsQFG4fnWW23Qoa7sDjAw==
X-Received: by 2002:adf:f092:: with SMTP id n18mr13843627wro.262.1569850441706;
        Mon, 30 Sep 2019 06:34:01 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id 94sm10406149wrk.92.2019.09.30.06.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 06:34:01 -0700 (PDT)
Date:   Mon, 30 Sep 2019 15:34:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net] devlink: Fix error handling in param and info_get
 dumpit cb
Message-ID: <20190930133400.GD2211@nanopsycho>
References: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20190930121003.GB13301@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930121003.GB13301@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 30, 2019 at 02:10:03PM CEST, andrew@lunn.ch wrote:
>On Mon, Sep 30, 2019 at 11:52:21AM +0530, Vasundhara Volam wrote:
>> If any of the param or info_get op returns error, dumpit cb is
>> skipping to dump remaining params or info_get ops for all the
>> drivers.
>> 
>> Fix to not return if any of the param/info_get op returns error
>> as not supported and continue to dump remaining information.
>> 
>> v2: Modify the patch to return error, except for params/info_get
>> op that return -EOPNOTSUPP as suggested by Andrew Lunn. Also, modify
>> commit message to reflect the same.
>> 
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Jiri Pirko <jiri@mellanox.com>
>> Cc: Michael Chan <michael.chan@broadcom.com>
>> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> ---
>>  net/core/devlink.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index e48680e..f80151e 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -3172,7 +3172,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
>>  						    NETLINK_CB(cb->skb).portid,
>>  						    cb->nlh->nlmsg_seq,
>>  						    NLM_F_MULTI);
>> -			if (err) {
>> +			if (err && err != -EOPNOTSUPP) {
>>  				mutex_unlock(&devlink->lock);
>>  				goto out;
>>  			}
>
>and out: is
>
>out:
>        mutex_unlock(&devlink_mutex);
>
>        cb->args[0] = idx;
>        return msg->len;
>}
>
>Jiri: Is the intention really to throw away the error?
>
>Looking at the rest of devlink, all the other _get_dumpit() functions,
>except health_reporter_dump_get_dumpit(), do discard any errors.

You are correct. The -EMSGSIZE dump errors should not be propagaged out
and -EOPNOTSUPP, but the rest should. I'll look into it.

Thanks!


>
>As for this patch
>
>Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>    Andrew
