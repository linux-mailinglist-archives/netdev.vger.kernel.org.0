Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D6EDF83B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 00:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbfJUWuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 18:50:19 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36523 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730276AbfJUWuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 18:50:19 -0400
Received: by mail-lf1-f67.google.com with SMTP id u16so11446811lfq.3;
        Mon, 21 Oct 2019 15:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DH2WqPm/ojhUxsYpmTYJtMkv2XHFaG9I6x06pfPP33M=;
        b=e0lZVujDIdHQMqq4a4zVTDR0+ugUY6tpSqAOGelmkxayw8TQ12b/b2VcYcmKz9ubRO
         AhsAx4qCyjJWos0M6KMboJfDKulxo9C2Zt6WYqcCY54MosMiJbWddbbmJQUZ3ectRIQP
         R4gx7Hr+/1CXcv7A54AuP52NsxMAfoKyQAjqrHHrYB6k6ekLKpHi0MesI3qZGMNZWsRL
         fsVj4lmWNpq6gjfVlxQg839fhVkaQR7e7tGkfgll+5M0M3Jsy29p8qo3g4V1xwv41iIu
         GPQqwh+tOjg2d9qegyWrPm/VYf7GOS4IwsiO7LnrmcP8+AKTQvWaQfoFlrGMS2riGoFi
         g/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DH2WqPm/ojhUxsYpmTYJtMkv2XHFaG9I6x06pfPP33M=;
        b=c3yIlCt6NZwPQ9HC1I8bLI4k5aIdoMUy47fYb/BDizHq8etQqGbk1lI01KOnTPvGju
         uRZdyi96xqtpZcx9OT20aWD8WBEari/5SQ1/m00dMwpN++0OuWcpadarGWGd5QqfiYKr
         g3VaOoFUDV07JnGAcozLwVu4gocSpYVX6QYmrHYoxVPXWHz9KlS4y11bWX1aMN7jtn/m
         jDZz19HDqKvvdmfZxVjKbmkpEuyyrl1JYtDPDGcrALHMxWzuYLnu5CBtCX3/riaWTWqR
         gSiIaP+v60qnOjrWk2Oh1N4ff6+ua3S5BLmbIURT1UsqfaO2L8JVvYuG581ECPjcuF5q
         3dyA==
X-Gm-Message-State: APjAAAVthUaL00k8mE0aBQ9EusxlOr+6Zw+hn4o+zgc5LAJ3kAb+sE3Q
        YsNzcRD05u91whS21qJOkJWkoy9B0xUXAR/oJwM=
X-Google-Smtp-Source: APXvYqx0Ttf1vJ1Lj2RKwreCFtwTV0UgvuG5zrLhTJi3HeYY5S5oceRiLbSUb+TLqSkGKMoUx4vMYrwXaPHuyMPAApM=
X-Received: by 2002:ac2:51d9:: with SMTP id u25mr16893966lfm.19.1571698217145;
 Mon, 21 Oct 2019 15:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191019111931.2981954-1-toke@redhat.com>
In-Reply-To: <20191019111931.2981954-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Oct 2019 15:50:05 -0700
Message-ID: <CAADnVQJNrW+tv4ZZJ_UFF969Jm1Gj+SSNa6=Xz=AizDRxOPv3A@mail.gmail.com>
Subject: Re: [PATCH bpf v4] xdp: Handle device unregister for devmap_hash map type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 4:19 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> It seems I forgot to add handling of devmap_hash type maps to the device
> unregister hook for devmaps. This omission causes devices to not be
> properly released, which causes hangs.
>
> Fix this by adding the missing handler.
>
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up device=
s by hashed index")
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Applied. Thanks!
