Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EDA2CB9DB
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbgLBJ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:57:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388269AbgLBJ5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606902936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GTdHhx4SS0ruAGPviFYgmLqy6rqHBMqdUWgmr00VutI=;
        b=Gi/fsQe/nhb91qDc9WptEYgouSnpZjamxJivxlJfk+ZWJYCACu+E4As4dFkN5tI/35QE2s
        96eNY9QnDt3ntziHRi2Vx7tkrlHM7pIDdi8iMm9yeIvRivxIjuK0PaEciEx4HZl2btwaxT
        wTe8jiMaZsvGWI4CO8RR4ks0O+7oC7E=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-WXrw4VVxNUGeAAr1bE2mmQ-1; Wed, 02 Dec 2020 04:55:35 -0500
X-MC-Unique: WXrw4VVxNUGeAAr1bE2mmQ-1
Received: by mail-qt1-f200.google.com with SMTP id r29so939034qtu.21
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:55:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GTdHhx4SS0ruAGPviFYgmLqy6rqHBMqdUWgmr00VutI=;
        b=BSG64X1dC15luwccCIed8V403VbZgzzsQZxEcVkgP5sB3bXP97fhgmxIVumZhWFR2e
         47WOL0UmlrgmCsqJu6WF3HC/EniMZyZ+CsCsGCgsmaYHXcfvbTLsOJUrAH3s0ouw3xwS
         3kCgrYdu7rxagVIW9+h8wN8hiDN04LvxTOh5glHSILbT4PlDjaK7eQ9A8A9YQ3Scn23w
         HRFNWnjLKgkVZGXdl+Sh+wbnGsj1Sjt+QcGwx82w2LyKtx5U0NWyv0flzfu6bXdOlbuL
         7NCAErT1PN0kDX5fpaIWAFhCHnUy7fVt4SooyU/xJv7i/JtbMESRMuXdr7SdFfEL9VSl
         /bcg==
X-Gm-Message-State: AOAM531P8bVoDg8CRukm0qdevZRcvQ/yxI4/R+9m97PrqDtb+DceCaKW
        qIUvK5D1sStYMX7TzkIIUOFuMcCibBd99/Ixaxhp6eTehSPElogqJPhdg/tyxy8PUy3jj4feA/b
        2riBgX98pVN+tDQMg
X-Received: by 2002:ad4:4807:: with SMTP id g7mr1755300qvy.26.1606902934582;
        Wed, 02 Dec 2020 01:55:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBHzQR/4Voy0A86XcmxRKjTC+xG2CcogcWu3CTnsGlRmotHDJhNuzNi2RWoJe2cf1bkNlHdw==
X-Received: by 2002:ad4:4807:: with SMTP id g7mr1755291qvy.26.1606902934420;
        Wed, 02 Dec 2020 01:55:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o125sm1261383qke.56.2020.12.02.01.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:55:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 51F31182EE9; Wed,  2 Dec 2020 10:55:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: sanitise map names before pinning
In-Reply-To: <CAEf4BzYKWnNQqLOxgUaj=qOP15wpMY8axYxfRDukvw8Wypbjgw@mail.gmail.com>
References: <20201130161720.8688-1-toke@redhat.com>
 <CAEf4BzYKWnNQqLOxgUaj=qOP15wpMY8axYxfRDukvw8Wypbjgw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Dec 2020 10:55:32 +0100
Message-ID: <87r1o8cz1n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Nov 30, 2020 at 8:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> When we added sanitising of map names before loading programs to libbpf,=
 we
>> still allowed periods in the name. While the kernel will accept these for
>> the map names themselves, they are not allowed in file names when pinning
>
> That sounds like an unnecessary difference in kernel behavior. If the
> kernel allows maps with '.' in the name, why not allow to pin it?
> Should we fix that in the kernel?

Yeah, it is a bit odd. I always assumed the restriction in file names is
to prevent people from creating hidden (.-prefixed) files in bpffs? But
don't actually know for sure. Anyway, if that is the case we could still
allow periods in the middle of names.

I'm certainly not opposed to changing the kernel behaviour and I can
follow up with a patch for this if others agree; but we obviously still
need this for older kernels so I'll send a v2 with the helper method you
suggested below.

-Toke

