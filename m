Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0167E3A16F3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhFIOVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:21:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234221AbhFIOV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623248373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmD730iRSU6aUNsHZzCL77C0ovVNCiGac/cSq4aisgE=;
        b=Vnr9hGOyfxgeNYx5hSE5CIuCUO50rwPUal/d6uA1vxJNwbPjijxOTUuTFJjV3XLW10p/Ms
        Dt98VZd2P5Rsg5NFBJ9ES6XA8gEyU5MHuQht4GUoXOYc5cL9euVADY769/9NHG1BYa+e/q
        VACjtx7o4lSFC579tCmcfKI24MRyAAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-qSjCf0m1NeWyJai4VScf5A-1; Wed, 09 Jun 2021 10:19:29 -0400
X-MC-Unique: qSjCf0m1NeWyJai4VScf5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACB7E802575;
        Wed,  9 Jun 2021 14:19:27 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id C02D29CA0;
        Wed,  9 Jun 2021 14:19:24 +0000 (UTC)
Date:   Wed, 9 Jun 2021 16:19:23 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 14/19] libbpf: Add btf__find_by_pattern_kind function
Message-ID: <YMDN6z23lbxfiYyi@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-15-jolsa@kernel.org>
 <CAEf4BzaT9eiyMrpKbmmq3hOpD29b8K6DiRzB0eRKnTso93YRoA@mail.gmail.com>
 <YMDJT4fnLCOsfFuS@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMDJT4fnLCOsfFuS@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 03:59:47PM +0200, Jiri Olsa wrote:

SNIP

> > > +
> > > +       /* When the pattern does not start with wildcard, treat it as
> > > +        * if we'd want to match it from the beginning of the string.
> > > +        */
> > 
> > This assumption is absolutely atrocious. If we say it's regexp, then
> > it has to always be regexp, not something based on some random
> > heuristic based on the first character.
> > 
> > Taking a step back, though. Do we really need to provide this API? Why
> > applications can't implement it on their own, given regexp
> > functionality is provided by libc. Which I didn't know, actually, so
> > that's pretty nice, assuming that it's also available in more minimal
> > implementations like musl.
> > 
> 
> so the only purpose for this function is to support wildcards in
> tests like:
> 
>   SEC("fentry.multi/bpf_fentry_test*")
> 
> so the generic skeleton attach function can work.. but that can be
> removed and the test programs can be attached manually through some
> other attach function that will have list of functions as argument

nah, no other attach function is needed, we have that support now in
link_create ready to use ;-) sry

jirka

