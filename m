Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BE56463DC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 23:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLGWGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 17:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiLGWFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 17:05:32 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABABB49B56
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 14:05:08 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-yD5IPmD2O_KCeTqYwEMREw-1; Wed, 07 Dec 2022 17:04:51 -0500
X-MC-Unique: yD5IPmD2O_KCeTqYwEMREw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87D0A29AA2ED;
        Wed,  7 Dec 2022 22:04:50 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACF0439D7C;
        Wed,  7 Dec 2022 22:04:48 +0000 (UTC)
Date:   Wed, 7 Dec 2022 23:03:45 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y5ENwSv4Q+A4O6lG@hog>
References: <20221207101017.533-1-ehakim@nvidia.com>
 <Y5C1Hifsg3/lJJ8N@hog>
 <IA1PR12MB635345D00CDE8F81721EEC89AB1A9@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <IA1PR12MB635345D00CDE8F81721EEC89AB1A9@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-12-07, 15:52:15 +0000, Emeel Hakim wrote:
> 
> 
> > -----Original Message-----
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > Sent: Wednesday, 7 December 2022 17:46
> > To: Emeel Hakim <ehakim@nvidia.com>
> > Cc: linux-kernel@vger.kernel.org; Raed Salem <raeds@nvidia.com>;
> > davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; netdev@vger.kernel.org; atenart@kernel.org; jiri@resnulli.us
> > Subject: Re: [PATCH net-next v3 1/2] macsec: add support for
> > IFLA_MACSEC_OFFLOAD in macsec_changelink
> > 
> > External email: Use caution opening links or attachments
> > 
> > 
> > 2022-12-07, 12:10:16 +0200, ehakim@nvidia.com wrote:
> > [...]
> > > +static int macsec_changelink_upd_offload(struct net_device *dev,
> > > +struct nlattr *data[]) {
> > > +     enum macsec_offload offload;
> > > +     struct macsec_dev *macsec;
> > > +
> > > +     macsec = macsec_priv(dev);
> > > +     offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
> > 
> > All those checks are also present in macsec_upd_offload, why not move them into
> > macsec_update_offload as well? (and then you don't really need
> > macsec_changelink_upd_offload anymore)
> > 
> 
> Right, I thought about it , but I realized that those checks are done before holding the lock in macsec_upd_offload
> and if I move them to macsec_update_offload I will hold the lock for a longer time , I want to minimize the time
> of holding the lock.

Those couple of tests are probably lost in the noise compared to what
mdo_add_secy ends up doing. It also looks like a race condition
between the "macsec->offload == offload" test in macsec_upd_offload
(outside rtnl_lock) and updating macsec->offload via macsec_changelink
is possible. (Currently we can only change it with macsec_upd_offload
(called under genl_lock) so there's no issue until we add this patch)


> > > +     if (macsec->offload == offload)
> > > +             return 0;
> > > +
> > > +     /* Check if the offloading mode is supported by the underlying layers */
> > > +     if (offload != MACSEC_OFFLOAD_OFF &&
> > > +         !macsec_check_offload(offload, macsec))
> > > +             return -EOPNOTSUPP;
> > > +
> > > +     /* Check if the net device is busy. */
> > > +     if (netif_running(dev))
> > > +             return -EBUSY;
> > > +
> > > +     return macsec_update_offload(macsec, offload); }
> > > +
> > 
> > --
> > Sabrina
> 

-- 
Sabrina

