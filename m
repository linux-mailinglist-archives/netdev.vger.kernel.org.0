Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A935E449F14
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhKHXlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhKHXlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 18:41:05 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A89BC061570;
        Mon,  8 Nov 2021 15:38:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so38004442edv.1;
        Mon, 08 Nov 2021 15:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JRpTU836KJIcI/w/szpWPlgNMc8fZQkmkoSfEheJIwE=;
        b=JgO4tYCjGwP8syDXVvYL9UuZ8OJeKqUzaaRM6Att58LC3H3yQ0xhexdLrTPD2B8vrc
         PMsuLkQ3DlPlofkMS/hGhAK9hxnBWtMlrkv29GDp0+yq+nE0yV3V6iDJ64H0sNdsD1Gk
         Dego/IdLo86F4S33dK8IkS0i1FzNUDjzxC61HP5ZGm59bgwYIAcl1Ma/lD3E+9bUWfb7
         xNSkvzNoEIHivMOcuB9Lx7nj9TGh4zeWS4MXjzXlCW2TNdCtnOWO65PrwZy5cRFzkkw2
         3NccN6VPuedQZbd23qTkUnvXqnox19x3HLxYBCX+CQxbDdEK18U0zmD/+/76ueYahq5J
         XsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JRpTU836KJIcI/w/szpWPlgNMc8fZQkmkoSfEheJIwE=;
        b=VX1A0GGfaEWduV2CQyQQ1MzsLHbx56930prAobPNAP1lknCcm8RmA5/C7XUxPTakbv
         ZpwIPPmSHdNuDyw65JYCN4Qk4cr3uSzue5PZBYJnJJgFr+pqaFPw2OXI/D3ada1LuCtc
         1bqHCIr213o9ijYFOpkK1AlN8q4K12HEZSfem+tipR6It6MRlzI9z5EMNqUa0GDA3WYn
         /mr6YxhQj3dxgJuaVExCb4Rug45IM9hny1zeX5/d3R8xA2Cgo3Ri6Vhh6NeptWABJ6c+
         ThioDhuXYQQRDwiKlyuZ95rIGUYMUkp+Z6qOmxWD1/Fw9Qkpc3dP4Lra5HhBIsCb/ape
         /jtw==
X-Gm-Message-State: AOAM533PNCIjUF2rIK6KAvuLSlpsjdL2dqzSChkkcuseyN2ISNHewTh1
        PC0fd0yD3s2zh5MxB75lpIQ=
X-Google-Smtp-Source: ABdhPJwRQ1P5Hyp5rXtLpmm/RZZ9gUj3EPIRLTDs/xJ0Ww0ar5b0tkF0wK8/1V75DrIuOn3IRDUvpQ==
X-Received: by 2002:a17:907:1c1f:: with SMTP id nc31mr3869561ejc.210.1636414698535;
        Mon, 08 Nov 2021 15:38:18 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id k9sm9972740edo.87.2021.11.08.15.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 15:38:18 -0800 (PST)
Date:   Tue, 9 Nov 2021 01:38:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabor Juhos <j4g8y7@gmail.com>, John Crispin <john@phrozen.org>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
Message-ID: <20211108233816.tnov6gufaagdrhlv@skbuf>
References: <20211104124927.364683-1-robert.marko@sartura.hr>
 <20211108202058.th7vjq4sjca3encz@skbuf>
 <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
 <20211108211811.qukts37eufgfj4sc@skbuf>
 <CA+HBbNGvg43wMNbte827wmK_fnWuweKSgA-nWW+UPGCvunUwGA@mail.gmail.com>
 <20211108214613.5fdhm4zg43xn5edm@skbuf>
 <CA+HBbNEKOW3F6Yu=OV3BDea+KKNH6AEUMS07az6=62aEAKHGgw@mail.gmail.com>
 <20211108215926.hnrmqdyxbkt7lbhl@skbuf>
 <CA+HBbNH=31j1Nv8T67DKhLXaQub2Oz11Dw2RuMEWQ3iXrF2fxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HBbNH=31j1Nv8T67DKhLXaQub2Oz11Dw2RuMEWQ3iXrF2fxg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 11:13:30PM +0100, Robert Marko wrote:
> > The driver keeps state. If the switch just resets by itself, what do you
> > think will continue to work fine afterwards? The code path needs testing.
> > I am not convinced that a desynchronized software state is any better
> > than a lockup.
> 
> It's really unpredictable, as QCA doesn't specify what does the software reset
> actually does, as I doubt that they are completely resetting the
> switch to HW defaults.
> But since I was not able to trigger the QM error and the resulting
> reset, it's hard to tell.
> Phylink would probably see the ports going down and trigger the MAC
> configuration again,
> this should at least allow using the ports and forwarding to CPU again.
> However, it may also reset the forwarding config to basically flooding
> all ports which is the default
> which is not great.
> 
> But I do agree that it may not be a lot better than a lockup.

I'm not sure what you expect going forward. You haven't proven an issue
with the actual code structure, or an improvement brought by your change.
Allowing the hardware to autonomously reconfigure itself, even if
partially, is out of the question (of course, that's if and only if I
understand correctly the info that you've presented).
