Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E92358F98
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhDHWCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhDHWCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:02:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2558C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 15:02:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso3940574pji.3
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 15:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQGXKvls8BXlcmzc3nfFhBPDBs91KZDEjwiXpeAbl+Q=;
        b=tbFTmVBZ3mDake5d/W3swnnlRND7CNjOYcKTu8W5BE7komS9nsSop+lavMEzRU7qCa
         ylPumScT/Vrg/bZI4GiBwpxJevyO32PHEjjXwhfACcf9lpKkNFxrI5wVKGH1JLfBLcAK
         v8dSFkaJ0nQZh9kpQMjXH7bM0ldFkxVg+mRZhUMZ9Ks8yBES07F6Sqn1ddtOjDxENIJe
         GqLTYlmTwpVCHhIwDinz9hjIzPrwr85S9Mj+ycu8Lk7bgajGN6DGyxH2++CkHGN1+Y5m
         NGpZpCobyy+NHBdcRBR25kyghGezGP3dvI7t+ZBFVpHFLbKk323aGT/UUTHPp31nhVlR
         aivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQGXKvls8BXlcmzc3nfFhBPDBs91KZDEjwiXpeAbl+Q=;
        b=t/VGfaWidnln5dzztF4AgWk3w3P2wRpoo/WilQxjkakmftgPpy3YzXdLdxDocFXFnL
         96UrMokidc/96163P/UFd04yhBKZzG3VOiDFSf+9dDm4ULlPhWmUfgEvMvpoLsaD+CIz
         986i8RqoBouc/2ZVsRKJ1wy572hHoIkvAHkZj8qcc1+tAjcvXPd68BO6Ay/1afujqHRw
         bsC9Rc2qXbYB3xoZzoo0GOiDXlJffBErwydZNubm9tNVRFxYnQPKDwGqFWfr+vBH/5MO
         EiRs3OjRkQjx4hk6miDgIQjVMjTQsknsNIrgW45gaSm/mhzDZld/LrrrePNoO0NYj5bz
         wApA==
X-Gm-Message-State: AOAM531z6NS24P+d/QcbOrGi+4WkUnzVf5nBmpvle0IBk2q8/numeAqp
        j3XZKjiYUEd2ZhCegjB0KuGnnXKq9zAQH36cPzM=
X-Google-Smtp-Source: ABdhPJxrq8WOoy286Kph2yZ4BuxY4xTLgFqUX3Fx40W2xLfN6lwxwWrNEsRu6NlEUbs/1dPwNS7OQ9234VaUcQJIrJc=
X-Received: by 2002:a17:902:8347:b029:e7:4a2d:6589 with SMTP id
 z7-20020a1709028347b02900e74a2d6589mr10079993pln.64.1617919340562; Thu, 08
 Apr 2021 15:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210407153604.1680079-1-vladbu@nvidia.com>
In-Reply-To: <20210407153604.1680079-1-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Apr 2021 15:02:09 -0700
Message-ID: <CAM_iQpUmaQ2w7pd7xn4deHu6sYb8wRO62mN_97nN6Kwte7t3LQ@mail.gmail.com>
Subject: Re: [PATCH net v2 0/3] Action initalization fixes
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 8:36 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> This series fixes reference counting of action instances and modules in
> several parts of action init code. The first patch reverts previous fix
> that didn't properly account for rollback from a failure in the middle of
> the loop in tcf_action_init() which is properly fixed by the following
> patch.

I still hate the init_res[] array, but I have no easy and better way to fix
it either, so:

Acked-by: Cong Wang <cong.wang@bytedance.com>

For the long term, we probably want to split the action ->init() into
two: ->init() and ->change(), like TC filters, which hopefully could
ease the complexity of tcf_action_init_1().

Thanks.
