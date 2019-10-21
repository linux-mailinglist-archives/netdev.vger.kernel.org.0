Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770B8DEDCA
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 15:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfJUNiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 09:38:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37026 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfJUNiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 09:38:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id u184so12620350qkd.4;
        Mon, 21 Oct 2019 06:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9XSunISr1V5QDmswNDcwodBh42fC8d5U9vuncv4G5IM=;
        b=ER4eUBUHpUKME3CHPHqs7qIKSq69WImH9o9qDSrUTdhYeMZd5G4iVomPepmt/6kMr3
         iLkuFeqKxRlvDxGYgpTs7s4eb03OxSMvygYTzcJvNdoQJB5nJ+3dxDjl+AoN0daJ59FU
         6TOFt/9gQ5mrJy6wec4UFSpIb+UYYyS3R2rY5fa/WdczZJZjwmYx0XWE54BafMCm4xUU
         cB19TRaR/arSPeqPTMJl4KaglfbuFM/LAe9KyWMjYbaxGYiya0UHeROCG3aq1gJPwv0u
         5rhZlqzYk9z19NqoJTV6CDTGJJlC+QwGzbiiXtDRio+FVfnlB6hvXwqkwgpDkl7MEWZa
         /f0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9XSunISr1V5QDmswNDcwodBh42fC8d5U9vuncv4G5IM=;
        b=aVHf7/z3eNLuNsARM2BpYfQtJAwKr7Ff7l+d6eTp2xcwtBtUACJAJdz9RCWb2z/AQl
         EVESp8TUo0NoLdW/gZ+aN35zt485LoRmXD8Va1GMBfQjI7eH61ZDjHGsUSbPlhSjOXCg
         1+mCZ/VmhSkKQuLjEHFV47az27R8xhDPWhwvIouB8SC55LlmTmTEQPPOjO8JgSr02WFk
         BCQA2XvZmru5JCtBNf34Ll+OQ6qU5DktMfKP6FYSE/gRjC/2FmgC1JSNA9YedbTSdhZ/
         1lov1RbWM/rhG/hLi0UJU1XacIqfB+lTlwPuIuqlf+AOWjyKlC4PGkR4h4ZJ51XWu9mS
         qO8w==
X-Gm-Message-State: APjAAAUiGdHtbBNjCuq1B68h6yXU6UlBtkoxqHHY+fbNjpeoNSjYLwGr
        c5uQEV6FsmxuKk3XX0z/LFdnVVW744SI+Bgd8Eo=
X-Google-Smtp-Source: APXvYqzLvDLzIi2FRZYljdcSujCRW8S21SwNQNpJnbMDoz4gADdJu0gIy/GFqrhTRQHH4ZEYFgcf+lujjixoK7gqA2A=
X-Received: by 2002:a37:8b03:: with SMTP id n3mr22111950qkd.493.1571665085765;
 Mon, 21 Oct 2019 06:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191021105938.11820-1-bjorn.topel@gmail.com> <87h842qpvi.fsf@toke.dk>
 <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com> <87bluaqoim.fsf@toke.dk>
In-Reply-To: <87bluaqoim.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 21 Oct 2019 15:37:54 +0200
Message-ID: <CAJ+HfNgWeY7oLwun2Lt4nbT-Mh2yETZfHOGcYhvD=A+-UxWVOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from
 AF_XDP XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 at 14:19, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
[...]
> >
> > bpf_redirect_map() returns a 32-bit signed int, so the upper 32-bit
> > will need to be cleared. Having an explicit AND is one instruction
> > less than two shifts. So, it's an optimization (every instruction is
> > sacred).
>
> OIC. Well, a comment explaining that might be nice (since you're doing
> per-instruction comments anyway)? :)
>

Sure, I can do a v3 with a comment, unless someone has a better idea
avoiding both shifts and AND.

Thanks for taking a look!


Bj=C3=B6rn


> -Toke
>
