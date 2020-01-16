Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F9913D8E0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 12:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgAPLXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 06:23:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36068 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725800AbgAPLXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 06:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579173790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6QKlwFhigKorIH7T4YEWFjAJ4HYJ8ZpoOh8DijWJCz8=;
        b=JfFSHTMyQK5K73I6ysK1aMNXpc3FWP8c1hYoc8UMYjYP33ZLYIANdbYWEKC2B+wVSjfQQk
        16GsqEdaEN7Fj62A4Oa68nrMWo6nfO+Un1rFqKObaKGmD9ZCCx0WcfL9Shze/+Fc4Wr4yk
        5SYpbmsXbQw+iOq10mehh8Lm8FROI04=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-FnhEyjyEMiu573R-DN8KFw-1; Thu, 16 Jan 2020 06:23:09 -0500
X-MC-Unique: FnhEyjyEMiu573R-DN8KFw-1
Received: by mail-wr1-f69.google.com with SMTP id i9so9151151wru.1
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 03:23:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6QKlwFhigKorIH7T4YEWFjAJ4HYJ8ZpoOh8DijWJCz8=;
        b=uUmZfZKQQSLMe/CHROH3+/C7nAbnlddV3xEa0iogqEW3YdSb/mmMZHTDCo+NoERpVv
         QJ5kYCnzdj1ofaz5w6vDop9Zd2Pa9W9e/Va18xvtLjD1HFRwJkZzGkjg0/As+q9H0Nst
         NMYSKbkNkxLEWgZFEX9b4OoymNgVlqYQ9rLx05lXrqZKFwEYkXfz2hOydtaswPp/MQXL
         HgID1DxDriW+QstROQaBpUFTKQNco4c5bMFnMKm6LRq2u/AiHn0Jpuibp8zsNFxC9a3Z
         76WrWw1hXPldswsiH4izcyj0giuhe5VZ49e7DrEzDBnBGy1y/eG23VpKXGNbcQ2u81PL
         68OA==
X-Gm-Message-State: APjAAAWP6srEr50W0qe4g2Th2EZddkVS/jfmxTh4cGCSQTUQkYgpZ5eZ
        qJ79qNFx5HhrIIXe0zEGbvP4wBcW2fY7QiCx5uV/wRpwvJ1Yo3o13+wOWVT8DBKWZjd/mfPHFgd
        qzzr7s4vYCKWS+jM7
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr2657966wrm.24.1579173788631;
        Thu, 16 Jan 2020 03:23:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJxuA6BmNsyXEVXb02VADDTP2o2vyXNOmQT4dD6wEFhOorZfx7j0D/YiZHGzLkf3tRQKvUEQ==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr2657946wrm.24.1579173788423;
        Thu, 16 Jan 2020 03:23:08 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id q3sm3830394wmj.38.2020.01.16.03.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 03:23:07 -0800 (PST)
Date:   Thu, 16 Jan 2020 12:23:06 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] netns: Parse *_PID and *_FD netlink
 attributes as signed integers
Message-ID: <20200116112306.GA22775@linux.home>
References: <cover.1579102319.git.gnault@redhat.com>
 <9a4228356eaa5c8db653c43467526a0dbd00ce30.1579102319.git.gnault@redhat.com>
 <4eb09a3c-f402-ad05-3cff-049578ed0935@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4eb09a3c-f402-ad05-3cff-049578ed0935@6wind.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 05:25:42PM +0100, Nicolas Dichtel wrote:
> Le 15/01/2020 à 16:36, Guillaume Nault a écrit :
> > These attributes represent signed values (file descriptors and PIDs).
> > Make that clear in nla_policy.
> After more check, I also find these one:
> $ git grep "NET.*_PID\|NET.*_FD" include/uapi/linux/
> include/uapi/linux/devlink.h:   DEVLINK_ATTR_NETNS_FD,                  /* u32 */
> include/uapi/linux/devlink.h:   DEVLINK_ATTR_NETNS_PID,                 /* u32 */
> include/uapi/linux/gtp.h:       GTPA_NET_NS_FD,
> include/uapi/linux/if_link.h:   IFLA_NET_NS_PID,
> include/uapi/linux/if_link.h:   IFLA_NET_NS_FD,
> include/uapi/linux/net_namespace.h:     NETNSA_PID,
> include/uapi/linux/net_namespace.h:     NETNSA_FD,
> include/uapi/linux/nl80211.h:   NL80211_ATTR_NETNS_FD,
> 
Well, this is really going beyond the scope of the original patch set.
But ok, let's drop this series. I'll repost the constification as stand
alone patch and will audit the netns attribute parsing when I'll get
more time.

