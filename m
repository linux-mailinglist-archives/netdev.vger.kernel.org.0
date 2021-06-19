Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E786A3AD68C
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 03:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhFSCB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 22:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbhFSCB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 22:01:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE6CC061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 18:59:17 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q15so9273938pgg.12
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 18:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u1AMljh5ebd2bW1musCcwxe25LHEp176QjGR55vxDYI=;
        b=t5KEXK3l1D0IaeTbpyRk/T32yKmEmkoMS8FOza7CdjVoJOePypE3g9ljooD70TwwKM
         Y1CDdUIpEVecyAIvr08LcljmMrFy05RAxsYfoWQd3SV0WivKY/iP+Ot6MVWjonuCpN/W
         2wh06wTd/1thACGQQ3T3KghjCPBWLiBqfEQCRIan+xWu9w/cUuHzAYDfEfO0eSGn7FVk
         NLG7XLj4MpSDqsvXnCMFilZj/2ykCuUzlCSiUXDeh6NFaJSe7yOoAOPSmA5TrcNFusI4
         pSUEM1izXkbLhgGR1gm+0x4gXY5+c0Rg0LKwgfIzPUv4fMlIdx91jPfnEnx9gm+CVi0z
         R3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u1AMljh5ebd2bW1musCcwxe25LHEp176QjGR55vxDYI=;
        b=D01qp7gUo/HiUHlgF/ukAFOBBWYHEBWob7IPQHFsASKYm4d6GtvMoo1+o20epZ3YiV
         djQjl5xs8GWYZr950iEqQZh/NKlHkblvkv9Z+MXEYZJ2BbEHA8UlwkhdBukRCEARl9qL
         Ml0hs7SGDaHm4ZK9ZvMn0/6clWzq/tllSGoQIhTXzYcFSm62BLTvQ69FQE9S48pdJ/7Z
         zHiaxDQ6HLQQWv75Ovgzoz2umVN0i89MjxUDVLD4S90l3hZpseF74bS7JoNWXzbTN2GW
         9pwFiWFMjFop+Knj0xOYQNgEn8SKtcf2w5zIlxJ87YAnJvwZu+zRYefgUzjgKSisCzRb
         tPDw==
X-Gm-Message-State: AOAM531exePnjMiV1cFWWl7HIxHr2L9ZfKynzAEVyiMC9yGvx9g5SY2+
        lT8I1W6Y1nh3x+878J77BHo=
X-Google-Smtp-Source: ABdhPJzpaoRFhFJ1vMMdMUmuVsyBjaWgRb6dz/IlR5GgigqGLpj6etddXQV+cr3WT5Sk7DYheciBzg==
X-Received: by 2002:a63:1141:: with SMTP id 1mr5614674pgr.217.1624067956860;
        Fri, 18 Jun 2021 18:59:16 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id em22sm13397902pjb.27.2021.06.18.18.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 18:59:16 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] net: dsa: assert uniqueness of dsa,member
 properties
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9b95b6f8-723b-f078-c9c6-f8333c93fdff@gmail.com>
Date:   Fri, 18 Jun 2021 18:59:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618183017.3340769-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2021 11:30 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The cross-chip notifiers work by comparing each ds->index against the
> info->sw_index value from the notifier. The ds->index is retrieved from
> the device tree dsa,member property.
> 
> If a single tree cross-chip topology does not declare unique switch IDs,
> this will result in hard-to-debug issues/voodoo effects such as the
> cross-chip notifier for one switch port also matching the port with the
> same number from another switch.
> 
> Check in dsa_switch_parse_member_of() whether the DSA switch tree
> contains a DSA switch with the index we're preparing to add, before
> actually adding it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
