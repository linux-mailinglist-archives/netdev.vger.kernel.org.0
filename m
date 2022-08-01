Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F0B587495
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiHAXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiHAXyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 127AF2654D
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659398075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tSd2NToDUTYIW2AcecmoPejo8WOBiujwBj5FJkpTbYU=;
        b=iGvvPM5jf2YnyiA8WD5z34OJnaTeU1dOymXmCxNAllqMG/PCZ9jbfWeBNVnAJ3TYC+yfde
        vWxsfHlNcYgfzqN82jBBdSDdbbGvqFAXRDmsmPf7pIiBODxK/aqHknunFT8oqjuG8GIpId
        OnNaKjyNNTy3Nqeb7iaJhAaJjFR32m0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-ub2ykVwlNOWXIQ8os-xx_g-1; Mon, 01 Aug 2022 19:54:33 -0400
X-MC-Unique: ub2ykVwlNOWXIQ8os-xx_g-1
Received: by mail-qt1-f199.google.com with SMTP id bp9-20020a05622a1b8900b0033921a622ccso458254qtb.23
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 16:54:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tSd2NToDUTYIW2AcecmoPejo8WOBiujwBj5FJkpTbYU=;
        b=f6NDYKr4tbDcRocBcu3Z0ZwHtiAfCuult9rqZjOAcFOnV98eBVyKlM9BMb164zgRnE
         EIDzT7O51WQugT3xmjbc/GxYqZzX2Tk6pYmDlCFtkKvhAtnS7S1GBfdBl2Y9WL5Y8wXa
         5hCWatnns9TP9zjgewuxps5GcvxmViVVFR/xu0AscazQWfsfjwcsaddtyHxG/hzXxgkp
         4OFvVeMA5HxLOZJUARyuJTz3PPtf0yvoHKuOTBQtv6N8PzDLEF8Bt2ChYlkXyKRDjz4t
         4MB0tWEAWGikSx6BQXzoshPbD431G5+jQkzuS4jYd8KklCEYaLoZ8fzLicPv2VArwi1J
         Pfng==
X-Gm-Message-State: AJIora9BQxT9swK6tnrZz6TgWEf3TZyqoa6lVViwOOwifz0KFXdAxa33
        UvVUhwlfNk6/W9rROKYB1JHoiCq/GLnFO6LPpF/Xl4okV1eRUMW/1lIy2i3gmI6vVdTD8fE6b2v
        zhq6BJxwx6HPORe1wJMrsbWIe7Cdw22of
X-Received: by 2002:a05:620a:469f:b0:6b6:74c:6b10 with SMTP id bq31-20020a05620a469f00b006b6074c6b10mr13301093qkb.80.1659398073459;
        Mon, 01 Aug 2022 16:54:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t1dUKdB2V8yJxCMGiTgXeqFVeuGKKwF839fo9VSL8FWjh9Ho2U0KH9YQgAXoOlvRC8KmDdBJMOh48eagRFjfM=
X-Received: by 2002:a05:620a:469f:b0:6b6:74c:6b10 with SMTP id
 bq31-20020a05620a469f00b006b6074c6b10mr13301075qkb.80.1659398073267; Mon, 01
 Aug 2022 16:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-11-miquel.raynal@bootlin.com> <CAK-6q+giwXeOue4x_mZK+qyG9FNLYpK6T5_L1HjaR6zz2LrW-A@mail.gmail.com>
 <CAK-6q+j7MGuHmQtMm8bHzV5WhsSgx=wntWuQUf+MWpa1VZ7NYg@mail.gmail.com>
In-Reply-To: <CAK-6q+j7MGuHmQtMm8bHzV5WhsSgx=wntWuQUf+MWpa1VZ7NYg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 1 Aug 2022 19:54:22 -0400
Message-ID: <CAK-6q+ihyGycUAOcF-UWs49YAtJi3so-aaRAodsD6ikxuhpX=Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next 10/20] net: mac802154: Handle passive scanning
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 1, 2022 at 7:42 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Thu, Jul 14, 2022 at 11:33 PM Alexander Aring <aahringo@redhat.com> wrote:
> ...
> >
> > I know some driver datasheets and as I said before, it's not allowed
> > to set promiscuous mode while in receive mode. We need to stop tx,
> > what we are doing. Then call stop() driver callback,
> > synchronize_net(), mac802154_set_promiscuous_mode(...), start(). The
> > same always for the opposite.
> >
>
> I think we should try to work on that as a next patch series to offer
> such functionality in which "filtering level" the hardware should be
> "started". As I said it cannot be changed during runtime as
> "transceiver is being in receive mode" but there is the possibility to
> stop/start the hardware _transparent_ from the user to change the
> "filtering level". I say filtering level because I think this is what
> the standard uses as a term. The one which is needed here is
> promiscuous mode, otherwise yea we usually use the highest filtering
> level. When changing the "filtering level" it depends on interface
> type what we need to filter in softmac then and what's not. One thing
> in promiscuous mode and everything else than monitor is to check on if
> the checksum is valid and drop if necessary, same for address
> filtering, etc. I don't assume that the software filtering is 100%

forget the address filtering, this is only required when it operates
in non scan mode. It always depends, however you don't need to
implement it if it's not necessary. I think we should somehow get a
per parameter at receive path to know on which filtering level it was
received, then more handling in regarding which receive path it goes
can be made, e.g. if frame xy was received in promiscuous mode. For
scan you don't need to check address filter but checksum, other
receive path have different requirements (not saying that those exists
right now but may in future).

- Alex

