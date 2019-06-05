Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D495364D7
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 21:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfFEThH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 15:37:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33451 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEThG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 15:37:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id 14so19454047qtf.0;
        Wed, 05 Jun 2019 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2csJP2e8mT2YZIAsKNMmzTnJtLz0nsfolBkD/FQ0NM=;
        b=iNXoPmjllI2/CbhIrRsJHG8jG71wQBxSAfnaOyDnT60rEsaUMvW4f2k91xQ4XWIdwC
         Pm8i3V7NI4ynV+7ThzEN/bQG6dRXwBu8HWxm4KgCHvXdxm2JGDjVv10rGuOQNSMKLvld
         T5bm8j+sYOoBio994RCOeI2lrTUBnLVTA/wmqp0sO25fY+FAE30GFF+tSVNlsoZlH2/2
         qhjojyuQjL7qtOJ16BA4aDRB+T7IFnaK4IBsaTjwTLshCovTfnLTCXJlv7hTpQnd0WLt
         Q+Z8pMLnPOm5kGo/12ntVIQ0QSuDior4Mb1OvxNZW3NQhFN1aVkiwTdqXlhbcocqs5pU
         yFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2csJP2e8mT2YZIAsKNMmzTnJtLz0nsfolBkD/FQ0NM=;
        b=BEa43mN8TbuOG5zncDHEI+tO2x1UDUo/Ny7bmcZHIpxlc8pxhku5vBWVHLEk/N+L8t
         fSBGXx3Q+QRah6UWay6qU831sB44Bb8unrLgkJ0vUIdLz2qlOiRw4MgHoilc2jj9H/xd
         uEOKMd0HGmxl2FnettwMohwavUnygcQ9/fIW9N8Haw6AF+mJHsnKFuDHfwqq2DQzhiCh
         aWmXu44v4SxBcF6sUgJ/hmJ99/jhGHD/mMAkj6Nnk8D/ds/sfWPsWOHD/gcZ2JwCV9JU
         e1LgOekDPvJ6+IbzzSYJfYn3TbieKZLknQ+6k1E04lSDPSXO6Q2k6B0r75dIolB/HFhz
         jOmA==
X-Gm-Message-State: APjAAAV4pJztrcLX2eAITXt3LfrwByxrJKk2Jxvaq1Vzi70K1svZDMJ0
        EOkxVb3XVYHrWs7NAUz2Andl5KQQPxDeWrK0qW0=
X-Google-Smtp-Source: APXvYqzwXd5uLGh2CZqKB9dUHEats+uYz9LtoxSTgwyhTvw7ooC6Liz3aa7R40tQxs4RPSH9v+WOukKDMKWx2vf72Lo=
X-Received: by 2002:a0c:95af:: with SMTP id s44mr7864192qvs.162.1559763425613;
 Wed, 05 Jun 2019 12:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190605191707.24429-1-krzesimir@kinvolk.io>
In-Reply-To: <20190605191707.24429-1-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jun 2019 12:36:54 -0700
Message-ID: <CAEf4BzYUg+FbBfCe-DTLrrT07ifK49NRFhLWye+Ej1JiFYwioQ@mail.gmail.com>
Subject: Re: [BPF v1] tools: bpftool: Fix JSON output when lookup fails
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     bpf <bpf@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        Okash Khawaja <osk@fb.com>,
        David Calavera <david.calavera@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 12:18 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> In commit 9a5ab8bf1d6d ("tools: bpftool: turn err() and info() macros
> into functions") one case of error reporting was special cased, so it
> could report a lookup error for a specific key when dumping the map
> element. What the code forgot to do is to wrap the key and value keys
> into a JSON object, so an example output of pretty JSON dump of a
> sockhash map (which does not support looking up its values) is:
>
> [
>     "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x00"
>     ],
>     "value": {
>         "error": "Operation not supported"
>     },
>     "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x01"
>     ],
>     "value": {
>         "error": "Operation not supported"
>     }
> ]
>
> Note the key-value pairs inside the toplevel array. They should be
> wrapped inside a JSON object, otherwise it is an invalid JSON. This
> commit fixes this, so the output now is:
>
> [{
>         "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x00"
>         ],
>         "value": {
>             "error": "Operation not supported"
>         }
>     },{
>         "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x01"
>         ],
>         "value": {
>             "error": "Operation not supported"
>         }
>     }
> ]
>
> Fixes: 9a5ab8bf1d6d ("tools: bpftool: turn err() and info() macros into functions")
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/map.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index 3ec82904ccec..5da5a7311f13 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -716,12 +716,14 @@ static int dump_map_elem(int fd, void *key, void *value,
>                 return 0;
>
>         if (json_output) {
> +               jsonw_start_object(json_wtr);
>                 jsonw_name(json_wtr, "key");
>                 print_hex_data_json(key, map_info->key_size);
>                 jsonw_name(json_wtr, "value");
>                 jsonw_start_object(json_wtr);
>                 jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
>                 jsonw_end_object(json_wtr);
> +               jsonw_end_object(json_wtr);
>         } else {
>                 const char *msg = NULL;
>
> --
> 2.20.1
>
