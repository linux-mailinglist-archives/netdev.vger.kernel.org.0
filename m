Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516EA30046B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbhAVNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:42:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727179AbhAVNmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 08:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611322844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T8/dpz659mbFNh9PVeskulIsAiFLuZwS2fClqbyn3YM=;
        b=IHmcGmF1V0D0wKqz0E7sCMMoccEbiEsxLHZxeW/k0r3pQYjTxZjpxebGOzyXHWQKG7kFa7
        0XQSmbRLkYoYUuZA7Xxl7R3gjGcu6g2uYQ45V918lODo1RnK1f1YInw8FXe3pw3fmVs3TT
        z33EI9Z/U3zl8YdyKTj2ehRdyCJz+Jg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-OYfwsH18NFesO_stpOxmkA-1; Fri, 22 Jan 2021 08:40:43 -0500
X-MC-Unique: OYfwsH18NFesO_stpOxmkA-1
Received: by mail-ed1-f69.google.com with SMTP id a24so2915400eda.14
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 05:40:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=T8/dpz659mbFNh9PVeskulIsAiFLuZwS2fClqbyn3YM=;
        b=ZjINADOz50xN1BTBuk7LEBk4yuFtc1joIwJoSwLYPrZrKqX/d/xP91p1vYDPhnrnMU
         FFX85NiMoDkunNcMN+YELltT3Bxd66/9fO+nPZIruAkJCSbri3meuhlHbHfqRiKlnTmR
         kSshGvZUfK+jhN37+eR4hT4gnXuNOSHCz3KU/fHz6JHRGCoPEXrmmwFLKOgbnlIacnDK
         AV4ZpIg33jGbeMIHUT7EIP+OA0OLhgDJxiiK/8cHDvKxlwI9wOy7lrIouAsqNs2o64oW
         38gnrF4WhaXTrpt0tgMaLTZa8cpKQMvAGs7WhTvdU/Sd2wMW1TkmEnGfMKvym8W0C4r/
         TcYw==
X-Gm-Message-State: AOAM533pWs+6klt6kHivvOrpwKsyBw8CpBocUV4j6gsjekvS9U0uWm0E
        uH6UvZ+ckYpILqtrSVYZjFzjatM0LS4UzD27Fngdx8C76/tqtXpc1u62qi7RRPqhxun6m99YPhe
        YLegIOMeeSIa9Fol2
X-Received: by 2002:a17:906:ff43:: with SMTP id zo3mr2959951ejb.542.1611322842178;
        Fri, 22 Jan 2021 05:40:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOicqAnMz/rfgF1MSmZt6fZrskk1X4SXMSNmV7CV2eRyt+QfLPZcYukOmJGeJkXkw95BNOuw==
X-Received: by 2002:a17:906:ff43:: with SMTP id zo3mr2959932ejb.542.1611322842062;
        Fri, 22 Jan 2021 05:40:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g90sm5756006edd.30.2021.01.22.05.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 05:40:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 14110180338; Fri, 22 Jan 2021 14:40:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next 0/3] AF_XDP clean up/perf improvements
In-Reply-To: <82c445fd-5be8-c9e8-eda1-68ed6f355966@intel.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
 <877do56reh.fsf@toke.dk> <82c445fd-5be8-c9e8-eda1-68ed6f355966@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 Jan 2021 14:40:41 +0100
Message-ID: <87y2gl5bty.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-22 14:19, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>>> This series has some clean up/performance improvements for XDP
>>> sockets.
>>>
>>> The first two patches are cleanups for the AF_XDP core, and the
>>> restructure actually give a little performance boost.
>>>
>>> The last patch adds support for selecting AF_XDP BPF program, based on
>>> what the running kernel supports.
>>>
>>> The patches were earlier part of the bigger "bpf_redirect_xsk()"
>>> series [1]. I pulled out the non-controversial parts into this series.
>>=20
>> What about the first patch from that series, refactoring the existing
>> bpf_redirect_map() handling? I think that would be eligible for sending
>> on its own as well :)
>>
>
> Yeah, I'm planning on doing that, but I figured I'd wait for Hangbin's
> work to go first.

Ah, right, good point; cool! :)

-Toke

