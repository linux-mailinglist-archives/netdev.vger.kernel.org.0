Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641AD64B80A
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 16:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiLMPHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 10:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiLMPHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 10:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620D521891
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 07:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670943992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QIV38DnRgw5d8eTHW5XOjPjMdQVy/JxED3DRuC/h3DU=;
        b=OdVpG9j91daC0g+cFkTSF+vuhAqs09a3PTYikcDdXU847+FMmBpn87q6RhqPb/dOf+fGMq
        NYhX41CMd9yFn09vLmplk1ntNhsoVaAkuKqhcDTR/xwgVD3QLSHoBJ/FfMyXEwIFx41Qon
        RB6gv4aCV+0Zl+IS5jx4aP986HW+TpY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-nQssGqYdMZ6ejUyIA7uh2g-1; Tue, 13 Dec 2022 10:06:31 -0500
X-MC-Unique: nQssGqYdMZ6ejUyIA7uh2g-1
Received: by mail-lf1-f69.google.com with SMTP id i5-20020a0565123e0500b004a26e99bcd5so1281161lfv.1
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 07:06:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIV38DnRgw5d8eTHW5XOjPjMdQVy/JxED3DRuC/h3DU=;
        b=gaVtxEGR55pulf7g3bt6mijz+uH8E27MYo0qAvKf+PFkYJNbHaTTbya8OvE1L0BuBK
         ITP2KtUM2TsJ1tu0BCJnxOJy+NSjZPN/51etZa4hdZPGulLcKGSHWUxX4BhHHReMNVn1
         ykz5fwAE06x/3edhtcLKA6g12PpaOipo+6kCsXgylYwmlOreLb55Lz4oW6D8zEeaPQ9N
         cwp3pQpBSzmD35zLl0aCo07yYRIZLO/jhiTF502Q2mhEovQ3UdkBVuSpSiB+/hIe8XDg
         vWm3uZ2CGHwFzSFXY1q59sz8vEAZiHw3EN/6icq54mFGnvRtI+wkBh966ERX0iLnFC4W
         l2ZQ==
X-Gm-Message-State: ANoB5pmnjJboFvoXxGBZmV284+65dwoVXUG2G4ETXKg1g/o14FnWGvWy
        qLB4WlTw7xoJMAILRO5VPU4F+bWIVGHCfe8HfEIPNx6x5pjaInQcHq1AAx0OTuJqnQyVnSxoqn0
        VDgKC3XyKhKpiIMhQ
X-Received: by 2002:a05:6512:25a4:b0:4b5:87da:8b35 with SMTP id bf36-20020a05651225a400b004b587da8b35mr6373276lfb.61.1670943988393;
        Tue, 13 Dec 2022 07:06:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7vgbEpA6HaWdsVzT53anYyRdWOSR1rrrHGJQiAPEgrJcsGLx4k6nbiisfQn77DohtXbaWyzg==
X-Received: by 2002:a05:6512:25a4:b0:4b5:87da:8b35 with SMTP id bf36-20020a05651225a400b004b587da8b35mr6373254lfb.61.1670943988122;
        Tue, 13 Dec 2022 07:06:28 -0800 (PST)
Received: from redhat.com ([2.52.138.183])
        by smtp.gmail.com with ESMTPSA id x13-20020a5d650d000000b002365730eae8sm14773wru.55.2022.12.13.07.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 07:06:27 -0800 (PST)
Date:   Tue, 13 Dec 2022 10:06:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <20221213100510-mutt-send-email-mst@kernel.org>
References: <20221213072549.1997724-1-bobby.eshleman@bytedance.com>
 <20221213102232.n2mc3y7ietabncax@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213102232.n2mc3y7ietabncax@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 11:22:32AM +0100, Stefano Garzarella wrote:
> > +	if (len <= GOOD_COPY_LEN && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> 
> Same here.
> 
> If there are no major changes to be made, I think the next version is the
> final ones, though we are now in the merge window, so net-next is closed
> [1], only RFCs can be sent [2].
> 
> I suggest you wait until the merge window is over (two weeks usually) to
> send the next version.

Nah, you never know, could be more comments. And depending on the timing
I might be able to merge it.

-- 
MST

