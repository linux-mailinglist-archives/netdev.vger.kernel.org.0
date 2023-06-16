Return-Path: <netdev+bounces-11584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8879C733A69
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4203F280A62
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CD6D1F190;
	Fri, 16 Jun 2023 20:05:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A1F1ACDB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:05:21 +0000 (UTC)
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9DA35A3;
	Fri, 16 Jun 2023 13:05:18 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-bad0c4f6f50so1846351276.1;
        Fri, 16 Jun 2023 13:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686945918; x=1689537918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hganKCZoZrwfRfCw52dCzqGAY7Ust8nvA0jKBdgWxU=;
        b=MyqY0ARx8Krf4EndKExz1PEsdoT01Sb9tUhBOE0+xhWJxSU2ApLkBfM6Tr8+Z3LheG
         Tfk/ImQFzoAr+8QOCISkpenjX8yV+UBDFzG5Ewc9WpzXck+mKFdQuyjV7BIg3hI2iIsz
         UEfhZ4vYbNR/3E4dY64yNw7fZ9v1EIK+zB7kmKm0/mR3jCSbTMLqXMZyn/CC4lMuvVaM
         dpjlBSVyixJzOG05gkWrMEE2bSL9mp/tmZdIKca8yT3b2aHxWBy3Aqbv7cEGTxwbzALD
         LH5Vd9q2PHXsE7388/25HsGUXbNE6+dW/SgRkdU1bH8mbeLQkhbO1aKBTr2QpF/2IPYU
         movw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686945918; x=1689537918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hganKCZoZrwfRfCw52dCzqGAY7Ust8nvA0jKBdgWxU=;
        b=W5cBSCsZr01D1YeFmWiMcdQU9tqxGjPIvn54Cut+QlTo0oCM9nDbOX4GOFwrxv4mB+
         vSUHexSuL40KQ0dio3P/++bR7RiwX28rQnjDiHqHC/UDn8j36pqgVkr7lUnb2WpBDuEq
         re8tAYaH6DMcIC4XMjNA0JvTMoU9YHMse54nfUncmV5OqesW7Dih47xWNmjbfNkVOL8H
         YIb0B5RB/U8ZBRaLCHrlLh1wDqNPuQZLQUMtXJwvLvM2tVsyqsjQS5+eV9IvehzM5Xic
         OiKEFq/maAsnhxXZv11UidzCq8PDOODrcrTfQq9u6THwHUhrgGPhyG5zeK7d9L1acsNy
         FbYQ==
X-Gm-Message-State: AC+VfDy/QAnqybQwYkwloOaXCASzwjMiRShI0+brWRWcqsouK9aNjrF7
	UN6gvx8se4+J61l5JHsOlyMYcLb3XGefr5KeWFY=
X-Google-Smtp-Source: ACHHUZ7LWyzqz+SNs9JXo0WmSwAW7npDcXANJCLpOLIcJ7DMOHGvrGhGsQp/M7eKycSCDiCPzeta6ypqibe/SkfTFaY=
X-Received: by 2002:a05:6902:92:b0:ba7:a55f:9091 with SMTP id
 h18-20020a056902009200b00ba7a55f9091mr165618ybs.6.1686945917818; Fri, 16 Jun
 2023 13:05:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614230128.199724bd@kernel.org> <CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
 <20230615191931.4e4751ac@kernel.org> <20230616.211821.1815408081024606989.ubuntu@gmail.com>
 <CANiq72mAHv8ozBsZ9-ax9kY8OfESFAc462CxrKNv0gC3r0=Xmg@mail.gmail.com> <20230616112636.5b216a78@kernel.org>
In-Reply-To: <20230616112636.5b216a78@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Jun 2023 22:05:06 +0200
Message-ID: <CANiq72n4sr7wYoiB8rv9CLpjkQ=DqWj+WqfHN0QkkLzXeWEJQw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: Jakub Kicinski <kuba@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 8:26=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Duplicated driver in a new language means nobody has a real incentive
> to use it in production. That really mutes the signal we get out of the
> experiment.

What I was trying to say is that there may be other incentives for
using the new one, like the ones I gave in the list.

Even if there is no incentive for using it right now, one may still
want to build/design it in order to evaluate Rust and/or prepare
abstractions for future drivers. This was the reason for the NVMe
driver request we got back then, for instance.

> At the same time IIUC building the Rust code is not trivial,
> so IDK if we're ready to force people to use it. Ugh.

I am not sure what you mean -- building works the same way as you have
done now, i.e. your usual build commands with `make`.

If you mean installing the toolchain, then we have a Quick Start guide
[1], and a script that checks for the requirements.

[1] https://docs.kernel.org/rust/quick-start.html

> Do you have any idea how long it will take until one can
>  dnf install $rust
> and have that be enough to be build a kernel (for the two major arches)?

You may do it today if the version matches, which for Fedora it should
e.g. next week or so when we merge the upgrade to 1.70, since Fedora
has now 1.70 [2].

But since they may not always align, I would recommend using `rustup`
(or the standalone installers) until we can establish a minimum
version. Please see the Quick Start guide for details [1].

Other distributions may provide a custom package with the required
dependencies for building Rust kernel code, like Ubuntu does.

[2] https://packages.fedoraproject.org/pkgs/rust/rust/

Cheers,
Miguel

