Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142E4227FFC
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgGUMeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGUMeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 08:34:21 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37683C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:34:21 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id u64so5792741qka.12
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W2qsGEvG5h67BEnGqS26t8X2j1qWAlQERAMmoeMa5CA=;
        b=fSMw7Xw3CVOMGPD2u88xuZNyvV9k4tct2KkiU41bNvQWZCPIEMG/t46NMZd92LJVAL
         rChB7ztTzkCRL/Yr2bZIxiZKVDSLoW7C9tZ7/pUrAQJFmP+xGTblVRafo8/Z7P2NjsP+
         Ye2zExvsmrtt1b2LeXipgs0EvcN6XX/NS5xL65rPWGdU2R+Ar034mqKqwwjI5ZRnDyPw
         emrCO9AQuMdGz/i+ebEuhi+ZseXJcEmdwIONIJY8AeUWbMPHGnyZMqf9VU/r8Ud5EDed
         RRAD4fnqPSuY132EJL/hpfGTLlG/VOZG/TdNs9nHd87DrjipXVZSWAttNc4nGP8OD7nx
         4sKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W2qsGEvG5h67BEnGqS26t8X2j1qWAlQERAMmoeMa5CA=;
        b=h4IUanR67YER75Rd2oEpE66vAlgrfWn9W/89bwCNJg7BzugEoXP2MaYxeoKEWBkhRy
         IM6bNClZrwfpn+9jBl+Ua/s0KGuUYm+vHgm7kiP+R1RklktFqCeDzHdtT2fKmdJNEkrM
         lQ3S2r8xLwKWTVYsVEvv48Aa2JM9ehmIUGr8l41xXugRUEHk6CvIh/UXJLKT+uUWs+PJ
         6dIEOOj8mtlMG+hKOQ+wXn146Ieyi/NqlNDuzD74nQyItzlANakJGsOxCgKKbsxInwpJ
         OHITFo3q1dSJGu34p17eHiHWc2YoiQObCEZhm1Jy5BNoT/vQbnBDf63nY8YynPW5RFRE
         /APQ==
X-Gm-Message-State: AOAM532ZVWMx9+Pb3MSehVcBL0BNpfqmWovF5K85pmW4w9BG2yvGDCRZ
        hKQ7iwK3gsK0z7UQzz3QqpH+MQB8
X-Google-Smtp-Source: ABdhPJwaeA3eH/Myjf/n26Eg6mCk3ZxBP77ZSV787VP5cAacQffNUfL7GCIiRxV3CvRvuvAC5m+wgQ==
X-Received: by 2002:a37:9147:: with SMTP id t68mr26019561qkd.34.1595334859669;
        Tue, 21 Jul 2020 05:34:19 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id c205sm139775qkg.98.2020.07.21.05.34.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 05:34:18 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id 2so9957080ybr.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:34:18 -0700 (PDT)
X-Received: by 2002:a25:4886:: with SMTP id v128mr39329225yba.53.1595334857734;
 Tue, 21 Jul 2020 05:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200721061531.94236-1-kuniyu@amazon.co.jp> <20200721061531.94236-3-kuniyu@amazon.co.jp>
In-Reply-To: <20200721061531.94236-3-kuniyu@amazon.co.jp>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 21 Jul 2020 08:33:41 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf9K5EH8Q3nvUE1=dBO2x1TNGPbapZLONmB3dqruuHA7g@mail.gmail.com>
Message-ID: <CA+FuTSf9K5EH8Q3nvUE1=dBO2x1TNGPbapZLONmB3dqruuHA7g@mail.gmail.com>
Subject: Re: [PATCH net 2/2] udp: Improve load balancing for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Craig Gallek <kraig@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        osa-contribution-log@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 2:17 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> Currently, SO_REUSEPORT does not work well if connected sockets are in a
> UDP reuseport group.
>
> Then reuseport_has_conns() returns true and the result of
> reuseport_select_sock() is discarded. Also, unconnected sockets have the
> same score, hence only does the first unconnected socket in udp_hslot
> always receive all packets sent to unconnected sockets.
>
> So, the result of reuseport_select_sock() should be used for load
> balancing.
>
> The noteworthy point is that the unconnected sockets placed after
> connected sockets in sock_reuseport.socks will receive more packets than
> others because of the algorithm in reuseport_select_sock().
>
>     index | connected | reciprocal_scale | result
>     ---------------------------------------------
>     0     | no        | 20%              | 40%
>     1     | no        | 20%              | 20%
>     2     | yes       | 20%              | 0%
>     3     | no        | 20%              | 40%
>     4     | yes       | 20%              | 0%
>
> If most of the sockets are connected, this can be a problem, but it still
> works better than now.
>
> Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> CC: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Acked-by: Willem de Bruijn <willemb@google.com>
