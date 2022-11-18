Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7C62FC0E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiKRRzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiKRRzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:55:40 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53AA6587F;
        Fri, 18 Nov 2022 09:55:39 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d20so5190471plr.10;
        Fri, 18 Nov 2022 09:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xKNOcXqP7D+nK6CYZjT+KDgff8RsnbBW9RoOhixZZcU=;
        b=YdhP9T+5XikRDKwKTizV6ej6Q7irCfHSLeKK8hnsv/dkip+eYLvaKrEvxOA3m2es7+
         fbdGzSOrnJUykx5ozYPXB1CHqZGu0fSObYZiYm1uThfRa5TUwGKC+5cs3s9r2/GI0hXL
         rv0fBEzkFyTN46RtpNVAx1v0Av6CS10MryWtwI795YBh1YydzGf59F8iQbsHO+VKUwcs
         NiJ2IMC6GET7PrGE+EueJxLiHRKAKpOE6YV8EmzjIq7eTIn+8mPlmiPQB17xL153jnCH
         6/5aS+CkJUpmOyqZfHiHsotFd3TSt+RvjSxQPwfRu27lM/WPZvI/aLxfuJRLGwZzjwQZ
         O6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKNOcXqP7D+nK6CYZjT+KDgff8RsnbBW9RoOhixZZcU=;
        b=0bFOjV449A5ACngTVA631Cz2NRPpQoiPad7B8t9zc6P3hNkH2yfaVeI216gChXStDL
         AJeDVE9i3dArwIjfmI2v1z7aXBZQ/svzB8bguPLXZS/OwWsHKXgKMnzokQdOr6fcY0Ie
         RzqbWvoRvsH+3udim5n7o2357xoL91Zhed6ggfhS/ZwYHAdYrOQcMbV6vdokYmGrMU7w
         rFxX1UAnEt04K8ZL7TIs8c08ko7FeJcqUiqI3Ph9mMryLpuemdnUM4pxJpefzBgnE57U
         qjYp8jGk95HqNyHGsohK02eNBeGLZakk3YWNFeTocVz3TVUSD3zxj04hENLyJKkHketi
         u8mg==
X-Gm-Message-State: ANoB5plkU3VK0XBWU5wz/Rb8arE+hwwjwXPJ6zgn6hfbgtXJyg6Pm+By
        TF33RQc9wEnAjv34QzBy1uk=
X-Google-Smtp-Source: AA0mqf7dqnugaQcIyoWJAedvRJhL6qeKp/1t1dx9PkqLO0aDIfK6ccbqN7bmYcxu+RYWLdMMLQA9kQ==
X-Received: by 2002:a17:90b:1bc6:b0:218:4d16:cecf with SMTP id oa6-20020a17090b1bc600b002184d16cecfmr8738008pjb.96.1668794139133;
        Fri, 18 Nov 2022 09:55:39 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:e4c5:c31d:4c68:97a0])
        by smtp.gmail.com with ESMTPSA id k188-20020a6284c5000000b0056c681af185sm3456214pfd.87.2022.11.18.09.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:55:38 -0800 (PST)
Date:   Fri, 18 Nov 2022 09:55:35 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
Message-ID: <Y3fHF9b1YoVTj/jL@google.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
 <88VJLR.GYSEKGBPLGZC1@crapouillou.net>
 <Y3ernUQfdWMBtO9z@google.com>
 <Y3fF/mCUVepTfTi+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3fF/mCUVepTfTi+@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 06:50:54PM +0100, Andrew Lunn wrote:
> > > Why is that 1 magically turned into a 0?
> > 
> > Because gpiod uses logical states (think active/inactive), not absolute
> > ones. Here we are deasserting the reset line.
> 
> This is the same question/answer you had with me. Maybe it is worth
> putting this into the commit message for other patches in your series
> to prevent this question/answer again and again.

Right... Actually I think I'll go and define that GPIO_STATE_ACTIVE/
GPIO_STATE_INACTIVE and try to get Linus and Bart to accept it as code
speaks louder than words ;)

Thanks.

-- 
Dmitry
