Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BDAE6219
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 12:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfJ0LIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 07:08:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43314 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbfJ0LIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 07:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572174521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHN22A9gnCxHdcuhoMHMy6YsJILpdXlmmsOKyHoaT0o=;
        b=E8oQjMDI9mGhzJ+u4coPgIHyY7dOlSA8FYOI2wTVqp6mAFPRwTxeP3PMiW6LBUup+y7cZL
        C7gF7A3Nx4WEOylqxz7LPkBP9qjYSFCrry6smI+dlP3dOM1YVAseqFThO2HTTe7FXmPqrW
        0HgAR55kTgZPHMu7+VDCi+wc8B4TipM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-t3zzpc8GNGKJyfMqFCmFUg-1; Sun, 27 Oct 2019 07:08:40 -0400
Received: by mail-lf1-f72.google.com with SMTP id m24so1289452lfh.22
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 04:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dElSF+lQ+3cIY+cF6leGiEjya6M0kDJpL5229CTlOT4=;
        b=LK/YzSFAI5U6togTKYyI8jMY56wGGijSLWA8dLyANLKRuNWSf35yhD6wgZjyorEoPW
         r40YKQR9JHkc39vNAIX5KvLxnxNO541YrLX35gcnfQfq3GTez9QNy3jaRIwssOpzIEcB
         eLyIK9x8Askmf33UGbkfrvjDNNobtinoaiZ/Qaa4acRJFOZyqH5hfhQC6AQX62POQ6XX
         4orlDhrh1kHV9hj5FAIhwExTLA+a33/b4I0ERO366R14/v7VFD3xusaa23h3XR2b524w
         4g5YeBCozGXF0wwc9TeHng5Tgih9g/vHrv+fXaMOJ30z3MaFDI6CTiJvJS2WEc/DBjoi
         YFHQ==
X-Gm-Message-State: APjAAAVrhLHCG4dM8Z2iMJY6xs9Ob85vnEvLpjMDDLc1AEkQaFJX/2iM
        vODSvbeuc4pJVK9J7K9Uy5y/lhEzYEu/Kgy0B267t0Q4mcBGpBxmK8c1vYe9MlTOHWaxnOSt/6h
        JjC6jMovovTO8Yt2l
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr8615516lji.226.1572174518669;
        Sun, 27 Oct 2019 04:08:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzt2hkdjbXLWipsGkmGcCPwdnR3pF8eyEXYho3y6PJ2Pg7f1W5ZhwTKxSWO0Jud1tLlXtUvFA==
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr8615504lji.226.1572174518425;
        Sun, 27 Oct 2019 04:08:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 90sm12139164ljc.0.2019.10.27.04.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 04:08:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5110E1818B4; Sun, 27 Oct 2019 12:08:36 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_set_log_level() function to adjust logging
In-Reply-To: <CAEf4BzZAutRXf+W+ExaHjFMtWCfot9HkTWZNGuPckBiXqFcJeQ@mail.gmail.com>
References: <20191024132107.237336-1-toke@redhat.com> <CAEf4BzZAutRXf+W+ExaHjFMtWCfot9HkTWZNGuPckBiXqFcJeQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 27 Oct 2019 12:08:36 +0100
Message-ID: <87sgnejvij.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: t3zzpc8GNGKJyfMqFCmFUg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Oct 25, 2019 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Currently, the only way to change the logging output of libbpf is to
>> override the print function with libbpf_set_print(). This is somewhat
>> cumbersome if one just wants to change the logging level (e.g., to enabl=
e
>
> No, it's not.

Yes, it is :)

> Having one way of doing things is good, proliferation of APIs is not a
> good thing. Either way you require application to write some
> additional code. Doing simple vprintf-based (or whatever application
> is using to print logs, which libbpf shouldn't care about!) function
> with single if is not hard and is not cumbersome.

The print function registration is fine for applications that want to
control its own logging in detail.

This patch is about lowering barriers to entry for people who are
starting out with libbpf, and just want to find out why their program
isn't doing what it's supposed to. Which is not the point to go figure
out an arcane function pointer-based debugging setup API just to get
some help. Helping users in this situation is the friendly thing to do,
and worth the (quite limited) cost of adding this mechanism.

If you're objecting to the new API function, an alternative could be to
react to an environment variable? I.e., turn on debugging of
LIBBPF_DEBUG=3D1 is in the environment? That way, users wouldn't even have
to add the extra function call, they could just re-run their application
with the env var set on the command line...

> If you care about helping users to be less confused on how to do that,
> I think it would be a good idea to have some sort of libbpf-specific
> FAQ with code samples on how to achieve typical and common stuff, like
> this one. So please instead consider doing that.

The fact that you're suggesting putting in a FAQ entry on *how to enable
debug logging* should be proof enough that the current API is
confusing...

-Toke

