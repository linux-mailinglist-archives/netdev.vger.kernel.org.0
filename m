Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE6B1C4DBB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 07:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgEEFsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 01:48:30 -0400
Received: from mout.web.de ([212.227.17.11]:55329 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgEEFs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 01:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588657686;
        bh=jwh8AGavXxbtN/8NVK6S83bOhyRV0FGGM+xObSctlGE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BYhY0lsXs8ky8S+axDLG0BQED1HE4mVp1U2Y0SGCOHz669sP+S12v2N50Sd6JXZ2j
         /KRO0uLnAnVkEqkM/yjvXK7iTgI67mUO2PxZmaxYbsbLc7Od2uGHY75TgMXfuc+TLd
         7HY15ZyBgLUqoyw0DQ6TYn/DXrvB7RxDyVthGkeU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.132.123]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MYeys-1jafkC19YQ-00VR5A; Tue, 05
 May 2020 07:48:06 +0200
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
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6f0e483f-95d8-e30b-6688-e7c3fa6051c4@web.de>
Date:   Tue, 5 May 2020 07:48:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAMV6ehE=GXooHwG1TQ-LZqpepceAudX=P63o139UgKG7TMRxwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:2fesKibbiJ+p94+j5FP8Ga6hELbWfSq4XGn8M53wlg02Qbe1I9b
 oWPdOok7wKI5PwbQww+wu309JTZzZJ5H4GwUhKKOiHPhSSsLWjq5CmFnWMoK7aEN3tgRk/X
 SsC75C7rsZwqduA36Es3/5G8hwuolJ+0CRmvQzZnq4ozJFWOQOFX56jpdDRppkeeHSXqqTf
 +OSt4gjGkJ3Zlu51BrhrQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:R8nqcsvcN84=:tuGlofeSicosgsmu6qvdBE
 YezSsb2ECM3xM04cMxBfpUIXXv9tcc0y7AIoIPSZV1dCvVGkX8APtuJ3wrXIiNt0x8x74s770
 tlBUL29/y3crQQCM8yaC3rVO92gHZXXs13K2a2M+kCjgh0ngK5w3EDnPzzHvdsnvzdQ4qTB9N
 z1j63z1w5Ed00ipD9wDr7fhjS/f1iY/ylKUp6bPBH7wwVd4IeX+Nre4Zx6EuCcfYq8UeNxPo2
 lXzUlrAgJqXpmeWLDlXHAin0Ws6zDurczFllXvJsr/viHptlz3EhtCbDYwLiyYYfI4KDQ5Wrz
 C3S/qjX/qiQ5xJeKgqRqV2nl0g1gi2PTpXJCTeKd1UMrONmHmoyS8WcujwBHY89MQBEVozEQ/
 haX+jrdYAgreO88hJskVa3XqTjwrFfuFAmKzsRQvM8cUX8pQjnbLserWrQfsT1dFcG8aMcHpR
 9dlnD8+qjnD8rDjif52qrihWPfLv/bg8zf3a0cSUsZVPhR9MebOR6vHyX0Bo+aHDfIEuVOcKg
 TBHBREz0yCYhJcSEovj0la+dF6Q1uBmJX43EMV3o1rbvU+HbTEhsg5v+34RydrcOq3akZPG0S
 abhZKxhtsFiiOoTTiooDUL/vpt8+EQEOO6Ymf2AflIYTJq1xvYT3zU0HnstGY5mN9bmxTUvSP
 vlPP4Vxeh0EEgY/lB2B8MWAw3EwIhOB2Y/fTAtns/mkTd2ZBSIqTYsd8b35LmGwABf8ZRiVNP
 avVl6kwkTQfXI4HNqX7Npe/+X9sgSpxLMRh39IfecPH7dMu5hHhHg0x6NtQWUqBOKsugZaJTX
 9N2LyUMYdHuHNxC1NCvxgcHE+FPqORkHRiiDgZRt1s4KDmHUvTU72auFHL/zzSQx8h3QnPW67
 OxeRmZesmb4+4B9DdUuq5C/u0p3aiiz7GuWxoFQlTfAirNBjcPfSunRAMoL1ruLIDeI3xOduT
 a7DwiSYEbeZJ22jtxl1x+/Rcb8Pkq7oJSTua3QITjAbltVquGItCruA/Z8dTNaQd5b/zcHZNO
 W6Ye7dIgQLU3x+6223dVBE0cZEWwo+qtVI8BNcbkUG8YwhPpW1s1PZxzAuU89IrC7KE7FPom0
 RLYh5PjvsBP42mI/1wuvfrOWkBEDR3n0Ww5zsOhv9q10XzZgkgIwlxDADwpkl+1Rhl1wBWsE9
 6dy+oE05swLmQXxfWgaoJnoWnEiMGXKToTrnGL/fLdzL5Vwi1nDW2ns9+puyGf8E13gBg0590
 IKdqP94JBXCvmgoYO
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for your feedback, and yes, I'd like to further adjust the description details
> to make the patch more clear and better.

Thanks for such a positive response.


> But because Jakub seems to prefer v1, so I'm somehow confused

Such a view can be reasonable.
The change acceptance varies between involved contributors.


> if I should submit a new version based on v1

Such a choice depends also on your willingness to clarify and improve
the software situation by better commit messages.


> or based on the version that has an addition of a jump target?

I propose that you can offer patch series with two update steps (for example)
according to the affected function implementation.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=47cf1b422e6093aee2a3e55d5e162112a2c69870#n102

1. Add a missing function call for the completion of the desired resource clean-up.

2. Adjust a bit of exception handling code so that it can be better reused
   at the end of this function.
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?id=47cf1b422e6093aee2a3e55d5e162112a2c69870#n450


I am curious if you are going to answer (my) previous questions and suggestions
(in constructive ways).

Regards,
Markus
