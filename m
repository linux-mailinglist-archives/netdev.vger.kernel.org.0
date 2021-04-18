Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2270B363651
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 17:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhDRPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhDRPLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 11:11:55 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96606C06174A;
        Sun, 18 Apr 2021 08:11:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f29so22481716pgm.8;
        Sun, 18 Apr 2021 08:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ke5WSxCRkYpPrC+7A8fEoFSGxA5olwH4RC9Qt2ZzghM=;
        b=XsnyZpqiWtpEOUWD5yebSAZ2y9whS4h8JWv1JYbmhBdLwZgdhy3Jx5+lV+sv/5gWHh
         fo5bIa3nyrk3HXWm9bRW7hQyISQzig+FpnJqsNcH1tHtY0ekaDB7DiYOfjiDc87gQtJX
         MUbdPpdP7H3FqQmWAUHvnsfzXgw87rMRS/IHgJBrQessOKhf9W7eozKc2gm2dSqhRV73
         8lJ2xZK/4703y0gP8k6UfP/HdboKFYhOBbW+HrKg3g5F1KBtHQyo+RGzbUCEKMrjImQj
         m9cCHcCItaKzurN0+BlOyifBajS9oI8bNw7Bfb2O6ZxofRQVgNCtiElSZWHfWyN8SMyZ
         w0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ke5WSxCRkYpPrC+7A8fEoFSGxA5olwH4RC9Qt2ZzghM=;
        b=IHtpUU1yTWBTWfsDDQhvj1PeIVIcDMEAzSLGGiatsWJ+N1kNrjukbyeE7ytEbhU2HA
         NFGEefPjIBG1WoTb/99wp07tuSuEJtEgN/UcPWzZSoOGm1NTnzQzeOoLb4MLInQAdhOI
         P/kKh+2Q/pCZsTQQiaWqvUBXchCl7uQA6AKEg+s5vmY85uv/3N/Gll4lbYaSOpAinCp9
         iUnngu+H7WcMi2iUM8hxWVmh3fZct/xB0EzcO5VDYr/vyBBoC0mhxa0H3KhXNWdtQoNL
         vDOs8TlgMWM2GnAyq/kpShjyU0HxIFVjgGWrPgENj0BJtJYgHWp78YWMQiWCcs0Uwi+b
         +4dA==
X-Gm-Message-State: AOAM531Tnj3MLeF1qdbbNaINQCeks3wGHersftJV0I83owiKKu3JLJSg
        VRxkyJIRKkthmmCVZ20vlgo=
X-Google-Smtp-Source: ABdhPJygkYIMPieMWWb7ZZyb4m4JHPlWlxAZ0A6zenFkY+LFzI+GH6YnNV1tQEwuBwKSf75EUN8vnA==
X-Received: by 2002:a62:1a4a:0:b029:25f:3159:78ea with SMTP id a71-20020a621a4a0000b029025f315978eamr2154517pfa.41.1618758687230;
        Sun, 18 Apr 2021 08:11:27 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n20sm5257043pjq.45.2021.04.18.08.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 08:11:26 -0700 (PDT)
Date:   Sun, 18 Apr 2021 08:11:24 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Message-ID: <20210418151124.GC24506@hoboy.vegasvil.org>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-2-yangbo.lu@nxp.com>
 <20210418091842.slmcybvjfkvkatiq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210418091842.slmcybvjfkvkatiq@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 12:18:42PM +0300, Vladimir Oltean wrote:
> 
> How about not passing "clone" back to DSA as an argument by reference,
> but instead require the driver to populate DSA_SKB_CB(skb)->clone if it
> needs to do so?
> 
> Also, how about changing the return type to void? Returning true or
> false makes no difference.

+1

Thanks,
Richard
