Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC03DB877
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhG3MSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 08:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238713AbhG3MSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 08:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC0261076;
        Fri, 30 Jul 2021 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627647515;
        bh=Ty/tO7I1pWiWd2DjVtY7FIZ+EGhv1AqkCYkOJUv81kI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kB53Zg2DyRvkNyqxVO671/pO/X+Xlpp0rA7efje28+GsTtZRB5B3rzVVIZ2adA467
         Vs+p/OZP0P+XmOzGl22YBdfsrUs5yoDfMhH7IHcP0CV+L/CaEg+4uPoKrj4GatngbI
         OJQpMLs8WuhSXxTxd1Qv2hp+bgMeHRdNZEvosbSzx53NG596aGvhUFxM+JLNfVUYyR
         6TROv+T0i5///2aM29Nu1nhdzsnxOUvy7TWe2tFzGL3L5sbD9qergmNnW8hjXBCX+F
         VWnzQRQ2gT6yhtPlmp8bxUScSEKaD1wsH0ApLM1cZuAJ82ZFC1bJgNQY7nq6VonpDX
         AkGEtm6pA+k5A==
Date:   Fri, 30 Jul 2021 05:18:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mlxsw@nvidia.com
Subject: Re: [patch net-next v2] devlink: append split port number to the
 port name
Message-ID: <20210730051834.53c83bac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YPqM8HUUsl1n0RKD@nanopsycho>
References: <20210527104819.789840-1-jiri@resnulli.us>
        <162215100360.12583.10419235646821072826.git-patchwork-notify@kernel.org>
        <YPqM8HUUsl1n0RKD@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 11:33:36 +0200 Jiri Pirko wrote:
> Something wrong happened. The patch was applied but eventually, the
> removed lines are back:
> 
> acf1ee44ca5da (Parav Pandit    2020-03-03 08:12:42 -0600 9331)  case DEVLINK_PORT_FLAVOUR_VIRTUAL:
> f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9332)          n = snprintf(name, len, "p%u", attrs->phys.port_number);
> f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9333)          if (n < len && attrs->split)
> f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9334)                  n += snprintf(name + n, len - n, "s%u",
> f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9335)                                attrs->phys.split_subport_number);
> 08474c1a9df0c (Jiri Pirko      2018-05-18 09:29:02 +0200 9336)          if (!attrs->split)
> 378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9337)                  n = snprintf(name, len, "p%u", attrs->phys.port_number);
> 08474c1a9df0c (Jiri Pirko      2018-05-18 09:29:02 +0200 9338)          else
> 378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9339)                  n = snprintf(name, len, "p%us%u",
> 378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9340)                               attrs->phys.port_number,
> 378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9341)                               attrs->phys.split_subport_number);
> 126285651b7f9 (David S. Miller 2021-06-07 13:01:52 -0700 9342) 
> 08474c1a9df0c (Jiri Pirko      2018-05-18 09:29:02 +0200 9343)          break;
> 
> If I do "git reset --hard f285f37cb1e6b", everything is looking fine,
> in the current net-next, the removed lines are still present :O
> I see ghosts...
> 
> Could you check & fix?

Looks like it was fixed by commit 149ea30fdd5c ("devlink: Fix
phys_port_name of virtual port and merge error") in net. I'll 
merge net -> net-next soon, sorry for the breakage.
