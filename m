Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D25AEFE9
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436845AbfIJQtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:49:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41742 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436473AbfIJQtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:49:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so11843936pfo.8
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Kf25Jpg4a69Kc9y790lirOsctWyzxF3mFzk+S+BI6Q=;
        b=MiwSvRJsi/sQgQatOCZd6eS7jBvvx/2u+ST7vXzr/DmtXBcGz0Ft/865T9hjJYTsOm
         DHzvyfgU94UFiqHPg81oGSBjSGKb9bRRrxc15NNHkuIEAFch0wUhfh/INjhYTZ4xszaK
         IAfCTRw2yirL456zbgsdPGJUZ2wLCu/qE7MlQ+ynOF7gzPpmESpkZ3skFzrZlzzhaE2O
         N56M0Pr5Dg/4dnFtFq2sDvsndO3zbg09QwHq3VShdTKufsqs2oGt4ApOkA2tb3gQga9T
         L32ngy378jcEyOo51nU5ldRQqIx59IA7GwxAQ1ap5VyUwz/TOhqZ8vhaESYjcVGucHuk
         KqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4Kf25Jpg4a69Kc9y790lirOsctWyzxF3mFzk+S+BI6Q=;
        b=YAV1KcDmz2DHx4tnRfrE6Vl6OtRGWKlUPiya0pG0fa+ukhBywQOuAK3htURgtrwYUy
         V2HymCITLphguiQaFfE/mDoh84NKWF6fTkHv47BXjXSIK9AKWEMeFTnahiM+iBPdcE3P
         FMR/46Xez7Ba2N0yNySfpimHTLePUb58XmpVayrXnwlrcRXYMQNTRmA9m0RTNxWBP7Ew
         XKorF9UJ6FBeXaiZEyRg852RGdIOLziYtp19OhADmU49iPNkInVC/uc2prWvccdzneNb
         j83aWEbCk4hnAUvinYtNjObo4nrU0at1NgMzFg8Ft6oyXw1lRC99hhUJ0lbMwgTOiZ8I
         nL1g==
X-Gm-Message-State: APjAAAXWNbh92UBgXM8twqJw3LTMP5Jc3Xu+44ev89YiWJyGhlSF6LY3
        OZaqp0Zx/vVFLLUXJckNYhw=
X-Google-Smtp-Source: APXvYqxbsBE3/3n9/gFt0DUbOC3zXleGu32VaKi5J0/OJhbJ+m1JkEzgfStYv1qRVstT0DkkzNFlNw==
X-Received: by 2002:a65:6495:: with SMTP id e21mr29058480pgv.359.1568134189167;
        Tue, 10 Sep 2019 09:49:49 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h1sm24900371pfk.124.2019.09.10.09.49.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 09:49:48 -0700 (PDT)
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
To:     Robert Beckett <bob.beckett@collabora.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
Date:   Tue, 10 Sep 2019 09:49:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Ido, Jiri,

On 9/10/19 8:41 AM, Robert Beckett wrote:
> This patch-set adds support for some features of the Marvell switch
> chips that can be used to handle packet storms.
> 
> The rationale for this was a setup that requires the ability to receive
> traffic from one port, while a packet storm is occuring on another port
> (via an external switch with a deliberate loop). This is needed to
> ensure vital data delivery from a specific port, while mitigating any
> loops or DoS that a user may introduce on another port (can't guarantee
> sensible users).

The use case is reasonable, but the implementation is not really. You
are using Device Tree which is meant to describe hardware as a policy
holder for setting up queue priorities and likewise for queue scheduling.

The tool that should be used for that purpose is tc and possibly an
appropriately offloaded queue scheduler in order to map the desired
scheduling class to what the hardware supports.

Jiri, Ido, how do you guys support this with mlxsw?

> 
> [patch 1/7] configures auto negotiation for CPU ports connected with
> phys to enable pause frame propogation.
> 
> [patch 2/7] allows setting of port's default output queue priority for
> any ingressing packets on that port.
> 
> [patch 3/7] dt-bindings for patch 2.
> 
> [patch 4/7] allows setting of a port's queue scheduling so that it can
> prioritise egress of traffic routed from high priority ports.
> 
> [patch 5/7] dt-bindings for patch 4.
> 
> [patch 6/7] allows ports to rate limit their egress. This can be used to
> stop the host CPU from becoming swamped by packet delivery and exhasting
> descriptors.
> 
> [patch 7/7] dt-bindings for patch 6.
> 
> 
> Robert Beckett (7):
>   net/dsa: configure autoneg for CPU port
>   net: dsa: mv88e6xxx: add ability to set default queue priorities per
>     port
>   dt-bindings: mv88e6xxx: add ability to set default queue priorities
>     per port
>   net: dsa: mv88e6xxx: add ability to set queue scheduling
>   dt-bindings: mv88e6xxx: add ability to set queue scheduling
>   net: dsa: mv88e6xxx: add egress rate limiting
>   dt-bindings: mv88e6xxx: add egress rate limiting
> 
>  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
>  drivers/net/dsa/mv88e6xxx/chip.c              | 122 ++++++++++++---
>  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
>  drivers/net/dsa/mv88e6xxx/port.c              | 140 +++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
>  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
>  net/dsa/port.c                                |  10 ++
>  7 files changed, 327 insertions(+), 34 deletions(-)
>  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h
> 


-- 
Florian
