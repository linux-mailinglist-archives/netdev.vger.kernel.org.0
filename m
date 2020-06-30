Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9001620FC66
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgF3TCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgF3TCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:02:53 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800D7C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:02:53 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r12so11523699ilh.4
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XspkxVwnCCMzj9hgy6TK9qT2xMitwCQCc7943oYVtDY=;
        b=FoQIaiJ3NT13TeSUKuHlr0zi7y/xj6JXzqfVEkrjhwxmtzC9l/xaqwuX9Aboke7qY5
         nM7Ojf5z2+UPTZbNiZBJmW/U9JQwBW9tNfQmptV2Ug/YKODN22BbN4gJV12IRcK2P18e
         xn9DnkLk2WjiQnu0XOTOJM6wvY8WWuTsRsEcXbwfG1AGeybxoyIZ3D8sUKowHyGvSiw+
         bmyzteJ+BpuZcfZG9cuPYyKPNhoppA7NV1rpDEtkAxFoOS/uYv/vyCR0f6JCUlJuNHzr
         tiU1PrQVS6NNZPF0BH5mogSv13dfdEV+iUWEQeidyDpsW19mQjvtnX3THPOu2UHBVJPE
         Vgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XspkxVwnCCMzj9hgy6TK9qT2xMitwCQCc7943oYVtDY=;
        b=M/PXvvfhD11IFMxxmp4QC9Dcym0d/vkhe4ong6L2CE+8n9uJxthhgfk870DEK19SkN
         FP+cPg8t1G+KneqUvJajZK7fEWfcmCNuwkdCAWYvMqfv4ibmVt0IyZGlWcwZ6P1D7pHn
         4yL3jrxDQXwEbaoBZwYzrNegqLFgUrTajLl+eB0M0NscT6Fj+Q32JDwxOEBdgChichkO
         6w2inyKqs4kFt5NV1eLkaCGt2b+vilGM8Ahsoh90wmmC+p8riLH3KnOovSfGAsLqyTQ+
         CKC8FZz9hPGOjDIUMUQ3F6Mbs+9q+o8/C2qAwz6/dgGwEmkquWXVLx/78xy/EKkI+Qwv
         yqjQ==
X-Gm-Message-State: AOAM5305ZaM2fg0ayFo00KVniIHxjkXt9zS3TypmKYEvw5u7vDsgxCsh
        SfHeDZTyXVYULDVJCxDfcTXjWWcvFhw5+KJ6Dog4Ge9r
X-Google-Smtp-Source: ABdhPJzLR03sniJGZMbdU8jiyE72wleUlMupCX7fnjbsYBHAsyiB+Esr6SWAoZUSEwDSPzYC35yFjSTE415WeKwxWZ4=
X-Received: by 2002:a92:b655:: with SMTP id s82mr4227030ili.268.1593543770817;
 Tue, 30 Jun 2020 12:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Jun 2020 12:02:39 -0700
Message-ID: <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 7:55 PM <wenxu@ucloud.cn> wrote:
>
> From: wenxu <wenxu@ucloud.cn>
>
> The fragment packets do defrag in act_ct module. The reassembled packet
> over the mtu in the act_mirred. This big packet should be fragmented
> to send out.

This is too brief. Why act_mirred should handle the burden introduced by
act_ct? And why is this 158-line change targeting -net not -net-next?

Thanks.
