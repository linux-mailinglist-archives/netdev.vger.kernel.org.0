Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E9E23CCAC
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgHEQ5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgHEQzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:55:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8584CC0F26CC
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 08:25:07 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g33so7196821pgb.4
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 08:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YL+BaqEpeJebRbk1DIYfaXHsTGY8IoG3njUpx4OoEIA=;
        b=j3j0jUK5//lVBqiX13+Jn4kQ8WxY9iJFXHgfO8UNs3Vc1gkGwxnAGL794XiYewJ5Hj
         EFN1hOS0itb9e4KZpHBxS25M77W892EEuO5W74A60BkWyMsI2YrMGojvnbaafCgmIvAv
         vWTAF3agbJWyoOJceBRVfS0CTMOpohQW0JdjllX2Lj0L0iZothftmi1Nq14WjwGMKB0Y
         BKYAZgiM9ebs88B2kLxLw0HYUpdXDhvdZMwy8MdNW6/Ntbkhkc7wix9ir4W/VTxiraXj
         g8XJk05RGQDAYiEkGbgOcuG8JthWV4smuHM2h2wbtC9N6b/XhIE8pJ9dH3DK/ZZf3ZB9
         LebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YL+BaqEpeJebRbk1DIYfaXHsTGY8IoG3njUpx4OoEIA=;
        b=Nno5mE6LHuxZp4YtJImW6M1lufEln5HvH9lwk/anwZeOvwSB1F3g8Y4g+xgdZrajGE
         n5SkUFCh2XUO5qGWWNj9hlXrEx85NlKJB8dcWBnNjR8RAMZOQOe0hym6sQOrxY5xeMs0
         JQafA76bsf+NOjiKXvDOmWqFMciCht7rPAv39WOm5EqOy1L+6a55zasf++T+zDQ4LLLI
         Eyrr+d1NSLd3KcoxSWGLDvE1BCuf8UyNUWzpJLxNncdAAGNhnMIVykMq+Fki2waH9y8v
         zbM/HSEAxK7UpQkWWOEmsSocpp/0bOSV3IyLTXCEbVQVRLfcaoZO/3/iUglLRT/7LCh4
         I95A==
X-Gm-Message-State: AOAM5337xd7AftUvks0O1n62L1Ura+IoXPt3wou1al02fyX2PocHlTw4
        kEbHQZc85ytO446yQ+xg5So=
X-Google-Smtp-Source: ABdhPJweuoCdySCOB/JgcD313Hc2LjwwTh4QmU2wzlXiNm3eDokuNwmilt3dgFyCyWRoVRtyqdZfFg==
X-Received: by 2002:a62:1614:: with SMTP id 20mr3902556pfw.258.1596641106590;
        Wed, 05 Aug 2020 08:25:06 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id bv17sm3416026pjb.0.2020.08.05.08.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 08:25:05 -0700 (PDT)
Date:   Wed, 5 Aug 2020 08:25:03 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Petr Machata <petrm@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
Message-ID: <20200805152503.GB9122@hoboy>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de>
 <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt>
 <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:56:12PM +0300, Grygorii Strashko wrote:
> So, skb->data pints on Eth header, but skb_mac_header() return garbage.

This triggers an ancient memory in my head.  Now I vaguely recall that
there was a reason I made different parsing routines.  :(

Still I think it would be good to have the common PTP header parsing
method that can be used in most cases.

Thanks,
Richard

