Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4481523F6B0
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 08:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHHGoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 02:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgHHGoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 02:44:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCEBC061A27
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 23:44:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d4so2118610pjx.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 23:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=99iuhieWe/L7zHKJ7lGsKD7kNIDmYrR7kSmFGvCx3W0=;
        b=crTjjRenziFvlaWSoCnJBuTCuIWewgRB/A7hLjJsn9D41DqnlGdNrUMsY4KCdHpJ0u
         3riwawkxLzg2eMKh/Fiig4xU0/ZIOC7QIAiMWcvhi0wYjeNkgH/jjT2ez2XuO2RqBHYY
         gWX4DkwmlZxQPzSshO5B+KLcrB0CwDZG1h3Qo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=99iuhieWe/L7zHKJ7lGsKD7kNIDmYrR7kSmFGvCx3W0=;
        b=UoQLhoXAhf2cykR7ijLQ9tMnM4EOr6KWeCiaJ9zE0iRBiiFScylxm3KAK4uedSAk/a
         GVv3PbaKsVvrPVcTrMgyMINEuoUS8/TK2fBix02ufPiUc/V8SVgC2F22472yOiELhJGC
         4rrDRL0iBw1Eiklxc8rIrw6k1ME3MZPFgA7xRru00iIMPLOLBM6sDQBKQ32NbU5H96Jb
         TDdcr0PWpFb4GWKeW5bDKbiu/U5a/AyPvdsT1cwIXB0OZt2HhAPs6lmSoDHsRkL2ABJM
         e4I1KZwu0NwMmWo/SNogiM6nnlDhmhSKWRCGTKo0tNyicmycAB4Zs4yzMA8gdcwoHwWI
         R5dw==
X-Gm-Message-State: AOAM530eo4mms84PrMhdyzz8QyOphduhsb+wwYTUx2ObNI94EBV3D/6l
        Fv1OMH4kqeEw42Wd4wmaG1/jcA==
X-Google-Smtp-Source: ABdhPJxZx5sGSRqJh9V1gUhqIUL430IdKNSJapbHrrbhCMw9gx11vjLjPagcJCe+f1BZ1de0vAr1QQ==
X-Received: by 2002:a17:90a:3268:: with SMTP id k95mr17076554pjb.153.1596869093841;
        Fri, 07 Aug 2020 23:44:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z62sm15146509pfb.47.2020.08.07.23.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 23:44:52 -0700 (PDT)
Date:   Fri, 7 Aug 2020 23:44:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     luobin9@huawei.com
Cc:     David Miller <davem@davemloft.net>, David.Laight@ACULAB.COM,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Message-ID: <202008072320.03879DAC@keescook>
References: <20200807020914.3123-1-luobin9@huawei.com>
 <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
 <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
 <20200807.204243.696618708291045170.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807.204243.696618708291045170.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 08:42:43PM -0700, David Miller wrote:
> From: "luobin (L)" <luobin9@huawei.com>
> Date: Sat, 8 Aug 2020 11:36:42 +0800
> 
> > On 2020/8/7 17:32, David Laight wrote:
> >>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> >>> b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> >>> index c6adc776f3c8..1ec88ebf81d6 100644
> >>> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> >>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> >>> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
> >>>
> >>>  	level = event->event.chip.err_level;
> >>>  	if (level < FAULT_LEVEL_MAX)
> >>> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
> >>> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
> >> 
> >> Have you even considered what that code is actually doing?
>  ...
> > I'm sorry that I haven't got what you mean and I haven't found any defects in that code. Can you explain more to me?
> 
> David is trying to express the same thing I was trying to explain to
> you, you should use sizeof(level_str) as the third argument because
> the code is trying to make sure that the destination buffer is not
> overrun.
> 
> If you use the strlen() of the source buffer, the strncpy() can still
> overflow the destination buffer.
> 
> Now do you understand?

Agh, please never use strncpy() on NUL-terminated strings[1]. (You can
see this ultimately gets passed down into devlink_fmsg_string_put()
which expects NUL-terminated strings and does not require trailing
NUL-padding (which if it did, should still never use strncpy(), but
rather strscpy_pad()).

But, as David Laight hints, none of this is needed. The entire buffer
can be avoided (just point into the existing array of strings -- which
should also be const). Add I see that one of the array sizes is wrong.
Both use FAULT_TYPE_MAX, but one should be FAULT_LEVEL_MAX. And since
"Unknown" can just be added to the array, do that and clamp the value
since it's only used for finding the strings in the array.

I would suggest this (totally untested):

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index c6adc776f3c8..20bfb05896e5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -334,18 +334,12 @@ void hinic_devlink_unregister(struct hinic_devlink_priv *priv)
 static int chip_fault_show(struct devlink_fmsg *fmsg,
 			   struct hinic_fault_event *event)
 {
-	char fault_level[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
-		"fatal", "reset", "flr", "general", "suggestion"};
-	char level_str[FAULT_SHOW_STR_LEN + 1] = {0};
-	u8 level;
+	const char * const level_str[FAULT_LEVEL_MAX + 1] = {
+		"fatal", "reset", "flr", "general", "suggestion",
+		[FAULT_LEVEL_MAX] = "Unknown"};
+	u8 fault_level;
 	int err;
 
-	level = event->event.chip.err_level;
-	if (level < FAULT_LEVEL_MAX)
-		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
-	else
-		strncpy(level_str, "Unknown", strlen("Unknown"));
-
 	if (level == FAULT_LEVEL_SERIOUS_FLR) {
 		err = devlink_fmsg_u32_pair_put(fmsg, "Function level err func_id",
 						(u32)event->event.chip.func_id);
@@ -361,7 +355,8 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
-	err = devlink_fmsg_string_pair_put(fmsg, "err_level", level_str);
+	fault_level = clamp(event->event.chip.err_level, FAULT_LEVEL_MAX);
+	err = devlink_fmsg_string_pair_put(fmsg, "err_level", fault_str[fault_level]);
 	if (err)
 		return err;
 
@@ -381,18 +376,15 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
 static int fault_report_show(struct devlink_fmsg *fmsg,
 			     struct hinic_fault_event *event)
 {
-	char fault_type[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
+	const char * const type_str[FAULT_TYPE_MAX + 1] = {
 		"chip", "ucode", "mem rd timeout", "mem wr timeout",
-		"reg rd timeout", "reg wr timeout", "phy fault"};
-	char type_str[FAULT_SHOW_STR_LEN + 1] = {0};
+		"reg rd timeout", "reg wr timeout", "phy fault",
+		[FAULT_TYPE_MAX] = "Unknown"};
+	u8 fault_type;
 	int err;
 
-	if (event->type < FAULT_TYPE_MAX)
-		strncpy(type_str, fault_type[event->type], strlen(fault_type[event->type]));
-	else
-		strncpy(type_str, "Unknown", strlen("Unknown"));
-
-	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str);
+	fault_type = clamp(event->type, FAULT_TYPE_MAX);
+	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str[fault_type]);
 	if (err)
 		return err;
 


-Kees

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

-- 
Kees Cook
