Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E675822B1
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiG0JFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiG0JFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:05:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC8CE4331A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658912746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VD2gv6Dn4KXXGjihjcL4YQf94dggu8ChImRGCTJ+EA=;
        b=YoOvJzLR/0Waorys1iIosAyXhemCctmaE1Qus0t5KB1EogD5tmICTPj700DdxZsUP/Ch8/
        ENfrAlfnsNXvgGVMVA5GzY99vVCd+D+EvkU0hvsWNCZT6AS/PHnG+G5LgR1Z6dxBhcD58U
        YaRbMKfu+VgqSxddwZ3QNGlK3lx16uk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-P2V3sTHaO8KFaDbJTMN1TA-1; Wed, 27 Jul 2022 05:05:44 -0400
X-MC-Unique: P2V3sTHaO8KFaDbJTMN1TA-1
Received: by mail-wm1-f71.google.com with SMTP id 189-20020a1c02c6000000b003a2d01897e4so8791781wmc.9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=/VD2gv6Dn4KXXGjihjcL4YQf94dggu8ChImRGCTJ+EA=;
        b=n4kRNWKX4AZbi1N7tTBt1+1U6r5PxxpFPlJ8/G6m2ADkOXhBEWBHZ9yBFxqKlGAJg6
         3pzGLT9+tvOoFleTdlSgYGcKCTBUBRcj/ccMSr9CM6D2FgKvAeelIsNSVeOBqLdIzGTU
         p2jPRJhHrF8nwtlZIvJXyt66Lj7HmB7fctSWVHvEiTHmT+r7bNxtMevYdwYWBB6HJbZN
         bsIAU0gae2Q0W7bSSzBPVJoZCAdUzvamLf5/mOorfyGHvY5+BvUupz6LwGTHjofq/j74
         /8OT4RLc4BS94zBwOG1JNDYF5Ic1n0cyI+zvs53e6ZPeuuVhCbiFk0ITqrEQ4MqUSmL+
         v0hQ==
X-Gm-Message-State: AJIora+OmeEjutSj4OPCJ3WNSzS4FAHJ+lDq1lZYRYhEVjeWTXcAlgi0
        yRob0Mj1Nr5s59amwtAX67ft8xF6yotzgi4YBtrcgN/udkHpCOMPCBgt5Wvap+6KrlKIRGTSfM9
        M4v+Ly+32GupCyAuN
X-Received: by 2002:a05:6000:144d:b0:21d:8109:701d with SMTP id v13-20020a056000144d00b0021d8109701dmr12896130wrx.443.1658912743285;
        Wed, 27 Jul 2022 02:05:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vFKCXGo7+tmPkeoN5oTHI8IVd+EWSmGixxPDJeK0M/yGU8GSgKKeLGqKrvSu3ZcnK2nIFrYA==
X-Received: by 2002:a05:6000:144d:b0:21d:8109:701d with SMTP id v13-20020a056000144d00b0021d8109701dmr12896092wrx.443.1658912742634;
        Wed, 27 Jul 2022 02:05:42 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7424:0:3d16:86dc:de54:5671])
        by smtp.gmail.com with ESMTPSA id b12-20020a5d550c000000b0021e4fd8e10bsm9990696wrv.11.2022.07.27.02.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 02:05:42 -0700 (PDT)
Date:   Wed, 27 Jul 2022 05:05:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220727050342-mutt-send-email-mst@kernel.org>
References: <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <4925d1db-51d1-148a-72e0-2347b20e82f4@intel.com>
 <CACGkMEsXLhhLhyfPwc=Sif=iy1wE3zm6sKWQxvO3cyuM547+zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsXLhhLhyfPwc=Sif=iy1wE3zm6sKWQxvO3cyuM547+zw@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 02:56:20PM +0800, Jason Wang wrote:
