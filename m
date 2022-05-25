Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAA35340CC
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbiEYPzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 11:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiEYPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 11:55:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74518B2251
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:55:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id q15so4450380edb.11
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pjlqq8cm62vi1hyWvBAKyBYweC3KIP1Fin8KJoGzD/A=;
        b=PgSRWc1c2FbH6lT3lgWeyuEK73r/Ap/6U/+zMoCiszJLOLBBEro6zRM2CAuJOFiIrL
         xMjFwQjOPtu4pzg+TuVQZ+M7YNr9AGeMkzYUmVDJpTbnOYKcS1koMcO3z7mRdpRzokJQ
         bfWz1TvFra1ZEsDQjvVwJ5Y1CUkz4EB+8i9xVrRbLSEhUS4Bjld9csrC21lj/PtnzRTB
         HzM5uXdcNFVL7m2NFq5Nli2Zcxph9whTDEl8IEJgCYvrLBF8c1ew1ObVcQ1Sk55B3Had
         VE0VvcCDn/Fr2MzlOrvctz/6bYEgBlvvu9z0XANtNB85ZbqBUy4uXx6BPSosveHTEwDR
         urrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pjlqq8cm62vi1hyWvBAKyBYweC3KIP1Fin8KJoGzD/A=;
        b=4+jNYLTVUtLquncIxbPZrLvqvqrLGqgLNqm+UIX1i74V+97mH3I1V3zCY8AFR1ZQlY
         IA1iqFXTElgad6gqQ6vMQmTtdR6KHFpZRO9Vq2CpnCg5cRe0mF3Rbj+4lXc2eQVfCj05
         Cs98PKtMVX5NZcc/R6v4lg5hcenfgx1ZyU74nsO8z0hMAa9gjYmGowCZjoXlkDH3j7N+
         hUrMy1z9TBx5whaUpzgBZJQx1CKwiW2q3ANpFLEVEfrgvJG4FdrXeoJn3iqzAeCtArXv
         w3D9rS1jAV315ohd7BcUbIGg0udccfxWOll1q+ZBUYJJuzUjxowCUpGR6+nWQcLAEfVa
         CN1w==
X-Gm-Message-State: AOAM532VkqCa3Z2bl5xckW+p+KQA0J3AyrVaHmB+SUbsbpU9CruJ18qA
        HCQRA0pAGCVYto6rWF8E6Ztr4viaDWY=
X-Google-Smtp-Source: ABdhPJyCsMPiFQV0i4uF1DgJDnsNHcilcE2ub1t8U8fmGuosc7/oFI49QqQeB3LgM9b1Vz+pa5aJqw==
X-Received: by 2002:a05:6402:1912:b0:42b:615e:6025 with SMTP id e18-20020a056402191200b0042b615e6025mr17867806edz.152.1653494138846;
        Wed, 25 May 2022 08:55:38 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id l17-20020a50c111000000b0042b9c322348sm1649613edf.35.2022.05.25.08.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 08:55:37 -0700 (PDT)
Date:   Wed, 25 May 2022 18:55:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rodolfo Giometti <giometti@enneenne.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Message-ID: <20220525155536.7kjqwnp6cepmrngr@skbuf>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch>
 <20220405124851.38fb977d@kernel.org>
 <20220407094439.ubf66iei3wgimx7d@skbuf>
 <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 05:00:24PM +0200, Rodolfo Giometti wrote:
> On 07/04/22 11:44, Vladimir Oltean wrote:
> > On Tue, Apr 05, 2022 at 12:48:51PM -0700, Jakub Kicinski wrote:
> > > On Tue, 5 Apr 2022 00:04:30 +0200 Andrew Lunn wrote:
> > > > What i don't like about your proposed fallback is that it gives the
> > > > impression the slave ports actually support PTP, when they do not.
> > > 
> > > +1, running PTP on the master means there is a non-PTP-aware switch
> > > in the path, which should not be taken lightly.
> > 
> > +2, the change could probably be technically done, and there are aspects
> > worth discussing, but the goal presented here is questionable and it's
> > best to not fool ourselves into thinking that the variable queuing delays
> > of the switch are taken into account when reporting the timestamps,
> > which they aren't.
> > 
> > I think that by the time you realize that you need PTP hardware
> > timestamping on switch ports but you have a PTP-unaware switch
> > integrated *into* your system, you need to go back to the drawing board.
> 
> IMHO this patch is a great hack but what you say sounds good to me.

How many Ethernet connections are there between the switch and the host?
One alternative which requires no code changes is to connect one more
switch port and run PTP at your own risk on the attached FEC port
(not DSA master).

What switch driver is it? There are 2 paths to be discussed.
On TX, does the switch forward DSA-untagged packets from the host port? Where to?
On RX, does the switch tag all packets with a DSA header towards the
host? I guess yes, but in that case, be aware that not many Ethernet
controllers can timestamp non-PTP packets. And you need anyway to demote
e.g. HWTSTAMP_FILTER_PTP_V2_EVENT to HWTSTAMP_FILTER_ALL when you pass
the request to the master to account for that, which you are not doing.

> However we can modify the patch in order to leave the default behavior as-is
> but adding the ability to enable this hack via DTS flag as follow:
> 
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> 
>                         port@0 {
>                                 reg = <0>;
>                                 label = "lan1";
>                                 allow-ptp-fallback;
>                         };
> 
>                         port@1 {
>                                 reg = <1>;
>                                 label = "lan2";
>                         };
> 
>                         ...
> 
>                         port@5 {
>                                 reg = <5>;
>                                 label = "cpu";
>                                 ethernet = <&fec>;
> 
>                                 fixed-link {
>                                         speed = <1000>;
>                                         full-duplex;
>                                 };
>                         };
>                 };
> 
> Then the code can do as follow:
> 
> static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> {
>         struct dsa_slave_priv *p = netdev_priv(dev);
>         struct dsa_switch *ds = p->dp->ds;
>         int port = p->dp->index;
>         struct net_device *master = dsa_slave_to_master(dev);
> 
>         /* Pass through to switch driver if it supports timestamping */
>         switch (cmd) {
>         case SIOCGHWTSTAMP:
>                 if (ds->ops->port_hwtstamp_get)
>                         return ds->ops->port_hwtstamp_get(ds, port, ifr);
>                 if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
>                         return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
>                 break;
>         case SIOCSHWTSTAMP:
>                 if (ds->ops->port_hwtstamp_set)
>                         return ds->ops->port_hwtstamp_set(ds, port, ifr);
>                 if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
>                         return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
>                 break;
>         }
> 
>         return phylink_mii_ioctl(p->dp->pl, ifr, cmd);
> }
> 
> In this manner the default behavior is to return error if the switch doesn't
> support the PTP functions, but developers can intentionally enable the PTP
> fallback on specific ports only in order to be able to use PTP on buggy
> hardware.
> 
> Can this solution be acceptable?

Generally we don't allow policy configuration through the device tree.
