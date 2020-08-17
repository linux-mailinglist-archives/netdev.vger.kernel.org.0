Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9A2471B2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391143AbgHQSch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391121AbgHQScK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:32:10 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61298C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 11:32:09 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so18529771iow.11
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 11:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+x0tFLOI1cqLAY5+IRsGYeL7iWfqCWDchfr9LLcvrdc=;
        b=nNb67H8dE9ONQltNXAlUD14U/2XakE5PNMblRzUW5yvcQpIYXsIoCuu+KHNhARVARW
         0Ifbh0SsgcOrzuptnSlooJsCjvHNrT74aNx78WX3Hiqy524MprNaa7tlatlpL0it03r1
         79WOKxbXnEXjsltPrpYMHwk5EB9AeWRU86JwCseap+87a0v3bI9RRze/iK9zBhCqwSpw
         zrYqCmcGG/0bzES+v2XvCrd95WaDJEOOI6pGHMvOJ+EsRnUmLKL2P34utJqeYDRs3Fki
         muplc9n0NWmxG7g59vd64gHszJWDj9DlEev2Qn9DjKKsfywlRo5fBRlgEvb1EcM3UNzC
         DbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+x0tFLOI1cqLAY5+IRsGYeL7iWfqCWDchfr9LLcvrdc=;
        b=MtrqfvlY5c0AU+xhgD6D0+VCATf3PzFODunuJucVd+V8IDxWjNn0cvzQ8f2fTWcnFS
         ZbOC3+bvikAIRUEZe8rvPxA0IXrkToA8Xnfi6XuK3jeZ4cOM551TN5MePfNp2dtMogj8
         oBFdJeYTdgnQyVLFiiBE6/GFviUTxiyELIgf2WpHVEAWYuk61IEAMfq50Rwg8XV9rcDS
         7Eo/soRe0aLTWsxhDc6G3gM5vOfWPFbUPTJCX5fLxT3ok87WylVolFqp11AJDQk3OyAg
         cMOkoApe8n91Vj3aJ8Cekcm3UUwf+PEJ+1tbnEq6BDAXNq4t3/9z+GQgW2idBW1+zaTN
         Hwjw==
X-Gm-Message-State: AOAM532D9TyWsJL1BQBAAPQyNP7yGZgsS1tUPlngN00cRaRuP3RvAsI0
        pbN+oPDuKCmEQzBAHCiuIoYmdOGvIHbUySnYPVI=
X-Google-Smtp-Source: ABdhPJzcqQyuiq65VlLYs6lTAzwOpP0YUEFuzn5YylxMwpHqiVRccnimqPCKBslw4OUiE5EMxb0HEjrElMkkNXaWYzo=
X-Received: by 2002:a05:6602:1343:: with SMTP id i3mr13134241iov.134.1597689128717;
 Mon, 17 Aug 2020 11:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com> <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
In-Reply-To: <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 11:31:57 -0700
Message-ID: <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 11:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, Aug 17, 2020 at 2:29 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Or put it into struct ipv6_stub?
> Hi Cong,
>
> That could be one way. We may do it when this new function becomes more common.
> By now, I think it's okay to make TIPC depend on IPV6 || IPV6=n.

I am not a fan of IPV6=m, but disallowing it for one symbol seems
too harsh.
