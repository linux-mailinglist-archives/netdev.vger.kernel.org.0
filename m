Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFF2CE4AD
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgLDBBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgLDBBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 20:01:39 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6ACC061A51;
        Thu,  3 Dec 2020 17:00:58 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id jx16so6261884ejb.10;
        Thu, 03 Dec 2020 17:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8n6wwjYgChlAVqfmH483TiY/2xa2k7YWDunQ91Fs8HQ=;
        b=k+egXQz0y+luTnzzFHeF7ngy0eK3UueIg9YxEdNSERA+uo8POU/JeCb22f0xILB+tc
         GPDQG/5jQBW6uA2pDVLiWPGo55Y2c7iJ7OcIdhaSBT9gocKE++p0XvYhxQnbB29Go8Pr
         GL/iLmeIe1n43MC5RcBGFsE4hLErEldpok+mO1cMQfK3LHj9XC5ejBnkEcQyVLa7Qgci
         GFS9rTq+dhqix0xTH+KxkcqpyVXMb+QNCWLgrJnmHnny9ZlsRZ62l+X8eVWcAIBtsmvp
         VB0/k7sAydXU08xXfe9Pn/rtNbwj4nt08Zkjq7wRgFRlpbO9CTWWK8QkkJlxx1De0iqP
         0+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8n6wwjYgChlAVqfmH483TiY/2xa2k7YWDunQ91Fs8HQ=;
        b=jUhYZJzd2i9tn1m4LkU7G7zxTh1rsIrBR9KvqD1w9C2VLYlvfSrJc1hJo/vg1UdlcK
         DoIlNTznljrryAdfHN0IRQQadpXFaBQAzvgIfktDetb8+YuYJugibacTttuqlqZhtc3v
         wLcXMDx0RVAlb+vrGq68lg6bEXu0LJ6eFHc2dwHxbUxdqGfz8iqfARDqytfAeVPJZYTq
         kMrH2FvVT6qIGoKOMKJsQ2qDZ7b3yYodeRLmjsXM3Wse9QkISrvBaGrj/jV54DVsj4MK
         t0v1ylQTHATB90w1PCaNtAuok1AAAbhipwVxhqL2Y6FBt2R4QHsSAY8sXn6MltsKeWGz
         qcWg==
X-Gm-Message-State: AOAM531Cl2a/2XupLlDtwjjydK4b2SRsO/HBwSnMpVDK60ZiqzYnehG4
        u6b0OKgLpTwehWlBfNswfIBssGqLkeU=
X-Google-Smtp-Source: ABdhPJzGf4h/EtobVqYCGg7XXprLO3dPpHol0SyIoQRgJTUotQVWlYjOjhNJdOtyx60n1h7IPUlH+Q==
X-Received: by 2002:a17:906:2708:: with SMTP id z8mr4747104ejc.428.1607043652735;
        Thu, 03 Dec 2020 17:00:52 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id k3sm1936776ejd.36.2020.12.03.17.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 17:00:52 -0800 (PST)
Date:   Fri, 4 Dec 2020 03:00:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 9/9] net: dsa: microchip: ksz9477: add
 periodic output support
Message-ID: <20201204010050.xbu23yynlwt7jskg@skbuf>
References: <20201203102117.8995-1-ceggers@arri.de>
 <20201203102117.8995-10-ceggers@arri.de>
 <20201203141255.GF4734@hoboy.vegasvil.org>
 <11406377.LS7tM95F4J@n95hx1g2>
 <20201204004556.GB18560@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204004556.GB18560@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 04:45:56PM -0800, Richard Cochran wrote:
> On Thu, Dec 03, 2020 at 04:36:26PM +0100, Christian Eggers wrote:
> > Should ptp_sysfs be extended with a "pulse" attribute with calls
> > enable() with only PTP_PEROUT_DUTY_CYCLE set?
>
> Yes, that would make sense.  It would bring sysfs back to feature
> parity with the ioctls.

Which is a good thing?

Anyway, Christian, if you do decide to do that, here's some context why
I didn't do it when I added the additional knobs for periodic output:
https://www.mail-archive.com/linuxptp-devel@lists.sourceforge.net/msg04150.html
