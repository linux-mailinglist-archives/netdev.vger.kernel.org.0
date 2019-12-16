Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AC120FFA
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfLPQqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:46:55 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45320 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfLPQqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:46:55 -0500
Received: by mail-qt1-f193.google.com with SMTP id l12so6257893qtq.12;
        Mon, 16 Dec 2019 08:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=FzQD5NeyjMYjn5GUzVnR8JJ9rnqQehngyUlXZ3ny/LA=;
        b=myJNU0ohp9NClRjz5DPyP/dp+qDqj+ibPEywlbAAwBbLAxuOWcnhhD211Y9I9/oLfo
         +yTrf/B9Bcg00ATyx4EfOmDBFF0HD/hJ1x/pO1N7gQoPnd8geBR4L9rtp682YVJW/if+
         t5LWStvrt0Y9nADtYgyD+om75KE0EebaMp1EidTPi0AIAPchcJI6/mOYmnF0ifJ+y5M4
         VKb1uDCQl9iwvLet2q2wnL5EDkb7yXhttv37C2iiC8vVTKhOD7j1MhR2odSpDh/BlR3d
         I96b9vPzMJfRwrEshTT2he+9nE6VpFrtA46lksRWRuqR+rcUrlU+T8YYVZGA0yCnVN0l
         GNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=FzQD5NeyjMYjn5GUzVnR8JJ9rnqQehngyUlXZ3ny/LA=;
        b=jDlZmM31yBb/NlI7uhaUORkjEL9sCoPd1f7lE9uBRmpHJB5HWh1Sukk6Cac+E8iKBu
         k3+njPqgPFL/OwjYgWCUwIl4a8mHH6rM2L7AsVm8rPreBTKLitjIiou41bzzXAiVfqo0
         Gtt7jrvgePWm7N/wyRgUoJKttF3IhJNzN8LcE1k02O4w1TXZ8rG/SFip6sNAIF+3jQBh
         2GUM6Flz3lLdfiwoVxQ678K8XAFVo53NuWntT5WvgqFlLrYOISiQzLSRTfUhgz0t4/qw
         tPs9f6tOdsflPLByyAEdHCnmC5z1SI4Gz/A7yEtlxEvxY3hXuP0RTEoQgsnorYXiOXlT
         7Mnw==
X-Gm-Message-State: APjAAAWE/+KEdXBZg3x/dSgWCR/fWNpBK76OQJIHmwJaoE+8VKijG1fc
        amRp2u5TT7PF6QHqFG2My33Dgm4H
X-Google-Smtp-Source: APXvYqy1XW6mMY70H5xpe65grZb9SyDfhNylXXrGbRIx1KeEvN9RjkDcnnI02dp3HQHtwhyGu5E0/g==
X-Received: by 2002:ac8:2d30:: with SMTP id n45mr98014qta.203.1576514814548;
        Mon, 16 Dec 2019 08:46:54 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m20sm2627380qkk.15.2019.12.16.08.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:46:53 -0800 (PST)
Date:   Mon, 16 Dec 2019 11:46:52 -0500
Message-ID: <20191216114652.GB2051941@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: b53: Fix egress flooding settings
In-Reply-To: <20191213200027.20803-1-f.fainelli@gmail.com>
References: <20191213200027.20803-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 12:00:27 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> There were several issues with 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback") that resulted in breaking connectivity for standalone ports:
> 
> - both user and CPU ports must allow unicast and multicast forwarding by
>   default otherwise this just flat out breaks connectivity for
>   standalone DSA ports
> - IP multicast is treated similarly as multicast, but has separate
>   control registers
> - the UC, MC and IPMC lookup failure register offsets were wrong, and
>   instead used bit values that are meaningful for the
>   B53_IP_MULTICAST_CTRL register
> 
> Fixes: 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
