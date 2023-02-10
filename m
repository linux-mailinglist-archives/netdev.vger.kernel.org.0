Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A7769196E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjBJH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjBJH4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:56:48 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A907B147
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 23:56:39 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id u10so3172563wmj.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 23:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CplsE+WPQOR47gOoL9DQQjcIJFO+isj8JIw4Fkmc+k8=;
        b=vmIARoe4f6daatXyWItxOCPk8NXqjxbVOAqIieV+wWKXW5+7toJzu1oIj39rMwhfLq
         inQJ2ap5JNOZCxyLy8byl4Rhy/mTY7ha+b3ED4hVnSE2BQJ+kJs23m4CAREwE9R47Cc7
         wLsoXk8J2+0s5ceJx0AtgN9iwWk9QL0ZMhwSlgvMjrqvJP50yriUPd9XkvWjHFWusLYZ
         lms/JA07fnujyVphN5JybTDRXNPDw7VFEyzvRhnS0qvHq2+iteClSo9Dn5kcHiUTIC6h
         ufhisyDvO8hHjCJvsVcWLvTL7YyDlrsjFfmL1k+toZflAiTNhmDWanVj+kW5gJLfZ+6P
         66NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CplsE+WPQOR47gOoL9DQQjcIJFO+isj8JIw4Fkmc+k8=;
        b=7ndjFUZ8SubpJEweEl/aaCEWQ660l5/2nh+miAeIjd4YJcaNpJvbJK4w3Zf0SoHRaF
         GVJ5H24L15L3J838uOpqV4iXKCH17lpx9OKDfRjEl/TjRCVkL6YLXCyJ+AUvST5YCqHo
         yqwwQJgxufJKk5CPeJ/5jqOx8SEbBlmXh74qWg5TQjSYJSPmkd98/EkWi/j3b0N6f7py
         gfxnDE4ipT+OBmTe5T0zSzgzhIsW0ltR0Pp/ZKks4L24c7GiAU08Wy8sZ97G/JF4lfFN
         ExfvUBFMZ6rCfpDw1Lh+QwDDUtWcUbDq0cqXA2HGICli1t4PGNvA+huCwVqC6MiMEc44
         36wA==
X-Gm-Message-State: AO0yUKW+ZA0lxGj8HUE6k47fkgCvrchboolvb695GBI/zYZxD+8waSBd
        gr75ygii0qVQZepqOEJ+vKQggQ==
X-Google-Smtp-Source: AK7set/raZvh5gAbT2+k+GADeSGCzzH3lYSj70Q4OHpAoKRGoXE76hziXJMHOo5EkVkoDNPUGkNL3Q==
X-Received: by 2002:a05:600c:180f:b0:3dc:557f:6126 with SMTP id n15-20020a05600c180f00b003dc557f6126mr15286307wmp.4.1676015798179;
        Thu, 09 Feb 2023 23:56:38 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c4fd300b003dc59d6f2f8sm4245296wmq.17.2023.02.09.23.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 23:56:37 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:56:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
Message-ID: <Y+X4tM/AtXYkWKEP@nanopsycho>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209205309.57e75fdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209205309.57e75fdf@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 10, 2023 at 05:53:09AM CET, kuba@kernel.org wrote:
>On Thu,  9 Feb 2023 16:43:01 +0100 Jiri Pirko wrote:
>> The primary motivation of this patchset is the patch #6, which fixes an
>> issue introduced by 075935f0ae0f ("devlink: protect devlink param list
>> by instance lock") and reported by Kim Phillips <kim.phillips@amd.com>
>> (https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/)
>> and my colleagues doing mlx5 driver regression testing.
>> 
>> The basis idea is that devl_param_driverinit_value_get() could be
>> possible to the called without holding devlink intance lock in
>> most of the cases (all existing ones in the current codebase),
>> which would fix some mlx5 flows where the lock is not held.
>> 
>> To achieve that, make sure that the param value does not change between
>> reloads with patch #2.
>> 
>> Also, convert the param list to xarray which removes the worry about
>> list_head consistency when doing lockless lookup.
>> 
>> The rest of the patches are doing some small related cleanup of things
>> that poke me in the eye during the work.
>
>Acked-by: Jakub Kicinski <kuba@kernel.org>

I will be sending v2 soon with Simon's nits resolved and also one small
fix. Thanks!
