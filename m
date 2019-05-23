Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419CE27FB4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbfEWOb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:31:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33086 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfEWOb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:31:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id d9so6565105wrx.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 07:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oitixCSyls+WYiarRC0a38mP4/mPHlJWvdjbHhBfuHw=;
        b=B/Y4fH6Qgs2zYncTUWrRBciMLNiyA1JzQ+6IFRwIVufOmOufnPzzI1bl9Hs37qOk2w
         APLNK6ED2e/jKD0/9FWVcR8OJkrnxL6OARAdbkmtNXaAGeKFS2XNBTmlIF3UUEITyQYY
         l5DRGg9Cd2cCXEOeQjDS2fX6CKYTieotF7b6/sI9oatoAJ/wc67l+GFLAxdL0riWCQLm
         Zil0wZ/8U9gLAvMQvTEI88tWK3D3mtWyX2fb7NavstFsm3wkaoLU0O9yTxeh60wC8Vfa
         /89K6IQIi3Hw07k3OrJ1OgXHX1I13qX/2/j657OgX1qljfcWjyEO34w4VItOyNs/4UjC
         PnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oitixCSyls+WYiarRC0a38mP4/mPHlJWvdjbHhBfuHw=;
        b=LFpWm1MRHaGlPEQVlyjSgmB5hlacNI4QU50o5yvBqxq3bI3sSKmDnU5sH4TDhlNcNi
         /heRTVNhX6ZkI8PgzhTzcmGsQRt0jhzG8HOchmX+7UbTQgK4cO8g2NLhddrvRQjDxxBD
         43gf6N4U3MJ0zvwipqcEEuv0Ip5Eu09qxzGIXLuxp/AxcRmvsAL+HCNWLOnwfGMHeYu5
         bLEvALRpf8XbUmXUdn+W/fwi7RKTQ7gx37D0WDJwtYfBRExnsJKSbvnu2fbVvnoFrqer
         KToWhZ3B9uraykEksSMFYo98Id647HdFtQk0jR39m+rTzxhmFmy7SUMCvX2Tipv/j9l6
         ZLzg==
X-Gm-Message-State: APjAAAUttuQeuLhpgHk6C6BpkauBdEz6PdktcNu3+JiPND3vKsyv1O4O
        e6/h1IFmBZ/6XnSjfSCJ17HoLZvOFgg=
X-Google-Smtp-Source: APXvYqzLpgvV703PNCaOR0gIk35TrvPQMaresROkLbWDiJ/l3GB8TuILzZw00e4zoaFvppE2r535cQ==
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr35521866wrm.147.1558621886783;
        Thu, 23 May 2019 07:31:26 -0700 (PDT)
Received: from [172.20.1.229] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id o4sm11751807wmo.20.2019.05.23.07.31.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:31:26 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32
 and/or/xor
From:   Jiong Wang <jiong.wang@netronome.com>
In-Reply-To: <c1f90672-d2ce-0ac9-10d1-08208575f193@iogearbox.net>
Date:   Thu, 23 May 2019 15:31:24 +0100
Cc:     Y Song <ys114321@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3ED3A4F8-CC01-4179-9154-6FC5338E83B5@netronome.com>
References: <20190522092323.17435-1-bjorn.topel@gmail.com>
 <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
 <CAJ+HfNhR2UozhqTrhDTmZNntmjRCWFyPyU2AaRdo-E6sJUZCKg@mail.gmail.com>
 <CAH3MdRX6gocSFJCkuMuhko+0eheWqKq4Y4X-Tb3q=hzMW5buyw@mail.gmail.com>
 <c1f90672-d2ce-0ac9-10d1-08208575f193@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
X-Mailer: Apple Mail (2.3273)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 23 May 2019, at 15:02, Daniel Borkmann <daniel@iogearbox.net> =
wrote:
>=20
> On 05/23/2019 08:38 AM, Y Song wrote:
>> On Wed, May 22, 2019 at 1:46 PM Bj=C3=B6rn T=C3=B6pel =
<bjorn.topel@gmail.com> wrote:
>>> On Wed, 22 May 2019 at 20:13, Y Song <ys114321@gmail.com> wrote:
>>>> On Wed, May 22, 2019 at 2:25 AM Bj=C3=B6rn T=C3=B6pel =
<bjorn.topel@gmail.com> wrote:
>>>>>=20
>>>>> Add three tests to test_verifier/basic_instr that make sure that =
the
>>>>> high 32-bits of the destination register is cleared after an ALU32
>>>>> and/or/xor.
>>>>>=20
>>>>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
>>>>=20
>>>> I think the patch intends for bpf-next, right? The patch itself =
looks
>>>> good to me.
>>>> Acked-by: Yonghong Song <yhs@fb.com>
>>>=20
>>> Thank you. Actually, it was intended for the bpf tree, as a test
>>> follow up for this [1] fix.
>> Then maybe you want to add a Fixes tag and resubmit?
>=20
> Why would the test case need a fixes tag? It's common practice that we =
have
> BPF fixes that we queue to bpf tree along with kselftest test cases =
related
> to them. Therefore, applied as well, thanks for following up!
>=20
> Bj=C3=B6rn, in my email from the fix, I mentioned we should have test =
snippets
> ideally for all of the alu32 insns to not miss something falling =
through the
> cracks when JITs get added or changed. If you have some cycles to add =
the
> remaining missing ones, that would be much appreciated.

Bj=C3=B6rn,

  If you don=E2=80=99t have time, I can take this alu32 test case follow =
up as well.

Regards,
Jiong

>=20
> Thanks,
> Daniel

