Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9006765DB7D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbjADRrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbjADRr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:47:28 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5D71A055;
        Wed,  4 Jan 2023 09:47:22 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id x22so84393946ejs.11;
        Wed, 04 Jan 2023 09:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cXFF8GYX5Zinjr/Qz/IXvMCn5CnWUu2Qz1tzFtqqkog=;
        b=JTaSmDfT0/oFcAPRSwmBn0cQRjSCiRxOfE9Oy3DECfRirfNcmbyfAh1OxkTh3gudn/
         ptZaF9itgHIRga+/R11GcJ85VIR5g4C6L0fbmbGTKId59a0EbwIf1H9a79xCb8fGf9m9
         Env/rlHBIPAC34UA7LidBeD9nZom+Ta/nfwGU+usHl5zyP/qXRV7ybdKLfQ+dHtFes7H
         PtYXoNquO7JUUneNAT2/CSHrmeY7EEGIizj4zK9S12fC0OlU6rpcWJVssJpZ8AuA+c+A
         zA4z5alDhxCTqmDbNIzJ2z4VzbJn30VbXjvCwWDXzF/3XFtN8UBvP2jt6ClXUgF7CCRP
         LDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXFF8GYX5Zinjr/Qz/IXvMCn5CnWUu2Qz1tzFtqqkog=;
        b=vNWwP3HaduUVSxdidlFzMeqzc308xpff45QoZynU97Fmp00WsIK9zEKObxopzR1azv
         Zepd3TNwWekAmRhMul3dlBNbg61yrWHjcXAueZSHPvE2QxjCnNPG0H1hEBJgu26+Lzpy
         IykaacEotqjiYkRgzETomJ8z7+i5LqAt0HSgJlZG7etpEJokPbTXDM0f1tmjXLspn25/
         u2S1t4wErlmv4OoINWLbC2LgxPGTrvA3lD3KyFlHpVfeBEsR8GmBByWuTcqBSRbWXxFe
         H4PCy8gBQDsGjm54940BH/m1LkTdEuXkdZmeashRnF5JOWoBFzA0kRLbs9kj52Gz2p0A
         y9Ug==
X-Gm-Message-State: AFqh2kqZrgGv+LzKiP0XAEyEO9A/Cy+xuYHo/gEaGSZUEi2KMJyPTSCV
        sGxrf8SWdffgJU+PWvND4kI=
X-Google-Smtp-Source: AMrXdXvxkZY8R7hruj4X+v4GnStcyC9p+uGPWu6YyXsIpz7AKO6U/tm3Hb4xblKQd6O1o7BYV5nVbQ==
X-Received: by 2002:a17:906:6dd4:b0:836:e6f7:8138 with SMTP id j20-20020a1709066dd400b00836e6f78138mr52011762ejt.13.1672854440801;
        Wed, 04 Jan 2023 09:47:20 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id t15-20020a170906608f00b0078d9cd0d2d6sm15862155ejj.11.2023.01.04.09.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:47:20 -0800 (PST)
Date:   Wed, 4 Jan 2023 19:47:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20230104174718.kq75drpngmfkflpm@skbuf>
References: <20230104130603.1624945-1-netdev@kapio-technology.com>
 <20230104130603.1624945-1-netdev@kapio-technology.com>
 <20230104130603.1624945-4-netdev@kapio-technology.com>
 <20230104130603.1624945-4-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104130603.1624945-4-netdev@kapio-technology.com>
 <20230104130603.1624945-4-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:06:03PM +0100, Hans J. Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series, is based on

Comma between subject and predicate?

> handling ATU miss violations occurring when packets ingress on a port
> that is locked with learning on. This will trigger a
> SWITCHDEV_FDB_ADD_TO_BRIDGE event, which will result in the bridge module
> adding a locked FDB entry. This bridge FDB entry will not age out as
> it has the extern_learn flag set.
> 
> Userspace daemons can listen to these events and either accept or deny
> access for the host, by either replacing the locked FDB entry with a
> simple entry or leave the locked entry.
> 
> If the host MAC address is already present on another port, a ATU
> member violation will occur, but to no real effect, and the packet will
> be dropped in hardware. Statistics on these violations can be shown with
> the command and example output of interest:
> 
> ethtool -S ethX
> NIC statistics:
> ...
>      atu_member_violation: 5
>      atu_miss_violation: 23
> ...
> 
> Where ethX is the interface of the MAB enabled port.
> 
> Furthermore, as added vlan interfaces where the vid is not added to the
> VTU will cause ATU miss violations reporting the FID as
> MV88E6XXX_FID_STANDALONE, we need to check and skip the miss violations
> handling in this case.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
