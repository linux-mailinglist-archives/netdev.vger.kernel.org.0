Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C865946B
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 04:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiL3Dlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 22:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiL3Dle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 22:41:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A06BCAB
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 19:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672371645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1F5+hQjkJhgkTWUhZtnbA0j58E86UDL3Nmc2tQULevg=;
        b=YbveMbX/RNRK42a+VlP295vGjHQSFWitlpo5Kj/qm0IR6dBPp72zSgqEdMafgCLXpZYLYq
        XTPkH1kgSAomzG77vjVA8ZpTW6DzlGv9kUqIyADqtSNhTMbdKxf1pkxLjZSgGPyfsHHHQl
        7721BvUtQ5TXPMsspn76blygoXLreow=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-qTI_KDy2MkquUw3kyaDJew-1; Thu, 29 Dec 2022 22:40:44 -0500
X-MC-Unique: qTI_KDy2MkquUw3kyaDJew-1
Received: by mail-ot1-f71.google.com with SMTP id f8-20020a9d7b48000000b0066f2d64da41so10862754oto.12
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 19:40:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1F5+hQjkJhgkTWUhZtnbA0j58E86UDL3Nmc2tQULevg=;
        b=I8QcLKKvpYQ84KmXX6XFZfqVY50BmZladDx5ocht5JKFqfUziR5x4yl5ll8nr2Eb0Y
         D9ApAs7J4xzN4XPNHApnhi0Gdtqkd7zjRkqDL+AiqBqefrL7FKnQgDv3QJRG5mxrCBd4
         DMQerjOi7iiourTlvM1zyOmhUrJ2yjAutW8cC7a0J+fvmkluB5qlMlhmJr55pcK07J9B
         taWB0O/iAMpRLID3Uxb147dazhdPUMx1vAcJmglakah5wrdRW/HfLXBPVeFyyON43Mk2
         aY9XKjciAOd67qG6WDxL/S//c6D4l+knJXqmT3Cn20CtNYwi/Km2F7Pr/OadezuC7TEd
         RPvQ==
X-Gm-Message-State: AFqh2kq1qDPcLePrYVzRcLsRRphIS46a95xjpVqqa/5JcPEzsUUh9Qpf
        r0HDcwT8/UbqggyR3Bb/gacOKChf6U+Q9Bil2oU9wn7TMwHkuY7sRT07wGWHuXiBStMOIlOYC0G
        ywZQBVkc9ATYbeEjoKWT3vLaz2vBnsQ5d
X-Received: by 2002:a4a:c989:0:b0:480:8f4a:7062 with SMTP id u9-20020a4ac989000000b004808f4a7062mr1398909ooq.57.1672371643844;
        Thu, 29 Dec 2022 19:40:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt7j5z1WBF0/DPB10FVuklqtEzv/3UxFifxJVoglD/g2yM0R+oXtjjD2Fs4H38z4VS9qlknIfSdxxEXjcWRmBs=
X-Received: by 2002:a4a:c989:0:b0:480:8f4a:7062 with SMTP id
 u9-20020a4ac989000000b004808f4a7062mr1398904ooq.57.1672371643572; Thu, 29 Dec
 2022 19:40:43 -0800 (PST)
MIME-Version: 1.0
References: <20221226074908.8154-1-jasowang@redhat.com> <20221226074908.8154-2-jasowang@redhat.com>
 <20221227023447-mutt-send-email-mst@kernel.org> <6026e801-6fda-fee9-a69b-d06a80368621@redhat.com>
 <20221229185120.20f43a1b@kernel.org>
In-Reply-To: <20221229185120.20f43a1b@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 30 Dec 2022 11:40:32 +0800
Message-ID: <CACGkMEsL2Tm=J-nazDEebO0_8=S_4hW2vKdLpZy7ab=Yr92cPw@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio-net: convert rx mode setting to use workqueue
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com, eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 30, 2022 at 10:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 27 Dec 2022 17:06:10 +0800 Jason Wang wrote:
> > > Hmm so user tells us to e.g enable promisc. We report completion
> > > but card is still dropping packets. I think this
> > > has a chance to break some setups.
> >
> > I think all those filters are best efforts, am I wrong?
>
> Are the flags protected by the addr lock which needs BH, tho?
>
> Taking netif_addr_lock_bh() to look at dev->flags seems a bit
> surprising to me.
>

Yes, RTNL should be sufficient here. Will fix it.

Thanks

