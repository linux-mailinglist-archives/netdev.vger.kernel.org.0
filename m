Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4CA3D71AD
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhG0JD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:03:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51691 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbhG0JD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:03:56 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M2OAi-1m4Ruv0WIo-003rxm for <netdev@vger.kernel.org>; Tue, 27 Jul 2021
 11:03:55 +0200
Received: by mail-wr1-f42.google.com with SMTP id z4so2398582wrv.11
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 02:03:54 -0700 (PDT)
X-Gm-Message-State: AOAM533ZCsp/7C9U1Oo/lb33bxVqE081xm5zGxI6uAHd+o3PRPzhKCQh
        FS3n8fd77qwRT2pbqw/OCpC4LklpbPlWrWmks5Y=
X-Google-Smtp-Source: ABdhPJySShWKcG2RwpVerTPmFEX5iIw5w7s3SYFxEBgj2IP+TxdzjSd15BmZrg6y/ajs8q6BtOLE+Uv4mJvDr2O2PRs=
X-Received: by 2002:adf:f7c5:: with SMTP id a5mr4766275wrq.99.1627376634786;
 Tue, 27 Jul 2021 02:03:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210726221539.492937-1-saeed@kernel.org>
In-Reply-To: <20210726221539.492937-1-saeed@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 27 Jul 2021 11:03:38 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3NC2Mda-8WMbO2OJZvtEwvxGfLgGmLo7ZsDrfg1MW82A@mail.gmail.com>
Message-ID: <CAK8P3a3NC2Mda-8WMbO2OJZvtEwvxGfLgGmLo7ZsDrfg1MW82A@mail.gmail.com>
Subject: Re: [PATCH net-next] ethtool: Fix rxnfc copy to user buffer overflow
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:8r/fWkSqghuzcF3/A83WSq+75fT8PMj32tQCH7nGgjLhpwNj0/u
 Jqe4phk7rqRpij+XYhcb4vQcLxg+W+M4wF5BgU8QbE7U0YsgBRRooK9PqI0hI6Ga3inyT+h
 3i78NU4QRfqLLhECO5tywKIXCzgAC4HSeB1KD9y0ehpIM1+YJt6IrD9FpJtpeYNhhAnMfye
 FnflWDhqjejmPyBaoF2GA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jjWj+wkPo80=:B9Zz2X5uEakpdf90JDRQeC
 can3EsC6ceE3qj+3qutFcRTWv0rYyl7HwHkA7ctRG1sI4ifDjDLRava9X7k2jfIYffffw6MzK
 tYmM/zeuSa3rCHL+6TwK1azHg0EumVtQgqvJoRzrdSeVesfiWChEpUp1JHzc8acTZvPMkvgNE
 tDSS/qsHwBQx9/9+G2B72AdOfMkxh/y/O98cnVDcmxS89b5h2Ifgx482VpMf4JyWv3bZiXidw
 nbWUU4fI+9OpW8yjz+3DUih4Dx4sEf81fAA8J4w3E5WxOEV/q5VUErGx2Yeud1F4K7JmX63Y8
 0u7K+Ids5tanc4OROOrcDpnKUzNYxxMl4LVOJxqvFfCdA4CyZzCJMYbDJ5U/izjCKzCglTlrr
 m87kHlPyHtSkKyWqZ3zohaqOOBlZBpVfmdyoix/yCbyl6rMIr81ssozotDIfqhxxBI6/2yRn5
 mm9CkFfwlcoe0BL3ExpEVlW1/k0OunVt6uY9hKBVWwradn72ydXYju3CkDo5okj/X9F5BAFhO
 3D7HUB+uNAlnazv9nj0LPb/l9K+XaG3WZWOQcyV4W3EHxLh08xHFEhPHifb7oD2j/uL4/vLJf
 B4vlT0IdLvuRmVXda8NnEiR7Fe163rpJjm6/2AXZOR+U8IX+8kLRU+9Ad3dAy4wzEReT04pIx
 lGI9KVjnI0YXNNiVgzcdcbKq5oo1YNI7ZX+c5/XjOt/2edjWf6O96KA/cpT+Gqwtn7GE3jnka
 0BERUiCtz8LzUfmrwVAAh+JoGE8T/MROOTHh2kHoZJPla49nxEWB/lpbXJlefLAWD4oD9NXKf
 TyC6b/8O9zlMw9hnnedkHv0Q4kHlQ+2UMAuXhZzstn4ckVMRT3ahjg/KRkcPesTppxjBcSq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 12:15 AM Saeed Mahameed <saeed@kernel.org> wrote:
> Fixes: dd98d2895de6 ("ethtool: improve compat ioctl handling")
> Reported-by: Shannon Nelson <snelson@pensando.io>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Thanks a lot for the fix

Acked-by: Arnd Bergmann <arnd@arndb.de>

         Arnd
