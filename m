Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE99C63F219
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 14:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiLAN4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 08:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiLAN4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 08:56:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407F51EAFC
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 05:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q2BKkuspfzaEs1qSoUtOA7ZZ4a78lTB3KCur/PIqHwE=;
        b=LqXlGXddivlSFQJAG4BJzVvkL4mk0vhEJV1kjAjADHTZETocHjJyQVK3ExCH3TDoPqA4Vg
        SgNKUCVSn0KkUZG6QVdUuCmaEr0878cx+hdzMhwbm3VQBg+YNzadWHe2ADY/+xW5hqaE7W
        DM7nP3lx9DRnbCW+SqR7QTWzmUiBVxA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-yKeTKsWBMQyO4cLv0EjzHA-1; Thu, 01 Dec 2022 08:55:04 -0500
X-MC-Unique: yKeTKsWBMQyO4cLv0EjzHA-1
Received: by mail-io1-f71.google.com with SMTP id f3-20020a5ec703000000b006dfc19c6378so1585708iop.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 05:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q2BKkuspfzaEs1qSoUtOA7ZZ4a78lTB3KCur/PIqHwE=;
        b=ieDqSwv6nVxXf0esidpfXV/UG0aQlFvF2tuFup13DUR5sFfk37W7xNDqlnNs/waFLq
         e4GQcY6FhqLVgoWYnHxNNNUPBnGDli1nJZ8XXYLOGREoWkpPp+jeqbP64vyb9CXU14AJ
         ir6R6s9SD5kC66NXrMsXyqfAxGvEojwf3VMeA7KmAkcjqYov3LFr8FTpTAN+PV3/hwWf
         HrnEjWecZpIENmlnwzi4ZGjJhRGWnfiAGyu+uGWUBFJe8FQwqi4wUC5XDnzXmhKdfXaz
         ghteRGlKZtFQC7TpJ8Mojsw7I3BaqyWmlCHcOPmuNYMgNKtiTCw92IXJUyBcTeFXKdwD
         PyLg==
X-Gm-Message-State: ANoB5plvfElz/j4gdQMwRR66iSRd5YYbdjK4yC68+UckG+8pI/ILb+xt
        ZmR7VO31hZkPWPo1uSYPKk2mjvuPipRGSz1PBAUPsfiQL2oblLm8nA3ebT15k1+k8kQ4T0LSvy9
        x81lHgTibRgTQAOm6
X-Received: by 2002:a02:6202:0:b0:376:91d:b188 with SMTP id d2-20020a026202000000b00376091db188mr31354391jac.49.1669902903765;
        Thu, 01 Dec 2022 05:55:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6f+zMmFejFa7H5SbKq8y0kuY/dgAPTlCDteiRUq7+DZpnAX8KlbGN1sO5K3anDocH/3wHXpQ==
X-Received: by 2002:a02:6202:0:b0:376:91d:b188 with SMTP id d2-20020a026202000000b00376091db188mr31354383jac.49.1669902903504;
        Thu, 01 Dec 2022 05:55:03 -0800 (PST)
Received: from x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id l6-20020a05660227c600b006cfdf33825asm1652098ios.41.2022.12.01.05.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 05:55:03 -0800 (PST)
Date:   Thu, 1 Dec 2022 08:55:01 -0500
From:   Brian Masney <bmasney@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cth451@gmail.com
Subject: Re: [EXT] Re: [PATCH] net: atlantic: fix check for invalid ethernet
 addresses
Message-ID: <Y4iyNRhkFmG/Avco@x1>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch>
 <Y4fGORYQRfYTabH1@x1>
 <Y4fMBl6sv+SUyt9Z@lunn.ch>
 <7ed83813-0df4-b6ac-f1d2-a28d8011b1aa@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ed83813-0df4-b6ac-f1d2-a28d8011b1aa@marvell.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 09:07:49AM +0100, Igor Russkikh wrote:
> 
> >> That won't work for this board since that function only checks that the
> >> MAC "is not 00:00:00:00:00:00, is not a multicast address, and is not
> >> FF:FF:FF:FF:FF:FF." The MAC address that we get on all of our boards is
> >> 00:17:b6:00:00:00.
> > 
> > Which is a valid MAC address. So i don't see why the kernel should
> > reject it and use a random one.
> > 
> > Maybe you should talk to Marvell about how you can program the
> > e-fuses. You can then use MAC addresses from A8-97-DC etc.
> 
> Hi Brian,
> 
> I do completely agree with Andrew. Thats not a fix to be made in
> linux kernel.
> 
> The boards you get have zero efuse. You should work with Qualcomm on
> how to update mac addresses of your boards.

OK, I'll work to track down someone within Qualcomm that can help us
program the MAC address into the boards that we have. In the mean time,
we'll go with the systemd unit approach to set a MAC address.

Thank you all!

Brian

