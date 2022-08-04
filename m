Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69C5589662
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 05:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiHDDI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 23:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHDDIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 23:08:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C35F564E8;
        Wed,  3 Aug 2022 20:08:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso4154765pjd.3;
        Wed, 03 Aug 2022 20:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=RHtZ1VlVkt6uu1M+FTMfyHpvjdn2kh4z4p+7clf3Kls=;
        b=RZz1ho6SmsSK/OBoUmBHWGW0BXgD4ngI543zvM0JJq9XlTE5t2eqhA+NzwKw/Kgs1k
         JP4DAWXjDEzLFxTSwE1OulpTw+aZCPk/y2/IczzZ7CoDCq4rvOxY7UJ1EdU13YJh/lYk
         hnCDKPYJAPWaho69qoBF6X6F9oH3k/dcTZWf6tmNhjI5fTXY0MjZMLEUrnYDsAXTHSAb
         9IibCko4OFRxJQenDZE7rXlmaGbBRk013wCpxYa7qfcYSXUAq7DZeSF0dsf8XvReGSe6
         kEY1N+d/4vSjPrbCXIxNMgLGt6khfQgBmcb2dqAjlbUN2I2bOwthjOpxsnbPGiahjNkr
         3CWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=RHtZ1VlVkt6uu1M+FTMfyHpvjdn2kh4z4p+7clf3Kls=;
        b=FfX6toxm17Q4MVxeJf7PDBjktfyqJ/Jjabsl6pED+TFXpME+rK+4XaBGgwB7892V5w
         P3cwledMmJ3vY5+nd6UK6gOTm1+I6WL7u6JlEer0/GGikO40SKKwDbMeJduQsS7Wi9Re
         NDfBBis/8i3qhbtQdt8WiTSDEaR1nvtTnKXvq23p4HSU0XmRBlX8Tz4WTe3JACHMQiFL
         B0JRtQwrKkia7qjIZGZQNWhfIpMMXTICay1mG+7MS0KwW27ooB27/0BHFxDIp6lJH+7b
         zpmnExYQ9RIcRDPVfLTREQZ5mLxUjOv7bce9werunraIXSDvuQtaQ85XljHP4BwtLjfg
         x0WQ==
X-Gm-Message-State: ACgBeo0SnOSBfiLvuc41ZL7HI4npef8lIUdOGZa+VVD1VieqWHPYF18T
        w8LDU+PPvZqzXXDMbJh1jIQ=
X-Google-Smtp-Source: AA6agR58KPxALmmMGmhDfOdOUZVhgZbzWX8jvRQmk1ojWK85ZgTbwROt90oq7/EaArMjndtmKhdQpQ==
X-Received: by 2002:a17:902:e543:b0:16f:23b5:9120 with SMTP id n3-20020a170902e54300b0016f23b59120mr2159060plf.30.1659582534048;
        Wed, 03 Aug 2022 20:08:54 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 13-20020a17090a034d00b001f10c959aa2sm2383353pjf.42.2022.08.03.20.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 20:08:53 -0700 (PDT)
Date:   Wed, 3 Aug 2022 20:08:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Naveen Mamindlapalli <naveenm@marvell.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [net-next PATCH v2 0/4] Add PTP support for CN10K silicon
Message-ID: <Yus4QrgERE9yR9WG@hoboy.vegasvil.org>
References: <20220730115758.16787-1-naveenm@marvell.com>
 <20220802121439.4d784f47@kernel.org>
 <20220802214420.10e3750f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802214420.10e3750f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 09:44:20PM -0700, Jakub Kicinski wrote:
> On Tue, 2 Aug 2022 12:14:39 -0700 Jakub Kicinski wrote:
> > On Sat, 30 Jul 2022 17:27:54 +0530 Naveen Mamindlapalli wrote:
> > > This patchset adds PTP support for CN10K silicon, specifically
> > > to workaround few hardware issues and to add 1-step mode.  
> > 
> > Hi Richard, any thoughts on this one? We have to make a go/no-go
> > decision on it for 6.0.
> 
> Oh, well. These will have to wait until after the merge window then :(

FWIW - I'm okay with any PTP patches that are about specific hardware
drivers.  When I can, I'll review them for proper use of the core
layer, locking, etc, but at the end of the day, only the people
holding the data sheet know how to talk to the hardware.

Patches that touch the core layer are another story.  These need
careful review by me and other.  (Obviously)

Thanks,
Richard
