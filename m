Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43362CD8BB
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbgLCONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLCONk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:13:40 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F267FC061A4F;
        Thu,  3 Dec 2020 06:12:59 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e23so1455356pgk.12;
        Thu, 03 Dec 2020 06:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xBK8JM0PJHLNoFEOdvQSEqTs4k9kFXjYQessqU1NrAM=;
        b=gf7QiBRLtEICd9g+cXW6r0YHcWAydR9Y3rXFakDaI1IyODiLtYWulnZ9i5qJ+WhpWs
         mT4gNRBSf3vwGqxKkfkwcEoAiRrW7FwlCmuQ2UyA22nE5dVmS8rRg+e/IkbN0Gy8jlAe
         cS4mE7eFTeh86JM2QqM88hW1cCg/evVN+F5R2wSsOmFi1knJkHHYmnycNm9sr7x6vcWu
         qGOr3zc0b+nP9J9oA4TTDGrvgKpygBGoczsk/ZlPsVSOvLO57kbwQ8HIHb3/0ejgNat/
         j8j2kdtNmIiYA1mZs9wlyOFnYGsv0MOY14TwzBGTsepBwblHIG22M0epKkF8saGGoU82
         XV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xBK8JM0PJHLNoFEOdvQSEqTs4k9kFXjYQessqU1NrAM=;
        b=pzMj7Xd/y92a5fJZ1M3vZ+hm0F8XA4hWhpNXvLzDL3ZP3f4PCfa9ZO98yIA+CtU269
         BKFbK90825g+dHlZTcTN6PeT9EPeIMrBRnYofSp2fRDYp6MkEnwQi765BI6/nzgZA4cx
         ZGP+sSCikS6dUJW10rMS09egEVPChl2ZC5wLdg4l+g7dSm5r09aLND/7qDAo1j0oAP/v
         0b9r2zXivpdXOJOcR1QBhbJoOAJl3LE1WNPSGPDGtdIZvD5/A76xs2TI1vakxYT1a+gB
         LzvNJnIAS5Uw6uCM3KeFJJkfPJB8u3O84a75K0aXBlJnFTzEGo6vAcUsFj+7uQJnnnU4
         nlqg==
X-Gm-Message-State: AOAM533GXREcrMM8bb425U0KFA/a0rjlPNUCDBWTQloQ8yk/ZK38CzO6
        B65qZh3PolA/XzwYtmBT7Ys=
X-Google-Smtp-Source: ABdhPJwKxOLeqXkFHFoXRFX52uQvO5gFZGIsvlNheWPwcYAraiy47OFm05xeEw1LBH3sTiLXx17eFQ==
X-Received: by 2002:a62:80ce:0:b029:19d:b280:5019 with SMTP id j197-20020a6280ce0000b029019db2805019mr530499pfd.43.1607004779577;
        Thu, 03 Dec 2020 06:12:59 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m18sm1656627pjl.41.2020.12.03.06.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 06:12:58 -0800 (PST)
Date:   Thu, 3 Dec 2020 06:12:55 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <20201203141255.GF4734@hoboy.vegasvil.org>
References: <20201203102117.8995-1-ceggers@arri.de>
 <20201203102117.8995-10-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203102117.8995-10-ceggers@arri.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 11:21:17AM +0100, Christian Eggers wrote:
> The KSZ9563 has a Trigger Output Unit (TOU) which can be used to
> generate periodic signals.
> 
> The pulse length can be altered via a device attribute.

Device tree is the wrong place for that.

Aren't you using PTP_PEROUT_DUTY_CYCLE anyhow?

Thanks,
Richard


