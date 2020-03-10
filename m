Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F641800E4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCJO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 10:57:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20807 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726295AbgCJO5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 10:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583852267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AbmGY4uz7W9+Z2kdlkADDdu9vVPFoM0fkBHCcTPirjk=;
        b=ZFRl5pGx+77fGLwr8CK01d4hqb6a4kRvIpt/MD757mglvgNesFDY6U/0zRL56jlr8S2Kj9
        v+a77S+knZiYJtH6dMqC+Um/zgLvmjMGhmqL8CV/yRBntheduA9g764F0YsXjhGbudfKMX
        jGu4dTsSkkIa2GifhcsDvuGigIhw0oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-2Fjo-U2XN56No1qPbAI7eg-1; Tue, 10 Mar 2020 10:57:45 -0400
X-MC-Unique: 2Fjo-U2XN56No1qPbAI7eg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80CA0107ACC7;
        Tue, 10 Mar 2020 14:57:41 +0000 (UTC)
Received: from krava (ovpn-204-223.brq.redhat.com [10.40.204.223])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28A7F8F35E;
        Tue, 10 Mar 2020 14:57:34 +0000 (UTC)
Date:   Tue, 10 Mar 2020 15:57:17 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>, Cestmir Kalina <ckalina@redhat.com>
Subject: Re: libbpf distro packaging
Message-ID: <20200310145717.GB167617@krava>
References: <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
 <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
 <20191016100145.GA15580@krava>
 <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com>
 <20191220135811.GF17348@krava>
 <c1b6a5b1-bbc8-2186-edcf-4c4780c6f836@fb.com>
 <20200305141812.GH168640@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305141812.GH168640@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 03:18:12PM +0100, Jiri Olsa wrote:
> On Wed, Mar 04, 2020 at 04:22:35PM -0800, Julia Kartseva wrote:
> > 
> > 
> > On 12/20/19 5:58 AM, Jiri Olsa wrote:
> > > On Thu, Dec 19, 2019 at 09:37:23PM +0000, Julia Kartseva wrote:
> > >> Hi Jiri,
> > >>
> > >> 1. v. 0.0.6 is out [1], could you please package it?
> > >> 2. we might need a small spec update due to zlib is made an explicit
> > >> dependency in [2]. zlib should be listed in BuildRequires: section of the
> > >> spec so it's consistent with libbpf.pc
> > > 
> > > sure, it's ok for rawhide, in fedora 31/30 we still don't have
> > > latest headers packaged
> > > 
> > >> 3. Do you plan to address the bug report [3] for CentOS? Namely rebuilding
> > >> Fedora's RPM and publishing to EPEL repo?
> > > 
> > > I did not get any answers on who would do that internally,
> > > so I'm afreaid I'll have to do it, but let me ask again first ;-)
> > >
> > 
> > Bump :)
> > Jiri, any volunteers for Fedora EPEL 7|8 packaging?
> > systemd folks would appreciate it.
> > Thanks!
> 
> hi,
> yep.. we've got Cestmir as 'volunteer' for that (cc-ed) ;-) I can see
> there's already epel8 branch for libbpf created.. but not sure what's
> the actual rpm status

so I did some more checking and libbpf is automatically pulled into
centos 8, it's just at the moment there's some bug preventing that.. 
it is going to be fixed shortly ;-)

as for centos 7, what is the target user there? which version of libbpf
would you need in there?

jirka

