Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80A52AB845
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgKIMbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgKIMbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:31:14 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1CCC0613CF;
        Mon,  9 Nov 2020 04:31:14 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id a71so8513884edf.9;
        Mon, 09 Nov 2020 04:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lOXCkHwDBXdk9Xu6WFNB+CaKyHv4hYFq+JyuIzbsveg=;
        b=N2W1TwSS8uB8pfIN1qZGvsZIb5eHziMIx0FvW0ArKChftD1BSzVnKtQDDcE9yU+cBP
         B/FzJAL6IXvxm3bS2TBJJrl6Q8Ocia/0O0ebR03aKP9oaaijgZrKHj9Z3KVQ3keememf
         RfukQOxG8bOedwOBliEhT9ujcZBqOnK4PRqDnfCuh7NAi5sE0T5fTRmAtdoQiQXOejbh
         rDQAh/+lT5cxAV9bnqUGw1QB4+eUxHaqAgnyxHC2iGFd7hWe3MajcSnKiNjjExHvd9qn
         i7mTRtcVkJtPmnhMspu7xjm7m0YFWwptX5tJ4+nKVq1Ai9SAh4hwR/5iaVqH3/2K977X
         q+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lOXCkHwDBXdk9Xu6WFNB+CaKyHv4hYFq+JyuIzbsveg=;
        b=uOAeP+fOVI1wyFUwzN6k29K1eDPl0drfM15SoR2q6OcNJq9d9fvoZpbd6a98FQwa1y
         YGQEJ8+RPFJD4G8Rzk3AnJwmOxQWGzFlYP+z5qo4C4Hujxvf7b8otjE6bsczBnapUcPt
         DQktwN1vTC85EwOn2Ib/P3mvNgcizJVAzorprv6Kj5HN+WyoN4quzTQoYr9OXIIskaQs
         CN2ucu7NMMIi2m6rQMAw4+jI/8xloFKiVu32EjzhpdYTETXH7KG2uWHsCMHNmvx6qP96
         +mSv1jbmeCD4cWOQR48xezMub22oYN/iOXS7VIa51OMMN/+4VUzjH53TbQkkERVNf2nN
         T88Q==
X-Gm-Message-State: AOAM533avnwnx4sPpE2tAgClps0COx3o2RBxejK+lpphyRjU2iL9tP1V
        CoOPJIlrRsmZhROY4B8y0NQqe2hs47I=
X-Google-Smtp-Source: ABdhPJz7cjiFS6mCCmso2niYkYSXB+F0DXGoaWW/qB1QJI//OcwZZ82zXXS7TMlwD6JrKDJ1xSjBCg==
X-Received: by 2002:aa7:cb58:: with SMTP id w24mr14896250edt.35.1604925072943;
        Mon, 09 Nov 2020 04:31:12 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l25sm8666680eds.65.2020.11.09.04.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 04:31:12 -0800 (PST)
Date:   Mon, 9 Nov 2020 14:31:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201109123111.ine2q244o5zyprvn@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <20201108235939.GC1417181@lunn.ch>
 <20201109003028.melbgstk4pilxksl@skbuf>
 <87y2jbt0hq.fsf@waldekranz.com>
 <20201109100300.dgwce4nvddhgvzti@skbuf>
 <87tutyu6xc.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tutyu6xc.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 12:05:19PM +0100, Tobias Waldekranz wrote:
> On Mon, Nov 09, 2020 at 12:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Nov 09, 2020 at 09:09:37AM +0100, Tobias Waldekranz wrote:
> >> one. But now you have also increased the background load of an already
> >> choked resource, the MDIO bus.
> >
> > In practice, DSA switches are already very demanding of their management
> > interface throughput, for PTP and things like that. I do expect that if
> > you spent any significant amount of time with DSA, you already know the
> > ins and outs of your MDIO/SPI/I2C controller and it would already be
> > optimized for efficiency. But ok, we can add this to the list of cons.
>
> You are arguing for my position though, no? Yes it is demanding; that is
> why we must allocate it carefully.

Yes, if the change brings additional load to the MDIO/SPI/I2C link and
doesn't bring any benefit, then it makes sense to skip it.

> > So there you have it, it's not that bad. More work needs to be done, but
> > IMO it's still workable.
>
> If you bypass learning on all frames sent from the CPU (as today), yes I
> agree that you should be able to solve it with static entries. But I
> think that you will have lots of weird problems with initial packet loss
> as the FDB updates are not synchronous with the packet flow. I.e. the
> bridge will tell DSA to update the entry, but the update in HW will
> occur some time later when the workqueue actually performs the
> operation.

I don't know how bad this is in practice. It's surely better than
waiting 5 minutes though.

> > But now maybe it makes more sense to treat the switches that perform
> > hardware SA learning on the CPU port separately, after I've digested
> > this a bit.
>
> Yes, please. Because it will be impossible to add tx forward offloading
> otherwise.

Ok, so this change, when applied to mv88e6xxx, would preclude you from
using FORWARD frames for your other application of that feature, unless
you explicitly turn off SA learning for FORWARD frames coming the CPU
port, case in which you would still be ok.

I need to sit on this for a while. How many DSA drivers do we have that
don't do SA learning in hardware for CPU-injected packets? ocelot/felix
and mv88e6xxx? Who else? Because if there aren't that many (or any at
all except for these two), then I could try to spend some time and see
how Felix behaves when I send FORWARD frames to it. Then we could go on
full blast with the other alternative, to force-enable address learning
from the CPU port, and declare this one as too complicated and not worth
the effort.
