Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BA166463D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjAJQgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbjAJQfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:35:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF4785C8C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:35:39 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so14053208pjj.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=imLGbwIwm0VjZIX/hifXIhUImnrtfvyX5+EOl43DpKY=;
        b=JIF+L+PABWXdSLlmQb+q5Rr8nuukQOD9TTu6IN82CuHYTcMEhuqpRT4ZnbLxijfKLT
         nkGVS6C74gKRlGfqmbl+ZxTNGVFkNgsidVF5ENt4rWjO+HKKgErfpuJaoZPIgnfiubRq
         qfhKG+Am3t4JYkZb/yqhQWvyOnEDmbVdoNhtStqAt58R84/9sr0pVQDWsGjyJIFHPCcB
         80nO7F8sBCJ3hxlLZDKpPqjdwP6S8dMp11y3OtW146idtNXkxGDGJGGq+PnxjbZn2dFN
         r0al1owm8oBEFbmpX9RE7jTcb6fSD+iRPyPh+ceaMZi1a6GTU9Wnmx4v/Eh8n893XHU1
         c1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imLGbwIwm0VjZIX/hifXIhUImnrtfvyX5+EOl43DpKY=;
        b=VUSx+Lcplwb3Yw2inRLzoi4F9IDCNm8Z+0ozZO7u0kD2DdyOdG43OETfkWnBtaTocx
         /ygdcgRktAKvsdqtH9O6tUAYTbP/SkaXd1CKbIH5DX/vm4hCeHPzPZcsRzdsi/lqFJFs
         TONiXIXoNA4KdeYTfaOzi9MspnnKkEND2djRIdpK/wzPl9eP8lsULlYU2yzFgCE4rfbQ
         pkW0rO+IrtKs+tUVsO4Y7Vec6s7DX+ntshrBHQx2s2VyV3pwE0hlrFDFrnwCPd7uZejv
         w7MTN2dqJie9Na+F6v1nJx6XitQpBsLZVTQySav5BDxgqBq4muJuFB06P98lkO4ufn1G
         nOmQ==
X-Gm-Message-State: AFqh2kpyG5WwgDxr6lLQzLsuSlS5Bn9nESQkOZv3elrRMKsnsQmJP0z5
        MHFMLk7usg2mmKVgcV5D1EuYYA==
X-Google-Smtp-Source: AMrXdXsghqIr8Siz1+1yFQhLV+zeGieV6NGJ6epJ4SHntwvQjoX6YXXaPJubBQEflRnzLwj+BzWayQ==
X-Received: by 2002:a05:6a20:94a0:b0:af:e129:cc1 with SMTP id hs32-20020a056a2094a000b000afe1290cc1mr54045346pzb.27.1673368538684;
        Tue, 10 Jan 2023 08:35:38 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm6883274pgm.22.2023.01.10.08.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:35:38 -0800 (PST)
Date:   Tue, 10 Jan 2023 17:35:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y72T11cDw7oNwHnQ@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org>
 <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 10, 2023 at 01:21:18AM CET, jacob.e.keller@intel.com wrote:
>
>
>On 1/6/2023 1:22 PM, Jakub Kicinski wrote:
>> On Fri, 6 Jan 2023 13:55:53 +0100 Jiri Pirko wrote:
>>>> @@ -5263,7 +5263,13 @@ static void devlink_param_notify(struct devlink *devlink,
>>>> 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
>>>> 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
>>>> 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
>>>> -	ASSERT_DEVLINK_REGISTERED(devlink);
>>>> +
>>>> +	/* devlink_notify_register() / devlink_notify_unregister()
>>>> +	 * will replay the notifications if the params are added/removed
>>>> +	 * outside of the lifetime of the instance.
>>>> +	 */
>>>> +	if (!devl_is_registered(devlink))
>>>> +		return;  
>>>
>>> This helper would be nice to use on other places as well.
>>> Like devlink_trap_group_notify(), devlink_trap_notify() and others. I
>>> will take care of that in a follow-up.
>> 
>> Alternatively we could reorder back to registering sub-objects
>> after the instance and not have to worry about re-sending 
>> notifications :S
>
>I did find it convenient to be able to do both pre and post-registering,
>but of the two I'd definitely prefer doing it post-registering, as that
>makes it easier to handle/allow more dynamic sub-objects.

I'm confused. You want to register objects after instance register?

