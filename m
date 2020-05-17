Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539A61D6BC8
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 20:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgEQSmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 14:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQSmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 14:42:16 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C300C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 11:42:16 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id g25so483895otp.13
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 11:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwl0RGZOIwhJuoUhECAWvdmU/bcjQnrwMTmsyakY9lM=;
        b=Khn+9aa8jg5e1SUk5JaBGmJwfnbFJjhQIeNCCBHn8PlXXiDjKaaelUcCx2fEtXE+OR
         cjFGB0Ar9QkrQzH1/+WPSnj8sLg55OLIBma2oYbi9IxF8mqY939LfUJCbkmbMcOfD+o4
         rpsYiFRP9K/yQyI+LZoTO/vJHGmn75prpCZKaxbNFGd2xIDDCN0HFmQ63VxuVpkeDlCA
         Km6dbohfm9LY7KWGuXDNzc20IfdW5R9YUMPMgdNAiVZVWGsmpxwJ9qj7kx2EwPy08fxI
         zsrn9T7Ausl8jGGeB1WMM7WxDG0ARxzoN54PwoKQMB5CjTWAexk/Z8HOhDbuDQz9fByU
         6xwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwl0RGZOIwhJuoUhECAWvdmU/bcjQnrwMTmsyakY9lM=;
        b=L103xfm3sQ+vkAwItvSLxW/6XAHGn1euBDU36MC7PCo15Fy5lJmu8v3nmfnuZpaBMp
         8/N9Mo0y6KZREkf4HD7oYw2kZ0WszGl2m8A1F6Z0s3p9boj8F/REwdO/xSVQgAQnnu8w
         HIR8a1WXjiwVt2eB4k3jgroysjqvaMMCryHKgX+jK0R48s/ther6xNIzLU+kZ0B+wUao
         Db8+uqte4DAKVFwL7uSn/Y1Pax14IvS9vnKUhMCpjUK+D4YYdaxpf5xSiiv2QzzqKXsx
         kFZYefMhSlXxRFuOqkaHr8JLSs3LdTWOoCZPZgh5xDZjCp54xt756Gn6rXCl0RpRFNKq
         KX0g==
X-Gm-Message-State: AOAM533dcvnLiyQ6aI46+Y/7vtY0cQHmNRj6UnKmIYCA8sXe/ESe2JFW
        SiKNEpkj5p/47aKdtkha70gyREoPfzUjReFEziw=
X-Google-Smtp-Source: ABdhPJw3PtXAZL/z6XS9bsXVv+BUXVjy3zOjButO3RT2gG4Mvs9v6lOETziHZz3NYhRK+DIb3qZKKU+9Hiha7JiyzFQ=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr6740707otm.319.1589740935266;
 Sun, 17 May 2020 11:42:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
 <20200503052220.4536-2-xiyou.wangcong@gmail.com> <CAMArcTVQO8U_kU1EHxCDsjdfGn-y_keAQ3ScjJmPAeya+B8hHQ@mail.gmail.com>
 <CA+h21hqu=J5RH3UkYBt7=uxWNYvXWegFsbMnf3PoWyVHTpRPrQ@mail.gmail.com>
 <CAMArcTWW+HNqvkh+YwR-HCLMDTq7ckXxWtTyMWRyDLvgYXc7wg@mail.gmail.com> <CA+h21hoWpXN-apJXyDgOLM7eByXdcuzczdmX5jxoPk9wxJzaNA@mail.gmail.com>
In-Reply-To: <CA+h21hoWpXN-apJXyDgOLM7eByXdcuzczdmX5jxoPk9wxJzaNA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 17 May 2020 11:42:04 -0700
Message-ID: <CAM_iQpV-LGNp=jBvFKhz50FtcYUpU5eCY8L853oWRFVoSqUPjA@mail.gmail.com>
Subject: Re: [Patch net-next v2 1/2] net: partially revert dynamic lockdep key changes
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Taehee Yoo <ap420073@gmail.com>, Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 9:53 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> Thanks a lot for presenting the options. In general, xmit in DSA is
> relatively simple and most of the time stateless. My stacked DSA setup
> appears to work just fine with NETIF_F_LLTX, including the updating of
> percpu counters. I'm not really sure if there's something in
> particular to test?
> Anyway, will you send a patch with NETIF_F_LLTX or should I do it? I
> can do further testing if necessary.

If DSA is software based, there is a large chance it can be just
using NETIF_F_LLTX, like you said.

Please do send a patch for this NETIF_F_LLTX. Note my patch
simply reverts to the old code, this issue probably exists before it.

Thanks!
