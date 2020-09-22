Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6396F2738ED
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgIVCyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgIVCx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 22:53:59 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9C8C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:53:59 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t13so15862357ile.9
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q5qFSNvUXZq+cK8xZChHWgOndBKOPeC3BQz4BQj4KVI=;
        b=RrjIwWUPgjZaX7GJ2s3e9W61YlIb7Wj+fjjhkM6yjx6EqYpIXoN5KdmbndAt6Z1k0V
         CXwTo9QvGH0mdQMNC31w7wrv+ZjSOuzwIMX7aMOQF4Ukbz29ItXwjGvl0DBUyEM2HuKi
         urXrOE5zAFkIpLwjj9bBg6w8cgDxLKTa6rD3I5J/e2SKq/NB5LZwzjw8T3N9qvkkGttC
         CYxpO57lCKMgae/yRl2cW+IQS3pBxM1w5dS5PYVsRqPcxEMDxy4CfedzVHx1h2ERN5ZW
         KJlOKVwTepTd1JucRcj3kzcAm+aljh+euLLfAwDviyo8UhNXxCUCDlGdiY/OA+M8r0mj
         BxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q5qFSNvUXZq+cK8xZChHWgOndBKOPeC3BQz4BQj4KVI=;
        b=aCDomLYK8hvCoXyKB4IvEXJJoWu3F2Jsb/fOYl50mAzcQFlA35IVQQUCA9EYGIjpmx
         UOZ5MVhZv95UteH1dHb8yvjAP98hzCEHpPERDphk3PMDmhsCujE7s1rr6Lw72CenU5s2
         vXDz+YRJWxk9jQ+87S+SZyGPbIlDgNluWuPmjJLK4S/xaeREvJOr4ieFHZ2aLMvDsaqz
         jBEwCV3fITKPHR8FW4yZbVGSYeCUFTt0FACo6EWPRM+3W4mDKAMRYtZNiuF0Bw7pPOGD
         oidJDHXl05dKj6oz8VKV8nCSCzuBO60Nx431g8DfDfGx6OYu51iAiuLKh/8ig8ejMGEO
         UZXg==
X-Gm-Message-State: AOAM533th7O3IU0TD86zrwLuffaqPvTfTMPyPEe1ETxbPgYheFflQg9N
        HhFecpGjtmcUW3hHzxDfyfBaxTLyGBi62e9IeNJjpLkDGYI=
X-Google-Smtp-Source: ABdhPJzpxzEF+KH/UXFyf76mMXKCciEDC/x2xNnhXPJVMcXtxnSXkxWRRJYTBYobgIhNnRwe0LZKogKtbCqb5St7J58=
X-Received: by 2002:a05:6e02:1411:: with SMTP id n17mr2539558ilo.211.1600743238824;
 Mon, 21 Sep 2020 19:53:58 -0700 (PDT)
MIME-Version: 1.0
References: <1600707762-24422-1-git-send-email-sundeep.lkml@gmail.com>
 <1600707762-24422-2-git-send-email-sundeep.lkml@gmail.com> <20200921161821.60c16a30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921161821.60c16a30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Tue, 22 Sep 2020 08:23:47 +0530
Message-ID: <CALHRZup3CU1O-pDTFO=jkXkHUC8191ovqYmJanhd0_na7ccRYw@mail.gmail.com>
Subject: Re: [net-next v2 PATCH 1/2] octeontx2-af: Introduce tracepoints for mailbox
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Sep 22, 2020 at 4:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 21 Sep 2020 22:32:41 +0530 sundeep.lkml@gmail.com wrote:
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
> > new file mode 100644
> > index 0000000..f0b3f17
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
> > @@ -0,0 +1,14 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Marvell OcteonTx2 RVU Admin Function driver tracepoints
> > + *
> > + * Copyright (C) 2020 Marvell International Ltd.
> > + */
> > +
> > +#define CREATE_TRACE_POINTS
> > +#include "rvu_trace.h"
> > +
> > +EXPORT_TRACEPOINT_SYMBOL(otx2_msg_alloc);
> > +EXPORT_TRACEPOINT_SYMBOL(otx2_msg_send);
> > +EXPORT_TRACEPOINT_SYMBOL(otx2_msg_check);
>
> I don't think you need to export send and check.
>
> They are only used in the mbox module where they are defined.
>
Agreed. I will remove those and send the next spin.

> Otherwise looks acceptable to me.
>
Thanks

> Please make sure you CC everyone who gave you feedback.
Sure.

Sundeep
