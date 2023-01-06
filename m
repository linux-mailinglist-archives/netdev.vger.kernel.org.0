Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F6866048C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbjAFQm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbjAFQmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:42:09 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EDA8D3B0;
        Fri,  6 Jan 2023 08:41:16 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qk9so4664326ejc.3;
        Fri, 06 Jan 2023 08:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zDuaJAmIpFC7NRUN1mfmkI05V2Xw7iuQAWXpbdza9ao=;
        b=k6E4PKkTUV1dQ0wgYn7oiwhBddgcr74bj1W1yCOR/vklx/RMhq4RYB6O4VZNAlzt31
         CY1TDLHCDTZal7/XS1znbPwbHOP5+QCJVqlSOzNWb2AYI30jbZ6yQxXJXrXf+QeIRUNR
         cixvyRuc0mx9kkSarFCNyQ+ljfUuxu10786kVxwtPUc1V4dOzPyTvVySH48XAggY+pFy
         vZnL+fnlwkySJOg9UuytfwNxwvQ7vwKPllGnezkWpIfMqTBaQyJyYdlURkFhpHXqRpho
         VsoxYDQ9aKfLz1nXGNJIJF45o55FpkS+ut5V3VsKxwvLl34iQDGpZgy730nqO7nXNCzl
         IF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zDuaJAmIpFC7NRUN1mfmkI05V2Xw7iuQAWXpbdza9ao=;
        b=07VwB4n3guaDm3EuPy/ufRRc/bgFzH8/Yw/JT0RcvfVTZM++/0zR3IVES/aJY3b8/S
         JosHwYDe+mv7SFp2AeOE0Wp6VNSDNiQA+6/0DY+SOWXGS7pCqJ6GG/xp68Q3dk5B28ws
         ++J+E5MNYqtR60TDi4J2vJWjPQYh2w5r8FYXEUIJZB7WI+8iS9KbmM6JonWM/ZELp+aw
         nmCiB2TFs9CY1b7XhFWbDiW36rP9YGjbkqh0ZQriSur0HdcA0OwaQYfqGG4UnMlVFJfQ
         KqAqq6f0tPXIs5Eh0OeAfPSxtDqPrk43jXLCIsR5doDnGHh6kLnI6H+QFDM19i83bXb2
         IR+Q==
X-Gm-Message-State: AFqh2koc6yZov9PfIk3OxIoV1ThC6ptFoDDzPc19+FPvGJXcIYhkDUhI
        HWHagLqgRvZzYmSGPMlXiOvkijqRO9k=
X-Google-Smtp-Source: AMrXdXvL0miVuApOuzskktynKCpIGEQxJijhE018M2OyjHSrRZdugGalgUZULBfE7zlgFjmVFAyq0g==
X-Received: by 2002:a17:907:2a06:b0:84d:12db:fd23 with SMTP id fd6-20020a1709072a0600b0084d12dbfd23mr4133816ejc.71.1673023274480;
        Fri, 06 Jan 2023 08:41:14 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id 19-20020a170906329300b0084b8979fc5bsm560512ejw.43.2023.01.06.08.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 08:41:14 -0800 (PST)
Date:   Fri, 6 Jan 2023 18:41:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20230106164112.qwpqszvrmb5uv437@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-4-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106160529.1668452-4-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 05:05:29PM +0100, Hans J. Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series is based on
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

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

Missing tags:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>


Please allow at least 24 hours between patch submissions to give time
for other review comments.
