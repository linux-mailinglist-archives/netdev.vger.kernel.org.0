Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902F46A7A8C
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCBEgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCBEgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:36:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3248A71
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 20:36:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so1653368pjh.0
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 20:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677731801;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3Sq1Xk/kmeTr6cRbg3WCMLCEIrSn3Yj/ffY/0Qgxyio=;
        b=q7hqNkDEwz1BKNkXJ4KQUalrH65Qx/CfVFa86CepnTUDDvLL7CB5wciTXeed+2XouK
         IBM6oPyFgWSitsAuP8ivZJIekkB2681HbOk1q2kMN4SZHFnOfa9bwNi4Sl1jKUfjZl4T
         8Pc74nBI8xl1vn5vQqB3SvK/WZv4p6djoAlfyg+Ui7Zm8QkS9xVB8Btsvf+P30M52sC1
         IsGY3TyR/AmKnS/mQToOKvjRW3mdrncME/+krNPf0Rmh+0+KzkIvMFzUMepW6w+iZZGc
         iEKn7jWRzFFb3ytYSio/zgpGOm3E7IYJ33azj5876P26ut/Zn4JrAxRNGeW1ZrOxeU1R
         sJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677731801;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Sq1Xk/kmeTr6cRbg3WCMLCEIrSn3Yj/ffY/0Qgxyio=;
        b=UgeVTc6N3WF4sti7ivzjr5yhrb/taoJ8wXWGhNp5fyoEYRAo0UA3+zaiFIFCRvw0lf
         GLeFpAdd2rFgkmdMs4818XWD3VLQPmPLMJ+Oiv35NT3I5tTh0GEAA3YBr8TUwTfgEvf0
         vvA7MT5+LgR3B7CXifFyENS0qV2NJ7e64xGMgF65ygW42+pvlDhblhUsfnHhdhpwAzbE
         e+4D1eTzgBpi2auEdXzlKHLhA02/8D9ZmRNIybNawOiSzPeKyZB8WJNN6I/qvK8ArZB9
         Yi0TYQCUebhFvX67n1iIwwYNip3AmyoKyQtD+tWPoUXPsUGS2Fk1rdWdbWzzwUQFN6O8
         m1cw==
X-Gm-Message-State: AO0yUKWVNqgjjwHAx1okyFkUoFjI57ANCrsS84etpMgun/aeArGRkDKP
        j5nBFHVrYL8fqaYI2IdxEKY=
X-Google-Smtp-Source: AK7set/6r0gTK89JFLiGtijc/4n5Zu0DzbhoD+4u51pIsJhJpgNMcpP4wFtz6S+fUo7ujG/DksLJZw==
X-Received: by 2002:a17:902:ec91:b0:19a:f556:e386 with SMTP id x17-20020a170902ec9100b0019af556e386mr9957404plg.0.1677731800997;
        Wed, 01 Mar 2023 20:36:40 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n16-20020a170902969000b00199203a4fa3sm9210487plp.203.2023.03.01.20.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 20:36:40 -0800 (PST)
Date:   Wed, 1 Mar 2023 20:36:37 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
References: <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228142648.408f26c4@kernel.org>
 <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
 <20230228145911.2df60a9f@kernel.org>
 <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 05:04:08PM +0100, Köry Maincent wrote:
> I suppose the idea of Russell to rate each PTP clocks may be the best one, as
> all others solutions have drawbacks. Does using the PTP clock period value (in
> picoseconds) is enough to decide which PTP is the best one? It is hardware
> specific therefore it is legitimate to be set by the MAC and PHY drivers.

It is not that simple.  In fact, I've never seen an objective
comparision of different HW.  The vendors surely have no reason to
conduct such a study.  Also, the data sheets never make any claim
about synchronization quality.

Thanks,
Richard
