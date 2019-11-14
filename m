Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7710FC970
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKNPEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:12 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34381 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfKNPEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:12 -0500
Received: by mail-qv1-f68.google.com with SMTP id n12so2465724qvt.1;
        Thu, 14 Nov 2019 07:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YuABco6iR/XWTZmlu6baSU3mlXVmQ83Wy8Rb3vSocgM=;
        b=qhabFQcOCSL6AGU2/ztTe9dxD+t5W+dnqQ9jPQun7uBVxRJyiyZifGTFsqXfb1Ypny
         7/aNTdudyLnygTylCqw1srgaFJLk2XExpopPJZVafUNRFG7sTXoacbV4LE8VVmSIr6SE
         pJxcZYWwZXLpSWQ5fbCrL9PGOcK/OS8HZY1NRwyBTT5Yi6IGRNrJgdWF5HzxgTYuyGVq
         lOCt0Z2/IrLew2HA0XyGIZqaWff74MGupjV6DZerDU3tz8y3Jqtm4V8t2dFr0dwojWyJ
         u6JdUy/XuEJ3T4P1Frfi0QaR9ppySooZ0w7IaKP7Ogj3cdIObIhy1fVdj7DxCEnF6n88
         ZKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YuABco6iR/XWTZmlu6baSU3mlXVmQ83Wy8Rb3vSocgM=;
        b=RiMabQHIqEF+WTgBbUcAU/tTpobvU/pD6UMQ0W01z+Sl8LYtXPqYNIQoQMcEh+uSyg
         z1SNf7kNKbFrLpdm5V8qUPFib6ADjCrAMU1a1AJqihNw4Ler8Hg8zRahmqPIG5R47Y/r
         GW/E+uzSy2wUW5AIsLGK4v8gUlgp3bH0Mxr1A4kuJsIRX/FuxQ5zlHSYzmnfBzFzyrUD
         BShvz4vZTVrDvJaq76yij1kb51QWhptqd6hDiRAdzGkiMYcj6+ki81CVR2Hm0vC+DCgd
         0LjjG7fwP6J0AxR2/H5WqfeAr07tCJ3xeXtUqg4OtSb81XifpzjUeIPobWeLwM9C32yq
         iDmg==
X-Gm-Message-State: APjAAAVSEypIS4s+3bOpHRvnmmvjMz8OIGYlYTCIbyhn3BCSA4ONCXWK
        gSpoYn/h6D28+X4qV1etyi3/3qsK7Bv+RVfX1A8=
X-Google-Smtp-Source: APXvYqyyp4Ff/QEyMPpQONAuQog9PjrTjyWyPuCIRoWYVuQTYUVLfhOy+XNXxUW5APa83v4gmxdwtse/CO0GyysOuPA=
X-Received: by 2002:a05:6214:70f:: with SMTP id b15mr8283904qvz.97.1573743849353;
 Thu, 14 Nov 2019 07:04:09 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
 <87o8xeod0s.fsf@toke.dk> <7893c97d-3d3f-35cc-4ea0-ac34d3d84dbc@iogearbox.net>
 <CAJ+HfNhPhCi4=taK7NcYuCvdcRBXVDobn7fpD3mi1eppTL7zLA@mail.gmail.com> <874kz6o6bs.fsf@toke.dk>
In-Reply-To: <874kz6o6bs.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 14 Nov 2019 16:03:57 +0100
Message-ID: <CAJ+HfNhRKFGOsv5Nbq5T9NHk=ZcHnK40_jR8bpqNC1GYk8ovTA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 at 15:55, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
[...]
> I don't really have anything to back it up, but my hunch is that only 4
> entries will end up being a limit that people are going to end up
> hitting. And since the performance falls off quite the cliff after
> hitting that limit, I do fear that this is something we will hear about
> quite emphatically :)
>

Hmm, maybe. I have 8 i40e netdevs on my test machine, all running XDP,
but I don't think that's normal for deployments. ;-)

Bj=C3=B6rn
