Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679D420BDF8
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 05:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgF0DiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 23:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0DiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 23:38:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6718FC03E979;
        Fri, 26 Jun 2020 20:38:15 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so11884746ioi.9;
        Fri, 26 Jun 2020 20:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=YnXy2jJrBLrp9KTsSRXGUin2LhiCDhmNUenGvJpXs0g8wM3JNtmVT1bZJfDQt4O7cG
         lJObOBnpNsGxhljsnoBj39JGTPIC0VRX5Oha5RtskvtjIj90dVZ8Y1FsaZuREFnsus7A
         b2m2jZerWIKuza6SzYPAxK0wxiuxbd1BS0XkuckPlmgVgXQqVXycm+s0lZdSK/g6rNKE
         AHuL3+KvRnJSUd7xdT5uSDKw7AESYMkh17wdQsAeRnobjrK6pua5/4iCSpFo5hi5ZS8E
         AoU7FI7t9yjBZBaGmHzhpJ8HN6CkkOBFqa8Qg1acEpt7aS+csnlEZXrZEj44WkajztKt
         b1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=XqTjumJzLzNatud6Kyi85BSgcxHkZ4LrTwD/TzCCWK61xTAoNhE1uwO2c+cBzrQeEl
         7zePq/pi909aoKkzm3UxfC02f57dgiMt0nQE2NxOEKYzfzlACkgC1VuFBkuWA82rCgsW
         lFgpQDMT8aYUOl0moNZ95z5SaMmG4FT4gm08semYFPlqMCo8iQ+tJcssJJGZ2Dux92Ji
         kV1dAvQj5zmqA0PWgPB/J31nrIPsgCvLMPU0FZYyXpjbk/MTZLEluLlop5MMg82fuvie
         IfDN1uGkcWEJ5B1y89g9Cx117tkO2YPB+bcEUnASKyEnDxfE9IDdBjpOe4Z0QyMmHjPu
         NMUA==
X-Gm-Message-State: AOAM533FKSrboJ7bO0dxXocYylv9Amo2dETOmiZqjag6nYBeS8tVa3dm
        YylKqkaWiVXPt7xCgrMKfx9Q8RJ0ofHhD+28BVk=
X-Google-Smtp-Source: ABdhPJwiJakEnB/h0rPtQqEEP0THFwBZEc3FqFsQCtePH/+CqbzVon/nfTbodf5IBDW5fS6OB6FJAJrRyutRWx7GwyI=
X-Received: by 2002:a02:1a08:: with SMTP id 8mr6492409jai.124.1593229094631;
 Fri, 26 Jun 2020 20:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000069c84c05a907f415@google.com>
In-Reply-To: <00000000000069c84c05a907f415@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 26 Jun 2020 20:38:03 -0700
Message-ID: <CAM_iQpVtv0Ut8nwwLYtKgMpQV2WknQJF9t35Ew4RewBYBvQ2wQ@mail.gmail.com>
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

#syz test: https://github.com/congwang/linux.git net
