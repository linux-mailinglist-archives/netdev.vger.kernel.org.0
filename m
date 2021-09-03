Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7F400104
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 16:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243523AbhICOKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 10:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbhICOJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 10:09:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826DFC061757
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 07:08:59 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l6so8157987edb.7
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 07:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pLYrjeZgUDIctTaJL7OpU9VI62FrytQ5AqIStACCfm4=;
        b=JCYi/P7OmIJld4751FVgpDj4P8gZPtf8wdoTI1uhkZqMS/P3Ma+HqKela7mJ1DYOSY
         MCnv5p/GHzMcs+5kezvYFkb4RAmKVcDBpU5LqhPcq3Qk+N5gyHz0QO9ajw7/8gypIB0O
         CxZhJpWIjEry+q5lYTaqaJN8a4kJbDs0OjyIL07sPC8c5vejJzGIrzJFW6dOqOvtQHWs
         XzcuN+3NKmxnleEI1QZyVP+DDRLYWxBy0Tk8uUc++TitVzaLPslJ1vzN3XriSPR2u66b
         VQEUOMKF/tGBz44/jMNY6LwKcFnKvC+wtaoP1skqpfdj/voSh+XKydxGHtOQzqScctWl
         grYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pLYrjeZgUDIctTaJL7OpU9VI62FrytQ5AqIStACCfm4=;
        b=mseCkHUmihKbXdbXZHLlnVo/VofdWQm965MTtjMA9C/CYbySpI4UO2jHvGxe1/aWXo
         7K/YQ8bqoPCMFw+jJroXYEMQuIiXDVd0NuJ4j45pRjdE3Y64f6rCXDQajBFeGDqRSnHQ
         lwPcUYWgO0le71O3Yh/WFzvpGTPsvQUvRnEP0WWeaJtihDdWQ7HvliEAdwHQm63CekN6
         anvqlXq6fnDa32eXoNW+oKGj0DMEma2/j6EPJHYkdHaiOUZ1pvwKp7BdG0RtLFLRUqGu
         u6LJhAbL0kNB4vbRD6976xaXxzFc2yubBLfh4NB0rqeAlIoK+9YL8CCB86QXtg0PE5z8
         MLzA==
X-Gm-Message-State: AOAM5312lbVbE3HoVVBslotWvd0UoZeRm6/wmN9wbEjAld78QndwFSxK
        pCk7w6d9fSoxLXMTpwbapHBWpo1Ld/rq0A2lyA8QaaNaMA==
X-Google-Smtp-Source: ABdhPJya8KPhv1kK2mrGoJlmdaCp8dyfIIWwx8ijfMBGM672W2xyF8JhviV8KK2qx6bDAK4GbDpiQMZlJ0AtWLHlmvA=
X-Received: by 2002:a05:6402:cab:: with SMTP id cn11mr4262241edb.293.1630678138060;
 Fri, 03 Sep 2021 07:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
 <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com> <7f239a0e-7a09-3dc0-43ce-27c19c7a309d@linux.alibaba.com>
 <4c000115-4069-5277-ce82-946f2fdb790a@linux.alibaba.com> <CAHC9VhRBhCfX45V701rbGsvmOPQ4Nyp7dX2GA6NL8FxnA9akXg@mail.gmail.com>
 <a53753dc-0cce-4f9a-cb97-fc790d30a234@linux.alibaba.com> <CAHC9VhR2c=HYdWmz-At0+7RexUBjQHktv3ypHmFU2jD5gDc2Cw@mail.gmail.com>
 <a732f080-1d72-d1ee-4eea-5266b5ad1447@linux.alibaba.com>
In-Reply-To: <a732f080-1d72-d1ee-4eea-5266b5ad1447@linux.alibaba.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 3 Sep 2021 10:08:47 -0400
Message-ID: <CAHC9VhStVwMMZ9ppLe+StNObBz91Y=55QqFFG+4wKcOahE8scA@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: fix NULL pointer reference in cipso_v4_doi_free"
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:31 PM =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.=
com> wrote:
> On 2021/9/3 =E4=B8=8A=E5=8D=8810:15, Paul Moore wrote:
> [snip]
> >> both v1 and v2 are there with the same description and both code modif=
ication
> >> are applied.
> >>
> >> We want revert v1 but not in a revert patch style, then do you suggest
> >> send a normal patch to do the code revert?
> >
> > It sounds like DaveM wants you to create a normal (not a revert) patch
> > that removes the v1 changes while leaving the v2 changes intact.  In
> > the patch description you can mention that v1 was merged as a mistake
> > and that v2 is the correct fix (provide commit IDs for each in your
> > commit description using the usual 12-char hash snippet followed by
> > the subject in parens-and-quotes).
>
> Thanks for the kindly explain, I've sent:
>   [PATCH] net: remove the unnecessary check in cipso_v4_doi_free
>
> Which actually revert the v1 and mentioned v2 fixed the root casue,
> Would you please take a look see if that is helpful?

That looks correct to me, acked.  Thanks.

--=20
paul moore
www.paul-moore.com
