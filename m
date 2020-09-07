Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2325FCD6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgIGPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbgIGPRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:17:54 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1BDC061573;
        Mon,  7 Sep 2020 08:17:52 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b17so4489253pji.1;
        Mon, 07 Sep 2020 08:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WmxQ1TCWh9ErVx2o7p8NTViaLgMIqPcYEFusknZqwqI=;
        b=t1cgqo7rKZqSJBgPGK8D56Ubf/mtwCDe1ZmLC6+tmdllzkFVR+ZoJEY3W0UuaK0VeG
         5x6pKpNiYya7bk79v4Rjg+rNA5p/MTUOGknwieskyteX78UX0a4MIF5JBNgulsLZkose
         0R2HBWg2w/BpJmYOX/Jp5AVKwewEhEYsR6v0+DvevJyIa84S5IsOxgPvP6jEcPO6eXRQ
         mZSoJnevEBi92fp76Jzwcf36hZ/UuuD+zuyBWmrYwF0QjJPwXQocS83l8BsLjuRnNWjC
         5QYai+9/Lk/avqm7Tu1q8AY2EwLF4swsi0FmiLpHcYEpjUaKN56XMyutuKyvSPbFZhgH
         tQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WmxQ1TCWh9ErVx2o7p8NTViaLgMIqPcYEFusknZqwqI=;
        b=nPae7tITWc990Yr7feP9VutTO5TFMBsuhNOodId75mwRBvgmB4Ks/T18AbBnO+s1NI
         Z/hpkL0yKpZpU3OusvxHz/5xSVN98hKTXYcKRbO2KqHWSMDLqsGXj7L7H3iMSKWaFcNq
         LrRWCY1uuaq/rGLCe2W7mL2di6n3MeX+x2+NOZTjnMnWUq2XH0MItZ2xqG5mb3yqwm29
         vNNdYi6BvUts4kZkliSLbhnGUJz8ty7AcZUPDkLnv0Jyi9OjVP6be1DN3vN1AXKn3mAb
         KoRyurkZoJUxCTZ+Wcp9jqmWcCGfs8OIFMScuK/apEShP2lM+RWqb+csOH2RjuSLGBdL
         o70A==
X-Gm-Message-State: AOAM533xzI83a1eDj11T7fIgFFvjySVhAFnVKhOUVslN0VKlShdzvXJz
        mKJ88XkvOru+RbBg9Mvdr5tYe9IpGg4=
X-Google-Smtp-Source: ABdhPJwIdV3RZW5cLJtksbg7hpSJsZniyydTuAeZPd2xB4V+NmxnZfBXPUjdHbh/2h/7NC1+I+IPJA==
X-Received: by 2002:a17:90a:46cd:: with SMTP id x13mr4319600pjg.101.1599491872287;
        Mon, 07 Sep 2020 08:17:52 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k4sm16698129pfp.189.2020.09.07.08.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 08:17:51 -0700 (PDT)
Date:   Mon, 7 Sep 2020 08:17:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200907151749.GB31299@hoboy>
References: <20200904062739.3540-1-kurt@linutronix.de>
 <20200904062739.3540-3-kurt@linutronix.de>
 <20200905204235.f6b5til4sc3hoglr@skbuf>
 <875z8qazq2.fsf@kurt>
 <20200907104821.kvu7bxvzwazzg7cv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907104821.kvu7bxvzwazzg7cv@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 01:48:21PM +0300, Vladimir Oltean wrote:
> So, I think that's not ok. I think the only proper way to solve this is
> to inform the IP designers that VLANs are no substitute for a port
> forwarding matrix

Somebody should tell TI that.  (cpts anyone?)

Thanks,
Richard
