Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C18398A1F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFBM5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhFBM5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:57:52 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986A9C061574;
        Wed,  2 Jun 2021 05:56:09 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1loQPl-0013QI-0O; Wed, 02 Jun 2021 14:56:05 +0200
Message-ID: <2dbf474b0a0358627d12b1949ff98b9022943d76.camel@sipsolutions.net>
Subject: Re: [RFC 3/4] wwan: add interface creation support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com
Date:   Wed, 02 Jun 2021 14:56:04 +0200
In-Reply-To: <CAHNKnsQh7ikP4MCB0LhjpdqkMTjWq2ByWG4wToaXgzteYjUQaQ@mail.gmail.com> (sfid-20210602_144554_521105_C70F7C7C)
References: <20210601080538.71036-1-johannes@sipsolutions.net>
         <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
         <CAHNKnsRv3r=Y7fTR-kUNVXyqeKiugXwAmzryBPvwYpxgjgBeBA@mail.gmail.com>
         <15e467334b2162728de22d393860d7c01e26ea97.camel@sipsolutions.net>
         <CAHNKnsQh7ikP4MCB0LhjpdqkMTjWq2ByWG4wToaXgzteYjUQaQ@mail.gmail.com>
         (sfid-20210602_144554_521105_C70F7C7C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> > The only thing I'd be worried about is that different implementations
> > use it for different meanings, but I guess that's not that big a deal?
> 
> The spectrum of sane use of the IFLA_PARENT_DEV_NAME attribute by
> various subsystems and (or) drivers will be quite narrow. It should do
> exactly what its name says - identify a parent device.

Sure, I was more worried there could be multiple interpretations as to
what "a parent device" is, since userspace does nothing but pass a
string in. But we can say it should be a 'struct device' in the kernel.

> We can not handle the attribute in the common rtnetlink code since
> rtnetlink does not know the HW configuration details. That is why
> IFLA_PARENT_DEV_NAME should be handled by the RTNL ->newlink()
> callback. But after all the processing, the device that is identified
> by the IFLA_PARENT_DEV_NAME attribute should appear in the
> netdev->dev.parent field with help of SET_NETDEV_DEV(). Eventually
> RTNL will be able to fill IFLA_PARENT_DEV_NAME during the netdevs dump
> on its own, taking data from netdev->dev.parent.

I didn't do that second part, but I guess that makes sense.

Want to send a follow-up patch to my other patch? I guess you should've
gotten it, but if not the new series is here:

https://lore.kernel.org/netdev/20210602082840.85828-1-johannes@sipsolutions.net/T/#t

> I assume that IFLA_PARENT_DEV_NAME could replace the IFLA_LINK
> attribute usage in such drivers as MBIM and RMNET. But the best way to
> evolve these drivers is to make them WWAN-subsystem-aware using the
> WWAN interface configuration API from your proposal, IMHO.

Right.

johannes

