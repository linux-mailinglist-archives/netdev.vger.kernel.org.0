Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28A1E8437
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgE2Q6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:58:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52249 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgE2Q6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590771532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tGbByuZRXmFAd1dhTbS4zQ9lQJnPiWlv2z/6LTD3Nc=;
        b=Mf7pEGjX+Ynhnc/HBdBdqGb6wIvAa71A9uJC8h3BTjyhLPswL5rYhuOMIzI0CNMRLu5ci3
        rXbUji3kVeP5WT4BKuiWqTaMpKepjCiBKzOGVKEHqUtUXGyfqRmFVx3R6XvlnKV2v3B8+U
        vOBPMzDJKHSvsY802AO7A9NlhQS0jFM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-x9aZN-tNPzaumoV-Qn-e-A-1; Fri, 29 May 2020 12:58:49 -0400
X-MC-Unique: x9aZN-tNPzaumoV-Qn-e-A-1
Received: by mail-ed1-f72.google.com with SMTP id t23so482700edq.5
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 09:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3tGbByuZRXmFAd1dhTbS4zQ9lQJnPiWlv2z/6LTD3Nc=;
        b=CTyakhJSepI2E/3+9p1Wff/pf9u0znvoDmOqZQHpr/9kD1gZoMsbSi/RbdslgGXXl3
         7VvHF4m07l5/CIIEmlLpv1KOUhGDTZAc4Uns+aBIiPHL7RayO3KwTAgT/r/8XqA4dcUE
         bDRazFKxP4g0h3nwTAQNMm4KmNm8l2LOYF/l96opfEW7eFrKZ6FSXyOdv9B5s8RA70Kw
         VcqAtC+529JlMlx2MWKgXwNXOP9mgOoGlEJuTT1zyMaIcBwqNdpRaloZjHjHmDgCDaf9
         qy8RuE1/y0T4SqwQUN8DOfgLW3ezdDJBWM4AuMmwKGgq+BSRZuH2G4vWHDSRTpj+lCtI
         XhMg==
X-Gm-Message-State: AOAM530HdhuvCHMocUzcU3+VqGoe4H63Oq4QiEqv7k1cppgy1qF5begg
        8wYjVoclA82V7tuZzmmTidMpyPC+Uebmu+hlUc4LK5nRWrxCKsb4yJHZblj4d5i91+k+OuBvf9F
        249HP0GqMSLvm6Ewz
X-Received: by 2002:a17:906:a402:: with SMTP id l2mr9054159ejz.14.1590771527867;
        Fri, 29 May 2020 09:58:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoWj0+rD5MVx5oFzuR+OBuCd+njf3lM2FmatSR0r39pJxoz4nqQBEhHHIeZZnLhbUlr1oHDQ==
X-Received: by 2002:a17:906:a402:: with SMTP id l2mr9054143ejz.14.1590771527699;
        Fri, 29 May 2020 09:58:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id dj28sm7334529edb.69.2020.05.29.09.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:58:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AAD59182019; Fri, 29 May 2020 18:58:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, lorenzo@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH v3 bpf-next 5/5] selftest: Add tests for XDP programs in devmap entries
In-Reply-To: <a8fd8937-25d7-0822-67a7-e01b856261be@gmail.com>
References: <20200529052057.69378-1-dsahern@kernel.org> <20200529052057.69378-6-dsahern@kernel.org> <87r1v2zo3y.fsf@toke.dk> <a8fd8937-25d7-0822-67a7-e01b856261be@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 May 2020 18:58:46 +0200
Message-ID: <87lflazni1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/29/20 10:45 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.=
c b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
>>> new file mode 100644
>>> index 000000000000..b360ba2bd441
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
>>> @@ -0,0 +1,22 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* fails to load without expected_attach_type =3D BPF_XDP_DEVMAP
>>> + * because of access to egress_ifindex
>>> + */
>>> +#include <linux/bpf.h>
>>> +#include <bpf/bpf_helpers.h>
>>> +
>>> +SEC("xdp_dm_log")
>> Guess this should be xdp_devmap_log now?
>>=20
> no. this program is for negative testing - it should load as an XDP
> program without the expected_attach_type set. See the comment at the top
> of the file.

Ah, right, sorry - missed that (obviously) :)

-Toke

