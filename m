Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54305DAD7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfGCBaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:30:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46947 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfGCBaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:30:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so726742qtn.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NdF561jXVNweNYUoOJz5cSdmi6GYXNKILSdaVQx92EI=;
        b=IzMsn6uvAihHWC+xI4jQL5EXSlCpq89Da5vdBU8pF5mhxYLAaPUmIASa2aOAoImI4z
         ZW13ivkgV55Kn0Z3u8kGsGNRnpgkewwp65DGh2RkUZezPSv7ZlUErLxqX/fHOGzlxuZD
         VeK914OF8SpXCWrCjwBA5vVyoesm6F5V/zhjuh76NXpWTo6CbaHWisMfBk4yBSikYAJn
         Z6GcfZje1egcCihtpUjrBHW4MyNIxEU+uuKVtY1QfRyYMKv5r+t+sqoQ4eW25NWYKZ1D
         59tytOuMwbdGDIi9K+7/qswB5zK5rOp4cet11f1LJ1RpFzCo7h/X8QStr3ZKM6ehuNC8
         obDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NdF561jXVNweNYUoOJz5cSdmi6GYXNKILSdaVQx92EI=;
        b=D8zY4pGxJkFdHX+oKWmuOtc6aSNNFMKyX4zO8SU5cWPqE8oRjwe/rosy+xcP4bm+kA
         kaYkoJw50FGqtXzwLhnt5bU3o/N1AHISWoI6MjxgqSvDGKMzvigPRyjcZxNLgArRTFcf
         l5LAlLIMJ/XXU5UL5JskZzM4Y6vddPTmoDMbVAHRsKOgy2fZgY9d0AcMidAwyWijhq8w
         AVLa7XLNuww0JFz7z+APJh3wCTA7B7ucmhRXpJV/efYoAhCeuTPBdnJEaA5o03EXDkWl
         5SA69xO23n09GNv+5mo1LMm+eblZ6fMidH+IqpYMKi1Vek2RGMXs2h7TwWpQJ1d2WBe9
         OPiw==
X-Gm-Message-State: APjAAAVLKd1/uJk5zSR9VUsUao1nSU24vzm5mu08sxyH7wopFStulilR
        4sF5pi8hue+6WIjA1jVU8x+8Fw==
X-Google-Smtp-Source: APXvYqzonc3yIGfK+TZvGWD04lDWPLi1g4Tt4GSAnz3bkEJTGn3ZfsU0P9piR1RT0f0L6874RQ59zg==
X-Received: by 2002:a0c:b2da:: with SMTP id d26mr18574230qvf.48.1562117401188;
        Tue, 02 Jul 2019 18:30:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d188sm279477qkf.40.2019.07.02.18.29.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 18:30:01 -0700 (PDT)
Date:   Tue, 2 Jul 2019 18:29:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
Message-ID: <20190702182956.26435d63@cakuba.netronome.com>
In-Reply-To: <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
        <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jul 2019 13:49:59 +0200 (CEST), Michal Kubecek wrote:
> diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
> new file mode 100644
> index 000000000000..97c369aa290b
> --- /dev/null
> +++ b/Documentation/networking/ethtool-netlink.txt
> @@ -0,0 +1,208 @@
> +                        Netlink interface for ethtool
> +                        =============================
> +
> +
> +Basic information
> +-----------------

Probably not a blocker for initial merging, but please note a TODO to
convert the documentation to ReST.
