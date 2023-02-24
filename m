Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36E06A17C3
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBXIOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBXIOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:14:08 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64289126F7
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:14:05 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ck15so52933047edb.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1677226444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bZ9NjB3AfY5RmYuTgL9PuMb/sGj2FF0qRFXCL1ZDU0c=;
        b=iZqQ48RVDfSik/RkQjDIXMAOAp6hDpO/tX9KcHVymjh7CDvK9dyauOFL30qLwicKCG
         /K28oD1Baayvccs8HQfL5ly/JhkXQw0ykFMLaDRofdlHl9/IFDRCQLKLPl8s065ZTfVU
         Vll0xgYxvduV1Yzl4o0EFd2WGLP67a4Eb5OLlujAEo2isMPsj0D41aDmn9U28K1dnap/
         rSwku6qyQalQXOonSuN7gCV4VtSwfuFzgAagGZ6YMJ/2jzXdfmK2pCpDmkFRnjXZnvk5
         mq4aN/ZybR2nix7Cf+eSTXla8dssqcY1MdbnheyfMKi0ittHVsp3S+jiTnJbWjULMZtZ
         yLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677226444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZ9NjB3AfY5RmYuTgL9PuMb/sGj2FF0qRFXCL1ZDU0c=;
        b=M5MGY/uTdKosENPSnk2Wn/FDj12M1EbzkRFeIUv5WpS8Pbw2Wx7m1aYRJqNVHWZiCK
         cz0oWdcFjsAxB/kAVAUqXSXK6+yVW7McLZ2Ze3HOL0Xf0X4/t8+zIoWpZXh637Lr9h38
         zmxpz6FAW2Kt3BaK00PlpMWQDYb9gMyPwQqgkbtU+eECnwokDaCMKglBTRy33ONxGjfv
         BCeN+UfRcDdNMOycdvveRRDAuIGmpMyXGqIBYc4ACmt+X2JwzC6C70fLqGjW/7a18qbP
         faH/pjsVUPRYQoSAKqs3zRVcoNY761fgMSQBGLgCL06kuBgxGt5/hu6Ak3+uDzjnM8x+
         9n+A==
X-Gm-Message-State: AO0yUKWkdTqqfHdkuw6z0zv3DzLikMruuwapXyGkBdCAQ/DhHTVHV1Gk
        KHfeB1rEaFjUGgoA1uG196OrHA==
X-Google-Smtp-Source: AK7set959ulc0reshj0XpPmyGWRl0z0D3rgqLSsxTYBlL4Y96AO2t6Uu0bzutklbzxdE/2wgThPG9A==
X-Received: by 2002:a05:6402:1850:b0:4ac:c5c1:e1ed with SMTP id v16-20020a056402185000b004acc5c1e1edmr15062452edy.12.1677226443826;
        Fri, 24 Feb 2023 00:14:03 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ot18-20020a170906ccd200b008b1b644c9fbsm9381434ejb.103.2023.02.24.00.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 00:14:02 -0800 (PST)
Date:   Fri, 24 Feb 2023 09:14:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: net-next is CLOSED
Message-ID: <Y/hxydP4flytTdKF@nanopsycho>
References: <e3e8fe0a646fbbbd64e47623aef40ff7ae3ecc8a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3e8fe0a646fbbbd64e47623aef40ff7ae3ecc8a.camel@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 20, 2023 at 07:56:34AM CET, pabeni@redhat.com wrote:
>Hi!
>
>Linus has tagged v6.2, so please defer posting new features,
>re-factoring etc. until the 6.3 merge window is over.
>
>As usual, feel free sharing RFC for such topics even in the merge
>window.

Who is flipping http://vger.kernel.org/~davem/net-next.html ?
It's still "open" there.


>
>Thanks,
>
>Paolo
>
>
>
