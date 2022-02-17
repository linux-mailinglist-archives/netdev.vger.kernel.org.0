Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424A34B9655
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiBQDHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:07:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiBQDHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:07:42 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F18EFF8B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:07:27 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id bu29so7527690lfb.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6e9pRDx3mYzd/GqaewKAgqNeZaCJzR+i5dxQMfm9mE=;
        b=Fmy7kwcNgT0RXI/YT7Ror106FKc+/ZiNybRJ8SSDlwSmuGGDLED2gX3S2pDsPDjk9z
         BlYYi7mCPG/lA18XSfzZVILEarKKmjLByGu7V06AL2EgAuZRBHU95UMYuipNE/kuF85v
         IY6lRbVtiuQ4hKXEgPiY1Os20d6M9Jdxqsu1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n6e9pRDx3mYzd/GqaewKAgqNeZaCJzR+i5dxQMfm9mE=;
        b=TDeY3F5at42QYLqJiFKpvIqrl2cAwWlQrsjItuLmoI8rjagE4XWJh2dsw6WubdnQcs
         PgWS8ktNN6hmoxhjmjHn6VgU/yrEg4A1vPua5+zebGO/1pxK2FOBQsb1IKB9cWunDMg8
         PEd4TYvni7Lhp8NeRAdnMOkEduxilj738fLwnYm6FW9usvzmRgEiWYuAbRuKyNcp6Y4w
         yo3YNVBjT8tGddmhBzWG8iFD7XqBHIB3wJrx+bTl6eJw0p8IuoI9MSFcWMM6mymJCh6a
         KN8hUZPqN0ZHKSRmQpWkTJxxy+/hxIebISAQo01fuMovDjFfBwQEyLwJAUhqhuKF6zUJ
         fOyw==
X-Gm-Message-State: AOAM530c0bjA2eYcCFz0mFiBF8qFByoRqiOs6R1s97XIFwPJxs4SOldY
        jL0fVxUSvEPwqMS5oCnqs4exgbASgx2l7rkeESEenQ==
X-Google-Smtp-Source: ABdhPJwkluKdS7kGR+JafDY0ufo0mwOsqaIPKfNL5wvet7YOW6+gtXBTXyQSQOL7LLNnrliyG4PFviOGO/4bJIFSB04=
X-Received: by 2002:a05:6512:220a:b0:443:1140:7ffc with SMTP id
 h10-20020a056512220a00b0044311407ffcmr686170lfu.566.1645067245652; Wed, 16
 Feb 2022 19:07:25 -0800 (PST)
MIME-Version: 1.0
References: <20220110015636.245666-1-dmichail@fungible.com>
 <20220110015636.245666-4-dmichail@fungible.com> <20220112145648.7e0c0d9c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112145648.7e0c0d9c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 16 Feb 2022 19:07:12 -0800
Message-ID: <CAOkoqZnwGd=xA7mD1qG7+XJ3O9DH+Q4hc+xB9XvzzvGpPBNk1w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/8] net/funeth: probing and netdev ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 2:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun,  9 Jan 2022 17:56:31 -0800 Dimitris Michailidis wrote:
> > +static int fun_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +     struct funeth_priv *fp = netdev_priv(dev);
> > +     struct hwtstamp_config cfg;
> > +
> > +     if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > +             return -EFAULT;
> > +
> > +     if (cfg.flags)           /* flags is reserved, must be 0 */
> > +             return -EINVAL;
> > +
>
> This check was moved to the core in 9c9211a3fc7a ("net_tstamp: add new
> flag HWTSTAMP_FLAG_BONDED_PHC_INDEX")

Thanks, I've changed it.
