Return-Path: <netdev+bounces-6178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B74B7150CA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 23:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD851C20A8F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421D31095B;
	Mon, 29 May 2023 20:59:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3668228E7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:59:57 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D059D9;
	Mon, 29 May 2023 13:59:55 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f4e71a09a7so4059309e87.1;
        Mon, 29 May 2023 13:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685393994; x=1687985994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=muVhT1+GO4gC9zLL5tbx3GAF0hy1z8ZsUMfe1NrlHoE=;
        b=VOW2vY32yN4iDG2a70OWI7XGg+K37P2ltLyg+H9RPE5J2BJcFf+kVPllbQ25uhsuI2
         fCQhyx7foXShno15V4AaW+V6aU6yJunaxCgyrVqXoCqHjAQvDLmG6Q9clx5bdHZKzBj0
         +aI0A1u5NvWf2IHkK+DP/wdNIwlyG7u7cI0nn+4k7dccr4s/g1zgNe6rJo+jKdS42kOY
         6u9kBBQLpOVpjAEKTHjnZhD0mQ6wsDhULe4PtzDa+Ki9olu+foQ+xBYndtdEN19qfLmx
         hzmA57oUsjAoFbm0QrwOw9/dLTwpjHeOCzSSCqsdbuf55BezbvXkrmNxFv5Rx9K2KRkk
         8bVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685393994; x=1687985994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muVhT1+GO4gC9zLL5tbx3GAF0hy1z8ZsUMfe1NrlHoE=;
        b=PEU8g/MqOwNcJ0k4oiqmJlDiWdLfD0tERxPKyZReFu4b8DbyYj1MG3hgnSWcn4T+Kt
         dMG3T/U9zfuz2rG8D8i5oOHkRuunM6qQVqx9c+mWpw6THsIfapYia+92+kAQC2dpXr4w
         wLDEoklmt2xpXd7qWG3R4pXAqBIb/iQf+Kmos2qFNSasKe9/Rxs2r+ZzKav0Ie2qdhY1
         bkddz4MnUOd2/QUmMAY+MomQwWGLBv4xYvYWkMoeefdw5hLWe7F9iUs6rdh8KK81AwSA
         7/RopKRoufoWLfXJgHiiGMplXXp5I0YkFtvmHgdFs8w55brO9+ghkNDwd86bURIJcL2x
         Wdig==
X-Gm-Message-State: AC+VfDzTN2PpQS8wgMlyxza8owespnR5u7g7j0ouxahIpT/qUs34JsAR
	X1aKgm6OTwezugkGRphHs2BpRtLG6sI=
X-Google-Smtp-Source: ACHHUZ54FS3+uUFt4OYzMp7Z3BXugUjfLX2QWU5yKwQPe3QNbSapaaGTh/IPu6IvY8bPyz4pQ/8KVQ==
X-Received: by 2002:ac2:4464:0:b0:4eb:3cac:23b9 with SMTP id y4-20020ac24464000000b004eb3cac23b9mr76329lfl.9.1685393993425;
        Mon, 29 May 2023 13:59:53 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id f24-20020ac251b8000000b004f252a753e1sm114533lfk.22.2023.05.29.13.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:59:53 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
	by home.paul.comp (8.15.2/8.15.2/Debian-22) with ESMTP id 34TKxm5b018866;
	Mon, 29 May 2023 23:59:49 +0300
Received: (from paul@localhost)
	by home.paul.comp (8.15.2/8.15.2/Submit) id 34TKxlTT018865;
	Mon, 29 May 2023 23:59:47 +0300
Date: Mon, 29 May 2023 23:59:46 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Ivan Mikhaylov <fr0st61te@gmail.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment option
Message-ID: <ZHUSQkXwruFQbvSC@home.paul.comp>
References: <20230509143504.30382-4-fr0st61te@gmail.com>
 <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
 <fc3dae42f2dfdf046664d964bae560ff6bb32f69.camel@gmail.com>
 <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
 <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
 <5b826dc7-2d02-d4ed-3b6a-63737abe732b@linaro.org>
 <e6247cb39cc16a9328d9432e0595745b67c0aed5.camel@gmail.com>
 <38ae4ceb-da21-d73e-9625-1918b4ab4e16@linaro.org>
 <5d7421b6a419a9645f97e6240b1dfbf47ffcab4e.camel@gmail.com>
 <408ee74c-e6ed-d654-af04-58bd7d1e087b@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408ee74c-e6ed-d654-af04-58bd7d1e087b@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Krzysztof,

Let me try to clarify a bit on the particular usecase and answer your
questions.

Let's consider a server motherboard manufactured and sold by a single
company. This motherboard includes I210 (Ethernet Controlleer) chip
along with the other necessary parts right there, soldered to the PCB,
non-replaceable. This I210 is connected to the host CPU with a PCIe
lane and acts as a regular network adapter. In addition to that this
chip is connected using NC-SI (management channel) to the BMC SoC
(also permanently soldered to the board).

There is a separate EEPROM connected directly to I210 which hosts its
firmware and many operational parameters, including the MAC
address. This EEPROM is not anyhow accessible by the BMC (the host can
read/write it using special protocol over PCIe). Intel expects the
board manufacturer to embed a MAC address from the manufacturer's
range in the EEPROM configuration. But in many cases it's desirable to
use a separate MAC address for the BMC (then I210 acts as if it has an
integrated switch), so the board manufacturer can, by its internal
policy, allocate two consecutive MAC addresses to each motherboard.

The only way BMC can learn the MAC address used by I210 is by a
special vendor-specific NC-SI command, and it can provide just a
single address, the one used by the host. NC-SI is using Ethernet
frames with a special type, so to execute this command the network
driver needs to be (at least partially) functional. I do not really
imagine nvmem getting support to read it this way.

On Wed, May 17, 2023 at 09:26:35PM +0200, Krzysztof Kozlowski wrote:
> I would like to remind this question.
> "why different boards with same device should have different offset/value?"

In the usecase we're aiming for the DT is describing a specific board
from manufacturer that guarantees the offset to be correct, as none of
the parts are replaceable and the MAC address is flashed into the
I210 EEPROM during manufacturing.

> Let me extend this question with one more:
> "Why for all your boards of one type, so using the same DTS, would you
> use one value of incrementing MAC address?"

Here we assume that for all the boards supported by a particular DT
the board manufacturer guarantees the MAC address offset by internal
production policy, by allocating the addresses from the manufacturer's
pool.

> But you hard-code the number, just in BMC DTS. How does it differ from
> BMC hard-coding it differently?
> 
> You encode policy - or software decisions - into Devicetree.

But MAC address of an Ethernet equipment is an inherent part of the
hardware. It's just that we can't store it in an nvmem-addressable
cell in this case, unfortunately.

> Why devices with same board cannot use different values? One board "1"
> and second "2" for MAC increments? I am sure that one customer could
> have it different.

You assume that the customers might be allocating their own MAC
addresses for the network interface of a motherboard, that might be
true if the customer gets such a board from an ODM. But such a
customer not willing to follow the MAC address offsets policy is not
much different from a customer who e.g. modifies flash partitions or
storage format making the nvmem references invalid, and so requiring a
separate DT.

> If you want to convince us, please illustrate it in a real world
> upstreamed DTS (or explain why it cannot). Otherwise I don't see
> justification as it is not a hardware property.

Can you please tell how you would imagine a responsible vendor tackle
the usecase I outlined? Guess it's not by a startup script that would
be getting a MAC address from an interface, applying the offset, and
then change it on the same interface?

Thank you for the review and discussion.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

