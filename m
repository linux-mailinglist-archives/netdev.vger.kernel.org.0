Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8666473EA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLHQJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLHQJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:09:48 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A78193FD;
        Thu,  8 Dec 2022 08:09:46 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l11so2430837edb.4;
        Thu, 08 Dec 2022 08:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RiqBb46+HPp8goYEv89xctk4t08Ol4xrURMi99OWSS4=;
        b=Nc4SjQe6se+E2RfzTOuOpKPEGmzDHlLzuw6/dulBCQF3ytQb5XTEWXI9DxJsvKfPyR
         Dt/LzrR63/Vmx6LjoDzVbOYtVxThIcRwns66WJVy4GfvzDvwVY9zELquWG40VQDSU9tr
         qRLkcYoPc1TEDX/x1dImSYtN0VOqLXAw+DSvqF7pqYz84okg3g5TZnAZR1DRrwGxyfN3
         q8kOvfg66AN1GNqW2sm36Zp5Qd5q7uHSxmUZCZDRdUPwedAlTQgDlKRTjbWIpYY0i96F
         UpD1lOY/Za1GDSFy/SfeqxZ8WL1ApeooWQZDuTlL+DPoMK2OxNgMreey5rwfoPIS4iFF
         9yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiqBb46+HPp8goYEv89xctk4t08Ol4xrURMi99OWSS4=;
        b=Mm5DyT7jlnLX9OHhTCg8aAtNnao/GZYzm7GlztMga6s0gAmbyOHrk7ZQRqVJWx1/4n
         E0oSGgPNqAWPdSj45KBn/HngdtKeUc2T8vjOps6xEif+6cBvl7FPuEKZ/ctiR0pUQdyA
         6UIYnK0Ef2pcxMewKdg/CKzN8Pcq1kY+yM4nft85mUqis/+JchQPBMQuFPTMyvztKnox
         O36+pYeRx9igEqmXRcmtpCaYqiF0zQ1CkotlUP4uItvRkmGUOddwrlM4wvN4d39YH4OZ
         QNIBcPYiXX4VN34DC1xY+a/iSRTBmN2zV5k04fHMFAuMr0lzn4FWDH4mz55aIGV5TMu2
         3HOA==
X-Gm-Message-State: ANoB5pm7yFsCbKk9uZ8KBBYwp0Sbx93d5RYSrtcPfmi1XRhti+0vYWRh
        aTeH5V9OPRFcqb3jOudJe8o=
X-Google-Smtp-Source: AA0mqf4L4/RKhfNxQ89B9VZH0YqMAEM5PLUXug+Fan3lhCyoMJMGOKKJetsN4PJ3QwcD+TLp1HdtYg==
X-Received: by 2002:aa7:d787:0:b0:46b:eadf:8d34 with SMTP id s7-20020aa7d787000000b0046beadf8d34mr2841682edq.7.1670515784856;
        Thu, 08 Dec 2022 08:09:44 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id c5-20020a1709060fc500b007ae10525550sm9868594ejk.47.2022.12.08.08.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:09:44 -0800 (PST)
Date:   Thu, 8 Dec 2022 18:09:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221208160942.r2xp5or6k4xrur65@skbuf>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
 <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
 <20221207202935.eil7swy4osu65qlb@skbuf>
 <1b0d42df6b3f2f17f77cfb45cf8339da@kapio-technology.com>
 <20221208133524.uiqt3vwecrketc5y@skbuf>
 <7c7986329901730416b1505535ec3d36@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c7986329901730416b1505535ec3d36@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 05:03:59PM +0100, netdev@kapio-technology.com wrote:
> At leisure, do you have an idea why it will encounter a VTU miss violation
> at random?

Do you understand that any packets with a VID that isn't present in the
VTU will trigger a VTU miss, and also an ATU miss if the port is locked
and the ATU doesn't have an entry with that FID?

Your selftest creates a VLAN interface on top of $h1 with a VID that
isn't present in the VTU of the switch ("bridge vlan add .. vid 100" is
run elsewhere; we run "bridge vlan del ... vid 100" when we no longer
need it). But the $h1.100 interface is persistent across the selftest.
And it's not silent. Linux does all sorts of crap by default, like IPv6
neighbor discovery, even if you don't use the interface. So it will send
packets from time to time. And that's when you get those ATU and VTU
violations. The MAC address of $h1.100 is the same as the MAC address of
$h1, of course.
