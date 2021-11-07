Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1FD44764C
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhKGWfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbhKGWfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:35:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F29BC061570;
        Sun,  7 Nov 2021 14:33:00 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f4so54767241edx.12;
        Sun, 07 Nov 2021 14:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g1beptLkyGSdX+f8reR/EG4OD643gUZaFb6uQDEsh0o=;
        b=GyCc1laX7hD02wLAfzwGd2dbH5IlpmvThwH6kks82GGJimXKYi30KfE3Q0tqxbP4GY
         pfO/zqhMkCje7BzVZCIyuAc1e1mfoNu+lmc4/Z3kCALPEhK3mEC5c+CapU8liNe+Q2f/
         1J0DzrXcPc7CMSoJTX4aYpHYVOh9j5Qk3k+EuUbyKYxlznMVyoqAavyNsTCoXPlEVZD8
         ia74+tfuBSp8bVweWYp5apVpyZXT44m4tZu3RFkf4yjQqL90PbJ2fm9vEmwOBxcF5RPu
         yoBozByAbZmKs/8IeCzh9RtfTh/sFqrg2mOdpxfRTQQq2Uri0UAbRLeVVaDYGwQX7gmm
         O7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g1beptLkyGSdX+f8reR/EG4OD643gUZaFb6uQDEsh0o=;
        b=nr+LXwJXxw0HjgwchnmO8UTFqRgXc7Nzig4FyoQ7nkqCeSwKfxXxxGFE2Z0K6zXL30
         FNN8TWt10D2+9V7X4cg9uAsOM5+VuDlwLJ86xoYIVh3oHlHcjpzAlNtl0aR/dFfzEpEh
         uZqPHJfU6ITg3A69BWNEvJdavHjYfxZMEygHJi1W1DwMgtiYKOS3pM58yoLL58+05MqV
         mwnorfOz1MOa8gIue/NAMIQEwb9IbUqjw9fKyqm8FdDTSxXr6v98jTh4KGe5Vk0zqt6K
         dLHF9v2Jx+E3vxbCAUZnos3MQqQ0LpoiHV/S6Zr3ydFvIBHCgjETuJTtRNWnAfe2R1r0
         xvTw==
X-Gm-Message-State: AOAM530u8A/gEQZpq7a3g2Y2O1wMTXmHM5Ux/ilm1FEt0CyAPhnP48fG
        fADmVvX7S3V/5PiWIGu96qlQt1QbcW4=
X-Google-Smtp-Source: ABdhPJxzEo4l4hj+faK6h7D7LvFXxUgKJWKZPBDFm8CJtQlLDrBvBEsiUQ4CGDXMuxhMZ/Pwky6hTw==
X-Received: by 2002:a05:6402:455:: with SMTP id p21mr61159460edw.384.1636324379135;
        Sun, 07 Nov 2021 14:32:59 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id s3sm7177102ejm.49.2021.11.07.14.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 14:32:58 -0800 (PST)
Date:   Sun, 7 Nov 2021 23:32:56 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] leds: permit to declare supported offload
 triggers
Message-ID: <YYhUGNs1I0RWriln@Ansuel-xps.localdomain>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-3-ansuelsmth@gmail.com>
 <20211107230624.5251eccb@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211107230624.5251eccb@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 11:06:24PM +0100, Marek Behún wrote:
> On Sun,  7 Nov 2021 18:57:14 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > With LEDs that can be offload driven, permit to declare supported triggers
> > in the dts and add them to the cled struct to be used by the related
> > offload trigger. This is particurally useful for phy that have support
> > for HW blinking on tx/rx traffic or based on the speed link.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> NAK. The device-tree shouldn't define this, only the LED's function as
> designated by the manufacturer of the device.
> 
> Marek

Sure I will add a way to ask the led driver if the trigger is supported
and report it.

-- 
	Ansuel
