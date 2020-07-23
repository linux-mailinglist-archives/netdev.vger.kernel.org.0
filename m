Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE9F22B73A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgGWUIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgGWUIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:08:47 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5223CC0619DC;
        Thu, 23 Jul 2020 13:08:47 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id i4so7567021iov.11;
        Thu, 23 Jul 2020 13:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=SpQK6K2X7N0C93+yndRn4e10pNS3E6luEgTo2qRq7ZDJmopozQp8rc8IfHFTso3kYd
         aMzLH2nJyI1b5h6m8Q1tY7vuWgduwqhhFg2OENjbJ0w/TtUeDw5cKCKhMR6szmGZ9K1c
         TzvbuU0yyf/2Vi+FTeNgFhvk47WwNW2KAWUu5u8htMwNzauJnHmhQZT8Ldohg1FR64OQ
         PENHr9Grjx4NITpr5hDCI1F/2OSCI7AmNHwclsSCK3yLE1zJVpYkTp0swFwAp0iqda1L
         i4kvxOssLg/IRmTIXAj6BV1yVpwpGKGR/nsBWGvc6/yP5WyikuA27BuUnEGqZ9L9iHvc
         DYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=LhLoZK/OJ4ByOTiseYa8eTJdiPGFvynIfOttqGDdYVJar6ioKuxP5JLlJI0IGbHLJq
         dOynwKA5kYwZR+LZWcnbyUVqGrBphX7XWzDUEEwfuQ3WKyYSuZr3GI0fhziC8xY30uf5
         vlBn0uneY1PCmuo+N6DwyLe1kfer7toofwK/lVOQS4gvu5kuCZw0SYPp6Ua3DspMJlkd
         E9acrIF0N0vD22BqgFUPjLCg2HXJ7qFrMFfzmcfdLuJaPK3qoYT2AE7Nwv+GtTaMWfNc
         hkaME7knFoSRh43iVaQYcCPK0dR+LRi6jXxTFPrjdQd+WHtqIt2jDSLvpz+AJU5RWxUY
         1Yrw==
X-Gm-Message-State: AOAM532El7tfQyztNRKbdLwPb+MrsUUmZBO2LiIzw1D1mWI/ofsMzZEk
        DeOna5DsF7D6Sz4kEm6N9P9HFzMWvekGRPokcgA=
X-Google-Smtp-Source: ABdhPJzixoHFO5I7nPAR72Dn5wBNlGEL/NvAFr0dUTpDHWk5arAIEJvA5sLvjSFR2WuRuSzwG/YuToZLIWJ0ABDkT7g=
X-Received: by 2002:a05:6602:1581:: with SMTP id e1mr6911572iow.44.1595534926642;
 Thu, 23 Jul 2020 13:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b1b74105a91bf53d@google.com>
In-Reply-To: <000000000000b1b74105a91bf53d@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 23 Jul 2020 13:08:34 -0700
Message-ID: <CAM_iQpXTe-DCr2MozGTik-SxOt8wiTehe6YkNhZGtDWfbHNPTA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in macvlan_dev_get_iflink
To:     syzbot <syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git net
