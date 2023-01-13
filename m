Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C43669A42
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjAMOcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjAMOaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:30:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2468984BF2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:24:02 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qk9so52714182ejc.3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFWmtyQhElMhZAYSojhKA2ROPpgJjvj4dvpPl9hdXjY=;
        b=E7aUi65aUCOgFHXorSvBoiMbh7mSNL7+sSuz5Odm82Va7d1zvN1AE61Sea3s6aSmTG
         PC6zu2dR5Kc6NPyv2fPBCh7A7o1sF4kxqkL8N71mT4WEOs64YXD9O0DksMHUZX7iDUzD
         bLFOWwLkSXCzrX8BRfKfpxsjhRTwqw+NNvvx3aWNEGW3sdfufBLxr2F9J98Xitz/80BT
         AeMygmI420My4a/C+9Vyi+dDMci4utOnbx18BjEmMfpqO2GAnSCHQb5yEuaWKF9+u0iA
         dZBXtW7S08hI9xIP12pSrRo/HP7him7J0jGBdK7GXgWuAwXTNn/tr1g2tJ5hwsbJzAX4
         WHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFWmtyQhElMhZAYSojhKA2ROPpgJjvj4dvpPl9hdXjY=;
        b=IuocrDDaYgpKx1AZUrSWmaWvtjredjFRXxFxNCab2FPCRrCkA1JE837JcnvglGcFt2
         Svlbf+DpISLSwhjI8GgmMBuBzRfI+0r3dX55SiJWdUsFDRgy4DwswMWD3Gok8l0viiiY
         PjHyErmgZEChZvE88lyo9UlOjrNvLJvLYZ/Eic+CbcP4ph2BLs+r3+aEegcKvcMQwp2E
         vSC8Dama30BujmHALy4azIjEkHD2CbyzSVHM159Ms4mxTNw8nQhTwOSjf7zzjRxxfJgQ
         XVoh1KH1PLgYKdSgJSBB/TukrHBlaDRjWSUNHm4Cj3m/fojvG5VUlCvyi5Tqy+l1P5vp
         jYIA==
X-Gm-Message-State: AFqh2krBN9gFiui5uJ5Jn/aXKpmb4sirz74AFCJjFtCyo5hKGeVRhWkG
        3mzXHzv6BI60XzK0n8l5yjQJyw==
X-Google-Smtp-Source: AMrXdXtE2dVLO1eSUmSGE5p02FSwCFLQgDLNRaAlZDKUOXmV6dCPGEhcMukCfg4ImUbKMTd5FScnpg==
X-Received: by 2002:a17:907:c28b:b0:84d:12d8:e1e9 with SMTP id tk11-20020a170907c28b00b0084d12d8e1e9mr16268503ejc.41.1673619840649;
        Fri, 13 Jan 2023 06:24:00 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id kw17-20020a170907771100b0084c4b87aa18sm8599805ejc.37.2023.01.13.06.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 06:23:59 -0800 (PST)
Date:   Fri, 13 Jan 2023 15:23:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [PATCH net v3] sch_htb: Avoid grafting on
 htb_destroy_class_offload when destroying htb
Message-ID: <Y8FpfgtgG0yxApjC@nanopsycho>
References: <20230113005528.302625-1-rrameshbabu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113005528.302625-1-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 13, 2023 at 01:55:29AM CET, rrameshbabu@nvidia.com wrote:
>Peek at old qdisc and graft only when deleting a leaf class in the htb,
>rather than when deleting the htb itself. Do not peek at the qdisc of the
>netdev queue when destroying the htb. The caller may already have grafted a
>new qdisc that is not part of the htb structure being destroyed.
>
>This fix resolves two use cases.
>
>  1. Using tc to destroy the htb.
>    - Netdev was being prematurely activated before the htb was fully
>      destroyed.
>  2. Using tc to replace the htb with another qdisc (which also leads to
>     the htb being destroyed).
>    - Premature netdev activation like previous case. Newly grafted qdisc
>      was also getting accidentally overwritten when destroying the htb.
>
>Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Maxim Mikityanskiy <maxtram95@gmail.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
