Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87051E95C2
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 07:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgEaFJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 01:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgEaFJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 01:09:39 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0B3C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 22:09:38 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id s19so4753839edt.12
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 22:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSl3g6ooU2S7nhGGuWtR+BEiW6wsImjVvfxuKdoTE6Y=;
        b=gHmVE0fLHQhTZs1WLBRFhgGsTEDWiv4bei9S5ItNNTM6YN76dVYpwuplW0b+COSvNd
         +JqNkurGLCeKoCoGDHG3dl3v+cu5cTcYRw1u/Jv0wY60aZjCdXU2MjyGB4UQGziPPRz/
         2dDAL0BD0O3pvTkSulxhrFyGLGF7qKi78iYrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSl3g6ooU2S7nhGGuWtR+BEiW6wsImjVvfxuKdoTE6Y=;
        b=UYxXGhH8j/RPGmhykYYaRJ15nOOec2gYcTAmR98QIJGyRkJC/iWU3qT8nZY7tS1uou
         jfN4Nx3O3bk+XRO1D0R65/aSRbKreX7X2BIJin4P5VM1gjo0/vV+vSBPKJLOsqOk8eft
         aM47kRzt5TQBdVjelBy7dZYAB35rvLA78NIVdqdL/M3a3mDrBn60niPHctZ5eHaPTzFP
         nvfBH1D8Fu0VMQnjtgLlWsJsJgHLqm0xZZsRfFs49aGeIWEjfOFEWMK3HFFw3Ue877Mk
         afJz33bevXE+rBhaHZ61plD2YBtw2+v3ffcBo/gYsXXzK0wR6sQ61b1JX/XKsDEk1lXQ
         CpMg==
X-Gm-Message-State: AOAM533IekB5e/h34pouR/S/pu2YyHKZeOPUyQAFBelk4mh4RVk3RYXC
        aqiRBY0vFmetylPxYhi+sawU8LjCOegKZiiVMUtZ/g==
X-Google-Smtp-Source: ABdhPJzvjXxd13IoKqyY80wAB0dwLxOAWVB1hEj5v0xfGtSDFHZvBWaX4z37a40B/+fiKMMV3ri5OL/gc1vkEm6PG1c=
X-Received: by 2002:aa7:da8c:: with SMTP id q12mr15871014eds.334.1590901777665;
 Sat, 30 May 2020 22:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com> <20200530.215858.2059483692603625208.davem@davemloft.net>
In-Reply-To: <20200530.215858.2059483692603625208.davem@davemloft.net>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 30 May 2020 22:09:26 -0700
Message-ID: <CAJieiUjwE+S7TkdhYB2_cGNumeGeBTqfg4DDq+wKqNm6PK2f-Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] vxlan fdb nexthop misc fixes
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 9:59 PM David Miller <davem@davemloft.net> wrote:
>
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> Date: Sat, 30 May 2020 21:48:38 -0700
>
> > Roopa Prabhu (3):
> >   vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
> >   vxlan: few locking fixes in nexthop event handler
> >   vxlan: fix dereference of nexthop group in nexthop update path
>
> Mid-air collision :-)  I applied v1, could you please send something
> relative to that?

:) sure, will do. I will just send the third patch in this series
separately. thanks.
