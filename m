Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6311B27CF
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgDUN2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:28:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32011 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUN2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587475702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kgaefng3mD2dYf3gVvRv9YQpTDJ5185X3czBi1FHafs=;
        b=N0s/Ad0hL884Wdfs8mlPLNfs5ebcZv0/ioh2PuPUi6vkeSKICsew11WtwajaIiwWXSBxUU
        7ITSbY7lWWrMNMoe6Hdt02FbHHFw/OYkKL5MLsOaEmsT+OF+0VnXCUp1ueZEZsELXPY+uC
        h/dQ2vGBgkgRs35x7ZvZE4t/QLk0XbE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-X1w7q5UIOCaydDvhWIE0nw-1; Tue, 21 Apr 2020 09:28:20 -0400
X-MC-Unique: X1w7q5UIOCaydDvhWIE0nw-1
Received: by mail-lf1-f70.google.com with SMTP id h12so5741870lfk.22
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Kgaefng3mD2dYf3gVvRv9YQpTDJ5185X3czBi1FHafs=;
        b=VFGLGVzaVxR2BgH7wWSy2uZbwE/j0gYS/b9YZt8LyREaWl0nwunOzcjTVWwdKR7OPV
         tKY8l1PycYVsa9qh6JGBdlGmpY9BaoDAWLJUrt8gqCFX88qqNRecFZOE6Cub8vVucpcJ
         +8YKoI83G4Mhfr1GvAK5ZceVPTTjX/QGDGTC3tQpsffO3VmRba3QjUIxDQLlZ+pqZeZw
         bhkidieZEcJjtvNaeZP85rJSyt7lDJX7K4VdDfW9pCQHj1yYC1uDAdQFu1g/r9I10CGR
         gndeGNwcksvp4Ed/ltJlPTN3vDo5nRWmO9DpEofHIQU+VKWx8xt2Dlfw0LZ9bwaNae/e
         fmkw==
X-Gm-Message-State: AGi0PuZAMdX6OIaPppfOUaUtIF+d9NDa1Rkzghj3jqGjaZ5/4m8Cc2zb
        C0T5+Jj2/41F5f9iitRGb3lfZa31U4TY7h+1M5LEWOgMDiD9EMb6JKXteMurbDJHcg+Nqe4zg9E
        otk/bWPKtCOSxqVGg
X-Received: by 2002:a2e:8590:: with SMTP id b16mr7696209lji.45.1587475699289;
        Tue, 21 Apr 2020 06:28:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypI5WRoJ91SZNkpU6DOzUnUtEqS4B6s/g4iq5252n3k1NdKvi9L6H3LaxTPH5I8xgTZ5DuBvhg==
X-Received: by 2002:a2e:8590:: with SMTP id b16mr7696182lji.45.1587475699120;
        Tue, 21 Apr 2020 06:28:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z13sm1951682ljn.77.2020.04.21.06.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:28:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB5A618157F; Tue, 21 Apr 2020 15:28:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 12/16] libbpf: Add egress XDP support
In-Reply-To: <f2385dfc-87de-b289-c2f0-7ef79de74872@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-13-dsahern@kernel.org> <87a7359m3j.fsf@toke.dk> <f2385dfc-87de-b289-c2f0-7ef79de74872@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Apr 2020 15:28:17 +0200
Message-ID: <87k1297ytq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/21/20 4:20 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Isn't the kernel returning both program types in the same message when
>> dumping an interface? So do we really need a separate getter instead of
>> just populating xdp_link_info with the egress ID in the existing getter?
>
> That might work with some refactoring of get_xdp_info. I'll take a look.

Great, thanks! :)

-Toke

