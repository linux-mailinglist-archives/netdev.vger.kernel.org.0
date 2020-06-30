Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE6620EC1F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgF3Dlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728930AbgF3Dlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:41:46 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D78C061755;
        Mon, 29 Jun 2020 20:41:46 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k1so15279818ils.2;
        Mon, 29 Jun 2020 20:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=mk+11WlRWtv/l/pJYJZ/RawfGOevO83rro8kVUb/Vrf4DiINK6k0SvEvAv4248qtD5
         SRxsQEFnTPHAwz0Fk09NojsWcpckLNuF16X//8BY1XJohQ7u4yRFrC77VCcBvv93kYLh
         ayp85mqvIvdJxLk3gPh3/Ocd5g/uXWTsZ07deh0prw5mhvkLUdWpuUnE6cgv4arSU0jN
         1n7k1iAFvOjTfq62s5822T7/sgJrEQw5l2g8ZhWLyJC61sr8kuhEvoQyrvQCdIRPcsRn
         EBWM/hL04FBRZ5YafWesRBHrJysZhBGzbkidU4THG6T51lDf4BoXJn2FpMDCT/jsDUAG
         FVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=pMfick0ICJPVYXDZdQqhL4fh8+CtrCbFV1L8QAS0rXeJZ81PauiEU2pjtZhf1LB7D1
         waXfCA644kUiBcvwAjAAt2yO6fMsgnKhrnrvkZaMnpvHOVn2Xjte6AKbUuF8LDjEcBOF
         yjVKoVAQkM6SeV6Qwewyf+uWcVLT6Lkrrs9suB1YsGF5g76/rGx3/7YxCGH8hU8O2ghl
         7y8klvM4bbgUzZxpQWGC68vGmNeCETffcTrFU2VI5c9jp4GQcjceW1067gIlHgpY76PS
         lSTYa7vSijQRMqpovf6gBWOUTnYthDyJADD0KO1dh/PpWsSqD+R5pSryCe+04cO/AI1+
         xNCw==
X-Gm-Message-State: AOAM532745iXsqwI61gq1GAfLyki2orMn+/uWiWYRr3zFr85WEqdbDZz
        aP6zW2MeLO6qRE7PLeItIzkN+1TnQhWJaB6nz7A=
X-Google-Smtp-Source: ABdhPJwMySp39OyWrYSU+/VcHayy9Ma8ihqWkE+7RcZvh1E4BBzAw0Bsx6/HIj42fFNOZQmueF/9iSDAv//sWqEenSk=
X-Received: by 2002:a05:6e02:147:: with SMTP id j7mr744349ilr.22.1593488505610;
 Mon, 29 Jun 2020 20:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c8af7205a9412c5b@google.com>
In-Reply-To: <000000000000c8af7205a9412c5b@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:41:34 -0700
Message-ID: <CAM_iQpVieGdepCKheYETDyo691k=tdj0n9GaEQG=orFTnz7tMA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in dev_get_by_name
To:     syzbot <syzbot+86e957379663a156cd31@syzkaller.appspotmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
