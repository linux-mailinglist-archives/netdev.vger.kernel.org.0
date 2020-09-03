Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA2625C131
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgICMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 08:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbgICMky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 08:40:54 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978A6C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 05:40:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k15so3030739wrn.10
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 05:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hBMfuDIAoT4SFwZ/3u104/lWEd/i6lIYF1PY5oM5pI0=;
        b=TcBFkEytJScweYUxW7dsjokpcc4dmGJTwVS80o7KJv6ybvjVYmpNSbnBfo1rYlkv1p
         8A4p9XEfzZraCb80CH2BOACdX5cweDb+xG4uwrw1AnVl5WgAJtuFeWmg7b5mfqvEq/EE
         yRmz5CMFI+4+8U8vysnwQ8MxV0vI0it6EQmqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBMfuDIAoT4SFwZ/3u104/lWEd/i6lIYF1PY5oM5pI0=;
        b=O1BUhzcwSDuCVvNtI2b+6oskIh2xC6oGbm5bVlNmmH+0NcbSIy+EVkBxDoQHybm19l
         IWzuPVwKgazxZ9E9kdIQivfyqOdKvyxCP3CE5hH/VRH8AdecQf594KoWf2Gk+V1fR605
         RZHNkRbmypseHYVeWRzMODDVRjSB0Sy5sOovphbovfZLwjKLmRZdyx+nL/NRafbvVIwz
         Fm+qoVV7ljGE4BOKuHjPatSVqjmyDPZAlysxn5eBm9B+r8XAGOKrBTTFQa707mILG2p+
         Yk4UXsOWjqp2fDGxyMFxKUu0HVaRjQumZuoZL8NfwqjAXS5dgpUExuOMFsB3reqwfJM3
         Evqw==
X-Gm-Message-State: AOAM532Y6AgOgY3u49qKvb30MeVMqyAj/YULoLiZ3aYekgLMEmuBWL+x
        987WTS8v1FkFpsNgbExOMtAhXw==
X-Google-Smtp-Source: ABdhPJyV878M9c5gTjfb9X56AXRamum95oJL6lvKmmNdxfz85kj+eiMmWlXgJ9A8vOQhbT0sWY+8Mw==
X-Received: by 2002:adf:b19c:: with SMTP id q28mr2444413wra.392.1599136852055;
        Thu, 03 Sep 2020 05:40:52 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o124sm4080466wmb.2.2020.09.03.05.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 05:40:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 04/15] net: bridge: mcast: add support for
 group-and-source specific queries
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, Dan Carpenter <error27@gmail.com>,
        kbuild-all@lists.01.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
References: <20200903121832.GD8299@kadam>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e44e5447-6420-68ba-3f45-bee090382660@cumulusnetworks.com>
Date:   Thu, 3 Sep 2020 15:40:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903121832.GD8299@kadam>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2020 15:18, Dan Carpenter wrote:
> Hi Nikolay,
> 
> url:    https://github.com/0day-ci/linux/commits/Nikolay-Aleksandrov/net-bridge-mcast-initial-IGMPv3-support-part-1/20200902-193339
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dc1a9bf2c8169d9f607502162af1858a73a18cb8
> config: i386-randconfig-m021-20200902 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> New smatch warnings:
> net/bridge/br_multicast.c:359 br_ip4_multicast_alloc_query() error: use kfree_skb() here instead of kfree(skb)
> 
> Old smatch warnings:
> net/bridge/br_multicast.c:711 br_multicast_add_group() error: potential null dereference 'mp'.  (br_multicast_new_group returns null)
> 

Thanks Dan!
I also caught that while working on v3 and the IPv6 part. :) 
Since it's in code that shouldn't be ever reached it wasn't tested.
Anyway in v3 it will be fixed.

