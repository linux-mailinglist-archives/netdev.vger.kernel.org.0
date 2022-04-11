Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16BC4FBEFD
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347071AbiDKO0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245248AbiDKO0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:26:21 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E965E1092
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:24:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ks6so6607064ejb.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gMGndr7Y/oKLXKAoK2ciXq6WW6eDpRTbb4dyHOcovV0=;
        b=SgI59+0lQo7X6mbX+L1VM3LZrn+f4z4wmzklCm4rbOs1oywwAw4td4DvPGDDFSeCjz
         dYK0Mq11vUj/CPz6iJrsEVuzHK1Lr2UidWLQpA1O9j+x1GVjuMApqGRWXKaSWsloB+1F
         IK0mslJH+bvYO0eDv0S3c1u9Gvy+eoukpneXKMUVlXN4X60OAJP06oND/8Ks7pQixoSZ
         cd2hzqz/Hv4gntYowr9nEnHkYwJBSP3DCqpdEb1wqFBOT2D5vVyN2ck8xdcqSNhQOBwO
         vGotHXC0nIGsVx54dYlzPo1W9Pvk63uOWGuJm7YOEUIrGntnY8ldvMuizEA7q0zi/sCy
         H5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gMGndr7Y/oKLXKAoK2ciXq6WW6eDpRTbb4dyHOcovV0=;
        b=XO0hKzFSj9Y04U8BboG0W7RmUeNsONIWT69LZJE9gRLMSpZyDM2KqwUWADD+Cf761y
         B2+ZOxsuTXZeh3XI0lKeSmcQaj9cnf4USvv6tVfVQfBYZXTQZHgO2JqTuX/1v5OyhP0e
         dM8Qfhul7CaH0NMVfy4FoC6RBs3DYbaxKyzNlOoY9Oc1n8zGIDHEyD56cymXbY1RwfjY
         XvIHTBDNYJeGDpTzksO6vEZ33hcO1EqYsqt/O3kIy3j1CXrsdYl7GP4mVqt8GPV5QtUR
         xDByF+EvRGUo3HW+6RcqDEZieCv9R6UF1lfs/FKFKG7R5wHCp4JWzsaw5isxGcUSOqHN
         z6cQ==
X-Gm-Message-State: AOAM533Gbqc9Rz93Ihv94edpQhIXqoh8mu5HtLutO58EJQ2UfO5OtvQG
        FRvp+3MwP+VAIiLaX24jkGI=
X-Google-Smtp-Source: ABdhPJxzLsJkfeK7JJc5tn9HeIDKzW7MxAoUuNwp/R/cWuxTQD+pzKVcmfxRCV7qaNyqmGqJuAA8hw==
X-Received: by 2002:a17:907:7204:b0:6e8:4252:2c98 with SMTP id dr4-20020a170907720400b006e842522c98mr17730450ejc.33.1649687044414;
        Mon, 11 Apr 2022 07:24:04 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id g9-20020aa7c849000000b00412fc6bf26dsm15402849edt.80.2022.04.11.07.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 07:24:04 -0700 (PDT)
Date:   Mon, 11 Apr 2022 17:24:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Message-ID: <20220411142402.vhuctrmlyezklg4n@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com>
 <20220409204557.4ul4ohf3tjtb37dx@skbuf>
 <8735ikizq2.fsf@waldekranz.com>
 <20220410220324.4c3l3idubwi3w6if@skbuf>
 <87zgksge17.fsf@waldekranz.com>
 <20220411105534.rkwicu6skd3v37qu@skbuf>
 <87wnfvhidq.fsf@waldekranz.com>
 <20220411135530.2nu4rlofyd6nphb2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411135530.2nu4rlofyd6nphb2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 04:55:30PM +0300, Vladimir Oltean wrote:
> > > IFF_ALLMULTI would implicitly correspond to BR_MCAST_FLOOD (ok, also
> > > adjust for mcast_router ports).
> > 
> > IFF flags shouldn't correspond to any bridge flags. They describe higher
> > level features. Therefore, they should be passed down to the drivers,
> > who in many cases may decide to use hardware resources that are shared
> > with bridge flags (i.e. flood controls), but in some cases may be able
> > to do something better.
> > 
> > As an example of "something better": some ASICs have separate flooding
> > controls for IP and non-IP multicast.
> > 
> > So, I think
> > 
> >     ip link set dev br0 allmulticast on
> > 
> > Should be one way for userspace to tell the bridge to mark the host port
> > as a permanent multicast router port. This in turn would trigger a
> > 
> >     switchdev_port_attr_set(dev,
> >     	&{ .id = SWITCHDEV_ATTR_ID_BRIDGE_MROUTER ... }, extack);
> > 
> > At the DSA layer this info would be passed to the driver, which will
> > decide if that means the same thing as BR_MCAST_FLOOD or something
> > else.
> 
> Yeah, I don't think so. Doing nothing at all is way better than
> entangling the RX filtering logic even more with the forwarding logic,
> IMHO.

Thinking out loud.
I still maintain it is weird and uncalled for if "ip link set dev br0 allmulticast on"
marks the bridge as a multicast router (maybe I'm wrong, but I don't see why it is helpful).
But the other way around may not be so weird. That is, as long as the
bridge is a multicast router port or needs to receive unknown multicast
for any reason at all, it auto-enables IFF_ALLMULTI on its RX flags.

Then, we just need to take care of that "RX filter is a mirror" thing.
Not ideal, but maybe if we actually introduce a bridge flag "rx_filter_mirror"
where the default is 1 to keep backwards compatibility, we could actually
turn the bridge into something sane?
The bad part is that we can't make switchdev drivers reject a bridge
with rx_filter_mirror=1, unless we're ready to deal with the breakage
(although even that is tempting...).

What this effort would achieve is that the bridge would no longer become
promiscuous in the presence of uppers with different MAC address.
It would do this by implementing the filtering you talked about in
br_pass_frame_up().

As for offloading, the nice part is that the bridge RX filtering logic
could be left as invisible to switchdev, and we could concentrate only
on flooding towards the host via the logic that Joachim is working on.
