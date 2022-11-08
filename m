Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEED62207E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKHXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKHXy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:54:59 -0500
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9900121824
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:54:57 -0800 (PST)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 6557A600F5
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:54:56 +0900 (JST)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 06472600D2
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:54:55 +0900 (JST)
Received: by mail-pl1-f197.google.com with SMTP id c1-20020a170902d48100b0018723580343so12240428plg.15
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 15:54:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KnksoYaM8c4ehrc9G/4XJM9Rzso4aSMZWSvfC6plin4=;
        b=5oY0wMu03MF3jA+J1IdriOWeBw6kWWHipKGRT/HYxt3lOm1n2AVfTDA2PzjMu5HsqX
         w2uVi9eZy304pXNii1Ycu2PBBPhkv/2ZkxnZEQsbrrUrt8LyOewbReLvG5EnV6FvPs4A
         VsmY/lNdahGCbl0IaPuVZ+FajSNZGt7M6b3v+30SnJ4BAiqAY9ycZPTRH2rCaDdIKCMS
         7hC74OwhUsF6AmUS5SvBL+V9Nat6VtRtXfrZWKj13zEyYn5J1XMe7a/XAfYuigov5gLJ
         uzYR7fEwqJ63dkzI/EAfKIpdkTOn3HZc3L14osl2ucNacNuD81U7BBNTWRtLm1hppCh1
         /YVA==
X-Gm-Message-State: ANoB5pntqILHNH46R+NYHMaU4wFtQ4O1lgY2jkMbrNP6AIkRI4odCPmG
        B8J3hPjPY20sksHX7l/uciQuHiSBQ0sDVMvM+f1aKOgVegGegMMGuUlixytR1zMQXB3ZnFlM889
        iptLNp7VXUuQPAPXcy/E0
X-Received: by 2002:a17:90a:49c9:b0:217:c5f6:4092 with SMTP id l9-20020a17090a49c900b00217c5f64092mr17169905pjm.33.1667951694111;
        Tue, 08 Nov 2022 15:54:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7lkcyT6KvvbkCMvIGHyAcNSvH+64wkGaI4+wTqhrX3TWqblxAynjwlMg46xqVUO1hbqGJEPw==
X-Received: by 2002:a17:90a:49c9:b0:217:c5f6:4092 with SMTP id l9-20020a17090a49c900b00217c5f64092mr17169877pjm.33.1667951693797;
        Tue, 08 Nov 2022 15:54:53 -0800 (PST)
Received: from pc-zest.atmarktech (162.198.187.35.bc.googleusercontent.com. [35.187.198.162])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902b68100b00186a2444a43sm7469812pls.27.2022.11.08.15.54.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Nov 2022 15:54:53 -0800 (PST)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1osYQe-00C2iT-1F;
        Wed, 09 Nov 2022 08:54:52 +0900
Date:   Wed, 9 Nov 2022 08:54:42 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
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
Message-ID: <Y2rsQowbtvOdmQO9@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqKCb2ZA+CLTVnGBMjp6zu0yw-rSFjWRg2S3hA7S6h-XEA@mail.gmail.com>
 <6a4f7104-8b6f-7dcd-a7ac-f866956e31d6@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for all the replies!

All remarks make sense, I'll do my homework and send a v2 once extra
questions have been answered.

Rob Herring wrote on Tue, Nov 08, 2022 at 07:59:33AM -0600:
> On Mon, Nov 7, 2022 at 11:56 PM Dominique Martinet
> <dominique.martinet@atmark-techno.com> wrote:
> > Add devicetree binding to support defining a bluetooth device using the h4
> > uart protocol
> 
> The protocol is mostly irrelevant to the binding. The binding is for a
> particular device even if the driver is shared.

This echoes the point below: I wanted to make this a bit more generic
for other adapters, question at the end of my first reply to Krzysztof
below.

> There's now a pending (in linux-next) net/bluetooth/ directory and a
> bluetooth-controller.yaml schema which you should reference.

Will check it out and add that.

Krzysztof Kozlowski wrote on Tue, Nov 08, 2022 at 12:37:39PM +0100:
> > diff --git a/Documentation/devicetree/bindings/net/h4-bluetooth.yaml b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> > new file mode 100644
> > index 000000000000..5d11b89ca386
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> 
> If the schema is for one specific device, then filename matching the
> compatible, so nxp,aw-xm458-bt.yaml... but I understand you want to
> describe here class of devices using H4 Bluetooth? Won't they need their
> own specific properties?

H4 bluetooth itself has very little configurable elements, from what I
can see about the device I'm using the actual configuration is done by
the wifi driver that uploads a "combo" firmware over the PCI side
(it's based on mwifiex, so for example mrvl/pcieuart8997_combo_v4.bin
upstream works the same way afaik)

This is a pretty terrible design, as the Bluetooth side cannot actually
know when the device is ready as the initialization takes place, but
that means there really aren't any property to give here

(I haven't reproduced during normal boot, but in particular if I run
bluetoothd before loading the wifi driver, I need to unbind/bind the
serial device from the hci_uart_h4 driver to recover bluetooth...
With that in mind it might actually be best to try to coordinate this
from userspace with btattach after all, and I'd be happy with that if I
didn't have to fight our init system so much, but as things stand having
it autoloaded by the kernel is more convenient for us... Which is
admitedly a weak reason for you all, feel free to tell me this isn't
viable)


Anyway, there probably would be other devices benefiting from this, at
the very least other cards in the mwifiex family, but I'm doing this as
a end user so I'm not comfortable adding devices I cannot test.

So with all of this (sorry for the wall of text), should I try to keep
this generic, or just give up and make it specific to nxp,aw-xm458-bt
and let whoever adds the next device rename the file?


> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +    #include <dt-bindings/clock/imx8mp-clock.h>
> > +
> > +    uart {
> > +        fsl,dte-mode = <1>;
> > +        fsl,uart-has-rtscts;
> 
> Are these two related to this hardware?

I'd say it's related to my soc rather than the Bluetooth adapter; I
tried to give a full example but it's unrelated and I'll drop this as
well.

-- 
Dominique Martinet


