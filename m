Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DF813CD5E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgAOTpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:45:23 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:34656 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAOTpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:45:22 -0500
Received: by mail-pf1-f182.google.com with SMTP id i6so8997506pfc.1;
        Wed, 15 Jan 2020 11:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5V5r0J0r7JgcBTcJZajxVuQ4bhqXd9Nr9nyhb0J6tzQ=;
        b=BJsgtvI/dl+ODR/UECf+HSQZty6cI5cpEOtm6gmNtMB9XZDPJI7WKrDFAJkgEPQpK2
         T83Fvtgez3cFfhUjHvLlrhZbnuwXRmzya1ZKeFR++X9uZQOOBDok5o+wM24XPj1MP8CL
         Y3UryILoDp9mWPy/CiJ0+6crKy2yE7CZvxstlrpzuWnNvQWYteTeIXKacT5HdzRfTwoe
         gu1+iCxjS7hcoeGyx7WWsmUmQtK9MjV/K7d45rpN0IU3ZAbTmO9sJvjY3agjkQ1uMREz
         CjykrD30btJV4hteG4xDmybYQFh8z273HWfWifUodcscjiH4hnQNoVN4y0+NuaeHC/l2
         9FCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5V5r0J0r7JgcBTcJZajxVuQ4bhqXd9Nr9nyhb0J6tzQ=;
        b=Tucebyq4vHpqiSIRGYqLGGtyp6blfdz3Z+Nb7IpVeI3fA16/FTRzRNhOsWuVA3uoK/
         nU2BmutAnlGWiOepauPQc66r3p64gBqvlzBBjbrfWmatnnHcoXHVK1Xr6uqZKV3+palL
         /m+M/jqlpFwde1Lz9KSQ5QSAZPEoMG58111vVXBkX9gKRf4qAOwkn5EugobHAELd0zRl
         iBTrytII95G02L/+ElMLfe9szMJM5zalIoPVAxPxPERWxEkGikit9hYuoVCDNT1taPw2
         1FPG67kC8ZIA4GVMB87cYrp+k+/O/AMmPmxcDWkTZaYrTkxeIhjC5j/Ieup1FEDpgqp0
         NhSA==
X-Gm-Message-State: APjAAAWN2pvuXoHIAiOP+DSoh8wEheJQxvCJyPqUGsVxDJhrlgugQWHy
        mXucSGByUGbnldgmx/Q4T3E=
X-Google-Smtp-Source: APXvYqzT9aYBz3/7MPDvcf9f3RghcGuGIfBwl51biDCA08aiGGpUuGJFJY11axuw408xg1EDmNmMhg==
X-Received: by 2002:aa7:86c3:: with SMTP id h3mr34070039pfo.225.1579117522010;
        Wed, 15 Jan 2020 11:45:22 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id c14sm22569404pfn.8.2020.01.15.11.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 11:45:21 -0800 (PST)
Date:   Wed, 15 Jan 2020 11:45:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e1f6bd0cb367_72f02acbae15e5c44a@john-XPS-13-9370.notmuch>
In-Reply-To: <157893905569.861394.457637639114847149.stgit@toke.dk>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk>
 <157893905569.861394.457637639114847149.stgit@toke.dk>
Subject: RE: [PATCH bpf-next v2 1/2] xdp: Move devmap bulk queue into struct
 net_device
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> =

> Commit 96360004b862 ("xdp: Make devmap flush_list common for all map
> instances"), changed devmap flushing to be a global operation instead o=
f a
> per-map operation. However, the queue structure used for bulking was st=
ill
> allocated as part of the containing map.
> =

> This patch moves the devmap bulk queue into struct net_device. The
> motivation for this is reusing it for the non-map variant of XDP_REDIRE=
CT,
> which will be changed in a subsequent commit.  To avoid other fields of=

> struct net_device moving to different cache lines, we also move a coupl=
e of
> other members around.
> =

> We defer the actual allocation of the bulk queue structure until the
> NETDEV_REGISTER notification devmap.c. This makes it possible to check =
for
> ndo_xdp_xmit support before allocating the structure, which is not poss=
ible
> at the time struct net_device is allocated. However, we keep the freein=
g in
> free_netdev() to avoid adding another RCU callback on NETDEV_UNREGISTER=
.
> =

> Because of this change, we lose the reference back to the map that
> originated the redirect, so change the tracepoint to always return 0 as=
 the
> map ID and index. Otherwise no functional change is intended with this
> patch.
> =

> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

LGTM. I didn't check the net_device layout with pahole though so I'm
trusting they are good from v1 discussion.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