> On Wed, Jul 27, 2022 at 2:26 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >
> >
> >
> > On 7/27/2022 2:01 PM, Michael S. Tsirkin wrote:
> > > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > >>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>> Sent: Tuesday, July 26, 2022 10:53 PM
> > >>>
> > >>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > >>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>>>> Sent: Tuesday, July 26, 2022 10:15 PM
> > >>>>>
> > >>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > >>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > >>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > >>>>>>>> When the user space which invokes netlink commands, detects that
> > >>>>> _MQ
> > >>>>>>> is not supported, hence it takes max_queue_pair = 1 by itself.
> > >>>>>>> I think the kernel module have all necessary information and it is
> > >>>>>>> the only one which have precise information of a device, so it
> > >>>>>>> should answer precisely than let the user space guess. The kernel
> > >>>>>>> module should be reliable than stay silent, leave the question to
> > >>>>>>> the user space
> > >>>>> tool.
> > >>>>>> Kernel is reliable. It doesn’t expose a config space field if the
> > >>>>>> field doesn’t
> > >>>>> exist regardless of field should have default or no default.
> > >>>>> so when you know it is one queue pair, you should answer one, not try
> > >>>>> to guess.
> > >>>>>> User space should not guess either. User space gets to see if _MQ
> > >>>>> present/not present. If _MQ present than get reliable data from kernel.
> > >>>>>> If _MQ not present, it means this device has one VQ pair.
> > >>>>> it is still a guess, right? And all user space tools implemented this
> > >>>>> feature need to guess
> > >>>> No. it is not a guess.
> > >>>> It is explicitly checking the _MQ feature and deriving the value.
> > >>>> The code you proposed will be present in the user space.
> > >>>> It will be uniform for _MQ and 10 other features that are present now and
> > >>> in the future.
> > >>> MQ and other features like RSS are different. If there is no _RSS_XX, there
> > >>> are no attributes like max_rss_key_size, and there is not a default value.
> > >>> But for MQ, we know it has to be 1 wihtout _MQ.
> > >> "we" = user space.
> > >> To keep the consistency among all the config space fields.
> > > Actually I looked and the code some more and I'm puzzled:
> > I can submit a fix in my next version patch for these issue.
> > >
> > >
> > >       struct virtio_net_config config = {};
> > >       u64 features;
> > >       u16 val_u16;
> > >
> > >       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > >
> > >       if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> > >                   config.mac))
> > >               return -EMSGSIZE;
> > >
> > >
> > > Mac returned even without VIRTIO_NET_F_MAC
> > if no VIRTIO_NET_F_MAC, we should not nla_put
> > VDPA_ATTR_DEV_NET_CFG_MAC_ADDR, the spec says the driver should generate
> > a random mac.
> 
> It's probably too late to do this.

Not sure why.

> Most of the parents have this
> feature support, so probably not a real issue.

I guess not reporting MTU is not worse than failing initialization.

> > >
> > >
> > >       val_u16 = le16_to_cpu(config.status);
> > >       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > >               return -EMSGSIZE;
> > >
> > >
> > > status returned even without VIRTIO_NET_F_STATUS
> > if no VIRTIO_NET_F_STATUS, we should not nla_put
> > VDPA_ATTR_DEV_NET_STATUS, the spec says the driver should assume the
> > link is active.
> 
> Somehow similar to F_MAC. But we can report if F_MAC is not negotiated.
> 
> 
> > >
> > >       val_u16 = le16_to_cpu(config.mtu);
> > >       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > >               return -EMSGSIZE;
> > >
> > >
> > > MTU returned even without VIRTIO_NET_F_MTU
> > same as above, the spec says config.mtu depends on VIRTIO_NET_F_MTU, so
> > without this feature bit, we should not return MTU to the userspace.
> 
> Not a big issue, we just need to make sure the parent can report a
> correct MTU here.
> 
> Thanks
> 
> >
> > Does these fix look good to you?
> >
> > And I think we may need your adjudication for the two issues:
> > (1) Shall we answer max_vq_paris = 1 when _MQ not exist, I know you have
> > agreed on this in a previous thread, its nice to clarify
> > (2) I think we should not re-use the netlink attr to report feature bits
> > of both the management device and the vDPA device,
> > this can lead to a new race condition, there are no locks(especially
> > distributed locks for kernel_space and user_space) in the nla_put
> > functions. Re-using the attr is some kind of breaking the netlink
> > lockless design.
> >
> > Thanks,
> > Zhu Lingshan
> > >
> > >
> > > What's going on here?
> > >
> > >
> >

