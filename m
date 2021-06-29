Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00AD3B7843
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhF2TL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhF2TLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:11:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B29DC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 12:09:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id nd37so38143774ejc.3
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 12:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PY/2WH5hnilO8u4PmgXgGiXRhHzf3uFJjP0VaA/hWn4=;
        b=QKSsB4h3ID/kSdb7wt92GbeIhWMNyCrJgByY7HREdDhAvHoD1qW1tudgyyu16IU0F2
         2k9bC3KBxgbFB2zTPpkjB9j+EEYrpp5wyw54cU0rS+QNlajm0IUgfW/LTUZijVmRU4Yr
         3Tpti+RM4el2Jaa8SG4ltVLAkKO9GlE98FEMweO+g5MqB84JolKvEXOvvqz5g45yDxxW
         /724aRYmRxy8bs1+jOoFZpAM9JF+/tDh7I+NWCayDF+vzoDG7tDOvVN4hHvyToDA/3lN
         8PiwjdMkOBRis0vKmzfYQwH3nxTfuafodN7AWZG7kz53fEHtYgeyFth5aWfBw5M7W5NL
         9m4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PY/2WH5hnilO8u4PmgXgGiXRhHzf3uFJjP0VaA/hWn4=;
        b=m2cAz2ue5uAhTYVVKXPT5xYkmutIbsjgUWx5Zl8F6NHsTZVNtNk3jXYCLLre1aITOG
         +JJXJ51ur2L+AWn6AkW7zmqv9B0F+xErUKvvM+3bDuqUrrE16ESGJ2DkN9kr28gmEZsk
         IZxduso2CiSjyz6Obm3tRkAy21h/+DUqnYsXZI7QwHKRrC8NiVDQjFVpNPB2Q5BUkwk+
         CuLXTPWDYILTw11YlPeYAWl/phWy4eiXkFpgl8vVqh/f/Q/sCWjpj+S2HfU9ZD+wwamo
         nHXJD/rWVPSI6hDEiy5cfRtSY+YI85TEwBMV5wKI0EomknGwZavIkNDYzBryziLjYFli
         XYNg==
X-Gm-Message-State: AOAM533TQxLYXfGmD3E0+4N8x+3OACjuxp7pCaLDZprejrJNkyf5q6Px
        P5zcp4rGiquA+4rzGaJy0DM=
X-Google-Smtp-Source: ABdhPJyZcaQ0SliB2uagtAxsRZdZzU/nealf18lmN0FRMeoKlWt+wK5KUCrMzPQh4y9FbJ/Ftf2bXg==
X-Received: by 2002:a17:906:9be5:: with SMTP id de37mr9730803ejc.549.1624993765732;
        Tue, 29 Jun 2021 12:09:25 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dd15sm11812959edb.45.2021.06.29.12.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 12:09:25 -0700 (PDT)
Date:   Tue, 29 Jun 2021 22:09:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, tobias@waldekranz.com, roopa@nvidia.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v5 net-next 00/15] RX filtering in DSA
Message-ID: <20210629190923.kf5utzbhmmgszwwc@skbuf>
References: <20210629140658.2510288-1-olteanv@gmail.com>
 <20210629.115213.547056454675149348.davem@davemloft.net>
 <20210629185822.ir3vp52xkyddm3j3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629185822.ir3vp52xkyddm3j3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 09:58:22PM +0300, Vladimir Oltean wrote:
> On Tue, Jun 29, 2021 at 11:52:13AM -0700, David Miller wrote:
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Tue, 29 Jun 2021 17:06:43 +0300
> > 
> > > Changes in v5:
> > > - added READ_ONCE and WRITE_ONCE for fdb->dst
> > > - removed a paranoid WARN_ON in DSA
> > > - added some documentation regarding how 'bridge fdb' is supposed to be
> > >   used with DSA
> > 
> > Vlad, I applied v4, could you please send me relative fixups to v5?
> > 
> > Thank you.
> 
> Thanks for applying. I'm going to prepare the delta patches right now.

Dave, is it possible that you may have applied v5 with the cover letter
from v4? I checked and everything is in its right place:

- the READ_ONCE stuff for fdb->dst:
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/bridge/br_fdb.c#n447
- there is no WARN_ON in DSA switch.c:
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/dsa/switch.c#n167
- the additional documentation chapter is there:
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/networking/dsa/configuration.rst#n296

Thanks.
