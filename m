Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E3D2137C5
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 11:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgGCJeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 05:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgGCJeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 05:34:10 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C6BC08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 02:34:09 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id h39so15177371ybj.3
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 02:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvCF6jGj9+cRTtslz+J9IGROnaBv1vbb6Y68KY6Jzmw=;
        b=LGUhIyUyYiIrYAoHOEuKp1YzuCZ20eWme1nSaTkCfkq8QjfPo8js3EjOFHlXMYUaHs
         eielRAF8jnu9F+sJxfaD5mf4Yi6LZAO/tJ3oY7E/paiUXWLEG58ZxVwGLxENEbXSrafP
         JGFUpMS0B27jN0FzuGfa3osZClqvrbwd7FCzUfGDSQZ/QLAXM9f9mWS8VgIP6KBaNEbU
         grRG7AbsiWpdd1shlzdjhrhPOWwJM30/2A+YA7j+Oq01VOnwo8bt2++ftGysONS/MJNI
         XidL3+y6RdYyD8zUICsQTfSCc6/zDy44+vg8v6ASPna6YShMIqdmvVPN9izeb9axVdOD
         kubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvCF6jGj9+cRTtslz+J9IGROnaBv1vbb6Y68KY6Jzmw=;
        b=HsSCbda7esIpkcI3ur09EGYsybmpFl4KoWs+47bshl3psu+iUp8sONEo9Yr2AR14Oi
         jdlVuNcYb7ZvAjJptfcxxvuG3du5A0SmgC1NGf4qLgtROlTXYC757kDtuz9ynjSo1eCo
         jH10zvXrJiU7UB+yEYarB++K8CHa1J4SCLOu/UAVDDKKkV5XJFFAiqwWRmOxn3kslOd0
         OAmkB4wyo3BWJRjwi1NARz7U7otRa8C7STa8W9HPDIfALpYs+bQB6S2YMX4Z4lEoxTiq
         IrgL2Wvfue75afPu1NFZuTmKYPrgt3GhEifxC4lfcP2Lpyv2hC7DesVktg6FSU9wbiBh
         wGyQ==
X-Gm-Message-State: AOAM532wGSDZfVVYyKZFCyF0HBTSyq9a2snsQaeIfGxS2//nDK5lJktx
        5wTGgNbChA+7YLTZ3nmNu+j3ACLiaieOYepW/HZ+WCBS
X-Google-Smtp-Source: ABdhPJxy4LAuSiSh44iEW7L2d1dh8Wzuqkhg97Un9ULCxrdWkGftq9Fo8EtYrqJLdYfMB6++p4DuYe5Ki03BvP/2C2M=
X-Received: by 2002:a25:2bc9:: with SMTP id r192mr56861527ybr.329.1593768849170;
 Fri, 03 Jul 2020 02:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221923.650779-1-saeedm@mellanox.com> <20200702221923.650779-6-saeedm@mellanox.com>
In-Reply-To: <20200702221923.650779-6-saeedm@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Fri, 3 Jul 2020 12:33:58 +0300
Message-ID: <CAJ3xEMgjLDrHh5a97PTodG7UKbxTRoQtMXxdYDUKBo9qGzdcrA@mail.gmail.com>
Subject: Re: [net 05/11] net/mlx5e: Hold reference on mirred devices while
 accessing them
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Vlad Buslov <vladbu@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 1:24 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> From: Eli Cohen <eli@mellanox.com>
>
> Net devices might be removed. For example, a vxlan device could be
> deleted and its ifnidex would become invalid. Use dev_get_by_index()
> instead of __dev_get_by_index() to hold reference on the device while
> accessing it and release after done.

So if user space app installed a tc rule and then crashed or just
exited without
uninstalling the rule, the mirred (vxlan, vf rep, etc) device could
never be removed?

Why this is any better from the current situation?
