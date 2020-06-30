Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3007C20EC2A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgF3Dsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgF3Dse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:48:34 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2706C061755;
        Mon, 29 Jun 2020 20:48:34 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id k1so15288840ils.2;
        Mon, 29 Jun 2020 20:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=YV4Bczfd6bRQ9u+eV78DMYCoXm1i8z9d/3fuFQu+vwiA2aPI3YZ8WhC292HaKBRfNP
         RhhGynlz+72LZnDTTao74cspJhBAu2YxIMiWQ9DhiT/yP3HuVYfdJDj26IHtkZJUuMkj
         2KhwW3iVCq6490GoCXVJh6wortfVW1+8f6nIw30m8JeXLBOqhVEwQ2vnmO3eKWP5ujDP
         +q06XRpDXWU9ea+yNtouGjdWF43ssCft2kSjUrF8flgz9DeUB5wZG+1+OQ9DzLc8YgeW
         bFyiRbF0fEQEk6wF2r/i3P1SOKsfsunzwwSDwTGwudBthnqM1VNsRtafBDlx6wHaH1Pr
         MCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=O8IBU5Pmd2QjNqvLPsX0IPOprGGPWtvWVnpyIh6gZKV2bGBD8Q5ZfrDtQYttRPubgz
         wclATHuB7ejw4SP7K/Wv4YKMm7aAmVUPSF85SwdZBg0ZbVfneQmLyrTcsRjTo4GNZBZd
         iRzfxiH+36h4DbhxcqOkOtpQCt7FpP7x2xYNq0nE+Oc2xzP2LWsl3xthgBLGG74V59TP
         QGAlt/d9MmUr6iB6YrqV35/hCAmI8DjDjyfNBc+DSyt+a3VeA8lt7uhXFyQW7sYwTcx5
         Uf/YppLT4pOlCnmXHqN1OVpSILlW7/PXzU0D7Y3y4R76oDIjSyV0jAU3TqBF5Satn5nk
         AEKw==
X-Gm-Message-State: AOAM533CtexwywBOIPNpym45kE72Xk3sptPywaQTcKlLXbOPZwRlf0Gt
        AWv4skIs91aDMAxLj5mRBK4ThO+5jzUDx3EPpRE=
X-Google-Smtp-Source: ABdhPJyjkFEj14utEUhY6LxqYobmK3bsy7i35K8spE7FGJtI1qZq51d4GS5sK0tLkpXIkrKSpdNa3biT5pTxesm4ysI=
X-Received: by 2002:a92:bb0b:: with SMTP id w11mr756075ili.238.1593488914196;
 Mon, 29 Jun 2020 20:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000744a6805a93b969a@google.com>
In-Reply-To: <000000000000744a6805a93b969a@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:48:23 -0700
Message-ID: <CAM_iQpV0oPkXPwca_annXc4Rr=_Wa-izZ63tFqML2WmxXuYV_g@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in devlink_get_from_attrs
To:     syzbot <syzbot+09b4a3f42f32d58b8982@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
