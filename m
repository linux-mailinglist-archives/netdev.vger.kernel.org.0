Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32E5552DCF
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbiFUJEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348663AbiFUJEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:04:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AB452ADA
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655802242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4v/xsZfnpHEZjghYZP8IP5iojWdhdQsyIaATEz+29Jo=;
        b=cVks5mEmapTsOBwYyJXGlX86KZT5Y+YrKVH+m4gmjqmySkTiAe/NiFQR1EYdjr1hCrygeH
        zp+WBP75HvuCyrjAV5vcL8n9LDbxqsSIbEo+xnHUJC+XC+TbubGYG0OeoWmmLXaMGd4FQy
        Z/PaHsv1sRSAvFCES1xwoeZoucY7pTs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-8ux_r7lANHCGUndcqlVigQ-1; Tue, 21 Jun 2022 05:04:00 -0400
X-MC-Unique: 8ux_r7lANHCGUndcqlVigQ-1
Received: by mail-wr1-f71.google.com with SMTP id ck13-20020a5d5e8d000000b0021b984d1565so268253wrb.10
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4v/xsZfnpHEZjghYZP8IP5iojWdhdQsyIaATEz+29Jo=;
        b=TlQq2DLDOwyuNbxDs88lIRwHi59PiRcxQG8Tx9ANOBcsLbS68m1LvmdZS0NaQws7fu
         Sra0AVmTKw2txw+zwIj/lPCFmL7VNpUWzU9ln2durU+kdxtU4ajG1l2dHcT1iLwmTJ8h
         0H3auGls0TCg3Az1rjyPZh8foklVhhobm2+WiqmoCOyWaflQccUybVCZAIdtKlfNwa/o
         5K6ORTw72Jw6MQIjcyxN/ltFTrWKSnNRfbm4vHUuOEXitsAeYsp9op3IX/8cA6Pq/G/J
         Vg9sODm5a6HYUjbo0so1Gdq0CnAjOak6dxzUHvABoX5hzerWJ1teSf01/80LEIYk8P2c
         RyqQ==
X-Gm-Message-State: AJIora9cfUZiLt1eyWxD4npKIKsPqoWDp5TBmJNPXEBIR0k0KCJM+TlN
        0fOvxGnuWeLfmuJ2BNM0Z0eZaCpoNwHwUIxfuM6RZHIP3fAh7iu8vQEcc8kduoFiIiFuQkf4gkW
        9YXLs1kFkToXwFE3M
X-Received: by 2002:a5d:5966:0:b0:21b:80b5:ecc3 with SMTP id e38-20020a5d5966000000b0021b80b5ecc3mr20352671wri.130.1655802239367;
        Tue, 21 Jun 2022 02:03:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uAo0I0LVW5yEUX2oJr5NIPQTG5ocShGC//OdCxZGK956uMHy4q7o2dO7gTusFePUAe4kZI+w==
X-Received: by 2002:a5d:5966:0:b0:21b:80b5:ecc3 with SMTP id e38-20020a5d5966000000b0021b80b5ecc3mr20352654wri.130.1655802239156;
        Tue, 21 Jun 2022 02:03:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id n17-20020a5d4c51000000b0021b962f4256sm1846114wrt.80.2022.06.21.02.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:03:58 -0700 (PDT)
Message-ID: <8cd9e84dabcf2efbf80f3bc43326bbea8bd21a98.camel@redhat.com>
Subject: Re: [PATCH v2] net: usb: ax88179_178a: ax88179_rx_fixup corrections
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jose Alonso <joalonsof@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 21 Jun 2022 11:03:57 +0200
In-Reply-To: <72d0a65781b833dd3b93b03695facd59a0214817.camel@gmail.com>
References: <24289408a3d663fa2efedf646b046eb8250772f1.camel@gmail.com>
         <6dacc318fcb1425e85168a6628846258@AcuMS.aculab.com>
         <72d0a65781b833dd3b93b03695facd59a0214817.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-20 at 22:18 -0300, Jose Alonso wrote:
> On Mon, 2022-06-20 at 03:45 +0000, David Laight wrote:
> > 
> > > -                       ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
> > 
> > You've 'lost' this lie.
> > IIRC the 'skb' are allocated with 64k buffer space.
> > I'm not at all sure how the buffer space of skb that are cloned
> > into multiple rx buffers are supposed to be accounted for.

I agree that correct memory accounting here is not trivial. I think you
should restore the 'truesize' assignment.

Possibly a slightly more accurate adjustment would be:

	/* for last skb */
	skb->truesize = SKB_TRUESIZE(pkt_len_buf);

	/* for other skbs */
	skb->truesize = pkt_len_buf + SKB_DATA_ALIGN(sizeof(struct sk_buff);

> 
Thanks!

Paolo

