Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD721B9169
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgDZQDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgDZQDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:03:03 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292BEC061A0F;
        Sun, 26 Apr 2020 09:03:03 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a21so12061198ljj.11;
        Sun, 26 Apr 2020 09:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uVMo5mYKGraHPBeJ1pf1ZYyBBNC6aAFTC/tR7qWS7Jc=;
        b=j4U0ucFXvk/rIPae5mhG0g4nvKOC37AhBVhSYPYBT0jYzuso0nDSY9rH8P1MOghtA1
         UiAsnJwNHiVUdGCvdkvXH2jsJCGbA2ZWMrCZU2TTHgh2dHnQVIEZxxT/RoZ/IaoRZXmf
         4keYyIEQ7DdBk3JXU1UNLc3fcsEjNZ4VgAWAVt4xfo96VNGmPodRNy0GlnZJwPz4T9P9
         b6dm3Ukz+odrqdEWd0v6jCrH9tjr8hTP1vGZ0iAjRk9NME39pk/cy1BZzqeD/XYCl2BY
         qVBMNMYt8PTfYr8Euwn7lOFVqFTVaQ/xTiumi3Jn51zuRfnw9VHrs2ug6H0W2ewIlTxV
         KKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uVMo5mYKGraHPBeJ1pf1ZYyBBNC6aAFTC/tR7qWS7Jc=;
        b=YuTXYtxzDGviDQcAOP4M/VBXbbRuJtBz11Ca0pgYn/laAeOpPUsxOCL1UVmBZ1zkjN
         CWmfhJdGIq3fw1YKZ+GRj9vrmPHukE54I3itVMN8ODLIP6FVohCg/C9XqakMJ1jLk5R0
         /VD55axfyuZXd0L5a28PXSGPCHnVvPBntiFKOlYZKJUsCfd3vpz58RBaG0CT8tt95d5F
         FVjkkznYbgs1gRk/ge6vKRiCxg6Uag7ta5+gq51M56pB1vMG8Pt4leig8SziLsJz6NG4
         YuQ1C1G1WGonaVd43NkUYiSrdwG6BHwmendK3bL4WpWsjN9dKXK6HubxvWnfGt/9jg/t
         ERHA==
X-Gm-Message-State: AGi0PuY2QfQPJT3NDwtooZ4dDgwRWUM7xzomYI0Eywt7shRlo4ZLLGjr
        7/sikeDVtf+LBoT7RRqaXo/xIs+qNTQiFyUhhbg=
X-Google-Smtp-Source: APiQypIX4ngSLuedu5ijVFWv81JZvAx6/42/MQBxEq1evI40OvHuAUJ2gxB0uq/A/gDtxjVQmcEqO9TJGhOrcpMzjgI=
X-Received: by 2002:a2e:990f:: with SMTP id v15mr10954772lji.7.1587916981488;
 Sun, 26 Apr 2020 09:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200420183409.210660-1-zenczykowski@gmail.com>
In-Reply-To: <20200420183409.210660-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 26 Apr 2020 09:02:49 -0700
Message-ID: <CAADnVQK8mhrxhQJPyBAhFU9mOCZYuoHot5LQFQMuENYzTtHu-g@mail.gmail.com>
Subject: Re: [PATCH] net: bpf: Allow TC programs to call BPF_FUNC_skb_change_head
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:34 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Lorenzo Colitti <lorenzo@google.com>
>
> This allows TC eBPF programs to modify and forward (redirect) packets
> from interfaces without ethernet headers (for example cellular)
> to interfaces with (for example ethernet/wifi).
>
> The lack of this appears to simply be an oversight.
>
> Tested:
>   in active use in Android R on 4.14+ devices for ipv6
>   cellular to wifi tethering offload.
>
> Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Applied. Thanks
