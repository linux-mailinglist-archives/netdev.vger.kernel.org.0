Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC069F75B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjBVPFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjBVPFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:05:02 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A4936FFA
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:04:59 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id f1so9318440qvx.13
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uZsmkWZE08X4YfNYjfJq6XQ+MFaq3k1arzzykq7tPo=;
        b=GGljisTqRFL3m91Jw/G2JjWap2xNgSrcdu+If5pQCfEfpj3Bf4AnLep+2kaUSZ4tZK
         4umj8qJ7ICxF+B3MxCcZRZCAtquRgswOJyL5y4N8MnRCSMJDVuzOxfAad29YNjSooHqZ
         D3iHJa4cayWZGUNCdzgdWlk55XVd7ek8EJFpqeZvV4lDlS/A3m0RfBGWuihaJdL0yPiI
         40ati0Wgg6IjOHpaw3oZ2e9DQfG9eTtgjwMK2tkvu9SXujnwhA0YdrsrGcRVFBRpX5En
         G8oqhuKP1oQiv2UckiH/96USOKF9qI6dUX/LD/6P+CRDymNRL86JEnp8Fj21PKY4tcBU
         pLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2uZsmkWZE08X4YfNYjfJq6XQ+MFaq3k1arzzykq7tPo=;
        b=fqYvp7c/uZ8HzzD3gD/SeeE07qC46xnTwqURzNaZMqveYcLL/quQu/r6Ycm63SUfkO
         jkIvW9GmX7LsM/koFxO09ovPqx8jDf9aGvN/zFzzPTqlLfMIB9pFh5k7SJgtUYVy4ue2
         97oJMBPUhTfXv8EeLA4eBTaAxS8tYUZkRUHDkYS6zmpoACWoeqFDRN874hRy/kPzOb0W
         fv7ofMbksPxOwQxY41paD9ZJJLQbGkxY6T0XGohsgqvgS5tT0k3+X1Kt4t88fjv64WaA
         J71EatjVgcd+2T83kZRBN0eAVFKJkYdzSFJafVtA70zQ0ho14rWVa+gVNuSwWmq4HHtY
         GXsg==
X-Gm-Message-State: AO0yUKWmlzLpaGssFRIC/PlptXvbtJBhXfsTs+iPW91eMZ0SGuu0LIqq
        61OE5D04dXqoY76g83VBZECdCcZqrh0=
X-Google-Smtp-Source: AK7set+V6/LydNQtamgyO70LbE/v+A7fxhlge4W6bT76hPvWRgw/Ig2l/Ne/rAaIjdQZKKvVNt+TVg==
X-Received: by 2002:a05:6214:528d:b0:56b:edfa:57cc with SMTP id kj13-20020a056214528d00b0056bedfa57ccmr15504349qvb.41.1677078297817;
        Wed, 22 Feb 2023 07:04:57 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 128-20020a370b86000000b0073b59128298sm4612041qkl.48.2023.02.22.07.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 07:04:57 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:04:50 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <63f62f125ac3b_2ab6208b4@willemb.c.googlers.com.notmuch>
In-Reply-To: <5c53cfa0-6728-055d-7aa5-6969844d26bf@antgroup.com>
References: <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
 <20230210030710-mutt-send-email-mst@kernel.org>
 <63e665348b566_1b03a820873@willemb.c.googlers.com.notmuch>
 <d759d787-4d76-c8e1-a5e2-233a097679b1@antgroup.com>
 <63eb9a7fe973e_310218208b4@willemb.c.googlers.com.notmuch>
 <a737c617-6722-7002-1ead-4c5bed452595@antgroup.com>
 <63f4dd3b98f0c_cdc03208ea@willemb.c.googlers.com.notmuch>
 <4b431f19-b5f2-6704-318e-6bde113a3e0a@antgroup.com>
 <20230222063242-mutt-send-email-mst@kernel.org>
 <5c53cfa0-6728-055d-7aa5-6969844d26bf@antgroup.com>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>> You're right. This is configured from userspace before the FD is passed
> >>> to vhost-net, so indeed this will require packet socket UAPI support.
> >>
> >> Thanks for quick reply. We will go with adding an extra UAPI here then.
> >>
> >>
> >> Another discussion for designing this UAPI is, whether it will be better to
> >> support setting only vnet header size, just like what TAP does in its ioctl,
> >> or to support setting a virtio feature bit-map.
> >>
> >>
> >> UAPI setting only vnet header size
> >>
> >> Pros:
> >>
> >> 1. It aligns with how other virito backend devices communicate with
> >> virtio-user
> >>
> >> 2. We can use the holes in struct packet_socket (net/packet/internal.h:120)
> >> to record the extra information since the size info only takes 8 bits.
> >>
> >> Cons:
> >>
> >> 1. It may have more information that virtio-user needs to communicate with
> >> packet socket in the future and needs to add more UAPI supports here.
> >>
> >> To Michael: Is there any other information that backend device needs and
> >> will be given from virtio-user?
> >
> > Yes e.g. I already mentioned virtio 1.0 wrt LE versus native endian
> > format.
> >
> >
> >> UAPI setting a virtio feature bit-map
> >>
> >> Pros:
> >>
> >> 1. It is more general and may reduce future UAPI changes.
> >>
> >> Cons:
> >>
> >> 1. A virtio feature bit-map needs 64 bits, which needs to add an extra field
> >> in packet_sock struct

Accepting a bitmap in the ABI does not have to imply storing a bitmap.

> >>
> >> 2. Virtio-user needs to aware that using packet socket as backend supports
> >> different approach to negotiate the vnet header size.
> >>
> >>
> >> We really appreciate any suggestion or discussion on this design choice of
> >> UAPI.
> > In the end it's ok with just size too, you just probably shouldn't say
> > you support VERSION_1 if you are not passing that bit.
> >
> 
> Sorry for the confusion here that we mentioned VERSION_1 in the commit 
> log. We actually just attended to give an example of what features that 
> may need 12-byte vnet header. We will remove it from the commit log in 
> patch v2 to avoid confusion here. Thanks a lot for your suggestions.

The question hinges on which features are expected to have to be
supported in the future. So far we have

- extra num_buffers field
- little endian (V1)

Given the rate of change in the spec, I don't think this should
be over designed. If V1 is not planned to be supported, just
configure header length. If it is, then perhaps instead a feature
bitmap.

