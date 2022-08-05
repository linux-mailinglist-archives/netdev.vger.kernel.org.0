Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B65058ADD9
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbiHEQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241156AbiHEQFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:05:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA4DE1570F
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 09:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659715540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KO2+Lhn1y2XnVi7bI4Cc5ciAkJZHya2Xso0bWfCh5JA=;
        b=asfYgS+LNK+c7OobwJ43vYVFp1dTTK4pR7dzyZvc5SkdUhABvQscgEH5YtMCiEMp/3DW/O
        z8zEYNgwtr/W9HFj1mtwbh7JdJOpDCBl+PY8UA0+PDuWYXXUjTJXRauU6jt9eM+ZF2ohhs
        gm00aj/bRF/E24eduiU3/MWU/L2bjp4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-bEUFalejMzyAg7H-R2TMRA-1; Fri, 05 Aug 2022 12:05:39 -0400
X-MC-Unique: bEUFalejMzyAg7H-R2TMRA-1
Received: by mail-qt1-f198.google.com with SMTP id r18-20020ac867d2000000b0033fbebb9213so2212022qtp.3
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 09:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=KO2+Lhn1y2XnVi7bI4Cc5ciAkJZHya2Xso0bWfCh5JA=;
        b=Jpkb0fdYbrVHAdo19WdjP/buQycRUPdOmqo+txbQLoywfFCHNZVsPHxHR5n6VrSp22
         sv8RLyFGsQCgJ/Z1V9ie/3UsmK8EgKdauUAiah/ajPkEJznVX+tmLZhYzvHco70paiyo
         3RZktddaO2Oarl89b7TfSfXsx5ZalQGM05wagQe7mUgc16c7iazKBPIFf22d1m4UsMRc
         7Ew3yP2WRi0eUoglfB2keKMcvPNQJ3koM/xmVjVrPQTmITmf0nKBOX2uyxDxiBDsTG6H
         n/NTkKyU+W8L6gY0dbJOaDKJs3NL2LLFBjYhVMYBetODY50oiYyppHltue3XOjxoZDnz
         kDUQ==
X-Gm-Message-State: ACgBeo1JHxClLP76VRBfGOVPmlf39VrHikgZAnC6/83L4dFwjf7xPkM7
        X24VavYNS3N+f3cDocHVBQ6ShjJRLbmPsa+ymcccoBX/ltwJJojFkqb/TT1aJMhhmisIq/oBiaO
        iMU4kHRir3QWEIege
X-Received: by 2002:ad4:5ce3:0:b0:474:71c0:adf3 with SMTP id iv3-20020ad45ce3000000b0047471c0adf3mr6391521qvb.47.1659715538459;
        Fri, 05 Aug 2022 09:05:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6V/dJ4FYdWc2pXQmkRsGFLohJ8WPMbtbN/X/1uVIpxzDhT0pzdU07XUiuvIlyTbScoDMAaoA==
X-Received: by 2002:ad4:5ce3:0:b0:474:71c0:adf3 with SMTP id iv3-20020ad45ce3000000b0047471c0adf3mr6391470qvb.47.1659715538111;
        Fri, 05 Aug 2022 09:05:38 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id z9-20020a05622a028900b003422c7ccbc5sm2577102qtw.59.2022.08.05.09.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 09:05:37 -0700 (PDT)
Date:   Fri, 5 Aug 2022 18:05:28 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <20220805160528.4jzyrjppdftrvdr5@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,
sorry but I didn't have time to review this series. I will definitely do 
it next Monday!

Have a nice weekend,
Stefano

On Wed, Aug 03, 2022 at 01:48:06PM +0000, Arseniy Krasnov wrote:
>Hello,
>
>This patchset includes some updates for SO_RCVLOWAT:
>
>1) af_vsock:
>   During my experiments with zerocopy receive, i found, that in some
>   cases, poll() implementation violates POSIX: when socket has non-
>   default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>   POLLRDNORM bits in 'revents' even number of bytes available to read
>   on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>   POLLIN flag and then tries to read data(for example using  'read()'
>   call), but read call will be blocked, because  SO_RCVLOWAT logic is
>   supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>   requires that:
>
>   "POLLIN     Data other than high-priority data may be read without
>               blocking.
>    POLLRDNORM Normal data may be read without blocking."
>
>   See https://www.open-std.org/jtc1/sc22/open/n4217.pdf, page 293.
>
>   So, we have, that poll() syscall returns POLLIN, but read call will
>   be blocked.
>
>   Also in man page socket(7) i found that:
>
>   "Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>   socket as readable only if at least SO_RCVLOWAT bytes are available."
>
>   I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>   uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>   this case for TCP socket, it works as POSIX required.
>
>   I've added some fixes to af_vsock.c and virtio_transport_common.c,
>   test is also implemented.
>
>2) virtio/vsock:
>   It adds some optimization to wake ups, when new data arrived. Now,
>   SO_RCVLOWAT is considered before wake up sleepers who wait new data.
>   There is no sense, to kick waiter, when number of available bytes
>   in socket's queue < SO_RCVLOWAT, because if we wake up reader in
>   this case, it will wait for SO_RCVLOWAT data anyway during dequeue,
>   or in poll() case, POLLIN/POLLRDNORM bits won't be set, so such
>   exit from poll() will be "spurious". This logic is also used in TCP
>   sockets.
>
>3) vmci/vsock:
>   Same as 2), but i'm not sure about this changes. Will be very good,
>   to get comments from someone who knows this code.
>
>4) Hyper-V:
>   As Dexuan Cui mentioned, for Hyper-V transport it is difficult to
>   support SO_RCVLOWAT, so he suggested to disable this feature for
>   Hyper-V.
>
>Thank You
>
>Arseniy Krasnov(9):
> vsock: SO_RCVLOWAT transport set callback
> hv_sock: disable SO_RCVLOWAT support
> virtio/vsock: use 'target' in notify_poll_in callback
> vmci/vsock: use 'target' in notify_poll_in callback
> vsock: pass sock_rcvlowat to notify_poll_in as target
> vsock: add API call for data ready
> virtio/vsock: check SO_RCVLOWAT before wake up reader
> vmci/vsock: check SO_RCVLOWAT before wake up reader
> vsock_test: POLLIN + SO_RCVLOWAT test
>
> include/net/af_vsock.h                       |   2 +
> net/vmw_vsock/af_vsock.c                     |  38 +++++++++-
> net/vmw_vsock/hyperv_transport.c             |   7 ++
> net/vmw_vsock/virtio_transport_common.c      |   7 +-
> net/vmw_vsock/vmci_transport_notify.c        |  10 +--
> net/vmw_vsock/vmci_transport_notify_qstate.c |  12 +--
> tools/testing/vsock/vsock_test.c             | 107 +++++++++++++++++++++++++++
> 7 files changed, 166 insertions(+), 17 deletions(-)
>
> Changelog:
>
> v1 -> v2:
> 1) Patches for VMCI transport(same as for virtio-vsock).
> 2) Patches for Hyper-V transport(disabling SO_RCVLOWAT setting).
> 3) Waiting logic in test was updated(sleep() -> poll()).
>
> v2 -> v3:
> 1) Patches were reordered.
> 2) Commit message updated in 0005.
> 3) Check 'transport' pointer in 0001 for NULL.
> 4) Check 'value' in 0001 for > buffer_size.
>
>-- 
>2.25.1

