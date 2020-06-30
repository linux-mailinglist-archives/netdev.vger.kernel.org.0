Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85B120EC25
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgF3DqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgF3DqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:46:08 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED58FC061755;
        Mon, 29 Jun 2020 20:46:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c16so19503077ioi.9;
        Mon, 29 Jun 2020 20:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=c6eKthvj/OmsKDM6C7rNM1Ef+xusgarh0TbLpwZCTU2oQYTtCk7NfZ/vJqv2APs3mC
         xYUQwyvtLW/UnYeGgskUHyl1kfZvezH+Q14NRk5oiISu/QpD0DB0Qma+p4ZzvRhK6Coo
         jOdoRu092uSwgid+MOBS95aHSlNz4iO6tAC9I7aN2kMrTo8+LSI+IoTMff+h5wiezAB6
         Hf3uOrY5VLSwXDxPhhvopWFhHYi2CTDNv75SmuHhIxFtP5wZicpYCLSvP2ZZqQBopwc/
         S5n4QJCxN2mw6rZhu4MpVQNYRx0/qNgp2AH6VIcwZa7P50vG+6I0135hLjoUi9Ot+rzw
         +89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=mG5MLTXHX5+6jAG6edYQ82vrkFGTnGFWCjtf/p06fOicdlVmW9wI75Qbq8RBA+vzZ9
         D4Oi8PM0da7juE9w5RL2GWmeBF8KZzo54J0P4yjxNWqEb2L3h4nsIdoPfsE2ku89HJBc
         ew5+gaInywBS8JD7lbgLeKX0Zj9e6Jg9QwXlqhzKC2vkTNs93ee3jQ4Chj8q1R9cB8K5
         TSZi70c2kP+QdqH/43SKOcZ3YvHYHZ67x/QdEl1j+At2di4J4uCOzF9GYEVmZR508cMK
         QSY85pWYKRLDE3tLYvZ7syUV00dv/dAFc8D7iuT7PPO5SvAyAXFDXLbpC/GiCZbk3dyP
         82HA==
X-Gm-Message-State: AOAM532vnjuvp5O8/wncSpRuoZ2+jtMFKUaNYNIR03eYIgMcZSZ/gfUy
        mOwJ1S8T65uWuEaKgO8lz3GjvQd3oOECnhPqjuA=
X-Google-Smtp-Source: ABdhPJy8XtpEUAaf0XNp2QAWiYLqojzB5Z70sWbCVZyb2IbZh106igboBMXdB10n7VUd2nCxyBgXBawZ0tpUos2YX/M=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr19229780iol.85.1593488767325;
 Mon, 29 Jun 2020 20:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f6883a05a93b4e6d@google.com>
In-Reply-To: <000000000000f6883a05a93b4e6d@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:45:56 -0700
Message-ID: <CAM_iQpX7EfmbWzre1VwrEGRzQm0OQ3cut71kiJiheHkbyyeu7Q@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tipc_nl_publ_dump (2)
To:     syzbot <syzbot+6db30c775c0fb130e335@syzkaller.appspotmail.com>
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
