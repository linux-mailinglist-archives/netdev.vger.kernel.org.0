Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C772022DF86
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGZNmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 09:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgGZNmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 09:42:47 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29BAC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 06:42:46 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j187so12896611qke.11
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 06:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8iw9+To1n/zcEeuNTpy6/kz53z2wBDbS42fW66NdfJQ=;
        b=rbnFcwbfGdUEuPtzg6FUllW2GTFczrXbgI0Q4WFhBuwJicUHaQxtAGAMLhz/ZJ/X5L
         pE222WFxhMXHars3JeDLpGSkhBejKzBPA/PNEzHrp8QQCc7I+VH1SKgWsUjLCA/agnV9
         V6rZcdTs9z8LOLarconQQYYYSBAD9UgpqWTuXrN5fIq3GMHjfU6iPpukJvVvYtLaFckE
         hUmvJeIlusuCKQB6pTem2AskRRyWX3WmqEb6kEBvuBYWQFhmeSL2uvQvdDU4HpWKwqZS
         C2Ks4nQETxn3YZBlzBLHiJSXm/Pq5CDN7C/zjfJHRvx2/ZrOgnoO4oclVQKzM72kRDBp
         cLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8iw9+To1n/zcEeuNTpy6/kz53z2wBDbS42fW66NdfJQ=;
        b=bJHfSV3CBy7K08cWX9O/wP1EAGQ4hXrBYviGpAtf0mCcH1k/88NRO9IWh+tE3ZEpfJ
         dFOY4LYffsGvV/ynlOTatl9tcN/J79mV578913R/0UgaMyMdvd6kIl3dWHN0LCTmWZ/C
         v6PNcJJ5LSPMiBAbMw7v53U28Du84dHAk12S3IwB13M46EobVG54t19PayzYRvMTm13e
         6Tq6ibpUovS2qQFIYoan/851i/L2/gQuPc/y6zIkKv5Vc0dMxuAcJPw+ZhdyAe0Pu2y/
         Lf4bVIWlFNil94Jk6P9KGdftJOmO5yaqKUk587SbefQWREQE/H4vtTy5NzVVVCLPxmlN
         FPLA==
X-Gm-Message-State: AOAM530RJByGMl5sqtnEF16B7GOJ/0KzP4p3Xc55cQIaIvbtsRrs1Ppf
        DHBZL8AFRTThmUaNUOeyyyL/+zLk
X-Google-Smtp-Source: ABdhPJx8jRhYy/8ZfWjQz67G1cOZGR76mf2eBMLK7doxcbhb5h8xFUJDlNOUJVZjxcazfleX+z0n8w==
X-Received: by 2002:a37:e86:: with SMTP id 128mr18246645qko.314.1595770964758;
        Sun, 26 Jul 2020 06:42:44 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id m203sm13495086qke.114.2020.07.26.06.42.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2020 06:42:43 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id n141so5135852ybf.3
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 06:42:43 -0700 (PDT)
X-Received: by 2002:a05:6902:6b2:: with SMTP id j18mr28516340ybt.178.1595770962614;
 Sun, 26 Jul 2020 06:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAEjGaqfhr=1RMavYUAyG0qMyQe44CQbuet04LWSC8YRM8FMpKA@mail.gmail.com>
In-Reply-To: <CAEjGaqfhr=1RMavYUAyG0qMyQe44CQbuet04LWSC8YRM8FMpKA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 26 Jul 2020 09:42:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfpadw+ea-=pL0pMXxujzjoLW+d9yH2+GQo0jOJv=Zo4Q@mail.gmail.com>
Message-ID: <CA+FuTSfpadw+ea-=pL0pMXxujzjoLW+d9yH2+GQo0jOJv=Zo4Q@mail.gmail.com>
Subject: Re: question about using UDP GSO in Linux kernel 4.19
To:     Han <keepsimple@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 7:08 PM Han <keepsimple@gmail.com> wrote:
>
> My apologies if this is not the right place to ask this question.
>
> I'm trying to use UDP GSO to improve the throughput. My testing shows
> that UDP GSO works with the local server (i.e. loopback interface) but
> fails with a remote server (in WLAN, via wlan0 interface).
>
> My question is: do I need to explicitly enable UDP GSO for wlan0
> interface? If yes, how do I do it? I searched online but could not
> find a good answer.  I looked at "ethtool" but not clear which option
> to use:
>
> $ ethtool  --show-offload wlan0 | grep -i generic-segment
> generic-segmentation-offload: off [requested on]

Which wireless driver does your device use. Does it have tx checksum offload?
That is a hard requirement. In udp_send_skb:

                if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
                    dst_xfrm(skb_dst(skb))) {
                        kfree_skb(skb);
                        return -EIO;
                }

> $ ethtool  --show-offload wlan0 | grep -i udp-segment
> tx-udp-segmentation: off [fixed]

This is hardware segmentation offload. It is not required.
