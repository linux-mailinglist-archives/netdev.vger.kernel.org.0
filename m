Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD41B1357
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgDTRl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbgDTRl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:41:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABCBC061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:41:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 188so488705wmc.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jjN4klF78TqCsstuudiTHIE+jPyDjeX0x32L+YWiINA=;
        b=memIumnBAmHJ1MrHMTO/bcnbaIaH6nTK3gk8jEqQoWLxow8YC3SXahCLRGP5UIX8T9
         6tiC8zFmq5d2uD+IG4YMCSH5/wBcXwMikppvRjOjViphFZoZF4OWYQ6bA/r/NBFGdB2y
         PsEJOptG0zW97BoV96tD8Slt8CPeNykul7xTaHtyTdT3vNv+k63qITJVJNIqO3WnNIBK
         +/a5gFgn1mSAQqjk9gginSgM7SFTdY/e7fj5QzjXb4Pf0fUYHFQjx8k8Keo9aBVZIipn
         y+U5aVIAviXIY0vsz3qBwIWk+5q77cUF6EXYw/+2QPGPq25TZVJ1pzA2pMBiBUlpzSHN
         FUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jjN4klF78TqCsstuudiTHIE+jPyDjeX0x32L+YWiINA=;
        b=qjV3J+fiNL+D0Yo892OOAl4vUr1djIkV3UoHBel+NoxXzrArXvmTyzqkEipJ1lusbi
         ArhNYXVwV/TMgm1wxlmGaYD5xcHXHPZ1iFSDjUk6nrXbgc57Xr1pkSO9tFeVS5uSPQcJ
         uHlpImwyJ5qb1bbxYDmEKC5QHf1XyAoQzG3nCkWvhe50EzQK+moPq77GUVpokNYyLrl5
         FTHSWb6PpOZI2hzyFKq2T4+fU3FxgqsorgkAIMODoI40APVMzrrnKVRYtc14t4U2Fdvp
         i9Nt1nEq332laMJQjaAU/bGVYZlKe0j+BVz49Jajqxp7LZh4dlpXFHIZA1D87M91h9Sc
         WhnA==
X-Gm-Message-State: AGi0PuYgmJ7FZtvzH9Oq1Bu0Sn1MXuJfC0L7Oa70E2tyCBq1/JS1amN+
        aeMDT+IQ4zN8UOIzcAtU3WPaUg==
X-Google-Smtp-Source: APiQypIopkck8cgFiG1J6Ej4UB9FguCCubTckqk0OwhawHyo3rPfoerNFe/fIWuDrqKVBA3B4ceKFw==
X-Received: by 2002:a7b:cb88:: with SMTP id m8mr445542wmi.103.1587404486252;
        Mon, 20 Apr 2020 10:41:26 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 33sm276340wrp.5.2020.04.20.10.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 10:41:25 -0700 (PDT)
Date:   Mon, 20 Apr 2020 19:41:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
Message-ID: <20200420174124.GS6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 07:29:15PM CEST, dsahern@gmail.com wrote:
>On 4/20/20 8:01 AM, Jiri Pirko wrote:
>> Mon, Apr 20, 2020 at 09:54:17AM CEST, maorg@mellanox.com wrote:
>>> Add new ndo to get the xmit slave of master device.
>>> User should release the slave when it's not longer needed.
>>> When slave selection method is based on hash, then the user can ask to
>>> get the xmit slave assume all the slaves can transmit by setting the
>>> LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.
>>>
>>> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>>> ---
>>> include/linux/netdevice.h |  3 +++
>>> include/net/lag.h         | 32 ++++++++++++++++++++++++++++++++
>>> 2 files changed, 35 insertions(+)
>>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index 130a668049ab..e8852f3ad0b6 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -1389,6 +1389,9 @@ struct net_device_ops {
>>> 						 struct netlink_ext_ack *extack);
>>> 	int			(*ndo_del_slave)(struct net_device *dev,
>>> 						 struct net_device *slave_dev);
>>> +	struct net_device*	(*ndo_xmit_get_slave)(struct net_device *master_dev,
>>> +						      struct sk_buff *skb,
>>> +						      u16 flags);
>> 
>> Please adjust the name to:
>> ndo_get_lag_xmit_slave
>
>I disagree. There are multiple master devices and no reason to have a
>LAG specific get_slave.

Do you have usecase for any other non-lag master type device?
Note the ndo name can change whenever needed. I think the name should
reflect the usage.
