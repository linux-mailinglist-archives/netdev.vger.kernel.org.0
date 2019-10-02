Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D99C9108
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfJBSnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:43:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35083 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:43:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id a24so11217pgj.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pCA1zsfhqRQDYfOGVH0/pWMPdPdoB56jzYQZcM4/ftw=;
        b=KsFhcSiFLUvRYrbfsMSOpwWNlqaA+mmBd8SRVooTHQv/YKDs1pe9oEQxvheL7znBSp
         XjhSMmIPsUJKYvinxHL4XhtYEsqHHukdtDJNyJU86EElhpFbvCDVJuM6nVjsGz6Ea+oy
         t9j3wsIMf3spwy+4Lwu02ibzMMnINQAFzuQ6vrQvWQlHqxfNQgAsvfsRof7HjKyfxxNd
         dNlVqvge51J8xy9CK5fOjVZ1DvqxMyvAFyfXPB+9At2rFxnzwhKWkOSe/QRxK7z7zho6
         OvJovXV2sKkE91Afay4HSzWWZrVpSwp+FGA3krzPIR+WyRqLDF8GyEj5gJ6ete1+npHo
         S9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pCA1zsfhqRQDYfOGVH0/pWMPdPdoB56jzYQZcM4/ftw=;
        b=O7hdIADI2InFr2BuoEjbnyIvnYZBZH5whiE4Ilp2yhLZ4dEnH+6PVH9Li8UFwRajpl
         50/zLkS0gaPdbeXtKNUUgPezwZqOv+HsIIae0dqUQKwiVJh4smgVpszHenCGd4e1xWSF
         ZXGHfEmHRRlMqcFkSvpGuaGgZ/XY7YgshEPuywjC0ho9Tg/YHLprexIYNezQViz2zLkw
         yAeZbtJ7siXJPn71qqZ/AjPoyK2C805rbe1Dls7IA1FZA+uaT6GzhFaPyuEG7Djm9lZl
         mfwV+yDqoDa3w2hbBjnnU4qwPmMFMBzuP5mkd69fDZ7oLLkBoyKFFt9dPDkUo7G6O3LW
         pQfQ==
X-Gm-Message-State: APjAAAUoEsLH+fRQzUEgZ8Hq/dfdFRPpZP7hMnZZ5EryJeVGjta/twA9
        ykQf9YYYGNEkCLp/NDYGFxk=
X-Google-Smtp-Source: APXvYqyeyjnM5QxNpouJ2NDBoKSxv41r+6cy+bt/LATWv7PZy+K6IOUMmkvMyOyryyZxJ5cNoTMjdQ==
X-Received: by 2002:a17:90a:d202:: with SMTP id o2mr5744017pju.54.1570041800034;
        Wed, 02 Oct 2019 11:43:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:2790])
        by smtp.gmail.com with ESMTPSA id a23sm99524pgd.83.2019.10.02.11.43.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 11:43:19 -0700 (PDT)
Date:   Wed, 2 Oct 2019 11:43:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Julia Kartseva <hex@fb.com>, Yonghong Song <yhs@fb.com>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "md@linux.it" <md@linux.it>, Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        iovisor-dev@lists.iovisor.org
Subject: Re: libbpf-devel rpm uapi headers
Message-ID: <20191002184315.zl5xpfhsaspllaix@ast-mbp.dhcp.thefacebook.com>
References: <20191002174331.GA13941@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002174331.GA13941@krava>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 07:43:31PM +0200, Jiri Olsa wrote:
> hi,
> we'd like to have bcc linked with libbpf instead of the
> github submodule, initial change is discussed in here:
>   https://github.com/iovisor/bcc/pull/2535
> 
> In order to do that, we need to have access to uapi headers
> compatible with libbpf rpm, bcc is attaching and using them
> during compilation.
> 
> I added them in the fedora spec below (not submitted yet),
> so libbpf would carry those headers.
> 
> Thoughts? thanks,

I think it may break a bunch of people who rely on bcc being a single library.
What is the main motiviation to use libbpf as a shared library in libbcc?

I think we can have both options. libbpf as git submodule and as shared.
In practice git submodule is so much simpler to use and a lot less headaches.

