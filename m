Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800FF5B8C23
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiINPor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiINPok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:44:40 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55476206
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:44:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id v16so35649404ejr.10
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=AJDSRBC+L/MdUTzyAnnlp8U5u/EZNEvvde+wf8FtIDQ=;
        b=S93LknfTT5ySVunekzwQ+FaOJFexYi46/ZHGTbwyiXjBbgeTc7UD4qf9LCLUnwI5C1
         hsahfsFaWd7PFdjMFP7Jah+JQoqVKtAJUr2GJLwoBP3m9y4sOrKYWBUozvprS5F2dg4O
         KzoEwEmeLUWvskNm9kxMHIM/3e5Grhdfp+LH9XBcueO9VvVuYLaBTDNkJ9SR89d7lvF8
         yD8kN0BsjGbT6Qy2vczLlDtE0auyKdwBvZEtAXRaOrCdfDEEQkRH23PkJQl5QeOuAIoZ
         gPoim6DXosNM0ciUVjiFByMkxdfd40tJ71YiDTFUFrusevlsQFhqDhMsmf+wga4Zvbvc
         kGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date;
        bh=AJDSRBC+L/MdUTzyAnnlp8U5u/EZNEvvde+wf8FtIDQ=;
        b=tri4elUAOUxcVg5y9EZaMl1xMzihliJpYfSHXajXOBvgbK7cIrjYLB03Pfp/GIjjgh
         W+hGszODU/FwWJ77E+8fbNcjxXH+lruPJbo04u8pfjNM4ZE3G2j2+opnT1W0rlodClqv
         2NuqF2VqLU6hGIZXTwJrNbsG8A508gzMNuERTFZTG9R7cKminpiN0kofyjSU+kRiYe9x
         COywNC7xzWuzPpg3w7fYPAM+GDRyUspjuUd+1JRGOP2Dc5z/kE7x9NKi63CRk5tEV52E
         Y1pXsBwiTAJqgXoWvnO3Iu8cReX7hgk5O9VcGAGke6TyPt6Q0JlnV7i5uYFQ0Em3e/id
         VDgA==
X-Gm-Message-State: ACgBeo2tZ/2Vi9upy/pijtil1JiGWufdPvbjg7Zi0j2UyN4wx51J04XO
        dqXK+yAEbLLks5ut2KB2uXX5VL1DKwTWYQ==
X-Google-Smtp-Source: AA6agR6KM36Y5l5wtK7rY7hLLffuRxUV9bNwbKpZ8NvCdsTckJb0xgGDYwxACPa4qQLONqE3iANLsA==
X-Received: by 2002:a17:907:7607:b0:770:7ec4:fb41 with SMTP id jx7-20020a170907760700b007707ec4fb41mr24499632ejc.685.1663170275328;
        Wed, 14 Sep 2022 08:44:35 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id o12-20020aa7d3cc000000b0044841a78c70sm9853310edr.93.2022.09.14.08.44.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Sep 2022 08:44:34 -0700 (PDT)
Date:   Wed, 14 Sep 2022 15:44:34 +0000
From:   Wei Yang <richard.weiyang@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Wei Yang <richard.weiyang@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [Q] packet truncated after enabling ip_forward for virtio-net in
 guest
Message-ID: <20220914154434.fng4ifuk73b5m2gt@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <CADZGycYUH=j80zmJVr7dfVtoJ+BrbAEPJE8Nvf3HR5oimJR+UQ@mail.gmail.com>
 <CACGkMEvNMDG=9tYAWDOqdYKMy-Sk3qShQX3PWGQZBcdvZ7y3Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvNMDG=9tYAWDOqdYKMy-Sk3qShQX3PWGQZBcdvZ7y3Tw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 11:46:56AM +0800, Jason Wang wrote:
>On Tue, Sep 13, 2022 at 11:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> Hi, I am running a guest with vhost-net as backend. After I enable
>> ip_forward, the packet received is truncated.
>>
>> Host runs a 5.10 kernel, while guest kernel is v5.11 which doesn't
>> include this commit:
>>
>>   virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
>>
>> After applying this commit, the issue is gone. I guess the reason is
>> this device doesn't have NETIF_F_GRO_HW set,
>
>Note that form device POV, it should be VIRTIO_NET_F_GUEST_TSOX.
>
>> so
>> virtnet_set_guest_offloads is not called.
>>
>> I am wondering why packet is truncated without this fix. I follow
>> virtnet_set_guest_offloads and just see virtio_net_handle_ctrl in qemu
>> handles VIRTIO_NET_CTRL_GUEST_OFFLOADS. Since we use a tap dev, then I
>> follow tap_fd_set_offload to ioctl(fd, TUNSETOFFLOAD, offload).
>>

Thanks Jason

So virtnet_set_guest_offloads() in guest would be handled by
virtio_net_handle_ctrl in qemu. This understanding is correct.

>> But I am lost here. tap_ioctl -> set_offload(). Since we use a normal
>> tap device instead of ipvtap/macvtap, update_features is empty. So I
>> don't get how the device's behavior is changed after set LRO.
>>
>> Do I follow the wrong path? Any suggestions on investigation?
>
>Note that if you are using tuntap, you should refert driver/net/tun.c
>instead of tap.c. Where it calls netdev_update_features() that will
>change the TX offloading.

netdev_update_features(struct net_device *dev)
	__netdev_update_features(dev);
		dev->netdev_ops->ndo_fix_features();
		dev->netdev_ops->ndo_set_features();
	netdev_features_change(dev);

If my understanding is correct, this netdev_ops is tun_netdev_ops. While this
one doesn't have ndo_set_features.

I see the log "Features changed: xxx" in dmesg, but I still don't get how the
behavior changes.

>
>Thanks
>
>>
>> I'd appreciate it if someone could give a hint :-)
>>

-- 
Wei Yang
Help you, Help me
