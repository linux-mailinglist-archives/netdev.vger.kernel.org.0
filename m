Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11FB1C61E0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgEEUSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:18:00 -0400
Received: from mout.web.de ([212.227.17.11]:51523 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgEEUR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 16:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588709862;
        bh=YHjHsOjHtltg1OJ43UcJF6RyLNnk3LxukMUmEw05Gc4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=cJpEqE+OOU2LmVX42JH4Drlz4skNosuENJK/y5MdmVbDm209dbvz4tp9g6uC0GLCl
         QQNuLuGObI+mQUaGnJNxZnQsbX3Uod/4XonZHeHvMsq1bnCS+X4VEsyaRjCIkiHZxQ
         QZ01xiXtnVxApGbZus4hVig4kSm/25EgasCtEeWY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.132.123]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MLgQp-1jWL7m3WVP-000rRU; Tue, 05
 May 2020 22:17:41 +0200
Subject: Re: [v3] nfp: abm: Fix incomplete release of system resources in
 nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, oss-drivers@netronome.com,
        Kangjie Lu <kjlu@umn.edu>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200503204932.11167-1-wu000273@umn.edu>
 <20200504100300.28438c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMV6ehFC=efyD81rtNRcWW9gbiD4t6z4G2TkLk7WqLS+Qg9X-Q@mail.gmail.com>
 <ca694a38-14c5-bb9e-c140-52a6d847017b@web.de>
 <CAMV6ehE=GXooHwG1TQ-LZqpepceAudX=P63o139UgKG7TMRxwQ@mail.gmail.com>
 <6f0e483f-95d8-e30b-6688-e7c3fa6051c4@web.de>
 <CAMV6ehEP-X+5bXj6VXMpZCPkr6YZWsB0Z_sTBxFxNpwa6D0Z0Q@mail.gmail.com>
 <956f4891-e85d-abfd-0177-2a175bf51357@web.de>
 <CAMV6ehE9YRxakbP9ahXkiZEPut8E3qYsN0cxiLqCWasfvLAWFw@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <e6989cd8-42b8-d1ab-1fe3-aad26840ae05@web.de>
Date:   Tue, 5 May 2020 22:17:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAMV6ehE9YRxakbP9ahXkiZEPut8E3qYsN0cxiLqCWasfvLAWFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MxjqGyClP6hvU3ad6ilNvkBCcOR2UaBsjyTM9/TJgRhGK7pJ7jR
 0HMtqiTh7pz0+BOrwLTDn0MTO7n2vP0TzB7wUhN/SKYzuhvOIPZu3NabkxGzQmsFCQ9uPU/
 spyAabkVax+1FTNiwA8pcvPPrqO4VTis1WRJyKAvZgcHTq9cByLMlTBeiJ+Hd0ubUspL4lT
 iGKFhY9kJTwlkPDIhcZNQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:u1rcn8iT758=:oJkLBEXUL8CPxKeY1ZiPH4
 lfCvQEfdS8CIpsZjl7rJ2zv7Pqq74Cz8skm9semJsgro62bORAFxF4+HZk43s0duwWAfNSomL
 GylzJHdGE7fSOuNS6j9zWs7EGUDNjILyyQ367mSk53HbryAkV03EnNyCZinRDp/coiGgBOtY6
 TC0V0/07zLCHbGi+we2ZAGu7MH/rJMnGCTXWGub63gncXFD0GTB+513Mo2xGm2Baz6X0X9ApC
 GR4yc2x08O+5Vx59pd+bdpYW8LyF3rBXZRS7c8iPZ/qx83kT2X9rToRUtT5voVEdPAUrNzvT5
 WcDOVOfbzmcfpFmkAmpmB8nZKlM6qIiAl2+Cy2rjp8M/HfmTfX8niio9q0SV65ZEnzhR1nikB
 81lzKZkINiwEQPCRIu9RctT/eCjvU7yutZm8bn+PArQeSwKe80t51l3zhGWb3+kWI8kvOkbcR
 MnxS4aYVRiTWcp0yWSS8enM5xmiUpnx/jlrw17eKSLVJtZsv2cTizWZpg0NpVVKlTCl2f181w
 gH/70z+sWfrFxN7+AFQRXCCEcKrDZGyyo1jgnGMIXT9ZThwGLj9P9xu+o7RdIpkPYhAG9IN0e
 B7eRnrGn+UKZQ+HVTXXRBOQk14F70dxSXxUsTNjA9AXmHBs7NV9dYsQLrC7agGQ8VARI+DOcU
 r3XjtkkAmO/Ceq7jXJWhdwskZte78zZXKl3suPhMshJLakJa1qixdiQGAW3bDDSO6Y2Aqx5/k
 JfwTex3iZG1rQ0FT5liSBTkzABbfCe0Z+teLl9/IzgcAW8habLN5ReHyIjBgLr4ztMqL7RA5g
 toLaF9GTnnOSMVOtsCOeIM9nEtllivpxxORYQ9aMK1CNPUfJBf8PAUG6eKgUZk6ourT2a2wUT
 4v9EdMP0XgYTgW1phCo1nfguoQnYrAEHDkr1oha+YeKI4KbHScgz3xi5SkxpLk9Q8EbVzMFpC
 zRykP7ieewssxIsb7XDFSzvIytq1AN/qzuZCulTiuhJsvLfBDR0xrYMQBJFequckCxPRHeBHj
 Pti3uSM4f6vQwRHBSw3cM/FidBA+YXO9DjVTIc9UI5qEC6l9mHA6h3sQfWX5m2JWFtZLtcHhV
 +gSoSa7qevrbOt7oIDw77NlplhpsfOtNFEzLrnlo9mMQx2YZOuJTnccfmGDhViBcb4VdsHd6m
 gDfmxpJ1Cr4xI0HLOmZOF1EMBUmqserHFXMKdYdw0LRn1KfwezgqZuvLLmDYEY6Undw2P5xTp
 Q81FTORuVZbalwQMu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What do you think about changing:
> "But when nfp_nsp_has_hwinfo_lookup fail, the pointer is not released,..=
"
> to
=E2=80=A6
> or
> "But when nfp_nsp_has_hwinfo_lookup fail,

I became curious about a related wording variant.

  But when a call of the function =E2=80=9C=E2=80=A6=E2=80=9D failed,


> NSP resource is not cleaned up and unlocked."

I find such information also nicer. (The abbreviation =E2=80=9CNSP=E2=80=
=9D might need
another bit of clarification.)

I imagine there might be interests (eventually related to computer science=
)
to measure the corresponding object sizes because of a missed function cal=
l
and offer a more precise information in the commit message
(depending on the willingness to invest efforts in such a data determinati=
on).

Will such considerations become relevant for any subsequent
software development approaches?

Regards,
Markus
