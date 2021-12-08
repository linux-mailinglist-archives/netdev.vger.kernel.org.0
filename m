Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7846CB9C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243899AbhLHDnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbhLHDna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:43:30 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E46C061574;
        Tue,  7 Dec 2021 19:39:59 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p27-20020a05600c1d9b00b0033bf8532855so874084wms.3;
        Tue, 07 Dec 2021 19:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=riVC5a42wHVh4WAZ9tYx5I3o1Gg5wk3HhmoSccz/Jv0=;
        b=fZogIUao7WYXn2E73Vnw1/mSN0mj6Vrao3sTangmjgT7XF3+e66jLDaEkUgH8BwhFX
         Hqpj1+TNRFjafGpuYnZmGhQsyFUsetoYJNNaiTZ75RoCzGHoLB/c+MiLd3Awe2njZlEE
         YsFlPXEKeJxSNz+o/jDyi6I+6pc/VMFhFwvYBGzd+ASiQ05Vj/xKuYdV7dg/97i5JU9l
         XD7OMX97dPunNtAX11qv/QtSJn3mhe26ZOtKuKWFMoT0XrXhOdwXJmQ5gGjsFNU6CufD
         uQebnZYiQdUr9zBPtTJiq+GA94SQpsrGosprbk7wFAv3upj9JqCkvqdfA/MNSg+9z75/
         iTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=riVC5a42wHVh4WAZ9tYx5I3o1Gg5wk3HhmoSccz/Jv0=;
        b=b9/9KoehQLAKPT2+y8mU6zFw/FtGS8Mk3QYRqI4dt6s2jkE4KT6Qi8C/eSmZaVhQRt
         +x7HjhvLnHpb0fAp4/DpM5JdZVPwswe7epnVeh1YDTNHtQe1kN5pg/QtDm6manETnOPT
         ozNcFRKmeYzRU+c/CKfq9TbNcTLaNOACzGhIrHFYnf/QgZgYQnyBFIQlkbrzN6YE2LvS
         rfA/pnJS+ZF7/0MYkrjrFex6SSrV4I5CtTI0EEjfEsiMN6vutAmupC+DBv4HYh5iNrfA
         58fDG2SWlLJvJ7e+Pwr7/xec2Cycwg2LL5EQwcWN9MVJoIKY8vZ0Yb61wHTbbRfHAkjr
         QNUg==
X-Gm-Message-State: AOAM533M+P1jmr/A8JKJJGNvIhn5Wn/jEpwNTU/kdXQHAmLYhJkgTuLl
        jKego9cZ9BH1gRDxCYzzP6rQcBP1SYc=
X-Google-Smtp-Source: ABdhPJxt3oUIH6vZ6J7GTuz+qvSrvX8yoP9WwM7eBE2PNhhztAqm2ibBUD/dZlz7AVjEjb86IRZIPg==
X-Received: by 2002:a05:600c:1083:: with SMTP id e3mr12412693wmd.167.1638934797715;
        Tue, 07 Dec 2021 19:39:57 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id g13sm1365052wmk.37.2021.12.07.19.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:39:57 -0800 (PST)
Message-ID: <61b0290d.1c69fb81.62af3.7a2a@mx.google.com>
X-Google-Original-Message-ID: <YbApAgQAzThzlRgN@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 04:39:46 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
 <Ya/mD/KUYDLb7qed@lunn.ch>
 <20211207231449.bk5mxg3z2o7mmtzg@skbuf>
 <YbAL5pP6IrN1ey5e@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbAL5pP6IrN1ey5e@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 02:35:34AM +0100, Andrew Lunn wrote:
> On Wed, Dec 08, 2021 at 01:14:49AM +0200, Vladimir Oltean wrote:
> > On Tue, Dec 07, 2021 at 11:54:07PM +0100, Andrew Lunn wrote:
> > > > I considered a simplified form like this, but I think the tagger private
> > > > data will still stay in dp->priv, only its ownership will change.
> > > 
> > > Isn't dp a port structure. So there is one per port?
> > 
> > Yes, but dp->priv is a pointer. The thing it points to may not
> > necessarily be per port.
> > 
> > > This is where i think we need to separate shared state from tagger
> > > private data. Probably tagger private data is not per port. Shared
> > > state between the switch driver and the tagger maybe is per port?
> > 
> > I don't know whether there's such a big difference between
> > "shared state" vs "private data"?
> 
> The difference is to do with stopping the kernel exploding when the
> switch driver is not using the tagger it expects.
> 
> Anything which is private to the tagger is not a problem. Only the
> tagger uses it, so it cannot be wrong.
> 
> Anything which is shared between the tagger and the switch driver we
> have to be careful about. We are just passing void * pointers
> about. There is no type checking. If i'm correct about the 1:N
> relationship, we can store shared state in the tagger. The tagger
> should be O.K, because it only ever needs to deal with one format of
> shared state. The switch driver needs to handle N different formats of
> shared state, depending on which of the N different taggers are in
> operation. Ideally, when it asks for the void * pointer for shared
> information, some sort of checking is performed to ensure the void *
> is what the switch driver actually expects. Maybe it needs to pass the
> tag driver it thinks it is talking to, or as well as getting the void
> * back, it also gets the tag enum and it verifies it actually knows
> about that tag driver.
> 
>      Andrew

I'm sending v2 with Vladimir suggestion so we can start working on that.
Hope with a some split code it would be easier to find the problem with
this and find a way to correctly validate the shared data between tagger
and dsa driver. (you will probably have to rewrite this also for v2 and
sorry for this)

-- 
	Ansuel
