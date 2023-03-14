Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73F6BA2F0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjCNW5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjCNW4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:56:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC945AB7D;
        Tue, 14 Mar 2023 15:56:22 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id fd5so34590660edb.7;
        Tue, 14 Mar 2023 15:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678834564;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bzQWNlryMqLjAgC3Vi7OBdvf1C26kSaDlmim0Qugobo=;
        b=Q1hya8gjXcXlqblfpqo6xgNC/QkrB7rcT2+7DnvTHufrE55q6KWSOgAChErWW36BAB
         dxzu6VMrCKJT0r38qgGS3wudJusoPOj3mIpY4WySp3SyYZ9qBoq+DeyIiCGbGx+BzJPg
         llzcCaJMOuyFQKj0BBZVI5XVy8z03CtzBTla1RoRJREJK9ZI2JMUPluZtgA4JTWjzdlw
         4xgpX9T/IDOQrhNZFKG37IGNmEMkMFOz1IXswXiRD/KFH3Huygdka7eyrUKWzMQw3woU
         oG+p6Ou+K5Usg+yst0ZihQc44RwAr8Hxb7wqIZgobx+Yl3FrghviM9i0otY1mMuImv7c
         6G1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678834564;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzQWNlryMqLjAgC3Vi7OBdvf1C26kSaDlmim0Qugobo=;
        b=sE8XCRiuxcDqvu3FAszOrG8A5sXVQUbCeNzKl7i4xU6qySmguXBXl48mJnc6wXdUcn
         5aQvT+dlTXI95ztw314jfvDj7bHQWXdVXyg3gV8QDPfHmjpYJmKKzydwjs0PjxrCSxJT
         Pk/429BxZY9psGA3EOoXaxjD8goixduyQdflGnz3FxIpEGVBrCmfZfDxubbTXvVldG29
         HSjxqRhW5D0pu/FJ+gpwklJwbvBx36huvWQA4mVBeKb1hWAtwiQSch33A/KeNykhHCfS
         ZEnd68J15I8Evhh+d64t9mjtQ7WGLxD/gaZnlxtoqxFNcUYCIVptKZuoPTxFfVB81EDX
         fZ3A==
X-Gm-Message-State: AO0yUKVpQe2pNEWHaik4pmJdPpLLoGYQMgyPwmk1yIxFI/WbQ9rSmcuQ
        zPdYfS201hwUZbShCDFpDu4Vgf9KFWWYNw==
X-Google-Smtp-Source: AK7set/NGVsUKh9EZ1I8PveEv7gvJbXe5aFLErgiZPHk9KbOycg1YVMTzgtE0JRQg7LKKi8LrPHJig==
X-Received: by 2002:a17:907:a649:b0:879:ab3:93d1 with SMTP id vu9-20020a170907a64900b008790ab393d1mr5157699ejc.4.1678834564418;
        Tue, 14 Mar 2023 15:56:04 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id hx3-20020a170906846300b0092a3b199db8sm1668093ejc.186.2023.03.14.15.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:56:04 -0700 (PDT)
Date:   Wed, 15 Mar 2023 00:56:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v4 2/3] net: dsa: rzn1-a5psw: add support
 for .port_bridge_flags
Message-ID: <20230314225601.wthhxavdbu3qbvs7@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-3-clement.leger@bootlin.com>
 <20230314163651.242259-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314163651.242259-3-clement.leger@bootlin.com>
 <20230314163651.242259-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:36:50PM +0100, Clément Léger wrote:
> When running vlan test (bridge_vlan_aware/unaware.sh), there were some
> failure due to the lack .port_bridge_flag function to disable port
> flooding. Implement this operation for BR_LEARNING, BR_FLOOD,
> BR_MCAST_FLOOD and BR_BCAST_FLOOD.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
