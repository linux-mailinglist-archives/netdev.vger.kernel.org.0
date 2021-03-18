Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D707F3400CA
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCRIVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCRIVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 04:21:03 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069D7C06174A;
        Thu, 18 Mar 2021 01:21:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k8so4514219wrc.3;
        Thu, 18 Mar 2021 01:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eJJxqJ1zy/xPFQIzDdROjaG15kS9TauPGIX9yPwO/T0=;
        b=BZQq33Qgxab+H17rvrhNWlChilECdxq9y3ZNeW1lPlMpu71pIj0UhJZbeECFr5FyFE
         9jGPfavxaNHW/ufHl+mZuCnoYvB3RaFHtU1LXH21s2PnOm2ADgV612ROBYHXU90LHRXm
         8+pYDmJvT5bh+g34/SSiGjAUo2dtnSOrPepWWKJzazZhCcoNGEjajbXKQRG7qTJGf63X
         MHIROfWQNdk8fgMp1coXuEigPKkDOhiacYzxyQNEwGdTOX9/CyqROMKONY9SqO+xenTT
         yh3kdodEz50/baLNSE88P1PeRj53n4ITxODB9NfhbygNxWXx6cx7CciQxVYib2cp1I0O
         Aa5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eJJxqJ1zy/xPFQIzDdROjaG15kS9TauPGIX9yPwO/T0=;
        b=ZNKwfeWQVwN6GF4ZUqYZ6GxaudNnKOO15Y3wIDPCOxTP6KZIT5XYsQ5hIjfsA1FgB8
         9PsfK71bIh1ErHt/AU4Kg8kPSrSjqGJ36kIt4i8JRxjAaLcUhX0wa8JSqTGHJWy3KUT+
         9V45dUUm9e9BEsUHpYagWHcK6+jgZGa/G5r2oZowGwndtQARG7V61uC2UL0O0raqAP5y
         dLtFsZ3s8rZqijoevGdKdQdmuruc18x88G3sLYcZ0R+UDDSr41bGeVwHm7PlC5gXIRKv
         OqD+BvE6TakBcCz0cNE6AAq6Fep9DSbwUT086Fp0GzRgxaas1ZwZh5uSFYAErDgXrnHM
         WqEA==
X-Gm-Message-State: AOAM5326+HPpOFI8RFHx8poTQxc0UFq2PRlHSZ7zdu2rEI8yRidSeQBA
        Z8oRdavucWpuPvdm8skfj/U8VD9To1w60BpDnGc=
X-Google-Smtp-Source: ABdhPJwuEI5gBLRrlqPew2LpVV9M7YNOhj6jL5NpMWIy1lx9Dqe0npepRwowLIcDlk/7M/efgb0i3u7jVJeObO/bmQE=
X-Received: by 2002:adf:dc4e:: with SMTP id m14mr8813794wrj.248.1616055661769;
 Thu, 18 Mar 2021 01:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210309101321.2138655-1-liuhangbin@gmail.com>
 <20210309101321.2138655-3-liuhangbin@gmail.com> <87r1kec7ih.fsf@toke.dk> <20210318035200.GB2900@Leo-laptop-t470s>
In-Reply-To: <20210318035200.GB2900@Leo-laptop-t470s>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 18 Mar 2021 09:20:50 +0100
Message-ID: <CAJ+HfNi-v2GkRVKuiqx2zHOjHRSCBn-=UxKC=0kofiG-wt7-dg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Mar 2021 at 04:52, Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Wed, Mar 17, 2021 at 01:03:02PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > FYI, this no longer applies to bpf-next due to Bj=C3=B6rn's refactor in
> > commit: ee75aef23afe ("bpf, xdp: Restructure redirect actions")
>
> Thanks Toke, I need to see how to get the map via map_id, does
> bpf_map_get_curr_or_next() works? Should I call bpf_map_put() after using=
?
>
> The ri->flags =3D flags also need to be add back as we need to use the fl=
ags
> value.
>

Hmm, I was under the impression that ri->flags was only to be used by
the new bpf_redirect_map_multi(), but now I see that you're planning
to use the bpf_redirect_map instead. Well... I guess the flag is back
then.


Bj=C3=B6rn
