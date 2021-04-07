Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4FF357642
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhDGUqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhDGUqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:46:54 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A29C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 13:46:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x4so1461955edd.2
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 13:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DEH5OiHUMSSzVTDAIw0bSpWUsSOAFR/jjnwEIiOmzGQ=;
        b=tTPQEZmVcB+YhdFxmar9Ue/0Hcrl7SMKiD8WgN8W22voF33kAEf4RWfG4qygMT3Es7
         yDHahXTocp4jKWPG6JyZVcsbN9GHS4a9magdQKOXOeme8emVm4qehRu2FP5UbOCy7iO2
         1LVeJkePhtkHp9GuUTvBrsZvQcXvLXIZ5DxPJNojnPnIkt19DSq5bTM4yjBJVJRajgmn
         5CgLCnJaAKx5UH5oP0cL99bnZdbAkt6s/9RxMurEIHH1yxpZAyIcviHsOZ8XGgaQ97+P
         dpA4q6RTQXnxmiqu+LnrC1WWTZV0fOsOn4w85RwmiAYWwE9+gHeWUDgJRjW2E5503dvR
         Mo8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DEH5OiHUMSSzVTDAIw0bSpWUsSOAFR/jjnwEIiOmzGQ=;
        b=YueUrNdJHe81FMhe3mCkzhMsdcP/hkYiQDBrfpFN1s/JYkEFBhdGLj9RFh2ZrWETEW
         RPyImX7H5rZXKWzaMK9/aARXJl46ftXnOC4MZgr5RZtwqFpVwnQ1OFSLi+DTTcK2zj7a
         k9kT75/Z28B1UgOaITrB7r+NKRA9RMHfSFc4WNqkHmWDK/htsJDWQP+y1zRKY/BBT1FQ
         kL5RbJ4M7Avm+C45x7SUutqBWeQNc0BN2eJlYawY8ERZaaNquGCC0fLVTK4EAvn/tuGx
         wmlj6d+yCRl92XBUEufnyLDAk32V8Na8pdhAkDErpA7YOuMNwlCzu1sDkUDj6f8jN6TR
         S+Cg==
X-Gm-Message-State: AOAM532WMZuAkI6qyB3fOP27tnFn1nhbLya9GBYcPe2UdrQJaMGVlpNd
        su0VufIH7myLwc1EuKQIiFM=
X-Google-Smtp-Source: ABdhPJzFZXzUKovpe+GVQGZjHIPJjSjEjccdq+FpuQHmI9l5hkasB582a/blsKO5YDq1qWH0s9i/Tw==
X-Received: by 2002:a05:6402:1759:: with SMTP id v25mr6805944edx.177.1617828403102;
        Wed, 07 Apr 2021 13:46:43 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id u1sm15991169edv.90.2021.04.07.13.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:46:42 -0700 (PDT)
Date:   Wed, 7 Apr 2021 23:46:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 0/3] Fixes for sja1105 best-effort VLAN filtering
Message-ID: <20210407204641.ly6hnjgi4kjbn4co@skbuf>
References: <20210407201452.1703261-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407201452.1703261-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 11:14:49PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series addresses some user complaints regarding best-effort VLAN
> filtering support on sja1105:
> - switch not pushing VLAN tag on egress when it should
> - switch not dropping traffic with unknown VLAN when it should
> - switch not overwriting VLAN flags when it should
> 
> Those bugs are not the reason why it's called best-effort, so we should
> fix them :)
> 
> Vladimir Oltean (3):
>   net: dsa: sja1105: use the bridge pvid in best_effort_vlan_filtering
>     mode
>   net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
>   net: dsa: sja1105: update existing VLANs from the bridge VLAN list
> 
>  drivers/net/dsa/sja1105/sja1105.h      |  1 +
>  drivers/net/dsa/sja1105/sja1105_main.c | 61 ++++++++++++++++++--------
>  2 files changed, 43 insertions(+), 19 deletions(-)
> 
> -- 
> 2.25.1
> 

Please don't apply these patches yet. I finished regression testing and
it looks like patch 1 breaks PTP for some reason I'm afraid to even think
of now - the RX timestamps are still collected but synchronization looks
flat by around 1 ms.

If my suspicion is right and the VLAN retagging affects PTP traffic too
(which should hit a trap-to-host rule before that even takes place),
then the MAC timestamp might be replaced with a timestamp taken on the
internal loopback port, which would be pretty nasty. Or the strict
delivery order guarantees towards the DSA master (first comes the PTP
frame, then the meta frame holding the RX timestamp) might no longer be
true if the original PTP frame is dropped in hardware because its
VLAN-retagged replacement is sent to the CPU instead? I don't know. I'll
do some more debugging tomorrow.
