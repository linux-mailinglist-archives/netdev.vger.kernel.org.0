Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C347942BF1F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 13:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhJMLpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 07:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJMLpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 07:45:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6ADC061570;
        Wed, 13 Oct 2021 04:43:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so9080275edj.1;
        Wed, 13 Oct 2021 04:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g4MqVLa5ZdKDHdC47GKJaVvbOT1P86V23mMh7Evbnaw=;
        b=gDkNW0jkBMTCnoK2VMT27fuLg3MaUrwNkO2Jz5dOa7Z0HfixcKOcefhlfYbOJRj5JJ
         Z9fCw8eUetIpQQRw+o4woUV48LuDiqvkZsnsy+GlwDPDxVekf3X7ISxZc5ZsUhDsG/n6
         3jIbIdjfXaNaR452utkvh/HoAWcnSEKzShaBjAvWFXImG3mj8dTcVQTdTOcO9NERQUKz
         WxLec11ZXbqpJXrlrY3DECkpT17W006l2BUwzmtKz7S6y2D1uU6+KcM2cRmzi5OtuA5q
         OzpFfQlxt8dml9auMHgbNEFbmFIbAWjjL9LJxRFX5S1Rg5VuDoJ2XrUCqkeivzhKLt7/
         NCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g4MqVLa5ZdKDHdC47GKJaVvbOT1P86V23mMh7Evbnaw=;
        b=pLeFBAtAPqDDoqt/VrHqGfnXIcRvKmvdEVNda8WX+M91JfMq5sAzUBLuYnrphjO+dJ
         JuzXy6YFSRHrVu9nXR50UMTgIDcN37KLdL7LM+mSYmakSze1JHtqEzTJZjhHpKwFy0gW
         agX2u8ZcCKeC4771tEgIpyydaMENuHnplOGW6l/bh1ThxcwbSayBePNQWQJ4lfxKTgcS
         ANuw/N6CRZuJfVl7HB7KmYQFlUjnLevAlxURAojzuHL7sVyElQ8hdYcVMjSvp6msqT70
         5TzUEi3LQUdul9FfK1fSugotUcnK0vGyqpoQQREQrPKLnNzPddwoTPr2Kk2H/zhOMSoO
         LsOQ==
X-Gm-Message-State: AOAM533+GBDd9woJ/fXykS7JJL9R5MpTu1gZ/TXml6ZNv7B48+HVRG7Z
        NMKRFZcLAe4h0eUi6pglbmY=
X-Google-Smtp-Source: ABdhPJwGEVhhSaULnI8/ipATz3k4a58wtdnd+ardQs5w04p2XWY+cPRHNGeiDNnXkBACxyCL2ls6rA==
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr40661799ejc.553.1634125382850;
        Wed, 13 Oct 2021 04:43:02 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id se12sm6553144ejb.88.2021.10.13.04.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 04:43:02 -0700 (PDT)
Date:   Wed, 13 Oct 2021 13:42:59 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 05/16] net: dsa: qca8k: add support for cpu
 port 6
Message-ID: <YWbGQ4omD537ZBh1@Ansuel-xps.localdomain>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
 <20211013011622.10537-6-ansuelsmth@gmail.com>
 <20211013041004.29805-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013041004.29805-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:10:04PM +0800, DENG Qingfang wrote:
> On Wed, Oct 13, 2021 at 03:16:11AM +0200, Ansuel Smith wrote:
> > @@ -1017,13 +1033,14 @@ static int
> >  qca8k_setup(struct dsa_switch *ds)
> >  {
> >  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> > +	u8 cpu_port;
> >  	int ret, i;
> >  	u32 mask;
> >  
> > -	/* Make sure that port 0 is the cpu port */
> > -	if (!dsa_is_cpu_port(ds, 0)) {
> > -		dev_err(priv->dev, "port 0 is not the CPU port");
> > -		return -EINVAL;
> > +	cpu_port = qca8k_find_cpu_port(ds);
> > +	if (cpu_port < 0) {
> 
> cpu_port should be of type int, otherwise this is always false.
>

Sorry for ignoring the prev review. Now I see what you mean and you are
totally right!

> > +		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
> > +		return cpu_port;
> >  	}

-- 
	Ansuel
