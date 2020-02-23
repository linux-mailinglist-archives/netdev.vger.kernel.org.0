Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B79169963
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 19:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgBWSTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 13:19:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42724 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBWSTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 13:19:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id p18so4105963wre.9
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 10:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FqHsgNFlSSHhJTOWB1G7rDoiJVu5BMqVM2zZksRNNdQ=;
        b=jSbgn2w7cVRMomeohFPnY+ivGDINUX5QQpgab5aHCquYazWZCfiXR6X9D2cF64pDA/
         sTmoA5szkmDXbs8uW46tpiPZW0nMrgkRuh7XvGiYe27YXbA2S/cd1IlNu1oLEEHtvSvI
         ken/DNbscknXxXjOuDISRVxkEBlSIgxXpk01uscWMjrhMBIBUkqaIYvfhKvxiuqX1Qah
         6UjW+Vxg2VOgoUFv/syjEBKKGHGH1CgS7hHlZbZedxfj54I8Z6zsYwGqQDNBwseOH5Vs
         /IfJGEd8T5PAMnFh/Hat/Z6ka8F/eLSGUW2MuGJC6ApE9oS8Jq4xtn1y+VIdsUW/6AnJ
         7KTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FqHsgNFlSSHhJTOWB1G7rDoiJVu5BMqVM2zZksRNNdQ=;
        b=ngypJqoxM6RZIXKp111JL7qL+279fOdtXfSNMzyA+Bq1jeqnCmfM2CH+3EG/X60zh7
         f98Ay37VkVSezPTOxhXCAp2r3pfrqvjvdkxBlsEhpIpc0+8ZGz9IO0A//RK+DC4VNDIV
         WzPXiEaiNrtT9Yc7Va0xKfowBV827dmNFCx9tt68kH/P1ovX1dOnjN1LnLgcYCV90FqC
         +q+OxLy5ohNUICqo8IDSAmF02TQXgxNICfI+q/BHpN/0cyuQmEJVdmRTGiuyFYNA/gOa
         F3Gao4/brucLnwo7kM5S0Z+q14suwFdX4PFAgGdU+NH26mJF/0DJ5g624My3hKpf3lbt
         SQPA==
X-Gm-Message-State: APjAAAUMGQYeun4gGAEYeHeiKcUy4UmRQCMS+ZjjmaHheyQ6WIrqQb3w
        gLkyOjq9SBpym/9Phu59eaP+iA==
X-Google-Smtp-Source: APXvYqzlxbuPW7iVzw2Nc2Q1NWGhU2whm7YsebgkXGuNbziiMil+HIMpmUL5LowpYE+fXL0vkQuIBw==
X-Received: by 2002:adf:e3cd:: with SMTP id k13mr37100249wrm.302.1582481975798;
        Sun, 23 Feb 2020 10:19:35 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b10sm11285443wmj.48.2020.02.23.10.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 10:19:35 -0800 (PST)
Date:   Sun, 23 Feb 2020 19:19:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200223181934.GG2228@nanopsycho>
References: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
 <20200221172008.GA2181@nanopsycho>
 <20200223110342.GB2400@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223110342.GB2400@madhuparna-HP-Notebook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Feb 23, 2020 at 12:03:42PM CET, madhuparnabhowmik10@gmail.com wrote:
>On Fri, Feb 21, 2020 at 06:20:08PM +0100, Jiri Pirko wrote:
>> Fri, Feb 21, 2020 at 05:51:41PM CET, madhuparnabhowmik10@gmail.com wrote:
>> >From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>> >
>> >list_for_each_entry_rcu() has built-in RCU and lock checking.
>> >
>> >Pass cond argument to list_for_each_entry_rcu() to silence
>> >false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
>> >by default.
>> >
>> >Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>> 
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> 
>> Thanks.
>> 
>> However, there is a callpath where not devlink lock neither rcu read is
>> taken:
>> devlink_dpipe_table_register()->devlink_dpipe_table_find()
>> I guess that was not the trace you were seeing, right?
>> 
>> 
>> >---
>> > net/core/devlink.c | 3 ++-
>> > 1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >index 4c63c9a4c09e..3e8c94155d93 100644
>> >--- a/net/core/devlink.c
>> >+++ b/net/core/devlink.c
>> >@@ -2107,7 +2107,8 @@ devlink_dpipe_table_find(struct list_head *dpipe_tables,
>> > {
>> > 	struct devlink_dpipe_table *table;
>> > 
>> >-	list_for_each_entry_rcu(table, dpipe_tables, list) {
>> >+	list_for_each_entry_rcu(table, dpipe_tables, list,
>> >+				lockdep_is_held(&devlink->lock)) {
>
>Hi Jiri,
>
>I just noticed that this patch does not compile because devlink is
>not passed as an argument to devlink_dpipe_table_find() and it is not
>even global. I am not sure why I didn't encounter this error before
>sending the patch. Anyway, I am sorry about this.
>But it seems to be the right lock that should be held and checked for
>in devlink_dpipe_table_find(). 
>So will it be okay to pass devlink to devlink_dpipe_table_find()?

Sure.

>Anyway devlink_dpipe_table_find() is only called from functions
>within devlink.c.
>
>Let me know what you think about this.
>Thank you,
>Madhuparna
>
>
>> > 		if (!strcmp(table->name, table_name))
>> > 			return table;
>> > 	}
>> >-- 
>> >2.17.1
>> >
