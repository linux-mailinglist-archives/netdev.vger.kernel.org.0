Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3532DC3FC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgLPQXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgLPQXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:23:07 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357F8C0617B0
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:22:27 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qw4so33521420ejb.12
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hF7g97hEivSNf5/fNIUQjuzbJZrJBaFIZE72L9hbLlI=;
        b=YDo6lddCN7cfwf8w9nIl8DiAVhs83+rF43j0JEYxcznptuPRRZACQb7uNGZNSmJbIU
         fuD75lIiq2tBtBZMdgPbJE+HBm3/Q1BzifTgeVzphbXEq6Fh9V5RgppSD6xAmHtyRwV8
         KwQ+1maXjEiMKwKs+cnDjSUtozPNFpktX58XtNBJ2uWwZNimKY0ocEzyJKEcMxPBk6c4
         30CEtBjzgPGI05QHzZ57okuv1syFwrB/QT5fDTMzA0I0RdtiljGD0iG8OtbhgoH7oSva
         apQV7P4aoUSPuJytNLPe2ZU6Ho6BiTvOtrIqaoI2JD1rDG5MDN6mrNAyBwTXdIOHRHJv
         DRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hF7g97hEivSNf5/fNIUQjuzbJZrJBaFIZE72L9hbLlI=;
        b=BD6+ZlaYAQy77sMWOqPlMQCtPEefZvf0JP5e7pYfdWUuKX7Xr/LIYf5HJdIAH9GD9v
         y6e0CXDPbKS3OnZU+uivkKME4xR3yOMoE6syMXgXbXovzBVEK0b1kSZ4G3xqXx5L9IDx
         4q4Lk31cW91FDEHr7hJ5VP9jNtkO1hUWHGtXbWarKi/6wB4AaaG1gL+Kr8eYERQE8TIb
         pDdtyzsdDfuFz7rJIMUDeetNgrFWHtCxAohjJB/EE3YjMVT7z8vdCy4g3AX878KdJyB7
         nLD+SaeP3SkIGBOH/lnsEJ2z9u60+wWz34pQH2m3nJPKpA08IGV7a0mZn3VwbLoRurr2
         n0aQ==
X-Gm-Message-State: AOAM531+NxrYv9gVycPohUM9Y4L+HvfHgMUsGd9lA0sFW1Wn9w9Eu6j2
        g0G3GlTcxJQFsCwxIe2bL/Q=
X-Google-Smtp-Source: ABdhPJyNc7+mUw9G3/MEaXa/aqMfSj+cPUz5BvK9t97KbRTGwnRz0UJkiGc1zeWQftEUnBs0j9UPkQ==
X-Received: by 2002:a17:906:2984:: with SMTP id x4mr14106418eje.239.1608135745836;
        Wed, 16 Dec 2020 08:22:25 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id z26sm21484525edl.71.2020.12.16.08.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:22:25 -0800 (PST)
Date:   Wed, 16 Dec 2020 18:22:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
Message-ID: <20201216162223.f7yndqvdlqt2akfs@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
> 
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
> 
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG device pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
> 
> Drivers can optionally request that DSA maintain a linear mapping from
> a LAG ID to the corresponding netdev by setting ds->num_lag_ids to the
> desired size.
> 
> In the event that the hardware is not capable of offloading a
> particular LAG for any reason (the typical case being use of exotic
> modes like broadcast), DSA will take a hands-off approach, allowing
> the LAG to be formed as a pure software construct. This is reported
> back through the extended ACK, but is otherwise transparent to the
> user.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> I tried in vain to win checkpatch's approval of the foreach macros, no
> matter how many parentheses I added. Looking at existing macros, this
> style seems to be widely accepted. Is this a known issue?
> 
>  include/net/dsa.h  | 60 +++++++++++++++++++++++++++++++++++
>  net/dsa/dsa2.c     | 74 +++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa_priv.h | 36 +++++++++++++++++++++
>  net/dsa/port.c     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/slave.c    | 70 ++++++++++++++++++++++++++++++++++++----
>  net/dsa/switch.c   | 50 +++++++++++++++++++++++++++++
>  6 files changed, 362 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 4e60d2610f20..9092c711a37c 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -149,8 +149,41 @@ struct dsa_switch_tree {
>  
>  	/* List of DSA links composing the routing table */
>  	struct list_head rtable;
> +
> +	/* Maps offloaded LAG netdevs to a zero-based linear ID for
> +	 * drivers that need it.
> +	 */
> +	struct net_device **lags;
> +	unsigned int lags_len;
>  };
>  
> +#define dsa_lags_foreach_id(_id, _dst)				\
> +	for ((_id) = 0; (_id) < (_dst)->lags_len; (_id)++)	\
> +		if ((_dst)->lags[_id])
> +
> +#define dsa_lag_foreach_port(_dp, _dst, _lag)	       \
> +	list_for_each_entry(_dp, &(_dst)->ports, list) \
> +		if ((_dp)->lag_dev == (_lag))

ERROR: Macros with complex values should be enclosed in parentheses
#86: FILE: include/net/dsa.h:160:
+#define dsa_lags_foreach_id(_id, _dst)                         \
+       for ((_id) = 0; (_id) < (_dst)->lags_len; (_id)++)      \
+               if ((_dst)->lags[_id])
                                 ~~~
                                 missing parentheses

ERROR: Macros with complex values should be enclosed in parentheses
#90: FILE: include/net/dsa.h:164:
+#define dsa_lag_foreach_port(_dp, _dst, _lag)         \
+       list_for_each_entry(_dp, &(_dst)->ports, list) \
                            ~~~
                            missing parentheses
+               if ((_dp)->lag_dev == (_lag))
