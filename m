Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA48132DA6
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgAGRyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:54:38 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:37416 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgAGRyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:54:37 -0500
Received: by mail-il1-f181.google.com with SMTP id t8so342387iln.4;
        Tue, 07 Jan 2020 09:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nJCWLp1gQvzaMi+m4xqOfZb3QWnS3RX2AWV9TPq5Zvs=;
        b=TYrVYWWHvv+RvBCLxYEdqVEhEwqMsjBovYelTnCeFhWUPniCElVxnsHhGSbdgACYWB
         avavDAh/n17wRANuR/g1+BGviXYYMW8MPQR8CfFFiJ9ZVkM2XnpK2L4p6PRnQbLImk+m
         hY7stD5jqd2lmPvhNkRIGmGIJviqMIsBxDvQ2LGdr/G403HoRoeZe4VPwjcSwDflX/Me
         NuEUz84crY3XpyhptO3XP/6XHxkT1yLfhV2FkapCdkS3DgFa5lktfNfPBF3uVyICo/S+
         UiI3Ga//Eg/aXmuCzR064gV9iAsDY/2tNn0fGJfdInU3xMqJosRJdk29sdwoWb4pZ1UE
         iQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nJCWLp1gQvzaMi+m4xqOfZb3QWnS3RX2AWV9TPq5Zvs=;
        b=a5gZV2Z1vTDQFVpTHo4PKyt9NryruzUx6fMWUMSN2Py/uv6PG0tR/bEdH9xZis4dqw
         0FRlFYJhwwQFIcmmIuaFr7dkq6C80QBf8J4f5TaX/C44fxgUkDoA9NkjYqc63zuXruXB
         CdviJxh/Gck4k0nxMTXPbyXlEl01+dEpa6FwG53i5QpwGgNv03A/gU8Upkrr4YYMdN7x
         7SJzhciVaK0QJoXgdPgC2QxsHhFJXdB6zBT9F2FgehNitYaciKLdTfzw0KhhEosfpPJn
         PbNpD35jlrj3bZNB78e7tWvEtFG+yDK/G1wP/nxS1eDDzPFTUfcuAJEa44h6Qhm383gK
         Xe9A==
X-Gm-Message-State: APjAAAWh8rZE64LdtOZeXPIPA7II/kToyDBIZOhJtmJ/hAYHGz65WUPh
        bFaYL4SPZASCfpO6Bm4xr9U=
X-Google-Smtp-Source: APXvYqxFP4IJdzD9J2BSVTJlSXTooxRPjqjcSQ9M6tXFhB0iVMhqMqzlcLwHlKrtqi0ZibUyIi/Ryg==
X-Received: by 2002:a92:5c8f:: with SMTP id d15mr310725ilg.102.1578419677279;
        Tue, 07 Jan 2020 09:54:37 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g27sm94787ild.26.2020.01.07.09.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:54:36 -0800 (PST)
Date:   Tue, 07 Jan 2020 09:54:28 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e14c5d4c4959_67962afd051fc5c062@john-XPS-13-9370.notmuch>
In-Reply-To: <20191219061006.21980-5-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-5-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next v2 4/8] xsk: make xskmap flush_list common for
 all map instances
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> The xskmap flush list is used to track entries that need to flushed
> from via the xdp_do_flush_map() function. This list used to be
> per-map, but there is really no reason for that. Instead make the
> flush list global for all xskmaps, which simplifies __xsk_map_flush()
> and xsk_map_alloc().
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---

Just to check. The reason this is OK is because xdp_do_flush_map()
is called from NAPI context and is per CPU so the only entries on
the list will be from the current cpu napi context? Even in the case
where multiple xskmaps exist we can't have entries from more than
a single map on any list at the same time by my reading.

LGTM,
Acked-by: John Fastabend <john.fastabend@gmail.com>
