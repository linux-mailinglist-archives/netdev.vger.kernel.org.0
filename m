Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378176B6B9C
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 21:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjCLU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 16:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjCLU6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 16:58:23 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B7D15C80
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 13:58:20 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g10so12171005eda.1
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 13:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678654700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c0hrdGshSEKU/aDGpMVr9ifjI9zSeyi2imIJNOgONEw=;
        b=gVKqQlRhKYq4IDY4I8bp+kvtDgtpmgMQv7yLR34fYGkp70h8Xw2XtqM6s9oFldkY4A
         iAnoBMQ2lI3mXaGRdHKJeu33VetbNJLUV/7UbP35ifxSzLt9R/iJnfIcbbOc5dlGH/7x
         rkBmQtZi0/w7Mg+TBq2fXBq+lrSjP5LsfEx8wEPTOb5aAUXppcU2Kxs6pCXl12m/u2zJ
         QZOFaDaBPvegIVCoHgKnatAcwGTpzUfdEsoWOX1Wfmqb7EYCmG0AUvPQSR9sb2ICacjD
         sIF60Tl1LhesG7t4/A34jpHQABM2E09guOfAOrKK8ZGk9PvYRU62R6sN9jSWd1rl6/4q
         90Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678654700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0hrdGshSEKU/aDGpMVr9ifjI9zSeyi2imIJNOgONEw=;
        b=4UlSieeclK8IS/D7xgGXKuw/yqSQthHHOEbiHl2j/xYt7LkF0Nhg4p16aySgy4QeqA
         Kd2s8Cq/7kqCjcyTIktaltChH3EQIl9guO9DYJ/RfILpwOQbvNHLWaXtH9F+Sa0I8EQp
         HhpRQxhpu9XtIXJLQ6Bv0VFba7FqHn4/S5k8gKyrd0si4g1KmAPvzM9jMOUD+hmDyidm
         w0UgA3YmjaP8WZN/aAoXjivMUOVke+JQfXaFjyMz8+WX+FHj+v8wHc10ON8W78bIcVpg
         d+RoCgY3O4TUhgLgob/clL17aomOPzutCqn8AkjwWLx/Ik/YkWn30RB8lfSZN5P/8KrG
         +/sw==
X-Gm-Message-State: AO0yUKXvbJnfIdi7p8ajlaDSf1UPeho7DV/IHefjXZFAyPTJzwe7Ogo5
        9HAV9XUQH0wrygmHHnlVHgIFew==
X-Google-Smtp-Source: AK7set8eFHxtqPSMhjQCnJNzoGMeukA2iqoVkwxekrwvDCX4ZkYzoC4SmNFoW97oexxty8ci+bgYpw==
X-Received: by 2002:a17:907:110b:b0:921:d539:1a3a with SMTP id qu11-20020a170907110b00b00921d5391a3amr4991203ejb.58.1678654700104;
        Sun, 12 Mar 2023 13:58:20 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id hv12-20020a17090760cc00b008b17cc28d3dsm2591795ejc.20.2023.03.12.13.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 13:58:19 -0700 (PDT)
Message-ID: <d7a740f1-99e9-6947-06ef-3139198730f7@blackwall.org>
Date:   Sun, 12 Mar 2023 22:58:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] bonding: Fix warning in default_device_exit_batch()
Content-Language: en-US
To:     Shigeru Yoshida <syoshida@redhat.com>, j.vosburgh@gmail.com,
        andy@greyhouse.net
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230312152158.995043-1-syoshida@redhat.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230312152158.995043-1-syoshida@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2023 17:21, Shigeru Yoshida wrote:
> syzbot reported warning in default_device_exit_batch() like below [1]:
> 
> WARNING: CPU: 1 PID: 56 at net/core/dev.c:10867 unregister_netdevice_many_notify+0x14cf/0x19f0 net/core/dev.c:10867
> ...
> Call Trace:
>  <TASK>
>  unregister_netdevice_many net/core/dev.c:10897 [inline]
>  default_device_exit_batch+0x451/0x5b0 net/core/dev.c:11350
>  ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
>  cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
>  process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> 
> For bond devices which also has a master device, IFF_SLAVE flag is
> cleared at err_undo_flags label in bond_enslave() if it is not
> ARPHRD_ETHER type.  In this case, __bond_release_one() is not called
> when bond_netdev_event() received NETDEV_UNREGISTER event.  This
> causes the above warning.
> 
> This patch fixes this issue by setting IFF_SLAVE flag at
> err_undo_flags label in bond_enslave() if the bond device has a master
> device.
> 

The proper way is to check if the bond device had the IFF_SLAVE flag before the
ether_setup() call which clears it, and restore it after.

> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Link: https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef [1]
> Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c | 2 ++
>  include/net/bonding.h           | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 00646aa315c3..1a8b59e1468d 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2291,6 +2291,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  			dev_close(bond_dev);
>  			ether_setup(bond_dev);
>  			bond_dev->flags |= IFF_MASTER;
> +			if (bond_has_master(bond))
> +				bond_dev->flags |= IFF_SLAVE;
>  			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>  		}
>  	}
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index ea36ab7f9e72..ed0b49501fad 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -57,6 +57,11 @@
>  
>  #define bond_has_slaves(bond) !list_empty(bond_slave_list(bond))
>  
> +/* master list primitives */
> +#define bond_master_list(bond) (&(bond)->dev->adj_list.upper)
> +
> +#define bond_has_master(bond) !list_empty(bond_master_list(bond))
> +

This is not the proper way to check for a master device.

>  /* IMPORTANT: bond_first/last_slave can return NULL in case of an empty list */
>  #define bond_first_slave(bond) \
>  	(bond_has_slaves(bond) ? \

The device flags are wrong because of ether_setup() which clears IFF_SLAVE, we should
just check if it was present before and restore it after the ether_setup() call.

I'll send a fix tomorrow after testing it.

Thanks,
 Nik

