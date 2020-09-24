Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34AD277C58
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIXXjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgIXXjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:39:54 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FA0C0613CE;
        Thu, 24 Sep 2020 16:39:54 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so1074826ejb.12;
        Thu, 24 Sep 2020 16:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M/T6SMuSQxWkK9zNd1KTMPycKvBLqqSkvYfJSypIeZI=;
        b=hHrkTdXyG4LnEOpfuTipZ7/o0M/roFSJ2oerQ7SbTz9bvtzI/OGVyiANTDtrtR4vKm
         Bk1Gd5es+E1eNrOaNIDv8NUvuXhyi3ryhTo9vTMFFkKvK7avas2W4po0Peai7YA5gvQQ
         ekS/I9N1LVqdZVBsF5abSf8eSTEcMHjWmsqmG/qmLJgGvKRnwQbesK0oPHq1GFSCZ8wd
         Y3Sadcbk+TKF6JuCPYNhI0PEr2EzKD2a9QzO9LNWIqODYoUwN1lakjyYwoP0QPhJQV9I
         IMvfSpYSpLVy/y4546B7f2PTyCRk+BC5Z6dXBxTsGdFWEBICKjNCwNk+b3DEuH5NYCDh
         GdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M/T6SMuSQxWkK9zNd1KTMPycKvBLqqSkvYfJSypIeZI=;
        b=QBkbSSMZOj6Ybldi4nSeFH29/xDfkDiGjLrnq7S6b+8reY4Z2OAnmGHKEejpth1RFc
         daF65EUdY3KluLpU8uwTXCx2CVKoLfr7XuCw3rVASj4bhOwW5l3zfwkjH2O3xiG/U0d3
         JZZYBBlFg8QD3vg2lxnr8BEeYUh56QIvwy9b3qCJ/Rwy218VAWf1DyhjIc8yhCdt9ejE
         ZZp9ncgar+PT+OpTMKmQaBuqEyL4SDqxsgs4NHG4llcqg0kYgGjOeR+sg3nm1sg60GrS
         vn3a1ZVar1woO/kLVaGXMWhzh2xXIdyTThrvQBquxilVNrwY/rUIBI+mxoq6TOW8SMJX
         aywg==
X-Gm-Message-State: AOAM5310lHBFf6VlAxxdfn6XDr86mn0dNANwvC7HMSE55tKTJu0QV6oz
        A/mtpuIckdFlQy8XP9zDb6A=
X-Google-Smtp-Source: ABdhPJwt6kAxWnfM0LTveDjYti3nWXYPY1/qS4N0O4tLjaTaaxQEJP6TIOkKYWfp7ioihJ7VxD7CMQ==
X-Received: by 2002:a17:906:56c2:: with SMTP id an2mr88857ejc.118.1600990792717;
        Thu, 24 Sep 2020 16:39:52 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id j9sm609650ejt.49.2020.09.24.16.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 16:39:51 -0700 (PDT)
Date:   Fri, 25 Sep 2020 02:39:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, hongbo.wang@nxp.com
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200924233949.lof7iduyfgjdxajv@skbuf>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
 <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Thu, Apr 23, 2020 at 10:29:48AM +0200, Horatiu Vultur wrote:
> > > +static const struct vcap_props vcap_is2 = {
> > > +       .name = "IS2",
> > > +       .tg_width = 2,
> > > +       .sw_count = 4,
> > > +       .entry_count = VCAP_IS2_CNT,
> > > +       .entry_words = BITS_TO_32BIT(VCAP_IS2_ENTRY_WIDTH),
> > > +       .entry_width = VCAP_IS2_ENTRY_WIDTH,
> > > +       .action_count = (VCAP_IS2_CNT + VCAP_PORT_CNT + 2),
> > > +       .action_words = BITS_TO_32BIT(VCAP_IS2_ACTION_WIDTH),
> > > +       .action_width = (VCAP_IS2_ACTION_WIDTH),
> > > +       .action_type_width = 1,
> > > +       .action_table = {
> > > +               {
> > > +                       .width = (IS2_AO_ACL_ID + IS2_AL_ACL_ID),
> > > +                       .count = 2
> > > +               },
> > > +               {
> > > +                       .width = 6,
> > > +                       .count = 4
> > > +               },
> > > +       },
> > > +       .counter_words = BITS_TO_32BIT(4 * ENTRY_WIDTH),
> > > +       .counter_width = ENTRY_WIDTH,
> > > +};

Coming again to this patch, I'm having a very hard time understanding
how VCAP_IS2_ENTRY_WIDTH is derived and what it represents, especially
since the VCAP_CONST_ENTRY_WIDTH register reads something different.
Could you please explain?

Thanks,
-Vladimir
