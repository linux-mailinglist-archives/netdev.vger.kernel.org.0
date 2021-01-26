Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819503057CC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhA0KF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 05:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316712AbhAZXJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:09:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84F3C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 15:08:36 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g3so32800ejb.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 15:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UuWKb7JkRecIO+hyjBuSiB6Qy8dgwEVmPtBF4GparO8=;
        b=D3oUBmmB3OZqm3TlrduboP9AZX/PHA+3HlUGCi7cNPP0v/LpI3eG+llGcsNgKGug/x
         Lkag5eto15Y3uOZp+8BI55MHJXjlvzRNtM4Y1QAvMQnXIdHcdbAcmmHGK1DGD/Pu9TY/
         Vz1yiTh7ar21gsC1y+zD8O3XBdJLhVsSpejh7j3dR6MPyyZ/7A2kk7Il2ITXrUI0qpjZ
         JJdgB3QnyZDh1LyeMYjX/BUyoinGE8zpiJZBhkZVBsZ5+7etl40I61I9k4cDm7PLNSd7
         44azsD+cFuSs0h6GWEWo+vp5T7Xzpunx1TVHNmdCpZLRvLlEGpOj//YnqrdHDCTLbrUb
         uxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UuWKb7JkRecIO+hyjBuSiB6Qy8dgwEVmPtBF4GparO8=;
        b=Dv40vpnHTPLI42LD4TF5QTrhXm8oKumeqCvVyHKNr1a0hz6IjDyR4aJO/g+kkotZ5a
         RxS3PzR4/HHuVnufmF7ytKg9z9azvvcV6rURBK3p/ThH5cYBbhsHtWU0cirmqxO8eQiv
         q397XlgQsz5DVPfOlSqmPl3xcrlbjELZYq65f+eXkuFmU0sSw+ZNQ+oohJF9Db3rl6to
         INeXgUqZiNMZwgJw10ixpQgnTQaZnU6s71oCqfR1P61IbtUGouBETuluvK1L02VGwNvf
         LhLKi7IWDPACd68VGjVJSnsBkyi44nVRP9ZJXlwiBrtsdwOsBKPWO5XewzPE4OQFl1II
         rAcQ==
X-Gm-Message-State: AOAM532acjrHr76BXCCD7/xzLZ1Y8HW42csGJrwwcSSFpGtHpm0f9n7t
        v62lQ/dicAG2yMydK6lTQdGiyoimit/Wxtanz5I=
X-Google-Smtp-Source: ABdhPJzV6hCVEqkSgA9MgGxa38S/AdcqQA1fBPEUEAB4fooQzSCe8eVNCRdN4h3OpueRetJVnjI0d6spWAjXKmD+5lc=
X-Received: by 2002:a17:906:e28a:: with SMTP id gg10mr4798651ejb.11.1611702515165;
 Tue, 26 Jan 2021 15:08:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611637639.git.lucien.xin@gmail.com> <77cd57759f66c642fb0ed52be85abde201f8bfc9.1611637639.git.lucien.xin@gmail.com>
In-Reply-To: <77cd57759f66c642fb0ed52be85abde201f8bfc9.1611637639.git.lucien.xin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 18:07:58 -0500
Message-ID: <CAF=yD-JjXopPwAR=N3+BgfYoA2B53zmcykz9Buk3qfB=8Cc4nw@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 5:59 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> When enabling encap for a ipv6 socket without udp_encap_needed_key
> increased, UDP GRO won't work for v4 mapped v6 address packets as
> sk will be NULL in udp4_gro_receive().
>
> This patch is to enable it by increasing udp_encap_needed_key for
> v6 sockets in udp_tunnel_encap_enable(), and correspondingly
> decrease udp_encap_needed_key in udpv6_destroy_sock().
>
> v1->v2:
>   - add udp_encap_disable() and export it.
> v2->v3:
>   - add the change for rxrpc and bareudp into one patch, as Alex
>     suggested.
> v3->v4:
>   - move rxrpc part to another patch.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
