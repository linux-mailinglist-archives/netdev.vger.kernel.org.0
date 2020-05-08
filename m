Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127CA1CA197
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 05:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgEHDch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 23:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgEHDch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 23:32:37 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3303CC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 20:32:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id a4so244723pgc.0
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 20:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uUrlQnAJGrRXx9Vc2WGqD8IlEbKgIzJ49dJdpVd/7lo=;
        b=JkKkVYE30xtHiaNjBlEFfxo+cSKufKFL4oJ6xQhC17yoFCNwNYfD/3WGa2sPFtUTDM
         vkJm5mI6nv/7S1JgWSvQTjrfghBvCBuWHqxmVjkMhHZyV7Kd0u22UdXZQjKW2qPYKhJ+
         j+sr/Ht2gkqYgQUIeQpPXq7+jF+RDWUSr0x6ov+k67BxufBbDylUJ2Ogn8Maw6kiACP2
         og2W+dbB8zSJDtqhARz83cCt/qahhsFCRiPAFhWWqpgyj6ceM9A0rd5oghjQE9cYNkKk
         OqRRfXCPBXIG679Yh1FHveagjt8kHcrWpEJFHSXChUGfCDknS3hvW6kBdsN9tk+6aNjE
         MHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uUrlQnAJGrRXx9Vc2WGqD8IlEbKgIzJ49dJdpVd/7lo=;
        b=n3te94bWBb/2nkYZ2g61gnS/PcLh8QW/ZFYHruezyqgy25YrsPJc2zyP/g6By0774q
         3RiGhhXp2ElwyIHFzNUdupFBSxCylP5z7w0a8KL5RxhspYjRm8QfNgR1UPHlOUK12gyi
         z9/G8OpHMWgx07ND6bp8gn/v9FSNSd5IkIXTdk8XTpKeommHyuqaWfvC7fqTOXKSMmKS
         npyDXY1HDqpwiJPpP0EEAe9+RQpY8dvfQn4tamn7OgnIdqDhjlqm5CiH7t7GLZ1OgPWp
         5PdK/+lLUMp7PbjCJdWOH6AlgVBv6QtHd6QFIhqdribsIenvXD/je3heb2706k3ckh8k
         xgLw==
X-Gm-Message-State: AGi0PuZy/4Ce7jCwSjISfo6o7FVG7Fr8ogjzmsY7UZjdycxjx0+9IKP9
        cYEYY/QPtCxlcu2JBSGGggw=
X-Google-Smtp-Source: APiQypJPTahGhSsZ8ivGxD2PT7uCGqGE7T7Au6Hhs9d/zvGjudK/9sCQATlaXrGEcN95qlu5pfn3tg==
X-Received: by 2002:a62:1c97:: with SMTP id c145mr688663pfc.68.1588908756496;
        Thu, 07 May 2020 20:32:36 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 16sm1087580pjg.56.2020.05.07.20.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 20:32:35 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 4/4] net: dsa: sja1105: implement cross-chip
 bridging operations
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
References: <20200503221228.10928-1-olteanv@gmail.com>
 <20200503221228.10928-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84957d61-69bc-6f41-3b77-0199d415ded8@gmail.com>
Date:   Thu, 7 May 2020 20:32:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503221228.10928-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:12 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> sja1105 uses dsa_8021q for DSA tagging, a format which is VLAN at heart
> and which is compatible with cascading. A complete description of this
> tagging format is in net/dsa/tag_8021q.c, but a quick summary is that
> each external-facing port tags incoming frames with a unique pvid, and
> this special VLAN is transmitted as tagged towards the inside of the
> system, and as untagged towards the exterior. The tag encodes the switch
> id and the source port index.
> 
> This means that cross-chip bridging for dsa_8021q only entails adding
> the dsa_8021q pvids of one switch to the RX filter of the other
> switches. Everything else falls naturally into place, as long as the
> bottom-end of ports (the leaves in the tree) is comprised exclusively of
> dsa_8021q-compatible (i.e. sja1105 switches). Otherwise, there would be
> a chance that a front-panel switch transmits a packet tagged with a
> dsa_8021q header, header which it wouldn't be able to remove, and which
> would hence "leak" out.
> 
> The only use case I tested (due to lack of board availability) was when
> the sja1105 switches are part of disjoint trees (however, this doesn't
> change the fact that multiple sja1105 switches still need unique switch
> identifiers in such a system). But in principle, even "true" single-tree
> setups (with DSA links) should work just as fine, except for a small
> change which I can't test: dsa_towards_port should be used instead of
> dsa_upstream_port (I made the assumption that the routing port that any
> sja1105 should use towards its neighbours is the CPU port. That might
> not hold true in other setups).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
