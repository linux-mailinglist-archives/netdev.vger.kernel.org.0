Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8057E660D3E
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjAGJVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbjAGJU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:20:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC238463A
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:20:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so7527720pjb.0
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TeWzdmWS75kiKb/+dm9GNBoHP1/5T3qxY8e5eVBdqNY=;
        b=byJ3eNk8qU6cJ89qFyAGphuKRhuQUcHg/3kE+RjVQaVIb8MXQkfPGKo+Y+1BDFipV8
         XHOj9qc+SniodY1aQ7i9IjUfJ5Fz8Fs4p0TQXXgSNG2HLNPVgGk2+CFsITCzGrcFso4E
         yK8mgOLIs2yY5uPxS0Qd0d5vzcm0K7MbOLsKatFdd1gO1bou/ZjpuCuBAr1VJ4eTKa9m
         EnjPEhWKedw7ryD3FlqikRg/d+6VxGYIUISpqotIx8ds4gxa0PsNbp0ahigui+azGGvU
         aOFTAXWfw++DBYnA/ogD+9A/IgfRuYiOWih4c//ZAzU9cvgaPLFmfXRCUGsdNeOlGtHG
         J/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeWzdmWS75kiKb/+dm9GNBoHP1/5T3qxY8e5eVBdqNY=;
        b=dJCZ8ZueKWHMqBwZbMrMyLsSGa52rLZazY/9doh6LK6Uvo/4FG3SU0IXJXyyp4m2bi
         hciBsnTOpLb8Kg/ZWKx+ujhS5ml3+InLlpDNhA2GtHtpDpzN/dDAZCf4CsgLifsI2pkH
         9cvPd3crXkdmmF05as26tvk7hC7dxtGyObz3t9MqwXI0k5AtIh4o1Qi8tHQ7LM7VilrW
         pSAoSsPMKkPVb26Q84otNog/4cNjMkFA651Jf8ij0g3OHZrk8Z8Cwhwg+WZJzgTygSrJ
         Bq/7Vr4i7me2VdKHd3hYv1gQFMNEYU1SDWm95drJ+bPJlCGK4S6BVtzBoAngSr5vRMGZ
         8IYA==
X-Gm-Message-State: AFqh2kqGYj7Jltr7n67Dgi9JL869j4hnVXIqAY8Fy+KTXYpbNfAVdKju
        P5I6UeDTtlVj1xCSrBiuV+TESg==
X-Google-Smtp-Source: AMrXdXvuOjYhunuF7z4xGh3yMLT9mWff3ZEqckF0DK+pxfjXyMneJOFRjJHtPTdujAcVK1z6j0mbWA==
X-Received: by 2002:a17:90a:c24a:b0:225:f3e6:424e with SMTP id d10-20020a17090ac24a00b00225f3e6424emr44606945pjx.17.1673083217031;
        Sat, 07 Jan 2023 01:20:17 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id z3-20020a17090a170300b00225e5686943sm3972385pjd.48.2023.01.07.01.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:20:16 -0800 (PST)
Date:   Sat, 7 Jan 2023 10:20:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y7k5TWKqvMrfjEfV@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org>
 <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106132251.29565214@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 10:22:51PM CET, kuba@kernel.org wrote:
>On Fri, 6 Jan 2023 13:55:53 +0100 Jiri Pirko wrote:
>> >@@ -5263,7 +5263,13 @@ static void devlink_param_notify(struct devlink *devlink,
>> > 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
>> > 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
>> > 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
>> >-	ASSERT_DEVLINK_REGISTERED(devlink);
>> >+
>> >+	/* devlink_notify_register() / devlink_notify_unregister()
>> >+	 * will replay the notifications if the params are added/removed
>> >+	 * outside of the lifetime of the instance.
>> >+	 */
>> >+	if (!devl_is_registered(devlink))
>> >+		return;  
>> 
>> This helper would be nice to use on other places as well.
>> Like devlink_trap_group_notify(), devlink_trap_notify() and others. I
>> will take care of that in a follow-up.
>
>Alternatively we could reorder back to registering sub-objects
>after the instance and not have to worry about re-sending 
>notifications :S

Hmm, let me explore that path. Thanks!

