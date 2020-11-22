Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C082BC30C
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 02:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgKVBx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 20:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgKVBx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 20:53:29 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E46C0613CF;
        Sat, 21 Nov 2020 17:53:28 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t8so11576646pfg.8;
        Sat, 21 Nov 2020 17:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MIe7JBVphd8V/7UhQ1MRn0n/7AgXswpdjQJ5okuNFK8=;
        b=rGoLRs+wcIpPA1aQLQ69VcyZHdImJznZrkhJPP19C1eKjna7sW7c6/LY0I0zbZZnpB
         Rw8wZEbAhAIOsZMl9vkxi60SGW7S8w5AMB4y79tDvv8WiBe013HgBm7lA/tluSnADfoi
         JsScBSYQHBGy36eJAgWAUIWw7Xdz8eNTdkkNHLGufUZinJy7tNFM38v3FoRz4eGuvxC8
         cF8UWFPl3yNAk5HpgSUxbVcZiiLIS3Pv2OVPsW9+FrFHHSdr2dAvs1VJVqufGdJDk4UD
         TAVlA0Ot4SdYs7BqGc5+bAWsI2BVugds9yJEqQMg9DTwjpNui9cFh6g4wh0e5+lmUFjP
         CVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MIe7JBVphd8V/7UhQ1MRn0n/7AgXswpdjQJ5okuNFK8=;
        b=ZVDr9TsC/3mbxEyYl7sUS1zc2ikhO5ajeUSz4BaT+k6dccMXkZBWGlC6uFQXol/jqj
         tObfutNeTVt/qZQf4ES7hNpa4c9Djj3JqkdJ24g2W4vH/wtLpQJ+r23nH0yk22QKg4eg
         MIY7FiWk1Nccpk0pC0TszBop7xdKZmjrjxW8cPgwBZoWO/G58sXWtJw7/wp9Umdhi0k6
         BPb3B3o1bHd0aHskUW1rv6P4Boqi7ewEGOPbTA2eUb+Lq+DIYrrK3KhZEmJTSeMNGYUb
         baK6vwb7cNZ6VFW/uAoeY9yIRWTBzQ8e1il/rKURdkOd8EzkWS7JXBTAo8JYZxdMVBr5
         9HzQ==
X-Gm-Message-State: AOAM533DRP1OOWKhe0vEYz6ByWfS4eoweRmTXh9dCk6Zfxq0YQj6E6Id
        N6MItJUy0y0B414QBmVPczM=
X-Google-Smtp-Source: ABdhPJxDu6RgGLguSifIbWrkq6bPuzL07yicCKTyRs3z5YJJan+n2YsInIIhkN6bOrhnlNTo7pglxQ==
X-Received: by 2002:a63:1959:: with SMTP id 25mr22212526pgz.201.1606010008181;
        Sat, 21 Nov 2020 17:53:28 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k4sm8306363pfg.130.2020.11.21.17.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 17:53:27 -0800 (PST)
Date:   Sat, 21 Nov 2020 17:53:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tristram.Ha@microchip.com, ceggers@arri.de, kuba@kernel.org,
        andrew@lunn.ch, robh+dt@kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kurt.kanzenbach@linutronix.de,
        george.mccollister@gmail.com, marex@denx.de,
        helmut.grohne@intenta.de, pbarker@konsulko.com,
        Codrin.Ciubotariu@microchip.com, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Message-ID: <20201122015324.GB997@hoboy.vegasvil.org>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118234018.jltisnhjesddt6kf@skbuf>
 <2452899.Bt8PnbAPR0@n95hx1g2>
 <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
 <20201121012611.r6h5zpd32pypczg3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121012611.r6h5zpd32pypczg3@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 03:26:11AM +0200, Vladimir Oltean wrote:
> On Thu, Nov 19, 2020 at 06:51:15PM +0000, Tristram.Ha@microchip.com wrote:

> > I think the right implementation is for the driver to remember this receive timestamp
> > of Pdelay_Req and puts it in the tail tag when it sees a 1-step Pdelay_Resp is sent.

As long as this is transparent to user space, it could work.  Remember
that user space simply copies the correction field from the Request
into the Response.  If the driver correctly accumulates the turnaround
time into the correction field of the response, then all is well.
 
> I have mixed feelings about this. IIUC, you're saying "let's implement a
> fixed-size FIFO of RX timestamps of Pdelay_Req messages, and let's match
> them on TX to Pdelay_Resp messages, by {sequenceId, domainNumber}."
> 
> But how deep should we make that FIFO? I.e. how many Pdelay_Req messages
> should we expect before the user space will inject back a Pdelay_Resp
> for transmission?

Good question.  Normally you would expect just one Request pending at
any one time, but nothing guarantees that, and so the driver would
have to match the Req/Resp exactly and deal with rogue/buggy requests
and responses.

Thanks,
Richard
