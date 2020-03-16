Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FF6187282
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 19:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732367AbgCPSj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 14:39:28 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:39485 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731967AbgCPSj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 14:39:28 -0400
Received: by mail-oi1-f169.google.com with SMTP id d63so18930197oig.6;
        Mon, 16 Mar 2020 11:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V5MeuyFn7e4mHxz4tUSn4H5NtYvN6rAxu8E1UQB7qo4=;
        b=DfBo03+FjBSE7obAc27AcFrOQCT4S8H2sN6Y3RY3suj1HDTsMaI5TQVLdt0OG5TEdW
         8kx2RCuwcrB7OdxDW34uq31gaR1JpOeSuev91BDhv8Lz6jYGrPBvZCbloP+uTYvWIEU4
         3BQ48OzgiZ4l8N7Zb3e8pTxeeHmiZLwWlVeVWaUOHoZ8NalIy2WLl1IbnRr6w4Xdz9sB
         8SomQ6o1JgNectA4G5Q7r/tIIRpXxaAMOvAQqzZ+AvyyTfryQTbZnWusi5erT0CmpT43
         yam7DJhc8x3uMLLSRIGm4xlOfr449lKVhQePQJkg5p0tLe5Y89GBiCWXPJh8HYHltG8u
         AwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V5MeuyFn7e4mHxz4tUSn4H5NtYvN6rAxu8E1UQB7qo4=;
        b=EHPCCxw00rgCqHb8M8VF+WoizFSQh6RNiqjs5cctAixRRIw7NGB5gmUk+QiWY+pFN+
         H/CA4P25ZuVDs5PEAoVG9sKYRkWOoW8W0/YAnUMIj0LxUP9Lpa/Z37EXiwCYaNY2OjK+
         +/ei5GDFePzNZ2rCLfTF33kZWSzV6zm3kiP5LveApJwrbGg9T9VKZqjwkIbZkyrvJ3lV
         XVueYcqNsf4dJ1ZZAqi8xyEsUuRWhitqD5y3nbfDcPdXvNfuCYRmK92EpHMYYFpiyhoe
         nS2JTVRZpdk8ID3uqST3uJXmTksAS+z3WbEWTTD9btmFqVRyspgqjeYn8YQ3phmZx3Tj
         cLFA==
X-Gm-Message-State: ANhLgQ2LxJ412cJrC0vtl2905i1L9WG96/HxxDaIvqbJkWWE0ZTZXFDj
        YDPyRNmW3fy+CGtB/r6dGJcbsNBJuqzngyP+MGg=
X-Google-Smtp-Source: ADFU+vss2VDm5Ia0mCKGMwQ6c+T5PBBRb7qFu9NLC4sbBuTB/DfypVUEnK2IdbNqWoWN2p81Xv0SSB8KVjrKHhFGHZo=
X-Received: by 2002:aca:ecd0:: with SMTP id k199mr717942oih.60.1584383967344;
 Mon, 16 Mar 2020 11:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005d435905a0877414@google.com>
In-Reply-To: <0000000000005d435905a0877414@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Mar 2020 11:39:16 -0700
Message-ID: <CAM_iQpVMWFu8to2zgZob5eYeWWabwYxmpNbJ9J_8Ea94uHEy2Q@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in tcindex_set_parms
To:     syzbot <syzbot+e5db00b3987d59130da5@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net_sched: keep alloc_hash updated after hash allocation
