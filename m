Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F094F22CD
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiDEGB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDEGBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:01:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C95FBA2;
        Mon,  4 Apr 2022 22:59:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i27so17296214ejd.9;
        Mon, 04 Apr 2022 22:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rgq5iROBrypUjKZXC6G4OewAtE9hWW/Gme2bB8GXjJo=;
        b=MCJVV7ek7/4/fiFRv/NT7c2FM1qIfwLkTOvYlBNbwfuCxCybryCTWxitSQbpLTlXHf
         2P1hD5dtOcBTcZcMVVNl4vMqQVkzBz5nNcZd5iS6NGgRK8YUfx8XUjeMblQJUikYP6Yd
         H2ob+aNdEu6f+jfK3D4Iqe0+R6Eq0BJF1jVWjVul+BvVg795DbfYXsxC0WZ8r7mATelO
         Hc71Vx5HOT8NbnMF8ejW0r558CYKaoVWthdeh0YXTPJFPTlgSpAMMUG2NcNp9DwnsnZ1
         63FGeLbOKRpFm0YcQyg/D+1yXxFcCJCnPKxnUnOChVDacAMEgFNYoqkEFbN3tN+EcBy4
         TiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rgq5iROBrypUjKZXC6G4OewAtE9hWW/Gme2bB8GXjJo=;
        b=KcCo7INtA7lSgN4ZdN2qm6Oa6bL++h1eZK+/EcvfPEf7NhSLRXHj4ZIFBhVxg/AogF
         aEJTlOFsUa2osQI2m98ZJTalvLyXmDZ806DV510c8RglpDaaJDksuWUHOXra1QB3XCu1
         0XQa3ot/5U8kQAKlSy57nfQ9HsUqL7pUbydnXQNhUQWsDJAS17W7tPFvxPaaGQFx3GcZ
         FgbEtr27BDK5G2Ps1sGa0QxJQ+UjInrKdWD8ZEjPU7ctqUGCMz925R+lF6AgDUkb2SH8
         HTzBo7At0yty/lYXepzBVP/a6haYCzC9ibezsm3b52Ef9q45QWmj5K5tszaqGFl1u6e7
         KS3A==
X-Gm-Message-State: AOAM531OjytEn6y+t4RnkEId9f6EN1VKa5jGRn3raZU9F645jl8ohidl
        R2Z0Z1PexxgCDwLKkxYEUMc=
X-Google-Smtp-Source: ABdhPJx3Dt/WfNhS4rp3hSkGVQpyPJIZElGz+DTkY6bVwjHNNIWaiL+ooU6OwxdNHMKNB4a2vPFgPg==
X-Received: by 2002:a17:907:97c7:b0:6e0:defd:342d with SMTP id js7-20020a17090797c700b006e0defd342dmr1835770ejc.231.1649138397017;
        Mon, 04 Apr 2022 22:59:57 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id dn4-20020a17090794c400b006dbec4f4acbsm5199369ejc.6.2022.04.04.22.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 22:59:56 -0700 (PDT)
Date:   Mon, 4 Apr 2022 22:59:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        grygorii.strashko@ti.com, kuba@kernel.org, kurt@linutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220405055954.GB91955@hoboy.vegasvil.org>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc>
 <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5a6f6193b86388ed7a081939b8745be@walle.cc>
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

On Mon, Apr 04, 2022 at 07:12:11PM +0200, Michael Walle wrote:

> That would make sense. I guess what bothers me with the current
> mechanism is that a feature addition to the PHY in the *future* (the
> timestamping support) might break a board - or at least changes the
> behavior by suddenly using PHY timestamping.

That is a good point, but then something will break in any case.

Thanks,
Richard
