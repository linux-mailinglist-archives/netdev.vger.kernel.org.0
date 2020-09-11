Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE9726683F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgIKS2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgIKS2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:28:30 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55328C061573;
        Fri, 11 Sep 2020 11:28:30 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so7214205pgl.10;
        Fri, 11 Sep 2020 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oGy60kweS4PLkfhdZmoSU7gQz4aGeok5OjY4ObJDP3I=;
        b=Uiw9LuGCDx+ZA1o2eCV1Z6buvR0PRsB+Cy7f75w4ow/kzlc71uer9OpgqjhWmoXhCV
         DRnbxvrFBm39hKRFg2+8R9LlPfAQXyPcI66DpXraYhwIyDEGSBiGJojCY0kKpVvsY2IK
         Oh1hVqBJ2oA4kD9BR4DNX74b2xh7W8GxiAOMmHpKW/xRX1eY/3n+97KY+gS4E9e59z5Y
         JPHPt3pLHR2llBdD+eBL4sfPNYQRW3Jti+AUhWWohqaSxHm/dH+/5ANJXHJ60QHCig/T
         lJ4GhVBqz70OJOTzm3CaJNXGfZZvW9U8U6wWk9h0MFJ0RRfzdXpJBbzeS+otCud9xuzs
         CtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oGy60kweS4PLkfhdZmoSU7gQz4aGeok5OjY4ObJDP3I=;
        b=hpoKqu+BGXK5mPP4ULVzXsNTyBDzO9dhmqGamG6zNVL1eB8CKkZhmGCyQxvLyjZ3Bf
         NnYVaRLpVVCqRw62YbSpDz1imULtTPmA9ZKxwD/x5WphPUyBlokC6PYbZ9JGZcQel+RP
         Cj0Pxyxhn3VZrznIqjv+3Ut0xH0ellEOufskqZY1YM5E8E3i82Lw07tc/JzfV6rb0IdZ
         nesqSgCClilYcnOOh0NU0rv4YsDiqiWYqhbiaI63RiN0mNKeqnGsfBY+tUoQow4AJoC2
         x+G+HexivGtzaPzHZXYcCO/tKVYGU4oKw6xYTvKsl9ZWF0A57P8Mwp+GhTOzztXcMUuR
         w/cA==
X-Gm-Message-State: AOAM531kS3nb22AMlbrjawYbkDKpaae16gkf8R9blK8TdInZtY+6AcM0
        ouci/a8le7sBzqqgfHGiuCaSYgap9qQ=
X-Google-Smtp-Source: ABdhPJyFF5iTbocGnmVsysQxi2B8gmRoPwAJ1cURQE1YitrYXHfW9rDraKW8q7TLBdpOVHIXf2szyA==
X-Received: by 2002:a63:d703:: with SMTP id d3mr2562886pgg.428.1599848909479;
        Fri, 11 Sep 2020 11:28:29 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q18sm2991908pfg.158.2020.09.11.11.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 11:28:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: b53: Configure VLANs while not
 filtering
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200911041905.58191-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <12b6df34-6f0b-fb40-2f04-1927d88f5321@gmail.com>
Date:   Fri, 11 Sep 2020 11:28:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911041905.58191-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 9:19 PM, Florian Fainelli wrote:
> Update the B53 driver to support VLANs while not filtering. This
> requires us to enable VLAN globally within the switch upon driver
> initial configuration (dev->vlan_enabled).
> 
> We also need to remove the code that dealt with PVID re-configuration in
> b53_vlan_filtering() since that function worked under the assumption
> that it would only be called to make a bridge VLAN filtering, or not
> filtering, and we would attempt to move the port's PVID accordingly.
> 
> Now that VLANs are programmed all the time, even in the case of a
> non-VLAN filtering bridge, we would be programming a default_pvid for
> the bridged switch ports.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

David, Jakub, please hold off applying this just yet, Vladimir has 
submitted another patch for testing that would be IMHO a better way to 
deal with DSA switches that have an egress tagged default_pvid. 
Depending on the outcome of that patch, I will resubmit this one or 
request that you apply it.

Thanks
-- 
Florian
