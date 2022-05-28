Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01A0536A71
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 05:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345056AbiE1D1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 23:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiE1D1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 23:27:17 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943962E0A3
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 20:27:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c14so5882074pfn.2
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 20:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R/j/VF9P+I0AISpAYSNFn884Og3NTbnIvr2uncWLAmI=;
        b=OoQTJtD5YECOsnfMguIrS7l5R0tY4gb416fxtK92KZdVy2P9A+pz7LuapqO2WgLa6P
         6lqiasF/5/ozDn1XbiUiIrxQ0Bf2rc60qxwOfO7qZk9wCNcDBHGJb36dUXuz1jEf06NV
         lu/glK0LkUkA8RTjQYSCesurwW+rUS4GilrhQvT7fJAH2VlW6DwHC2dgdHpzg+L1KvLY
         2lC5XA8NjA1TnfSEMdLx2kFkHdws1YJhSnsZ0iXbouviBlH3PG3GoDaZaYFOu908L+0s
         uPVDNm6U/JTx/CvBip/YCffWnUExe6Q6c6Rd2fgYn7dQObjRs+Hm9hruHK0iCfBUsld2
         PE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R/j/VF9P+I0AISpAYSNFn884Og3NTbnIvr2uncWLAmI=;
        b=DG3XkBYknhujvDAdfjvbFLu2HByENiu/2E8+jZIG8mGgMpczjsV13In35uGlJBsiCV
         WFp0FxLhcujjiu5d9vukSc7PCiF385O1kwNYvCDpxJPhB6BRPfwwhrD8GuHnp9GD+arY
         xZ/wC+Jo+8gMzQkuLGCAJX6L2TvBYvRsUYz/ONGxFvkl2GMrmQOMPlrt9CFM7y2MvDug
         RRwTdAB6pOv3vYy3n4CexhPG9qxXmsAy8zdCK3kRl7GG1/Pv8iRaHC5RNkKFzeOGi2DE
         j5fDz7so9zep+5OZ/a6SbW+FsDo02rdHWopo6LYzEovzvoNzVSx3CIOmrjwTjd+F7+Cv
         xLvA==
X-Gm-Message-State: AOAM533L3yH7LP2fsJfTiEtMrTc/HagpEgMg44vFkIBJYpywz7Dz2KX+
        y5ih3kPPvOR5zozDot4qh8M=
X-Google-Smtp-Source: ABdhPJztsUWWVHrgJym4EkX2lxRStqkYex/fOVNLZH05GEhrg58kOSRj/gb49uwQWwvxJEuDyfLnpw==
X-Received: by 2002:a05:6a00:1487:b0:518:b952:8894 with SMTP id v7-20020a056a00148700b00518b9528894mr24343102pfu.73.1653708434993;
        Fri, 27 May 2022 20:27:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 127-20020a621485000000b0050dc762812esm4260933pfu.8.2022.05.27.20.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 20:27:14 -0700 (PDT)
Date:   Fri, 27 May 2022 20:27:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, kernel-team@fb.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v5 0/2] Broadcom PTP PHY support
Message-ID: <20220528032712.GA26100@hoboy.vegasvil.org>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 03:39:33PM -0700, Jonathan Lemon wrote:
> This adds PTP support for the Broadcom PHY BCM54210E (and the
> specific variant BCM54213PE that the rpi-5.15 branch uses).

I'm interested in this series.  Can you please include me on CC?

Thanks,
Richard
