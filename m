Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E279E8C7A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390370AbfJ2QMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:12:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43516 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389902AbfJ2QMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 12:12:15 -0400
Received: by mail-pl1-f194.google.com with SMTP id v5so7855813ply.10
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 09:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NAT8h3GfCznRCCQkShL2kjx8siB2Aq1MMhmzBSGzR4o=;
        b=SMLnelVjMgKOG8ilrMR71i9XzSvVIOn8uwHhfNcFvbJmE6LUDIKoDkrWO5TNbu9nUc
         1b6FoO0se8vhk1WBUYHot70AHlWfvd/NDGO/eywynvddTtip/VP0dcvD0LyNXDcEREKB
         kmBybkBrGoiuw+ebRpGIZkRsn7Gh7IzMeBgHzA8KvKDjiZyBUYlVPk0sC0+GyMge/mfu
         7vP/pRlmDhvRIPtBuTXUwGZSh845KE1QYmj0kgRMSOQIDVs6roaAGD9eOHTsvXo0wHne
         N0bYQPk0GMqnw7Rod/7d0KrV9S4siHy7sGlqkFTI7qEj2xXgxhDkfaRjIjHBc2SNKZkw
         xKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NAT8h3GfCznRCCQkShL2kjx8siB2Aq1MMhmzBSGzR4o=;
        b=i9JE5MmatwnZ6eiWI0wiDWEZoqDWeoH7APjIMToJfsQDw2Lqc2nSdxK6U0G4Gok2dX
         3TX5nPthEaUADPTw2mB2ldUZq/ztJ+hc9Sj4W4bP2ADHqJijhWQHN3bV0pc5y1Jj12qi
         YWRnwn52l1K/qgyEdOywl4C7qO1zn3xgjMtwPEtLXdqwByvTq5LCvtrcWDZES7FMsI6N
         HLUVA+6CsSzr2ohTG0qe+L6C9jbQsQQLoJSskMdVhMiOJKDSmtdvRViSZdemsBdmlUaJ
         0RJL+8qeKjO0MMHV9Rvgat0qbg30k7rm0D3xo0hMjAqDZ25FCNWn2h97IcQjpFLJrABR
         VaqQ==
X-Gm-Message-State: APjAAAUKhUHAVRFJ1B7jFDdL4/oS/cRYcZ4DgJ5R1r/1GdpusEkZTthO
        0R/UTTyjHi8+auXuV0oAkvz+jQ==
X-Google-Smtp-Source: APXvYqzJU+CBGmIoYxP8LYfNWQ98/DJqUSWUHBVzA1XruZNYpSy80rM2ImCnHJxD2DZ+Su0OSypEkg==
X-Received: by 2002:a17:902:321:: with SMTP id 30mr4997781pld.61.1572365534851;
        Tue, 29 Oct 2019 09:12:14 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 13sm15392785pgm.76.2019.10.29.09.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:12:14 -0700 (PDT)
Date:   Tue, 29 Oct 2019 09:12:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, toke@redhat.com
Subject: Re: [PATCH bpf] bpf: change size to u64 for
 bpf_map_{area_alloc,charge_init}()
Message-ID: <20191029091210.0a7f0b37@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191029154307.23053-1-bjorn.topel@gmail.com>
References: <20191029154307.23053-1-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 16:43:07 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> The functions bpf_map_area_alloc() and bpf_map_charge_init() prior
> this commit passed the size parameter as size_t. In this commit this
> is changed to u64.
>=20
> All users of these functions avoid size_t overflows on 32-bit systems,
> by explicitly using u64 when calculating the allocation size and
> memory charge cost. However, since the result was narrowed by the
> size_t when passing size and cost to the functions, the overflow
> handling was in vain.
>=20
> Instead of changing all call sites to size_t and handle overflow at
> the call site, the parameter is changed to u64 and checked in the
> functions above.
>=20
> Fixes: d407bd25a204 ("bpf: don't trigger OOM killer under pressure with m=
ap alloc")
> Fixes: c85d69135a91 ("bpf: move memory size checks to bpf_map_charge_init=
()")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Okay, I guess that's the smallest change we can make here.

I'd prefer we went the way of using the standard overflow handling the
kernel has, rather than proliferating this u64 + U32_MAX comparison
stuff. But it's hard to argue with the patch length in light of the
necessary backports..

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
