Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8B54F59E8
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 11:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiDFJas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 05:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457059AbiDFJTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 05:19:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72D6B450323
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 18:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649210218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=99Z2Rijt/VE4EbyknhjqjEZxvGPAdDFOgiKQjfGOIEU=;
        b=iUNLwUk1H4Lo/oseEynG/SGJrlPguCMKzw+RENJivei2aMTqscs65uVt0JNuZGotmsliCu
        18EVeI9AXKq+ryokcpLLxgeS9zmZbI0AEBVVZGSpflqz9j+AZZ2+AiBaTA9rKIJKB2Dwme
        pHcBCu3h9zqBDJLcBgmDj4yqf5hfsw0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-fu9oFyCBNW6UksUtDfip1A-1; Tue, 05 Apr 2022 21:56:57 -0400
X-MC-Unique: fu9oFyCBNW6UksUtDfip1A-1
Received: by mail-pg1-f199.google.com with SMTP id p4-20020a631e44000000b00399598a48c5so604572pgm.1
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 18:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=99Z2Rijt/VE4EbyknhjqjEZxvGPAdDFOgiKQjfGOIEU=;
        b=O5b2FcsGHe9+7NMxRbElgPjyEE76cvG1Q1xa7qgfY3CmXnNmn30wb5th63KnD/aFbD
         KKLcFsbtFJHSWI9xnpCWMDwErdNfKi3dlA8EIH+2duSpGIKGT92Mza9s0C31Xmi/tkyz
         UN21ibN0AtrwDFi6dBQN/NUG6IljmmkfOwQ7YPxGv1nJfymom0Lgt8ZkVcHMd5eJX1vZ
         EU99+Ed60Sw7YDoCIMAiikTCdP28tNcqHa849OkerU4tkGC9uOEvAVlAmz6eYoYq7stJ
         9kSSyBNpr9QGPPnSAW34+o/y9GjRP36P0Trt2KGrXLPbeRjuH5F5/YPPJGIG5XjmEnyU
         HqXw==
X-Gm-Message-State: AOAM532AoA6ph45sUnxmlGB1e/SCbvniHfVtLqzKsaIBaykywhitQKl8
        ww7XPeptqvvFAAHXDTyZPy2FFJ7FGtoK4apOyXUwlRLrE7W/wcS9a0vFQUSn3Qv2D0LEE+i6v7/
        ioFLMN5NBzKqxQABs
X-Received: by 2002:a17:90b:3886:b0:1c7:c935:4447 with SMTP id mu6-20020a17090b388600b001c7c9354447mr7412664pjb.196.1649210216660;
        Tue, 05 Apr 2022 18:56:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyj+7ANZxM8sUwq4Uo7Vdcrs9toKr0kHrL0LeoNsUciJBkQwj6kWHwZWXw0V5aCUv1aSW2ctw==
X-Received: by 2002:a17:90b:3886:b0:1c7:c935:4447 with SMTP id mu6-20020a17090b388600b001c7c9354447mr7412655pjb.196.1649210216379;
        Tue, 05 Apr 2022 18:56:56 -0700 (PDT)
Received: from fedora19.localdomain (2403-5804-6c4-aa-7079-8927-5a0f-bb55.ip6.aussiebb.net. [2403:5804:6c4:aa:7079:8927:5a0f:bb55])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm14511359pge.23.2022.04.05.18.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 18:56:55 -0700 (PDT)
Date:   Wed, 6 Apr 2022 11:56:51 +1000
From:   Ian Wienand <iwienand@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v2] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <YkzzYxn0/04JT6Yv@fedora19.localdomain>
References: <20220405001500.1485242-1-iwienand@redhat.com>
 <20220405124103.1f25e5b5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405124103.1f25e5b5@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for review

On Tue, Apr 05, 2022 at 12:41:03PM -0700, Jakub Kicinski wrote:
> Can you spell out how netfront gets a different type to virtio?
> I see alloc_etherdev_mq() in both cases.

Yeah I've been doing further testing to narrow this down, and I think
I've been confused by the renaming happening during the initrd steps.

It seems that renamed devices (no matter what the driver) will have
their name_assign_type set to NET_NAME_USER; which [1] gives away as
coming from the rtnl_newlink path.  virtio devices were renamed in
init phase in my testing environment, which is why
/sys/class/net/<iface>/net_name_type works for them by the time
interactive login starts -- not because they explicitly flag
themselves.  Sorry for not recognising that earlier.

> This worries me. Why is UNKNOWN and ENUM treated differently?
> Can you point me to the code which pays attention to the assign type?

Yeah, I'll have to retract that claim; it remains unclear to me why
CentOS 8-stream does not rename netfront devices (systemd 239) and
CentOS 9-stream does (systemd 249).

systemd only seems to use NET_NAME_ENUM in an informational way to
print a warning when you're using a .link file to set network info for
a device that might change names [2].

Perhaps this still has some utility in making that warning more
useful?

[1] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/ip/iplink.c#n65
[2] https://github.com/systemd/systemd/blob/main/src/udev/net/link-config.c#L446

