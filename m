Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C8031339C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhBHNqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBHNng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:43:36 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3508C06178B
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 05:42:55 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id l11so6919723qvt.1
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 05:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DkENRTfEaM9klneO9RfcLXG0HJFeHEjZ5HI48eGsKuU=;
        b=LzWK/lVCWjM1G2dvokUdJwX0JbWzEMdRqaCwFXm9w1rMGBh23JAOu+RZGEiWA4hJX6
         q6zyW6YZNPBk8HSgUGP9okqzK5Pp5YRFqbXDD6YjUkgmkqERobX3Oze+DTxZP4aPTPbg
         nXG4GiVvuw1tMIpKJwNtOf/CW5Pd9qTda44zo5bdw++d/f8Ky/djIH1UbF20IPaoAYqF
         vqp0AmcU+wrWVaqFEUjEcPMkr+QaJ1WpVwvkUvBCbLkxmeCj5VJ0/S1yghhVFtOXJ0Qr
         CslXfIQ8+JcY7EaAW5tNeCfSpAc3TiZ5TH6mt9RdwttMnnuASd9AnqdowseAygN0y/uB
         Kq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DkENRTfEaM9klneO9RfcLXG0HJFeHEjZ5HI48eGsKuU=;
        b=feaFz1NWsLLkpnHWx2kjDAn7CLCvuH+0uBCfJUqFN7J3sW9VlUKcrqU8VVtCMGeON4
         KRCoLMa2N0E7QFiSoEUHfFgw1rtBzKWkuntGMpCmT/teonzZj1vWY0X29HXupuHHCBC6
         ohn1BtfvOaV662nwdTyWMECS8I6QyC1vPn+iryfmSGFynz1goABTBJtityNwM93DyQrP
         067K0gsq9fo1EXXduIVKQF5pYtlocMYFJ/QxKSKyTQMgynZU0XLOV/VFA+hax08z2zQM
         WVLeI+goAl/T3qH6iP9AkHH1OaVX3rnQRwe8IHjbxvBSgbF5IZCUiHdN5cY00DTciwn1
         HaFw==
X-Gm-Message-State: AOAM533dZsgxP+E7tmZWLDf5ExGC/Sr4W9CRDCTV1x1uO0hA6Nj6otJ3
        Kpd3IrE9Qp0Uc3micdwfBNk=
X-Google-Smtp-Source: ABdhPJz52wBoDdouZBn+ZSS/xyFA7ATlmJR+T/2T0SK8fiIzVLftoGnRv4gC9THYIzE5hiIlH/jZFw==
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr1123984qvb.26.1612791775004;
        Mon, 08 Feb 2021 05:42:55 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f013:33b1:1bdf:3c19:7173:82ba])
        by smtp.gmail.com with ESMTPSA id l35sm14859684qtd.90.2021.02.08.05.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 05:42:54 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 75764C13A6; Mon,  8 Feb 2021 10:42:51 -0300 (-03)
Date:   Mon, 8 Feb 2021 10:42:51 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210208134251.GB2859@horizon.localdomain>
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain>
 <ygnhtuqngebi.fsf@nvidia.com>
 <20210208132557.GB2959@horizon.localdomain>
 <ygnhr1lqheih.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhr1lqheih.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 03:31:50PM +0200, Vlad Buslov wrote:
> 
> On Mon 08 Feb 2021 at 15:25, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Mon, Feb 08, 2021 at 10:21:21AM +0200, Vlad Buslov wrote:
> >> 
> >> On Sat 06 Feb 2021 at 20:13, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > I didn't receive the cover letter, so I'm replying on this one. :-)
> >> >
> >> > This is nice. One thing is not clear to me yet. From the samples on
> >> > the cover letter:
> >> >
> >> > $ tc -s filter show dev enp8s0f0_1 ingress
> >> > filter protocol ip pref 4 flower chain 0
> >> > filter protocol ip pref 4 flower chain 0 handle 0x1
> >> >   dst_mac 0a:40:bd:30:89:99
> >> >   src_mac ca:2e:a7:3f:f5:0f
> >> >   eth_type ipv4
> >> >   ip_tos 0/0x3
> >> >   ip_flags nofrag
> >> >   in_hw in_hw_count 1
> >> >         action order 1: tunnel_key  set
> >> >         src_ip 7.7.7.5
> >> >         dst_ip 7.7.7.1
> >> >         ...
> >> >
> >> > $ tc -s filter show dev vxlan_sys_4789 ingress
> >> > filter protocol ip pref 4 flower chain 0
> >> > filter protocol ip pref 4 flower chain 0 handle 0x1
> >> >   dst_mac ca:2e:a7:3f:f5:0f
> >> >   src_mac 0a:40:bd:30:89:99
> >> >   eth_type ipv4
> >> >   enc_dst_ip 7.7.7.5
> >> >   enc_src_ip 7.7.7.1
> >> >   enc_key_id 98
> >> >   enc_dst_port 4789
> >> >   enc_tos 0
> >> >   ...
> >> >
> >> > These operations imply that 7.7.7.5 is configured on some interface on
> >> > the host. Most likely the VF representor itself, as that aids with ARP
> >> > resolution. Is that so?
> >> >
> >> > Thanks,
> >> > Marcelo
> >> 
> >> Hi Marcelo,
> >> 
> >> The tunnel endpoint IP address is configured on VF that is represented
> >> by enp8s0f0_0 representor in example rules. The VF is on host.
> >
> > That's interesting and odd. The VF would be isolated by a netns and
> > not be visible by whoever is administrating the VF representor. Some
> > cooperation between the two entities (host and container, say) is
> > needed then, right? Because the host needs to know the endpoint IP
> > address that the container will be using, and vice-versa. If so, why
> > not offload the tunnel actions via the VF itself and avoid this need
> > for cooperation? Container privileges maybe?
> >
> > Thx,
> > Marcelo
> 
> As I wrote in previous email, tunnel endpoint VF is on host (not in
> namespace/container, VM, etc.).

Right. I assumed it was just for simplicity of testing. Okay, I think
I can see some use cases for this. Thanks.

Cheers,
Marcelo
