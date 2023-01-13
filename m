Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35966695BE
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbjAMLhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240935AbjAMLgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:36:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446CB6542
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:24:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o18so976511pji.1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nOKltmOsXPyNKe1uYloIrl4n+T0JFIJ4CzRVVMvS6LY=;
        b=ettxfXGGn22lN/zb8s/n80BHiUp/+R30ro+s/M6ULXIpdz2kiSFwSTHgDOazEZpVnn
         q42D5X89VZ+nF0QF9yIHFVFRboLt+XLTIhjHTUSCSz8I21vvbBUovrNCPxnrNgxPO/kL
         amMeBR7KbhPFoRBC91Xqfkc0lvWrE0dGej0ySjYFGV2OzYwVxy0RVhMAPvkXxQsEkX5t
         viMVllRet7rixd6YgoE3P14qgHYxkI+F0XJmG/BTGthGhbB9ro09MZ8LAmpCwnV9pm7K
         TwHkfulI4/QWqDLeMM0vPSRrOzeGmnQd/QxieJ53awM+SBvJn2NT/seNB/sRFdGjmKS6
         0zxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOKltmOsXPyNKe1uYloIrl4n+T0JFIJ4CzRVVMvS6LY=;
        b=npGxBJ0ysYD3lz1AgQxJTiCcJ6WIPv7KeSB/KfutnfXA50cplS2lux0fbdcm5dGbX4
         OyaPrlO6qbLl1dUzA2OKDddiru/59ybcI7HkQQryHZueTGbCjsdjPbxA77uailu29al3
         lHUVviNm1lZi+ARnBuco3NAeS0/9t5GegPbsi9CI+tnlCOwhJU8QzwSwZP+rAA7Gu20s
         SXzF3riBZtF2uGEeLpEFDDiEAv4wd/DkucDyjULUaJXRknf8juL8B6tf9AGdie+9o5nL
         jfsBMjFAHUxAYD/8Xj728ONKWr51/NRVh2XknCxWHeUHQmbedllDESICpg62IW22i2Ke
         D/gg==
X-Gm-Message-State: AFqh2krlwjs3GDswNikf5PRKWuJkHlUeKjwea9Vog2yejzZweKN5cs9E
        TAI6sbObkaAT2yVVzMvjKoo=
X-Google-Smtp-Source: AMrXdXuHfSVkr7YaD/r354nbLVYVruipq3R59Amrhmyg8bbDRZ5Vzjv/H8wjenC+83jwcyGtENYZ3w==
X-Received: by 2002:a17:90a:f404:b0:229:557:8a21 with SMTP id ch4-20020a17090af40400b0022905578a21mr5515148pjb.7.1673609047682;
        Fri, 13 Jan 2023 03:24:07 -0800 (PST)
Received: from localhost ([23.129.64.222])
        by smtp.gmail.com with ESMTPSA id qb14-20020a17090b280e00b002291295fc2dsm1907292pjb.17.2023.01.13.03.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 03:24:06 -0800 (PST)
Date:   Fri, 13 Jan 2023 13:24:02 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v3] sch_htb: Avoid grafting on
 htb_destroy_class_offload when destroying htb
Message-ID: <Y8E/UnlyiqeH30Yr@mail.gmail.com>
References: <20230113005528.302625-1-rrameshbabu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113005528.302625-1-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 04:55:29PM -0800, Rahul Rameshbabu wrote:
> Peek at old qdisc and graft only when deleting a leaf class in the htb,
> rather than when deleting the htb itself. Do not peek at the qdisc of the
> netdev queue when destroying the htb. The caller may already have grafted a
> new qdisc that is not part of the htb structure being destroyed.
> 
> This fix resolves two use cases.
> 
>   1. Using tc to destroy the htb.
>     - Netdev was being prematurely activated before the htb was fully
>       destroyed.
>   2. Using tc to replace the htb with another qdisc (which also leads to
>      the htb being destroyed).
>     - Premature netdev activation like previous case. Newly grafted qdisc
>       was also getting accidentally overwritten when destroying the htb.
> 
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---

Thanks, looks good to me!

Reviewed-by: Maxim Mikityanskiy <maxtram95@gmail.com>
