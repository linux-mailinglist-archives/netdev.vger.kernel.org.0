Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8966424F339
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgHXHli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgHXHli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:41:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC387C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:41:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id m22so10584004eje.10
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTzlQ7Rhg3BTSDxMZf6QKa1TmEEqVMRelM5+HXqfNqc=;
        b=ZgbzKWZocv0/t2CkGuegbUbenwIhMyURXxemd3OHiQCAU7jPp3cSLx0vy7JGG3a0eG
         ahMpvvNdDFtCdPNW5IiLFE/KIsj3t5l3m6n5cZXK+TLzDLrON23KTcgds1SsjcRHA2w2
         20R26VXWkHSSnxXR4Yi98MbEchd9I7e/grPRaDhcUllIVcyVzOzcaq9jW3Q+T8KWeIF7
         jQYBI3UmSkHJKfO/dLZ9PGWhcBCuRkJvf68sdf8symmIs0ZUclG0Io3geZn6OyNSNyPp
         l9+N3RC6V5U8/NjG6EAgHdirwOuJQfV8L/ZhRknOoaVUwFGUuWUeQikZBZK5xT1H9TRH
         RZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTzlQ7Rhg3BTSDxMZf6QKa1TmEEqVMRelM5+HXqfNqc=;
        b=c4YCUiTZWXyVOTJjtz8h0Rp9IbxC587evm0HqYu5rBQ5E3vlIhkFPXUrYd5n+lDGY0
         1++wlJtB3TL1ZTVODsHfF38CC4+ddfxawsywIXcNGRKey9FfG65mH3QedxUoqBEP+FtA
         7xiZRNCa6RZa4fhfepQQMcrqZqKseSa75So1TX5ceeTM6XDRs7noo0ORcYavxF+yVt2W
         cRCE30fewWDN1eTq7FixItWJCPS4NPwd/978V9K8bUIB7EAzDnJxa0L7QGWgqzjHLkLK
         OFlRKqLB/FzEOA/lchfAjqkiF8kjmXxFTk8llYWrn9dKhtz/GD21EWFCxMwtIe4AnNn6
         B+Vg==
X-Gm-Message-State: AOAM533L0hIUgp1fExxdyiS7cV76MNZMJ9c+iiXXuY1+LnKfXpD79xwc
        B0F2+Lt51qRoquQqVOwnv3TMhMfKI2zWkwbrjNk=
X-Google-Smtp-Source: ABdhPJx7uGhhzEjLv9XhBS3RFhbxJfOOxkIRVFJ94dz0Erq+e1ybBX6FxHSeHUqqKNoInlZBGTBDLSMdaGan5ZyBdms=
X-Received: by 2002:a17:906:1a07:: with SMTP id i7mr1413ejf.122.1598254896396;
 Mon, 24 Aug 2020 00:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200818100923.46840-3-xiangxia.m.yue@gmail.com>
 <20200819.155207.713791050216186108.davem@davemloft.net> <CAMDZJNVcuN29b5S0JxqzEcw4yG6S+TVSpwkiohYJMgE0TU45PA@mail.gmail.com>
 <20200819.185209.697239873202931307.davem@davemloft.net>
In-Reply-To: <20200819.185209.697239873202931307.davem@davemloft.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 24 Aug 2020 15:39:41 +0800
Message-ID: <CAMDZJNV4RXtbzy8SyyLbUCt1LE2wCOBcTQYt=-WR5T_2hQMNCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/3] net: openvswitch: refactor flow free function
To:     David Miller <davem@davemloft.net>
Cc:     ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin Shelar <pshelar@ovn.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 9:52 AM David Miller <davem@davemloft.net> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Date: Thu, 20 Aug 2020 07:21:33 +0800
>
> > On Thu, Aug 20, 2020 at 6:52 AM David Miller <davem@davemloft.net> wrote:
> >
> >> From: xiangxia.m.yue@gmail.com
> >>
> >> Date: Tue, 18 Aug 2020 18:09:22 +0800
> >>
> >>
> >>
> >> > Decrease table->count and ufid_count unconditionally,
> >>
> >>
> >>
> >> You don't explain why this is a valid transformation.
> >>
> >>
> >>
> >> Is it a bug fix?
> >
> > No
> >
> >>
> >>
> >>
> >> Can it never happen?
> >>
> >>
> >>
> >> What are the details and how did you determine this?
> >
> > I want to simplify the codes, when flushing the flow, previous codes don't
> > count the flow, because we have set them(flow counter/ufid counter)to 0.
> > Now don't set counter and count flow and ufid flow when deleting them, and
> > I add BUG_ON to make sure other patch no bug when flushing flow.
>
> Add these details to your commit message, please.
Hi David
v2 are sent, please review
http://patchwork.ozlabs.org/project/netdev/patch/20200824073602.70812-2-xiangxia.m.yue@gmail.com/
http://patchwork.ozlabs.org/project/netdev/patch/20200824073602.70812-3-xiangxia.m.yue@gmail.com/
http://patchwork.ozlabs.org/project/netdev/patch/20200824073602.70812-4-xiangxia.m.yue@gmail.com/

-- 
Best regards, Tonghao
