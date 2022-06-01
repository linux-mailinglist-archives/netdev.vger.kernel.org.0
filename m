Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33759539D2C
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349821AbiFAGXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349769AbiFAGXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAEB8674EE
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 23:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654064626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ObvcbhHhMzX4KCwPSWO8iXUi+7J6vd2qbDKxEwk9xTg=;
        b=MazYN3XfI2/hyGRd147tQef85xKBfkxF3oXJ/iS4EEL3g0gYz0vuFhkcflD1ide03mjdWx
        aTjWoDRFr53B++h9QNl4E9KDs1F4iWKxanI2aL+aS0OB79zRRYsEKpbqaSI7xJMTew1Flv
        rHlrkOCgu0FQ1znx6dlv6BNHgDKdUuQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-JYJTpWgPMoqF9xUhDSMy2A-1; Wed, 01 Jun 2022 02:23:46 -0400
X-MC-Unique: JYJTpWgPMoqF9xUhDSMy2A-1
Received: by mail-io1-f69.google.com with SMTP id 129-20020a6b0187000000b00660cf61c6e8so407154iob.4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 23:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ObvcbhHhMzX4KCwPSWO8iXUi+7J6vd2qbDKxEwk9xTg=;
        b=WD5TnWhBgKTr+Vps60dD8L7vWd2/hxDnsp8y29MaxNWTvk+2K2Itl/0Bu+2YXhJst/
         pbDh2TmUgm5Zu0Inoe8trZ87RzSr+XefFV1OWSamWBatnPUCIYH4AU5kteXsD4A3uYxG
         eYdLSq46uLivzAcmQduqrpGuW7aZCDBZyCRwftC7XckjRV4OnDTxMmbfyy0B6Oi+3QCI
         sNpOnNK0H13qEHARRkGF2Gd8ecLG6BNZVwNsgNYGOhvOGHmCWyZ0N3we8p+8jhxV9IU5
         mL/di/v8yyElezzGY5xX7hEz3YkcTt8R7m+p2qmtOVnqJ/scLq8VCEQkJ/Z39mXiBxA9
         3s0Q==
X-Gm-Message-State: AOAM531j3ghwEVvW2xLhRmjNjZWhcQk7yI/PkVCoFvSqkT+jRistJgvv
        t0gHw2j0l858FJgL16Ov8cwnuqbz6ZEi1HbU4qOMo0lZ0gAhMCyNkzLnsTEH4iWarslw0ERhoRk
        Ww1CO5mqbx8ztqXUuneuMImcu+JDe00dl
X-Received: by 2002:a05:6638:204d:b0:32e:d894:2b07 with SMTP id t13-20020a056638204d00b0032ed8942b07mr23349604jaj.106.1654064625241;
        Tue, 31 May 2022 23:23:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvvvIUGiWpEPp18t4pNQ+yfM11uWYBFfXbqZ1lYd8MnTcI6wnkfQkmk+Dp/YLl2cvjBmzKGPnE9OA4bp7wVDw=
X-Received: by 2002:a05:6638:204d:b0:32e:d894:2b07 with SMTP id
 t13-20020a056638204d00b0032ed8942b07mr23349590jaj.106.1654064624903; Tue, 31
 May 2022 23:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220531134034.389792-1-ihuguet@redhat.com> <20220531083757.459b65dc@kernel.org>
In-Reply-To: <20220531083757.459b65dc@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 1 Jun 2022 08:23:34 +0200
Message-ID: <CACT4oufD4KtCLgP+vdOMFymrvi+1=ZoK_mbE7sgYmLb0L8CJ9A@mail.gmail.com>
Subject: Re: [PATCH net 0/2] sfc/siena: fix some efx_separate_tx_channels errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, cmclachlan@solarflare.com,
        Jesper Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 5:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 31 May 2022 15:40:32 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > Trying to load sfc driver with modparam efx_separate_tx_channels=3D1
> > resulted in errors during initialization and not being able to use the
> > NIC. This patches fix a few bugs and make it work again.
> >
> > This has been already done in sfc, do it also in sfc_siena.
>
> Does not apply.
>

Sorry about that, I had only applied with patch, not with git, but it
applies with fuzz 1, as I'm seeing now, so not 100% cleanly. I will
send v2.

--=20
=C3=8D=C3=B1igo Huguet

