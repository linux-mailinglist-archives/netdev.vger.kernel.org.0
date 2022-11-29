Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C50A63CB2D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 23:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiK2WtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 17:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236589AbiK2WtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 17:49:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7091F9DA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669762105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HGikrnX364rCVWywnwVxKwVfVWGtIZ6vltliqWh6T0Y=;
        b=QkbtcaUs6jofWqyQNxcPhO8cZdTiY4ArBcOcNAxY26K8HCUwrR8vNg4FD+tUxj+aRFAxw8
        Xe66iKljN4Ehpmm9PcW8kRIuu0fvub0ZjgfXk1RAKhsd+AmSeURnpdlrMBN7msB9WEGmfu
        Ip2fTNLVXqsAed8aPO71iJGxhEoHvK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-jPivghd9PsO6geSKUF7Vmw-1; Tue, 29 Nov 2022 17:48:19 -0500
X-MC-Unique: jPivghd9PsO6geSKUF7Vmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBC1A84ACA0;
        Tue, 29 Nov 2022 22:48:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.50.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC26F140EBF5;
        Tue, 29 Nov 2022 22:48:09 +0000 (UTC)
Message-ID: <8b11568a8022cdb759a43f34fdcddf33d9abc37c.camel@redhat.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
From:   Dan Williams <dcbw@redhat.com>
To:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Date:   Tue, 29 Nov 2022 16:48:07 -0600
In-Reply-To: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
References: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-11-23 at 16:40 +0100, Nicolas Cavallari wrote:
> On 23/11/2022 13:46, Greg Kroah-Hartman wrote:
> > The Microsoft RNDIS protocol is, as designed, insecure and
> > vulnerable on
> > any system that uses it with untrusted hosts or devices.  Because
> > the
> > protocol is impossible to make secure, just disable all rndis
> > drivers to
> > prevent anyone from using them again.
> > 
> > Windows only needed this for XP and newer systems, Windows systems
> > older
> > than that can use the normal USB class protocols instead, which do
> > not
> > have these problems.
> > 
> > Android has had this disabled for many years so there should not be
> > any
> > real systems that still need this.
> 
> I kind of disagree here. I have seen plenty of android devices that
> only 
> support rndis for connection sharing, including my android 11 phone 
> released in Q3 2020. I suspect the qualcomm's BSP still enable it by 
> default.
> 
> There are also probably cellular dongles that uses rndis by default. 
> Maybe ask the ModemManager people ?

Yes, there are.

Another class of WWAN dongles presented as USB RNDIS to the host, had
an onboard DHCP server, and "bridged" that (for lack of a better term)
to the WWAN. And like a home router exposed HTTP based management on
192.168.1.1 to control the WWAN stuff.

https://openwrt.org/docs/guide-user/network/wan/wwan/ethernetoverusb_rndis

RE Wifi, (echoing Johannes) there was one Broadcom chipset, but a bunch
of devices used it. I have some though I don't actively use them. But
they still work...

Dan

> 
> I'm also curious if reimplementing it in userspace would solve the 
> security problem.
> 

