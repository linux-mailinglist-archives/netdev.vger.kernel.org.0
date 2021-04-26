Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF58136BA88
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbhDZUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238187AbhDZUGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 16:06:40 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799EFC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 13:05:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w9so6275757lfr.12
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 13:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ys1pALIVK8EXtzpFIZZmPRxRPFzULoCycqi5M+Q+z9U=;
        b=kONxnZMeg5qi+ye+Uwjhw0msT78kXlYOf6TxAV+uVl9zS9J8zuIedqWDzWv7pJoAB2
         D9akRegpfwmSiiJUldMX47tZqRmdNM+QsGrJ1uVMfJaEd48JI2R8QAbWmfDHKGIKxAut
         +Q34XgNxRZog6usMIWcoFuoOAnj0WCEhoqbUZM39SxfP2m/+UEFDUMWC8EKoz/uqucKZ
         0NP1vvMxeNEMjun6qaO20dbLW2WlblSm3Ad1WZzevdlASolNMKNZURgsSsSE9Lx83xVK
         jyksx4673h9xWYPDJAPXtePISDo/s61O59j07ZRu+9/VvUlYgVoosRoN77IKt85pb8Db
         rEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ys1pALIVK8EXtzpFIZZmPRxRPFzULoCycqi5M+Q+z9U=;
        b=AnN0qQ2yTeeS2ljK+/NG8eGDDxmWv5oRJA/026Qo/CCDPP2ixifQr7b6HosdM+08yu
         4NI0WF/G+VkFlvs4iVx2WnBtcycuVPgGxrtX8WYiNS5wSrgmWWcqrFoEHCOiXs651P4m
         unt9or99e/PsqPsZIFa/OY7dLduHD/RhKE0jIDjfu9sciB05ocXRjcfRWoxuejgrJ5yy
         3WjNqRI+kGhSIIunNPRCdqdVh2oxFE+OTgdVypXfD/JteGywld4erBOs9jErbNjKcVR3
         eHUex+ZlgHoFbDooJRCk6bPUvWlaiTwuB7KlwPAW/cNFfyGO7BD3LxGV90ARIe13XxaE
         yUlA==
X-Gm-Message-State: AOAM531/0WMD2Aiqt3h3hRuoH3zBssCft/daZ7IwwivXxM0RFyBGA+1x
        8IvPgdsL2BkHlg/kmkhY5/H/5w==
X-Google-Smtp-Source: ABdhPJxKFJZSMKEQEuNX4ZBDHUneFiJn0I85A/ykj8o9VGrJ3Z+HWHIN05qydUU+E09xI17nDc1rvw==
X-Received: by 2002:a19:354:: with SMTP id 81mr7802387lfd.174.1619467554930;
        Mon, 26 Apr 2021 13:05:54 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id t14sm109074ljj.49.2021.04.26.13.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:05:54 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 5/9] net: dsa: Track port PVIDs
In-Reply-To: <20210426194026.3sr22rqyf2srrwtq@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-6-tobias@waldekranz.com> <20210426194026.3sr22rqyf2srrwtq@skbuf>
Date:   Mon, 26 Apr 2021 22:05:52 +0200
Message-ID: <877dkoq09r.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 22:40, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Mon, Apr 26, 2021 at 07:04:07PM +0200, Tobias Waldekranz wrote:
>> In some scenarios a tagger must know which VLAN to assign to a packet,
>> even if the packet is set to egress untagged. Since the VLAN
>> information in the skb will be removed by the bridge in this case,
>> track each port's PVID such that the VID of an outgoing frame can
>> always be determined.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>
> Let me give you this real-life example:
>
> #!/bin/bash
>
> ip link add br0 type bridge vlan_filtering 1
> for eth in eth0 eth1 swp2 swp3 swp4 swp5; do
> 	ip link set $eth up
> 	ip link set $eth master br0
> done
> ip link set br0 up
>
> bridge vlan add dev eth0 vid 100 pvid untagged
> bridge vlan del dev swp2 vid 1
> bridge vlan del dev swp3 vid 1
> bridge vlan add dev swp2 vid 100
> bridge vlan add dev swp3 vid 100 untagged
>
> reproducible on the NXP LS1021A-TSN board.
> The bridge receives an untagged packet on eth0 and floods it.
> It should reach swp2 and swp3, and be tagged on swp2, and untagged on
> swp3 respectively.
>
> With your idea of sending untagged frames towards the port's pvid,
> wouldn't we be leaking this packet to VLAN 1, therefore towards ports
> swp4 and swp5, and the real destination ports would not get this packet?

I am not sure I follow. The bridge would never send the packet to
swp{4,5} because should_deliver() rejects them (as usual). So it could
only be sent either to swp2 or swp3. In the case that swp3 is first in
the bridge's port list, it would be sent untagged, but the PVID would be
100 and the flooding would thus be limited to swp{2,3}.

You did make me realize that there is a fatal flaw in the current design
though: Using this approach, it is not possible to have multiple VLANs
configured to egress untagged out of one port. Rare, but allowed.

So the VLAN information will have to remain in the skb somehow. My
initial plan was actually to always send offloaded skbs tagged. I went
this route because I thought we already had all the information we
needed in the driver. It seems reasonable that skb->vlan_tci could
always be set for offloaded frames from a filtering bridge, no?
