Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF44171345
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgB0IuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:50:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728933AbgB0IuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582793416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1nyeIRe0NrbrLrsRG5PNzKkePAtGFT/fpceGBxaKfv4=;
        b=ixLdfVbu+SsPkdBKgIrKFhHpw7m9Ngy2sXDUwl4xkhSSWoOS1AS+4UngpUdJbrr4gLPuvW
        +au23EbxTVSi/ltPSzJyNBBy+xbXH5EzJAn4UxPORLnsiEjVfZJl1WOX/Y1YSNdmcdeRpe
        4LAKVbroVw+oXkWxcdFvYbzqaCIPOKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435--LypJKN-NSOJBatdsnhItQ-1; Thu, 27 Feb 2020 03:50:12 -0500
X-MC-Unique: -LypJKN-NSOJBatdsnhItQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C17E218B9FC1;
        Thu, 27 Feb 2020 08:50:09 +0000 (UTC)
Received: from krava (ovpn-204-93.brq.redhat.com [10.40.204.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E225C545;
        Thu, 27 Feb 2020 08:50:05 +0000 (UTC)
Date:   Thu, 27 Feb 2020 09:50:02 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 04/18] bpf: Add name to struct bpf_ksym
Message-ID: <20200227085002.GC34774@krava>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-5-jolsa@kernel.org>
 <CAPhsuW5u=6MEWKU4-Cfdr3VfYn+NuTgX6SezC_W33WZsM3j8ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW5u=6MEWKU4-Cfdr3VfYn+NuTgX6SezC_W33WZsM3j8ng@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 01:14:43PM -0800, Song Liu wrote:
> On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding name to 'struct bpf_ksym' object to carry the name
> > of the symbol for bpf_prog, bpf_trampoline, bpf_dispatcher.
> >
> > The current benefit is that name is now generated only when
> > the symbol is added to the list, so we don't need to generate
> > it every time it's accessed.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> The patch looks good. But I wonder whether we want pay the cost of
> extra 128 bytes per bpf program. Maybe make it a pointer and only
> generate the string when it is first used?

I thought 128 would not be that bad, also the code is quite
simple because of that.. if that's really a concern I could
make the changes, but that would probably mean changing the
design

jirka

