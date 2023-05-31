Return-Path: <netdev+bounces-6687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB427176EF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEF171C20D64
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73CEF6FB5;
	Wed, 31 May 2023 06:36:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B201879
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:36:30 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F9E99
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:36:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-307d20548adso3732922f8f.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685514987; x=1688106987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=42zFtfX3xhWSol7+Kv8vrSNR4n2kl36PeEzSrRGbTx0=;
        b=c/CX5wlZOOAB53sh5vlrksw6qhZlD23X3UjlFa74AGb6lIAI77B4Lu4lvDgjPFZ9CS
         ACavdTkqu5fikD5MamPU/mcetlkFb1ZBXH8Y3Ua+PNAsXZHSWOQ2LuWA5dBZ/yOwCpiA
         /EjfP1p0KlMRZXK1V08ftlqLMKTT/F17HSlBTiz93OO0mxGmRnzbth0Rzg26aea173y2
         y7g+uezL21TtzmtBk0IqObtVfQnb6kwb8kZXLce0UIZKMjyZtGVmKAimL2AYJe9yn7cl
         23LACF5wXcT9feRMySG0q7Rh1nE17K1X/kKl3qpQPb+QIO2ssWS8zU/QQpGzJktISa3x
         tXKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685514987; x=1688106987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42zFtfX3xhWSol7+Kv8vrSNR4n2kl36PeEzSrRGbTx0=;
        b=RoEaiVetEpZFSXbSkSvuyW5h9E9oF1uEKStjbm3HUt4QFIqHHNY67d5EBm8X5qNL4z
         nZQjJ2T1CDGYthQOMxsfyKWVuXRcAtFLyDzr8z+A+e02oxlHtyqam11BeXV/Anq+1xcA
         mxynGEX4f+8ctheU42KbwqvfyYA4Vu20ysBaObGjEShz8PYG9UX/jlJxj8gUJdy9iafG
         F9wMJoBXF3I6FmdU5ZNUsFdCGfkUKod+Z1w/VLenaiRPDm87r/nsdiBUvAdjGf+WmvPE
         Ko/ZsPNj006pMGKykY5OA6qpZYPjw1zAnOUDkDPxDg2glpe4Z1cdaWWeQWfRT/Ou8kRh
         voeA==
X-Gm-Message-State: AC+VfDzxn+UfoB8wMTRLbNX/GcwU1OCiLMz2H6uTMdbKYg2yb8rbLy97
	JljxG3TKBmj+hMKkMAEFnd9jXg==
X-Google-Smtp-Source: ACHHUZ5EUGEwOFJgLuFxiXQw/g7+JQsqv5M421yXN998tVnEl5FRIUrOUaK/taXFjbD8rWSKAYPXLQ==
X-Received: by 2002:adf:e6cd:0:b0:2cb:2775:6e6 with SMTP id y13-20020adfe6cd000000b002cb277506e6mr3290836wrm.45.1685514987388;
        Tue, 30 May 2023 23:36:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d4a04000000b003079c402762sm5550864wrq.19.2023.05.30.23.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:36:26 -0700 (PDT)
Date: Wed, 31 May 2023 08:36:25 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, saeedm@nvidia.com, moshe@nvidia.com,
	simon.horman@corigine.com, leon@kernel.org
Subject: Re: [patch net-next] devlink: bring port new reply back
Message-ID: <ZHbq6aH+S69heG44@nanopsycho>
References: <20230530063829.2493909-1-jiri@resnulli.us>
 <20230530095435.70a733fc@kernel.org>
 <20230530151444.09a5d7c1@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530151444.09a5d7c1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 31, 2023 at 12:14:44AM CEST, kuba@kernel.org wrote:
>On Tue, 30 May 2023 09:54:35 -0700 Jakub Kicinski wrote:
>> On Tue, 30 May 2023 08:38:29 +0200 Jiri Pirko wrote:
>> > From: Jiri Pirko <jiri@nvidia.com>
>> > 
>> > In the offending fixes commit I mistakenly removed the reply message of
>> > the port new command. I was under impression it is a new port
>> > notification, partly due to the "notify" in the name of the helper
>> > function. Bring the code sending reply with new port message back, this
>> > time putting it directly to devlink_nl_cmd_port_new_doit()
>> > 
>> > Fixes: c496daeb8630 ("devlink: remove duplicate port notification")
>> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
>> 
>> FWIW it should be fairly trivial to write tests for notifications and
>> replies now that YNL exists and describes devlink..
>
>Actually, I'm not 100% sure notifications work for devlink, with its
>rtnl-inspired command ID sharing.

Could you elaborate more where could be a problem?

