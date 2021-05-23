Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D738DBB9
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhEWP4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhEWP4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 11:56:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58EDC061574;
        Sun, 23 May 2021 08:55:10 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso9096110pjx.1;
        Sun, 23 May 2021 08:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t+5MkSu3mBujA43uLcDMuoMOmhHFHE8pqCUwk/bfBbw=;
        b=pkjEnWmAi03pTeN80ISyMF+PIXn5yZCMmRgnQlFlGSgYrGv9ap+xVRgNgqlKeIGUiA
         yhIlS7CqZ2RX0Tjxs9tKM2SWJ/VgMobRDo8mlrHl3XdBraGztQ3wWohsTMCy8o8csugB
         mcRisMGsUadeMhs6+s2o16YK/XOA9/dF11Q7goP4MlBVgXVFhXGZ/oMIJrrTkPI0k3AZ
         Us5SfCs5QaBODuzVKdW4//edxj7MSW0gLUBXTUQo4sIDfEBMilhJ88aGHoN6ZXVk88rI
         XpUMkPQTaITuKv5OjjBCGWgjRlydlIBv6LEKugL13HYpuV5ffC7tOBHTrwx3Vf3CSmg7
         +03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t+5MkSu3mBujA43uLcDMuoMOmhHFHE8pqCUwk/bfBbw=;
        b=FJo0v2ieTrXbqkiVFkjOt+cRgdHSG1b12x8mRXqHhLCA3nVf+17KNgSYHVH3sgEPPw
         vOY+pVEG/Y1KBKxHfAxeTKjWDcjDTouDczqZtYEhCEiZkwGMTeoSystUUOT/mhYQgDn7
         qkzf+aHrr/wa+r5pBHtC3gwJ3+jmlB5OJqikN0Aa1rOf93kdNwFqNbHRIoNNzkzCOFu2
         h0OyiiK2PnLv4d7sPMjYxzSuNMCqYsLzIxxgkuCapDxMTH/PxcHcRmMCiPYQC0teLpom
         zSqjTi5bx8bmWSEULUZRC9RPNkljVYmnlcOtb49ZOklJcun1sOWtLeky2G5FXISJwVZE
         XZ/w==
X-Gm-Message-State: AOAM530AbdY8djqN24nLep5aM94DLnC+DveFkxJkoeJFkAgpPz4x8MSu
        PlbH8h2Ow3m0rZHlY1qA/RLb5x/68+P41Q==
X-Google-Smtp-Source: ABdhPJxofMG7N5YCl9euGVoi329vElZrUp4omztwpNnFw2mVD8csoQUj2tvn9D3c/f6KJtdi3tx96w==
X-Received: by 2002:a17:902:c9c3:b029:f6:3f15:e8d8 with SMTP id q3-20020a170902c9c3b02900f63f15e8d8mr17668705pld.71.1621785310347;
        Sun, 23 May 2021 08:55:10 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id o7sm9949609pgs.45.2021.05.23.08.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 08:55:09 -0700 (PDT)
Subject: Re: [PATCH net v2] net: dsa: mt7530: fix VLAN traffic leaks
To:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>
References: <20210523144809.655056-1-dqfext@gmail.com>
 <20210523145154.655325-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <385fe766-0886-e96d-3e2b-fc2c346685a6@gmail.com>
Date:   Sun, 23 May 2021 08:55:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210523145154.655325-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/2021 7:51 AM, DENG Qingfang wrote:
> PCR_MATRIX field was set to all 1's when VLAN filtering is enabled, but
> was not reset when it is disabled, which may cause traffic leaks:
> 
> 	ip link add br0 type bridge vlan_filtering 1
> 	ip link add br1 type bridge vlan_filtering 1
> 	ip link set swp0 master br0
> 	ip link set swp1 master br1
> 	ip link set br0 type bridge vlan_filtering 0
> 	ip link set br1 type bridge vlan_filtering 0
> 	# traffic in br0 and br1 will start leaking to each other
> 
> As port_bridge_{add,del} have set up PCR_MATRIX properly, remove the
> PCR_MATRIX write from mt7530_port_set_vlan_aware.
> 
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
