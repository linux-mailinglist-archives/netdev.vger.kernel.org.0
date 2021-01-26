Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C609D303518
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbhAZFe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732182AbhAZCGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 21:06:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C9EE207D0;
        Tue, 26 Jan 2021 02:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611626471;
        bh=8vHNnFi0JpdrpQlL1R/+L5DiBlhQRP5u4PaUCq/Kogg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oO2fTB91IreBoPnw8Ojz71RYtOULiAQr1fpZax2IDQy6RdY9tnikMMIMXgLDjL57q
         +SGmcryh4c/Ti7ioM8DfRfNcu1p2C/q86JvZGFNzOM5EXqVPy0SZoWfhOfqjjgzmOV
         epHIyIUR8yjE0ATlbNrncJdn34BZJtrpt4fcKXEcIEauqapvDdGoNyEouU/mF6O5+Q
         jdITxMBJav6ERlM/3KonNW2m7YND7ed6xXGTl5IVPny8JFm3ex2p+YDJaAgTbgAqZ1
         kjn6fSQXZ36v+hg6l6l/XtSGjUGOWrYOiusqfl8yEGQ45tiSCrrRP4cf6D5Y8MH9FG
         71xpLiKchrKGg==
Date:   Mon, 25 Jan 2021 18:01:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 4/4] rtnetlink: promote IFLA_VF_STATS to same
 level as IFLA_VF_INFO
Message-ID: <20210125180110.3859f487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123045321.2797360-5-edwin.peer@broadcom.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
        <20210123045321.2797360-5-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 20:53:21 -0800 Edwin Peer wrote:
> Separating the VF stats out of IFLA_VF_INFO appears to be the least
> impact way of resolving the nlattr overflow bug in IFLA_VFINFO_LIST.
> 
> Since changing the hierarchy does constitute an ABI change, it must
> be explicitly requested via RTEXT_FILTER_VF_SEPARATE_STATS. Otherwise,
> the old location is maintained for compatibility.

We don't want any additions to the VF ABI via GETLINK. IMO the clear
truncation is fine, hiding stats is pushing it, new attr is a no go.

> A new container type, namely IFLA_VFSTATS_LIST, is introduced to group
> the stats objects into an ordered list that corresponds with the order
> of VFs in IFLA_VFINFO_LIST.

