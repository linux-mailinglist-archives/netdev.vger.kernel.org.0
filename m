Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA6114F6
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfEBIKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:10:12 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33411 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfEBIKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 04:10:12 -0400
Received: by mail-io1-f65.google.com with SMTP id u12so1349486iop.0;
        Thu, 02 May 2019 01:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1acnK496SFJqTcJMu4CgJboDMAM5s/xPYYQtkQ45aN8=;
        b=AnVCujeHG0QwQ6IQWU4rQK93qOOulRI+GOQ092QYKEZFXmLjwQPSy2Wt/lYL7W4iO3
         uxFQF6kNHqiYRfFliULe1vq445mV09l95jlj8zldOLt2XZLNyL1DxJEMLn5BdHJJ1McE
         JtSAqbuBYHuwf+tD0m3FMT1eI900/oGu8RNWDY/Y+quF2IhBMaYNtZniB+TOO4GsV3PE
         GP2MfVYjtI/SCWZAYucetffFSEk5OUVNlTyrLt/037OTRB6ryVM+7IVDc2e0HdL476MD
         8NjegW6RrSbRqAlDz7PCvHyG+qf2iJaJRslC3IvSP14tvfTxT2Uq0a0B7/RUzpZxEvaO
         tWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1acnK496SFJqTcJMu4CgJboDMAM5s/xPYYQtkQ45aN8=;
        b=AiLkYeO0ZJIykdL8oPRK5opiXcKtZ8AjRuRWRvdWQQM54ysVLIZdhMo5+3/Y+qZ4to
         Pp+9fBJuXXx3xV0BeAyTXB9rsNgKeHSZmkMLJ2dzhp6NF/QEF6QW1b23ffshOW3YlRWX
         wkqITY46ww25rSowKdBZJ2jDFkDAR1qaiWzFaIPdy21Ob93tWCtHQHXEQHaR4iw+KXl8
         dW5U7kQNRuHPpCyovPq4FuUJgw+74oTBjh4yg5wawtDraazQK1WIlWHaeIGhd8mEaXg4
         2XDAwHiFuxGjHJT1RAFXBgMFgQkmS0EEVizjYdTi+vGPZ0jdIexHzdFMVUnRHhoOLZHP
         WYjg==
X-Gm-Message-State: APjAAAWmU3Ko8DzyVcII6z5OCKmZfPzOoDRr8O+8dSpSBl2Yd7IBhOG6
        Ln5iyUoVU71t+YiRlVziQ67fD3pzCxEeyQYIRM8yNRJa
X-Google-Smtp-Source: APXvYqyFWr7co3ZF6R+WngPwGiLaUWThwG12s2McXPeOJZYi49KU2GgsCJRWXCdxdJLnyHSHc9dzvyQiK3wIdLYafFQ=
X-Received: by 2002:a6b:c842:: with SMTP id y63mr1623521iof.304.1556784611433;
 Thu, 02 May 2019 01:10:11 -0700 (PDT)
MIME-Version: 1.0
References: <20181008230125.2330-1-pablo@netfilter.org> <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com> <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
 <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com> <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
In-Reply-To: <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Thu, 2 May 2019 10:09:56 +0200
Message-ID: <CAKfDRXixb3WoNkBBY9_y77QyydLnjfp9QxO1TniShO+T1O3+Mg@mail.gmail.com>
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on flush
To:     Florian Westphal <fw@strlen.de>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 2, 2019 at 9:46 AM Florian Westphal <fw@strlen.de> wrote:
>
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> > I understand your point, but this is a regression. Ignoring a field/attribute of
> > a netlink message is part of the uAPI. This field exists for more than a decade
> > (probably two), so you cannot just use it because nobody was using it. Just see
> > all discussions about strict validation of netlink messages.
> > Moreover, the conntrack tool exists also for ages and is an official tool.
>
> FWIW I agree with Nicolas, we should restore old behaviour and flush
> everything when AF_INET is given.  We can add new netlink attr to
> restrict this.

I agree with both of you. Unless anyone beats me to it, I will try to
have a fix ready during the weekend.

BR,
Kristian
