Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5D157243
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 10:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgBJJ7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 04:59:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32794 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgBJJ7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 04:59:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so6835943wrt.0
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 01:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kfdFxRlP+TMK7CgIbUcstIHGZH0w34dTTNNCY8oMeFc=;
        b=kYlX32XWTJOlSvvxY3CD10rBLglj0+evxRZutAADNeUZdSQ6rKbOcZop8LsSZoZ+bX
         253+/tBUoxcMOuK/YOnK52yOFLyX+mkoXUW9ec2oXNKM1DBzKm7y/Nim86OZMXrLwawu
         JN7LHOW7Ni9M/R3TW1MP2ycpgqbV43GnRyEG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=kfdFxRlP+TMK7CgIbUcstIHGZH0w34dTTNNCY8oMeFc=;
        b=RkCE97kDa3ObwkFu7movIAz+vRDD9YaPO2G+mC4aLfTaOZihXes2mJEkPKWD5pEduz
         r+Chj6jTJzZXQZmKVwAyThnltBtWvF6wBkY6HRbgAG+esPQ2PZsJQ3AXAFLiGijjCFrr
         8J2A3qlzuIuu2Du0F6RoZ6/yur4bDufiGoW5QKICVLvNhap6heW80jhywkcAY5VucEHS
         J317bzK0/HFGTmLtAKxnlBn8VZdQ3iICPgpvip+2mreTmt+s92F/iXrnHYv6lVukWqlu
         WzE3/jNvksqBtc477V6MJO+smR8lTEpAVgNyU5Qmc8lni5v9AHALUK/CN4Qwu4exdF3Z
         QITA==
X-Gm-Message-State: APjAAAWDQz0zKojelQLiIVOoQ2VGDnNTwmU2XCpl1PMpTTRlcj5zWhqd
        ShrFp44rFwH8jZFS7wkU8mS+ug==
X-Google-Smtp-Source: APXvYqybXg81Fw56ANOv2rgQ4Sz8b23jypwCHMuRwirRGk3swWkYQja0ERv/SU0s935UoPFjBz4Wzw==
X-Received: by 2002:adf:81e3:: with SMTP id 90mr1003706wra.23.1581328791911;
        Mon, 10 Feb 2020 01:59:51 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id c9sm15406594wrq.44.2020.02.10.01.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 01:59:51 -0800 (PST)
References: <158131347731.21414.12120493483848386652.stgit@john-Precision-5820-Tower>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH] bpf: selftests build error in sockmap_basic.c
In-reply-to: <158131347731.21414.12120493483848386652.stgit@john-Precision-5820-Tower>
Date:   Mon, 10 Feb 2020 09:59:50 +0000
Message-ID: <87d0amahk9.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 05:44 AM GMT, John Fastabend wrote:
> Fix following build error. We could push a tcp.h header into one of the
> include paths, but I think its easy enough to simply pull in the three
> defines we need here. If we end up using more of tcp.h at some point
> we can pull it in later.
>
> /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c=
: In function =E2=80=98connected_socket_v4=E2=80=99:
> /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c=
:20:11: error: =E2=80=98TCP_REPAIR_ON=E2=80=99 undeclared (first use in thi=
s function)
>   repair =3D TCP_REPAIR_ON;
>            ^
> /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c=
:20:11: note: each undeclared identifier is reported only once for each fun=
ction it appears in
> /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c=
:29:11: error: =E2=80=98TCP_REPAIR_OFF_NO_WP=E2=80=99 undeclared (first use=
 in this function)
>   repair =3D TCP_REPAIR_OFF_NO_WP;
>
> Then with fix,
>
> $ ./test_progs -n 44
> #44/1 sockmap create_update_free:OK
> #44/2 sockhash create_update_free:OK
> #44 sockmap_basic:OK
>
> Fixes: 5d3919a953c3c ("selftests/bpf: Test freeing sockmap/sockhash with =
a socket in it")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_basic.c       |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/too=
ls/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index 07f5b46..aa43e0b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -3,6 +3,11 @@
>
>  #include "test_progs.h"
>
> +#define TCP_REPAIR		19	/* TCP sock is under repair right now */
> +
> +#define TCP_REPAIR_ON		1
> +#define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
> +
>  static int connected_socket_v4(void)
>  {
>  	struct sockaddr_in addr =3D {

Neat, I haven't thought of that. Thank you for fixing up my mistake.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
