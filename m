Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8D031687A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhBJN50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhBJN4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:56:52 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A06AC06174A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 05:56:11 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c5so1535495qth.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 05:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HqaaWL9GkybFbf1f9Nk80tEVe7WpQxrJxNKLFj1spnw=;
        b=anyo83kjJHccd8wb5UNEBYJY074jv7IYYrcnFOUvCB5q/nE5x3YSD31FhMbknM1UI3
         KGbjJOTZ6PJDz0mGE0jJ070iJloseEL7Zy+6FeHQg2OieytmrL8brSO+ALoOuJkEcRV5
         hDu7vR4bPAQT1m0Wjw+9D2qn+YGhA6sy7DhQrUNHp14QCeVAtTbF/bSS3r7B/9PLcAW4
         DzTZjNSiJd3TndsE7dxgx0BkF5/jvowH75BArBpx5PsEi7dsPLGi6dEln4dGnE+9b8rJ
         3tNObx5E/mW/j3/zsZtLqWgP9jwmkhFprayjCOpFuemqfpsZFOuH1A5kjTTDEIDJ0kWj
         gt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HqaaWL9GkybFbf1f9Nk80tEVe7WpQxrJxNKLFj1spnw=;
        b=L/Q/iqdFThJt9bSDgQEG2o+U47UAUEtotAL7Z304Qw13OvRvDY6uXlTAvyiZTl7RWs
         PKppRl5NRhEY/IUAiMGgsRxOQLb2BM8d9ll9cI0GDldWOpFjiobL90iQUc1ty3FnZYu5
         SCMK0haE1OxM6+U47q6lKC2cHAecXPFksFknel6nONF3VShe0rR3dGn7ueC4c82yHyl5
         BWQ4oTSQYR3mFU57oV2VWDsSqKdE/envqPMywYO2CFxBfPS1d31Vldvl2woYW1EyyitG
         4v9oADUAOyYdfhpwsYvEO51S2hzr2O7udN4wofChVBPZjGrMhYaSjL0yODTuVWMwgWE5
         jypQ==
X-Gm-Message-State: AOAM5339t24EOkbrWYXvZibDwqlxFzrMuthjCpI5/dIBwF7PspZNYs/N
        QLswdNVsgchXsaUzMyIOxBY=
X-Google-Smtp-Source: ABdhPJwt70PKXKqjfSoycldyLxj4fHBd6QvrMNEUpBaptH2o5lY+O0F91H/e+8L5kHuwLl7C/xEG9Q==
X-Received: by 2002:ac8:ace:: with SMTP id g14mr2729119qti.156.1612965370322;
        Wed, 10 Feb 2021 05:56:10 -0800 (PST)
Received: from horizon.localdomain ([177.79.104.116])
        by smtp.gmail.com with ESMTPSA id t19sm1554519qke.109.2021.02.10.05.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 05:56:09 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id A41B7C009A; Wed, 10 Feb 2021 10:56:05 -0300 (-03)
Date:   Wed, 10 Feb 2021 10:56:05 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210210135605.GD2859@horizon.localdomain>
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain>
 <ygnhtuqngebi.fsf@nvidia.com>
 <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ygnho8gtgw2l.fsf@nvidia.com>
 <CAJ3xEMhjo6cYpW-A-0RXKVM52jPCzer_K0WOR64C7HMK8tuRew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhjo6cYpW-A-0RXKVM52jPCzer_K0WOR64C7HMK8tuRew@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 06:10:59PM +0200, Or Gerlitz wrote:
> On Tue, Feb 9, 2021 at 4:26 PM Vlad Buslov <vladbu@nvidia.com> wrote:
> > On Mon 08 Feb 2021 at 22:22, Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 8 Feb 2021 10:21:21 +0200 Vlad Buslov wrote:
> 
> > >> > These operations imply that 7.7.7.5 is configured on some interface on
> > >> > the host. Most likely the VF representor itself, as that aids with ARP
> > >> > resolution. Is that so?
> 
> > >> The tunnel endpoint IP address is configured on VF that is represented
> > >> by enp8s0f0_0 representor in example rules. The VF is on host.
> 
> > > This is very confusing, are you saying that the 7.7.7.5 is configured
> > > both on VF and VFrep? Could you provide a full picture of the config
> > > with IP addresses and routing?
> 
> > No, tunnel IP is configured on VF. That particular VF is in host [..]
> 
> What's the motivation for that? isn't that introducing 3x slow down?

Vlad please correct me if I'm wrong.

I think this boils down to not using the uplink representor as a real
interface. This way, the host can make use of 7.7.7.5 for other stuff
as well without passing (heavy) traffic through representor ports,
which are not meant for it.

So the host can have the IP 7.7.7.5 and also decapsulate vxlan traffic
on it, which wouldn't be possible/recommended otherwise.

Another moment that this gets visible is with VF LAG. When we bond the
uplink representors, add an IP to it and do vxlan decap, that IP is
meant only for the decap process and shouldn't be used for heavier
traffic as its passing through representor ports.

Then, tc config for decap need to be done on VF0rep and not on VF0
itself because that would be a security problem: one VF (which could
be on a netns) could steer packets to another VF at will.
