Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED61410D0
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgAQSbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:31:33 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:34674 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgAQSbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:31:33 -0500
Received: by mail-ot1-f43.google.com with SMTP id a15so23380273otf.1
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 10:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O6K3NpF+yFUbY5mjLo/9N6tdjNVG23p1tidP3KjCkWw=;
        b=VDLXwmIe+3KvGusGIBou7wQr4KKUSlNKcKqq9si2oNqVf5dkGQsoukTkxm686pDGnH
         fP2XUQKE4p+M38BdzHZBWaCXBtpnr6QV2LLcHkaT30BB2+dhiwPp0ye0hhEy0PM4mXA+
         Y7ULGTmBDXa5hSbasbWo6yZhA1AMLlJVsc77o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O6K3NpF+yFUbY5mjLo/9N6tdjNVG23p1tidP3KjCkWw=;
        b=NSdSYPyVm4d4hIqTl/T3wHJE+gbX+aunyh8PqonN2CkpDM6VUIxPwQBD28fPUfPyAe
         g6Zb3wL+zDoPgTt6yxLbqd+qB1GK9I1ym5Das42LErFzMROnYx6FoAwnv0L0rjJzGFn0
         /oXzcrzJH05cGL1qN9trYTD79DwW2vsHo03lgIMyoFmXeJp/xUX6h+4aFbV/TTh7QZcr
         CrlTIYrZq91RpTIuE3pFu5Odi8dQ23dDTmki9odpN1IFjF9D3eawggHu8dxQxegVSpa9
         +sqgIEdTu9BNImNA2KykvFwdR/On8L57+6ZmhcjV0V9StqX1JTe5kvADSESf5Yxt6GSW
         PJIQ==
X-Gm-Message-State: APjAAAUKYkQtLybmahnoglrrQkv7amX708lfMBEhkKHoTCECeuy8jH1d
        qrGZPlv/IC+02ZV1Bp0urGKsD3rDQN8HjdRv3dQ5S11B
X-Google-Smtp-Source: APXvYqzAdejlZ4GkR40lSUHL/qsBslGnQa/dUmF3AlUTNXpaZdkJJBSR+TvN74bjW+iyJTWCxAWxBxqxtqZnVM2ddW8=
X-Received: by 2002:a9d:784b:: with SMTP id c11mr6765678otm.246.1579285892167;
 Fri, 17 Jan 2020 10:31:32 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+hczhYdCebrXHnVy4tE6bXGhSJg4GZkfJVYEQtjjb-A-EQ@mail.gmail.com>
 <CACKFLimgUxTV7Cgg5dYtWtvTsWpOK538UtLmyyxP0tTaYOzL6g@mail.gmail.com> <CAH6h+hevYD8DOr-NnRTNDB_ph2QNpCTyAJSrQJgvxwgYZ28MjQ@mail.gmail.com>
In-Reply-To: <CAH6h+hevYD8DOr-NnRTNDB_ph2QNpCTyAJSrQJgvxwgYZ28MjQ@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 17 Jan 2020 10:31:20 -0800
Message-ID: <CACKFLimOUZdkPK4mT2oop_0z9JWGOgx3sUW3BVbkcdouVjLmdw@mail.gmail.com>
Subject: Re: 5.4.12 bnxt_en: Unable do read adapter's DSN
To:     Marc Smith <msmith626@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 8:04 AM Marc Smith <msmith626@gmail.com> wrote:

> I'm curious though about your comment: Is there in a fact a kernel
> config option I can enable for "extended configuration space support"?
> I looked through the PCI support options in the kernel config menu on
> 5.4.x but nothing jumped out at me that sounded similar to this.
>

As I said, I received a similar report about this issue and they
specifically reported that PCIe extended config space was not enabled
in their kernel.  I believe it is CONFIG_PCI_MMCONFIG that will enable
access to extended config space.  It's also possible that during
kernel boot time, the MMCONFIG base address could not be determined in
their environment.

Thanks.
