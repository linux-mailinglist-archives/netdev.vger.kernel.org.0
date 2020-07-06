Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06A42152BD
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgGFGhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgGFGhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:37:38 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E597C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 23:37:38 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so39471390wrw.12
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xwWBkFk6RN986GOG/12Xtl/4y20SlvTZY/q6FM8tW1Q=;
        b=aSIAEtPXgtK669+bOn5Ozc4VHf23KT7KycYh2uRYMbPTaTGiLUCORkS8QRaJueyS2e
         6zC3lWeWq+92XxxZ2YDI8ej929Sz+oxKqNPoaGcD6TKWiNZ70TfaHbA1eg11HpzoFSGU
         xgmIC+vjzr8j423Y8fca5ert/Bp1t+JEQsXgNom1QZOVTj41JMfiNTx/xeOKt+2TGY01
         lu7OGuOMm106emAT9yb1oQCeYXJXC/zK0QLksdmRrS4yoXbr8PwL6F7LOvfcN+XdW+8a
         cY9+jlcGis3enwDUwMYkintrvnVxN856C6v8drikA4RVNPybbArzo2i6CYr8p/xdAAt5
         FCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xwWBkFk6RN986GOG/12Xtl/4y20SlvTZY/q6FM8tW1Q=;
        b=Efth0OVr7KO3EFnd9VH35eKJLOXXOlZsWo8ASlcpjMdcGRLEJtFbKYZj2ukoAgq57h
         TcCTHKU10Dg2VKw96nAFR17ao/Zbr/otpCSBw7EwQaxZ+jN6RrJGEUn4BXuhJG/xoZP+
         7AYTlz2hCFk3VAFGAZsipc0Cm3krH4kmYQOIoxPpxViCNw5Btp/rXgWBU2tOqTD/ThE6
         l1lDv1RS44zg8S9mDXpGhvYU6VsMtf97U0WatUUZDfDTWewzlvSvBx6kGSEyWQZ+lWNj
         ZzGQTryV8TYbyxT2KqoSDlCuJcrAuqfV4/jPCgotu4UFNpqWBLzisjTw2tmzWFV6ZMAk
         rJxw==
X-Gm-Message-State: AOAM532I23sVzxdSuG4kgWiH+wGFRdeTb8A43FMpif9i6w8A4OSieZhS
        KB8UjC65Nrk3q5K7v2uNCD4=
X-Google-Smtp-Source: ABdhPJxxP7K0VHgt52jGxWPHCRZ0zppW+/qWmlSExQ19gWfzMzAwZq/zc4CrLR6Kcvh35Z/W5FjM3Q==
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr46349883wrm.62.1594017457113;
        Sun, 05 Jul 2020 23:37:37 -0700 (PDT)
Received: from hoboy (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id r3sm25729193wrg.70.2020.07.05.23.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 23:37:36 -0700 (PDT)
Date:   Sun, 5 Jul 2020 23:37:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/7] net: phy: dp83640: Fixup cast to restricted
 __be16 warning
Message-ID: <20200706063734.GA8486@hoboy>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-6-andrew@lunn.ch>
 <9d433028-1c46-d24b-f700-63f12c45f3af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d433028-1c46-d24b-f700-63f12c45f3af@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 01:45:50PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> > ntohs() expects to be passed a __be16. Correct the type of the
> > variable holding the sequence ID.
> > 
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
