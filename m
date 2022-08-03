Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366CA58885A
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiHCH5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbiHCH5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:57:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D25442A273
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 00:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659513471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OEFsmwkVi669wYEes65YKb6PZlH2lsPyfB4kF4NfeRE=;
        b=i8zlpjY+ZPtTnUMg7tddV6jx3cBF6Q3jL2qlJsHyCaYGX7J94+azgkjQJ/7tHmBTPFxrg8
        xEXUUezyP2yAeOhx38oQ9rKyVWWUhM0fYys32yh9VTSBiZIkHVg7cMomdSdJGR3f9rcmc5
        Z7QYb4pqakCx7G4zdDVO+chNrSkVY4I=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-wW8a7mi1PHaBrPjttJdGXg-1; Wed, 03 Aug 2022 03:57:49 -0400
X-MC-Unique: wW8a7mi1PHaBrPjttJdGXg-1
Received: by mail-lj1-f199.google.com with SMTP id h18-20020a2e9012000000b0025e4f48d24dso2193410ljg.10
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 00:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEFsmwkVi669wYEes65YKb6PZlH2lsPyfB4kF4NfeRE=;
        b=mW2merHTWbgGFcgXmRqa+VEbqp2dEAeKfwbpYyJGZ5q37O23tTTPc2BNvx5IV1M2Gt
         XWPX7rOIUYZVSvwaXBaiusj33oW+LcPnQSNjSsmMLdwDvjekujE5VqRZPIL8Rwx78+3t
         /V+gheoHdd3ZzkV5CJ2AT48ji/eNQoDR6EiieDh30CLnmyH/6LeV4ZpqN+KoeMZepch/
         KYbLzftZrtdEfkPCrQ88q9N9TiUw5lv5Z+Z+XeSyF/DySnvrjt/LPyaiRDfTVGaKaomh
         NAbNYq6knH0Z5ZMMfTiRAAnpwv69l0/AW3LXl4LBtDyl2moCSAJY/0pxltsD1P187s0b
         yM0A==
X-Gm-Message-State: ACgBeo14VlRlSMm16AAbCkY88vb+fHavKrTpmPXNZgVheZJP5S8iBCyp
        3bAlVWx/WSy2IIdX3i48Pxf88cAxu+0QjimE/0DPd8sqUjH3fbjrbI1lQ6fWS2ZXgMk0oogZAeR
        uryv8MmeZXUucc6Qh6dHGCzDdOgZYmZGt
X-Received: by 2002:ac2:43b0:0:b0:48b:1eb:d1e5 with SMTP id t16-20020ac243b0000000b0048b01ebd1e5mr4033023lfl.641.1659513468091;
        Wed, 03 Aug 2022 00:57:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR600ldUB8qbBwa7CANdnj6UO9/ZbaTlVrEpGYh1sEEV3xqsMglefFL6pbFFalSJdNMSIfi9UKtLwl2x+Q35u4E=
X-Received: by 2002:ac2:43b0:0:b0:48b:1eb:d1e5 with SMTP id
 t16-20020ac243b0000000b0048b01ebd1e5mr4033015lfl.641.1659513467888; Wed, 03
 Aug 2022 00:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
 <20220707155500.GA305857@bhelgaas> <Yswn7p+OWODbT7AR@gmail.com>
 <20220711114806.2724b349@kernel.org> <Ys6E4fvoufokIFqk@gmail.com>
 <20220713114804.11c7517e@kernel.org> <Ys/+vCNAfh/AKuJv@gmail.com> <20220714090500.356846ea@kernel.org>
In-Reply-To: <20220714090500.356846ea@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 3 Aug 2022 15:57:34 +0800
Message-ID: <CACGkMEt1qLsSf2Stn1YveW-HaDByiYFdCTzdsKESypKNbF=eTg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Habets <habetsm.xilinx@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        davem <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        linux-pci@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        mst <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 12:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 14 Jul 2022 12:32:12 +0100 Martin Habets wrote:
> > > Okay. Indeed, we could easily bolt something onto devlink, I'd think
> > > but I don't know the space enough to push for one solution over
> > > another.
> > >
> > > Please try to document the problem and the solution... somewhere, tho.
> > > Otherwise the chances that the next vendor with this problem follows
> > > the same approach fall from low to none.
> >
> > Yeah, good point. The obvious thing would be to create a
> >  Documentation/networking/device_drivers/ethernet/sfc/sfc/rst
> > Is that generic enough for other vendors to find out, or there a better place?
>
> Documentation/vdpa.rst ? I don't see any kernel level notes on
> implementing vDPA perhaps virt folks can suggest something.

Not sure, since it's not a vDPA general thing but a vendor/parent
specific thing.

Or maybe Documentation/vdpa/sfc ?

Thanks

> I don't think people would be looking into driver-specific docs
> when trying to implement an interface, so sfc is not a great option
> IMHO.
>
> > I can do a follow-up patch for this.
>
> Let's make it part of the same series.
>

