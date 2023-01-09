Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEFB662591
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbjAIM30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237219AbjAIM3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:29:14 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FAF1BE91;
        Mon,  9 Jan 2023 04:29:12 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vm8so19664835ejc.2;
        Mon, 09 Jan 2023 04:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=crINwX8GG7oE7iuw+Z+Wz82V7aegfStJZU7gXgsc5Qc=;
        b=P/IIjdLg2bouOSQCv2Z03ysTzM8CtExWpKYVGm7RPVyMZ5cRimFFXovhV98OwKeeVh
         0vaMYwLL5eqTRXLPGb5jcal0YgpDAOPnzOarn3RsCTNO5G71T+I0vcyt+YoXMOml73wH
         L16uIdbW/mUIj2anFkl6Ww8a0UyZS0sRDliaK50B0PKFQGXP+H8rO612B5zsbLM5R5vS
         6OMJflVKJlUYYDqGVpOl5p/UVVqsqxV96XHkJM1QY8pQSU5XbHXPt9ahGS/1zZ5sSMHm
         0ptuSn6+n5+jCFD893QTFZsfZdBiYbY1HCYkDJhx3U600CgdfBJDnCa/untfcTWby19Z
         ucqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crINwX8GG7oE7iuw+Z+Wz82V7aegfStJZU7gXgsc5Qc=;
        b=BUMsMRn4eTsKioOnmFhV8SD8SLw2194aAvToXIQ+DwrfjgMES/FCE2om9e4EUTNxes
         bAArpv1P7QVvmeQayBAHvQbXBCDJiv7FcfGMuFeCLX5lhCq/abahFelLevOYLA4d+E43
         oE+HcN8nUqqM8sIlq2IzPtp6vciHg7VqQDIXBOmujfhO0HjaUE6leHaYBJxRhVi8e03U
         dzr/V4hXFPcmdbqwxQFMRMOX9heI3fs2pTCFY6UBSnkJSfE3Qj4DQtswVN84iCBJkxm0
         wpm32hvliqo3mPSqgKzZidtK3C18aKBmsuT4rERxusAwsXdKRMdKteKSpdnOymGAlil9
         Q2uA==
X-Gm-Message-State: AFqh2kqiHnPd81N0Exmof8So3pyPS1+L6PtfqvmrU8EMlE1jwILitK7r
        OF2yzzIyaDLOldgQ63sk+E0=
X-Google-Smtp-Source: AMrXdXu+jN1Z5u4gvx/HeqOmEL5odydFz75WSlfwSrwQ+II0GJyIu1O/oM6oeG4mZPvmWt34FYk30g==
X-Received: by 2002:a17:906:8447:b0:7c4:fa17:7203 with SMTP id e7-20020a170906844700b007c4fa177203mr48361852ejy.63.1673267350944;
        Mon, 09 Jan 2023 04:29:10 -0800 (PST)
Received: from skbuf ([188.27.185.38])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b00846734faa9asm3633540ejo.164.2023.01.09.04.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 04:29:10 -0800 (PST)
Date:   Mon, 9 Jan 2023 14:29:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v5 net-next 01/15] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <20230109122908.dn2xlzlbcvfxgeii@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-2-tobias@waldekranz.com>
 <Y7vK4T18pOZ9KAKE@shredder>
 <20230109100236.euq7iaaorqxrun7u@skbuf>
 <Y7v98s8lC1WUvsSO@shredder>
 <20230109115653.6yjijaj63n2v35lw@skbuf>
 <Y7wGct6VWmbuWs5F@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7wGct6VWmbuWs5F@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 02:20:02PM +0200, Ido Schimmel wrote:
> On Mon, Jan 09, 2023 at 01:56:53PM +0200, Vladimir Oltean wrote:
> > On Mon, Jan 09, 2023 at 01:43:46PM +0200, Ido Schimmel wrote:
> > > OK, thanks for confirming. Will send a patch later this week if Tobias
> > > won't take care of it by then. First patch will probably be [1] to make
> > > sure we dump the correct MST state to user space. It will also make it
> > > easier to show the problem and validate the fix.
> > > 
> > > [1]
> > > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > > index 4f5098d33a46..f02a1ad589de 100644
> > > --- a/net/bridge/br.c
> > > +++ b/net/bridge/br.c
> > > @@ -286,7 +286,7 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
> > >  	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
> > >  		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
> > >  	case BR_BOOLOPT_MST_ENABLE:
> > > -		return br_opt_get(br, BROPT_MST_ENABLED);
> > > +		return br_mst_is_enabled(br);
> > 
> > Well, this did report the correct MST state despite the incorrect static
> > branch state, no? The users of br_mst_is_enabled(br) are broken, not
> > those of br_opt_get(br, BROPT_MST_ENABLED).
> 
> I should have said "actual"/"effective" instead of "correct". IMO, it's
> better to use the same conditional in the both the data and control
> paths to eliminate discrepancies. Without the patch, a user will see
> that MST is supposedly enabled when it is actually disabled in the data
> path.

The discussion is about to get philosophical, but I don't know if it's
necessary to make a bug more widespread before fixing it..
The br_mst_used is an optimization to avoid calling br_opt_get() when
surely MST is not enabled. There should be no discrepancy between using
and not using it, if the static branch works correctly (not the case here).
I would also expect that consolidation to be part of net-next though.

> > Anyway, I see there's a br_mst_is_enabled() and also a br_mst_enabled()?!
> > One is used in the fast path and the other in the slow path. They should
> > probably be merged, I guess. They both exist probably because somebody
> > thought that the "if (!netif_is_bridge_master(dev))" test is redundant
> > in the fast path.
> 
> The single user of br_mst_enabled() (DSA) is not affected by the bug
> (only the SW data path is), so I suggest making this consolidation in
> net-next after the bug is fixed. OK?

Yes, net-next, sure.
