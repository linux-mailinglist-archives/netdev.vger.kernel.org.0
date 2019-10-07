Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16717CDB78
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 07:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfJGFfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 01:35:31 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42666 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfJGFfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 01:35:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id c195so8291976lfg.9;
        Sun, 06 Oct 2019 22:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxN3nY390QDD4avFKTUgHHcPrTARM4ErRwch6jaSXLk=;
        b=dFsWTvq4KvrTmnT03gqCtoGI2k+2kVVJ6gWBlsFAReNUaHZw9I/BR7BltRlNrZVwlr
         aX9IUF0QNyeaULrDllGLN3z15TjIt4/AcSjnTiGvWUqKty7LOAIbsEA+TVGIH3Px0mLB
         Vbn8oolhpNcfR/W8R4j1BVnJR8pjVFSLOvpHi1TtRsxZT5PTjeqixuGJjHWf1wwnPa09
         MGEvs198beGV947XQasUrR0Ie7gX9c85btH+nbVwR35CgdVNu7pdtNZ8GLmk1f14lzUJ
         pbsQSu7X6N91PdKY2ZfNqu/Q5YodTCPJy71fYgu/4ULZadu6zLFU4FxxMLwbAtsQx7VO
         iSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxN3nY390QDD4avFKTUgHHcPrTARM4ErRwch6jaSXLk=;
        b=ViRGM9DoQYynW56YNg72210zithjXsgvY1fIG8qB03RK7eKD0yYyzs8WA47KfyjQbb
         Z4fqJpHbVSTIk+dkFL/CfMLbWRXUyoKehonQsV16kO0HSyR/rcjlkK3uV8CnJj7ZIVJ6
         FxT0hBTS/7d1tbBDEDv7sG/S2QTDagIWENg32/K9MaF1ezcHh1G7zrIy0aeo5HQkupih
         Yp1MmG/MFA1qiA1CmC+OREiP4mruRtrjc7OdfUiNNlGWtTQMvXuoQNsZO2az0eObrE/R
         JY12ydzJn6NhVmXdbfT6cvxAyYY5kFxh01Sb2iC2NmzXGM8x1TXuqHWg44S3bS4wL+Um
         iNHg==
X-Gm-Message-State: APjAAAUFY+uNvpX71JlF9tMnf+HDy89m81CSO+h/n4p8fDHYRgAC3fRJ
        aT325LoniMUJXHR8bRl8XalXNb6aFb6tC4XR6jI=
X-Google-Smtp-Source: APXvYqzBuM4f/vcsa70Ied4nXsj0WyqqPlOO25t0tgSB5/Chur75k+r8MBrH3Zn+jp9MfCX6qWt2rokwg0GycN6Or/s=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr16233171lfp.15.1570426529409;
 Sun, 06 Oct 2019 22:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191007030738.2627420-1-andriin@fb.com>
In-Reply-To: <20191007030738.2627420-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 6 Oct 2019 22:35:17 -0700
Message-ID: <CAADnVQK=Pc6Z5q7=oF1xdxq3ThX-Ox5mjmVk3DkwqUrXRHZ1Xg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/3] Auto-generate list of BPF helpers
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 8:08 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set adds ability to auto-generate list of BPF helper definitions.
> It relies on existing scripts/bpf_helpers_doc.py and include/uapi/linux/bpf.h
> having a well-defined set of comments. bpf_helper_defs.h contains all BPF
> helper signatures which stay in sync with latest bpf.h UAPI. This
> auto-generated header is included from bpf_helpers.h, while all previously
> hand-written BPF helper definitions are simultaneously removed in patch #3.
> The end result is less manually maintained and redundant boilerplate code,
> while also more consistent and well-documented set of BPF helpers. Generated
> helper definitions are completely independent from a specific bpf.h on
> a target system, because it doesn't use BPF_FUNC_xxx enums.

Applied. Thanks
