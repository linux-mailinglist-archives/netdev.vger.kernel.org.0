Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97404F9D4A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiDHSxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiDHSxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:53:34 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CCA24507A
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:51:30 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e2a00f2cc8so1195608fac.4
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 11:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xJPDHBk7FtJEnzCFaDHcsNDwuqh3fcyrWKPXJqwOzLA=;
        b=B99VI4pEqZHBz/5XqHeMiP66YWfYaSEIHsP7KMZcIyWT4h1MO4WQ92SQydG3GP3tE/
         ZaI73tGjEZxg1s4qpVlsbEhtVgsiWXG7JB0rq60eJQlYrYxOO/np3pn900ELG57ItDOb
         8RddYi8kJJ6n7u8dPvyvkBxH8+fS1OZlbd/bUm67z+9WqLIlECPPMKUepij3xgVQnXMy
         YBzvt/4ckMPfxSx+6o/4QWRhuBfSAjY2d+FL6JXgPsywQbY6AaGHEOKHuhBYx3FXl7nF
         7EdCmxSIFY4Lm1raLXGMRUPIrAQ7YBpos8iscLEK4fATlr0wpTBB7Fydv11OBecU7RDJ
         LCLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xJPDHBk7FtJEnzCFaDHcsNDwuqh3fcyrWKPXJqwOzLA=;
        b=hbjF3DagYECFCMuhoq+TLaQCDMZs1Ady4B6pLqAPn3ak07kWWgfsYwTHpzF/5/VRVE
         yc/AIAfn/zXwmP/vyNvQuFaLMiK9fFZuxn6cwWYRo5RzHT6qdRL/vJ+FRQNVM2jMBp3W
         bltsGFuShNdB4Nick88guCCAVf8UDzIjTLlNiuJ5wwGvuSVpZ4WATnVY+pzBo6a7tCaG
         tel5fsC3ixz6PjS62BVig/wtoTFHPgzhZulZ8KTV8x416YErCpe77Peisfc5MtyB84vm
         uizqP6wNemz8NRnxx6mpZ8279zZTvrkO9fDum/3P2S2kVf9kmPQYYWQHND7wQGM87V47
         cRoA==
X-Gm-Message-State: AOAM530mbHoYd5cTelaviJr8S8ytGEGSkG8Dc9mIboXYJdOpfrywVjea
        dU+wos5RDao9ntFVsULam9MAjukvXxRFAQ==
X-Google-Smtp-Source: ABdhPJzSLHmlHIt+vs+5yYUcCy7r1nN5wwghTB+QZcvATpOt94qis/E9co9Ml3hbteNwawst8K2/+Q==
X-Received: by 2002:a05:6870:e2d0:b0:e1:e588:fc22 with SMTP id w16-20020a056870e2d000b000e1e588fc22mr9554418oad.219.1649443889571;
        Fri, 08 Apr 2022 11:51:29 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f016:143b:3e81:1765:8b0b:dc3f])
        by smtp.gmail.com with ESMTPSA id m15-20020a9d644f000000b005ce0a146bfcsm9202740otl.59.2022.04.08.11.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:51:29 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 20B391DFE41; Fri,  8 Apr 2022 15:51:27 -0300 (-03)
Date:   Fri, 8 Apr 2022 15:51:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, petrm@nvidia.com, jianbol@nvidia.com,
        roid@nvidia.com, vladbu@nvidia.com, olteanv@gmail.com,
        simon.horman@corigine.com, baowen.zheng@corigine.com
Subject: Re: [PATCH net-next 00/14] net/sched: Better error reporting for
 offload failures
Message-ID: <YlCEL1tW8lu0yRtC@t14s.localdomain>
References: <20220407073533.2422896-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 10:35:19AM +0300, Ido Schimmel wrote:
> This patchset improves error reporting to user space when offload fails
> during the flow action setup phase. That is, when failures occur in the
> actions themselves, even before calling device drivers. Requested /
> reported in [1].
> 
> This is done by passing extack to the offload_act_setup() callback and
> making use of it in the various actions.
> 
> Patches #1-#2 change matchall and flower to log error messages to user
> space in accordance with the verbose flag.
> 
> Patch #3 passes extack to the offload_act_setup() callback from the
> various call sites, including matchall and flower.
> 
> Patches #4-#11 make use of extack in the various actions to report
> offload failures.
> 
> Patch #12 adds an error message when the action does not support offload
> at all.
> 
> Patches #13-#14 change matchall and flower to stop overwriting more
> specific error messages.
> 
> [1] https://lore.kernel.org/netdev/20220317185249.5mff5u2x624pjewv@skbuf/

Seems like tc is almost becoming user friendly!? :)

post-merge review FWIW,
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
