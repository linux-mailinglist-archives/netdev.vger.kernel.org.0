Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE21CEB5A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgELD2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELD2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:28:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913D6C061A0C;
        Mon, 11 May 2020 20:28:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x10so4783428plr.4;
        Mon, 11 May 2020 20:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1d5OCkOtOnJ8OLVOeaxWfOYK4GSiBg86sv7BBdrALvU=;
        b=bN6Fi/WEFa57u3XBvVIZ8uWR8bSVV+qc0T74MDyq+/8YXo0lZgkilfWWTne7KrpYA1
         h8lbaSe0lI+1i1Kx6rud6na5o7ywImuH2I3SbBP+5tvbKS+vhQost8AdwmL+Iz3sj2Si
         8V5Xoq1KLF6fLq74KEVrydk7opVY7WKjuMVPvkRxweGVfebPxcVsf4ZLBUDAh1YxhfMt
         hgb+VfTQc2NTvuGuA+8jw5TmFzNhyc+tVHrc0QU8BAgx6hd5NEMS3Ls4orDnZnku0fUs
         OoJ8yIqnti0haMc4Pe9Kige++LnV6bWxDrZuutzNfbTlRDUTTF4bg7ofRbUQjK9g8jgD
         z/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1d5OCkOtOnJ8OLVOeaxWfOYK4GSiBg86sv7BBdrALvU=;
        b=tS6MjVSc+0F/12QvN8jbTKdK0fg2EDpXUmrm9jgpgN5FJC7HzkK/VkWN9WUhrYGEE6
         HJ+9iN4bofxC+hEXWVO/i+M3DlRCmX/V/joEK7d8sN6vwvTXfybHuzyZmDIm0aVx0VL4
         jeAQ1xJ7SqdlEKYRh+GJhhgeaZR+KJOXPBMmSYfzA+KxL/UjEAw/z7A20mRLtUT0g1BQ
         k9t3bzB9MeLZKE2b9GFO8QZKObBggoYEPkRIJtjr0lXudVUDInHM9sgWbJvibGx5qlav
         kH77fKZ6/0Tn4Bj7elK8FzKLKmQKVkvnouLCA7nvXy3blD/uEop63SUxU8keWMefjR+5
         LYEg==
X-Gm-Message-State: AGi0PuaGVfBp0T9cYz/NIig3rwiYNUbYmww5YLzvwUE9hP4Z0PdGzYs/
        q0rYdYQsuFS2gfnLwKE49CIErVij
X-Google-Smtp-Source: APiQypK8E7+Ha7ZfpUfXOwYXzk9w+LvPp9SdhPKYFtiBqpzCrnWym+QKpOUODxgsaHpCBcTY5yrlRQ==
X-Received: by 2002:a17:902:eb54:: with SMTP id i20mr17902118pli.179.1589254117694;
        Mon, 11 May 2020 20:28:37 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k27sm9074952pgb.30.2020.05.11.20.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:28:37 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 04/15] net: dsa: sja1105: deny alterations of
 dsa_8021q VLANs from the bridge
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <967cf2a8-6f23-b241-bc60-b431091b3a9b@gmail.com>
Date:   Mon, 11 May 2020 20:28:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> At the moment, this can never happen. The 2 modes that we operate in do
> not permit that:
> 
>  - SJA1105_VLAN_UNAWARE: we are guarded from bridge VLANs added by the
>    user by the DSA core. We will later lift this restriction by setting
>    ds->vlan_bridge_vtu = true, and that is where we'll need it.
> 
>  - SJA1105_VLAN_FILTERING_FULL: in this mode, dsa_8021q configuration is
>    disabled. So the user is free to add these VLANs in the 1024-3071
>    range.
> 
> The reason for the patch is that we'll introduce a third VLAN awareness
> state, where both dsa_8021q as well as the bridge are going to call our
> .port_vlan_add and .port_vlan_del methods.
> 
> For that, we need a good way to discriminate between the 2. The easiest
> (and less intrusive way for upper layers) is to recognize the fact that
> dsa_8021q configurations are always driven by our driver - we _know_
> when a .port_vlan_add method will be called from dsa_8021q because _we_
> initiated it.
> 
> So introduce an expect_dsa_8021q boolean which is only used, at the
> moment, for blacklisting VLANs in range 1024-3071 in the modes when
> dsa_8021q is active.>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
