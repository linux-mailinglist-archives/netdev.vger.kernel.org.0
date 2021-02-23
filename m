Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A586E323032
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhBWSDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhBWSDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:03:20 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA35C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 10:02:39 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v22so26806477edx.13
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 10:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ihUqmwv5OUTw6FUqci8+zxRKSb2yydjUEvfAwAIVMD8=;
        b=gaIilBJixyJej3tmSFQvuHapLjMwWpwwlXO2OABS+rj4OZj15H4nsw+KD2KEwxoNqM
         lbsHwUHk5UP0dCUskjNrwEoyz/7lS5GEVn4an6JHwAWjGmMYysoCzNXG2ybS9NZvaCIK
         Nj5SaHsFB5RFatNn7sKXxVSTHrQ6S0toEHNOO/3htmBQDkNpqKnRsgDNxgLJissiFpty
         sy3I9wLz+Sp8ba2NkoHc5rW8VWW9enf+n92W60KyojIu6tpQsE3loZoAhUedYA5QGbuw
         Bb2GRcNdbR99C5y/3m3+jHe7Jd9UrMLxiKHsr1hUPcHLV4pb+rII/6iZJ2N91jYSlkft
         Trng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ihUqmwv5OUTw6FUqci8+zxRKSb2yydjUEvfAwAIVMD8=;
        b=Q91qgqfvZz4xLwuY7abyKgBnNWTRE1uCkDk1OuqdC16F8uk1ETQdKS60GOlyHA1NYH
         76ASQokCzY9BIACqW+gb0dZrIPqUddVNBSWE5zmdKkY3zrfbCt9Uk95c21VgEtdZdfPh
         SwbntvgLXPCZ47KkuJAnu2qDD4scU/MLgBDPM7U9Yync/wWqa3AzasHfFqQ7h6zQI0NW
         Z3gK7WgxSe2KIYOQcGSsU0LucZiO7jJsq6k2ACrV48C+NOzUGiKQl4XFNqDfdMB2KdQp
         NCW2y6P0/sCjQFyZqBnKp2yTXBr96E6wS1YEouZ07/8F0SuK2jPDD9gEYmQ/cHnHcsBG
         S2eA==
X-Gm-Message-State: AOAM53155Ono4nlLw+Y5cJEBCfkWXsfmH1OjGs3P0ZMYzXScO68S45sv
        PjweHSRTFwKnVdjbf3iHAvc=
X-Google-Smtp-Source: ABdhPJwhdY/HzhzPlQQywU4W5MDBrMJm1RzRty7TCzUMB1e/MD1dPEp4y+BhCPdP+/km2VPj+m6y+w==
X-Received: by 2002:aa7:d817:: with SMTP id v23mr15287682edq.257.1614103358534;
        Tue, 23 Feb 2021 10:02:38 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id k27sm13710774eje.67.2021.02.23.10.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:02:37 -0800 (PST)
Date:   Tue, 23 Feb 2021 20:02:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: Timing of host-joined bridge multicast groups with switchdev
Message-ID: <20210223180236.e2ggiuxhr5aaayx5@skbuf>
References: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
 <YDVBxrkYOtlmO1bn@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDVBxrkYOtlmO1bn@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:56:22PM +0200, Ido Schimmel wrote:
> For route offload you get a dump of all the existing routes when you
> register your notifier. It's a bit different with bridge because you
> don't care about existing bridges when you just initialize your driver.
>
> We had a similar issue with VXLAN because its FDB can be populated and
> only then attached to a bridge that you offload. Check
> vxlan_fdb_replay(). Probably need to introduce something similar for
> FDB/MDB entries.

So you would be in favor of a driver-voluntary 'pull' type of approach
at bridge join, instead of the bridge 'pushing' the addresses?

That's all fine, except when we'll have more than 3 switchdev drivers,
how do we expect to manage all this complexity duplicated in many places
in the kernel, instead of having it in a central place? Are there corner
cases I'm missing which make the 'push' approach impractical?
