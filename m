Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3512EE89DA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388810AbfJ2NoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:44:25 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42288 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388734AbfJ2NoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:44:24 -0400
Received: by mail-lj1-f195.google.com with SMTP id a21so15318268ljh.9;
        Tue, 29 Oct 2019 06:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JYn1Uu+shCSnLq+0ZvQ3I1FPEGlcJ3N+UYZ+2/Wurpw=;
        b=eKxdQ5z/HByrO2cHLfgL5FvESnBsKMt81/DMCZzQViWEEddusYjeC3pcq3Db+q0EC3
         PViwkCgr6exD64xA43VB9neZ3o9mZZ08Myl3TpdCO/+T4ZtCg5IaE+vwsvNeNdTGlA02
         Crgc++LXNRFZkMuCEAh/HhPREqnIKVw4BuAHNQiUtOm5s6z1j9KsyfBtfMjvHUduzZA2
         yMrtefWiE4C6c2PKx9zWteFkOyAtvBFXomt+9ZhQCTR1JxUpyoJZeAdRY6pyJL/t3K09
         nNBlUuDc3qXgPvcNrS6PIuL7amE0FtVLNdFvlN4aEUA+GOrV6of9Si0oaTxBX5gZy81n
         4LWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JYn1Uu+shCSnLq+0ZvQ3I1FPEGlcJ3N+UYZ+2/Wurpw=;
        b=I6krA63rTurYpqdti/luPdNqp70PvObp9UgJzbijvuBFUstBMURKDjFfidhPJStBMZ
         SLz592TtxJp0LKdXdNO+UxHCuZTBNTfibFQlnHGbGuTdOnyMzDVRCxNrSod1qjOgzxHF
         6pUt8bWDgOira4GT2QjAXftJLoYHQQO2km81IUrTMAMWAD6hH0bRv5wB5J21r0FC4j+5
         5XXEIDp6fwvds62qXBXy2YzomxQfjo8I8DCaD1ZD6XT2evqsRcxIdGK5W5qZjWi9gMMj
         I1vnc0kKmmficy0g0QOBS2xfQJjxHx+UgHP6NFw9ViSPmEIwvk/fBZXpBxPo+GZjZXDO
         iwLQ==
X-Gm-Message-State: APjAAAUkJoR0VSgTnqkIE5iY8GQ20mXz0INSHI1YeRNIZOecATWzQsSa
        lofIjJKFLzFyItERCGgkFFKh4BtkYmQ8PJclh1M=
X-Google-Smtp-Source: APXvYqyR7P9o96unTDHQPezVgHocaeFLVWlBzxpoNUL4lvk0eR+qH44WaXoH/qsQQ5/BdGIwrl/NN3dgeLHTolKv08s=
X-Received: by 2002:a2e:85c2:: with SMTP id h2mr2750520ljj.188.1572356662920;
 Tue, 29 Oct 2019 06:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191025071842.7724-1-bjorn.topel@gmail.com> <20191025071842.7724-2-bjorn.topel@gmail.com>
 <20191028105508.4173bf8b@cakuba.hsd1.ca.comcast.net> <CAJ+HfNhVZFNV3bZPhhiAd8ObechCJ5CdODM=W1Qf0wdN97TL=w@mail.gmail.com>
 <20191028152629.0dec07d1@cakuba.hsd1.ca.comcast.net> <CAJ+HfNjDzNg9wdNkhx7BVkK5Udd3_WP0UMT8jTyssd254M6NsQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNjDzNg9wdNkhx7BVkK5Udd3_WP0UMT8jTyssd254M6NsQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Oct 2019 06:44:10 -0700
Message-ID: <CAADnVQLFY3rNSbc5vqPuWmyuczvT6y-tD=zgTcJZX1yeqbVq8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] xsk: store struct xdp_sock as a flexible
 array member of the XSKMAP
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 11:21 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
> Changing bpf_map_charge_init()/bpf_map_area_alloc() size to u64 would
> be the smallest change, together with a 64-to-32 overflow check in
> those functions.

+1. bpf_map_charge_init() already has such check.
Changing them to u64 is probably good idea.
