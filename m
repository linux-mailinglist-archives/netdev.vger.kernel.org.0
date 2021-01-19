Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D802FBF68
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 19:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbhASSsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391773AbhASRw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 12:52:56 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31829C0612ED;
        Tue, 19 Jan 2021 09:47:42 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id r4so10914643pls.11;
        Tue, 19 Jan 2021 09:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vj3d/y6C6DOgbXzf2RttFBmm8LEeclj0ROf8HeKiY8g=;
        b=Gza4yrKvypPVvC2wkKL9etDjldp+9bnLdLXbFgYamGwpBhn7ArAwoylghM23j+yHj7
         rYme0rAafT0rqHv+SPbuNogLo/MHU4xq9qijpgZQBBIr8sdwK8od135MLwnehdx6Q8k+
         h+nOuaS2oWzRn1hqVt+DyRcw6h0PjFMA0bQNsF09qBy32Qn0C7QvuA6BrAiJEi2/mSOJ
         yln3f99grwA0E5tXHo5SmH5rvumiq2PdDYZ/GUzG1I5P1D+pscNonjfSPA3NRRfHlcGu
         EGiFCBqGCwQUwHqJbUc7ZPy+YphQgkBH9U5n6ebS63iSZvsW1xxPO0DpTHh6dUZV5Drn
         +LFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vj3d/y6C6DOgbXzf2RttFBmm8LEeclj0ROf8HeKiY8g=;
        b=WVp/JZGmILqilyBphnBrkMxRfWvXLIL77Iw2dWUPQfy7+b+BKR98nOIt7soawHkVwc
         T3CNaLkwjIDUcJcij4C6aR3b8eO8zwQcIE+9mafGEVA91Cfr1xY2PBhrg1ffKkDI8qPu
         P1ZnAA1ZP4/N2V8vz5U/ZoyF7zdq02MIY5Tgg+x6054rqZVehmIAk9o4iC3ffjE38Fld
         vf/cHDRNtSqwhPFAMIZ9lo3fLV4aWNrZalxPjPTL3+en2cMDN9Q3uSmxNuSsYKcyT1g8
         aEYjRP1DW1wgo7bm4ajSqdAIJH5CbD0If0ZhJ0e6aYwFHXpFwS47sIFgL64APHePO7ca
         cPTA==
X-Gm-Message-State: AOAM532vXo3ME5WnK3jMc4jLxdlXSoKtiNFAXwLNhfOdyJhe5ja4MYMG
        N3ABJH5/eLtv/uRE/B3YXR9weJSZKSo=
X-Google-Smtp-Source: ABdhPJxgoYwtpZyHVG7nHZ48lLA7Ax7OrR16pA6VPKzJj98xFIQn662Hh8HrG3XMB0Lgo51MW8X6rw==
X-Received: by 2002:a17:90b:11cd:: with SMTP id gv13mr864755pjb.21.1611078461270;
        Tue, 19 Jan 2021 09:47:41 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a189sm2785265pfd.117.2021.01.19.09.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 09:47:40 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: Fix off by one in
 dsa_loop_port_vlan_add()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ", Andrew Lunn" <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YAbyb5kBJQlpYCs2@mwanda>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd234f6a-7b30-09a8-df14-e0243d2e9304@gmail.com>
Date:   Tue, 19 Jan 2021 09:47:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAbyb5kBJQlpYCs2@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 6:53 AM, Dan Carpenter wrote:
> The > comparison is intended to be >= to prevent reading beyond the
> end of the ps->vlans[] array.  It doesn't affect run time though because
> the ps->vlans[] array has VLAN_N_VID (4096) elements and the vlan->vid
> cannot be > 4094 because it is checked earlier.
> 
> Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
