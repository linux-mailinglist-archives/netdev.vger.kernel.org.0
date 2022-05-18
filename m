Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2530852BEA3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiEROcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238575AbiEROcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE81513C344
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652884328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4NxmFDuLsapwzf8QkP6j59BYhx83cNJvECfwJ8BgydY=;
        b=DC7qIgBVXrrbcF8ZdTqEASrTzt3RrYCZYYf7OG1m67WG8zEsgvBTS19W3rOgDASW4l2Q/y
        DDWYuUfti1MDk4c+llOA0tPBB0z6ozpvD6pnkzknY8icLJnnRJWqBAdjf1Q+3yXroJi/nL
        nAGm6VAo3dOEXGxXyuU4v5l9IZG0KNY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-DALA_E7DMCyuH6EHdmfOkg-1; Wed, 18 May 2022 10:32:06 -0400
X-MC-Unique: DALA_E7DMCyuH6EHdmfOkg-1
Received: by mail-qk1-f199.google.com with SMTP id v14-20020a05620a0f0e00b00699f4ea852cso1694399qkl.9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NxmFDuLsapwzf8QkP6j59BYhx83cNJvECfwJ8BgydY=;
        b=Rv/SkNUoOld3uR8Zn7UpGH8RrLigY/GXmjjvNm/JeRsF29cXgePILye6Jkests7rFW
         bsI7F4BS6HN0tk7YGibq5iHYf6Ne9rgCMGTOt+7AFPcP8U4XhObHkZtOG2mgGR1AtUm0
         eT5n7vpCCQse22TUJhpsxHDyAHoikkKZgc79eCBdWysvrC3munQqNkL0NOY/5w1jomGN
         twuwZXXy89u8E4aTV4rtdbPEw6UcJEyBZeyWbJvzAiszBUfZ7u3c1Jgm1R+HB4CsHN++
         P83r9+FvYBzfkmgfW1ibWlXXag5O/gyUzGoGkWeiBCmZeAfg1RKpw79M8z/2VYP2C2c9
         onnw==
X-Gm-Message-State: AOAM532U8chVT7Rl2UrjpAq5yNSMbPthDr3WLHL2J3fqWbSi9sgaUoAu
        seFiktdrZY2Ex9LvGBSzHhwi/rf2vTnG10FPKW0jgKqFVU/vqOLN6g/k+h5VkSTRPd3gxLhVB5d
        UCflMXOCN6pJQ4fu8xvfrscQn9guLxWfR
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id a9-20020a0562140c2900b0045afedd7315mr24543811qvd.59.1652884326223;
        Wed, 18 May 2022 07:32:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb1Kg3lD6H71VYLEttsjoNdAC0Ho2U3IqJWBUvNtS6gjTzCGNPFbzEFH6DxKTolRYZO9rcaqyI+bZUmkrz2pc=
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id
 a9-20020a0562140c2900b0045afedd7315mr24543779qvd.59.1652884326024; Wed, 18
 May 2022 07:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
 <20220517163450.240299-11-miquel.raynal@bootlin.com> <CAK-6q+g=9_aqTOmMYxCn6p=Z=uPNyifjVXe4hzC82ZF1QPpLMg@mail.gmail.com>
 <20220518105543.54cda82f@xps-13>
In-Reply-To: <20220518105543.54cda82f@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 18 May 2022 10:31:55 -0400
Message-ID: <CAK-6q+j-EgoO-mWx_zRrORmA9-75h_=_fh22KMxySdSgeLsJEA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 10/11] net: mac802154: Add a warning in the
 hot path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 18, 2022 at 4:55 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
>
> aahringo@redhat.com wrote on Tue, 17 May 2022 20:58:19 -0400:
>
> > Hi,
> >
> > On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote:
> > >
> > > We should never start a transmission after the queue has been stopped.
> > >
> > > But because it might work we don't kill the function here but rather
> > > warn loudly the user that something is wrong.
> > >
> > > Set an atomic when the queue will remain stopped. Reset this atomic when
> > > the queue actually gets restarded. Just check this atomic to know if the
> > > transmission is legitimate, warn if it is not.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/cfg802154.h |  1 +
> > >  net/mac802154/tx.c      | 16 +++++++++++++++-
> > >  net/mac802154/util.c    |  1 +
> > >  3 files changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > index 8881b6126b58..f4e7b3fe7cf0 100644
> > > --- a/include/net/cfg802154.h
> > > +++ b/include/net/cfg802154.h
> > > @@ -218,6 +218,7 @@ struct wpan_phy {
> > >         spinlock_t queue_lock;
> > >         atomic_t ongoing_txs;
> > >         atomic_t hold_txs;
> > > +       unsigned long queue_stopped;
> >
> > Can we name it something like state_flags (as phy state flags)? Pretty
> > sure there will be more coming, or internal_flags, no idea...
> > something_flags...
>
> 'phy_flags'? Just 'flags', maybe?

make it so.

- Alex

