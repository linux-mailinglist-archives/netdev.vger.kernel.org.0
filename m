Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557785DB00
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGCBhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:37:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45752 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfGCBhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:37:31 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so512191qkj.12
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=itC4RfMamo4nBUphW+p9hF/96GAi0A3uCODUBRvJI84=;
        b=TMhO5cgS+76xq5nHpxySpbIhABSRUywM4yxx2+y9FXTrvyuMrU3Cp2feNwPsOeRsKW
         DwKwJWsXiHOYGDICseJdVlYxguntHUvsU6MrtNgLZzUMElpHNBXa/6Jjn0/xtQMqMIB8
         Li6ad1O97GJAVS+d57FQzz6F3TMcNdl9iVk4T74Lx6hRRdmkPYI4UUEoAioE0m+84vvk
         DeVz4JERwD1PMdQMjQ3gICjK8PxsLEGU3AUM9Lg9AWg6DAaTXRItWMCoZYyHLuxDhIsD
         OpmqLVAEODV5QsCL8faaQnLfHa0ajB/20e6HjUrjqvxAQtCeJhPZL1UO8W1JyqkAll4C
         8i3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=itC4RfMamo4nBUphW+p9hF/96GAi0A3uCODUBRvJI84=;
        b=VaDEpBNrLuS5aFyRV3R1IZPm1EI7fWD6TzctLRMeIzWxl45IlERBjnj1SccL1FjHVV
         ITcibhUxvxUnqCG/+krEA2xXS9k4fiDPdIK0SNkocxdBriZbeIIb9utD6seK5CZMzu9L
         ko/mrhIN0sYgXJ5oWUvxs0dolC40N+EpYjqrwRZDrlvJNB18ZZhnPDXQonIdIhPnVWKY
         aZxJ54sxW7KY1DDH//qKLggCWqH4p42vYeLAn/PSrC8hNacISFB5+rBy6L4UT9QG2hOS
         IC5Iw0bT6LfWzBAsVYQpYyM08ze5S+K+uleIZyMwqq5FabB7Qg7fLQEqXgLC61C46gX3
         96gg==
X-Gm-Message-State: APjAAAXhBAB14DddVgMGyruHECM+iJElua+sKBV+F5iXdoyN/dkaGVLN
        LCxscKHRAu8T7KSA/84kJuEjNFu4V5I=
X-Google-Smtp-Source: APXvYqyyl+pNFApWH9ul5KAlVhaGUV3rJBSAcAPkIU+AHaxs/CaVSypyCo85+p1EbI/jfLSIHXgbvA==
X-Received: by 2002:a37:f511:: with SMTP id l17mr25845461qkk.99.1562117850182;
        Tue, 02 Jul 2019 18:37:30 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n3sm280989qkk.54.2019.07.02.18.37.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 18:37:30 -0700 (PDT)
Date:   Tue, 2 Jul 2019 18:37:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190702183724.423e3b1e@cakuba.netronome.com>
In-Reply-To: <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
        <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jul 2019 13:50:04 +0200 (CEST), Michal Kubecek wrote:
> Add common request/reply header definition and helpers to parse request
> header and fill reply header. Provide ethnl_update_* helpers to update
> structure members from request attributes (to be used for *_SET requests).
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 3c98b41f04e5..e13f29bbd625 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -1,8 +1,181 @@
>  // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>  
> +#include <net/sock.h>
>  #include <linux/ethtool_netlink.h>
>  #include "netlink.h"
>  
> +static struct genl_family ethtool_genl_family;
> +
> +static const struct nla_policy dflt_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
> +	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },

I think we want strict checking on all new netlink interfaces, and
unfortunately that feature is opt-in.. so you need to add:

	.strict_start_type = ETHTOOL_A_HEADER_UNSPEC + 1

To the first attr.

> +	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
> +	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
> +					    .len = IFNAMSIZ - 1 },
> +	[ETHTOOL_A_HEADER_INFOMASK]	= { .type = NLA_U32 },
> +	[ETHTOOL_A_HEADER_GFLAGS]	= { .type = NLA_U32 },
> +	[ETHTOOL_A_HEADER_RFLAGS]	= { .type = NLA_U32 },
> +};


