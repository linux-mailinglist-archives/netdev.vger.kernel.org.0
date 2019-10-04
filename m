Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DDECC22D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfJDRyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:54:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39278 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfJDRyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 13:54:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so9692306qtb.6;
        Fri, 04 Oct 2019 10:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pn1lEr0tFf8WcG/pP9C0+kwkDcrhVdevTkVqHR5JdFw=;
        b=Ridhwle7HOhw3AuJ6vTKi2/N2ulOhayX6/yfclN0Fvd1/8VlPygBp1PAOFY5ywO/Uv
         fel2OTVetwkfevGKSJ5JZnvbWSXDHCRYMy+YGcfBP/z9U9S16DacEcbWN2jBApXIiiuo
         y8ngh+rAkY8cTwdV2VDjNft/HKPOZr4GQwlKDjgQ8Vj+wvXK/Z1X9zm05Y25yzf2f1fU
         cDeOxdupWgSjOjOh1qOZ/0MHi0/2f3bc22Odv38kpyz7C1cLnGyqVEoFTl3mY9NzYj9+
         cUPIfMM2nTJji2VD7jLbEO3yObA3dGW1em2j+uT1N+1ENA6Cn2lVPg5xwPvZQT1sQc+q
         z42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pn1lEr0tFf8WcG/pP9C0+kwkDcrhVdevTkVqHR5JdFw=;
        b=OqlSKzmooF+Un3lUOAA8Iy7QY7Y4i5A7vq2vYCXGfbmpB0s1BacBhUrran4dq6FCUu
         JYYdqUEiYla7Bs2pSpGrEFdEiuyih+Y7KJl4FxZDp4jpZIvuMYsoYNyGPyu2fWPha1uk
         ODlFOu7fSV+mI50soz58gPItwX2PyF4Z+yXRNxvBoZTI5IKWRYdzf/VNZBr6nJ3qJfNc
         ubnBPVKngTuENpdBOzeHJbbpwhNj2Pude8BOa7l/B2dT3d1Gf5Ssyy/MAEmoyekBQy/Q
         SMpvNbxpAl5+X4+2jx41cuBTJIgOdO78ak/ngsGKwjRnICvjZry2feWsFpg/fl8gt5Cl
         e6fg==
X-Gm-Message-State: APjAAAXXi43dvXbN1geCVTZ7YTdr4LQu6zTl4ZmPBPv+WsbckuqnsTMT
        S7YaxnGk5C7scW8xxiygODurrDEZyXzvtAC+44o=
X-Google-Smtp-Source: APXvYqwAWbwK7yQBJt5yyi/sKiflrZ5VBB0HCxfxOrXOMdbyX7VP/sLqtE6r1lLuOGPvUDQPpEA/itE6KBIV6DePhoI=
X-Received: by 2002:ac8:4704:: with SMTP id f4mr17024775qtp.183.1570211677076;
 Fri, 04 Oct 2019 10:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191004155615.95469-1-sdf@google.com> <20191004155615.95469-3-sdf@google.com>
In-Reply-To: <20191004155615.95469-3-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 4 Oct 2019 10:54:25 -0700
Message-ID: <CAPhsuW4PC4Oo7fRL60EkiMvyY9pohKYznBhAe=HndKqX6PxqSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: add test for BPF flow
 dissector in the root namespace
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 8:58 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Make sure non-root namespaces get an error if root flow dissector is
> attached.
>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>
