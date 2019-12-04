Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58281128C9
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 11:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfLDKDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 05:03:48 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:38595 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfLDKDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 05:03:47 -0500
Received: by mail-wm1-f51.google.com with SMTP id p17so7129117wmi.3
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 02:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R9RIq0TKmxaGeXsj1wrmN8idpfaTrDVkEEsy2aMnbAc=;
        b=bIcjJPaN5dHHUWBCCQ8F12sLNZF5S5Ys3++N9E1pZ46LLf2XMmEOcqZbimOfgRG+KR
         9938FfKMS4lJYJN4eyypuPm300jP5tG9+wX2kEb/Tp1FtH40SRPCPGjaHtQNkvf3wqFn
         LODffKQAgXnLHWVPqxO+JPRNd7gUtQkhW6EXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R9RIq0TKmxaGeXsj1wrmN8idpfaTrDVkEEsy2aMnbAc=;
        b=IIbroggEZeNsdHQ0ixzfIuQSxyLb5txQHED+i/d40e9+03sqfhdWwvGju0HDJBDpY2
         IpVvw9p3c9c5hUFmmk8akblZJxPl/dHsKf6FeV/yI+R2jIVXGceNULamQuupkntVI7Cb
         7zFuAL2vEXuQByoyhD6QtIDr0phMq4dpfAGJW7SKf89aox5rxKw7KKu6fWpBgnzYEbup
         Gql7mcDXZOox2HVgOAoXPOIrjlI/3ojd15E0OiSPKeCiXVzUKdT5WkqrBToCGtYXBjs/
         +zFN60gQziKNvaPOs2hM2f7kSpzYY5rkxYTqDVrnTpkHxyUJ5RHl9b/l1AH2WvixHwrj
         yYQg==
X-Gm-Message-State: APjAAAURca2WWxumnIEvi/QkuIJQMylGqO671RqgXzXT8MX5/rxNX8p8
        GG7XO+jO3trKx3xUaeWF/kk/RU1L+UMtXtmGlwGf4A==
X-Google-Smtp-Source: APXvYqxRXZkQy1he8Ga6BNpalK8SjbfFpkKAYfm+6Y+LG4HnKLxaOYUI3yuzkmJXfiZuk/XQvz4nDtXRHmjmOPFcgHg=
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr15375113wmc.158.1575453825720;
 Wed, 04 Dec 2019 02:03:45 -0800 (PST)
MIME-Version: 1.0
References: <1923F6C8-A3CC-4904-B2E7-176BDB52AF1B@gmail.com>
 <CACKFLikbp+sTxFBNEnUYFK2oAqeYm58uULE=AXfCp2Afg3x4ew@mail.gmail.com>
 <A1527477-EC6E-4B64-880F-B014E8CFCB9D@gmail.com> <CAMet4B7vi6yYu2HZd1Pj7rhtxme8FmT4wbXTjQOnQEqJp0Z_3w@mail.gmail.com>
 <5AC684B1-79CA-41EB-9553-FFBFD7284085@gmail.com> <CACE64B8-91DE-4F25-B2F7-2C86526986FD@gmail.com>
 <CAMet4B7npXtDd4U7HOKFN74hwpcAYmyq_LH3N_jtcyxtm43JNg@mail.gmail.com>
 <CAMet4B6csj+6umj+h7mdPfz+rnLrOFYe6RBhVb+-ykiAwjxJUg@mail.gmail.com>
 <7C0AE73E-DB62-45D1-B358-3CC47D0EB6B0@gmail.com> <3FA0ADFD-6F62-43E4-9119-64F7AC1BCD27@gmail.com>
 <E3ACAA7C-97EF-4EC0-B306-72AE3AAF18C5@gmail.com> <7F804C96-2567-4D97-87CB-D86A2E630126@gmail.com>
 <7C626C22-0289-4D99-B68E-66DFEF792E95@gmail.com>
In-Reply-To: <7C626C22-0289-4D99-B68E-66DFEF792E95@gmail.com>
From:   Siva Reddy Kallam <siva.kallam@broadcom.com>
Date:   Wed, 4 Dec 2019 15:33:34 +0530
Message-ID: <CAMet4B6gjM2BHO346WJ6Y-brd3S9CGKtzbYpSpmB5EPrrtTk6A@mail.gmail.com>
Subject: Re: Gentoo Linux 5.x - Tigon3
To:     Rudolf Spring <rudolf.spring@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 7:28 PM Rudolf Spring <rudolf.spring@gmail.com> wro=
te:
>
> You should be able to reproduce it with the following conditions. Build a=
 bridge interface and add only the tg3. Bridge config like this:
>
> config_eth0=3D=E2=80=9Cnull"
> config_br0=3D"192.168.1.1 netmask 255.255.255.0 brd 192.168.1.255"
> bridge_br0=3D=E2=80=9Ceth0=E2=80=9D
>
> The computer should be configured as router and have a 2nd interface conn=
ected to the internet.
> net.ipv4.ip_forward =3D 1
>
> Access this Router from another computer and start downloading a large fi=
le and simultaneously browse the internet. Tg3 crashes instantly and repeat=
edly.
>
Let me try this way and provide you an update on this. Thanks
