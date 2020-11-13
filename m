Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9DF2B14DA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMDuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKMDuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:50:15 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A58EC0613D1;
        Thu, 12 Nov 2020 19:50:05 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id g11so3890449pll.13;
        Thu, 12 Nov 2020 19:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gABDaPkcpRWm59XVoAKUWYYqP1oIGF8Ef2Jtd6N0Tyo=;
        b=G8lEsSAua3HsCmja0zB/zOPY63CO+tQCw94u/xLgqwaasHysJ9oSVuBsJbpMhlTfSD
         vIv9SSpKtwP4aka7hHCkzIiMQf4m+QvjE1xBAsjMHJU4PVkPI/FoZhsCFtlkeUwmBPBV
         Vg+hSqIi6e3ubsSixfT/s6A6aRLCvloju3MT/MTx6pBgtdx5d90Zh2HjDCHX7QhICTkD
         TvyEvXqMCa+YIHj7sR7POk+/xFyRJT9vOsE6OSi0Ae7LOqcWLKKn4ibJHoYf49lL/x+V
         fAKYZUCxNj6NDvnQufM7y1fT4CN9qLuokxGTYPGGwG3XLJq1YSnXCAFxvIU/NwntErGa
         NPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gABDaPkcpRWm59XVoAKUWYYqP1oIGF8Ef2Jtd6N0Tyo=;
        b=Zzr3KcnMt9BCa5cM+cDQHo+dwDmmt0Z7dvGAsw+XCk0knSDSQlgLTw+h+kIC58L/u8
         LtEcWdAVWpDaE5637MQkqgQsNd2VSmwzBrEFKkL8mwHI91Jcz4N41R0IGjxsxbxaUJ6S
         05l1DWJ5dzVItCS+E/2K0pKB/8EHcUWDxU+UvFFB2V5EqY3KJr/cLizOPb6AhQZkGZY3
         ztQ4K3p0KczieL1/CC4bSR2dHx3vcrzWMPLYeSgiBn+Q1+0cGq0MRz4sXPW0uSOgLBMo
         LwY/QC/cT3M6QbA+j4jeCtDpwb9lEVpwlzACEaKVs7MV1hTJjbCAMyB4CU/cyoYQc8cS
         eudg==
X-Gm-Message-State: AOAM532quj9/WykCx91/OrKkOgQnQ8t+gx5Qy9ehi2d7+wvRXsiJBLzP
        0zih3rlW5eaH4erhnjJZcbI=
X-Google-Smtp-Source: ABdhPJyeyUBA3HpqDRkEW1v2E3CskKpk2vJI03ZCq7IfmMltMuGHtVNmHv5Wpe3R0nSsN9KtVMnelg==
X-Received: by 2002:a17:902:778e:b029:d8:d024:a9a with SMTP id o14-20020a170902778eb02900d8d0240a9amr525188pll.12.1605239405118;
        Thu, 12 Nov 2020 19:50:05 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b5sm8081594pfr.193.2020.11.12.19.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 19:50:04 -0800 (PST)
Date:   Thu, 12 Nov 2020 19:50:01 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Subject: Re: [PATCH net-next v2 10/11] net: dsa: microchip: ksz9477: add
 Pulse Per Second (PPS) support
Message-ID: <20201113035001.GD32138@hoboy.vegasvil.org>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-11-ceggers@arri.de>
 <20201113025311.jpkplhmacjz6lkc5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113025311.jpkplhmacjz6lkc5@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 04:53:11AM +0200, Vladimir Oltean wrote:

> Richard, do you think we can clarify the intended usage of PTP_CLK_REQ_PPS
> in the documentation? It doesn't appear to be written anywhere that
> PTP_ENABLE_PPS is supposed to enable event generation for the drivers/pps
> subsystem. You would sort of have to know before you could find out...

Yes, please!

The poor naming is a source of eternal confusion.  I think that the
"hard pps" thing from NTP is not used very often, maybe never, but I
didn't know that when I first drafted the whole PHC subsystem.

Naturally developers of PHC device drivers think that this the PPS
that they need to implement.  After all, the name matches!

(Actually, at the time I thought that this would be the way to
synchronize the system clock to the PHC, but it turned out that
Miroslav's generic method in phc2sys worked very well, and so the hard
pps thing has little, if any, practical value.)

The documentation is vague, yes, but I think even more important
would be to remove the word PPS from the C-language identifiers.

I'm open to suggestions/patches on this...

Thanks,
Richard

