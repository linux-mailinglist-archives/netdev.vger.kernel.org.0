Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504936B32D8
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCJAix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCJAiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:38:52 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCECF8678;
        Thu,  9 Mar 2023 16:38:44 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id n18so3775004ybm.10;
        Thu, 09 Mar 2023 16:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678408723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iK7tJXCeBCQ5qxrZr1LoLqlVbX3hpxm0sSYbj+O2+B0=;
        b=fHMaWgjSBoKhKohY9+iX/Os0sZmu724cZwjxeNJ+GV/LAjd67CbiLyNZ2z2+R+kmtb
         vm8zdnve2JBfGI/ZAuDBgT+wGWKiUO6yZxOTmTVv06zK8b00SJzoPHkk0vNM652J2xpV
         zWtDaRPho4DVhCr7iFEAhs5DFi/j9FSA3YKqaQh156RQ5iR3RXS6LSn0CcYdiC3cKbx2
         fJGD4+n+3Kxk8cZecrQPgR5yaCUUqHQkCRI+62DHN0Ix0VfWtVSg+QIWSMa9KajcIFtM
         yvFvwIHt+hAo+Xph8863hCPBp8MhyRK4P5oxkHygO/bK0ZRb117lSpl0NapVC99GjBo7
         rNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678408723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iK7tJXCeBCQ5qxrZr1LoLqlVbX3hpxm0sSYbj+O2+B0=;
        b=Lp6tIUcak8AgdIWwgTUTZWi8cbjQuC3kdhVewXeJ4P/ub2Dtj1ZQrnprK424HcGcE+
         8Yj/8TWYuDowp1zl62WD9aAxCDtgQ4j7sMS+0NDMlYnw33rYOBdDbBTjq4Na+6j8yMAa
         orXyvNHQb2/EpW3wIEV2h6M7AeUg46phEHfR3AIIcubmCMRa0q4oc95zfyNJlUMWa1Tz
         RX+R5H8ZRsnAlFI07cVvo7XztpMRUMI8Z5L9Nab0TZMS4K7ZS8QR7KzLI51B7C5suHBc
         9XBPn2V4dVbx6T4IZNyg/VXXY390Kg39haLnQz0+XyryC6eduO/BgCV64QX4ZQSSyk4J
         6Xsw==
X-Gm-Message-State: AO0yUKXSHvV3G10kIGcbbndqqoXKNb7/4oIzJ+9F21TXGKRCxXVYg/zx
        OVeJwdn3LXxule0Yk0Zaa0zfRXc53MVPiwE2bco=
X-Google-Smtp-Source: AK7set9cDEK4jnyPUsJeoQH5wPSDCbID3qqIghvvcyTpVui0chwxTG5pMV7kBLtwW9iLLFgQ6tgPb3glfgRM3MLIXCo=
X-Received: by 2002:a5b:105:0:b0:9f5:af8a:3c11 with SMTP id
 5-20020a5b0105000000b009f5af8a3c11mr11912188ybx.11.1678408723350; Thu, 09 Mar
 2023 16:38:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1678224012.git.lucien.xin@gmail.com> <3e977ca635d6b8ef8440d5eed2617a4f3a04b15b.1678224012.git.lucien.xin@gmail.com>
 <09cdc1990818a26fd0e3514b7619261ebc0da50f.camel@redhat.com>
