Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFFB49511F
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376504AbiATPMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 10:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376503AbiATPM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 10:12:27 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EDAC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 07:12:26 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c24so27708464edy.4
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 07:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WlGMQO7In9qZC+1LRTvxdGcpi2v1Vhj+Oy4FoUXD/tk=;
        b=fPC/B895XGi8IY4r4smrQRBe0bSZJfaF4lDFMcUK7W35iOUx9c+R1uxLrx9ZZpOa8v
         j56apXq4it/OuZH7KnNJJbkMvHZCpV12SbNi5wT1hJLY6ejkLdwbresU0nlPsCaUwfFq
         JC56iYHh79il4LzFocJIkKRU1SdrZI4CXEQ2A2fOzsk2IosyoKmDeiz/QhfLpn/HteZM
         zo8WhhyD/p6pXibq28qxXixxzAMdto4EyQEDjo3CanFgXsicruu1OuYuFA+JfOt7KAAO
         oW435Ix7lKSnOn7lmGcY94p/vjgVUg62ndvjw8zXyQLk3ZVAgKtGFOm4jwLGiFkdrmnS
         k8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WlGMQO7In9qZC+1LRTvxdGcpi2v1Vhj+Oy4FoUXD/tk=;
        b=GwZvGXIGxgw6c7WYYRenUTPs+/CJRHbA1aqRZRghFNo1594VkLlo/xTIgjcg0rC/4t
         P6PqxLdMjTUmf4XxH4SuMFwOP6zqOCzsj3etkg8yfqrKF+w+hVOfWXIZNwIXvZImm6M0
         WoYwfko4v2Xs/mf2nWdG1T/jE+JvJQnp8B/w0aMGvdNgLjNC+nr3nEBS648fQFNbxirx
         Fopeb84hnZHiqsDUyjFrcgr97BaG/HA+/XIXdfU8sMZLYTF7JOXL2VrrqNyA4nBvKHEk
         eSvMFZacKjsZbYWYbtt1h+plCyK3tRSxIVbqwetNwarunLzW3x1oInNY4kwtSB7+frG9
         Z4Xw==
X-Gm-Message-State: AOAM531alqicHS5RQ+USkx7XQZxbge/wXztboXhzC7DA08b0uTfd4LYP
        XMusDJSCfWRUP0tQHQzQZyE=
X-Google-Smtp-Source: ABdhPJxdGjoN1bCo2PhNnIxDwhSEZKOkGO6iVI23romvwj8M8nsFMABnUHdJshT8UJEhBaP/my+x2g==
X-Received: by 2002:a17:907:8a04:: with SMTP id sc4mr28898590ejc.392.1642691544657;
        Thu, 20 Jan 2022 07:12:24 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id w27sm1135562ejb.90.2022.01.20.07.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 07:12:24 -0800 (PST)
Date:   Thu, 20 Jan 2022 17:12:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220120151222.dirhmsfyoumykalk@skbuf>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yea+uTH+dh9/NMHn@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 02:20:57PM +0100, Andrew Lunn wrote:
> On Tue, Jan 18, 2022 at 01:58:39AM -0300, Luiz Angelo Daros de Luca wrote:
> > > the problem is checksum offloading on the gmac (soc-side)
> > 
> > I suggested it might be checksum problem because I'm also affected. In
> > my case, I have an mt7620a SoC connected to the rtl8367s switch. The
> > OS offloads checksum to HW but the mt7620a cannot calculate the
> > checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
> > move the CPU tag to test if the mt7620a will then digest the frame
> > correctly.
> 
> Some MAC hardware you can tell it where the ether type value is in the
> frame. This is often used to skip over the VLAN header, but it can
> also be used to skip DSA headers. Check the datasheet for the hardware
> and see if there is anything like that.
> 
>     Andrew

And what is the problem if the hardware cannot calculate the checksum
with an unknown EtherType? Is it the DSA master that drops the packets
in hardware? What is the reported error counter?
