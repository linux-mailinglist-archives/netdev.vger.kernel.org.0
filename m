Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F8B305589
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316980AbhAZXNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhAZVx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:53:59 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7FFC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:53:19 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g3so25209411ejb.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QX8KIowDTZjJROPyEgbNhIvy3AIeShxW9GK0WPW8gNc=;
        b=P/m9hYaPo4KCzQ6HGwVT5eH1lW02mYCVyqFcRF80dF301wjKV39DqznqYJD/DsMEhC
         oeo+reiI49t8xnrEoD+nZvMpP7i+R14MjwY/B25LwlP8UR1dx3QVLASxzGi3+w3c2+9B
         S0hvC6VYNYBvoj2SsoenHbgmWhpZxP0Xe54YPkXS0LjjQoV5k2TLr1ppGabMpKxh3tub
         HtmTanFn6OZ/fvThD3jQ599P+IZu6ObrolKJjfVVwdyifsan9lotfupRre9/22GvFSzp
         FC2Rp2HogjSXJAZM5/2qadQpedKQjpvHFqnH5rFPkGMRcAm2lV5369cLC0tmVIdtxMjD
         ZWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QX8KIowDTZjJROPyEgbNhIvy3AIeShxW9GK0WPW8gNc=;
        b=fipfqhtdHt1GjtAurK9BunS76kd/zihu3UsRGGlNyMGTI+k1SNCjR+KlNM5si7b5PB
         rtAFcyJnj/XJSmotxlOQTsWsWdgCkiiEDy+5ckurRGim38LrjdJ8I1k7MYdHxuemRVF3
         GOJw8p9gJFf9ueYx71Lqv8P93BVqj2a4DRKPCI0cpMnu56lN/Ozm1yAGWJq/32/dzquC
         l2eLixhetkXQrjDtkRbUedZhul+bXVZb4My9s1lnjvH9Pg/U2j1Xuhd7jhcgZPKXfzR3
         bZrGVwoDFbMdQ7bj/6nQc9hqm0EsDATvoh1XTB/jxH+ughT8/5SW4Gnxu9c75X6kwW+L
         AE9A==
X-Gm-Message-State: AOAM532DpW7s1BjL0BEGPzxN4ymQewL2X8aShmQP9ALACHuxRyYXosiK
        ENl9+Mw7Ul6X4PgB8WNZdYc=
X-Google-Smtp-Source: ABdhPJwX8F5rKSNgurRp6dsCdbINuBP6eS4GMx6rTl8ttEP7AdyZ1RNQoWo/PTo+957IUYgu2gG1Ng==
X-Received: by 2002:a17:906:7948:: with SMTP id l8mr4763543ejo.550.1611697997989;
        Tue, 26 Jan 2021 13:53:17 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b26sm27181edy.57.2021.01.26.13.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:53:16 -0800 (PST)
Date:   Tue, 26 Jan 2021 23:53:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: mv88e6xxx: use
 mv88e6185_g1_vtu_getnext() for the 6250
Message-ID: <20210126215314.3i3gs3bcy3rxxscp@skbuf>
References: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
 <20210125150449.115032-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125150449.115032-2-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 04:04:48PM +0100, Rasmus Villemoes wrote:
> mv88e6250_g1_vtu_getnext is almost identical to
> mv88e6185_g1_vtu_getnext, except for the 6250 only having 64 databases
> instead of 256. We can reduce code duplication by simply masking off
> the extra two garbage bits when assembling the fid from VTU op [3:0]
> and [11:8].
> 
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> Tested-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
