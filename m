Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848EF1030E9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKTA7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:59:55 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44159 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfKTA7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:59:55 -0500
Received: by mail-lf1-f67.google.com with SMTP id n186so6265468lfd.11;
        Tue, 19 Nov 2019 16:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5fRxUlXXstDWJi/psai//6bkR6LldBMpFWpi5SyjDnw=;
        b=QTRroSQJxknUqXKls0Hh2QgV8M1osOyU25GQyapVQRw7hQDgCVUSwj3SRDHmL2IMjD
         tSIWD9ezfNk0M/D74J5z2YzwZgrOt28yEffsqn0iE29Z0wEV107pF/Z8MYesIAulM7Wo
         iY1G3ZceBeqd+wrQjqT1nJQLhPzU+86gd5gvqX4Z9YMBOQt6Cpvphpe+Ll9lnhgdhK9A
         3XJ9M9x0jAkqzzGYqzjapqNpG2SnfX1tHhJVczGTSSnwwPT8p4j7f9/w5msG3zcUT8ku
         Ud4X2KGjyp8omL97cLv2Drzv/g4BUZ/PTXgvxDq23I42EkcwPoQHD4iayQd1/xoBljri
         7ISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5fRxUlXXstDWJi/psai//6bkR6LldBMpFWpi5SyjDnw=;
        b=aHRaL0aiOXG4A96+kj0FVXVDPP+QVeLa4OJ4tlAN966Qi6+j5qcfvigkik0ErXSfpp
         l80wllhXZasSVyCN+G5eqBInEMDFHkcvxP/BIqV5MERT+7LrkROIFiauYFczDBi671St
         HLZ2yGwIYZnMP7zEkXjN3GtClU9y8eQ3jsOtazK/7fhmTVuhraTiSyuBGPVXpvDeXtjj
         EPwudfNS1R9NWHD0bYkLfCIiQrhsfflH3NgdBOoMIMRONpwivAmaWiRTESDnpY5Js4i4
         w41wxZuacN0b32H8z93GfyVepjsYmiYjO+xFGEBe0jhrcjTIvpS3QDVCtuDXeKOsrIOq
         1WvA==
X-Gm-Message-State: APjAAAWXgBId0hZThEpaT2qO6lANnQsKgR8oZQlD8C1evg4mo1qYyOar
        Fa+pCwz6SFEQ5E/hpS2qfn9AmmclH/JAAzW8ja8=
X-Google-Smtp-Source: APXvYqxlujAa4PK79p3Yw0hwc+VTqczue6SXzUgBIrjhCPdS0ktMtzQf6eEbjA/3v1jQZr4j4ddZZ3OMhKZWUO3YtIo=
X-Received: by 2002:a19:c384:: with SMTP id t126mr375251lff.100.1574211591000;
 Tue, 19 Nov 2019 16:59:51 -0800 (PST)
MIME-Version: 1.0
References: <20191119142113.15388-1-yuehaibing@huawei.com>
In-Reply-To: <20191119142113.15388-1-yuehaibing@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Nov 2019 16:59:39 -0800
Message-ID: <CAADnVQKzNSC-RgTrbS6LvquR5D51qw4Gr7mpKCp5ADugaZr_aA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Make array_map_mmap static
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 6:21 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warning:
>
> kernel/bpf/arraymap.c:481:5: warning:
>  symbol 'array_map_mmap' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied. Thanks
