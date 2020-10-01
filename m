Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB027F708
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbgJABKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbgJABKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 21:10:50 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF18BC061755;
        Wed, 30 Sep 2020 18:10:50 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j13so4493371ilc.4;
        Wed, 30 Sep 2020 18:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=mlu+nXufabQCXgtl/aLMdhskyqL9Xpz7Nkqz4yvDjkIlJrKcy9heINS+TQ/6IZ0MCU
         R8PQt3MGhN2oWQruQjs6Z2LyiZaI8Aio0aiIvnEY76SQTtfQGJ8Fk3BRe8iNJ6++xMgy
         cauXc5+zm/E1hDYKETTV0Rt/DR0vBcTT7uDy4FZJqiJECwfTtvJ9KPQF7KNul/JR0SLs
         MoxDEIJ6d/VVMZghX4SjISQD2rQwJ2OYbpzHV6OvsGtV4QZiiUUdItr/y15KSgMgB1In
         YbfpIEs/SujGUF7djO0/bY3AkECr+q40GthfFP/xbCQCokpvRlMP/P0jl0yhdOMWG9PN
         cV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=cuHUUpRv03zxNa+H84V4xYIleP9F2TCab1jnQUGUGW85dAXtDx0RDaJPZ5P7eXV3Ki
         WVrYzbd34pMmFUSMfjJBRpZA9V3ZN4P4uBjY6hOt/EceDm58zPSERM/5IumGlD+7w5Hm
         XlBuevJrHpY5DMH48M3FJ6VU6hD7IgeThMf6k+06ISNL1z2utUJ3Wz/Bp2jOcPc6mPu7
         B11tWjFX0w6QwF+VbdrqJxdLvmoTdW/8FcegH/mYEAD20kdsQfyytDk0vHWSoWOPKNxr
         VAUiTdaSTEzWib/WUUvoZjDJHK4+CejmMX1M6P2mlYlu4exnu488P1YIyBBMlCXxeRZ6
         LvSQ==
X-Gm-Message-State: AOAM532eeZx8Bf5gr5A/edDVF/R3LS7Ft6OEz/eUHyHpfUmb8SLYimWn
        S0hPbDaWHX7dL6TJR9UQr4gqEHHUGakzWI8ilLc=
X-Google-Smtp-Source: ABdhPJzwp7SrDj1j7a9sADzkI3mbaNIW3HuRXVx3hSkH3CXqpgpTJ4YWwE8SzY8RS4UFX7QfC8Q5kJ/KTx72gcdUa2w=
X-Received: by 2002:a92:910:: with SMTP id y16mr541160ilg.22.1601514649994;
 Wed, 30 Sep 2020 18:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000065deb05b05a99a5@google.com>
In-Reply-To: <000000000000065deb05b05a99a5@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 30 Sep 2020 18:10:38 -0700
Message-ID: <CAM_iQpW+_5wLteCoVc6Wn+z9WOp6FwVUpsy456hM+up0daxedw@mail.gmail.com>
Subject: Re: INFO: task hung in tcf_action_init_1
To:     syzbot <syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git net
