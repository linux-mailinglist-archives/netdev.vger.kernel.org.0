Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D55C179972
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgCDUCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:02:45 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39875 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbgCDUCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:02:45 -0500
Received: by mail-lf1-f66.google.com with SMTP id n30so2556623lfh.6;
        Wed, 04 Mar 2020 12:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0++ND2QOO8ryntJ6kV2i7bFQ/MLLMaAr8V/FDQd9ZNE=;
        b=Q0JkuMyvk2i2EJtm9+V9H3KSA2tIRKa6MsHiEozbQU9VIduA/JbfIA89U/zvuTPxRU
         f1y3NqIrV3Xsfd+WJzzzJ8Sl856hJtljrc7aLYre7D8yF7056Iun3qnL17o4Kd19aQjZ
         8MEJ+GVB/GuiJ0c8C/1gA5QwBYwhws4S4eIkBFILrw1Ma2m3B4oqNbGLVkxhG7Fb4iMx
         Unqq1KRXEHBR+Xh7nqB3PnfmTfmOHVVGaRp2a8T6dv6IJzKc5xsiEq36pWYZrYZ0ZNmI
         GdEx783ltWAGPdpCw4vi1EvS97YTiyEfR4ytiF6BuVX6YAOlQhDdX1z03z8FIbaeGNVt
         8vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0++ND2QOO8ryntJ6kV2i7bFQ/MLLMaAr8V/FDQd9ZNE=;
        b=Plz7GlWcwxOzT6jKfVXQhEYye1xkC0QUdqLOpwebzckU2DzsEVNjeRIJORMNCOfU3y
         R/bSbTVDtffPWxRZvxjcj8wv80XIPqQnB7UzUldPOhV2fZDHKq5Y1fVKMvjI3qjaB+r1
         088lm6GQa3zNlw8foUsdj2Joiigm7+QuB5atyAtm9q5JLvsEBAsCWa5MsTtatIm8YdmG
         ydhMnJ4CuT2e5CKYKjeAxTnM9D2rm976B9+dL5qbHimuilKhgtYpsCbbZ33hq7lwirxp
         mBJeUQqNfoAkdXK9GKdnPqi8272oXC/EIONU61gt2EtWupDncX+f24C7fEzNeTyNRa6h
         0riw==
X-Gm-Message-State: ANhLgQ1Yo9RbQg9AZzxntOAgQjssfoOH5bxe+9L4IawIuuuQgU8hA45p
        aKt8eBsp8X3E2NHMeQ1iYF/N9YtUnVhG0oBhYttvkw==
X-Google-Smtp-Source: ADFU+vs50JL8TetTjaRbrMZJRNANdv0Eo+Zw0Sh+1rgX2MPVqtlMoPd7rpfNwy+CMLqGADpMgGIGmpsb9n7WiN8uEvg=
X-Received: by 2002:ac2:442e:: with SMTP id w14mr2848835lfl.119.1583352162786;
 Wed, 04 Mar 2020 12:02:42 -0800 (PST)
MIME-Version: 1.0
References: <20200304184336.165766-1-andriin@fb.com>
In-Reply-To: <20200304184336.165766-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Mar 2020 12:02:30 -0800
Message-ID: <CAADnVQJucGSPyJJmH2wJ_B96cWHVmRqkXK0vRwqhkpNz2NTY7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: support out-of-tree vmlinux
 builds for VMLINUX_BTF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 10:43 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add detection of out-of-tree built vmlinux image for the purpose of
> VMLINUX_BTF detection. According to Documentation/kbuild/kbuild.rst, O takes
> precedence over KBUILD_OUTPUT.
>
> Also ensure ~/path/to/build/dir also works by relying on wildcard's resolution
> first, but then applying $(abspath) at the end to also handle
> O=../../whatever cases.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks for fixing a build.