In-Reply-To: <09cdc1990818a26fd0e3514b7619261ebc0da50f.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 9 Mar 2023 19:38:15 -0500
Message-ID: <CADvbK_ch9KF7afGFTnYni1QsJ7XYFb2WN97V_650dgWy2Gkyow@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sctp: add fair capacity stream scheduler
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 5:31=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On Tue, 2023-03-07 at 16:23 -0500, Xin Long wrote:
> > diff --git a/net/sctp/stream_sched_fc.c b/net/sctp/stream_sched_fc.c
> > new file mode 100644
> > index 000000000000..b336c2f5486b
> > --- /dev/null
> > +++ b/net/sctp/stream_sched_fc.c
> > @@ -0,0 +1,183 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* SCTP kernel implementation
> > + * (C) Copyright Red Hat Inc. 2022
> > + *
> > + * This file is part of the SCTP kernel implementation
> > + *
> > + * These functions manipulate sctp stream queue/scheduling.
> > + *
> > + * Please send any bug reports or fixes you make to the
> > + * email addresched(es):
> > + *    lksctp developers <linux-sctp@vger.kernel.org>
> > + *
> > + * Written or modified by:
> > + *    Xin Long <lucien.xin@gmail.com>
> > + */
> > +
> > +#include <linux/list.h>
> > +#include <net/sctp/sctp.h>
>
> Note that the above introduces a new compile warning:
>
> ../net/sctp/stream_sched_fc.c: note: in included file (through ../include=
/net/sctp/sctp.h):
> ../include/net/sctp/structs.h:335:41: warning: array of flexible structur=
es
>
> that is not really a fault of the new code, it's due to:
>
>         struct sctp_init_chunk peer_init[];
>
> struct sctp_init_chunk {
>         struct sctp_chunkhdr chunk_hdr;
>         struct sctp_inithdr init_hdr;
> };
>
> struct sctp_inithdr {
>         __be32 init_tag;
>         __be32 a_rwnd;
>         __be16 num_outbound_streams;
>         __be16 num_inbound_streams;
>         __be32 initial_tsn;
>         __u8  params[]; // <- this!
> };
>
> Any chance a future patch could remove the 'params' field from the
> struct included by sctp_init_chunk?
>
> e.g.
>
> struct sctp_inithdr_base {
>         __be32 init_tag;
>         __be32 a_rwnd;
>         __be16 num_outbound_streams;
>         __be16 num_inbound_streams;
>         __be32 initial_tsn;
> };
>
> struct sctp_init_chunk {
>         struct sctp_chunkhdr chunk_hdr;
>         struct sctp_inithdr_base init_hdr;
> };
>
> and then cast 'init_hdr' to 'struct sctp_inithdr' if/where needed.
>
> In any case, the above is not blocking this series.
>
Hi, Paolo,

There are actually quite some warnings like this in SCTP:

# make C=3D1 CF=3D"-Wflexible-array-nested" M=3D./net/sctp/ 2> /tmp/warning=
s
# grep "nested flexible array" /tmp/warnings |grep sctp |sort |uniq

./include/linux/sctp.h:230:29: warning: nested flexible array
./include/linux/sctp.h:278:29: warning: nested flexible array
./include/linux/sctp.h:348:29: warning: nested flexible array
./include/linux/sctp.h:393:29: warning: nested flexible array
./include/linux/sctp.h:451:28: warning: nested flexible array
./include/linux/sctp.h:611:32: warning: nested flexible array
./include/linux/sctp.h:628:33: warning: nested flexible array
./include/linux/sctp.h:675:30: warning: nested flexible array
./include/linux/sctp.h:735:29: warning: nested flexible array
./include/net/sctp/structs.h:1145:41: warning: nested flexible array
./include/net/sctp/structs.h:1588:28: warning: nested flexible array
./include/net/sctp/structs.h:343:28: warning: nested flexible array
./include/uapi/linux/sctp.h:641:34: warning: nested flexible array
./include/uapi/linux/sctp.h:643:34: warning: nested flexible array
./include/uapi/linux/sctp.h:644:33: warning: nested flexible array
./include/uapi/linux/sctp.h:650:40: warning: nested flexible array
./include/uapi/linux/sctp.h:653:39: warning: nested flexible array

Other than the uapis, I can try to give others a cleanup by deleting
these flexible array members and casting it by (struct xxx *) (hdr + 1)
when accessing it.

This warning is reported if a structure having a flexible array member is
included by other structures, and I also noticed there is the same problem
on some core structures like:

struct ip_options
struct nft_set_ext

which are included in many other structures, and can also cause such warnin=
gs.
I guess we'll just leave it as it is, right?

Thanks.
