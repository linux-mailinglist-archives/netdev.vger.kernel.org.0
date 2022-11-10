Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53E623CC0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiKJHiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiKJHiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:38:05 -0500
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3744C326F4
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 23:38:03 -0800 (PST)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 9A1A660116
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:38:02 +0900 (JST)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 0559B60105
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:38:01 +0900 (JST)
Received: by mail-pj1-f71.google.com with SMTP id mh8-20020a17090b4ac800b0021348e084a0so2946047pjb.8
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 23:38:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCjb7yV/CvXMOFsUMLrHBUd25VG/nQ2JHyjPko2pBBA=;
        b=uyKWX0gfthHveQ2i9tZkb6pap3dT8D1krSoRLX9xZXbxTo5aKjvqrD9wn9aXSQFg3K
         i8A8s6SrhKVl3lMkKhnWM0p6pg6fEUmVqy6hlFDRmSpNpZjCE+LZqWuJe7mKcRRmYTUl
         gtxHwD0fQJi+sqd0VsTnZ/mFEuhEg1Qtrag4aTIYvKSfeUrx0VC2m2tA0338/fn+LX3d
         nGWhWNiAqg/sCTXy0ZRQlkoEi9eVm8JXOgxAf7Qi0iArLbq+eS898h1D+gO3xbpwWYyu
         rgVO34jNkWTG3iP2BA8mn45FmJw13AnGQF8lH+VGTM/un8dvztwkuTP6SUrVDOYwt5A2
         pzrQ==
X-Gm-Message-State: ACrzQf0+xI3FtI+Jb4/Ml6tKGV/l608U58YbTF/mvAdWcsBzM6pekwTs
        GaiLsOr9/h+wh68R3Qg6wbKQrGF43GBs1tR9b6mEiE48/HSCA4wP94h1KpRTGgtJA5wE/Feo4MC
        IZzDjKuHaK/RW+TPMn/KT
X-Received: by 2002:aa7:83c8:0:b0:56d:8e07:4618 with SMTP id j8-20020aa783c8000000b0056d8e074618mr51964652pfn.33.1668065880059;
        Wed, 09 Nov 2022 23:38:00 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5Lb2t86EbMFW9ZQ3kwu22IuMxG74UdO/YAYM+jzqoI78XZoQm20kFTU/Woblan8jqfRmomqA==
X-Received: by 2002:aa7:83c8:0:b0:56d:8e07:4618 with SMTP id j8-20020aa783c8000000b0056d8e074618mr51964632pfn.33.1668065879804;
        Wed, 09 Nov 2022 23:37:59 -0800 (PST)
Received: from pc-zest.atmarktech (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902ebd200b00176b63535adsm10381193plg.260.2022.11.09.23.37.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Nov 2022 23:37:59 -0800 (PST)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1ot28M-001gKL-0J;
        Thu, 10 Nov 2022 16:37:58 +0900
Date:   Thu, 10 Nov 2022 16:37:47 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings
 for hci_h4
Message-ID: <Y2yqSxldXPdmkCpW@atmark-techno.com>
References: <CAL_JsqKCb2ZA+CLTVnGBMjp6zu0yw-rSFjWRg2S3hA7S6h-XEA@mail.gmail.com>
 <6a4f7104-8b6f-7dcd-a7ac-f866956e31d6@linaro.org>
 <Y2rsQowbtvOdmQO9@atmark-techno.com>
 <Y2tW8EMmhTpCwitM@atmark-techno.com>
 <20221109220005.GA2930253-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221109220005.GA2930253-robh@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring wrote on Wed, Nov 09, 2022 at 04:00:05PM -0600:
> Punting the issue to userspace is not a great solution...

I can definitely agree with that :)

Userspace has the advantage of being easy to shove ugly things under the
rug, whereas I still have faint hope of keeping down the divergences we
have with upstream kernel... But that's about it.

If we can work out a solution here I'll be very happy.


Rob Herring wrote on Wed, Nov 09, 2022 at 04:00:05PM -0600:
> > This actually hasn't taken long to bite us: while the driver does work,
> > we get error messages early on before the firmware is loaded.
> > (In hindsight, I probably should have waited a few days before sending
> > this...)
> > 
> > 
> > My current workaround is to return EPROBE_DEFER until we can find a
> > netdev with a known name in the init namespace, but that isn't really
> > something I'd consider upstreamable for obvious reasons (interfaces can
> > be renamed or moved to different namespaces so this is inherently racy
> > and it's just out of place in BT code)
> 
> Can't you just try to access the BT h/w in some way and defer when that 
> fails?

This is just a serial link; I've tried poking at it a bit before the
firmware is loaded but mostly never got any reply, or while the driver
sometimes got garbage back at some point (baudrate not matching with
fresh boot default?)
Either way, no reply isn't great -- just waiting a few ms for reply or
not is not my idea of good design...

> Or perhaps use fw_devlink to create a dependency on the wifi node. I'm 
> not sure offhand how exactly you do that with a custom property.

That sounds great if we can figure how to do that!
From what I can see this doesn't look possible to express in pure
devicetree, but I see some code initializing a fwnode manually in a
constructor function with fwnode_init and a fwnode_operations vector
that has .add_links, which in turn could add a link.
... My problem at this point would be that I currently load the wireless
driver as a module as it's vendor provided out of tree... (it's loaded
through its pci alias, I guess it's udev checking depmod infos? not
familiar how that part of autoloading really works...)

But that makes me think that rather than defining the bluetooth serdev
in dts early, I could try to have the wireless driver create it once
it's ready? hmm...

Let me sleep on that a bit and have another look at both fwnode
(fw_devlink) and dynamic device creation.


Cheers,
-- 
Dominique


