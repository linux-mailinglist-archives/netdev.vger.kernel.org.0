Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EED20EC51
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgF3ECH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgF3ECH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:02:07 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1CFC061755;
        Mon, 29 Jun 2020 21:02:06 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id i25so19609294iog.0;
        Mon, 29 Jun 2020 21:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=Ky/iwafX+R7dEmWZyZumx6DSeZPlvcCGnf07kA1EqZ2yRSbzaR/LXNRc5U1uI6zusn
         u+EiYnWG+JuhYHO0o94bpvhUzNWKKrF7/DLfDrkUPzwOLSeo9ub0K3pjFmen8fTDAnVf
         BZ/TN4WX8DpphcUTFiD08QZ0tz6fE2nt6QR5sJ4dWnSV5WcYPD3s4yzmqO+zOjRDFfbR
         rSVJjubT2vLGH8HcOSyS+B3DEtSK5lEUj0lUEyb1BqfvDO+KKtQMnebYpm/6+43YLRC7
         UuAljR0/KCMeYJJjVxweHH/p4nuPd/bCpjrYrJH8D1BLghuA03ihwrqj03pgBEsTdoqo
         9law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=pFDbVik1EOo6jRBNO9YWV/EAjhW//MdCJ+HlTOdgnygKq1I7iA4fWAX9/WFdKcN37K
         qdMYAplBeCTwuANBQaXFvtGZrFozJ5zo0asjqnzWj/n2f9VZ5fNJopaLmP13ok8rOlW7
         klSaqIZmWrBSzlC+QSFIJMV3EMozVpoSzIv9vepLuUMesYQth9rKeRefYJC7r7hjhbHx
         z9GxuF/qEGhf97UCNiECMXh1qBwSkaOMdyUMduJrvuXxN3E3MJrUr+a0R77gUkE3zjrG
         I4cJKz0010On5eiW50NQP0tiq9PP4FbK2esk6mMfLwtdQzuz4z3K5LGzq/wDaJpZGxLi
         Jq0Q==
X-Gm-Message-State: AOAM533P1El/xfyri5IeUO/4InDy2zG/EQbQVzUMohTWFibERxF/h0ZX
        /9ou44n3TvuIABI8eevOIL38dh1QmgDamJdRkp4=
X-Google-Smtp-Source: ABdhPJzTs4iypkYJ4X1iAIulRzYJC9ZkZD+Cs777rZ1TTCrDJVdQr4rHW6keFvhcH9/GrW+YPSIFYa4tkC2/3uqe5E8=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr19269584iol.85.1593489726375;
 Mon, 29 Jun 2020 21:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000049ea0a05a8ffc126@google.com>
In-Reply-To: <00000000000049ea0a05a8ffc126@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 21:01:55 -0700
Message-ID: <CAM_iQpUXmLsM7dtZfcx59tC8fJWxnBd7tLi2iJ3990w-pkDb1A@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in nl8NUM_dump_wpan_phy (2)
To:     syzbot <syzbot+4c8afc85aa32ddb020dc@syzkaller.appspotmail.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
