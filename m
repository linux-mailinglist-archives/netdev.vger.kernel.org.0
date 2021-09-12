Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCE0407E76
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhILQO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILQOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:14:55 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D77C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:13:41 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id g11so6155954qtk.5
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jrKPDSyqlfa5ko+t5aSIib2ipq8puVz9cvEr5ZpPHBk=;
        b=QirUgSa4gVwzAFU6tfmkug8UtBHKE9VHnAtW8/EyAtsQlJMG5xqH8xWQwoGDehvp9U
         QRPe8myHhEX69xg5pM7FCmwnNrS69BpR6YgZI3kVR6EK7cH81Gj6WMSF0h5dYRFet0u0
         /wkTTDpLIVVkOLFXIAUQleNqeBs8vxqB2MkHdk3F29cSLlo4KSRg3C5eedsKNQ02Rd4Z
         mtNsmcvjMsxFd96SkYDhKqePzKOFplWA4UDe7aUiJUHSqhcTIXmoBCp3HyI8+9DLgMaj
         vCHBtbKZmTmr2xiJsLf4ImAP9AuSSmilnQYp1kyLn2P2E69SMLDkD/f0HMCsG9MeUH5Q
         V5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jrKPDSyqlfa5ko+t5aSIib2ipq8puVz9cvEr5ZpPHBk=;
        b=51byKosAHPFgMLTNqIIRDUgvaT+03Irz/CrpmTNCfoqWxS8WYMjOG3qAoFEfk+b0oI
         v9y2hNzKEh6ZVcTfyAjfHTx4N+C4RTfv3UiaS0uCwW08Ype/87174aZPpvw5z9yN0Mdu
         50rWYxq468af/sjDTDYpTj9GcOu1TVSvJrXs0zDz0cyEZd79/wdY9hOEV3utwFHh/CXM
         Yl0JLYU3DNXl1UoB42nczzZKp8c9J8aXVm2jK6wSdA/7qFqoD5K9O0+xzZom+K4n6A7Z
         l95llSj+HhWhQDExhnL3Aihi71DGUUsjyVohRzTd5f0o7OKdJ+TozrwQamnifVqVP6cS
         uelw==
X-Gm-Message-State: AOAM530qkhK9t0f1adNj7ebpypjFtNcnmU7Td4cWimcHeXMbw1F/aIdp
        8wXee59Uht9+uZj1w9Lzn4I=
X-Google-Smtp-Source: ABdhPJx6Xig+ofPCztPyiMPXwx9qREdU+n9KRdr70CFine+2Q2D9haGqO+tzSajRsmJ4W/jVN/fFBA==
X-Received: by 2002:a05:622a:1454:: with SMTP id v20mr3671856qtx.16.1631463220215;
        Sun, 12 Sep 2021 09:13:40 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:b198:60c0:9fe:66c9? ([2600:1700:dfe0:49f0:b198:60c0:9fe:66c9])
        by smtp.gmail.com with ESMTPSA id c28sm3465480qkl.69.2021.09.12.09.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 09:13:39 -0700 (PDT)
Message-ID: <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
Date:   Sun, 12 Sep 2021 09:13:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 9:00 AM, Vladimir Oltean wrote:
> Sometimes when unbinding the mv88e6xxx driver on Turris MOX, these error
> messages appear:
> 
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 1 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 0 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 100 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 1 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 0 from fdb: -2
> 
> (and similarly for other ports)
> 
> What happens is that DSA has a policy "even if there are bugs, let's at
> least not leak memory" and dsa_port_teardown() clears the dp->fdbs and
> dp->mdbs lists, which are supposed to be empty.
> 
> But deleting that cleanup code, the warnings go away.
> 
> => the FDB and MDB lists (used for refcounting on shared ports, aka CPU
> and DSA ports) will eventually be empty, but are not empty by the time
> we tear down those ports. Aka we are deleting them too soon.
> 
> The addresses that DSA complains about are host-trapped addresses: the
> local addresses of the ports, and the MAC address of the bridge device.
> 
> The problem is that offloading those entries happens from a deferred
> work item scheduled by the SWITCHDEV_FDB_DEL_TO_DEVICE handler, and this
> races with the teardown of the CPU and DSA ports where the refcounting
> is kept.
> 
> In fact, not only it races, but fundamentally speaking, if we iterate
> through the port list linearly, we might end up tearing down the shared
> ports even before we delete a DSA user port which has a bridge upper.
> 
> So as it turns out, we need to first tear down the user ports (and the
> unused ones, for no better place of doing that), then the shared ports
> (the CPU and DSA ports). In between, we need to ensure that all work
> items scheduled by our switchdev handlers (which only run for user
> ports, hence the reason why we tear them down first) have finished.
> 
> Fixes: 161ca59d39e9 ("net: dsa: reference count the MDB entries at the cross-chip notifier level")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Did you post this as a RFC for a particular reason, or just to give 
reviewers some time?
-- 
Florian
