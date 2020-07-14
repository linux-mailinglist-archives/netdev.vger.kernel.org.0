Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973FE21ED58
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGNJzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgGNJzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:55:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DCFC061755;
        Tue, 14 Jul 2020 02:55:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so6805012ply.11;
        Tue, 14 Jul 2020 02:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=feWyy0YWmvWVEAuHgQpmSZhwHtPX9xjD6RVECBnCw3E=;
        b=szkV+r3apsHlELmwwhzxtkq1yixy/UbcMA1fZ4Ojl6hwP8YJWOUvxKilJEieNgl/mr
         CFKioRISpV6/4WG5XX8mpUMa7j+NitLI7/st6mguFQg8ExUFf5i9sDUUy77If+ucQVHq
         Hnci4wSGC5I7Zel6KvKxA9pR/hkKNSoeIf2W5P6THvDhpvEw6EaDHrsNA9Sz14hWivOS
         aaodikEJC3hSmcgtkFN3xjvr0J80158VGgrlXemKKvNTkGykwQeetuTuTsB823max8IV
         ND7qI01RAydtjE8w2L3J3QFMkXiGYPYaRUmsrSEJyExDAPRoQcScywiY28ytlVewnMVy
         8hmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=feWyy0YWmvWVEAuHgQpmSZhwHtPX9xjD6RVECBnCw3E=;
        b=MKQ+FiGZ9aKTB20Hb/wfKt1lV3H20rvDIQd6ao/wvTlOfh55aYNjwArrZNsOr1s2sB
         j4PHvAjRh9J05o/OkppIMfcGQJSzh8tq+sxIGmZGuCbZIkHGsSPOhYPwvRJE/EBUbxSf
         ZLEOH4BZbWb9H+/UrMui/G3o0opI2GYuFPfhc/uu4H95r+5EwS0o3G2esIfzEdwKLfd9
         3aW39nrxe74Pj8zGv6VszLT+2AEue3XLlQJK6bWqVehX2KHQVlzc4WFUqnLxE8boMIn+
         GoY3ko0HiIX84MsaMftAQh2kMggaHHfrPZV26VDYh051w3DvNs3ZMCUO+1q1gljZlbf0
         0r6A==
X-Gm-Message-State: AOAM5301F8dX/VQCwOk1CTPmj0ZQlHK5jyom2DBIrwiFAFrEzebvbUwz
        ER7FD34OIBnutTHFIjjs7FetL3+yQM+H5onSbQk=
X-Google-Smtp-Source: ABdhPJyLkwHAgk0Hq9Da32IJsRjfu0UEDZPtRnkMliyiC9nKvLchi2zi9dqKwFcuEsMNxDe5/zAQeyqFPhpPEFkQ8O0=
X-Received: by 2002:a17:90a:fd12:: with SMTP id cv18mr3943134pjb.66.1594720522822;
 Tue, 14 Jul 2020 02:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200708043754.46554-1-xie.he.0141@gmail.com> <20200708.101321.1049330296069021543.davem@davemloft.net>
 <CAJht_EOqgWh0dShG258C3uoYdQga+EUae34tvL9HhqpztAv1PQ@mail.gmail.com> <490146353e9225245d8165b6edade1a9@dev.tdt.de>
In-Reply-To: <490146353e9225245d8165b6edade1a9@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 14 Jul 2020 02:55:11 -0700
Message-ID: <CAJht_EOu1cWt3bZJaWw3-TpbEVY3yr7HGeo3SLZb+6HDNed8gQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 1:07 AM -0700
Martin Schiller <ms@dev.tdt.de> wrote:
>
> It really seems very strange that this driver seems to contain such
> fundamental errors. I have never used it.
>
> But the explanations and fixes look plausible to me.

Thank you for reviewing this patch, Martin!

Yes, this situation is very strange. I guess not so many people have
tried this driver. The comment of this driver says it doesn't
implement the checksum, which is required by the international
standard. So I guess it can't be used for practical purposes anyway. I
tried this driver because I was personally interested in X.25.
