Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC828534E90
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343943AbiEZLrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347335AbiEZLri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:47:38 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64196E15F7
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:45:53 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id q15so1468265edb.11
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfOErO6fy5eTpl/9iS2Cw+n8TwvhSHjdW06lieV7SLY=;
        b=2IogySvh3904IgW4sh9keQoRrbHzUSW8lIMvNWmnC+KcY/q/Hx6PARA4A/kCVAmNOL
         ohV57Si3W4lnVH1cNkNYU0JUIRBt7GEuhgyuHD3NpyAY+24EU4TZrhV/N+NUcUKllnCk
         X1SfXyOI0xFdf/nv0Sp2Wrc2W6t+28oX2ULQEJJdB0sCePBtu3optM9v0kAjFBoAMxs7
         7Jga3vfPhn9wAoaOa2BInMIY2gZ7bgjXO9BxSYwKoR6DMpiegZ1c0AZR5/nVrKK2k0KY
         kduFcJaV4pT8eOonXk9BTSRyOZwaBH8O1wn76AWBE2sLpibMmcL6twWGM3AjOC27cqhE
         e91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vfOErO6fy5eTpl/9iS2Cw+n8TwvhSHjdW06lieV7SLY=;
        b=AHAnRuGuWEI4vr1zJ5ii7OPCu/NQGtzUIiO1qT6ztoT11sCa5CG2+fLPmnPe8bvw0U
         uB6bNAQoxszuR1sypuHJi6IdpdWl0u89tFejPRIRADj9WndxljTd2+R6eeRlGbRDnAF4
         KQLsgVCXcZlM2lxyGt7A/HChsd1QD1e4N/ToeZjM+DVnkxxiu3apaWDTx6wT97lE/v/a
         lb34PRMpLBtqqo7cfkSGlDj5SqMiXrIsqkLpJCnK9v4B7K13gWR101Zhv1uLn2c31AsY
         G6Fj7Js3OueSqA8icSLvVl9ERJV4+KtiAqDV7NxvLJBuAuefTh25Bs8sLsMC+3iNlSQ3
         +Rfg==
X-Gm-Message-State: AOAM533PkzWhOsbEilWeDb3+Hv+TtOjQmUU+ZEQordPyoMgSFtXPnCjf
        ZiH/UrBQwLM6MjKbm6S9Mo/WH46YIXwxUI3Tr0Q=
X-Google-Smtp-Source: ABdhPJzuYDQc6TahHsPw9MD4zjkrxxQy4KEpb/rzsYRTgHJNHkk7vYMylwFBp2DK71r91vkBeACl8g==
X-Received: by 2002:a05:6402:3289:b0:42b:4d05:ac85 with SMTP id f9-20020a056402328900b0042b4d05ac85mr25239699eda.106.1653565551711;
        Thu, 26 May 2022 04:45:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id mu31-20020a1709068a9f00b006feb875503fsm449076ejc.78.2022.05.26.04.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 04:45:51 -0700 (PDT)
Date:   Thu, 26 May 2022 13:45:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Yo9obX5Cppn8GFC4@nanopsycho>
References: <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <20220524110057.38f3ca0d@kernel.org>
 <Yo3KvfgTVTFM/JHL@nanopsycho>
 <20220525085054.70f297ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525085054.70f297ac@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 25, 2022 at 05:50:54PM CEST, kuba@kernel.org wrote:
>On Wed, 25 May 2022 08:20:45 +0200 Jiri Pirko wrote:
>> >We talked about this earlier in the thread, I think. If you need both
>> >info and flash per LC just make them a separate devlink instance and
>> >let them have all the objects they need. Then just put the instance
>> >name under lc info.  
>> 
>> I don't follow :/ What do you mean be "separate devlink instance" here?
>> Could you draw me an example?
>
>Separate instance:
>
>	for (i = 0; i < sw->num_lcs; i++) {
>		devlink_register(&sw->lc_dl[i]);
>		devlink_line_card_link(&sw->lc[i], &sw->lc_dl[i]);
>	}
>
>then report that under the linecard
>
>	nla_nest_start(msg, DEVLINK_SUBORDINATE_INSTANCE);
>	devlink_nl_put_handle(msg, lc->devlink);
>	nla_nest_end(msg...)
>
>then user can update the linecard like any devlink instance, switch,
>NIC etc. It's better code reuse and I don't see any downside, TBH.

Okay, I was thinking about this a litle bit more, and I would like to
explore extending the components path. Exposing the components in
"devlink dev info" and then using them in "devlink dev flash". LC could
be just one of multiple potential users of components. Will send RFC
soon.
