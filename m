Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C861E5B4EB8
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiIKMTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 08:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiIKMTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 08:19:12 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB3C2ED49
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 05:19:10 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t5so9018885edc.11
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 05:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ESNqHKzFYRbLllUT/xcQbfHQ8QXquEYLd9ELgyLatYk=;
        b=hJuefVBhDOKbSlQyYiazURVRh/Nb88mHm5TVWlL6VefcMrKw35Q28GhrZ/PCNCX9e/
         gF/DjaSTm4jOK1Umernv84uFlU03Zp0JaBAAwjsft5C2OhiS9hlgT0x1zy0tpURQYWpl
         lYePskarJuZyf2ypHi5ncZzALjeYics3vyQqWP9509i+bG4TgvdJ4SBdCdXbe7j9kQzi
         0ds9u01pjNnn1ABiteld3V22AnlCq/El9V+Mhuu7jkkYw3E3eeMrCYDzAypC1kL6g+0O
         cLOhOMmH/9YBcA1A/GQuQtmTKkWvahNEv3sLg1jGZG2bU1CChHYLJmGT8tgFRSsci6tS
         9FOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ESNqHKzFYRbLllUT/xcQbfHQ8QXquEYLd9ELgyLatYk=;
        b=bbsK1/EK2q6bQKlFwRSpN7zVv5tOGzd121MRwODfmk0Egw7xdTdaa3j9Zd/9WArYOj
         +IUddGbq6c5zjFPYoE0NLY1cRV3Sf2TYa6vV5BqQ6J3vbad/Dwfbwp1kdPUuLEai+xWO
         blYoigu7gQMv5AO3jYXkKvk8VVoll8vxRtT7NxoSUtxt6yG50Od5IIT1plu2dEN/ClU8
         UfPMwKUA2Uo8zDPO8+mJlJJ2EMsICdMAKYQjkPtuJIUpQKYXedX5u3ux8Lk+r52zgh8Q
         SgBUhX6zXvhTNoeNRZWVe0sPqj78mSZ1lbs3Sth26edARTcqhXp572letGE8VW7/Hpz5
         Q+AQ==
X-Gm-Message-State: ACgBeo10J3ySugY4W0x+VqxIOZeFI0mNwFemo3qzOxw8L9H7pGV2gNw0
        pNa41B/awij48j64ZWTSjUb1Pi/QfEKnMVlT
X-Google-Smtp-Source: AA6agR5nmGFg+8Hjqahjsc8MnyajDH9X1MZsIdwrVW5M4cihH+x8IYhT6SNQ54VlfBYFNDAQS4j2tA==
X-Received: by 2002:aa7:d4cd:0:b0:44e:e3ab:a995 with SMTP id t13-20020aa7d4cd000000b0044ee3aba995mr18352703edr.166.1662898748741;
        Sun, 11 Sep 2022 05:19:08 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l19-20020a170906645300b0073d9630cbafsm2854539ejn.126.2022.09.11.05.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 05:19:07 -0700 (PDT)
Date:   Sun, 11 Sep 2022 15:19:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v8 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Message-ID: <20220911121905.hhjauibp237r6dgk@skbuf>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-2-mattias.forsblad@gmail.com>
 <ee6ac1f4-4c80-948e-4711-7e7843329a16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee6ac1f4-4c80-948e-4711-7e7843329a16@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 10:34:35AM -0700, Florian Fainelli wrote:
> > +	int (*rmu_enable)(struct mv88e6xxx_chip *chip, int port);
> 
> Change the argument name to upstream_port to match the implementation for
> each chip that you are adding?

Or the implementations to "port", for that matter. But yes, please keep consistency.
