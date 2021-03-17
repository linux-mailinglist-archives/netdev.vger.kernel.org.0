Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC633F2B1
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhCQOdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhCQOc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:32:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C266C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:32:58 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y6so2557279eds.1
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VULqenmn7b6ivm5aBb1HPTvJLbDLc3V/xV5o8NuumQk=;
        b=j/uLvhwQjj4R13gkxa832B8PXE/4jSCj+Si42lI+k9uUMMtkK8tlBNp5LujaOMiuwe
         J/fnNVPqIfvuQn7/UTzyOYdpt4GaWl8xkEtqsaZ02kfPq780H69YeaqP7kuYj/JTxE3u
         PMz42cu0yCnKNQeR/z5MFLNc7yyzCEGZL1TR27YEuh0jg4lq1Xzje2TiJG94RwKp7Y+n
         eNSFithnla7kQaa5j8JO7IlBBDPV5hKY+L7BYX7IGANsu5k8miziRwaCk61L5Ao//r3I
         KOjePNT3jVT11zrsatoRbf0BzdZNyifIeg4YkOXEt/StITKYd+VxJ/FdhHc5hIavUhTZ
         VsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VULqenmn7b6ivm5aBb1HPTvJLbDLc3V/xV5o8NuumQk=;
        b=Wj3RiZuz8K0mc4GYdsIb+EPoy/OwJSkmQCJwW7DDeBxX55f0jtF1ZM5TTOODZdTlcU
         04zVDzA9NwPwuiYXzZI4Zo3L/+87647G3duJFeQl+h6/8KyMs1vaTm6bpfJt6cLVQzQ9
         Fi4x/Jkux/6ocBp2j++6qjjqpao1lPLR9MnS/BlC//2QuVxz/uuxxlgvEzi6i814iUqz
         78FePXgYmWfCTqgKuzkaA1EnfrYXzpi3p7MGLRt8No2jRaSRq5UUyr/1wktmSSmZV0NQ
         ahi2OPYNQz9Dr+0dfNI1s8MxV3HkErWivl+XRD2ecZm42W3ttKaG+Xowlbtdi93M5O4/
         HhaA==
X-Gm-Message-State: AOAM533YijR8DOego9WYC3zXS8wJvL7NMqJxiY2p1UbC25wdkezJgmaw
        5qioMwBcMk65IBwoBmgMrK8=
X-Google-Smtp-Source: ABdhPJz+vi4ufOKUjIaWakE6kAPdzvBuy7YCKR+gpudMQuVpxGOwEZm5mbu8rgyWLRR121Y3JZQkgA==
X-Received: by 2002:aa7:ca04:: with SMTP id y4mr42075750eds.339.1615991576620;
        Wed, 17 Mar 2021 07:32:56 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id cw14sm13236325edb.8.2021.03.17.07.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:32:56 -0700 (PDT)
Date:   Wed, 17 Mar 2021 16:32:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        lkp@intel.com
Subject: Re: [PATCH net-next v17 4/4] net: dsa: mv88e6xxx: implement
 .port_set_policy for Amethyst
Message-ID: <20210317143255.7vvan6kaclx7w4ys@skbuf>
References: <20210317134643.24463-1-kabel@kernel.org>
 <20210317134643.24463-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317134643.24463-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 02:46:43PM +0100, Marek Behún wrote:
> The 16-bit Port Policy CTL register from older chips is on 6393x changed
> to Port Policy MGMT CTL, which can access more data, but indirectly and
> via 8-bit registers.
> 
> The original 16-bit value is divided into first two 8-bit register in
> the Port Policy MGMT CTL.
> 
> We can therefore use the previous code to compute the mask and shift,
> and then
> - if 0 <= shift < 8, we access register 0 in Port Policy MGMT CTL
> - if 8 <= shift < 16, we access register 1 in Port Policy MGMT CTL
> 
> There are in fact other possible policy settings for Amethyst which
> could be added here, but this can be done in the future.

..and not using ethtool --config-nfc perhaps, but with tc clsact, flower
filters and actions.

> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
> ---

I don't have any documentation for 6393x, but the change looks simple
enough.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
