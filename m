Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFD9560F93
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiF3DSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3DSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:18:37 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9AC1EEF2
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 20:18:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d129so17185747pgc.9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 20:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eSjVV+7OFulr8zAbPRa6Qjx2R8k+45lODfZoNjxvcqs=;
        b=Lx1c57tTgH+t6kB+yTTJmKIg3WS/nZHmMzUyGstTwvcXAZCJfH3roT0bo0B0D3IynA
         gcG7w6TbBx1SDUM/juFfjpRgUiA8Hd+fK/BjudtqkKRMBXAQnNb94in8sgnquuk3UppT
         20/aD8P8QcNKUSKW1d0CmAfy2iqsy/6K5YXkdxOExC0/0+u7MRF15OIjl55Q5SfYvK22
         suPmypE+cChmRKEJcW8lhjhhLkyEG4EJMoRwuerD95gxjL7I5kv9EqiRqAlWrmxIWo0I
         EtvJifffCtyQwy6j4NyRbSyLp1GdY9R82pDBYIL03ps2ko06KgqIeZ80dbeYJqWYUa5Y
         I3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eSjVV+7OFulr8zAbPRa6Qjx2R8k+45lODfZoNjxvcqs=;
        b=RBgrgFM23XtUEPSyt6qeKXvnQh/Tysg+qWvlTXsPiL5PaabkfUE4LZChS6KLZBmYg/
         S/GBSe1zeeOIuEK8sBotsXenkweVE3rG1o5TtCes0Ih9hD0XXjIK2EKCyTZ4p53zs5XQ
         RE/X63cWX58GfxwGQ8AnLqh78RTy5mA3mCggOnlJ617gOFU5BgnLpUfBFcWPoCoPenEj
         diPu1VuIjaYJFbYyMXulaDEtPfb9c0eeBUT4tHZ+zi+O2giL0Cy/yt8F3fDEllmzMav6
         Qe4mHXWFn3EqyFYdnycebBSEtpVv6q2PMYRsVcvpYj2LBs6p4y4L2gglkckepZ93W8sl
         2ixQ==
X-Gm-Message-State: AJIora/vGLFk7hw37E17fOaXkJsxu3OBXDMoajtte3XnKYDrgCco5+ry
        NzF4HwEEfDmvW+K+J1yNALg=
X-Google-Smtp-Source: AGRyM1tfBjCLOLGDdJ/EaJd2jUDv6WrbqFKzPXB0aaD9Tfm6mUHY/UQ8UGBrb7L18FqgdgyMU1Dirw==
X-Received: by 2002:a63:1d20:0:b0:411:9f92:43c3 with SMTP id d32-20020a631d20000000b004119f9243c3mr1506952pgd.115.1656559116369;
        Wed, 29 Jun 2022 20:18:36 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c20-20020a656754000000b003fcf1279c84sm11945718pgu.33.2022.06.29.20.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 20:18:35 -0700 (PDT)
Date:   Wed, 29 Jun 2022 20:18:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next] net: gianfar: add support for software TX
 timestamping
Message-ID: <Yr0WCSQnEvh2nwjZ@hoboy.vegasvil.org>
References: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 09:13:35PM +0300, Vladimir Oltean wrote:
> These are required by certain network profiling applications in order to
> measure delays.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
