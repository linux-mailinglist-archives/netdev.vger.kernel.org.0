Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4CC1505E6
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 13:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgBCMLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 07:11:44 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40785 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgBCMLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 07:11:44 -0500
Received: by mail-qk1-f193.google.com with SMTP id t204so13904510qke.7;
        Mon, 03 Feb 2020 04:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PJ4qdO8JQggLc2fWQs+boqL64SksK4OFYeVmitKgQE4=;
        b=Bxb38YHIJX1vfVH2RKNljqr7dyt5Q/ki6AeGgnHvJ7uOngxB49ry89IdWx1kdg90B0
         GUL7iyKw5dK8qSyARFnm5WazGUbUNcL+RhZjW0PLt33AoYRIAbPMNUNVk2EFECzaSse6
         cs3zlPKhSYicpauAlaPnppQMfZGJI027iWqF+fbMnQyH49WfkGYrINVJ7VW0IlNpqwiS
         rirxMWUGsjIJT7hU3jM/KK/bGr+1LyPgcWyOhSNqpFYjKOeK4Env3C9EwHyDzVZn+RE+
         3LuENlU84kdtV3wbj7hTI6F0ndsbWJlLCkOz4C91+6usbO0dszlufk/rWNoscdOoliE7
         Jf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PJ4qdO8JQggLc2fWQs+boqL64SksK4OFYeVmitKgQE4=;
        b=T9U8fMvoP8Lk+PdT1cLSQitiVl8qo6sfjx30Zps78/3DIAxdmfcARea059kCCkpcdi
         UdVfF1mgYdFz9TduhZvWpWC0qa5c3yFQXVw42camNK8ROf7dbVc8cTHA0m/PKy/bNxyY
         0xHueOOaANQpNzgmpqUerA2dp72LoiokFhKNt5507/MUusoOipU3o36tjvlRm7pAG+Zb
         MNhOXmcC7wsKSFITsmQK9DlHup8DfyauQ3xJex0bKJwpeytS2FWjEqwRDrzKDtVoa64w
         zlNmn+F9iKELG5/9G344Vw0Si0keqyxd+GF+XFM9JbU7V8xW/3bZLO32MtQ0p9jbBXeS
         bsNQ==
X-Gm-Message-State: APjAAAXJR8RkRd8JD5nKFlRNaP5paZ8gQVfBy74VstEP2tJIrBJhJ39r
        eWlaaV7xiemcP8zHRXo573uzVbv62ssOso5ZQ/HYr9ibEVw=
X-Google-Smtp-Source: APXvYqwe9Us2PgVu6MqeMNAO664AzntNtBV6pxz6hiw73jiD8G4iW8o+aobGl1EqwZofyiZhblcjvbiNbuP9RfonqcM=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr23348389qke.297.1580731903294;
 Mon, 03 Feb 2020 04:11:43 -0800 (PST)
MIME-Version: 1.0
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-8-bjorn.topel@gmail.com>
 <mhng-041b1051-f9ac-4cd8-95bf-731bb1bfbdb8@palmerdabbelt-glaptop>
 <CAJ+HfNhvTdsBq_tmKNcxVdS=nro=jwL5yLxnyDXO02Vai+5YNg@mail.gmail.com> <mhng-a006210f-8a00-42c3-b93d-135144220411@palmerdabbelt-glaptop1>
In-Reply-To: <mhng-a006210f-8a00-42c3-b93d-135144220411@palmerdabbelt-glaptop1>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 3 Feb 2020 13:11:32 +0100
Message-ID: <CAJ+HfNit8dsXV360qUCiG33yNdbf7=w58M9DncOuNqNOCAE40A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/9] riscv, bpf: optimize calls
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020 at 03:15, Palmer Dabbelt <palmerdabbelt@google.com> wro=
te:
>
[...]
> >
> > BPF passes arguments in R1, R2, ..., and return value in R0. Given
> > that a0 plays the role of R1 and R0, how can we avoid the register
> > juggling (without complicating the JIT too much)? It would be nice
> > though... and ARM64 has the same concern AFAIK.
>
> Oh, why did you say that?  This kind of stuff is why I'm twenty days behi=
nd on
> email...
>
> https://lore.kernel.org/bpf/20200128021145.36774-1-palmerdabbelt@google.c=
om/T/#t
>
> :)
>

(back from vacation)

:-D Very nice, I'll take a look!


Bj=C3=B6rn
