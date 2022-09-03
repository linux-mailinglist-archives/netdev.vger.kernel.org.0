Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6F65AC0C0
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 20:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiICS3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 14:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiICS3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 14:29:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C504542AE8
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 11:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662229757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2JFtouHZvYoDswOl7hDRXvN6uVGBX2uC31/Be7OBlHY=;
        b=PyznNgmMtJ1Z5D1HTdumJ0AM+Nj7L2EKb25dOPYsNYYZZk+GhdEtI58/KiWcoppZAeuSCD
        y1CxDYBwq1gKVfc3v3N0xJN40f5Tc4K8gKTcvzuVt64lNsoa7hj2zYNkt/GpDz+F3p5JCF
        hmrm+InEzyg+eLYjMptcGWZ89S/00WI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-oJs6mQNEOlq0ymZgv0VbLw-1; Sat, 03 Sep 2022 14:29:16 -0400
X-MC-Unique: oJs6mQNEOlq0ymZgv0VbLw-1
Received: by mail-qk1-f198.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso4358672qkp.1
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 11:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2JFtouHZvYoDswOl7hDRXvN6uVGBX2uC31/Be7OBlHY=;
        b=x8gWqyCur/C2y62er9F1VeNDSAw7KHgjQROMvPsQXyMAq/UVF6J+Tchd85/z4dNJtc
         nTMGZX+AZ9/XE4KeAm5TT7PMsng8ni7twjZGv1JeYrr5DasxU5nR+DkjSEeWiG6w6D+J
         7kG1Bt3LWdDln2Bp/3pOAKO83+BZqZuIMaOBeValOyvigNh/785lwQYroL2OKppA59t8
         bNOaD13wxFNaQNzMyhqjleWlFJTqK4hTy7cvJu/WdK2ea8/I/heZmhKsmcJbtSiKpSVj
         8WpxY3eYtAe1eu+k8JbYOf42NIPyX79p3p2q2YuZLaw3ZOKZH1/XP+4ivZch/7sErqAQ
         uk1w==
X-Gm-Message-State: ACgBeo2TqARmC+7Ksmb2ocSnnVqQ0+Rjw2nr5XjvV3+91427JFRU+Wqf
        MzI3pQ/dFvYPyO5e5tF8uHlGIJXEwQPdW0pk5TpmI10Ep5EKjnYkkhwAVZQRQjeyvScgPQl3Xoh
        rYJkHf9dnDBGS22Cdm/UBi6ZkH2o+2nMH
X-Received: by 2002:a05:622a:4:b0:344:94b7:a396 with SMTP id x4-20020a05622a000400b0034494b7a396mr32570595qtw.123.1662229756312;
        Sat, 03 Sep 2022 11:29:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4tA06EEjnq8KwvTgtBIApULLViUAdlXrHA+PUz9Afw1X1Z5XBSSBU7taWFW+mKX5XPqznbgvFI3jkZMvtkCq8=
X-Received: by 2002:a05:622a:4:b0:344:94b7:a396 with SMTP id
 x4-20020a05622a000400b0034494b7a396mr32570578qtw.123.1662229756131; Sat, 03
 Sep 2022 11:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13> <20220901020918.2a15a8f9@xps-13>
 <20220901150917.5246c2d0@xps-13> <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
 <20220903020829.67db0af8@xps-13> <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
 <20220903180556.6430194b@xps-13> <CAK-6q+guC=eYQtUX=2wvhUTyNC+iNWSVuiBHC94soVUrLoBYGg@mail.gmail.com>
In-Reply-To: <CAK-6q+guC=eYQtUX=2wvhUTyNC+iNWSVuiBHC94soVUrLoBYGg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 3 Sep 2022 14:29:05 -0400
Message-ID: <CAK-6q+hyKFS0kPRkG=AKV7z5E1OdGEbjPSKZ0uFEgcK_8WC=Ow@mail.gmail.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Sep 3, 2022 at 2:21 PM Alexander Aring <aahringo@redhat.com> wrote:
...
>
> Assume you always get an ack back until somebody implements this
> feature in their driver (It's already implemented so as they return
> TX_SUCCESS). We cannot do much more I think... it is not robust but
> then somebody needs to update the driver/firmware.
>
> It's more weird if the otherside does not support AACK, because ARET
> will send them 3 times (by default) the same frame. That's why we have
> the policy to not set the ackreq bit if it's not required.
>
> > What is your "less worse" choice?
> >
> > > Btw: I can imagine that hwsim "fakes" such
> > > offload behaviours.
> >
> > My current implementation actually did handle all the acks (waiting for
> > them and sending them) from the MAC. I'm currently migrating the ack
> > sending part to the hw. For the reception, that's the big question.
> >
>
> In my opinion we should never deal with ack frames on mac802154 level,
> neither on hwsim, this is an offloaded functionality. What I have in

* except of course in cases of monitors, but monitors really aren't
part of the network and they are sniffers... A monitor can indeed send
frames out, which could cause a lot of trouble in the network if you
want to. It's a playground thing to do experiments... Here we never
analyze any payload received and forward it directly to the user, it's
also a kind of kernel bypass. I know people run some user space stacks
with it (including myself) but they get problems until it gets into
e.g. ackknowledge handling.

- Alex

