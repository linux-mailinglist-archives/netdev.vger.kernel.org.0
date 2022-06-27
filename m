Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBB55B53D
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 04:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiF0Cbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 22:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiF0Cbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 22:31:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C20D42BE5
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 19:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656297103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NbmH8eeNH9GCNyJEMJVIoZ6jzBY1Wwznz8gCyxIKlQM=;
        b=DrjXV66dKehKrYyMP9VKK/gHV2fxQFOANue0FvsMbzaPQ0/i4hoX3NK27eON0WdAaR75IY
        V8vNHFpqncKhqMuJJBX3suBJpKsXTqTf0IaHo8vQujbnQR1G61csfm2+q6vnXEI19YfrEd
        CqmbYXGy5t0iVE15TLRZfC66bRoLXAE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-bHOsnW54OQuO0MpEGQTfxA-1; Sun, 26 Jun 2022 22:31:41 -0400
X-MC-Unique: bHOsnW54OQuO0MpEGQTfxA-1
Received: by mail-qv1-f70.google.com with SMTP id s14-20020ad4438e000000b0047084e1931dso8121979qvr.3
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 19:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NbmH8eeNH9GCNyJEMJVIoZ6jzBY1Wwznz8gCyxIKlQM=;
        b=u1lpneFFZZbPjGmtmHy6LCJjrLvA/lY1kvSPVRCTDANgmgr1La7ajiGDm4LiN3572q
         kLy+vZyUjC/GWbggzJ+91pCq7pzg9zc8DKDYDNx1kURgWNFr8ijowiXUrwJc6k7ok1wY
         DvNm9te2VeGGSkJXtbC+lYlD1CPka47E0DNduebYlsNVH8HawPvzBLh20/JOiK6Lt9yF
         WTz4DosvBgonBO9IEGlWpc9JOUPUKtUI0P3+hHTKEtlKpkF1cC8YQdxTAeOPdS+M+alW
         qZDdjKZJhreD6tB9rX83r1IsvjNM8rMAh8fxxL6o6uKnICC8u5TlycGUWv03SKdcaHW4
         QhFQ==
X-Gm-Message-State: AJIora9OUwxWPabrKJAqqmc9ubqvhTwMLVo+NpBhHncBANEK+D09Byd0
        MkqbvzZ8j0DQoi/0C+XnCHACWHa2m9igVaLA7ilHUv6JKiX4L3GPAUR/mB/eVomIGuZs2kcYECV
        Mx7Pv/j2Bf/82LPBLMYYDA05oDE33n90T
X-Received: by 2002:a0c:dc83:0:b0:470:aa91:9ea5 with SMTP id n3-20020a0cdc83000000b00470aa919ea5mr5787256qvk.28.1656297101021;
        Sun, 26 Jun 2022 19:31:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sckSJl+2KxDYqzywLJ6Cgs+wC5jgXtSANOYX1ODyEpm+4+KD8q/ct4paXz1mgZ94SHRCAZ8XaT/QePmQ65Nnw=
X-Received: by 2002:a0c:dc83:0:b0:470:aa91:9ea5 with SMTP id
 n3-20020a0cdc83000000b00470aa919ea5mr5787245qvk.28.1656297100859; Sun, 26 Jun
 2022 19:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+g1jy-Q911SWTGVV1nw8GAbEAVYSAKqss54+8ehPw9RDA@mail.gmail.com>
 <e3efe652-eb22-4a3f-a121-be858fe2696b@datenfreihafen.org> <CAK-6q+h7497czku9rf9E4E=up5k5gm_NT0agPU2bUZr4ADKioQ@mail.gmail.com>
 <20220616093422.2e9ec948@kernel.org>
In-Reply-To: <20220616093422.2e9ec948@kernel.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 26 Jun 2022 22:31:29 -0400
Message-ID: <CAK-6q+hvw-3EtSoQA-01w+RPCZ1mUDtPEyw-um9a6ocOzW+ovg@mail.gmail.com>
Subject: Re: 6lowpan netlink
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 16, 2022 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 16 Jun 2022 09:00:08 -0400 Alexander Aring wrote:
> > > > I want to spread around that I started to work on some overdue
> > > > implementation, a netlink 6lowpan configuration interface, because
> > > > rtnetlink is not enough... it's for configuring very specific 6lowpan
> > > > device settings.
> > >
> > > Great, looking forward to it!
> >
> > I would like to trigger a discussion about rtnetlink or generic. I can
> > put a nested rtnetlink for some device specific settings but then the
> > whole iproute2 (as it's currently is) would maintain a specific
> > 6lowpan setting which maybe the user never wants...
> > I think we should follow this way when there is a strict ipv6 device
> > specific setting e.g. l2 neighbor information in ipv6 ndisc.
>
> Unless you'll have to repeat attributes which are already present
> in rtnetlink in an obvious way genetlink > rtnetlink.

I think this is not the case, I do not implement a new protocol
family... I just need to manipulate some 6lowpan stack settings that
aren't part of the current ipv6 protocol familty rtnetlink operations.

Thanks.

 - Alex

