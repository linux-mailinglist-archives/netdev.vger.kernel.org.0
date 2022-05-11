Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218F1522E98
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiEKImN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244059AbiEKIlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB2BD63BD2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652258497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPS2gEzpHpA65x1YUF542svpx6qrA/jIISHdop4pxU8=;
        b=W+LQ7JA3PqNjZxinPLOmH2Gl2No+4pOCgwcwp7AzwFvd6LElDy7+bpVnIfVKRpYw3cPXMi
        vwIzYWqK21NhRM970Eq8skLDxnPw62Tm+mfN385Wf4/YWi5wfuPiwUMgb9+Gxxribzhopk
        7OaCCkKMHD8MW/BkxKaHCxoNMMkUcY8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-tAULofPfPzG_L9I1rD2Paw-1; Wed, 11 May 2022 04:41:34 -0400
X-MC-Unique: tAULofPfPzG_L9I1rD2Paw-1
Received: by mail-io1-f72.google.com with SMTP id ay38-20020a5d9da6000000b0065adc1f932bso777418iob.11
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=BPS2gEzpHpA65x1YUF542svpx6qrA/jIISHdop4pxU8=;
        b=i5Q4AXoqStZcRb80s7B7Zop4escFORA79INLNNPHHfM7dCARfMD9Emwk0pqwDCrwsm
         Fl5utay9WQkCGwFOmYS+F1XFhaagXOLXw/iU3pWCg75DuoFW6uor85TaFzJgRzK6vbvL
         MsKWvK1aec1xjNjbJoRsRj0G0ILKYV9XABDlkG39h3FhBvL+E8E9g4bWLDOJHh0NpQDd
         Q7akZLfyhZWVY4hiCjRmnU1ad1zB9yAOvfNpZO13QwjBVMCcui/TH7CreznfKMQeLDAj
         KB6bJ/LsJFN/tVbYmGKzpN6tHQxUBIywcjU9IQGvCM7qEbg2ZFV89Qw6KW9Z4bOZJaan
         /RWQ==
X-Gm-Message-State: AOAM533DV2Ej/egB6hwbxV7I91iChkhqUDmr98d+8rBG1wx+ssUJ7gyP
        c7K4pMpbKXbAyLsYuaPft0gRlfcKJV7hUwhZDxPZvXSPtuJpsW3TLz1vds1b7pgojzhOuC/wVIt
        VuY6dPlScXu3OM+jZ9rPTmfwUdMqgh81s
X-Received: by 2002:a92:cccb:0:b0:2c2:7641:ed49 with SMTP id u11-20020a92cccb000000b002c27641ed49mr11211357ilq.271.1652258493974;
        Wed, 11 May 2022 01:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydQJBkSlun5AyBMPN2WFi4eptGVYctsB1/DO6Jdl9GwRoWrwbuUAIuIdECLXT1pLJI/8zAYH9nAzY0/IvJc7E=
X-Received: by 2002:a92:cccb:0:b0:2c2:7641:ed49 with SMTP id
 u11-20020a92cccb000000b002c27641ed49mr11211343ilq.271.1652258493702; Wed, 11
 May 2022 01:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220510084443.14473-1-ihuguet@redhat.com> <20220510084443.14473-2-ihuguet@redhat.com>
 <20220511071945.46o3hlfnhppkqoro@gmail.com>
In-Reply-To: <20220511071945.46o3hlfnhppkqoro@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 11 May 2022 10:41:22 +0200
Message-ID: <CACT4oueVVo5UEk0x_+j03MYRjEgDdLp-sox+fHaEVj7ZXOY6FQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] sfc: add new helper macros to iterate
 channels by type
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, ap420073@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 9:19 AM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> Hi =E5=A9=89igo,
>
> On Tue, May 10, 2022 at 10:44:39AM +0200, =E5=A9=89igo Huguet wrote:
> > Sometimes in the driver it's needed to iterate a subset of the channels
> > depending on whether it is an rx, tx or xdp channel. Now it's done
> > iterating over all channels and checking if it's of the desired type,
> > leading to too much nested and a bit complex to understand code.
> >
> > Add new iterator macros to allow iterating only over a single type of
> > channel.
>
> We have similar code we'll be upstreaming soon, once we've managed to
> split off Siena. The crucial part of that seems to have been done
> today.
>
> > Signed-off-by: =E5=A9=89igo Huguet <ihuguet@redhat.com>
> > ---
> >  drivers/net/ethernet/sfc/net_driver.h | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethern=
et/sfc/net_driver.h
> > index 318db906a154..7f665ba6a082 100644
> > --- a/drivers/net/ethernet/sfc/net_driver.h
> > +++ b/drivers/net/ethernet/sfc/net_driver.h
> > @@ -1501,6 +1501,27 @@ efx_get_channel(struct efx_nic *efx, unsigned in=
dex)
> >            _channel =3D (_channel->channel + 1 < (_efx)->n_channels) ? =
 \
> >                    (_efx)->channel[_channel->channel + 1] : NULL)
> >
> > +#define efx_for_each_rx_channel(_channel, _efx)                       =
           \
> > +     for (_channel =3D (_efx)->channel[0];                            =
     \
> > +          _channel;                                                   =
   \
> > +          _channel =3D (_channel->channel + 1 < (_efx)->n_rx_channels)=
 ?   \
> > +                  (_efx)->channel[_channel->channel + 1] : NULL)
> > +#define efx_for_each_tx_channel(_channel, _efx)                       =
           \
> > +     for (_channel =3D (_efx)->channel[efx->tx_channel_offset];       =
     \
> > +          _channel;                                                   =
   \
> > +          _channel =3D (_channel->channel + 1 <                       =
     \
> > +                  (_efx)->tx_channel_offset + (_efx)->n_tx_channels) ?=
   \
> > +                  (_efx)->channel[_channel->channel + 1] : NULL)
>
> We've chosen a different naming conventions here, and we're also removing
> the channel array.
> Also not every channel has RX queues and not every channel has TX queues.
>
> Sounds like it's time we have another call.

I saw you were already upstreaming the siena split, probably it had
been a good idea to wait for it to be merged before sending this.

I'm going to be on PTO the rest of the week and the next one, maybe we
can talk when I'm back, and hopefully you will have made more
progress. Then I can resubmit this series adapted to the new state of
the code, if it's still useful.

> Martin
>
> > +#define efx_for_each_xdp_channel(_channel, _efx)                      =
   \
> > +     for (_channel =3D ((_efx)->n_xdp_channels > 0) ?                 =
     \
> > +                  (_efx)->channel[efx->xdp_channel_offset] : NULL;    =
   \
> > +          _channel;                                                   =
   \
> > +          _channel =3D (_channel->channel + 1 <                       =
     \
> > +                  (_efx)->xdp_channel_offset + (_efx)->n_xdp_channels)=
 ? \
> > +                  (_efx)->channel[_channel->channel + 1] : NULL)
> > +
> >  /* Iterate over all used channels in reverse */
> >  #define efx_for_each_channel_rev(_channel, _efx)                     \
> >       for (_channel =3D (_efx)->channel[(_efx)->n_channels - 1];       =
 \
> > --
> > 2.34.1
>


--=20
=C3=8D=C3=B1igo Huguet

