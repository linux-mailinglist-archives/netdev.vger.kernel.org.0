Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7596C5EF4A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 00:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfGCW4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 18:56:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42020 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbfGCW4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 18:56:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so1919423pgb.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 15:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PRnPC62JX/RoJO2/m7GOKXtEfYdUUSzelwP+KhPJ16w=;
        b=YpKWoSeoP8mPpxkQgnQZglfCx5jnSJdY1jiKYlL+sUIb0OfW4xqnmRkLdMNjT2NTwz
         9MQiJoHu40bDZPvu2VldqFTU3rT3DdBHClvwtFqkBXx8+WGhIzttsMK29A/5Zkeyrp6U
         20YtqOCnf4UR+BIpkiNdJVXqHbtmuquinMAQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PRnPC62JX/RoJO2/m7GOKXtEfYdUUSzelwP+KhPJ16w=;
        b=sk5KAcTQBNXyxzFhrH2wpmZJC5wR8FCPf7IhrBlAW8wpV6Jolut/0NdVQfGlhFRRUu
         6IxqgugYgCZ5ikvUALLkdo/wlE3BQFPjMs/YsORc2SWbHakp5v2ZWcQcupKJYaDqn7Fb
         x3bg4saVpKuUUQdp9D4VG81l1YiBaFMEuJMh/9hiUko6thNi539xXo1L1GkZj7thSxee
         RRR6fZDLHlFdtZNzw2Hoa+Kraet7GV15998L3BulfC8AAjpvHI99rmm+7iWol+7f0fo+
         sPz8l/IyN/+oqKfzdOb9GmPGwStLzZmn4VWwj3l6GEB9nmXs0S0hMcj3x4GVVTWu7DT7
         /nwg==
X-Gm-Message-State: APjAAAX0fep2+U5smP8JZBNLUnLciR3JbHfMeZklheSD3/T1goSt13sQ
        aLXC8M9G0waKH4yT/LJ0aAcKuA==
X-Google-Smtp-Source: APXvYqyvAYsxwYDLVdbBmZDOVqaTqouGlL7BWOuPZ+HJcoLd2cmjndbKZyf58r/rkf0fKUu0eYY6LA==
X-Received: by 2002:a17:90a:2190:: with SMTP id q16mr15114510pjc.23.1562194611721;
        Wed, 03 Jul 2019 15:56:51 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id d187sm3427000pfa.38.2019.07.03.15.56.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 15:56:50 -0700 (PDT)
Date:   Wed, 3 Jul 2019 15:56:48 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 4/7] net: phy: realtek: Enable accessing RTL8211E
 extension pages
Message-ID: <20190703225648.GK250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-4-mka@chromium.org>
 <dd7a569b-41e4-5925-88fc-227e69c82f67@gmail.com>
 <20190703203650.GF250418@google.com>
 <98326ec2-6e90-fd3a-32f5-cf0db26c31a9@gmail.com>
 <20190703212407.GI250418@google.com>
 <3e47639a-bbbb-f438-bc66-a29423090e95@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e47639a-bbbb-f438-bc66-a29423090e95@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 11:27:41PM +0200, Heiner Kallweit wrote:
> On 03.07.2019 23:24, Matthias Kaehlcke wrote:
> > On Wed, Jul 03, 2019 at 11:01:09PM +0200, Heiner Kallweit wrote:
> >> On 03.07.2019 22:36, Matthias Kaehlcke wrote:
> >>> On Wed, Jul 03, 2019 at 10:12:12PM +0200, Heiner Kallweit wrote:
> >>>> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> >>>>> The RTL8211E has extension pages, which can be accessed after
> >>>>> selecting a page through a custom method. Add a function to
> >>>>> modify bits in a register of an extension page and a helper for
> >>>>> selecting an ext page.
> >>>>>
> >>>>> rtl8211e_modify_ext_paged() is inspired by its counterpart
> >>>>> phy_modify_paged().
> >>>>>
> >>>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >>>>> ---
> >>>>> Changes in v2:
> >>>>> - assign .read/write_page handlers for RTL8211E
> >>>>
> >>>> Maybe this was planned, but it's not part of the patch.
> >>>
> >>> Oops, it was definitely there when I tested ... I guess this got
> >>> somehow lost when changing the patch order and resolving minor
> >>> conflicts, seems like I only build tested after that :/
> >>>
> >> RTL8211E also supports normal pages (reg 0x1f = page).
> >> See e.g. rtl8168e_2_hw_phy_config in the r8169 driver, this network
> >> chip has an integrated RTL8211E PHY. There settings on page 3 and 5
> >> are done.
> >> Therefore I would prefer to use .read/write_page for normal paging
> >> in all Realtek PHY drivers. Means the code here would remain as it
> >> is and just the changelog would need to be fixed.
> > 
> > Do I understand correctly that you suggest an additional patch that
> > assigns .read/write_page() for all entries of realtek_drvs?
> > 
> 
> No, basically all the Realtek PHY drivers use the following already:
> .read_page	= rtl821x_read_page,
> .write_page	= rtl821x_write_page,
> What I mean is that this should stay as it is, and not be overwritten
> with the extended paging.

I now see the source of our/my misunderstanding. I'm working on a 4.19
kernel, which doesn't have your recent patch:

commit daf3ddbe11a2ff74c95bc814df8e5fe3201b4cb5
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Fri May 10 22:11:26 2019 +0200

    net: phy: realtek: add missing page operations


That's what I intended to do for RTL8211E, no need to overwrite it
with the extended paging.

Thanks

Matthias
