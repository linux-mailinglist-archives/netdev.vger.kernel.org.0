Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031F11174A9
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfLISnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:43:24 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37599 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfLISnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:43:23 -0500
Received: by mail-pf1-f195.google.com with SMTP id s18so7670055pfm.4
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 10:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=IIH0mWEOKsrcmUy6W4S6vhOIAF99APXeNHDFU0+OuwU=;
        b=AtitwyU5jG9dUQgdTtVCGo+WvR+V5xoyOXDZnvs1Xma9x4r123GcU5mVq2ySCFO27j
         bp/826+4nJMux9V+IUJgYpLdDKC5BraO2w9IVzwB406YKaGsk631poHYEoGnWSpIfyWo
         uYyCIHrNASD0reSbdZqLgB+vV1uAmtBV1XhL0HAfAAbS4Tqp0MoTg//95jLuNNB8tfKl
         qPMvG+UirHZ0IpBISVMc9wMYj4Jf7FPt4dkUoW78W7gNnMnxhoi7/66HyEj46GLzLjNB
         rEXqVybTNZBWCO60EuWtp34Wu18BnPXGDJ8QujFJVWzHatSopGoUgnTPJTc53NWGKwi/
         BhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=IIH0mWEOKsrcmUy6W4S6vhOIAF99APXeNHDFU0+OuwU=;
        b=BpxDhoaziRqEeKR4uOzYwzh8qw5N3BojFOKqsRNsodoyNGj4f9ayrUSmj1sr4VbCHZ
         recRaVRfT3OC2Q2AvL/9zEBBIYo4mDoxptP/YKONwFIKXjZYlVNoCMyT11wpVC3H3czF
         V0dJdRJN2q1w+uFjMGEejsvljUqgPtb/vmqTbpuYJL3LOrnWprPdKiWGrf4LwzsPSe/G
         u4S+RRB6sTZVpJxTxD9Kk41+lYnOkQmsmpvLucIfmE6ihOpcx4dBA7nDpFCQ8yUMjGMI
         5KCcWj69VSPyMKHPLtTbTEeoPYa5aIlmhEbPVL2G+Fzkz/gcBdNKFv15eacS0+V7Pe2Y
         FWkw==
X-Gm-Message-State: APjAAAXgOTtpxA1187uV2NIymLppNCoqWB/fhp3Pn5lBK4cxoBmBYimu
        FvONWy59XLGpbPEQtqfBlO5tVg==
X-Google-Smtp-Source: APXvYqxzV/mu35PgMYvXJ8tR4re+h252qjg9YNYgXGnvNKzHqxJjS+0qR0RPmVMaDkNSG+YYcc0pGA==
X-Received: by 2002:a63:3245:: with SMTP id y66mr20161392pgy.234.1575917002492;
        Mon, 09 Dec 2019 10:43:22 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:e2:ee2:815a:30c4? ([2601:646:c200:1ef2:e2:ee2:815a:30c4])
        by smtp.gmail.com with ESMTPSA id a2sm200336pfg.90.2019.12.09.10.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 10:43:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Date:   Mon, 9 Dec 2019 10:43:19 -0800
Message-Id: <F6840B11-060A-48F2-9FFE-774E73C50765@amacapital.net>
References: <efffc167eff1475f94f745f733171d59@AcuMS.aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <efffc167eff1475f94f745f733171d59@AcuMS.aculab.com>
To:     David Laight <David.Laight@aculab.com>
X-Mailer: iPhone Mail (17A878)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 9, 2019, at 3:01 AM, David Laight <David.Laight@aculab.com> wrote:
>=20
> =EF=BB=BFFrom: Eric Dumazet
>> Sent: 06 December 2019 14:22
> ...
>> Real question is : Do you actually need to use recvmsg() instead of recvf=
rom() ?
>> If recvmsg() provides additional cmsg, this is not surprising it is more e=
xpensive.
>=20
> Except I'm not passing in a buffer for it.
> The reason I'm looking at recvmsg is that I'd like to use recvmmsg it orde=
r to
> read out more than one message from a socket without doing an extra poll()=
.
> Note that I don't expect there to be a second message most of the time and=

> almost never a third one.
>=20
> Although I think that will only ever 'win' if recvmmsg() called vfs_poll()=
 to find
> if there was more data to read before doing any of the copy_from_user() et=
c

I would suggest a more general improvement: add a -EAGAIN fast path to recvm=
sg().  If the socket is nonblocking and has no data to read, then there shou=
ldn=E2=80=99t be a need to process the iovec at all.=
