Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2228852DBEF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243280AbiESRv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243507AbiESRv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:51:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5400D4108;
        Thu, 19 May 2022 10:50:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c12so7870693eds.10;
        Thu, 19 May 2022 10:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kysG7peRaXTE3fgA73ZrEonc9KZUQR5unrMXwy4Uj9o=;
        b=pn44M0nIDsuMrP+dKMwBp+StvLvH/KW2GP14Do100lpmHNtk+ysc58OWASgdR1+akJ
         fY0LjZS4wLYwueIUHhdLFEl3zov9xTzH//jxST0YUBujUvHDOPrt1kNLVTxTDYxwTRH9
         oMuMgLwyeckAaUql+UYP0NPb2MrEgFwJWtiU5FAvUauA4HbhRGXS+YtBa/O87HFyd03y
         TeFsbGQnqNXHycOtiYCsLDPW0J0AklWNJwsiVFMGM1CDmdc7Walm/JjVqv2zsbrmGbj6
         xHXV+jy/1lYqd7zdwgZvaYvWvh9ht7pIEWOeEyP8a35FaCHx/8UKHceUCyznvYrnb/82
         sULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kysG7peRaXTE3fgA73ZrEonc9KZUQR5unrMXwy4Uj9o=;
        b=BP+tuAIkkHwtTluFFmSzeX4SqCmvlRgYOWrZpM/+Ddam9rpkd0ACZqhFvnt7tFUGub
         0ox3BEw4VRvIRK0tnqYYHxWVwdAR4UyReO0WD0ZKU4x9vp8dwr7j+AKO/OfM8Zk4WvKL
         W7hPZXjsEp0T9d1I+TGW1yFtjnVOc4bW8/qLQlhhln/72KH9XM7AP/t1yEPtpz2y0e42
         1IeYOCjzWxaTQnDEGwSr5Msd+OCwl4yVjY1rncp6BOZcoRlxJuu+W8haSAJDMEST5sG/
         Tk9ByGG07/Ae4kQoSvo79K4mvQxLRej92BA7qy9DlSgxM5Cz5Hcis33krWsPMD3Xapuv
         JuMQ==
X-Gm-Message-State: AOAM531nLSIQd2b+GhGvbMqEOjozkepWtCuyEW/EAZ85LTLpmcl9Ei/g
        IrEls02J3DiqowdsBP7iZnk=
X-Google-Smtp-Source: ABdhPJw6pya5WcIeizsK42rhj+Y02NWU0RzLCbDdcr7wWO4603xAXDiNtgA7dkxYpc9hE2OcepQ8tw==
X-Received: by 2002:a05:6402:254f:b0:427:d23c:ac69 with SMTP id l15-20020a056402254f00b00427d23cac69mr6734176edb.314.1652982607175;
        Thu, 19 May 2022 10:50:07 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id r21-20020aa7d595000000b0042aba7ed532sm3043108edq.41.2022.05.19.10.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:50:06 -0700 (PDT)
Date:   Thu, 19 May 2022 20:50:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH net v1 1/2] net: dsa: lantiq_gswip: Fix start index in
 gswip_port_fdb()
Message-ID: <20220519175005.hoborvhfntq3trar@skbuf>
References: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
 <20220517194015.1081632-2-martin.blumenstingl@googlemail.com>
 <20220518114555.piutpdmdzvst2cvu@skbuf>
 <CAFBinCBZ6dDAgC+ZUAPOwTx5=yVfYBYvODs=v+DQzGzeEOeiDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCBZ6dDAgC+ZUAPOwTx5=yVfYBYvODs=v+DQzGzeEOeiDw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 07:58:58PM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
> 
> On Wed, May 18, 2022 at 1:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> [...]
> > The patch, as well as other improvements you might want to bring to the gswip driver
> > (we have more streamlined support in DSA now for FDB isolation, see ds->fdb_isolation)
> > is appreciated.
> Thank you very much for this hint! I was not aware of the
> ds->fdb_isolation flag and additionally I have some other questions
> regarding FDB - I'll send these in a separate email though.
> Also thank you for being quick to review my patches and on top of that
> providing extra hints!

Ok, feel free to ask.
Please note that there's also this discussion with Alvin about FDB
isolation and host filtering which hopefully helped to clear some more
concepts.
https://lore.kernel.org/all/87wnhbdyee.fsf@bang-olufsen.dk/
