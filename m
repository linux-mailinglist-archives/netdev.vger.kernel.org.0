Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623D36696DB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbjAMMXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjAMMWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:22:33 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10516A0D0;
        Fri, 13 Jan 2023 04:19:11 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id d30so27958324lfv.8;
        Fri, 13 Jan 2023 04:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6faP50Mw9aTkvwsIWr7IMN/5yvvoVsA56UjGLQdNSw=;
        b=T5u79behWf45ObWMGY9fC6TZakwW4xkGQMVOZPlYLQcp6Wv/8zEK9n0dkiqyXJ5rQQ
         EutHUpK4KIgq4LOzlkvW7IK3Efqts8So/Fs+XDZ0XyXrSD4vcMITOnd8OrukM0cA/Fi6
         llBa8H5BVhfScoe5N9F8xF1T0JRc1Z0zK9XskhTLSV/0p4+NC79U8195Ynkw785B4A+a
         oBzIUDrsHXVxCrZp0yzoWNpf6eixVRBf1Zo+pXiKTzi2lVno/Vl0JIc4pUpQ4jo7JbGz
         jAp0dco6v+z7g7EfmXC2S/kc96uFIqcpQF27O96D9hPmNf+Uxuk49glrnLXyFTSm5jtK
         hF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6faP50Mw9aTkvwsIWr7IMN/5yvvoVsA56UjGLQdNSw=;
        b=MwZNO3oig3+h+GqG2GboBYAoshBZ4TmsVBCdY0lDUnvJlGhEwaIqtwNryHqRzewPJk
         ICCWGO9cGt/SXOsZeu+XMrvW7wqVjGZM9kfb2OmA4HYUEJJragv/DVXfg2r3kUEt9xv4
         +QxdZrPvqeR6KdthBC0DcVlIOf7oLvqmR+VzEbpgR7xUMYymYYAtXQ8avsDQfHf8hnGu
         OTYYln77/BY6pa2vYuumCs0gffZpNapKg0ohKnpuxSp1CAhkj7GmG/7eYIi8brYomaLF
         idEWgJso+oH5CwKZ2rj4wFWSJSYRCz0XiXD6oVVVZ8iQRgvTzSOaD2C0Q0Atw86nZZWT
         8pGA==
X-Gm-Message-State: AFqh2kqRDj4HzW7cV9opGp4P71D/HkDFPtcTvMVjj4gvKLPUwmaSYw3e
        xuUnKF/I35/7ee49wdDe96Y=
X-Google-Smtp-Source: AMrXdXulLYXISmUbqfDXH/p68lOOjKJLMtc39ARlb/N55OC7EYmPN8ZGLZgPFcVq3SlPHyDbwCRLpA==
X-Received: by 2002:a05:6512:33c4:b0:4cc:53e2:5387 with SMTP id d4-20020a05651233c400b004cc53e25387mr11373336lfg.50.1673612349773;
        Fri, 13 Jan 2023 04:19:09 -0800 (PST)
Received: from localhost ([185.244.30.32])
        by smtp.gmail.com with ESMTPSA id f21-20020ac25335000000b004b57a810e09sm3846326lfh.288.2023.01.13.04.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:19:09 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:19:05 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [net-next PATCH 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <Y8FMOa8ORJ8gGMLX@mail.gmail.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
 <20230112173120.23312-5-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112173120.23312-5-hkelam@marvell.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:01:19PM +0530, Hariprasad Kelam wrote:
> All VFs and PF netdev shares same TL1 schedular, each interface
> PF or VF will have different TL2 schedulars having same parent
> TL1. The TL1 RR_PRIO value is static and PF/VFs use the same value
> to configure its TL2 node priority in case of DWRR children.
> 
> This patch adds support to configure TL1 RR_PRIO value using devlink.
> The TL1 RR_PRIO can be configured for each PF. The VFs are not allowed
> to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO value from
> the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.
> 
> Example command to configure TL1 RR_PRIO to 6 for PF 0002:04:00.0:
> $ devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 6 \
>   cmode runtime

Could you please elaborate how these priorities of Transmit Levels are
related to HTB priorities? I don't seem to understand why something has
to be configured with devlink in addition to HTB.

Also, what do MDQ and SMQ abbreviations mean?

(Ccing Jiri for devlink stuff.)

> 
> Limitations:
> 1. The RR_PRIO can only be configured before VFs are enabled
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
