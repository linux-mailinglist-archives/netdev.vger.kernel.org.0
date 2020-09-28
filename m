Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB7127B8D0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgI2ASm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgI2ASm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 20:18:42 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4AFC0613CE;
        Mon, 28 Sep 2020 14:50:57 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s88so2848877ilb.6;
        Mon, 28 Sep 2020 14:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fKP0iCW5C41AVuyVgy4H4iCpIWkNbhmKoGGaIw+FRPw=;
        b=txxrKViSulx5nWg0jtDkzjfDTpBwfo0AEStIUXIx3QHK1HCmFE8x4JEv8jzMIQ0VMy
         HghahSBICquGrNLxO7fyA6HR4GVMM4Rl5av5KH4D5HjmHcOs61027JJ6+89uF+APN2uh
         BN5hR29lcMhmOyrTIGQgLyuhM0RZbcLiM2oONLO+xGJ7Pvw9Q5+LIOLIGEoN9XOgnSnm
         cjcK2Nw4um/650TxfHCJ/mRHVYLpDoBVl8sbZeXELWaCrsoXs1zgIh9t4MOz62uTrUkT
         wifctUHQ0XztsVxuN7niWW4MoQCqWbtXpzlc8R7uqqaTCA09mNimTS840oPEmyBYk722
         PcqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fKP0iCW5C41AVuyVgy4H4iCpIWkNbhmKoGGaIw+FRPw=;
        b=Itk3MQDwbH50hFJ9aJpsBHagqzjFehArlr0l8Sz4AHL5tVkqFtPfeCfrldkKUgfA0i
         iRtCJ8+euWFUUKSob0szxpwIXMX6b2i1BsEPWl8ash+6N35nmldkxHqOJomkbBxeso6M
         jFV+7Z5vJJbbNhMwMjLth4j1ABE9mL+DeEBOsGJ91xNk+Xah12uhCOJW0oOLJbcirzCy
         yHvQ/dZnIqo1IdHNZaqhJ1bFRPSFlgnJBb8MupcDbqTMbIEsSpDfQ3jA+21reVDzWzuQ
         too3qw+b6EbXkZHUgVbQQ4kPBKJqIqm2iPndtY0itBDHulNMGP3rZAwjwTj0eOkK3rO7
         rN6A==
X-Gm-Message-State: AOAM530CMvu1q+NPPi344udasnWdWhuZxbAnvTJhyEBmxi12vGW1DEp7
        iOnrQBtPME50FoZKhQAm0bHtiGBxyBikcYtulcQ=
X-Google-Smtp-Source: ABdhPJwcIzK8LFFyJn81id6zB83vyHuZH7bJQhMEXxa2VQMxxrs7pEGmiSSMyNFguEMIPBLO+YYTOW4tnrNUnMXSDqY=
X-Received: by 2002:a92:4a0c:: with SMTP id m12mr392985ilf.238.1601329857041;
 Mon, 28 Sep 2020 14:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000095d3605b05a9909@google.com>
In-Reply-To: <000000000000095d3605b05a9909@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 28 Sep 2020 14:50:45 -0700
Message-ID: <CAM_iQpWotD4ZE0QBYMzB0_sEtxo0yLzeVfo-_6rXPwW9o9wwYQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tcf_action_init
To:     syzbot <syzbot+9f43bb6a66ff96a21931@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        enric.balletbo@collabora.com, groeck@chromium.org,
        gwendal@chromium.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        jic23@kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net_sched: commit action insertions together
