Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA337450988
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhKOQYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:24:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232435AbhKOQXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636993249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJXd3y47Yvuh4jq6RhS8xDO4xus8QSeywbiwUwhav7s=;
        b=M3mKJAdC0CpSzzobSWjAVZur9dkY7peMTzyeFGhztwfguWYWb2wucglZJccLbDrrk+o1Qh
        Euc2ZQzBeK9Ne7BSQqMaZ/LHJAMtShfTz8g5hOQw403+T2AVKoPwVRGBDDCbNANHkHYiHr
        IpquQBjngoI7x0Se3cgy6iR7NGtY41o=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-CFAJL2_kPGiaBZasFs6__A-1; Mon, 15 Nov 2021 11:20:48 -0500
X-MC-Unique: CFAJL2_kPGiaBZasFs6__A-1
Received: by mail-qk1-f199.google.com with SMTP id p18-20020a05620a057200b00467bc32b45aso11426999qkp.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:20:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hJXd3y47Yvuh4jq6RhS8xDO4xus8QSeywbiwUwhav7s=;
        b=h/t1QfgzVr8oOogLNedCKl5ahjjQZIXzXikzbxGPJOZUilkhxUByZ5YcT+4YhE+y6u
         BUfPhR0JRW+JMOu7+Qktk2UZWVJZjfl9gKNLKH8PQIQVAUj1Z2H2UxeyykSdX/PBO+fv
         nNWFfqTBzcO2rpLa0ZT5v5mO1A42RAC0fI1QS8NnAcJJE3ao6eubU4idWL1DZaVemZk3
         /xx08fGqDeYBIGaFX5y/eSXZtF7TFXWiOrF3W6rOL42/7qOI2S4eQ5pYtcLNk4QWqctG
         RP4ZMxUeBzlOfbpR0iiuiY3XpDrpqhk2PZK4F3QvEwAeifYIsmHGLh4sgmIFsPHmPrZU
         KCyw==
X-Gm-Message-State: AOAM5325fYM31T6L1K/Of4WxigkB64jQHvH5MQxOwuQSOjVzP2oKGBRZ
        DqfVBTP0ILczoBLxjxMJOVdxzup0khZoniAhDsvnso4t7bwvSeUkfcVAbwC9xom7Wy9wuc6Ow0i
        yVehrp0njeF3n5mzl
X-Received: by 2002:ac8:5855:: with SMTP id h21mr243849qth.8.1636993247375;
        Mon, 15 Nov 2021 08:20:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznTB6ASLKQoL3laWA31P0QaPk9N0ZM4IS6XXkdl36U8FSBxNvhTFzyGLHOG8DQoDP7389EFA==
X-Received: by 2002:ac8:5855:: with SMTP id h21mr243788qth.8.1636993246950;
        Mon, 15 Nov 2021 08:20:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m9sm7114499qkn.59.2021.11.15.08.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 08:20:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DCB4718026E; Mon, 15 Nov 2021 17:20:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] bpf: do not WARN in bpf_warn_invalid_xdp_action()
In-Reply-To: <188c69a78ff2b1488ac16a1928311ea3ab39abed.1636987322.git.pabeni@redhat.com>
References: <cover.1636987322.git.pabeni@redhat.com>
 <188c69a78ff2b1488ac16a1928311ea3ab39abed.1636987322.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 15 Nov 2021 17:20:38 +0100
Message-ID: <875ysto0fd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> The WARN_ONCE() in bpf_warn_invalid_xdp_action() can be triggered by
> any bugged program, and even attaching a correct program to a NIC
> not supporting the given action.
>
> The resulting splat, beyond polluting the logs, fouls automated tools:
> e.g. a syzkaller reproducers using an XDP program returning an
> unsupported action will never pass validation.
>
> Replace the WARN_ONCE with a less intrusive pr_warn_once().
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

