Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D44532DA8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiEXPhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238986AbiEXPhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:37:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E055E76E
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653406622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DLkarMW/Ivf9L6qEuXyyRvGUtVt+gqN+Wc9AhGNSB1U=;
        b=QCDgl2P9B9OgHfHTgsxJCASwE1VztJPKJIDOcgVqUQRUJ6jdfjgnxi2XO4YVuvHRlPUJc/
        tR+ucW81yVTPARmo2Q3KSGmOFYtrHl53dmiDDtz+Xf2pk5Ect4+ua4n/L1rl49pqyJUkCF
        ZF8kse7Bjvg6TnmVgi5GnV9XCneDAlk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-ltkNBjhfM0-CaoWjloUuVw-1; Tue, 24 May 2022 11:37:00 -0400
X-MC-Unique: ltkNBjhfM0-CaoWjloUuVw-1
Received: by mail-io1-f70.google.com with SMTP id l9-20020a5e8809000000b0065e534ca51dso7451248ioj.17
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=DLkarMW/Ivf9L6qEuXyyRvGUtVt+gqN+Wc9AhGNSB1U=;
        b=5xrVngZpfXY4pYEBHCq5XKeinO/l/zmxCC9e6pqbOs37pII8yPFisNcIaUcQjum/20
         ouqpuh0qmJ/V1RZf8FPNvP3pVeiFobA1i9zk7I8pWxEMCh1D+wonwVdYZpwIGKaBY9Rj
         fF22YHpjmN2UOsrdnfJbuk+xVt9yLVmcuZy4AcMn0SbLvhEiFosMKhLh/xJBGKRqHMza
         1FZdc8nDHHoqicXQAhjtt4c7VkPJtFmy5afXeOQR/e1iDPW2aJyXazEoCOUdXtcKTz65
         D5Y9sULx8s/31e86CuKGm2KIsNW2WUo6XRV9pRyW5yMQ4wVPP6C+jpyOUgomynW31alO
         83vA==
X-Gm-Message-State: AOAM530y1nV/eBlj73XIMPpXsenv2OcsAS5g5JWF6Vlhq6CFTpDvVkeV
        UMK0bRYlWg+Q+jRYqavNKGtdJh27ImxQn4hmZ7SlFPfpgCFZNrHCRiTpbNo05k73d8Anfu3qXa/
        qwl0/VOWIe+q+K/U6pqnuFgenFYx84dcC
X-Received: by 2002:a05:6638:4883:b0:32e:4d19:4583 with SMTP id ct3-20020a056638488300b0032e4d194583mr14007477jab.312.1653406620183;
        Tue, 24 May 2022 08:37:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKZWMx9AoXs5+lTSEPhOr1VD3a0Q0EBTc/hdclVZmDZsa9Ky5PF16AObVRarpUD2OOkVXRrc1Ed0cTuY68SFE=
X-Received: by 2002:a05:6638:4883:b0:32e:4d19:4583 with SMTP id
 ct3-20020a056638488300b0032e4d194583mr14007463jab.312.1653406619937; Tue, 24
 May 2022 08:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220511125941.55812-1-ihuguet@redhat.com> <20220511125941.55812-3-ihuguet@redhat.com>
 <20220513110723.dorpu2wgrutcske2@gmail.com> <20220513123716.nuizgafnuanyj2na@gmail.com>
In-Reply-To: <20220513123716.nuizgafnuanyj2na@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 24 May 2022 17:36:49 +0200
Message-ID: <CACT4ouf7P=jq8RM+3WOCVKhNi6mBAunuw65zgTHmHmzw8v-fqg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] sfc: do not initialize non existing queues with efx_separate_tx_channels
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, amaftei@solarflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 2:37 PM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> On Fri, May 13, 2022 at 12:07:23PM +0100, Martin Habets wrote:
> > On Wed, May 11, 2022 at 02:59:41PM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > > If efx_separate_tx_channels is used, some error messages and backtrac=
es
> > > are shown in the logs (see below). This is because during channels
> > > start, all queues in the channels are init asumming that they exist, =
but
> > > they might not if efx_separate_tx_channels is used: some channels onl=
y
> > > have RX queues and others only have TX queues.
> >
> > Thanks for reporting this. At first glance I suspect there may be more =
callers
> > of efx_for_each_channel_tx_queue() which is why it is not yet working f=
or you
> > even with this fix.
> > Probably we need to fix those macros themselves.
> >
> > I'm having a closer look, but it will take some time.
>
> It was easier than I thought. With the patch below I do not get any error=
s,
> and ping works. I did not have to touch efx_for_each_channel_rx_queue().
> Can you give this a try and report if it works for you?

Martin, this is working fine for me. Module loads and unloads without
errors, and I can ping and run an iperf3 test also without errors.

How do you want to do it? Should I send this patch on your behalf
within my patch series? Or do you want to send it yourself first?

>
> Martin
> ---
>  drivers/net/ethernet/sfc/net_driver.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet=
/sfc/net_driver.h
> index 318db906a154..723bbeea5d0c 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1530,7 +1530,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx=
_channel *channel)
>
>  static inline bool efx_channel_has_tx_queues(struct efx_channel *channel=
)
>  {
> -       return true;
> +       return channel && channel->channel >=3D channel->efx->tx_channel_=
offset;
>  }
>
>  static inline unsigned int efx_channel_num_tx_queues(struct efx_channel =
*channel)
>


--=20
=C3=8D=C3=B1igo Huguet

