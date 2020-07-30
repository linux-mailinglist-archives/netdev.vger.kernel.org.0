Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1D233015
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgG3KJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:09:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726946AbgG3KJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 06:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596103795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OkLwVoR4eojoQKNFkbEPIflQsN604MO7LrgpXTR0n6s=;
        b=NxZt+mgWH5LorzDetN3crCGM7Fe0mf/C1xiZfSAC8ygIlaLNrX1fQaBhTJITS9boZ3UVAQ
        i/qlxYC+s8XtOBHdCnvCWx3J7j26lRJSrxmcCduiMz107F1pNip4tTmAAK3PI9Rgi4hGTV
        jDh0ZmHN9uSFPnWe9+ozrf8b7fgGJQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-rL9NMs9UM1SqJqYxIqimZg-1; Thu, 30 Jul 2020 06:09:51 -0400
X-MC-Unique: rL9NMs9UM1SqJqYxIqimZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90041102C7ED;
        Thu, 30 Jul 2020 10:09:49 +0000 (UTC)
Received: from krava (unknown [10.40.194.223])
        by smtp.corp.redhat.com (Postfix) with SMTP id C606E87B0A;
        Thu, 30 Jul 2020 10:09:45 +0000 (UTC)
Date:   Thu, 30 Jul 2020 12:09:45 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>
Subject: Re: [PATCH v8 bpf-next 09/13] bpf: Add d_path helper
Message-ID: <20200730100945.GQ1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-10-jolsa@kernel.org>
 <20200729201740.GB1233513@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729201740.GB1233513@ZenIV.linux.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 09:17:40PM +0100, Al Viro wrote:
> On Wed, Jul 22, 2020 at 11:12:19PM +0200, Jiri Olsa wrote:
> 
> > +BTF_SET_START(btf_whitelist_d_path)
> > +BTF_ID(func, vfs_truncate)
> > +BTF_ID(func, vfs_fallocate)
> > +BTF_ID(func, dentry_open)
> > +BTF_ID(func, vfs_getattr)
> > +BTF_ID(func, filp_close)
> > +BTF_SET_END(btf_whitelist_d_path)
> 
> While we are at it, I hope you realize that the names of kernel function
> are subject to change at zero notice.  If some script breaks since
> we give e.g. filp_close a something less revolting name, it's Not My
> Problem(tm)...

even now when we change function name some scripts will stop working,
so I don't think we are creating new problem in here

thanks,
jirka

