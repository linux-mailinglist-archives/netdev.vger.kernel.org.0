Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282D03B781C
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhF2TAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhF2TAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:00:54 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88020C061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 11:58:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w13so26717969edc.0
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 11:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z2Fb3+vtJUFLAOYibiQsrogriXMJFkIlpt7gzXo5b3s=;
        b=Nfoozq3nvMm1J+m68LVpsIw8XpkqmH77WiLXMjCDym3burytz0B5uLixgTCopwdwBM
         auDMtpAY67nCdQGgxNAWmOJ5l6ZDgJ/X4r5k9Sq4Bq9ijuyBZ0vsEMD0fntd1MYXjQuy
         MpmHkobYnu5tpaoJAF72qr8D7+oZsBCi9zITEeAw+FxyalldPTV/kmURPJIKU7d/ZExo
         lgLlzIhEpSp1WpD8bVCRpIUBqjo9Eb1BgDbJ0gkvo5hFM18c21BQBwjV0XNmcuvax+Z4
         uFua8+jNXdZCUmQbyzzOqJcMK1yTFuS8Cd9lHjLrsDeHsI54wYs0aPwe9L41wqIPhQRC
         BD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z2Fb3+vtJUFLAOYibiQsrogriXMJFkIlpt7gzXo5b3s=;
        b=Vjgh0oh20/VJyytvX5O/MmegaUS2UrTLUk6Eky2Xma5WZr5uZypG48mOpfmg6hI1c8
         zTJ1Zc3RBTZFl93mQnEaz5OafkmaD1sgnEtqzuuqVBLuOYj1/9lJJZVd0S8Ov8E7/Bhg
         iigpHVwD5toNiqABToORV16FGeazUP5wRgChAc4rO7nNcmhkQXGLdDC92DJ/k86NWan6
         RDIKz2drgjXUWGojVDpoZoj4VLC0/e25ti8ttQcYUnQFKImDZwjKazG3nzE3+7KrschK
         OolcCKuOGWFJUgbqp0lYK1e9DtYSkRPu+k3AZ3ARY8FGpqphyXjvChzhFitYkFYJ9Cwy
         RR1g==
X-Gm-Message-State: AOAM533RLIxlklR875W1PCyhOa/LFbNghdPn7zjIF9mMHjq/7C7nIwuI
        lco8o818C0snQuc/aj2uJLmPWOJU1lE=
X-Google-Smtp-Source: ABdhPJweMa1Ehvju/FvGa7XCAsSxYwPTNDavr9JV5zFi4klgVTB0+0PJ2TeisCmX8LVSq8+I7ClhnA==
X-Received: by 2002:a05:6402:d0a:: with SMTP id eb10mr43081181edb.139.1624993104116;
        Tue, 29 Jun 2021 11:58:24 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id r23sm10010077edv.26.2021.06.29.11.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:58:23 -0700 (PDT)
Date:   Tue, 29 Jun 2021 21:58:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, tobias@waldekranz.com, roopa@nvidia.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v5 net-next 00/15] RX filtering in DSA
Message-ID: <20210629185822.ir3vp52xkyddm3j3@skbuf>
References: <20210629140658.2510288-1-olteanv@gmail.com>
 <20210629.115213.547056454675149348.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629.115213.547056454675149348.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 11:52:13AM -0700, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 29 Jun 2021 17:06:43 +0300
> 
> > Changes in v5:
> > - added READ_ONCE and WRITE_ONCE for fdb->dst
> > - removed a paranoid WARN_ON in DSA
> > - added some documentation regarding how 'bridge fdb' is supposed to be
> >   used with DSA
> 
> Vlad, I applied v4, could you please send me relative fixups to v5?
> 
> Thank you.

Thanks for applying. I'm going to prepare the delta patches right now.
