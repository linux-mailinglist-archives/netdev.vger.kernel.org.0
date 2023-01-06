Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E556C65FF82
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 12:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjAFLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 06:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjAFLZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 06:25:39 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367CC687AF
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 03:25:36 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso1373884pjo.3
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 03:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fNpOej0WQRYIf1vM6xEAS9yoKOpBeblZYES0x3jJjbg=;
        b=UHW3sQce66hRMaf729qKpYAcW0VMUJniGPBqK2Edeg+1upV+jjPG24z+IgMJC347+K
         JqJ8FJXsA9jYRpUDlPquqPrtog1MJgNLvYuWx9Efq2bTPVFLX5JgXeIFLQa+5O+HmIA1
         txHB/6dRCFwvbvKw0sVKv3ELWB26K7t9lbqOFE2MIEih6bRHsZT1YXpeDtpvEpctqD6/
         kCyjO/HKl2hrKYhF2UCpo2+k1Y1lFgDfk9sWh3GC0csPE7OW2FVaQ05YoiY26z9ThI8X
         /+HJmJN6DljavWRycAEU8mxm14Typx60mjiRHshGthROc26zR55SQelZOp0uVRY114cn
         K1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNpOej0WQRYIf1vM6xEAS9yoKOpBeblZYES0x3jJjbg=;
        b=eG3qiglVV/D7dm0N23LeZjf2B8A+AbTKfIO5WhglDJZDaf3IhM6r2sAi1qxsPjbtdg
         bijvSVr027A02Ozl6dqVfYQDxyKnlBG1XXz5KSax4HlmvWMxMwr3i8xdCcFWzp/w7qc5
         gefKWUdURlxOWfjeFMTwfD0V+0fQu86PtPIIAjduZzMeCEab3CA+1UQOwgymvNLfbxuy
         MJzeWOS/G+UaquXDn6BStkZFktohmD12elYBrdgWq0QP/h3U4eb56FdD2M70/5Qm+a0B
         qFatpzotPaOadpQoStZwVbEyGZDZt8HX4KpPVJ7M8A4hK3sWrxfRJCQJG/kklMc3PZyF
         Cykw==
X-Gm-Message-State: AFqh2kqcqcwgX1Z9KthdZi5jjVrQLOaBJZ/8HhMozxaL9NroWn4XmGk+
        TDt+Oq6bNLRezOgHtHSN7X00bQ==
X-Google-Smtp-Source: AMrXdXvABNY/MAbIRqnZGqNR+8aR4B8uB9a4itqUhdsH0deTlpgdokVRb67wMmZs9IomV77aIFfvwQ==
X-Received: by 2002:a17:902:8f86:b0:191:282:5d6c with SMTP id z6-20020a1709028f8600b0019102825d6cmr62989632plo.61.1673004335659;
        Fri, 06 Jan 2023 03:25:35 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902784200b0017d97d13b18sm779872pln.65.2023.01.06.03.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 03:25:35 -0800 (PST)
Date:   Fri, 6 Jan 2023 12:25:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <Y7gFLHFGQ36ZQFIP@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org>
 <Y7WuWd2jfifQ3E8A@nanopsycho>
 <20230104194604.545646c5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104194604.545646c5@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 04:46:04AM CET, kuba@kernel.org wrote:
>On Wed, 4 Jan 2023 17:50:33 +0100 Jiri Pirko wrote:
>> Wed, Jan 04, 2023 at 05:16:35AM CET, kuba@kernel.org wrote:

[...]

>> >@@ -173,6 +181,8 @@ devlink_linecard_get_from_info(struct devlink
>> >*devlink, struct genl_info *info);
>> > void devlink_linecard_put(struct devlink_linecard *linecard);
>> > 
>> > /* Rates */
>> >+extern const struct devlink_gen_cmd devl_gen_rate_get;  

The rest of the commands (next patch) you put in a different place, so
this is alone here.


>> 
>> The struct name is *_cmd, not sure why the variable name is *_get
>> Shouldn't it be rather devl_gen_cmd_rate?
>
>It is the implementation of get.. there's also a set command.. 
>which would be under a different index...

The rest of the commands (next patch) you omitted the "_get" suffix.

