Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432223E9632
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhHKQkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:40:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229819AbhHKQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628700007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u63HNp6/QtMaAR+WssqnWCaQvdnhIjzKRkK0ogRXtPU=;
        b=My8UfjJI13ecirHrXyGwEDR8tsgDvyt4YefiCDeKeibE53D2UMc0NDo+qq7s4HzjMSHmwN
        pJ3/nYsBGAXDUs+DGOdcRJI8lVvWt8C+o7N9GpMtwFGQy9IH0nnQBQyEIZ82LzCbncsA0s
        XgbpoiGGus+cZnM0W6tdZQJjmKOUXOA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-rVrurOkNOAqtc7AZKxoQgg-1; Wed, 11 Aug 2021 12:40:05 -0400
X-MC-Unique: rVrurOkNOAqtc7AZKxoQgg-1
Received: by mail-wm1-f72.google.com with SMTP id b196-20020a1c80cd0000b02902e677003785so2271395wmd.7
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=u63HNp6/QtMaAR+WssqnWCaQvdnhIjzKRkK0ogRXtPU=;
        b=GGxlGJ/p2H+lQOCt+hr/aV94XTRJzBZHtUpD9aoz+Pore52MZUoWe6z6lh90yEodIk
         ztGRehjj0kCXOxH8/pA1TwRq6awmuS9OZS79E9RG7GsdyFcmaYOINhzm9rpwc7f4g3Ym
         PXGLATLMkJYvRq9c5J6TBj0psMQW1fvgNzmuv07r7xXIsCZ+cYifbo3RMLvtMXfJy5gS
         s15yLSe8yQj9koKRpNKTOLOMXHA4SdEZPln83lxv0BuYMPlBa9DmMbl80EZsGmskDbra
         t4XvYUZ7zeSquM54woP87gWA8wZ+hrM6ZVk+zEib0SphNz/Cx6yXB0YGJiKIxyRYhw+6
         KzCA==
X-Gm-Message-State: AOAM532tsu5mdiYaOPmeFXgSO4efHmbh9nXDjgf6/z+Ke/q3rUX33n4D
        dHzEuWq4r4XR6ygLRt3bDzesNC0hgxrfIJfMJogFLrHRJZZye3a0hL+wF+fr0SLXt7mSguaEE3t
        JQUqCiIEM1gBOhhD9
X-Received: by 2002:a1c:751a:: with SMTP id o26mr12895397wmc.94.1628700004400;
        Wed, 11 Aug 2021 09:40:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiBajL2VPPdnqoTAGj/QWW0XxOnsvTNG6Yb6XPrvxaWyyvFStg6KW79RXml6rjkVRMfDw4ew==
X-Received: by 2002:a1c:751a:: with SMTP id o26mr12895386wmc.94.1628700004238;
        Wed, 11 Aug 2021 09:40:04 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z126sm21647754wmc.11.2021.08.11.09.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:40:03 -0700 (PDT)
Date:   Wed, 11 Aug 2021 18:40:01 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <20210811164001.GA15488@pc-32.home>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com>
 <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
 <2B54E919-1263-4AD2-B37C-6B1F24211D77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2B54E919-1263-4AD2-B37C-6B1F24211D77@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 09:27:14PM +0300, Martin Zaharinov wrote:
> Add Guillaume Nault
> 
> > On 9 Aug 2021, at 18:15, Pali Rohár <pali@kernel.org> wrote:
> > 
> > On Sunday 08 August 2021 18:29:30 Martin Zaharinov wrote:
> >>>>>> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>>>> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: ioctl(PPPIOCCONNECT): Transport endpoint is not connected

The PPPIOCCONNECT ioctl returns -ENOTCONN if the ppp channel has been
unregistered.

From a user space point of view, this means that accel-ppp establishes
PPPoE sessions, starts negociating PPP connection parameters on top of
them (LCP and authentication) and finally the PPPoE sessions get
disconnected before accel-ppp connects them to ppp units (units are
roughly the "pppX" network devices).

Unregistration of PPPoE channels can happen for the following reasons:

  * Changing some parameters of the network interface used by the
    PPPoE connection: MAC address, MTU, bringing the device down.

  * Reception of a PADT (PPPoE disconnection message sent from the peer).

  * Closing the PPPoE socket.

  * Re-connecting a PPPoE socket with a different session ID (this
    unregisters the previous channel and creates a new one, so that
    shouldn't be the problem you're facing here).

Given that this seems to affect all PPPoE connections, I guess
something happened to the underlying network interface (1st bullet
point).

