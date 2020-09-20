Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F642711CC
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgITCol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:44:41 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7E3C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:44:41 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kk9so5127063pjb.2
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ubv2bA/z/dToN2xaxaRXLC3wPsRx2+cqIsWiQfIcRTs=;
        b=NvvW5iae5WwRl8qxz9U1xKu6w0wmuJxMsHBlJxCqKae9+DqVW86n7vrbPuZkYyNe8i
         2LNdKm6u/EQ/kwNwL+eIjjMgs5fiSiB9M3c/0Bp030/Voy9egJEEoMnJsvwcnrdZlRH+
         wo0XCATYoh64CDrvCDrNSz71Atq1CqO0O82ArkqWiWvEAlTUrWRLDaKviGyX5xYyQHHf
         HblGUkTnpLrlRgiypCHcMlNqtq3gcSmEbZBj7GzBXsTEeglTik+Dd7+4Yc4K6phqgvlw
         /pk5hloZVQbXlxdDy77OsBecFdUItP3W/TAI88iAwVD08x6W33wpIPacCWiVq1fIKZ1i
         TEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubv2bA/z/dToN2xaxaRXLC3wPsRx2+cqIsWiQfIcRTs=;
        b=dWRyrrK0/toPCGSdv/8ELQgADq1spLOpFs+M9t60lYD1H3sFbLvwQ0ee5yn9UCm+oo
         5vtowQ8nWo4wPs2icR8woyr82KcpVdofI5XhiPq0t8saqCyFnLdWEZePMVVZuG447tUh
         avEl8BnH1DytML4dOVnuOU16TWgnPPuXwHdoAbCO4Pmiqn2t4QzawhHy1JrwAgORsVx0
         kpTyN1X5wa7ja1LgOagAJGPNpHrctNj/LO2eN5/ldh2H8K6+d+kBv9l5qvaON9qTUa7Y
         4f1YMcjE4EsEZuUHtMr5Sin4ohqQmwdXtyMrJO2g4mPzkMOfaZJHZ7elBuxtWKmV3Doy
         rAGA==
X-Gm-Message-State: AOAM532zILtAkbxubLmINo5/8rsiDX9ASx4o3lfQR1+8inlNneU69xrG
        Dmw/HPk1GEm7rOvLHygsZzQ=
X-Google-Smtp-Source: ABdhPJwN9TFrEM7AoV02YylfTEc+CVwgE556AjhaEQhE1lpO5klTYfdptdj39X2fzc9VRtJj2dvF0w==
X-Received: by 2002:a17:902:854b:b029:d1:cbf4:bb43 with SMTP id d11-20020a170902854bb02900d1cbf4bb43mr29167152plo.13.1600569880777;
        Sat, 19 Sep 2020 19:44:40 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n7sm7720704pfq.114.2020.09.19.19.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:44:40 -0700 (PDT)
Subject: Re: [RFC PATCH 8/9] net: dsa: tag_8021q: add VLANs to the master
 interface too
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5ba7d62a-710b-4649-0093-812d30de8c75@gmail.com>
Date:   Sat, 19 Sep 2020 19:44:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> The whole purpose of tag_8021q is to send VLAN-tagged traffic to the
> CPU, from which the driver can decode the source port and switch id.
> 
> Currently this only works if the VLAN filtering on the master is
> disabled. Change that by explicitly adding code to tag_8021q.c to add
> the VLANs corresponding to the tags to the filter of the master
> interface.
> 
> Because we now need to call vlan_vid_add, then we also need to hold the
> RTNL mutex. Propagate that requirement to the callers of dsa_8021q_setup
> and modify the existing call sites as appropriate. Note that one call
> path, sja1105_best_effort_vlan_filtering_set -> sja1105_vlan_filtering
> -> sja1105_setup_8021q_tagging, was already holding this lock.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
