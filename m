Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2309587484
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiHAXmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiHAXmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6A814330D
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659397341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q0oRGguOnPX0TTD163ZhfwgVWeLoIzqDnSSNj+nC26Y=;
        b=CZ5DNDtBRYD3MXiF5PF300sdV3kixfFwQ9CJjOBKEIgOmsehdz+wQULzFZoh0znS5+404e
        PBte8CvkfTzoDRph6K6kc9Vjf8vLxe08kOfvAUVfUUnEzS9n9HOlReU2V7UbJ578O+2kVf
        AMztQ0yvR+c5Prf6NrmSwaAdzTSHyeg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-VKKsUD-CNNayFSqCp9LXIA-1; Mon, 01 Aug 2022 19:42:20 -0400
X-MC-Unique: VKKsUD-CNNayFSqCp9LXIA-1
Received: by mail-qv1-f70.google.com with SMTP id o9-20020a0cecc9000000b0047491274bb1so5151295qvq.19
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 16:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Q0oRGguOnPX0TTD163ZhfwgVWeLoIzqDnSSNj+nC26Y=;
        b=3yfzJZHzIH8x1T/JsVDcaNa+KpoX7XgTHRn9rP6l8PuVNRwUOP+/ANCYSJ62KYfOVu
         EIsCZwr5DKCyuMQI9NQOgQ11gvRFyd1NxoEWUcHY8m7rA6bmT/HcequJEFmDMNTPp6nr
         NTifEwN43T6sTwV+XehYqwO23XRaRLBnk9YCz9vCHgc9kDKhklV7DQjYWuObm3dDSEh8
         Ur+rND2TFnfhREGwm+vILxM5Mt9lYLGCTu1/BLt0GooAjYZrcfjSbM/su4oJp53s8o4T
         jjn5E260LFOb5sDPWafmoUZcuD/AatfnTLyvsEgNU92CWHjjCQy9cpXauNlu4xB7q6RP
         7s/g==
X-Gm-Message-State: AJIora8TL1QJQcAM3raAjAUqHCTPjU3H+WTxGhd8fspMleIDR7V1scdX
        oIdRmfEbvAMk5YpkhFclnWNRSRq1UDQEUU4/tQX0w8/k2+D3SJ4NDswJTDgYoP9KD4ZuJkqppcc
        FEJgj3PMm+sTMNqXcxrfzzHNqO8KP//1+
X-Received: by 2002:a05:622a:1316:b0:31e:f3b4:1c8c with SMTP id v22-20020a05622a131600b0031ef3b41c8cmr16744824qtk.339.1659397339373;
        Mon, 01 Aug 2022 16:42:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vbJZYXyRcJEnyF8L4b8tDvLVv1K5QQlmIoeGtEOq3JCHbn87oxy5Y5VfkMJ6pOzSSWXmUh01hemlWPmn4UfTI=
X-Received: by 2002:a05:622a:1316:b0:31e:f3b4:1c8c with SMTP id
 v22-20020a05622a131600b0031ef3b41c8cmr16744813qtk.339.1659397339079; Mon, 01
 Aug 2022 16:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-11-miquel.raynal@bootlin.com> <CAK-6q+giwXeOue4x_mZK+qyG9FNLYpK6T5_L1HjaR6zz2LrW-A@mail.gmail.com>
In-Reply-To: <CAK-6q+giwXeOue4x_mZK+qyG9FNLYpK6T5_L1HjaR6zz2LrW-A@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 1 Aug 2022 19:42:08 -0400
Message-ID: <CAK-6q+j7MGuHmQtMm8bHzV5WhsSgx=wntWuQUf+MWpa1VZ7NYg@mail.gmail.com>
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jul 14, 2022 at 11:33 PM Alexander Aring <aahringo@redhat.com> wrote:
...
>
> I know some driver datasheets and as I said before, it's not allowed
> to set promiscuous mode while in receive mode. We need to stop tx,
> what we are doing. Then call stop() driver callback,
> synchronize_net(), mac802154_set_promiscuous_mode(...), start(). The
> same always for the opposite.
>

I think we should try to work on that as a next patch series to offer
such functionality in which "filtering level" the hardware should be
"started". As I said it cannot be changed during runtime as
"transceiver is being in receive mode" but there is the possibility to
stop/start the hardware _transparent_ from the user to change the
"filtering level". I say filtering level because I think this is what
the standard uses as a term. The one which is needed here is
promiscuous mode, otherwise yea we usually use the highest filtering
level. When changing the "filtering level" it depends on interface
type what we need to filter in softmac then and what's not. One thing
in promiscuous mode and everything else than monitor is to check on if
the checksum is valid and drop if necessary, same for address
filtering, etc. I don't assume that the software filtering is 100%
correct, but we should have a basis to adding more filters if
necessary and we found something is missing?

What do you think?

 - Alex

