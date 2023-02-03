Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523586892F6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjBCJAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjBCJAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:00:39 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F44292184
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:00:38 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f7so4495798edw.5
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOmBX+JFGzHeh3HwbWQ3WsjWoMbr/hW5pwzke5pae9o=;
        b=lhcv1O85T1j9+JkwWAs13ZEbDJMw1J/GHfnBfP9Y1Tlr7pZdw8GA5nZnOQ2Hjid1ni
         1k48+uB90Kf0vuXIK45p85TT/ksioHFUok1B6O4zY2jwVq7itola7GRbqgxt2HIVs7h8
         G4FvQH6geXL8jV+PWStFb8xCqB4x1R/ZVYoqB2qFPxeB2jw+Ck7Iru3F+ntJY3MWhUMn
         aiGCE23l6ELvO/hH8Qy3P10ReMU/+NoPVKeeJAzoVFaQFzVaqxJaLRMu034VfpffPsU3
         GUpjKK0mUiGQgyCL6kMj7eFjU0GfYgMbp4wABl77bb5Tfu/t8PcjXQaCCTHiM0OD7JR7
         pLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOmBX+JFGzHeh3HwbWQ3WsjWoMbr/hW5pwzke5pae9o=;
        b=NtO4TekHsCWMTeSwBYjYLNH24OAn9mrx4tytGsmHgqcf5640ImRf7rIxe9Q+R4f0TO
         pFtmgq+XbLKAENootAq414dnxtCR0LjGmOGXo1qUJuyRkn6SmLxXuJeCe0LjJlV+HtrA
         elbEzu2BQdacMgYw2CiZ7w+57tq0TC+kp0Rby/RT+o2w9katxY5LKoZ+Ho2lNq1c32zW
         gZ8P0eLRujFoHz9jLxNkGFAxNQEhdcGUyPaQk/TH4TtrDIn0AzjbGSSEmj0Boh//xRan
         iQxPl8JQ/j4B6WAcmEIX8bAU3I4g8UtOZVIQfUs1XRTt0CJ/zMEx2WUljsRbqooXZ/+P
         zICw==
X-Gm-Message-State: AO0yUKXLXNkc0+R/PZOJJl5Np72zcuvOzS5XveebZb1Ufr6LwkPJAgj6
        4MjKOzUA118kY17+csFAR2mc5Q==
X-Google-Smtp-Source: AK7set/cBY+YaBO8Yc+HKz4QkBw0D86mvHB1uC/RAiiKBq3J8GAf/tCJRaTK6a6X2bohYQznH/EAfA==
X-Received: by 2002:a05:6402:f06:b0:499:d297:334e with SMTP id i6-20020a0564020f0600b00499d297334emr11045289eda.20.1675414836536;
        Fri, 03 Feb 2023 01:00:36 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ez22-20020a056402451600b004a2666397casm784882edb.63.2023.02.03.01.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:00:35 -0800 (PST)
Date:   Fri, 3 Feb 2023 10:00:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/1] net:openvswitch:reduce cpu_used_mask
 memory
Message-ID: <Y9zNMqVIlW0l3kpF@nanopsycho>
References: <OS3P286MB22955AB6FF67B67778343FEDF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB22955AB6FF67B67778343FEDF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 03, 2023 at 09:52:56AM CET, taoyuan_eddy@hotmail.com wrote:
>Use actual CPU number instead of hardcoded value to decide the size
>of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
>
>'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
>Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
>8192 by default, it costs memory and slows down ovs_flow_alloc
>
>To address this, redefine cpu_used_mask to pointer
>append cpumask_size() bytes after 'stat' to hold cpumask
>
>cpumask APIs like cpumask_next and cpumask_set_cpu never access
>bits beyond cpu count, cpumask_size() bytes of memory is enough
>
>Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>

Eddy, could you please slow down a bit? Why did you send v5 right
after v4? Could you please always put a changelog to the patch
submitted to contain info about changes in between the
submitted version?

Thanks!

