Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C851BEF6A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 06:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgD3Et7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 00:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3Et6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 00:49:58 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6DEC035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:49:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so5149858wrs.9
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lcaPUyBZ3u0Hpydi0Zv3Uk1futAwlNFSZrAn8NDCYn4=;
        b=DAZOyJOTppGn5WeoO/Z39Xh56mRUAYTOEFL10CZGw6jQELPwPJHvh18EdngqmoNBWR
         1vuQWUgqsEhE9anCsROM3TRw2fMkp1zwggu+NE7QpM7bgF/Wf2DTNZ01A9Wez1BiZB12
         WtchsWxE6+vVSkn5bTQPimRqOJaM9fPt+PwDfiop9kNV02xO8QPLPsk5HV8cvMt3joQo
         GjHfjZsq1nS9LRT79QYnXFjGjpWOKT/dGI3q5DYfO+DNxlVLwo+IzszDBWfIN1rMnSRp
         hdVGRBGBVHIHKCtrLiGwor3Su1HBNwb/AUJEfkDl6Fg7hHz+ntq3GYwBvZWoIV+fKoLK
         jbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lcaPUyBZ3u0Hpydi0Zv3Uk1futAwlNFSZrAn8NDCYn4=;
        b=QiXkk0m40y26PIiL4LSVNpIYVheaFQ4Lj8oZcKiZsHnoZS7Bnb3P2FYdV4gMiJNgJS
         Q6Y+utBrpI6IuAYtMwxnrTdPiU9A5dJeLEM72e0oUB8JRc1Scp4KETq8xhTFtj28zuzi
         SOgqGcV5XjJYpyOYG8/1m+UFMwMX7+zbdePWWhUJe39EBVTqpDqA6oJF7kU3i9WBKK23
         QGK/zhKBeU6BX6LGsinwXz0qWq8yhO6ABo9eTNBSblrP2YqYRsZnydxDQpFvpVJrqq86
         r9ACjaDfLU437cAISjcDxFvm+6/tPh9yw7MTBhAG7wCDs9pjpuGu4w2Y5dhBzlndwPGO
         HKUw==
X-Gm-Message-State: AGi0PubUz3H0W5nU2MYHn7Pv1q3M1m/LgOeri6osxhkXSj2x1HkBCZD/
        RVqDydAjFSbueWq69tT3DnNTHg==
X-Google-Smtp-Source: APiQypLjiGsKd8L7X/QBYDKaGCNT6qKaIQGqCEilUXrvvVPuxRfav7TnEGEca9DvXq7J7EwRl66jFA==
X-Received: by 2002:adf:e5c8:: with SMTP id a8mr1913947wrn.56.1588222195630;
        Wed, 29 Apr 2020 21:49:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s8sm2112777wru.38.2020.04.29.21.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 21:49:55 -0700 (PDT)
Date:   Thu, 30 Apr 2020 06:49:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] devlink: let kernel allocate region snapshot id
Message-ID: <20200430044954.GE6581@nanopsycho.orion>
References: <20200429014248.893731-1-kuba@kernel.org>
 <20200429054552.GB6581@nanopsycho.orion>
 <20200429093518.531a5ed9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429093518.531a5ed9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 29, 2020 at 06:35:18PM CEST, kuba@kernel.org wrote:
>On Wed, 29 Apr 2020 07:45:52 +0200 Jiri Pirko wrote:
>> Wed, Apr 29, 2020 at 03:42:48AM CEST, kuba@kernel.org wrote:
>> >Jiri, this is what I had in mind of snapshots and the same
>> >thing will come back for slice allocation.  
>> 
>> Okay. Could you please send the userspace patch too in order to see the
>> full picture?
>
>You got it, I didn't do anything fancy there.
>
>> >+static int
>> >+devlink_nl_alloc_snapshot_id(struct devlink *devlink, struct genl_info *info,
>> >+			     struct devlink_region *region, u32 *snapshot_id)
>> >+{
>> >+	struct sk_buff *msg;
>> >+	void *hdr;
>> >+	int err;
>> >+
>> >+	err = __devlink_region_snapshot_id_get(devlink, snapshot_id);
>> >+	if (err) {
>> >+		NL_SET_ERR_MSG_MOD(info->extack,  
>> 
>> No need to wrap here.
>
>Ok.
>
>> >+				   "Failed to allocate a new snapshot id");
>> >+		return err;
>> >+	}
>
>> >-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>> >-	if (err)
>> >-		return err;
>> >+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>> >+		if (err)
>> >+			return err;
>> >+	} else {
>> >+		err = devlink_nl_alloc_snapshot_id(devlink, info,
>> >+						   region, &snapshot_id);
>> >+		if (err)
>> >+			return err;
>> >+	}
>> > 
>> > 	err = region->ops->snapshot(devlink, info->extack, &data);  
>> 
>> How the output is going to looks like it this or any of the follow-up
>> calls in this function are going to fail?
>> 
>> I guess it is going to be handled gracefully in the userspace app,
>> right?
>
>The output is the same, just the return code is non-zero.
>
>I can change that not to print the snapshot info until we are sure the
>operation succeeded if you prefer.

I think that would be clean to do this, in kernel.


>
>Initially I had the kernel not sent the message until it's done with
>the operation, but that seems unnecessarily complex. The send operation
>itself may fail, and if we ever have an operation that requires more
>than one notification we'll have to struggle with atomic sends.
>
>Better have the user space treat the failure like an exception, and
>ignore all the notifications that came earlier.
>
>That said the iproute2 patch can be improved with extra 20 lines so
>that it holds off printing the snapshot info until success.
