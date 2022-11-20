Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B2D6314BA
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 16:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKTPA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 10:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKTPA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 10:00:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63715252AF;
        Sun, 20 Nov 2022 07:00:25 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l11so13097988edb.4;
        Sun, 20 Nov 2022 07:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YSfdnSoe4gIRDGuMTJI+PS4BCsBcj93Q9hQI4fLU4XE=;
        b=C/3I3BNCH58dMhYqLJ0NG31nZVGrYmvzqdmX4wocQ3iMfFjjgb7dTgd3N71wRuJfPk
         vJyCmzWhPfW6NAsRm/CCRIdwl9F9wTD0SeqFqhPH24Tz0ljsQ6Ne2LuV6h3v7LBK9xzh
         tt8SWJBa7hkVPlUqCO9b7zj2smT72Ixs+5axzFnoc2WUhAD2lOPfK1AtzK3CEqAWLf4N
         zvDzgJTm5T9gxqcpdEkM3NymQygt56J7d8DikbRJLVDy8qtzCt/7ECpYXJmX2UQPToS7
         Jt2bGC3B+pJXJrlh4mMbE4NzrWpfEJ5CvFxP3jXeJ3p0A5wnGU4vofOYCP0BAH9oOrjY
         BYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YSfdnSoe4gIRDGuMTJI+PS4BCsBcj93Q9hQI4fLU4XE=;
        b=JJiHotFdZD/uVHUfHb9bXOrcyrqXWUXn+F10CqK+NmVZ+Hc634PMFCNwTC4gVdYs+N
         Qldo2h66lfljLXxn7q4JEplRqPc1ujt59CSqssDzZYto3Lpp28p6OPVDMUZg7iMLMB3n
         U7CQpLWjWzpO8VgncB03416UGbOb7PPjrpo8xbn/XwK/VkcFiLkrsR5vWekgJ1QhBm0C
         /+CuwG7QBuVwMHZNtYGdrCaoWp5dVjJ2cDQOb39diq2fxfAeTC8+p9W1IlPAmdbVbalV
         S2L1F17MXEpD6IhLZ+Anjfp6WlrLM8u3qcEfR4QDL53TAmetRnMDrD9dCqvF+Brh8Mk+
         pN2g==
X-Gm-Message-State: ANoB5pmhMekDECgtMjw3dpktv2oK6mC+Q15RplJbgMMzekFVaCFvO32y
        PfLd+uW2iEzGLwICdrQJtVc=
X-Google-Smtp-Source: AA0mqf6WNrEhZPE13ixlXJGBe9/kLR1A5HZyd9qCVTIDD4NsPdV6LHieITzYkWVHn0r+5D5P8CdIDA==
X-Received: by 2002:a05:6402:389:b0:459:2515:b27b with SMTP id o9-20020a056402038900b004592515b27bmr12970975edv.338.1668956423715;
        Sun, 20 Nov 2022 07:00:23 -0800 (PST)
Received: from skbuf ([188.27.185.168])
        by smtp.gmail.com with ESMTPSA id p2-20020a170906604200b007821f4bc328sm4032168ejj.178.2022.11.20.07.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 07:00:21 -0800 (PST)
Date:   Sun, 20 Nov 2022 17:00:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221120150018.qupfa3flq6hoapgj@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
 <6c77f91d096e7b1eeaa73cd546eb6825@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c77f91d096e7b1eeaa73cd546eb6825@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 11:21:08AM +0100, netdev@kapio-technology.com wrote:
> I have something like this, using 'mvls vtu' from
> https://github.com/wkz/mdio-tools:
>  VID   FID  SID  P  Q  F  0  1  2  3  4  5  6  7  8  9  a
>    0     0    0  y  -  -  =  =  =  =  =  =  =  =  =  =  =
>    1     2    0  -  -  -  u  u  u  u  u  u  u  u  u  u  =
> 4095     1    0  -  -  -  =  =  =  =  =  =  =  =  =  =  =
> 
> as a vtu table. I don't remember exactly the consequences, but I am quite
> sure that fid=0 gave
> incorrect handling, but there might be something that I have missed as to
> other setups.

Can you please find out? There needs to be an answer as to why something
which shouldn't happen happens.
