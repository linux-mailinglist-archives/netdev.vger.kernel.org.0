Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2700369794
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbfGOPLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 11:11:48 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42346 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731667AbfGOPLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 11:11:44 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so11855239qkm.9;
        Mon, 15 Jul 2019 08:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=obT241NE0xGOXdIPu6PnSNQNubI9lc5VVpLNN9jbZPs=;
        b=rP4oVEnnurCqv7lMvDdDiqbxUqBGAfXAmVaTDNJW7/ac/tX03HH1xs4Sx8sQnRXKxL
         XbJeGlW0kwt/fF4bXWRwCCEUDo84hxF78ZzK6IJ6MiKpfZoF+Ny6OmcsYMzCe/hFZFmG
         qBNSLiQ2aJ5WEhVH94QLWF8B92cWkcVEDJT9o+xfASLEYGugM3izmazOpfkyyijfefk0
         YArNqJoP/Pn3N1wIXWxm4O9tE32qw94kprulhPYbnYuPe9tVTqgW4z+WuAEbYAdk2dmd
         S3Ov9+B0Qx4k1cwTwMEbhfsJeBeANkNfBqwvqWDt9jM6K366CB9V4VmqnLwl8dezhyfo
         HHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=obT241NE0xGOXdIPu6PnSNQNubI9lc5VVpLNN9jbZPs=;
        b=cRIuY9BT3Mse05KDxmU8rYRD1v27slFsta3RxRBBh2SJeuGKeIrOWXKfkZc4+ZkE2C
         MvlIoNG7ezGdpclhCmXTQWAYcrB6cqV/SYDQbo5C8dxjt0H8JROc9c8G4yIVBUyOHhWl
         4LDwEMXBRlW4jUVKdVOsHgKDEuCHkRXMmSwZpvDeoGc9BDpwrw6w2QF12lm+1jodGzeb
         Pk9qMDsSrSK528V9k34rQPTOHsBRZ6ept0dKDVC7ypNqtm/l6rJ/TaKQnvLx3tmlRe1L
         ETXLGYOPeJE4SVRo2Xc45j/M/2GjhKiScLwlqZbOzXSt5X+Uc8aAbtWCUwXDSyhgBnSI
         iwDg==
X-Gm-Message-State: APjAAAXyPAG0axkrMP4AsP63Ce+mAa52EEiGNZcm9BFvWcwH9pBBk5uI
        aqRA8a9TpZKlM9+M41CmE7ZIEWuXL/wyxFedJeE9abvm
X-Google-Smtp-Source: APXvYqyZL2lm5AIzOLcpNgGzPpUAqU9zlfkN6pc052CC/Akm7TXhtA3X1fRroPCXrTXJNgwRvJfjDdwRAzOoEb3eUbk=
X-Received: by 2002:a37:b646:: with SMTP id g67mr16659507qkf.92.1563203503210;
 Mon, 15 Jul 2019 08:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190715091103.4030-1-iii@linux.ibm.com>
In-Reply-To: <20190715091103.4030-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Jul 2019 08:11:27 -0700
Message-ID: <CAEf4BzY-pcuiwyZ874yWiYFEK0kU6wytXRVNsegTUny5GChxEQ@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: build with -D__TARGET_ARCH_$(SRCARCH)
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 2:11 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> While $ARCH can be relatively flexible (see Makefile and
> tools/scripts/Makefile.arch), $SRCARCH always corresponds to a directory
> name under arch/.
>
> Therefore, build samples with -D__TARGET_ARCH_$(SRCARCH), since that
> matches the expectations of bpf_helpers.h.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  samples/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index f90daadfbc89..1d9be26b4edd 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -284,7 +284,7 @@ $(obj)/%.o: $(src)/%.c
>         $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
>                 -I$(srctree)/tools/testing/selftests/bpf/ \
>                 -D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
> -               -D__TARGET_ARCH_$(ARCH) -Wno-compare-distinct-pointer-types \
> +               -D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
>                 -Wno-gnu-variable-sized-type-not-at-end \
>                 -Wno-address-of-packed-member -Wno-tautological-compare \
>                 -Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
> --
> 2.21.0
>
