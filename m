Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F53D9C8C
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhG2EWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2EWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:22:20 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC43C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:22:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c16so5399570plh.7
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U7XGZRczsZwtqjlaTvf46exP7LV/S9DdpRRKxZ8l0qQ=;
        b=fQL2RBpDcmQvltulvPfMTs2+P8+TfjdOXqVBibqdgQYAUIdj9oB2GxAxkDlaAhsGkC
         rhAhRdsLt9Wu+gtnX2xq4N+nKfvZ0TcREoaxmEi5hyUyysR+/0eSN3RlgOYDZ91WUXPK
         srfn1wieZ6pOLTJ8ex103kBFgsMTENUyHMdJOCJO1rT2lwrvqrLivQ9vp1Phewj7xE3R
         xk/4aiehj/kj0f2Ioi5tQ/x4RqPc233NFy/wHORhKh7uBrrXsWT9UcRw6ATj0BWSaFFy
         4vr8kSSneSyJGJy0F0xLcB9ReijoVcr9r2oX4fKkuVWvlbU182Xy6b53DU6VdDL+MZK3
         1EeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U7XGZRczsZwtqjlaTvf46exP7LV/S9DdpRRKxZ8l0qQ=;
        b=o1yVJ+aHZwz5t1TSlZZpYA6A+xFCgQS4eFqtljAI3EBK4Wxf0swug9B1LiFX8+CXEh
         AhEEZaP/gd3rHDBRNpw9GEB4zLvWrm1fMUlmNNkVqNO5ZBu9kG3r4ofZfRLSTTH8KuCo
         QsttdSr7QxRgGV/6t3myBSQ+tWqfg6n7hoNd1+floruzjZHzcHDK1xqQ8xReueUFsyZk
         gelM0FeMX7HxwMFS5TyQBH0g0ueVOvC/mBjZ0wMBBdsbS6u9mjAVC52D1jJ7KrPIFaUX
         AA5c1YWsfn1XEE9GmlIbphgsqcew8nD5QO9jzl3XwJyocFmL0ljAjnjHqnicAukiX85r
         StiQ==
X-Gm-Message-State: AOAM532xb7bWIheQmnvSsNqk+GJd8o+2qayxXE1VYu5rR165F4+xAK8L
        ubX/C7hfn1ky/ll+klyrz74=
X-Google-Smtp-Source: ABdhPJyly+v304+C8Dvh5EmKbFdRDcVM02Jz2E4s7JH8QRxWklCn2z8/OKbuglI5HvjsIKoOeGggQw==
X-Received: by 2002:a05:6a00:139e:b029:337:1895:b702 with SMTP id t30-20020a056a00139eb02903371895b702mr2927449pfg.39.1627532536836;
        Wed, 28 Jul 2021 21:22:16 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y23sm1660598pgf.38.2021.07.28.21.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 21:22:16 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: dsa: sja1105: reset the port pvid when
 leaving a VLAN-aware bridge
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
 <20210728215429.3989666-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1feefe30-7a82-218b-557f-2840c0775a0b@gmail.com>
Date:   Wed, 28 Jul 2021 21:22:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728215429.3989666-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2021 2:54 PM, Vladimir Oltean wrote:
> Now that we no longer have the ultra-central sja1105_build_vlan_table(),
> we need to be more careful about checking all corner cases manually.
> 
> For example, when a port leaves a VLAN-aware bridge, it becomes
> standalone so its pvid should become a tag_8021q RX VLAN again. However,
> sja1105_commit_pvid() only gets called from sja1105_bridge_vlan_add()
> and from sja1105_vlan_filtering(), and no VLAN awareness change takes
> place (VLAN filtering is a global setting for sja1105, so the switch
> remains VLAN-aware overall).
> 
> This means that we need to put another sja1105_commit_pvid() call in
> sja1105_bridge_member().
> 
> Fixes: 6dfd23d35e75 ("net: dsa: sja1105: delete vlan delta save/restore logic")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
