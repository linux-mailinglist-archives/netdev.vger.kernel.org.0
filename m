Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF5D6B72C6
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjCMJiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCMJiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8FD2594F
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678700117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AQpW0MtAAGC9H850DvbSl98IgEUwIqqbc/Y7v5HGv34=;
        b=JDBz+kIu25R0/tG8uc2n+Yww1v8DzxQDBS/Fyf5lc1ZenUcefzWBVUOCPEU2VRKLezVubD
        CHULO+zuch6GW+9/dB86UGG7HaBuksP+b3876CU/npdmSgUYI+g9u/ck03NNPR5z2ev/By
        3dxDhIACHpNDsv68QRarCaKqXu0SyjY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-HPGo4v04PMq6CnvHb3Z9UQ-1; Mon, 13 Mar 2023 05:35:16 -0400
X-MC-Unique: HPGo4v04PMq6CnvHb3Z9UQ-1
Received: by mail-pg1-f200.google.com with SMTP id t12-20020a65608c000000b005091ec4f2d4so779761pgu.20
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 02:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678700114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQpW0MtAAGC9H850DvbSl98IgEUwIqqbc/Y7v5HGv34=;
        b=cCSvxxaIBMVRCBjSFxib9zKklGsgPN0GtSpSH4C5p8QUbdl6MlJJR1SUP19lC2zF+i
         3yaRs+8NMcFW5fCIMXRvZkUJ6e3LDOB0IjSyhgKlKHwmZZooPYQ/oTfohRGnn8ux0kk3
         vxdTlgcUunUI+k3YPd2Moq7YjYmgZ28E8Oh/X/0az8vbdUB6IX7lwCNxMZl4vRwmD4EG
         DHfAg/sizRYdCn4B77EgWWfuLWXaVRnUuQwkiwPCXYCPcHCktCAPH+GShex91Cj+Co1c
         Fq9bobYA/P6CxAP9FanZZM8BQJ7AYigoNx6j6bbc7Owe/tLzRvlgmXL5UrNGsOj9nxCM
         sFFQ==
X-Gm-Message-State: AO0yUKVWMdne7AvxRqm1nLES9FrSGaWad9q0VJvnq0rsY9wqq6e6lqVZ
        CEkifyakbN9gLV3bo1zlJDcwZ6+yEdFIwZ6N5fV3pFjCpkh0s7Tm24/qDqGahRlRWKMm/9aqhYp
        cXbJAfM3LkfHdRShL
X-Received: by 2002:a17:902:c10c:b0:19a:bbd0:c5ca with SMTP id 12-20020a170902c10c00b0019abbd0c5camr30025410pli.48.1678700114257;
        Mon, 13 Mar 2023 02:35:14 -0700 (PDT)
X-Google-Smtp-Source: AK7set8qak99w/AMcIHIkbXFQmu0oB5IulOHjMgE3Cr+/Edugbjr1WBiM99TptRhutLefIoxxEt3Fw==
X-Received: by 2002:a17:902:c10c:b0:19a:bbd0:c5ca with SMTP id 12-20020a170902c10c00b0019abbd0c5camr30025390pli.48.1678700113905;
        Mon, 13 Mar 2023 02:35:13 -0700 (PDT)
Received: from kernel-devel ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id w1-20020a170902a70100b0019aeddce6casm4269374plq.205.2023.03.13.02.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 02:35:13 -0700 (PDT)
Date:   Mon, 13 Mar 2023 18:35:08 +0900
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
Subject: Re: [PATCH net] bonding: Fix warning in default_device_exit_batch()
Message-ID: <ZA7uTL2/IkBEIRD7@kernel-devel>
References: <20230312152158.995043-1-syoshida@redhat.com>
 <d7a740f1-99e9-6947-06ef-3139198730f7@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a740f1-99e9-6947-06ef-3139198730f7@blackwall.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On Sun, Mar 12, 2023 at 10:58:18PM +0200, Nikolay Aleksandrov wrote:
> On 12/03/2023 17:21, Shigeru Yoshida wrote:
> > syzbot reported warning in default_device_exit_batch() like below [1]:
> > 
> > WARNING: CPU: 1 PID: 56 at net/core/dev.c:10867 unregister_netdevice_many_notify+0x14cf/0x19f0 net/core/dev.c:10867
> > ...
> > Call Trace:
> >  <TASK>
> >  unregister_netdevice_many net/core/dev.c:10897 [inline]
> >  default_device_exit_batch+0x451/0x5b0 net/core/dev.c:11350
> >  ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
> >  cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
> >  process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
> >  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
> >  kthread+0x2e8/0x3a0 kernel/kthread.c:376
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> >  </TASK>
> > 
> > For bond devices which also has a master device, IFF_SLAVE flag is
> > cleared at err_undo_flags label in bond_enslave() if it is not
> > ARPHRD_ETHER type.  In this case, __bond_release_one() is not called
> > when bond_netdev_event() received NETDEV_UNREGISTER event.  This
> > causes the above warning.
> > 
> > This patch fixes this issue by setting IFF_SLAVE flag at
> > err_undo_flags label in bond_enslave() if the bond device has a master
> > device.
> > 
> 
> The proper way is to check if the bond device had the IFF_SLAVE flag before the
> ether_setup() call which clears it, and restore it after.
> 
> > Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
> > Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> > Link: https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef [1]
> > Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
> > Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> > ---
> >  drivers/net/bonding/bond_main.c | 2 ++
> >  include/net/bonding.h           | 5 +++++
> >  2 files changed, 7 insertions(+)
> > 
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index 00646aa315c3..1a8b59e1468d 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -2291,6 +2291,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> >  			dev_close(bond_dev);
> >  			ether_setup(bond_dev);
> >  			bond_dev->flags |= IFF_MASTER;
> > +			if (bond_has_master(bond))
> > +				bond_dev->flags |= IFF_SLAVE;
> >  			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
> >  		}
> >  	}
> > diff --git a/include/net/bonding.h b/include/net/bonding.h
> > index ea36ab7f9e72..ed0b49501fad 100644
> > --- a/include/net/bonding.h
> > +++ b/include/net/bonding.h
> > @@ -57,6 +57,11 @@
> >  
> >  #define bond_has_slaves(bond) !list_empty(bond_slave_list(bond))
> >  
> > +/* master list primitives */
> > +#define bond_master_list(bond) (&(bond)->dev->adj_list.upper)
> > +
> > +#define bond_has_master(bond) !list_empty(bond_master_list(bond))
> > +
> 
> This is not the proper way to check for a master device.
> 
> >  /* IMPORTANT: bond_first/last_slave can return NULL in case of an empty list */
> >  #define bond_first_slave(bond) \
> >  	(bond_has_slaves(bond) ? \
> 
> The device flags are wrong because of ether_setup() which clears IFF_SLAVE, we should
> just check if it was present before and restore it after the ether_setup() call.

Thank you so much for your comment!  I understand your point, and
agree that your approach must resolve the issue.

BTW, do you mean there is a case where a device has IFF_SLAVE flag but
the upper list is empty?  I thought a device with IFF_SLAVE flag has a
master device in the upper list (that is why I took the above way.)

Thanks,
Shigeru

> 
> I'll send a fix tomorrow after testing it.
> 
> Thanks,
>  Nik
> 

