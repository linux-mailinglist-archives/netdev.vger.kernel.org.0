Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907452DAAC8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgLOKXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 05:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgLOKXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 05:23:35 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF555C0617A6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 02:22:54 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 3so17956064wmg.4
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 02:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K36QeBex9taYW3hhw2b229GNHMSNLUfgz5JSQHgq0RQ=;
        b=ut5I/5B0dpDpp4V58fscKQyWli4sF8D9SxW+eWBLVTYcHIHHmVVmAwvN3q7TgK9PyH
         1A40QJOO/UUMerQ2TeIIylYKqIYihKQEX8v0KdDXTZxNjAxfT3up4/E8ja3mO3W823an
         i10I9JfWG9y6aNBBv2ypFHwMfv7B8gzdpjKSOmTtqIY2ZJJ4qBgQgBAo4wt+wC9xrT2W
         FGjNYbfBaIk8a1QZ9mtfkOKTVVBFpg3HgRueFp2gUw0QDcNvRxbcOHChgrsRcviRZnNx
         93RINqoYn5gNrcmrSDuzwokPlr/XAmfVd9YktJffuf9LAZmx/eVJNmDQQOBKirnxCpfG
         vUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K36QeBex9taYW3hhw2b229GNHMSNLUfgz5JSQHgq0RQ=;
        b=DVupNNwGmReEMcK8P4GqOPUVR8sfut/gjc/vS5WsGeRtkNzgIgnf370r9Bk76UhgpY
         RCWEyOdMXqeYVHop98MV5N4/hdd3012B/bCC/Vpuu4TFM1PNUjB6EGe/hNaJfuKlw9jW
         Fa5I+ztfCAuEA8WuQ+fWM+o87wOg5G349aBdGYIX89g6oaffQl8Lnx2PLilhXvvOvjN5
         hjJHWjg0g8wY5qr2BPeijGzsiLb3oJyMwv2Xa5u5odxf7e9TNb2FLzPjgQZ8ndjwEVdw
         mkqpH0QzvTUWYZ6OVcx98JEiBl4ZiUuIqjlTtVACK5yGxWYHM6yJJ0bXWLp8cIYMq7nl
         w3zA==
X-Gm-Message-State: AOAM530BZWWpKZfi1fl05H/QLWO2ia3ZjfQMP4SS0jWLxcjoe++1uqv4
        AjNcm0+AOMpo/F8DaqN7gwA2TA==
X-Google-Smtp-Source: ABdhPJzGkVViYuc40sHFA8Tgz9RcSAMNpv4Inc9u/e34YjtiZC50W/IcOBsYVUMIKcHcJ8awNMX1eA==
X-Received: by 2002:a1c:4904:: with SMTP id w4mr31493771wma.140.1608027773431;
        Tue, 15 Dec 2020 02:22:53 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id m18sm22274535wrw.43.2020.12.15.02.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 02:22:52 -0800 (PST)
Date:   Tue, 15 Dec 2020 11:22:51 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH net] nfp: do not send control messages during cleanup
Message-ID: <20201215102249.GA5855@netronome.com>
References: <20201211092738.3358-1-simon.horman@netronome.com>
 <20201214182650.4d03cc7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214182650.4d03cc7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 06:26:50PM -0800, Jakub Kicinski wrote:
> On Fri, 11 Dec 2020 10:27:38 +0100 Simon Horman wrote:
> > On cleanup the txbufs are freed before app cleanup. But app clean-up may
> > result in control messages due to use of common control paths. There is no
> > need to clean-up the NIC in such cases so simply discard requests. Without
> > such a check a NULL pointer dereference occurs.
> > 
> > Fixes: a1db217861f3 ("net: flow_offload: fix flow_indr_dev_unregister path")
> > Cc: wenxu <wenxu@ucloud.cn>
> > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> 
> Hm. We can apply this as a quick fix, but I'd think that app->stop
> (IIRC that's the callback) is responsible for making sure that
> everything gets shut down and no more cmsgs can be generated after
> ctrl vNIC goes down. Perhaps some code needs to be reshuffled between
> init/clean and start/stop for flower? WDYT?

Thanks Jakub,

I was a bit concerned with fragility in the clean-up path, which is why I
had opted for this simple solution. However, looking at your suggestion
above it seems simple to move the cleanup to app->stop. I'll work on
posting a patch to implement your suggestion.
