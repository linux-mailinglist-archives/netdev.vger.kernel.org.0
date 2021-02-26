Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF73266B6
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 19:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhBZSIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 13:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhBZSIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 13:08:53 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45DAC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:08:12 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id k13so16331002ejs.10
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tJTj4L4Z1gvW5d3qhqo1mTYBW5OtC0f3OkfNL7pt5K0=;
        b=onOWWkmW9ZnD0IuarXdkEPvEh9mRiju07+9vrm3Y3XbADrRwLcddWitkNfSp93o6x8
         eiq9O9lSTlOJLBhQYQfAcGlCFkD26NpWpYlxC7CJjLabEL4FCycaNQApAnpfjEghOvMa
         ao8Xo/2Yy6zfjTbxjX7Rye723rxbzLT9PuwJ/zVuiRgmo0WmeIjHYXXIpXOUj97htS/M
         j5vhW29loGL+8VaDgngtNRVAZDLOEYb+R3mSyu94bHLe54p2izvZUulVs4OcQU1si3SA
         lpbRLNW9IviQZOkKkjA5E9OoDTBdSc9ctvDooMPeBNLrAy3IcdMC0sGPB6XQweOkOIT2
         z++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tJTj4L4Z1gvW5d3qhqo1mTYBW5OtC0f3OkfNL7pt5K0=;
        b=dnr5v5WzUvISJS4B+y+hd2OJ7YWGVbJ+Eevxw0ea1pM+meXgXRVBHQ+RWfUPtkyxsP
         n7kMclz7yPe0btlbG8nRp46ZAVD9Q//A301NTAndPOc+8faXRJRyX/p7NYYx6J+jXeDB
         8WFj7XDEtuldieBPcuHLo6hxti4ddF1TLcN4qbBZzwQG96Arl9KWlioQdY1go5mn/fpS
         u2l0oKTX2tm2A8Xi2fuj7xEiqvu2uCzpaIJgIXSh02JKzM2rMNnSx+0cCeQTrZs/w10F
         8jC5K8FO2j3iekh97JG24wMnAnOvmio2pq8xmX6GAwtJhWBsQ5JqVaX62uIXzrEGHTGj
         utUA==
X-Gm-Message-State: AOAM532duu7KvqDAFVymtvvgBpByN25EKgPL/Qsh8rNywkacEg5Rh7wv
        E2oAVYU6iZAzve9TtvpcP7s=
X-Google-Smtp-Source: ABdhPJymy6DBxRIRvgDRCW8ZQAqYNyLjNEGihdhWM/Vo3SUCqZpkYRqaHZlUKBdU0MuRlufxvu0xjA==
X-Received: by 2002:a17:906:145b:: with SMTP id q27mr4805232ejc.432.1614362891498;
        Fri, 26 Feb 2021 10:08:11 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r17sm5593780ejz.109.2021.02.26.10.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:08:11 -0800 (PST)
Date:   Fri, 26 Feb 2021 20:08:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 15/17] net: dsa: replay port and local
 fdb entries when joining the bridge
Message-ID: <20210226180809.25xsn26gphxlvwv4@skbuf>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-16-olteanv@gmail.com>
 <87mtvrqapw.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtvrqapw.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 01:23:23PM +0100, Tobias Waldekranz wrote:
> If VLAN filtering is enabled, we would also have to replay that. Port
> attributes also, right?
> 
> I like the pull model, because it saves the bridge from doing lots of
> dumpster diving. However, should there be a single `bridge_replay` that
> takes care of everything?
> 
> Rather than this kit-car approarch which outsources ordering etc to each
> switchdev driver, you issue a single call saying: "bring me up to
> speed". It seems right that that knowledge should reside in the bridge
> since it was the one who sent the original events that are being
> replayed.

Yes, in the non-RFC version I'm going to do that.
I'm also thinking I could just pass the blocking and atomic switchdev
notifiers as an argument to the switchdev_bridge_port_offload_notify()
call, such that the drivers need to do one thing and one thing only.

For the purposes of this RFC I just wanted to have something that works
for address filtering.
