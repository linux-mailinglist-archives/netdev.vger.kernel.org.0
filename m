Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CF22F6D8C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbhANVyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbhANVyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:54:16 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99896C061757;
        Thu, 14 Jan 2021 13:53:35 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 6so10456687ejz.5;
        Thu, 14 Jan 2021 13:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=anksxnkHLeB2FAcBB+QNuQEynmx4Nz/SvWBtlXjMqAo=;
        b=H1KvecnshTTJJvl6oYxiMrUpeKIvMsVFTuwKWYTqwN0viE2gkVbViHxMY7pTvZwkF6
         SfnokzXVw4QsrRqnJJZ+rwr1Xq08/ghppgwt1WvY9V2lMOy6wjEOaXBX1FrWZ1+jZLKw
         Vzfuh20qc7tr27pfNNd8Oa+fj6QZ353GFfvPlhPKWO+CEreMSIxbCSSItSE7j6DwtTcB
         K8JNGuXSLglk6swAV9nj/MgSTHOI0sappam6DgJ2m6T05vwj3hg+0NSuebLpcEVepvOF
         v/H3/XLGAgNwYTAHKeYw40/WWQddyribYpDOEhhu1qwx2uqWEc3iDsqHqRBCHDVdvJKy
         Bqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=anksxnkHLeB2FAcBB+QNuQEynmx4Nz/SvWBtlXjMqAo=;
        b=nKk/wJH7tkhcMQNu6XYSUfAz26IC6IrW9mxExsdU/bqoDPn5RJ3ujIgFOHYwpOf/tn
         XCSiJDG/O1aC2UDdNXgt9ohP378zweIZU2KWN3TB/GM6VYUbYjBsazwzpy8mKyQWCeiF
         iQZjIeWhYF0xA84cHx/gQvjQ7mtRFz5lnUnCHzqN9kd3RHTAUpVy05IzIhtJBqfLAtg/
         Ezznq4HOsQqgMe5HDhhEAlHQrl6geOgg2AXcF6sUGnjs6GiV01qS8oWTsLHBALpVoVIG
         CMiOuRaoVqMDJ/43OLhUq9XqlV6ICjwlxE8WDR8eud9SYLBx1rxRWtRw7LU5Ggm+Vozu
         mBiw==
X-Gm-Message-State: AOAM531KzOOB/oVC1OUS5wOIoHp1S3okrZzzzp3qNWXloF7zp9bmBL7s
        zv65rpddF3RBSjJ+4h/GtqGDc/4bb94=
X-Google-Smtp-Source: ABdhPJytYbx7q17j2PzhRH4JQ1eRxP6HTe6G7jsLIaZlU6db6kZE0AmQXsza/rC+fXoWvxCwqyMlHA==
X-Received: by 2002:a17:906:9a07:: with SMTP id ai7mr6738778ejc.216.1610661214389;
        Thu, 14 Jan 2021 13:53:34 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id pg9sm2438300ejb.102.2021.01.14.13.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 13:53:33 -0800 (PST)
Date:   Thu, 14 Jan 2021 23:53:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] dsa: add support for Arrow XRS700x tag
 trailer
Message-ID: <20210114215332.k2hkfdlmvxcdyz5a@skbuf>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
 <20210114195734.55313-2-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114195734.55313-2-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:57:32PM -0600, George McCollister wrote:
> Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> is modeled on tag_trailer.c which works in a similar way.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
