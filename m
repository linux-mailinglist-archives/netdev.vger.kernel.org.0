Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0848F230430
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgG1HfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:35:15 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:55013 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgG1HfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:35:15 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MuDPf-1knLMT1jCv-00ucez; Tue, 28 Jul 2020 09:35:12 +0200
Received: by mail-qt1-f170.google.com with SMTP id t23so11082490qto.3;
        Tue, 28 Jul 2020 00:35:12 -0700 (PDT)
X-Gm-Message-State: AOAM531bLlf1hTCvlV7+0iPP+VmKnVqyC0bNmn7Y42CWdYosjblaUS1A
        O2xQYKUZowkVbYKRdZRpHwqd6cAhzo/wmJzTJc0=
X-Google-Smtp-Source: ABdhPJzm02izO1Ffq0PZdADjKoK3t4vds3+X8L/oZzjLjgpqyxpOvLwSSCIHYnBRr4PgGF+B+aNhgZlxi8N9vDUMUn8=
X-Received: by 2002:ac8:688e:: with SMTP id m14mr18758364qtq.7.1595921711141;
 Tue, 28 Jul 2020 00:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200728022859.381819-1-yepeilin.cs@gmail.com> <20200728053604.404631-1-yepeilin.cs@gmail.com>
In-Reply-To: <20200728053604.404631-1-yepeilin.cs@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 28 Jul 2020 09:34:54 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2_61F2OT3FkNF4zTdmQ+VtdGkr+dWu1SuL+q6YbN-Ytw@mail.gmail.com>
Message-ID: <CAK8P3a2_61F2OT3FkNF4zTdmQ+VtdGkr+dWu1SuL+q6YbN-Ytw@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] xdp: Prevent
 kernel-infoleak in xsk_getsockopt()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ea85R/l0RhqD2jar4GIsAVuSbP8q+tqdgYpDciLzCh2vczIgPY7
 0U7W0m2+00t53Ngi4QwIblA7e7OymA/4xAtHe2b8aw+7iTNvkrqMKqcI6BkX8Is2/6VTXsx
 VsmbEKJXUIHbzmJRfuYZstroWcFWqHot7DKwQHOsZ9d0vadiyYovN+9l3I20dV2LOIEpQXN
 OPpYUr2IANQwBfCReeGNw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bBIWiQconYU=:etXMGO21NeYgUooWd7eSo8
 KAZRJ8GQXB4d/stO00LAjEEM01ZISG881LiYnQN9QLMq2RBGmdrqneORsJ8WwEtrZPyQPLmSZ
 XxOjdLm9zwQUOKfXnSXWB6yvDchCz6LutZFG3nwlbgPi6/6VOsZlyYaUsHxS5sb798juHqBCn
 DE74HDiIhjBp0c3cGb+Dg7I8E1B8XaDYbpd7rwJuw8n2vGnibK1mpeWFXjqPBOzbDEN/JeS0H
 DLvUWpX0Kaq5SnbXzbQvbBLzV9WEFda1d1TLAlldYDgJrqVZvOrBKB3tc2vJUyt17ZNcc+92Y
 zSoK9/N86OnJhWHT4IlbIer4WfISWLOG10ErIf5A1ym2WGeq+872pU3LvAd4OsoYhCZ+p3YwJ
 WCuhBOjTbBs31dCcektc2o6pvtuSxnbiBMHohEwLi8ZXm4HH24fo9lrwSh09mVGgIMlOyaP6e
 FfC8X1M/MoNba2MbAkApHSjyDWEqUJVVgPHVqEVrIsQMEn6uX2H31bPipfDr1sxw55glBsc/n
 qV6V6Kf6oVJOTMC5swNDQzKtlSybW1gPsMW766UI/M52eB83yfBgPuLyGpuLd0hZQTS8FQkDN
 ZZe+0V7qo8L6jzSFVP8a+vey1Tpvct8MdjmoLUejc1Agc92unH+q7G3qREGj5kwpO+zlLHWv5
 O6z6H2SBjbRik+CVJyhWpMVk5JQiMXfku9mJ0w7NilGRkU0MFwJ8pPtiH4R2AoK1zxmBAgO+n
 k2yVK4RQYURdeGkjriz6bIYKGfMRjDNoO7uJI0622VhDb/+8aC2BnVgBvKUnyFVlEdaNnhpj/
 h/janOHjW+5Y6yVJjxGPZisonAEwxXhIJyJBUr3vDK+upLCCYMO2COzPZPZJE4BVAT33CRp9r
 23M2m8Ql3mS9UyP1YZMjjS167kxcUmHIgz7rEdlf18ewPLShiAyMIbtvzhCfVZ2wwTJuG/BMS
 mFdXXRr4ELUgnxr2MT5i+49vnbohHmKS+JlQU1nLYkgBqv9aCFuQ4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 7:37 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> xsk_getsockopt() is copying uninitialized stack memory to userspace when
> `extra_stats` is `false`. Fix it.
>
> Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
