Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3F22A273
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732922AbgGVWgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgGVWgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:36:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CCAC0619DC;
        Wed, 22 Jul 2020 15:36:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so3366727wrl.4;
        Wed, 22 Jul 2020 15:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kz2w9f6frW3tghSL2zSCIYf47I2KccSy+DwiSsQhMSc=;
        b=ZhShWHd3a5L5plAi0v4InTrHQZBdmoMUbj5dyJ71K4JwvXUCYvREO/olQPQEKS65NK
         ndmFAZxay8kp9FQY0t0Ns8guz2Q+TeFF/nft6GViGdcoUwthpf1YLu3gIca7rI3EWi8B
         TQMASa6rZWpaiIFTS+aO6krJJXWL/dVkJL146NNzyh0MJ1NMVgEHj16JS2xnisJmuOVM
         AwYi93O4pK+00z1/jAE2tQuXdY/JxV3XIvgUTh23UGxa8ieHPyppic3tL30B7OVYV7f1
         zeMrMPd7ggL6VtP33qMEa38XKzW1gLJFZ4upSZTiERlDWXtpADfw6BtJ8ARHpkrwA+yG
         EkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Kz2w9f6frW3tghSL2zSCIYf47I2KccSy+DwiSsQhMSc=;
        b=KN8O20jlxrlvD2h7OuswGfVGAOCXeEonGOCKBz0VmQrPzs1C3k8UgOEQ8DqpbWJNKk
         lKU2tURGpRPXnA6U7bnAUo8PZLVhPqIJxESbAdeymHRwcS8pSTzWJVmWKzZ+/du8WkB5
         /UFKoqU3yAEgfAYqYPsv1C6En/DXd749M84NPQI68l6siizDcNWTVpuZIOPm09dLq87x
         Y5OXFaE+exTWbeE1P6JQXHAfmCUzV4K1jD8D7w2hjFxuPgnabz/WecfDb1lS4/fNrydo
         bF9us1IUeZj4h1l9ALXqiuY9Kgc8oc2DKhiS4RyoYq39ei06SVkOwshvOaAfnyjdXqaA
         iEqQ==
X-Gm-Message-State: AOAM533TMiCujz6Ml39xrjuvahhvP9VhkuiVLTnEKjRGIcGsLfN55NZz
        KssxAyWNTHwmzx3uGrzs9JObKpAq
X-Google-Smtp-Source: ABdhPJyoyX7mNEyhwuX+6wbiony4XwvfGNeCMxR/K8uPBVcOwJfr38qR3OHZWDhuFDY+GHAXe1QW3g==
X-Received: by 2002:a5d:55c9:: with SMTP id i9mr1340938wrw.31.1595457407234;
        Wed, 22 Jul 2020 15:36:47 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s4sm1634667wre.53.2020.07.22.15.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 15:36:46 -0700 (PDT)
Subject: Re: [RFC PATCH] net: dsa: qca8k: Add 802.1q VLAN support
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200721171624.GK23489@earth.li>
 <1bf941f5-fdb3-3d9b-627a-a0464787b0ab@gmail.com>
 <20200722193850.GM23489@earth.li>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <77c136d0-c183-ebb5-5954-647e08c8ec18@gmail.com>
Date:   Wed, 22 Jul 2020 15:36:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722193850.GM23489@earth.li>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 12:38 PM, Jonathan McDowell wrote:
> On Tue, Jul 21, 2020 at 10:26:07AM -0700, Florian Fainelli wrote:
>> On 7/21/20 10:16 AM, Jonathan McDowell wrote:
>>> This adds full 802.1q VLAN support to the qca8k, allowing the use of
>>> vlan_filtering and more complicated bridging setups than allowed by
>>> basic port VLAN support.
>>>
>>> Tested with a number of untagged ports with separate VLANs and then a
>>> trunk port with all the VLANs tagged on it.
>>
>> This looks good to me at first glance, at least not seeing obvious
>> issue, however below are a few questions:
> 
> Thanks for the comments.
> 
>> - vid == 0 appears to be unsupported according to your port_vlan_prepare
>> callback, is this really the case, or is it more a case of VID 0 should
>> be pvid untagged, which is what dsa_slave_vlan_rx_add_vid() would
>> attempt to program
> 
> I don't quite follow you here. VID 0 doesn't appear to be supported by
> the hardware (and several other DSA drivers don't seem to like it
> either), hence the check; I'm not clear if there's something alternate I
> should be doing in that case instead?

Is it really that the hardware does not support it, or is it that it was
not tried or poorly handled before? If the switch supports programming
the VID 0 entry as PVID egress untagged, which is what
dsa_slave_vlan_rx_add_vid() requests, then this is great, because you
have almost nothing to do.

If not, what you are doing is definitively okay, because you have a
port_bridge_join that ensures that the port matrix gets configured
correctly for bridging, if that was not supported we would be in trouble.

> 
>> - since we have a qca8k_port_bridge_join() callback which programs the
>> port lookup control register, putting all ports by default in VID==1
>> does not break per-port isolation between non-bridged and bridged ports,
>> right?
> 
> VLAN_MODE_NONE (set when we don't have VLAN filtering enabled)
> configures us for port filtering, ignoring the VLAN info, so I think
> we're good here.

OK, good, so just to be sure, there is no cross talk between non-bridged
ports and bridged ports even when VLAN filtering is not enabled on the
bridge, right?
-- 
Florian
