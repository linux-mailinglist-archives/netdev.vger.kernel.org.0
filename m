Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBE223C57F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHEGAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgHEGAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:00:41 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D7AC06174A;
        Tue,  4 Aug 2020 23:00:38 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id v89so8977370ybi.8;
        Tue, 04 Aug 2020 23:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34rG3P89K5RP1igZXxDZgcgRcAMA4C4KLciz5cdfcbs=;
        b=rFrqkPG7WmJt3NpmD1R37HZo2/SXf4eUUUiB7ZTdoBWqwboX/oI7A8mzQR/YWKaGTD
         9GT4vsZZdjeyWaH2FKXIMboHds9CEGlqcFITno4yWZ1w5VDV2Q5+fPLQSRrjoDpS3r3t
         T7yd1I5UJoJOtDg++gIMn1CtYLkNdqL1KoIQ+WlMWaAogp8lbrXL08RRi41h8wYYhBqq
         kdwYn+/EankEoFqyt+673O3QcqKkOnU3yQC5qjrCBD+EgYvxur/nSlsw8Bh4kCecYhCm
         I0QgU7yif1M9LRgCwjAsb28oFkPEsytvkn9hlm0ntUbk+KYBhac9Fk1FzSdMWoRhTqIR
         Oe0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34rG3P89K5RP1igZXxDZgcgRcAMA4C4KLciz5cdfcbs=;
        b=YpaB8oDKjOynj9QooX8WjKLW8bgeindPChnMTiMcPbul6wf7BEu6cKVbULWY8TyKxH
         Eyqu+o86UZBxJL6XU7Oml/cazuqwP9JYT6AoFKTwJasujt5H5pbTCc24ig15vWzQh1YN
         SOQOl7hM/R+ceUG+hf7//ta/j4wVVFJu80090C4hgmToCkOK+HXZ6iVzq139c7oQttcK
         RFvn2ezcHjsFZUU/rNV5nHjl79sW8iiBQzRhCAWVUAMCtRBa5xvISOJ3a6VurswU40vS
         PzT/430WoCQ4lkkBtMnBGypisH0urImgcJDxUXI5b1EHfOjpGITRUdSwWGZil3PkORFt
         mROg==
X-Gm-Message-State: AOAM532GW2mD5fFPIjAu3Wp5psdhjIHYCvuGT8RCDf/2boya27BWYcYa
        FURHkPJsJ3msO2y/76uWFN9qQ04mW12X3DNelVE=
X-Google-Smtp-Source: ABdhPJz8jSx8oSFOf33/VYfO2X1UHTq0Xx+bGON06Tn5m03W50bZv5LHnlGNnCE5R2iYLlPrZEVY+UFzC0OcG1jrtME=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr2384215ybm.425.1596607237829;
 Tue, 04 Aug 2020 23:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-2-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:00:26 -0700
Message-ID: <CAEf4BzZ82T2+PumS2Zv5zr72SrDbfG=L-ccMXmCXCq2wGSk1cg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 01/14] tools resolve_btfids: Add size check to
 get_id function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> To make sure we don't crash on malformed symbols.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/resolve_btfids/main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>

[...]
