Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3291F23C93F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 11:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgHEJeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 05:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgHEJdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 05:33:51 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B682C06179E
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 02:33:51 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id q68so10626062uaq.0
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 02:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zv3njctJm6+JcXZYqCty4/Sd4dBn0kL3k7iTzjdDtfw=;
        b=oenfg43n0bbPqzDbC7M2gy1BFz6L4j5HVCwHLtU/Pd/u1lL9Q8XQe9N2tV7UufJLBo
         MATyUl4G6KT941Gq5GWK1IRQAUrFB+lObmZPz6DsWSFZIk98PEkOpyS44op89AjF0Yhc
         /nCPtftT2HFYYw1+IL9n60Qm0Rse1uvZQdFsSt1qycaGxhSvOLb2GrZKd3IQdGpnbER7
         55M2mlDFMUTcf3/1WW8TpGa8ffoPYhK6NHu8G+w75fYXZQNHZYmxpY7ENGI8aJd1IqbQ
         COcN6TjLK7eeGurWWCYgSthmkkpR2GYKwx/B6sEXmj3k30YgV+xNiFNNEZmqWstxYnmp
         HSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zv3njctJm6+JcXZYqCty4/Sd4dBn0kL3k7iTzjdDtfw=;
        b=LtW3MCDiTIu5M/Z5FdQRxMXTppB8hBegLpkNleoAdvv9XChZMMO5SRUjbcO0irYXW/
         3Vdm3HIipfk4JirMc8IAozc3Vsn3qKMQ5gcK8Q0YVQNw83a6Z050dNXGFlFe5OpQ+TM4
         3oAMX/k2cXj/3rHO9qVWNy0x+7FzKTyCq9qTRmP8C1zcaO3PcqoECwqzmR19uutOps3r
         MPOCgm6zMU6qX/NIdzL9sB6LJ9/bB5jU3BiWcgwKmwXL34UKFfyV2KUYndE/d4uzI+ML
         wXv6K2ly1wzbEx0Qyy9RQbg1qfTSCaYzGhvpM+i/II9z1H2fqZjPMbkioCC3CvVp6uRN
         O5gw==
X-Gm-Message-State: AOAM532kws/PDrb6Y6dOJZzE73bGwnfdX0rZu/wX9iMP/1jQdHc4x9g/
        5vwiJpvsENL0ZbYl6ClOEXcDJLEs4mw=
X-Google-Smtp-Source: ABdhPJxuClENbG9opTponTHOKYiGVCepKraQsC/pUZxsLUxMtUH4K0ii7TK9ir9VFN824AITyxx1Uw==
X-Received: by 2002:ab0:37d3:: with SMTP id e19mr1335947uav.64.1596620029728;
        Wed, 05 Aug 2020 02:33:49 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id p192sm241943vsd.23.2020.08.05.02.33.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:33:48 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id i129so4921445vsi.3
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 02:33:48 -0700 (PDT)
X-Received: by 2002:a05:6102:517:: with SMTP id l23mr1162285vsa.114.1596620027960;
 Wed, 05 Aug 2020 02:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200802195046.402539-1-xie.he.0141@gmail.com>
 <d02996f90f64d55d5c5e349560bfde46@dev.tdt.de> <CAJht_ENuzbyYesYtP0703xgRwRBTY9SySe3oXLEtkyL_H_yTSQ@mail.gmail.com>
 <9975370f14b8ddeafc8dec7bc6c0878a@dev.tdt.de> <CAJht_EMf5i1qykEP6sZjLBcPAN9u9oQoZ34dfJ68Z5XL6rKuDQ@mail.gmail.com>
In-Reply-To: <CAJht_EMf5i1qykEP6sZjLBcPAN9u9oQoZ34dfJ68Z5XL6rKuDQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 Aug 2020 11:33:10 +0200
X-Gmail-Original-Message-ID: <CA+FuTSf2r1eFoFHov-cGDG=5iLAUGt+Jv7Aok7EFrVo8UqkJog@mail.gmail.com>
Message-ID: <CA+FuTSf2r1eFoFHov-cGDG=5iLAUGt+Jv7Aok7EFrVo8UqkJog@mail.gmail.com>
Subject: Re: [net v3] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        netdev-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 10:57 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Tue, Aug 4, 2020 at 10:23 PM Martin Schiller <ms@dev.tdt.de> wrote:
> >
> > > Adding skb_cow before these skb_push calls would indeed help
> > > preventing kernel panics, but that might not be the essential issue
> > > here, and it might also prevent us from discovering the real issue. (I
> > > guess this is also the reason skb_cow is not included in skb_push
> > > itself.)
> >
> > Well, you are right that the panic is "useful" to discover the real
> > problem. But on the other hand, if it is possible to prevent a panic, I
> > think we should do so. Maybe with adding a warning, when skb_cow() needs
> > to reallocate memory.
> >
> > But this is getting a little bit off topic. For this patch I can say:
> >
> > LGTM.
> >
> > Reviewed-by: Martin Schiller <ms@dev.tdt.de>
>
> Thank you so much!
>
> Yes, it might be better to use skb_cow with a warning so that we can
> prevent kernel panic while still being able to discover the problem.

Let's not add defenses to work around possibly buggy code. In the long
run that reduces code quality. Instead, fix bugs at the source.
