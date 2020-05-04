Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB77F1C387F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgEDLna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726782AbgEDLna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:43:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CF8C061A0E;
        Mon,  4 May 2020 04:43:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so8612202wmh.3;
        Mon, 04 May 2020 04:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7zq/Vd/myQ/CLDbfPWku2LL/tP/F7KSMA7+XLhhYj9g=;
        b=u8hJ3JzAwBJnpqX4QTl/fM1A96s9krcR44lRLgfz/ZDH7DHDBIf075O5Jh3s1Tcbyg
         lWZEKQyiAjNtUmAKezHOybJehnehqgtuk+LVwdpuNE2GLEQc54QtmWPY0u5715MJP+vk
         sp07LfgKQPnttBrKF9O+F4RqBupuM1bzYj6o+Yqsi21fv95mZy8m0igZjA0Qvd1KjyQP
         yH6s5g6BMhnqMXHtKLGOYbDMHPRYEnJhwO3IcbpPAmnBUyZX2esycZfRLrGkJegP41KS
         tf3crszhytYeYYiRC7Z/b91gAUzjrJowQPKrHTti9EPumDXdhEAKUGj9xA96yDTn20qH
         sMqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7zq/Vd/myQ/CLDbfPWku2LL/tP/F7KSMA7+XLhhYj9g=;
        b=rkKvrS5C9Z0OCzdQgRUblkxkYo33X6sgaxUDu8SauFZ0kMQL/X+TdIs3QwZCNvcF1h
         plfNo673gh9af4q5b1pwbaCGxBFxntNWJmnkEGBeqOkkc8slQmfLzDvzsgOeQyYMJ/Wk
         v74NQAjOOlUgz2DVeLDOCvAVcsvTTpU+vQSHXK8x5m0XFSzTk2Knl2V2S3xqjZVxWu7j
         m8HO+SNaafdxy9gZBzQoq9zjvX+HMgCAFJQ3hLAsquTTCqF81IYUj5N30xeSk5bZm6zt
         nnwCP7aF3hBT82dMU6ay2nyix9D0wpI0tghEuzIFSCNKvpFWgs/3xU03+uWAUDxPDdcN
         ME+A==
X-Gm-Message-State: AGi0PuZEs6U3OqixokyJrV/J3gcNkImn0UwvF3+nL6eyr6CreswzAl9w
        ZTdWBE7fC2BwtXGXDcM2uPt+ObObq+IxJbCpjUY=
X-Google-Smtp-Source: APiQypJ3iuedsbNxfFhX7K/2DjPz9/nHMo3wBXC/NZX8pDB9XJHUyvx+ORF9u68W5iUeL+N9hnq4RCb0MisGH0Fckdg=
X-Received: by 2002:a1c:5502:: with SMTP id j2mr15187871wmb.56.1588592608652;
 Mon, 04 May 2020 04:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200504113716.7930-1-bjorn.topel@gmail.com> <20200504113716.7930-12-bjorn.topel@gmail.com>
In-Reply-To: <20200504113716.7930-12-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 4 May 2020 13:43:17 +0200
Message-ID: <CAJ+HfNhV0+3moPNr8dtSKbTzs8W=z3CdPDk4Brg88hKH=og=Kw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 11/13] xsk: remove MEM_TYPE_ZERO_COPY and
 corresponding code
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 May 2020 at 13:38, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> There are no users of MEM_TYPE_ZERO_COPY. Remove all corresponding
> code, including the "handle" member of struct xdp_sock.
>

"struct xdp_buff"
