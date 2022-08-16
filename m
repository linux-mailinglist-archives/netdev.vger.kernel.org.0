Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED59595F25
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiHPPef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiHPPeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:34:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DEC2AC61;
        Tue, 16 Aug 2022 08:33:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so9975397pjf.2;
        Tue, 16 Aug 2022 08:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=n/FMSM3ExKJRjr622Mf4zh6vREPBH4bbDUrMTS9EAJE=;
        b=coY1ULOQGYbtD5Fl9zB+DTvbg9QzIuSBHlYn0BUIPLeYj8SIsry7yeWGv0KXWmX0Df
         hKhf1+WZ2Dsb2zDhyBKSu/R9AFfXfuiibo3+bS6zvkdb+fz/qBz9lCkkqENxZn3RwBd2
         7XMAkwS+4gVIWZEfOq0rSzffEuNVb7eXql5bvU/PVaWLu8l6DBzVj45oMN8JDuSTFJPe
         B9wcK9sItTMq9iiRy4c4apTtzdp4rp5/TAhr1tdJ4Pb+sP0LiZvuwfhx6aq2Ht5cTi+O
         MC0QhqP5L1cnRFoRX7z7pFJRm69vlurkbUCxrTob3GHTLiJkHxf5ppMSk3PMEIZEjGal
         cwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=n/FMSM3ExKJRjr622Mf4zh6vREPBH4bbDUrMTS9EAJE=;
        b=DefYMzxXFU7FkErXCyUuLuUXNCGR3Jzcj55PLgVYzGvLtPIPqC/eaofwIV4kwjSQIz
         15p1cyeX6AizywUZqnmwsIMinkwcUO8patsDsHpX2A9Jxy8I6RlvEUsAePYJHJPeFqrv
         fEdyVdFXvFWHY8AMtMjsUzCuccPiPVidZuP1xpFDbqgB45fF0/bW3Fw06IsUbUXKxqvs
         wnL2JxIq9uwZ5gVwMVQTWBKweMSQxcKusftDiW5KmnpO78JNouaApfvRc1wL3oVYJTMn
         F4nd0JT7AsSXpcYBswZptVJ/BgRqQB8kKbq6CQQcn5rSAe+l99nHfyO0IG1Ihm+jxVPD
         Ta8g==
X-Gm-Message-State: ACgBeo24NJKaoEhpGrWZZ33cdIleKM9sTGt8CgHHdwUwg0BhEQVzm1Sp
        2lgWHiCUyYLTqLQ2gB82O7k=
X-Google-Smtp-Source: AA6agR5NXZ/kQlO4iZOCVY5kJBaSmzrVxUhovyabNBaEWgXNe/fhe2B/P9ZUBCoG5HnwLmtCSBur/Q==
X-Received: by 2002:a17:902:c146:b0:16e:97d8:dfb0 with SMTP id 6-20020a170902c14600b0016e97d8dfb0mr22351431plj.48.1660664028125;
        Tue, 16 Aug 2022 08:33:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7973a000000b0052d748498edsm8825924pfg.13.2022.08.16.08.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:33:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Aug 2022 08:33:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     syzbot <syzbot+684d4ca200fda0b2141e@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] upstream boot error: general protection fault in
 nl80211_put_iface_combinations
Message-ID: <20220816153345.GA2905014@roeck-us.net>
References: <00000000000033169005e657a852@google.com>
 <6a7b0bc82647440a9036a8e637807da618552cc5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7b0bc82647440a9036a8e637807da618552cc5.camel@sipsolutions.net>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 05:11:32PM +0200, Johannes Berg wrote:
> Hmm.
> 
> > HEAD commit:    568035b01cfb Linux 6.0-rc1
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=145d8a47080000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=126b81cc3ce4f07e
> > 
> 
> I can't reproduce this, and I don't see anything obviously wrong with
> the code there in hwsim either.
> 
> Similarly with
> https://syzkaller.appspot.com/bug?extid=655209e079e67502f2da
> 
> Anyone have any ideas what to do next?
> 
Ignore it. It is caused by a problem in virtio. See revert series at
https://lore.kernel.org/lkml/20220816053602.173815-1-mst@redhat.com/

Guenter

> johannes
