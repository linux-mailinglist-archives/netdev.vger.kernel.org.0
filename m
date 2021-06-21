Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E623AE6B2
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhFUKG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhFUKGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:06:55 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93588C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:04:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t7so18076325edd.5
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6/oxryNKmKsCYcCoqAs46IyaujD6fOxf7sV8IZsZxnc=;
        b=vFxyHfxidydu3SUnvfFi3I3dFkd5wsl/O45qUrFcpBLKurOOaTeKWHeEa80NZglV8S
         lzOGptqsVD0WRAe2t7dCXzPnDflDXgw6pu/xUDHMTrV8//490S5Cs3q27Mq5vP/0vQly
         sgOhaDLPElCvHHx6tHVsYjitIqwqFiAvyA0EkrPCYkb6jcn1uCcFhJUbqrPEcM2Ssjxh
         XswD5zK2nPupMTfAvZibRb5D8gZMT4D/ImZeQOaRrRLUrRgSgPNdrlvo1IyaBwLJ5tt/
         ZLz4kqn9tH5ox6yothLZA2wiyiTX/rmCxEsCuo3UrvwssmAq7sqo3skH6BD9rM9xgNOr
         FtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6/oxryNKmKsCYcCoqAs46IyaujD6fOxf7sV8IZsZxnc=;
        b=RJIAoc76BrfF+gOweDxFwDAmqJRrglVR7oj/IG042kAcV4peJacYGdjfDUe5G0kqk8
         3DIRA8pXqkKLgMM6fG0vWK46bhpRxDbZh77KlJ6ZgIvcTGAZf/jR49FgU328yWLrGr9j
         97a27vwB/ZfzU4KFZ/2ak9rJTtGOdnwyxsRUSqoejzM9CGL91eLXrN52VJFq8eI4azmu
         mxb49qBVy+vjU+dHsBVrRCWn6AW2RdJRoGWFfjB8YdiJMgybAdnVy+RO+doYR8rcO0bb
         A/SRSRvcrtrYXRSQNER24ch2MRqW7VCaTyXJnTXvuOt/5Jbg0CjLo/k/Z8NBZjNn1amU
         f8cA==
X-Gm-Message-State: AOAM530/JLFPL7r/FaPQswSk8KOxOxJJF2CUy80CPXvhIUvrr5WAEDeY
        AKeNpvOWxDgljS1/khaRD3c=
X-Google-Smtp-Source: ABdhPJz0FkKmFDq90XsU/pLr8pCPTCmTZk1gG63M799Tully+v0sL7hV2P+V7fCU9W0FxVSxX3PaQQ==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr20316015ede.142.1624269879213;
        Mon, 21 Jun 2021 03:04:39 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id hx18sm3065289ejc.82.2021.06.21.03.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 03:04:38 -0700 (PDT)
Date:   Mon, 21 Jun 2021 13:04:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] mv88e6xxx: fixed adding vlan 0
Message-ID: <20210621100437.gmnxnnycjpg4nimm@skbuf>
References: <20210621085437.25777-1-eldargasanov2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621085437.25777-1-eldargasanov2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 11:54:38AM +0300, Eldar Gasanov wrote:
> 8021q module adds vlan 0 to all interfaces when it starts.
> When 8021q module is loaded it isn't possible to create bond
> with mv88e6xxx interfaces, bonding module dipslay error
> "Couldn't add bond vlan ids", because it tries to add vlan 0
> to slave interfaces.
> 
> There is unexpected behavior in the switch. When a PVID
> is assigned to a port the switch changes VID to PVID
> in ingress frames with VID 0 on the port. Expected
> that the switch doesn't assign PVID to tagged frames
> with VID 0. But there isn't a way to change this behavior
> in the switch.
> 
> Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index eca285aaf72f..961fa6b75cad 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1618,9 +1618,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_vtu_entry vlan;
>  	int i, err;
>  
> -	if (!vid)
> -		return -EOPNOTSUPP;
> -
>  	/* DSA and CPU ports have to be members of multiple vlans */
>  	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
>  		return 0;
> @@ -2109,6 +2106,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
>  	u8 member;
>  	int err;
>  
> +	if (!vlan->vid)
> +		return 0;
> +
>  	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
>  	if (err)
>  		return err;
> -- 
> 2.25.1
> 

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")

because that's when this started becoming a problem.

and the patch should go to "net".

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
