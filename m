Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D857410B3A8
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfK0Qlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:41:52 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34499 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfK0Qlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:41:52 -0500
Received: by mail-lf1-f67.google.com with SMTP id l28so17740403lfj.1;
        Wed, 27 Nov 2019 08:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/eWB2rCOMmX423AOdl9mozQ2GWqfxXSdgs//MzFs0+M=;
        b=PjE0Rhyu81sYgLylgpTP49Qm6RDM7316CZq2qBpmlkMeVqPvRDx9xTAXQ6It4gyTeu
         lxSoKlhqE6pHkozHig5mrPioaniP7qIlGkIFuvYjnFNniKEkuFYdSKB0atDKQlKJpwoh
         AXbCs/Sfsgdrkg+FtSDwONO3995AlcHgtz1y6y6hqEOhp0EMIIlxDv5A2t8u4tdjk9q1
         DRt33TLffLnmsvO7Iz9pWafhEQs+5gkgpMqoqZzCLLR+Bu6tCwIvakF0eZKyU7Hbaj/l
         jYuOHipQnrz5S1LPjDLmEAbG5N8zh+UpFJs2losfuj0/y/qm5GR6db4/Ozi/sV5Rb2lD
         /2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/eWB2rCOMmX423AOdl9mozQ2GWqfxXSdgs//MzFs0+M=;
        b=AryOIlaAsuYHmXtwQY43nU0/6s/k2Uody/DBdfyscBCely1Btni3TkTWQruIzNbGu6
         zfqYQxMTdDx3hkZ/xnPO8O3h+FL+0hGJn+QhigyRH2s9n/r5r/RtjSjvFcOUc9YuzLrd
         +tyho4R5e0wNKF3J+i/j/N66zxpNrzkA4o+qIZtZ+P57ilT+kBcBUhyKewvOVvcYwelh
         W5xjX9VBHZvq+G+yEcOopPjbeVMY2aj61yeAcIg3vsM0YrNiqokqY4bnZGO1SD5qeVSI
         ePe6KOup9X5HHue3+UAKJpgoCOiWV7MoAOxJP3lq5n1oAVVC6H9FTNKWm+5Vk6J1qFUy
         0ekg==
X-Gm-Message-State: APjAAAWfU+7/tG2bLAhnQ8zq7QFVeJKaEH04OzjyveVYxEJ2wcdgOHBf
        xDTuf679pah4HPKNHYQRrcma5x9tCq76I/8UcHs=
X-Google-Smtp-Source: APXvYqw8XiZzJsCr/3/6hFAt3SNZuHFa9l5qi3WPi3It1HEt6ojoVz3oyCyzHungjh9pEXPIuP3Kr9yU76HqJGqBPK0=
X-Received: by 2002:ac2:5462:: with SMTP id e2mr19863175lfn.181.1574872908250;
 Wed, 27 Nov 2019 08:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20191127094837.4045-1-jolsa@kernel.org> <20191127094837.4045-4-jolsa@kernel.org>
In-Reply-To: <20191127094837.4045-4-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 08:41:36 -0800
Message-ID: <CAADnVQ+04C7BCH+UCMXLuHoP3vWcKmmycaZa-bMJDSFBUddo1g@mail.gmail.com>
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> diff --git a/tools/build/feature/test-libbpf.c b/tools/build/feature/test-libbpf.c
> index a508756cf4cc..93566d105a64 100644
> --- a/tools/build/feature/test-libbpf.c
> +++ b/tools/build/feature/test-libbpf.c
> @@ -3,5 +3,14 @@
>
>  int main(void)
>  {
> +#ifdef BPFTOOL
> +       /*
> +        * libbpf_netlink_open (LIBBPF_0.0.6) is the latest
> +        * we need for bpftool at the moment
> +        */
> +       libbpf_netlink_open(NULL);
> +       return 0;
> +#else
>         return bpf_object__open("test") ? 0 : -1;
> +#endif

Such hack should be a clear sign that it's not appropriate for libbpf to
be public netlink api library. Few functions that it already has are for
libbpf and bpftool internal usage only.
