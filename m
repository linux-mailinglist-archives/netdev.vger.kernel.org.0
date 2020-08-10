Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC476240742
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHJOLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:11:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48704 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgHJOLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:11:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58WI-008xB0-9z; Mon, 10 Aug 2020 16:11:22 +0200
Date:   Mon, 10 Aug 2020 16:11:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/7] netlink: get rid of signed/unsigned
 comparison warnings
Message-ID: <20200810141122.GD2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <90fd688121efaea8acce2a9547585416433493f3.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90fd688121efaea8acce2a9547585416433493f3.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:24:19PM +0200, Michal Kubecek wrote:
> Get rid of compiler warnings about comparison between signed and
> unsigned integer values in netlink code.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  netlink/features.c | 4 ++--
>  netlink/netlink.c  | 4 ++--
>  netlink/netlink.h  | 2 +-
>  netlink/nlsock.c   | 2 +-
>  netlink/parser.c   | 2 +-
>  netlink/settings.c | 6 +++---
>  6 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/netlink/features.c b/netlink/features.c
> index 8b5b8588ca23..f5862e97a265 100644
> --- a/netlink/features.c
> +++ b/netlink/features.c
> @@ -149,7 +149,7 @@ int dump_features(const struct nlattr *const *tb,
>  			continue;
>  
>  		for (j = 0; j < results.count; j++) {
> -			if (feature_flags[j] == i) {
> +			if (feature_flags[j] == (int)i) {
>  				n_match++;
>  				flag_value = flag_value ||
>  					feature_on(results.active, j);
> @@ -163,7 +163,7 @@ int dump_features(const struct nlattr *const *tb,
>  		for (j = 0; j < results.count; j++) {
>  			const char *name = get_string(feature_names, j);
>  
> -			if (feature_flags[j] != i)
> +			if (feature_flags[j] != (int)i)

Hi Michal

Would it be better to make feature_flags an unsigned int * ? And
change the -1 to MAX_UNIT?

       Andrew
