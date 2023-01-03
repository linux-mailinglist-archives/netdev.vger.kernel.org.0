Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2465BD63
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbjACJq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbjACJqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:46:38 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B223E0E3
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 01:46:36 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so16230632wml.0
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 01:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qYTVlLqpKj7V14RVSGHObF4xif83hFaCTG42OtqQyCE=;
        b=pcYDvzaIPN5cjwp4xPbSbMa3mg2rPVtLzZmwJx2mJz0M02fNHsdqxAxxlotsQHL6uP
         8ufDZdjKp7t1ah1nAWV8bKPG67OYm4w0pTawadh/OSucf/1DOW2q+CWHqoRy9cU+xWkf
         Gz3QVEKNiucuQNDwN+KQZUzVm1IMnJ50rnEk6mVA/vLYNlVggVt6hnpRCVaLm3eBBtHS
         q50dvGwcT9QIqKHRZWZwpSN/H41lzXZbdDJuSFq4Oja+5hp8+2Dlt9xj1849PGLB1P8Y
         SWERFRNRMiUjZPUvAPpkg0FG7Pm5+Mrirva4BBWLflmyf4J5fNE8qj3xyICp5Hsh7v4P
         NyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYTVlLqpKj7V14RVSGHObF4xif83hFaCTG42OtqQyCE=;
        b=3PFPHUns7gICIsSgPWZaAKR0s6pq3ODzrW7s8CNuldgQ2XKYGvIZtHyQjahuoi8oQ3
         KDnL71Iqpt0CLVZhOTHf7UbO3aUQuHZYZp/rnYOrL4QWayW0ZGLgIqF+LjKRiH9Rb191
         Ax55eFNRkiS2gLDOhjmoJyDyFtFOrtBauop28JSb4oA4tBFKmomZdTQ0IZJwj8CfwKpX
         HDDZO7L26PjMgzocgB9Nvr8OsYVHXjD8d1LJq9k+Nu9VflnX6Ysx2O7pe3FoePMSWnUy
         MuU4FAhGjKA8KgQB5IUydmMurZuHu63AhT8PeGMBLhIEdimsUE1e/oXcMjI4jRALtsSv
         p/mw==
X-Gm-Message-State: AFqh2kpaVR8IW1B+LOnoKv2vakLejQMqc7mX3ALg3sNK4L1SIbucTc20
        8/a+FG9IuA0flKHn1vJRv+YC4/JP+ITSEL17p98=
X-Google-Smtp-Source: AMrXdXuTN9KS14dzWhFUv0sSIFQZ9EhWqeUOzhcNOLfCpSBBuvgUbA4mVeTuF9CqW2uNIHbml0OUJw==
X-Received: by 2002:a1c:7216:0:b0:3d3:49db:9b25 with SMTP id n22-20020a1c7216000000b003d349db9b25mr31891022wmc.26.1672739195029;
        Tue, 03 Jan 2023 01:46:35 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bh12-20020a05600c3d0c00b003cfa81e2eb4sm41944319wmb.38.2023.01.03.01.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 01:46:34 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:46:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 06/10] devlink: don't require setting features
 before registration
Message-ID: <Y7P5edT15cHuqk4I@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-7-kuba@kernel.org>
 <Y7L3Xrh7V33Ijr4M@nanopsycho>
 <20230102152447.05a86e28@kernel.org>
 <20230102153254.22dea2be@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102153254.22dea2be@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 03, 2023 at 12:32:54AM CET, kuba@kernel.org wrote:
>On Mon, 2 Jan 2023 15:24:47 -0800 Jakub Kicinski wrote:
>> On Mon, 2 Jan 2023 16:25:18 +0100 Jiri Pirko wrote:
>> > Sat, Dec 17, 2022 at 02:19:49AM CET, kuba@kernel.org wrote:  
>> > >Requiring devlink_set_features() to be run before devlink is
>> > >registered is overzealous. devlink_set_features() itself is
>> > >a leftover from old workarounds which were trying to prevent
>> > >initiating reload before probe was complete.    
>> > 
>> > Wouldn't it be better to remove this entirely? I don't think it is
>> > needed anymore.  
>> 
>> I think you're right. Since users don't have access to the instance
>> before it's registered - this flag can have no impact.
>
>Let's leave this for a separate follow up, mlx5 needs a bit more work.
>It sets the feature conditionally.

Okay, let me take care of that.
