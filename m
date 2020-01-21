Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51801440A0
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgAUPhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:37:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727817AbgAUPhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579621058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEbtb5iPk+ToPcHf5Qqxgw96P5QADIf6QorZP19ushc=;
        b=LGWh9SEgWVVTcFN2egblWoWmoNLGC8W2pQDDwIKLF4L5Z0/jLSO3leUdmDfcCg/gSL5vek
        3fDDIMni8i7pzK9JiMthwOd1GVGcGY8SdAtH9cqpK9GFU6Cq06ExzAAG2K0Yk9VXEH2ID2
        ivkwGkSP14ZjCnhJ5rcxWeArjeylsmg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-onUlVbz6OnK5m4VPK1BN_w-1; Tue, 21 Jan 2020 10:37:35 -0500
X-MC-Unique: onUlVbz6OnK5m4VPK1BN_w-1
Received: by mail-lj1-f198.google.com with SMTP id o9so383135ljc.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 07:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=KEbtb5iPk+ToPcHf5Qqxgw96P5QADIf6QorZP19ushc=;
        b=M33i1ssIBMnPXX8VKpsVqAUwtQtw6VmRctNDbTvnnP1vZi35f+fhuS98lKTmTBWmHy
         KAw5IDmmzX8wSu2gVetXIPnUs8dRsP8XIAg0doQqk49hn+rWTWyPZnMjY1SCVp3sW5U3
         oiQgeYigAvnT4QeoKo48voyBKkfNdYv8G4kUsS6VZY1SNNV9jkz0whxrysosbXO7ACDC
         o3VeRQdAmPSbEjJI4Sdxx/2FN1R72WbWehhV0z6982FRnu3p2lRdCXAMON/wlopBSV3T
         zWIVg3t8ijWZK2NE5nuRSB9hGLchiFIT7/P2SYmLoSfGDsmhx8gZfLUri5xm8T/obU6b
         SjsQ==
X-Gm-Message-State: APjAAAVK7jrscR8ksKYw8viToqQrJ9T8dObOimvt8YEkW+3GyaPiU0uL
        RcVGHmtld5wOyR/2AbCmlY2duirxRoCytiVpt3WUx9BVyF9FsMUcdGABCk/pUMfIXT2fvwYeLWk
        2+UAALYcFxK9L5l2d
X-Received: by 2002:ac2:5964:: with SMTP id h4mr2950784lfp.213.1579621054189;
        Tue, 21 Jan 2020 07:37:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6uaYdLVGSTACmkFUIlBWi+Ha5SsSLjiSCZDkG7dr7z3tLFd30yps7dKGbcY0cYUdeEr7ISw==
X-Received: by 2002:ac2:5964:: with SMTP id h4mr2950770lfp.213.1579621053832;
        Tue, 21 Jan 2020 07:37:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o19sm22699778lji.54.2020.01.21.07.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 07:37:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AE53118006B; Tue, 21 Jan 2020 16:37:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Program extensions or dynamic re-linking
In-Reply-To: <20200121005348.2769920-1-ast@kernel.org>
References: <20200121005348.2769920-1-ast@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Jan 2020 16:37:31 +0100
Message-ID: <87k15kbz2c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <ast@kernel.org> writes:

> The last few month BPF community has been discussing an approach to call
> chaining, since exiting bpt_tail_call() mechanism used in production XDP
> programs has plenty of downsides. The outcome of these discussion was a
> conclusion to implement dynamic re-linking of BPF programs. Where rootlet=
 XDP
> program attached to a netdevice can programmatically define a policy of
> execution of other XDP programs. Such rootlet would be compiled as normal=
 XDP
> program and provide a number of placeholder global functions which later =
can be
> replaced with future XDP programs. BPF trampoline, function by function
> verification were building blocks towards that goal. The patch 1 is a fin=
al
> building block. It introduces dynamic program extensions. A number of
> improvements like more flexible function by function verification and bet=
ter
> libbpf api will be implemented in future patches.

This is great, thank you! I'll go play around with it; couldn't spot
anything obvious from eye-balling the code, except that yeah, it does
need a more flexible libbpf api :)

One thing that's not obvious to me: How can userspace tell which
programs replace which functions after they are loaded? Is this put into
prog_tags in struct bpf_prog_info, or?


For the series:
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


-Toke

