Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2192824
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfHSPQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:16:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33841 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfHSPQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 11:16:42 -0400
Received: by mail-qk1-f196.google.com with SMTP id m10so1707535qkk.1;
        Mon, 19 Aug 2019 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=24B83GAj2zrYC67kLJsxEOw0y5XbbNOfyVyJzgA3rdw=;
        b=Asot8gPdIFuuMjVgsBA6+u074prDvDVWXLNd5isC8rSw0AjNMr3648EAb6eP83IoIJ
         SD1fIFkYpwsy52ssJtroXf8k8mPSm/6N3zgCWJgZhta3pnRGfZk16sM+Gans4YkxEZ2Z
         5PEXbt3HcsdLAAV3XguWoZVEotWa4H/bFgxshaLKS8pM++5m24ymRd/2mHraHlRnXu+x
         Oc0gOHjnCiayflb9CBx/WQn8JgTNIILt0EoVW7RWqJ0ZFO2zri/qRWdNvrLuyC/YYASd
         n33TOjYhzDjydSSzNN3PxDeOR4vxRrRMIEmdDooG9Eq8lvBBUjW30TG1xxcbwnDQ7jUm
         yRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=24B83GAj2zrYC67kLJsxEOw0y5XbbNOfyVyJzgA3rdw=;
        b=DNQZfL4aSNkw0RkYS5kxEDj8Lvz8XPCNc6pNKNkqH3SMZwxqCKVAZEYDb2Zf3i6lEU
         dKmOoRd0pditJpjDoTO3InhwMeIismayGZt1qSAQ2mH2QdGz54gThDWvtzVjeAvFV2Yh
         mEfvmDaEVhff33ijN5Iq95r0U/W9D8il7lrfYfbbTm6AJjMhuEM7eDjIB813TE7/ujIp
         AWeHoJw4TZDS2BDl/S828rw5m2ax04LmgWkGx/7zZz5ZVzarh4OmC69oVUAWWftSuLbU
         bxXiadang3PI70ihNxF+jnz+M0LrBn1r1w3cgSHklI99k4RL1D89reUCwc0Z94rex8S2
         sQrg==
X-Gm-Message-State: APjAAAXIg5noyHToZEu+eOhOQmg32npXk8PUeThWp50/NK10pmtIztrm
        J2tW/0g3tbOyQU3jqVqmvdw=
X-Google-Smtp-Source: APXvYqyeMoQKzzB2cvMJ5CgtPb7GqHXZqwrsN8c92XAswh0+10YEXSUuqDoz4U5jfepWD4UVwTym3Q==
X-Received: by 2002:ae9:f804:: with SMTP id x4mr21041900qkh.178.1566227801585;
        Mon, 19 Aug 2019 08:16:41 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y188sm7927972qkc.29.2019.08.19.08.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 08:16:40 -0700 (PDT)
Date:   Mon, 19 Aug 2019 11:16:39 -0400
Message-ID: <20190819111639.GB6123@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
In-Reply-To: <20190819132733.GE8981@lunn.ch>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
 <20190816163157.25314-3-h.feurstein@gmail.com> <20190819132733.GE8981@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 15:27:33 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > @@ -45,7 +45,8 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
> >  {
> >  	int ret;
> >  
> > -	ret = mdiobus_write_nested(chip->bus, dev, reg, data);
> > +	ret = mdiobus_write_sts_nested(chip->bus, dev, reg, data,
> > +				       chip->ptp_sts);
> >  	if (ret < 0)
> >  		return ret;
> >  
> 
> Please also make a similar change to mv88e6xxx_smi_indirect_write().
> The last write in that function should be timestamped.
> 
> Vivien, please could you think about these changes with respect to
> RMU. We probably want to skip the RMU in this case, so we get slow but
> uniform jitter, vs fast and unpredictable jitter from using the RMU.

The RMU will have its own mv88e6xxx_bus_ops.
