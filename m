Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52677689EE9
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjBCQHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjBCQHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:07:42 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B75C9F9CC
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:07:40 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id qw12so16699901ejc.2
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 08:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mv4Tw1a7+WNqMwMi9Hb0edTB8YtKReMwtw4zFtjDKg4=;
        b=Yi+DtZuGbq9lNYTtwtUMgdX4orJXwFHGCuZOGAggaZ6AMB9WVXAlZGRXWZ1ea+o33k
         3WO7IUmfAi0ndihbkUrgb2nwKe03OIw7uqO7Yzhccea3hh9apwGUf2yhUfDjD+hDMWpd
         4XqT7KiqlOiBfabZARxQ5dVT+DdakSaXhBbb2FrRJ9EX74iUHg9cKSnZLI+iUEHXDudX
         W4jYra2EiCV0BJpx05yrVFhh+cdO40eGpvKDEf7iyrEVnVsLaZ6mQMhJ/rlriDmn5XJ0
         +Qs534qGEODd6SFYaOs18BsHuMrhoVczZuQcJ1BGCunhgw+6lj7IiRb7k2eg5xSqbC+x
         ba/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mv4Tw1a7+WNqMwMi9Hb0edTB8YtKReMwtw4zFtjDKg4=;
        b=Sz881I+QtEE2MDzlRqfhwMIFi4pLp48p9YWUp1BMVnApP8k5idL3CkK3Uix+04Zp4P
         9VZvOAtegvfxToae/pivNOzhLS9hkg1PgsxhRo45WvLzRheKzMYFvTUV+ZnfY7wXI9Dy
         UHwlj10fs7LVp+mqAMocWRjLDlA1O2aGiTiyiJJ8AD9WMdpwkCnDMHG8M5SbQs8i7CMW
         5u6nPJzYMS7rYnkVvaxxuYLtAEAFn7wogAMpR3Cy1nJ/t4XIG5LCyd90DSD4HJkSBWrk
         LaeWegmSU421v3WnWdJ8hX3OiX+1jhuY5Sp93Ja8/pxdyRHMiu5h5mH8govTYY52Aexp
         UyQQ==
X-Gm-Message-State: AO0yUKVbcDwTzsauEb2QHN03qx4eHxnAYRQV1ekwZwZSyGldguwgoUw1
        oBeIbosCnQGVSaMfTAh9tWeC+w==
X-Google-Smtp-Source: AK7set82A9Kb0hwNrj1M0to5qoC8vv2uCV2EiO8NNND3SgDSYSico/58trjpGYHNR6i0MUj3s2K1vQ==
X-Received: by 2002:a17:906:8da:b0:87b:db53:3829 with SMTP id o26-20020a17090608da00b0087bdb533829mr10690486eje.46.1675440459116;
        Fri, 03 Feb 2023 08:07:39 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709064bda00b00886c1a02d20sm1560622ejv.47.2023.02.03.08.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 08:07:38 -0800 (PST)
Date:   Fri, 3 Feb 2023 17:07:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     =?utf-8?B?6Zm2IOe8mA==?= <taoyuan_eddy@hotmail.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?5Zue5aSNOiBbUEFUQw==?= =?utf-8?Q?H?= net-next v7 1/1]
 net:openvswitch:reduce cpu_used_mask memory
Message-ID: <Y90xRInJeyuNA6RT@nanopsycho>
References: <20230203095118.276261-1-taoyuan_eddy@hotmail.com>
 <OS3P286MB2295DC976A51C0087F6FE16BF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <ECDAB6E2-EBFE-435C-B5E5-0E27BABA822F@redhat.com>
 <OS3P286MB22950F0D26C1496D1773B172F5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB22950F0D26C1496D1773B172F5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 03, 2023 at 04:50:31PM CET, taoyuan_eddy@hotmail.com wrote:
>Change between V7 and V6:
>move initialization of cpu_used_mask up to follow stats_last_writer

Okay, please stop sending stuff and begin to read.


>
>thanks
>eddy
