Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211E5264FFC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIJT6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731221AbgIJPDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 11:03:31 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B0DC061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 08:02:40 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t16so5918002ilf.13
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 08:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PL95GrN7knemSxB1i150DELB2PMwEzuHebtPayZQxPY=;
        b=MiQ8SMny35xHBK6iSisVac4406CtGwH8//a7sqaqwgK6w938YvQ030G6McvmHoY7Ky
         9B1RwYS4tVl6ltu5DUlDFh1V+HlxqZ4ckx22TKRlYzQPK4oJv56bRJmxMg/GvvDUn53S
         CPnpxFFxWhfwN/+n9eZsyzZAtaSaKFDuMZ9SZ6Kg3o4GD0aexbXY0IKWkc8m/r7S40bu
         Y20SeTzoDfwWkkbuGgus24DNWaVNGWdFOzKZLMhe5MMu2PVKBk/HmQ2vl11gYTzkO4Wy
         z7W3khK4ZnCxgiYrBXPEf45k0qYiDHwKM5KzydWcoThp0vBWQYNNm4zIsKCbRBf1YlDb
         qqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PL95GrN7knemSxB1i150DELB2PMwEzuHebtPayZQxPY=;
        b=ms32IVDN4Bp3MMweK349qtBdyTHUG9ykDJaeU2y/eK6Axev3mMuaMKHlD0cd94Xo6+
         n4zhgPGFG7ZlbSbBLXSsoZ6Sx5Y9gCPs8vDZxAMzB2wmwNZyp6F69xof7Xy65LfTPrjm
         lz1tyAOY+EkYbqR/8RSt2mBYjvxVTmr32l+jbJYkPb5IxyIvNL+hkdGmY+Ehoz1RnG+M
         h/BznYFon2KulnvrBlYhlrv9bGfqDnCvpKb29c6F8Wpo559Q5ABYqQFwYXwdZqeiLNi+
         fKV2fEQpA4ZNZ4AMvPOZmqBAEZRNP0egO8s+fc8qSGlxgj6PrFPmhn+u/QGWgC7v2VXZ
         zxqQ==
X-Gm-Message-State: AOAM533IYMEHZpXJZK/6W2i8oTVudjH8XNHgKP/B2yWV3KbLhClkVFyS
        R4APsfN7Q5nW3pwkY74m5xc=
X-Google-Smtp-Source: ABdhPJwPQumkr+lW/bEayMrO+8hsdJAdJSdWPIXWmCHJ7ZMy8W4sfA/Ta0Qq2Ma7pRQD3bBemRULnQ==
X-Received: by 2002:a92:9408:: with SMTP id c8mr7542245ili.61.1599750159368;
        Thu, 10 Sep 2020 08:02:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:5dc7:bd14:9e78:3773])
        by smtp.googlemail.com with ESMTPSA id y10sm1070293ilq.83.2020.09.10.08.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 08:02:37 -0700 (PDT)
Subject: Re: [PATCH net-next v3 6/6] devlink: Use controller while building
 phys_port_name
To:     Parav Pandit <parav@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200909045038.63181-1-parav@mellanox.com>
 <20200909045038.63181-7-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <012dea67-8ebd-ab03-a221-e303ce5b7b0f@gmail.com>
Date:   Thu, 10 Sep 2020 09:02:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200909045038.63181-7-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 10:50 PM, Parav Pandit wrote:
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev ens2f0c1pf0vf1 flavour pcivf controller 1 pfnum 0 vfnum 1 external true splittable false
>   function:
>     hw_addr 00:00:00:00:00:00
> 
> $ devlink port show pci/0000:06:00.0/2 -jp
> {
>     "port": {
>         "pci/0000:06:00.0/2": {
>             "type": "eth",
>             "netdev": "ens2f0c1pf0vf1",

That strlen is 14 chars. Any 2 ids go to a second digit and you overrrun
the IFNAMSZ which means ...

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 9cf5b118253b..91c12612f2b7 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -7793,9 +7793,23 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  		WARN_ON(1);
>  		return -EINVAL;
>  	case DEVLINK_PORT_FLAVOUR_PCI_PF:
> +		if (attrs->pci_pf.external) {
> +			n = snprintf(name, len, "c%u", attrs->pci_pf.controller);
> +			if (n >= len)
> +				return -EINVAL;

...  this function returns EINVAL which is going to be confusing to users.

> +			len -= n;
> +			name += n;
> +		}
>  		n = snprintf(name, len, "pf%u", attrs->pci_pf.pf);
>  		break;
>  	case DEVLINK_PORT_FLAVOUR_PCI_VF:
> +		if (attrs->pci_vf.external) {
> +			n = snprintf(name, len, "c%u", attrs->pci_vf.controller);
> +			if (n >= len)
> +				return -EINVAL;
> +			len -= n;
> +			name += n;
> +		}
>  		n = snprintf(name, len, "pf%uvf%u",
>  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>  		break;
> 

