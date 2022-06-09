Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D685454D1
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiFITVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 15:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiFITVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 15:21:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D781EEBA4
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 12:21:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so211632pjq.2
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 12:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=eESKUx7er0t8KoIOuD4axPtC3s3/W93vy/ObAGyjlUU=;
        b=GI7Ze/ew625VFP+JWOo+cPOorStO9hfJ9nEEOcu3+ul5I0qX+3NlgKj/RutDbZP8rK
         n5CiDZndcU8GcrbUjTZ20lXPt8hHUzp1WyB0lZvUaMAt8w5McvKV6WvB1s0UFsa6Lhbe
         I8QU9SIni4hHOWQjvct+/JYnaKIkQmge8oq3lWWDFEEaepBjIzwFCV9Kayg55ZztxU/e
         NDyny8xElfcaQrye1jbVWs0dp0UoVgKGM7z+IqVRebnyXNgNuD8ya6CytiVxlcZbL71N
         b0qZSvB5pfMHfUJqljag6kKaADjX8P5qnbRsLSNQAbor/ONdOPhzRhyX2q75Tc8GLuS3
         hXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=eESKUx7er0t8KoIOuD4axPtC3s3/W93vy/ObAGyjlUU=;
        b=kuyTW8xscvjHMJmr1WN7QN9BfQqeNjMmj4kOqcaJ7KoUZKZY8b+v31pniXdgZczvy1
         dQIQ3YBnZrVlZT31fMi5OxbuhKeB+cXgIN2XB6/+lAZK7A2JyMKiJUALW9jt4DWi6cse
         REHZ3o5G2QSxkUOncL4s0YeJVvLPDtWnAX9OdIuxEm2iiCiRozAX8GfJqQTtVsln7h+8
         Bb2GuQqkbWw0Zc/dYhDQ/WLbL/ZVnwUPGK4Wp7/z4wxrd+UIMy2HY7fWdk1C4KqdWGCh
         kRbXUvS6viEjjyBFVJ23E/dAoBnX9C1Yqw6mE456g9V6XC7zWfOeLJGLWHFge2wNcBKl
         8ALQ==
X-Gm-Message-State: AOAM531JyBjUUB32ooCjz0oop0VvahN84acpW9BBzBgyXm1h+NhVKP7g
        nefvlnoboQk2GmfVCDuBQsw=
X-Google-Smtp-Source: ABdhPJz1aOrpqFPYwVb6JoclPTyeRRX3pDfqEKtSKFSK+e9Oucx7h/60Ml2My6iKpNFQQ8d60xLyYA==
X-Received: by 2002:a17:90b:1c86:b0:1ea:4ceb:2788 with SMTP id oo6-20020a17090b1c8600b001ea4ceb2788mr4880666pjb.16.1654802488694;
        Thu, 09 Jun 2022 12:21:28 -0700 (PDT)
Received: from [100.127.84.93] ([2620:10d:c090:400::4:3822])
        by smtp.gmail.com with ESMTPSA id h184-20020a6283c1000000b0051ba0ee30cbsm17538851pfe.128.2022.06.09.12.21.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jun 2022 12:21:27 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for some Broadcom PHYs.
Date:   Thu, 09 Jun 2022 12:21:25 -0700
X-Mailer: MailMate (1.14r5852)
Message-ID: <85F4D27D-EF7F-4F69-9020-769D2461777D@gmail.com>
In-Reply-To: <20220609040141.GA21971@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-3-jonathan.lemon@gmail.com>
 <20220608205558.GB16693@hoboy.vegasvil.org>
 <BCC0CDAF-B59D-4A7A-ABDD-7DEBBADAF3A3@gmail.com>
 <20220609040141.GA21971@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Jun 2022, at 21:01, Richard Cochran wrote:

> On Wed, Jun 08, 2022 at 02:29:15PM -0700, Jonathan Lemon wrote:
>> Do you have a stress test to verify one way or the other?
>
> You can set a large freq. offset on the server.  For example
>
>    phc_ctl eth0 -- freq 500000
>
> for 500 ppm and see what the client does.

Server:
  phc_ctl /dev/ptp0 -- freq 60000000

Client (cm4):
  ptp4l[252648.584]: rms    5 max    5 freq -59995478 +/-   5
  ptp4l[252649.584]: rms    2 max    2 freq -59995476 +/-   1 delay   165 +/-   0
  ptp4l[252650.585]: rms    3 max    3 freq -59995475 +/-   1 delay   165 +/-   0

Flipping client and server roles still works, (up to the 62499999 limit
for the igb adapter I'm using on the other end of the cm4 link.)


Looking at the math, the adjustment in bcm_ptp_adjfine() can be up to
0x7fffffff, as this is added to a 0x8000000 base.

So:
  (0x7fffffff * 15625) >> 9 == 65535999969 scaled ppm

  (65535999969 * 125) >> 13 == 999999999 ppb

Seems like the 100000000 ppb max value is in range?
-- 
Jonathan
