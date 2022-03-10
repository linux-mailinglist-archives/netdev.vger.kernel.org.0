Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E085D4D4791
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbiCJNAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiCJNAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:00:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BB205716B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646917162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hwCuIDSsPjX4AERceBeOtiMJvDAZVLHVVFLuVfFYlm4=;
        b=BH7O8ZkaqBXBI7e5a3Sg3UozcHA2L49+QDlxMCk/J9NROom0uIwsARykkzgXjmPEmIt11F
        x4ptZDV896fqck7OOBNx5OC9KIIJpthVmdqbYwMdT0G8mTNs7uihjFnPl+iabfYzPjVYID
        +56C70l3Qu11nbD9suc/eO/nBxSS8MI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-HN6-TXZ6MAmmwxQgqXKytA-1; Thu, 10 Mar 2022 07:59:21 -0500
X-MC-Unique: HN6-TXZ6MAmmwxQgqXKytA-1
Received: by mail-wm1-f70.google.com with SMTP id 14-20020a05600c104e00b003897a167353so2248720wmx.8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:59:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hwCuIDSsPjX4AERceBeOtiMJvDAZVLHVVFLuVfFYlm4=;
        b=T56j8y1mHFq3dR7cdxcikrSmqikXaMNPURJp6utQa9N3VePjPkJfLabDenzovLD5Nj
         t91jLPvvZeodYSAe2qQQRdEHn1oB6ogMRVBPPPJoNwOBm0pf/cYasdbMUO2AqHQhn2QG
         /7cnoa9mn0deiWqIdt6Jay0twOrVPG1aLPa51o0cu1YgePCMJnzxVVgI8eU9gHHOIDd1
         y5miCqiIBXobrKDR7FH4Su6k6rTtmBD1n2sd7g9q7FmhspDtFnMQp5sxGSg00mfvwRNY
         mgbHrxdIyyhv/xZQRRIwcPhosdiHa8L4qf4FQKqjeq+ajlh0KiM06PpXLetMf1Oq3MO3
         TcPw==
X-Gm-Message-State: AOAM532BoEiE5q3iijkk+/ed+GwnPIxTOjKu3im7K3jPrKmd04kKbFZL
        C0uZadIRLWgWjL60FBysTi5t+5ubrJg1fq8nENSXMbMuITyu+zx6/wqRCHTvu1k0miWY6l86dg7
        PjQVlKAaD3Bmwstoa
X-Received: by 2002:adf:e74a:0:b0:1f0:25cb:3ad5 with SMTP id c10-20020adfe74a000000b001f025cb3ad5mr3347336wrn.231.1646917159909;
        Thu, 10 Mar 2022 04:59:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4qf2SKWvXQvwoAB9Gh/FK48f8OJZe69JH0iUoqd3J7EpB6Fi2Yt+tJIwgM/gUJZtaibSlQA==
X-Received: by 2002:adf:e74a:0:b0:1f0:25cb:3ad5 with SMTP id c10-20020adfe74a000000b001f025cb3ad5mr3347324wrn.231.1646917159674;
        Thu, 10 Mar 2022 04:59:19 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id n7-20020a05600c3b8700b00389a6241669sm8676255wms.33.2022.03.10.04.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 04:59:19 -0800 (PST)
Date:   Thu, 10 Mar 2022 07:59:15 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     sgarzare@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vsock: cycle only on its own socket
Message-ID: <20220310075854-mutt-send-email-mst@kernel.org>
References: <20220310125425.4193879-1-jiyong@google.com>
 <20220310075554-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310075554-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 07:57:58AM -0500, Michael S. Tsirkin wrote:
> On Thu, Mar 10, 2022 at 09:54:23PM +0900, Jiyong Park wrote:
> > Hi Stefano,
> > 
> > As suggested [1], I've made two patches for easier backporting without
> > breaking KMI.
> > 
> > PATCH 1 fixes the very issue of cycling all vsocks regardless of the
> > transport and shall be backported.
> > 
> > PATCH 2 is a refactor of PATCH 1 that forces the filtering to all
> > (including future) uses of vsock_for_each_connected_socket.
> > 
> > Thanks,
> > 
> > [1] https://lore.kernel.org/lkml/20220310110036.fgy323c4hvk3mziq@sgarzare-redhat/
> 
> 
> OK that's better. Pls do include changelog in the future.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Hmm actually I think I have a better idea. Hang on.

> 
> 
> > Jiyong Park (2):
> >   vsock: each transport cycles only on its own sockets
> >   vsock: refactor vsock_for_each_connected_socket
> > 
> >  drivers/vhost/vsock.c            | 3 ++-
> >  include/net/af_vsock.h           | 3 ++-
> >  net/vmw_vsock/af_vsock.c         | 9 +++++++--
> >  net/vmw_vsock/virtio_transport.c | 7 +++++--
> >  net/vmw_vsock/vmci_transport.c   | 3 ++-
> >  5 files changed, 18 insertions(+), 7 deletions(-)
> > 
> > 
> > base-commit: 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
> > -- 
> > 2.35.1.723.g4982287a31-goog

