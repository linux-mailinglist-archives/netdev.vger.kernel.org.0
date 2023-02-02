Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BF688527
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjBBRNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbjBBRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:13:48 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8E431E16
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:13:47 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-510476ee20aso35347427b3.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 09:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYolLOrpCs+EPTXTbkuBbcQbjcKJfJxfyu7DwbCKRBI=;
        b=TzDSaTD7smCwFr1Gp3ieJcPCwz6CHgu3Ir6e2bwqLQOPL6oAhDcYVgAG0vOuPVUCC3
         XIst/7xezSvKcjHKDJl0R1L8+IUD/QYmU3BhKCF1O+qAQXisd1spheqfWMX9/Y0UEU+2
         ajMPXNIog8mjIagQAUR+mMDcptfD7E5IB6PVyvICwAL6nswu5+E4pN8rZnMqbBm0uIz9
         lOlVpdOHvEN+PAkw6jSXM3j94qWzjj9b5tcAQqIrHNf+pjKdaY4t0afyUv55ZrM8sLyI
         OEsCdRIKYL9P5+IWEQUrf66eZTL1efa79svc0s16aJWztnnhPVBP0rqREGTTaCg/jcpu
         dD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYolLOrpCs+EPTXTbkuBbcQbjcKJfJxfyu7DwbCKRBI=;
        b=nqGJA0alEdkCwaQ/BSmdd457auf2A6XP+EaLMskrLxUTFSteq1H0eRyqMwwdhJqxSC
         CIgvjV9bt+b/T1IbaZl0N0uRlkrWAsGGcDcwWIxlR61HX9F1yjAYN8+z3lbQ5rxKv79L
         qFYs73IYj36BWR4kvg/dj5+5sO2urE1jSAZF3d1zMy0EoTu79sO7NEUbeUhjMWSdrYVK
         Od0UzBXLJQ2M9Xpu6q2CeIcey6o6idDAiI3sHiAdCz76V+lSjo+i8tlSbdaiS7w3O6OZ
         hT8zOp9ByFT7n0TUPkfbWmDYfNaT4Q+I8ZPSu4AEfELUleXYC3d8089p19OpJrnoXA4y
         VQsQ==
X-Gm-Message-State: AO0yUKUx1xAeYdnRVoobnydjCcmgRxuCvMekXrlB7mI9TqLo/F7TN71l
        N9kcQrXwM65GZU7mQnp8sHriw0BIOzCrcyzVWK0=
X-Google-Smtp-Source: AK7set+UK8uUpMaC0mUfIcYTjp7u+uj+139LfKiLM+gKYHloAgVbHmbHnl8pqB3avaINXbOGUAoNzRfx61t8hOGLnlw=
X-Received: by 2002:a81:ac05:0:b0:4fc:560a:f52d with SMTP id
 k5-20020a81ac05000000b004fc560af52dmr899570ywh.198.1675358026175; Thu, 02 Feb
 2023 09:13:46 -0800 (PST)
MIME-Version: 1.0
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org> <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
 <60962833-2EA3-449C-8F58-887C833DFC5C@holtmann.org> <10d117b6-a1bf-ee19-7d61-f6ba764aeab6@suse.de>
 <98A14BB2-67BB-4B63-8FC7-E673980EB773@holtmann.org>
In-Reply-To: <98A14BB2-67BB-4B63-8FC7-E673980EB773@holtmann.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 2 Feb 2023 12:13:26 -0500
Message-ID: <CADvbK_eiMmZgPr-L==-zMHDfej82aVv_-xMxv6iqroV2Q9yCHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Hannes Reinecke <hare@suse.de>, Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        hare@suse.com, dhowells@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com, bcodding@redhat.com, jlayton@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 9:24 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> I know, utilizing existing TLS libraries is a pain if you don=E2=80=99t d=
o
> exactly what they had in mind. I started looking at QUIC a while
> back and quickly realized, I have to start looking at TLS 1.3 first.
>
> My past experience with GnuTLS and OpenSSL have been bad and that is
> why iwd (our WiFi daemon) has its own TLS implementation utilizing
> AF_ALG and keyctl.
Hi Marcel,

I'm no expert on TLS, but I'm a supporter of in-kernel TLS 1.3 Handshake
implementation :). When working on implementing in-kernel QUIC protocol,
the code looks a lot simpler with the pure in-kernel TLS 1.3 Handshake APIs
than the upcall method, and I believe the NFS over TLS 1.3 in kernel will
feel the same.

>
> While that might have been true in the past and with TLS 1.2 and earlier,
> I am not sure that is all true today.
>
> Lets assume we start with TLS 1.3 and don=E2=80=99t have backwards compat=
ibility
> with TLS 1.2 and earlier. And for now we don=E2=80=99t worry about Middle=
boxes
> compatibility mode since you don=E2=80=99t have to for all the modern pro=
tocols
> that utilize just the TLS 1.3 handshake like QUIC.
>
> Now the key derivation is just choosing 1 out of 5 ciphers and using
> its associated hash algorithm to derive the keys. This is all present
> functionality in the kernel and so well tested that it doesn=E2=80=99t wo=
rry
> me at all. We also have a separate RFC with just sample data so you
> can check your derivation functionality. Especially if you check it
> against AEAD encrypted sample data, any mistake is fatal.
>
> The shared key portion is just ECDHE or DHE and you either end up with
> x25519 or secp256r1 and both are in the kernel. Bluetooth has been
> using secp256r1 inside the kernel for many years now. We all know how
> to handle and verify public keys from secp256r1 and neat part is that
> it would be also offloaded to hardware if needed. So the private key
> doesn=E2=80=99t need to stay even in kernel memory.
>
> So dealing with generating your key material for your cipher is really
> simple and similar things have been done for Bluetooth for a long
> time now. And it looks like NVMe is also utilizing KPP as of today.
>
> The tricky part is the authentication portion of TLS utilizing
> certificates. That part is complicated, but then again, we already
> decided the kernel needs to handle certificates for various places
> and you have to assume that it is fairly secure.
>
> Now, you need to secure the handshake protocol like any other protocol
> and the only difference is that it will lead to key material and
> does authentication with certificates. All of it, the kernel already
> does in one form or another.
>
> The TLS 1.3 spec is also really nicely written and explicit in
> error behavior in case of attempts to attack the protocol. While
> implementing my TLS 1.3 only prototype I have been positively
> surprised on how clean it is. I personally think they went over
> board with the key verification, but so be it.
>
> Once I have cleaned up my TLS 1.3 prototype, I am happy to take
> a stab at a kernel version.
>
I'm glad to hear that you're planning to add this in kernel space, and I
agree that there won't be a lot of things to do in kernel due to the kernel
crypto APIs. There is also a TLS 1.3 Handshake prototype I worked on and
based on the torvalds/linux kernel code. In case of any duplicate work
when you're doing it, I just share my code here:

  https://github.com/lxin/tls_hs/blob/master/crypto/tls_hs.c

and the TLS_HS APIs docs for QUIC and NFS use are here:

  https://github.com/lxin/tls_hs

Hopefully, it will help.

Besides, There were some security concerns from others for which I didn't
continue:

  https://github.com/lxin/tls_hs#the-security-issues

It will be great if we can have your opinions about it.

Thanks.
