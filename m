Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA82132F65A
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhCEXHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhCEXHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 18:07:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0C66509B;
        Fri,  5 Mar 2021 23:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614985623;
        bh=qd9tsVXUfBIWEXb4jZGqmGwVVcreJ+LXBXy/V9itMNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EQOs6IlN9yeg2lqrWD6SEupKvk7HgPhwVnP6E7FYWK3Z/qqlsCnKBxTnFpDY/q493
         BENkCNpt3DPnvxTz/PIW5gGGkJhGz3yGGFIEw7Ea/SwstcgmsKfv/ubfxKM0Fed+cI
         yZRFcWBY/Swo5HUSaHv9BG2Ui5pG5OuPx0sw+0NcvtgIsKJMI+HLfYHQyO9yOTKLsU
         1dud6w3cxsNUhMwNwcvOu8y/uCcEwe/f1uIyTgRorpZGOCDAOs2uILrdQOAuX6Jyg/
         d4hmnGyAor5zjoqlRzC4ZqX61o96rRnzQXy+0NLWjay0VLMkyPvQFObcjL8hSeRwh/
         3NjAyDU+8TXYw==
Date:   Fri, 5 Mar 2021 15:07:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: Query on new ethtool RSS hashing options
Message-ID: <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Mar 2021 16:15:51 +0530 Sunil Kovvuri wrote:
> Hi,
> 
> We have a requirement where in we want RSS hashing to be done on packet fields
> which are not currently supported by the ethtool.
> 
> Current options:
> ehtool -n <dev> rx-flow-hash
> tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
> 
> Specifically our requirement is to calculate hash with DSA tag (which
> is inserted by switch) plus the TCP/UDP 4-tuple as input.

Can you share the format of the DSA tag? Is there a driver for it
upstream? Do we need to represent it in union ethtool_flow_union?

> Is it okay to add such options to the ethtool ?
> or will it be better to add a generic option to take pkt data offset
> and number of bytes ?
> 
> Something like
> ethtool -n <dev> rx-flow-hash tcp4 sdfn off <offset in the pkt> num
> <number of bytes/bits>
> 
> Any comments, please.
