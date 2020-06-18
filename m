Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8131FFD6F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbgFRVdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731180AbgFRVdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:33:22 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B76C06174E;
        Thu, 18 Jun 2020 14:33:20 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c11so4344565lfh.8;
        Thu, 18 Jun 2020 14:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+JqzHuZcJ3DEX++xBQSODpTEudGzjBjE5lxaLfjVrIU=;
        b=eN/pRpjkN5m8vnZiWZJpgp8Z0Vo29WA/TDODYi4H1QYFpxoZjW7T2fVw3u5cnFkk0k
         CQTVHOYt5/1UMTRpYJtz/P/lSn2w5lq8r79rbizP8rp359oEx+6KY2qNpKZMSHGWJnta
         f1m7De7wFnqzwccvqgfqVSSR5jv7dAvRz+mH4RG7CNv1dQyJWwC6xdi+mvYmwo6Qqzr7
         zg+v+eqczh25Boype41vcwJSuHXldHm6SHE2npWKHwk7zIEnopMIAFziSQ2RH2nxi3Z7
         9Tsdaqsxl8lnTnLW3Sbie83ZVPwO5DCjWjdwwAK26Airbhsp1dO4rhKEJZ29BkLbzmPv
         T96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+JqzHuZcJ3DEX++xBQSODpTEudGzjBjE5lxaLfjVrIU=;
        b=ow6d2nxq3jAgjku1TTep3Verwg8oeBALCRqOle/igEtkdvr/ogD+Im/6RayIQRqWtt
         vGmt/WytKXPA+3uTxKnfx2YEISoG61fyb8uOqDpvu2peMsv8EOHOe1itIDtsXBA/9cOB
         kNn5FBE4bPZvLDdyLhqDLAzYMgI0i73/1TZooOSseWNV+aWxGnK4lrOyois2rHIT+T20
         eFmO3ZGBA3jmRm6mZfEzZ9eKpqhwbI+8wRfmdmbKN7+BfpVBccJL+rxHwzMm9MdHELP+
         iI9x6JaKK+eviqlAxQHa7ZCz4irqf2qHvDpEBSqEAmH2n4NhBL5eldo7KEeynrI3Ms/V
         VPjg==
X-Gm-Message-State: AOAM533iJxBDVCL1mqp8uqb4tjgu5SuF2PF/WxloGdv1aXTQ1z60GUve
        7PfDAeUtUS/nt7gQpvn3v2dTOBCCtPO2H0FWr/Y7r7zJ
X-Google-Smtp-Source: ABdhPJx1B/dvucQv79czCRkw/xzQUP8ehSFW+QDfkeqEdxbmH2pGl3TL3A4XVAcC+4Zv2VLlJa0JyhDD2jD195i8WQk=
X-Received: by 2002:ac2:5e29:: with SMTP id o9mr142348lfg.196.1592515999225;
 Thu, 18 Jun 2020 14:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200617110217.35669-1-zeil@yandex-team.ru> <20200617110217.35669-3-zeil@yandex-team.ru>
In-Reply-To: <20200617110217.35669-3-zeil@yandex-team.ru>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jun 2020 14:33:07 -0700
Message-ID: <CAADnVQJVJ3CtMVh_20MXeQUF2g1WJJuHShuJqHhA44qKXTJcEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] bpf: add SO_KEEPALIVE and related options
 to bpf_setsockopt
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 4:02 AM Dmitry Yakunin <zeil@yandex-team.ru> wrote:
>
> This patch adds support of SO_KEEPALIVE flag and TCP related options
> to bpf_setsockopt() routine. This is helpful if we want to enable or tune
> TCP keepalive for applications which don't do it in the userspace code.
>
> v2:
>   - update kernel-doc (Nikita Vetoshkin <nekto0n@yandex-team.ru>)
>
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/uapi/linux/bpf.h |  7 +++++--
>  net/core/filter.c        | 36 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 3 deletions(-)

Please update tools/include/uapi/linux/bpf.h as well.

Also please add a selftest for at least some new opts.
