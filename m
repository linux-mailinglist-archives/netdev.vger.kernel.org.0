Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BF7207B7B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405969AbgFXS0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404995AbgFXS0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:26:13 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4807CC061573;
        Wed, 24 Jun 2020 11:26:13 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id x18so3684328lji.1;
        Wed, 24 Jun 2020 11:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idAtOp9fWCJgFeJGNzuhbj33T8Adl8XrGT3VmzCp3bk=;
        b=reH6YmLWcmvImMNdyMoceJVPv11juxJCCms8kM3/+TwH9p5Faby5iTTQZqAE8uiN2Q
         5uXZUESCyOBiW9OZVv075cZGIO3qMvFXUXGnHJZt7db62fd1LpQJiEoNvvnJfJrnt/S6
         FhbRE4Hr/V/BqNJXPsuBFlmNexYTfgjpVDQ9qPcm5McHVB/FGjC9SokiucPfxeVGSBXp
         7l2Z6fnqt9+Z/4VI/peTQD4vOUcjXKanznWpyv2Ur0MOZvwoofPwpbdm5rqF+56l1dNe
         mLSIYhzDR/6gtQtHK+tXdHR+4WJ3LY2hC/KF6Rh4KacqKe9OBxCdzBW1lOSH47vFMndY
         xghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idAtOp9fWCJgFeJGNzuhbj33T8Adl8XrGT3VmzCp3bk=;
        b=rjEBqE829G2kIEgDTqY7tHMnsl1Kz4xG0nBKuz1VxuhS9ghSEk+hgsxZXFDx2gIPJv
         MesuxQgwlcjtGs6UCPsr8VUltBlF/hsLlSJoG6BcjVr8Q2CQtclaHVAHl51MDxvpu2W6
         Y/Hs5DJlapG5R9dkJIf1AqDRu8f2jhxPrfEBNrW/+beqIzra7oCO6N656P/QH7PJIC+d
         EbC8JmvnFa0OPOKIbUAJNIAZ1hnda9GxRQ7hMleUPfzwO41bBP1JcgPG1RNFQmRVpsiM
         +yYemBcppmdqe7/6TBmSryruxJVg1i92/ukX0l1L3X3Zj/oxVSPHXuPELaLKHJ32Im0c
         9pZQ==
X-Gm-Message-State: AOAM531YmSeTeLVC943/K6uTkVqsnOfcYz5S7rQWGQQWrEt8zR/ddSUD
        a6sVVQtdHGij2Pc0bRiB2MwpQw0G5rnbVmCljnMJ6g==
X-Google-Smtp-Source: ABdhPJw7eX3TAfjZ7+RbGtG1YvH4dNDp44NUMxYXnGps6SD9mcDNUa4FY337gHgl95gSc12eGm/DPEpIUXi61IfFoSc=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr14978125ljg.450.1593023171719;
 Wed, 24 Jun 2020 11:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200620153052.9439-1-zeil@yandex-team.ru> <20200620153052.9439-3-zeil@yandex-team.ru>
In-Reply-To: <20200620153052.9439-3-zeil@yandex-team.ru>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Jun 2020 11:26:00 -0700
Message-ID: <CAADnVQJ96t=ALtXSRPG4JncxctVVRjBnhvdCH6q2ju4hVOzjFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/3] bpf: add SO_KEEPALIVE and related options
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

On Sat, Jun 20, 2020 at 8:31 AM Dmitry Yakunin <zeil@yandex-team.ru> wrote:
>
> This patch adds support of SO_KEEPALIVE flag and TCP related options
> to bpf_setsockopt() routine. This is helpful if we want to enable or tune
> TCP keepalive for applications which don't do it in the userspace code.
>
> v3:
>   - update kernel-doc in uapi (Nikita Vetoshkin <nekto0n@yandex-team.ru>)
>
> v4:
>   - update kernel-doc in tools too (Alexei Starovoitov)
>   - add test to selftests (Alexei Starovoitov)
>
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
