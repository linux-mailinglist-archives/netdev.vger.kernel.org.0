Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AAF20EC48
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgF3D6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgF3D6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:58:02 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3B5C061755;
        Mon, 29 Jun 2020 20:58:02 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id c16so19520805ioi.9;
        Mon, 29 Jun 2020 20:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=Jwy9H3saqG5+ztn6id7zbZi8EUBu2AqTjWIz+ky847y/yUCKIZr+q/c1EMqXXwq0MP
         /d8vRx0xNyBYGO9owyhdrFkaFcCpZGArjxCXbdfOYVG9YgEjF6Cew0HWK12Y2p2VFe6q
         F4T534Tf8mZpxsKuYB4NqtbV+lvaPJtFnpb3ZAwha4Is24FITgbnDCfPoZOc1KEqaeH2
         jGCl0R/rWja4zxHwQcSS9NGmiH36Wd4PbsEPHDj5eMYkWw6Ei58jF/qYYIx2tbVeZZxd
         EfKwyaiOBN62uh40HELVbSBaHvxcdCnHWVornMMYtYLP+ZO8/4q4e+/sQkQzQ/XKkQjB
         xUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=Vu1kQzeSxKcr5UPzu7rQFr9YfIHGO5Vk5oBtR2vxyYpY3vmi8qbazUIwWhzKM/rC1d
         lxA6h9w0CbU44poi30Zz6gIBcGDbppmVrFrU2sNww83v3Fr5HwtkMNQ3n3ABYO3v5Qfk
         2TcSRhzNZHRUHmK4zLG/DoLJ1mzcLDTU7Eytl3DSaVjvWu2IOiW5xMqo2/txiGwU7leB
         LdaqFfEB3aCdPpaY0881e0tM6KvYgKOj/qR04uTGNZqlfMlE+fieGXuP1yO+kmXlS3b7
         vDL6HfkSDTyeJad5uaPt38gUpTx4TuvEG8ufoap6IpkL/S3tDIuEPgdbm4ei6TlF1W2A
         hbmA==
X-Gm-Message-State: AOAM530fwgsWhV2Hi7sRGyJPBHWY6RDd7q3aiFvibRBV+r5Wyx9jMSmP
        C5hMERy9oP7YM9vDX04RoLgPJT2Cd4feAi3RUtHvTJLNDCc=
X-Google-Smtp-Source: ABdhPJwsMHFmKuMtjStSjy8YPYeY4ccKaAc2Q4sEyCVJktz4mtl1pJTnFggKJ/bIPMWTwHU13w3hbppW4usUQsntj6g=
X-Received: by 2002:a02:7818:: with SMTP id p24mr21683369jac.131.1593489481628;
 Mon, 29 Jun 2020 20:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000069c84c05a907f415@google.com>
In-Reply-To: <00000000000069c84c05a907f415@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:57:50 -0700
Message-ID: <CAM_iQpWBg1dU16UYwgDLsMqfmxKd6X=xbJeDjPMNDjOYceBJaQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tipc_nl_node_dump_monitor_peer (2)
To:     syzbot <syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, jmaloy@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
