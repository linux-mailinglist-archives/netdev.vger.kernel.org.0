Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D958C6E4700
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDQMBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQMBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:01:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BA85FF9
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681732653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2LRp3zjh0DOhKKwcTJt+220dZY+oP35RdJVHgXAQvQE=;
        b=BIdxuxHyTFxm1K0PUlMnZNY6Yc8h9GMQlYr8RvX/FaCz2NKrC9y03X+dGBIo7tH5A+nHfr
        6reM9Ufab3wc23/g4AvkxJRl7dlnPIpE0HEcLJsphTkniadHRkKy0ZBTwTB/xByGPuGnhA
        Yowi/zBE8+WlrnATd8kf+87SNTM05Rc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-9c0rThByMF-NMW1bck5MGA-1; Mon, 17 Apr 2023 07:57:29 -0400
X-MC-Unique: 9c0rThByMF-NMW1bck5MGA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5067d65c251so1398657a12.2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681732648; x=1684324648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LRp3zjh0DOhKKwcTJt+220dZY+oP35RdJVHgXAQvQE=;
        b=J6joncefghQDV0vPjEiAvLnZP10JvE+hUF8r/PDACOP2/JP9/xm2GN8ZFD6xHG2CtS
         jIciSwA8iU+/SeA4kbo/t42hT30AhLBOqdtD+SSASJvcE/AoeaSejGQDTcGiGTd6vU8K
         /UCTslPnTDcw1FY3KxV1WV8dHCE5mckzsWAs+azObKadBGxnnoWfjFOM+smfCg4LIZUX
         WH/djd2iTKHzrFeuPGm3dQ/uutH+kGW8+ryNNk/MJv54f9ImuEyX1z5wBzkNulbepguB
         TnfEA3clpkf9WvTxFrf5kYEWBMB1LuSvnycbVorJmxhjgt0jZKl96AMAp2b1uO/JGtA8
         4g/g==
X-Gm-Message-State: AAQBX9fX+UAyaq4iIses8KiCgF3JNRAWdxSiVGTVUJoOvmbkZXIjVEQS
        R6iq9cLa1y+CHvCMSxRS1u4IX2uF3drEjOeBB99dCiur97tYOZjBJwm3DIcuGDpDu1IFDuo7eQB
        ubEE/naYNdKPJjm0F
X-Received: by 2002:a05:6402:1154:b0:506:83f7:157b with SMTP id g20-20020a056402115400b0050683f7157bmr10206148edw.10.1681732648814;
        Mon, 17 Apr 2023 04:57:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350aNKgY4zPoooD46Q25GLFK8yAqcM6inydsLa/BdAONuep0Wjoauz5/ie895Qh5ZYK7I0H0Nfg==
X-Received: by 2002:a05:6402:1154:b0:506:83f7:157b with SMTP id g20-20020a056402115400b0050683f7157bmr10206139edw.10.1681732648606;
        Mon, 17 Apr 2023 04:57:28 -0700 (PDT)
Received: from redhat.com ([2.52.136.129])
        by smtp.gmail.com with ESMTPSA id n23-20020a056402061700b005068f46064asm3426009edv.33.2023.04.17.04.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 04:57:28 -0700 (PDT)
Date:   Mon, 17 Apr 2023 07:57:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230417075645-mutt-send-email-mst@kernel.org>
References: <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:51:22AM +0000, Alvaro Karsz wrote:
> > > I see your point.
> > > Regardless, we'll need to fail probe in some cases.
> > > ring size of 1 for example (if I'm not mistaken)
> > 
> > Hmm. We can make it work if we increase hard header size, then
> > there will always be room for vnet header.
> > 
> > > control vq even needs a bigger ring.
> > 
> > Why does it?
> 
> At the moment, most of the commands chain 3 descriptors:
> 1 - class + command
> 2 - command specific
> 3 - ack
> 
> We could merge 1 and 2 into a single one, both are read only for the device, so I take it back, it won't need a bigger ring.
> But it will need 2 descriptors at least(1 read only for the device and 1 write only for the device), so we still need to fail probe sometimes.
> 

Yes that makes sense, it's architetural. We can disable ctrl vq though.

-- 
MST

