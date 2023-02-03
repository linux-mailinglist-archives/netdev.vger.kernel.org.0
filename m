Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977356892F2
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjBCI6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBCI6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:58:52 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3696EAE2
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:58:43 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m8so4469382edd.10
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UrKNzsUVRho2VPkIQDrxJjyVZbC45qulXjt40NBXOCY=;
        b=1qxhRJKdhBwjmnbUQCjvkTIqy+DIXgYcnTUInPcwNJNHiqnxehLDkylZ11KgLmyLY0
         KTVHibKLVWruApO41J2c0AGiL+DD5CEv1839xbevLaebJYfA9pnyIK8QofHeQkjAkPiY
         W6p2n07zY5QQxycxFkTqgAGlsZtphzC9wmrSg/xOhXOMlWS+kMqyilR2TnwIF/uRrpzF
         J+DAE3IB6RaQNArM8nL8wXASUy45Ob2gMUmOGRac3BvRYwPWnSrzGd4XlGEPplLgWUsS
         ZvO5PY8HCfX1GesHijSsPfB3g5eZE28PIiwPUM6NNjiuCmrxxha4omgXbX+AWBb6/fNg
         LR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UrKNzsUVRho2VPkIQDrxJjyVZbC45qulXjt40NBXOCY=;
        b=yzh29n80qEnz1pMxOU3oI/9ULDWFG2fi3ZQAJXzQMM2tawAUV49NPMJLKn46OeOequ
         TLxykfZk++Q/sDMKHRML1ugD/Aj2hqVImSQ+H5idH6RHUJCniQIp/V6W2gJNwrXHqRP5
         reHUFPqojOVNMPI1bXgRZcU973+3hustWHNpfgwCZap1We7AeFoyb2N2eOS9xjokkZ6Q
         UGP5ahEkkO7H+XfKs/nIL2/q85TkFfRYxO4wG4LWVlxag4/YwhqiOcf/3Iy18e6IvNH8
         w25Qin210B4ehnhe1vARL60x4CQk8r0QZxEAU3dCv07wPojAXjNHES9EbvXlL/XJEcyX
         rFcw==
X-Gm-Message-State: AO0yUKUKALxvaXeHIGFdpGno/9jUAhC5y0kpSonIqehRRIh+/6Z9D4ww
        HW0IMvaDZy8itcuKCsstlrzzDg==
X-Google-Smtp-Source: AK7set9DVM2F8SyiwhmoC06UhXUiEphbR5K7mjObD3ixKUservxkmS/RnXN+yODQsd8IKK0cgbwSog==
X-Received: by 2002:a05:6402:176a:b0:4a3:43c1:8440 with SMTP id da10-20020a056402176a00b004a343c18440mr3694996edb.20.1675414722367;
        Fri, 03 Feb 2023 00:58:42 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o11-20020a056402444b00b00495f4535a33sm796499edb.74.2023.02.03.00.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:58:41 -0800 (PST)
Date:   Fri, 3 Feb 2023 09:58:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/1] net:openvswitch:reduce cpu_used_mask
 memory
Message-ID: <Y9zMwA2pxSpdUdT5@nanopsycho>
References: <OS3P286MB2295CD8900C8D4E701E08B4DF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB2295CD8900C8D4E701E08B4DF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 03, 2023 at 09:40:36AM CET, taoyuan_eddy@hotmail.com wrote:
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

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
