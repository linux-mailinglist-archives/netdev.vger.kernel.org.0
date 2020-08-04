Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9529A23BFF5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgHDT3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgHDT3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:29:37 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ABFC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 12:29:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jp10so17164982ejb.0
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 12:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dQXsk2Gn6p+fNfrn+Xsi+CcY2ZVqR72jukgDZLAh21I=;
        b=JliyC5gu6lp7A+0TfyTkpmo73S2EjVH/Xw4fVz16EeHV5opCOLL0l9KRL2Geu7vf1p
         UK8q+yodZRi4NZDuFqp7XpZojXoB7PAiPGxILRY1JVnDg0SoxmjXbR7kwxl1UaCWMu/P
         MhCKiDs6iSL2FJkgylO+igeExkgOyoAdCTDJpBH+m/K6o3tOB4eQR9RwGpAMnB8lI/T+
         z7zGPXcf+nje7KWo3B9NxlwWUxA1wNkIxvO1dii07N7crbyYTd9rJF5bOMuGY/8wWC4h
         syfwrkjrF3RxmWT9BJ2/ON9MYuli0RfknNGM5HxOigDnm/hBkEGeinEG7SoFzd83Tn3r
         sWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dQXsk2Gn6p+fNfrn+Xsi+CcY2ZVqR72jukgDZLAh21I=;
        b=m4BnXj3VpIlNNkf/n2hhpwaHibdi1x4wsiZx48UwhCAYqHzvZBn3GgrxGD78uGVdhx
         rZ7sQ7DIHLXchaNhUoMnnX2mLxDriAbAQpGgaeY+agBNGKNNAqUM4XdhHKa1aFHTaIZl
         cLLU/0vFJwkJn51QX07EbUGo9Isfvm+Aat3pI7PwwMyFnlXSeiXG1OjE4HmtFRD7dWSS
         YjhWCZvPuGusNOVJk5PX8/SmOOTdVewhBQVgfscRMXXozjbjoG49HDSaJhSh+VKrZH/G
         Kpn1xHAplWGFgTofD28hVDw3YiRD3QoXBHd0RSiI9J5DTvL9eRFVxI816eisPwqDX9wc
         r+lw==
X-Gm-Message-State: AOAM531E6o/vjkE1mbtSnA5/z5+uJcsKuPEv5wTETqNUBaSmkTJ8eSi2
        A3gfU39Ln39UduKQLyyUIQY=
X-Google-Smtp-Source: ABdhPJy0nx91d+oYNXzipTbo1SfHypJpmV6nWWzSCX8Zt2VTD/CPG/k0q/96ljPHWFLLzWK5/dJw8g==
X-Received: by 2002:a17:906:ecf7:: with SMTP id qt23mr23842883ejb.314.1596569375734;
        Tue, 04 Aug 2020 12:29:35 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id s5sm18132230ejv.67.2020.08.04.12.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 12:29:35 -0700 (PDT)
Date:   Tue, 4 Aug 2020 22:29:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804192933.pe32dhfkrlspdhot@skbuf>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> 
> My 2013 commit was a bug fix, and hinted that in the future (eg in
> net-next tree) the stop-the-bleed could be refined.
> 
> +               /* Note: we might in the future use prio bits
> +                * and set skb->priority like in vlan_do_receive()
> +                * For the time being, just ignore Priority Code Point
> +                */
> +               skb->vlan_tci = 0;
> 
> If you believe this can be done, this is great.

Do you have a reproducer for that bug? I am willing to spend some time
understand what is going on. This has nothing to do with priority. You
vaguely described a problem with 802.1p (VLAN 0) and used that as an
excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
curious because we also now have commit 36b2f61a42c2 ("net: handle
802.1P vlan 0 packets properly") in that general area, and I simply want
to know if your patch still serves a valid purpose or not.

Thanks,
-Vladimir
