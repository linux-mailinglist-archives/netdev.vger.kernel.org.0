Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15FF43E279
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhJ1Nr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:47:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhJ1Nr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635428731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f4RVU0fCj6WA9PThqjBMiACWmhqkx1yRyCGqh2MBFEY=;
        b=NQLzxgpbZYz8T9AtxshwO1ePrO1/HuXzYPJPHpSD+kbY291Nre23JwKa0e6k3y7OVl5Hi/
        hzCNF8iO0Mmoqrkc+3wuaV15fMzKbqdTiTf6TfkSKYoX+HBqcNCilCvZbZQ4CDHlRu+W58
        2yxItp13jXoTDstcEn8AMgR0RVKklt8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-4tnmACquP0mkt4xE6R9skQ-1; Thu, 28 Oct 2021 09:45:29 -0400
X-MC-Unique: 4tnmACquP0mkt4xE6R9skQ-1
Received: by mail-ed1-f72.google.com with SMTP id c25-20020a056402143900b003dc19782ea8so5707806edx.3
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=f4RVU0fCj6WA9PThqjBMiACWmhqkx1yRyCGqh2MBFEY=;
        b=sL9x/8QiKRa2hrHg+h77vxGBWlSlFf+WsuqvthP8UcUb3Jio5/UTFkO/Tlgnkf2u00
         tcbqnDpmCENqruiSArHn4oiGiq95e0wC0cFPvgQg+X9vOn8G9cH094JKhcPwy5WdwxGE
         9y7CJ2BaUy7ebqueU1paUxJ/9Pgle/cb17kt2ZV9MBKfeWLL2wRl3Mu90R+u9bN3yVTy
         OhZrQLGVsddpFYRjRB1ETUfGkSiM+pSBF4/6ReOKSq4I+XHgkDM5FA7E7pkpmtOhlgaK
         4Ropow3Q6enc83xycux0J0XAxnmnggKE4pT4cCT+PfHtS/vHzL7JXfVZPmFc7G+jCpxI
         U9DA==
X-Gm-Message-State: AOAM530Q8rTKnL2rzXXyeBhtAM085sZE72yBbeaCHx8JM2QNUIz8/Db6
        ahivZBlb0SgiLQDw4xIRk/mM8tRsFxwdFjC0tayD9b/bjNLSdseTA1fjWbWDCuWfVyH8/Rlh9VL
        ni6ZTHS5VrrOU7dgv
X-Received: by 2002:a17:906:c248:: with SMTP id bl8mr5457417ejb.360.1635428725658;
        Thu, 28 Oct 2021 06:45:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcDI0nkrtjKeJZUtJYosbKl2scjVFZLNXlJd0FYdMFaHC8SXLtHYGFSpOcdLpttH8EW8QTRg==
X-Received: by 2002:a17:906:c248:: with SMTP id bl8mr5457296ejb.360.1635428724766;
        Thu, 28 Oct 2021 06:45:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x15sm1695156edr.55.2021.10.28.06.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:45:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9D564180262; Thu, 28 Oct 2021 15:45:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: deprecate AF_XDP support
In-Reply-To: <20211028134003.27160-1-magnus.karlsson@gmail.com>
References: <20211028134003.27160-1-magnus.karlsson@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 28 Oct 2021 15:45:23 +0200
Message-ID: <87tuh18dqk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Deprecate AF_XDP support in libbpf ([0]). This has been moved to
> libxdp as it is a better fit for that library. The AF_XDP support only
> uses the public libbpf functions and can therefore just use libbpf as
> a library from libxdp. The libxdp APIs are exactly the same so it
> should just be linking with libxdp instead of libbpf for the AF_XDP
> functionality. If not, please submit a bug report. Linking with both
> libraries is supported but make sure you link in the correct order so
> that the new functions in libxdp are used instead of the deprecated
> ones in libbpf.
>
> Libxdp can be found at https://github.com/xdp-project/xdp-tools.
>
> [0] https://github.com/libbpf/libbpf/issues/270
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Seems you typoed 'libxdp' as 'libdxp' in the deprecation messages :)

Other than that, though:
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

