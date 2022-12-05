Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1DF6428F0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLENHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiLENHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:07:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D291B9EC
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 05:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670245584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fysUMtd7nyS68Uh6akbyo7z/TqrJMUL08Oy/r5zD+R0=;
        b=eXYRAYPcs+N0cnCothl45L4Mfw3hcz7czXPP1bAcyGCxuOzJoiPStjbDKB+pCSWGF+tVux
        duillBH+kWy6CuU8tK0Ampc8dMi6BNCTbHUIvzbQrnzXnnkm+hMyD0T3FkentRBHOppYoM
        ErW/CLgWxyujvg5J575eH/kzyziskX4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-6dBKngVpOjCWJBeEWMvO7g-1; Mon, 05 Dec 2022 08:06:22 -0500
X-MC-Unique: 6dBKngVpOjCWJBeEWMvO7g-1
Received: by mail-wr1-f72.google.com with SMTP id l9-20020adfa389000000b00241f907e102so2257961wrb.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 05:06:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fysUMtd7nyS68Uh6akbyo7z/TqrJMUL08Oy/r5zD+R0=;
        b=qFmKxsFkV0NqG8yNmxy0qoMTEx1A4jxyxishkWP/NQfGqXCVLex2EX992du6n0PpIo
         9sy5N2TeqP13QU+a7fFFLR042KboP7W3k5K2QOwvv6NbQ7HYjKFbb+vBpwMZid+hnpZL
         aWaS7vaRpPFmk/o+9ceUasFRy2C/bTYwHr/6YxZDUywlf0Gn2jtSC6tGfWnhq8m/3QLD
         TuirkTq2S4MR+gNaKt8ZGb3bwYrqPC8tPZqLgknC2QyRNI13ZQTVFOxhc8qszCZjYopl
         uA2gdJIEJkQY6qo16Fs7R7n/S8Y41lxbhGf/FwixyP43TVlAj5/Cg9qsp5Mp82wbs6k6
         YW/w==
X-Gm-Message-State: ANoB5pnbGV13yCMDMRH4TBQ62HRcQHRPEKi4dwX+2nrjw2BhFiuk9+Gu
        9Su+8+NcqLYIOBKTTSMD0nf/iSmB6VNrdEZf4YyF+BXLL1Iwbhl9J8cuiSB93WhHMB15yDuN6hZ
        pC1bo6GMBG99uHIZP
X-Received: by 2002:a7b:cb83:0:b0:3cf:96da:3846 with SMTP id m3-20020a7bcb83000000b003cf96da3846mr61506330wmi.10.1670245581770;
        Mon, 05 Dec 2022 05:06:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7RZfPMSS4umpthjPuwuEfbtfp0zUdyrA+FWxPzPvb5YZzdZ87NyoR3TcEQ0+8D1lPGIcScpg==
X-Received: by 2002:a7b:cb83:0:b0:3cf:96da:3846 with SMTP id m3-20020a7bcb83000000b003cf96da3846mr61506308wmi.10.1670245581511;
        Mon, 05 Dec 2022 05:06:21 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c4f1600b003cf54b77bfesm23862340wmq.28.2022.12.05.05.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 05:06:21 -0800 (PST)
Date:   Mon, 5 Dec 2022 14:06:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v3] net: vmw_vsock: vmci: Check memcpy_from_msg()
Message-ID: <20221205130615.jqnno74hnui6527c@sgarzare-redhat>
References: <20221205094736.k3yuwk7emijpitvw@sgarzare-redhat>
 <20221205115200.2987942-1-artem.chernyshev@red-soft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221205115200.2987942-1-artem.chernyshev@red-soft.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 02:52:00PM +0300, Artem Chernyshev wrote:
>vmci_transport_dgram_enqueue() does not check the return value
>of memcpy_from_msg(). Return with an error if the memcpy fails.
>
>Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
>Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
>Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
>---
>V1->V2 Fix memory leaking and updates for description
>V2->V3 Return the value of memcpy_from_msg()
>
> net/vmw_vsock/vmci_transport.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

