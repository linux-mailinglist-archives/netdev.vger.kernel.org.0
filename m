Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103A9300060
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbhAVK0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:26:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727626AbhAVJeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:34:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611307972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xZnuatSgLpQGoR06zuojtkToZnjixX0n8huY2zeyF+I=;
        b=RsRUsDQrGWlc0VeNeIK8swGTZFiJncG59TQEcx4WBGdnY5TJihqH+x7zSt0fgv2vHHvuk3
        yP9jHVNbGapQiAVBnd46a6IDB+qRiq/c4gT6KLdFayUkrQIL/4fKnKV4XmWoQMgi3sXMEL
        3A6nkJtAjkt3QMfzIuJRzwtEgcFYhTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-ZdVXmGXkN6eS0IqFZpK5Mg-1; Fri, 22 Jan 2021 04:32:48 -0500
X-MC-Unique: ZdVXmGXkN6eS0IqFZpK5Mg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32E0A59;
        Fri, 22 Jan 2021 09:32:46 +0000 (UTC)
Received: from krava (unknown [10.40.195.32])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0BCA760BF3;
        Fri, 22 Jan 2021 09:32:35 +0000 (UTC)
Date:   Fri, 22 Jan 2021 10:32:34 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210122093234.GA35850@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
 <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:
> On Thu, Jan 21, 2021 at 12:25 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > For very large ELF objects (with many sections), we could
> > get special value SHN_XINDEX (65535) for symbol's st_shndx.
> >
> > This patch is adding code to detect the optional extended
> > section index table and use it to resolve symbol's section
> > index.
> >
> > Adding elf_symtab__for_each_symbol_index macro that returns
> > symbol's section index and usign it in collect_symbols function.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> You missed fixing up collect_function() as well, which is using
> elf_sym__section(), which doesn't know about extended numbering.

ah right, it's for modules, I guess it's why it did not show up

thanks,
jirka

