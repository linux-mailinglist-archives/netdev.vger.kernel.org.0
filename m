Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C526C32620D
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBZLjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhBZLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 06:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614339464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rikGehM9mwA1nuC9BKnS7TVn/QfaVjDSfEE0cqyBQ9A=;
        b=BhYknFRW3FrHyzuKj0yj7aRgPoP+LaVbmgS0jVRtED2ezVqbpd2fxfobe/ZeswH1Luzem8
        EqddT7Tb2aOQKIetQ5W1aFLCUdqkW4n28nugFVF/7lYgiaBGzp70OUT5GY7Om+2AaqLT2P
        GV7povUKtG6Ja4eJEwyNvWZJI6tZaP4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-Zq9d7JUDNsyDqIrZ_3xKog-1; Fri, 26 Feb 2021 06:37:42 -0500
X-MC-Unique: Zq9d7JUDNsyDqIrZ_3xKog-1
Received: by mail-ed1-f70.google.com with SMTP id z12so4343917edb.0
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 03:37:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=rikGehM9mwA1nuC9BKnS7TVn/QfaVjDSfEE0cqyBQ9A=;
        b=AaC5mJglyot3mwtbXoKdwZtHKUO1kahzyjMXEk9YJtABpdvsR1SgSczZx/r6W45LY5
         uPoYHdH431GYx688sL04LMEdwxUbGKfrJhk6j3dNqaw4ZXzVh5yAJDTqdrC6TjJHGk1n
         vlk/8qoxdLZvAz0sgous9uMEL3aqkmMDiu2bfPHnTeLiEQ0lbo7Lpx21jr8l5B/W4iu6
         4WXGNRpKpKQHpuf1qV+2+dHihftjU74DKrhh/tq4C9fs8rws38wLaX+Tai6mlMspbhkW
         6sd7qb80HsMBqxkuV0HP5uD6+TUmjFAvLgFn6gZhlFP9xxXMy93RnDXBlcy4/GH6jxmw
         fy1Q==
X-Gm-Message-State: AOAM530HsEytDvmx2Tpjcy5VMdC2utvaoTBcBV6kLQGDT17UeSE0o508
        5HCdHC7QQ6GKQwmRzQ1PjVY5xN8wKJc3BhvHVzq8ya65eDkn7kwBIVF6HYQV+RblkB2XA3OtPqO
        RRcuqROiAnzVPKpzr
X-Received: by 2002:a17:906:8593:: with SMTP id v19mr2937002ejx.32.1614339461631;
        Fri, 26 Feb 2021 03:37:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXn/h5D6IkRtSIeDsQ/6ZHYlmsIQmw0U+/xrByjFJmIDx4A8bxWkPzAFulORPtyVc1cPiL0g==
X-Received: by 2002:a17:906:8593:: with SMTP id v19mr2936976ejx.32.1614339461378;
        Fri, 26 Feb 2021 03:37:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id lu26sm3566077ejb.33.2021.02.26.03.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 03:37:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B98B7180094; Fri, 26 Feb 2021 12:37:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
In-Reply-To: <20210226112322.144927-2-bjorn.topel@gmail.com>
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <20210226112322.144927-2-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Feb 2021 12:37:40 +0100
Message-ID: <87sg5jys8r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Currently the bpf_redirect_map() implementation dispatches to the
> correct map-lookup function via a switch-statement. To avoid the
> dispatching, this change adds bpf_redirect_map() as a map
> operation. Each map provides its bpf_redirect_map() version, and
> correct function is automatically selected by the BPF verifier.
>
> A nice side-effect of the code movement is that the map lookup
> functions are now local to the map implementation files, which removes
> one additional function call.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Nice! I agree that this is a much nicer approach! :)

(That last paragraph above is why I asked if you updated the performance
numbers in the cover letter; removing an additional function call should
affect those, right?)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

