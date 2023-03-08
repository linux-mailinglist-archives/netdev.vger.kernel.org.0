Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6142A6B0EB5
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCHQ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCHQ0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:26:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417C9AB0BD
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 08:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678292757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9rxCu09c0NETlVwsuLK1Q55qTxLR/36qzoqgR71TIHw=;
        b=Z/DM5KmBzKV8oyYQPbw9Ciq32AL5ZJXAGFsrF0KpxyFSPGyclKRh5/BZYiI2e4zJRxXQOG
        HVVZasGgPpr7OrchEzqem3y7n1obELk5T6yAwdzAFg6GEwQmlWQJ+Ev0P9lWUvGiQp7/r2
        1kFVvb/+DzJzy9IdGRk9pp41SmqjiRE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-xsViVbugO3mDscnUcNW-5w-1; Wed, 08 Mar 2023 11:25:56 -0500
X-MC-Unique: xsViVbugO3mDscnUcNW-5w-1
Received: by mail-pj1-f69.google.com with SMTP id q24-20020a17090a2e1800b00237c37964d4so1241334pjd.8
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 08:25:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rxCu09c0NETlVwsuLK1Q55qTxLR/36qzoqgR71TIHw=;
        b=0Jgu7fJ/xugP1btSVitf7Ug16lMKdOYogPTOODv09/cb0Tev9XnEf9eBfLdlk8SGn6
         0G3xReuXFReaKCq6i+oW3/pyKQW/EiIfi68PEW16vEGUCbn6+JfXkPNdZdRItfHn8vt8
         LQoW+Bknl8o+hJ+5DMG7eGs2tNJTlHJP8Qgzb8uK1Un3Mqp+D3bvIsf/v5oNVz+qzH9F
         IXVKsVg6FTuZCaTJ4iDptgapCdefTZJYYa4WzXJTjo6jtUy1ndcXLXbqJK6hdMSM2PUF
         qHI2OpcGxoJeeqE2sYjPG2gKz60z9KUxf61+LhhD3qRSCogeqxH5g6C8iYhnytZxDVSU
         nJuQ==
X-Gm-Message-State: AO0yUKWEC/tMMms08w+p8AzM8cXXlj1YCRuE5FL/4mcql0cvaqZVSZ+f
        S2fLjxDDz+edLa0AVfiW/qZXxm++qQ8jFJNBn0A3j0mWTn+A371TtFaQO4Xa7o3pY24jF/Ls1xN
        GMmWhW1XM1d/Jr0RfQj+R4Zo9cay8a5gR
X-Received: by 2002:a62:f807:0:b0:5a9:d579:6902 with SMTP id d7-20020a62f807000000b005a9d5796902mr7832100pfh.0.1678292754867;
        Wed, 08 Mar 2023 08:25:54 -0800 (PST)
X-Google-Smtp-Source: AK7set+vaQev+5Pt9Z4fNcHOrzUhwcY8hETLVQ7TWcxm+gDJoVwnvii4tVx2ZUsD6hSf8Hujs8ljLqd6G1f0Mut9FEE=
X-Received: by 2002:a62:f807:0:b0:5a9:d579:6902 with SMTP id
 d7-20020a62f807000000b005a9d5796902mr7832087pfh.0.1678292754379; Wed, 08 Mar
 2023 08:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20230308113254.18866-1-ihuguet@redhat.com> <ddf82062-8755-1980-aba7-927742fed230@gmail.com>
In-Reply-To: <ddf82062-8755-1980-aba7-927742fed230@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 8 Mar 2023 17:25:43 +0100
Message-ID: <CACT4oudb2Jf09w62k65PLFpJyrCPnPAXc1FcVZLeB0To6OtORA@mail.gmail.com>
Subject: Re: [PATCH net] sfc: ef10: don't overwrite offload features at NIC reset
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 4:53=E2=80=AFPM Edward Cree <ecree.xilinx@gmail.com>=
 wrote:
>
> On 08/03/2023 11:32, =C3=8D=C3=B1igo Huguet wrote:
> > At NIC reset, some offload features related to encapsulated traffic
> > might have changed (this mainly happens if the firmware-variant is
> > changed with the sfboot userspace tool). Because of this, features are
> > checked and set again at reset time.
> >
> > However, this was not done right, and some features were improperly
> > overwritten at NIC reset:
> > - Tunneled IPv6 segmentation was always disabled
> > - Features disabled with ethtool were reenabled
> > - Features that becomes unsupported after the reset were not disabled
> >
> > Also, cleanup a bit the setting of other features not related to
> > encapsulation. Now that Siena devices are unsupported, some checks are
> > unnecessary because they're always supported in all ef10 models.
>
> Could you clarify what checks were removed?  All I can see is the
>  'NETIF_F_TSO6 requires NETIF_F_IPV6_CSUM' check, and Siena already
>  supported NETIF_F_IPV6_CSUM (it's only Falcon that didn't).

Yes, those are the removed checks. It's only one check, actually,
sorry for the inaccuracy.

I didn't know since what device family was this supported. Then this
check was unnecessary since the sfc_falcon split.

> Or are you also referring to some items moving from efx.c to the
>  definition of EF10_OFFLOAD_FEATURES?  That's fine and matches more
>  closely to what we do for ef100, but again the commit message could
>  explain this better.

Yes, a very poor explanation. Moving those items is part of the "cleanup", =
yes.

> In any case this should really be two separate patches, with the
>  cleanup part going to net-next.

I thought about doing that, but I'm always reluctant to increase
reviewers' work by sending small cleanups, so being small and very
related to this patch, I included it here.

> That said, the above is all nit-picky, and the fix looks good, so:
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
>


--=20
=C3=8D=C3=B1igo Huguet

