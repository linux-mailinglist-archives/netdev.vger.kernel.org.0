Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD7E2CFAB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfE1Tk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:40:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42043 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfE1Tk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:40:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id r22so9233413pfh.9;
        Tue, 28 May 2019 12:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=93NiWg88plww3BEzYyn0ICvR5hG8lZfHE/HYRcLE7m8=;
        b=uPvok+oSTNyhB8lNqKartxqkRHCvLIVBjUAU/WAo1chSRW/lAL/BhXriszd23uypGv
         LJL6lOqwCBI0M5yd3oVt1fitkvExyvZsF/XXSQXZO3EqSqSSRmHkVfAyu6usLmOzpFt0
         /X00PXHarOpSuBzi8Rvg94s/lmKQNjgheEHMuxepkoxoXm2nRe40bUdwi9f1rTm6MRWA
         AKtvqdZLhKH6iRWAJafmYmhb3qmu2IsA+af/SLQoWpqc1aqvKhsQQaj29stpxQnTb/1x
         LVD4wotFH+F4t0PX/FHFO8HYimz3TXTt6C7w+2xtmG7I8y37DgaoMS34HG/xMYPBpvvr
         B1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=93NiWg88plww3BEzYyn0ICvR5hG8lZfHE/HYRcLE7m8=;
        b=OptsLzT+w/qBvF3pHvkReFdZHUOBiPgbcik9hV875q62hiHadTQ68eThLUUfUCaeUo
         AYZcilmcHj0oSNrM/Qv7qbOwPyfYGRtoSvlFazDvProMT6oN3R/3TUHLQiaZmrPH8glW
         jlGhYJ+XwOT4MQiwkRBA4C/Y18ZrDpB7ADLY+x1zOZ2Y4o2neGaJ6rQkgdkzHSCkMv+1
         cS5WSz0aPyLxdq7oBfNlGVYMhg6QSClGwY7NXPhVaiLxUPTpo1wTmMnBH2aoeMAMgVUp
         WRZOaYWZEa8cB2b9YGAfUbBCQDhawdZC3I0UtBAZTU5noDKLEVUpaaimlvrQUI9br0Xv
         HWSA==
X-Gm-Message-State: APjAAAUN/SheOcpOBtSSPPYX3OKbzIQytxz/LqNPN8Z4mehAKgXGoxQJ
        wrjZhptzvK6GeDrefR8/pDM=
X-Google-Smtp-Source: APXvYqwtgsrbCEG18fVm8Gokp3KisI3vELC3eMLPrjdBKmLgj/BK318YYXTdUiZvuDF4qitzAzXdtw==
X-Received: by 2002:a63:e616:: with SMTP id g22mr69232791pgh.61.1559072455122;
        Tue, 28 May 2019 12:40:55 -0700 (PDT)
Received: from ip-172-31-44-144.us-west-2.compute.internal (ec2-54-186-128-88.us-west-2.compute.amazonaws.com. [54.186.128.88])
        by smtp.gmail.com with ESMTPSA id u20sm16266834pfm.145.2019.05.28.12.40.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 12:40:53 -0700 (PDT)
Date:   Tue, 28 May 2019 19:40:51 +0000
From:   Alakesh Haloi <alakesh.haloi@gmail.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests: bpf: fix compiler warning
Message-ID: <20190528194051.GA7103@ip-172-31-44-144.us-west-2.compute.internal>
References: <20190524003038.GA69487@ip-172-31-44-144.us-west-2.compute.internal>
 <CAPhsuW7H=w_UMyu5Q5p5+MGogkQ7+7X7sS=vJTiR=+JJy0KuTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7H=w_UMyu5Q5p5+MGogkQ7+7X7sS=vJTiR=+JJy0KuTg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 09:45:14AM -0700, Song Liu wrote:
> On Thu, May 23, 2019 at 5:31 PM Alakesh Haloi <alakesh.haloi@gmail.com> wrote:
> >
> > Add missing header file following compiler warning
> >
> > prog_tests/flow_dissector.c: In function ‘tx_tap’:
> > prog_tests/flow_dissector.c:175:9: warning: implicit declaration of function ‘writev’; did you mean ‘write’? [-Wimplicit-function-declaration]
> >   return writev(fd, iov, ARRAY_SIZE(iov));
> >          ^~~~~~
> >          write
> >
> > Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
> 
> The patch looks good. Please add a "Fixes" tag, so the fix
> can be back ported properly.
> 
> Also, please specify which tree the patch should be applied
> with [PATCH bpf] or [PATCH bpf-next].
> 
> Thanks,
> Song
> 

Thanks for reviewing the patch. My apologies for not following the
rules. I have sent an updated patch after adding Fixes: tag and
modifying the subject to reflect that it is for bpf tree.
The updated patch is here https://lkml.org/lkml/2019/5/28/904

Thanks
Alakesh
> 
> 
> 
> > ---
> >  tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > index fbd1d88a6095..c938283ac232 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > @@ -3,6 +3,7 @@
> >  #include <error.h>
> >  #include <linux/if.h>
> >  #include <linux/if_tun.h>
> > +#include <sys/uio.h>
> >
> >  #define CHECK_FLOW_KEYS(desc, got, expected)                           \
> >         CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) != 0,           \
> > --
> > 2.17.1
> >
