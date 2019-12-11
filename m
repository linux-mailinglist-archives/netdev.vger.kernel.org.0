Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B6911ABEC
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfLKNUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:20:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23278 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728265AbfLKNUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:20:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576070419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/u/4ZEqQP0e+uS2+lCszxa5LZBpaQoPz1LVNN7voyg=;
        b=dE92+E8Keo6YqSkUKbQr++CMuiQIjplKbMtXwxLR0fWUD8bB7y+amC3EK6XdBZG3b2yX/K
        lp0cS0lQKTzj4978xYr3d/J15PIhdqDY8iDFyGL5vD2ZYDQDEFAgKHOIPeHZCagY9KIbYS
        SX6HWPIMMFf0vzb0yKQw2XPkUbdr/UM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-kgcngnt6M9WjqmFa8X4S3w-1; Wed, 11 Dec 2019 08:20:15 -0500
Received: by mail-lj1-f197.google.com with SMTP id d14so4383833ljg.17
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 05:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=o/u/4ZEqQP0e+uS2+lCszxa5LZBpaQoPz1LVNN7voyg=;
        b=q0PBRXBu041c5Jj5GV09hQ2SOH2KLF2et+O7s4ZzvK5XD1RDnaEGDJyLJRfrDH5z/a
         ApCZMM9C+ApBXVCrFCPO02+VxWMf1Hbwvc647MBpGb+CMTNbjGD1qt4QPADuB6+yqwoC
         XybUFzRK3H6S/lD5kMwlXC6GFlX+EErAoJ6J6R7wLt4aAnVmuQOERZqffGaDQJBD3gx1
         Y7ClS5STmdzjQPfOksmQsd+5ADN8bctZuuGPJmKvCLn51h4UB0t2lfJ/uP0YAH4Q2j2Y
         jRqUM3b3kjZu+MXoetpl++R14FVgPLYGiiSfoxsW6p+uU3QmLgcAsjHHJQ06oNX+B/ib
         qeAg==
X-Gm-Message-State: APjAAAW4dJaaIXX7RW7CO8QcJpyBgaHwRSrfpXP3flnoDdnMD7RKfhuM
        1sCdEWP6kpEW+3Mll9n8I0J+xBYEGXv0r+J1O2xqBmHKN0SYtW+OfixVVBB1FqWvnsLSunrq/2Z
        bPAV9YJM6OdELI8PK
X-Received: by 2002:a2e:9b95:: with SMTP id z21mr1806006lji.112.1576070414500;
        Wed, 11 Dec 2019 05:20:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxiBoj4+UzNM6MVzGlRn15zbpyF65rItNLpqEE+jZ6WQC2/2JVmPf9if2K7dMUlgg9zx4M+KA==
X-Received: by 2002:a2e:9b95:: with SMTP id z21mr1805990lji.112.1576070414253;
        Wed, 11 Dec 2019 05:20:14 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c12sm1157656lfp.58.2019.12.11.05.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 05:20:13 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 64AA318033F; Wed, 11 Dec 2019 14:20:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or ksyms
In-Reply-To: <20191211130857.GB23383@linux.fritz.box>
References: <20191210181412.151226-1-toke@redhat.com> <20191210125457.13f7821a@cakuba.netronome.com> <87eexbhopo.fsf@toke.dk> <20191211130857.GB23383@linux.fritz.box>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 14:20:11 +0100
Message-ID: <87zhfzf184.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: kgcngnt6M9WjqmFa8X4S3w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On Tue, Dec 10, 2019 at 10:09:55PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> [...]
>> Anyhow, I don't suppose it'll hurt to have the Fixes: tag(s) in there;
>> does Patchwork pick these up (or can you guys do that when you apply
>> this?), or should I resend?
>
> Fixes tags should /always/ be present if possible, since they help to pro=
vide
> more context even if the buggy commit was in bpf-next, for example.

ACK, will do. Thank you for picking them up for this patch (did you do
that manually, or is this part of your scripts?)

-Toke

