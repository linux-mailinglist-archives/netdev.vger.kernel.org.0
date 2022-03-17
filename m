Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E23A4DCED4
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbiCQT2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiCQT2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:28:23 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A2215478;
        Thu, 17 Mar 2022 12:27:05 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hw13so12603457ejc.9;
        Thu, 17 Mar 2022 12:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/7iAhcR4tM55eEx0OphxTplV89HWokZKexzro1tRyR4=;
        b=B8XIvyZykfMaM6OPqWJsED+v5Dwn3xRPjvNFplB7XHHqcf+b+PsDawQkL/LFEncHXO
         7BsmBBjN6XsztRPgkTlTEVyciryk7kfyMykxuI0t9DoxYnt6rqJSySkzGa499pRV5xQl
         2K0JH+lIFThsnhGGADoEf9LSYYhuI6P0EY+ZAWnVI1Aoj9oMpsxKN0wTqYppiQyz2G8a
         /y+0qKS+hz8wZ9WtRe3aGXVnubOQHNZdyZiZpxwrIKXgeyYwZePhUlo/rH6Yb2RuPjCl
         +aXjTlyMvs9HnFgqVZk8dr50w/0ScT/W1K8nPH8qAzkUX5hAtwUQCGZ6EDlKWyUlrOTI
         htjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/7iAhcR4tM55eEx0OphxTplV89HWokZKexzro1tRyR4=;
        b=fDHclNRupJwIFfc9nsTCOmNOk0Un/H/51uzQb5SHhY7FEYyMYNL/FEcqRbdUDpryJX
         y+2sMmZETlkejMFTvPXtbvEcamww46AWj/57Nl6dF2GVGjGDfwd4e2mwb7mZ8E2cMAbk
         WKJpNQMW8Qk/rM/LvrL5xk4qQ1eVZ5v0DpwiUbvwf58ohDynxSaJA+GkIGHmGKtBJc9K
         zUi/D9bLensWod20T5kz0Jwq/vl87O30ttfo9e0JHwiB9lb60gmHzR6vponZAXaMKPAb
         4dz/uw82W0ASqtz8MMke+VODhD7iXJ1ybSCNWRk4Hv5Tq/zUHNFqxgMeHLUGovBG2ntb
         G8HQ==
X-Gm-Message-State: AOAM531RZr3lsZtUcFGrhhcmFFIKf5T/iLXlqRIjpQf+qi5awoF+88Ma
        7kmdIzSEcEByueWEerENIyA=
X-Google-Smtp-Source: ABdhPJwPhRlaqdL9Yr6GpyMIvyoLXWBJgeNDVCRYVIiBTwwE4iUBPuPMJFdJZW6dfMgWExHCpvYwhA==
X-Received: by 2002:a17:906:dc81:b0:6df:8348:d201 with SMTP id cs1-20020a170906dc8100b006df8348d201mr5832495ejc.113.1647545223798;
        Thu, 17 Mar 2022 12:27:03 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090679c300b006cf9ce53354sm2782790ejo.190.2022.03.17.12.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 12:27:03 -0700 (PDT)
Date:   Thu, 17 Mar 2022 21:27:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220317192701.vskynomfmnciv732@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-4-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317093902.1305816-4-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:39:01AM +0100, Hans Schultz wrote:
> +int mv88e6xxx_switchdev_handle_atu_miss_violation(struct mv88e6xxx_chip *chip,
> +						  int port,
> +						  struct mv88e6xxx_atu_entry *entry,
> +						  u16 fid)
> +{
> +	struct switchdev_notifier_fdb_info info = {
> +		.addr = entry->mac,
> +		.vid = 0,
> +		.added_by_user = false,
> +		.is_local = false,
> +		.offloaded = true,
> +		.locked = true,
> +	};
> +	struct mv88e6xxx_fid_search_ctx ctx;
> +	struct netlink_ext_ack *extack;
> +	struct net_device *brport;
> +	struct dsa_port *dp;
> +	int err;
> +
> +	ctx.fid_search = fid;
> +	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid_on_matching_fid, &ctx);
> +	if (err < 0)
> +		return err;
> +	if (err == 1)
> +		info.vid = ctx.vid_found;
> +	else
> +		return -ENODATA;
> +
> +	dp = dsa_to_port(chip->ds, port);
> +	brport = dsa_port_to_bridge_port(dp);
> +	if (!brport)
> +		return -ENODEV;

dsa_port_to_bridge_port() must be under rtnl_lock().

On a different CPU rather than the one servicing the interrupt, the
rtnl_lock is held exactly by the user space command that triggers the
deletion of the bridge port.

The interrupt thread runs, calls dsa_port_to_bridge_port(), and finds
a non-NULL brport, because the bridge is still doing something else in
del_nbp(), it hasn't yet reached the netdev_upper_dev_unlink() function
which will trigger dsa_port_bridge_leave() -> dsa_port_bridge_destroy().

So you continue bravely, and you call rtnl_lock() below. This will block
until the "ip" command finishes. When you acquire the rtnl_lock however,
the brport is no longer valid, because you have waited for the user
space command to finish.

Best case, the bridge port deletion command was "ip link set lan0 nomaster".
So "brport" is "lan0", you call SWITCHDEV_FDB_ADD_TO_BRIDGE, the bridge
doesn't recognize it as a bridge port, says "huh, weird" and carries on.

Worst case, "brport" was an offloaded LAG device which was a bridge
port, and when it got destroyed by "ip link del bond0", the bridge port
got destroyed too. So at this stage, you have a use-after-free because
bond0 no longer exists.

> +
> +	rtnl_lock();
> +	err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, brport, &info.info, extack);
> +	if (err)
> +		goto out;
> +	entry->portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
> +	err = mv88e6xxx_g1_atu_loadpurge(chip, fid, entry);
> +
> +out:
> +	rtnl_unlock();
> +	return err;
> +}
