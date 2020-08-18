Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35793248653
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 15:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHRNp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 09:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbgHRNp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 09:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597758355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZRumnYOrFgt3qoT6t+nLLJKuANtNAnklm5YHpJrh+8=;
        b=SH63MKzYz7r2sN/Wyk5h769y2OcKXiKXQ1q6NaWGVLFIExR0/Zutdnh7ACdj/1ahehyQHm
        GtvIpJGukIs8tmT43j8c9lpob9/ecmgBVqCdsv+kVEilVF2Ge4O1ujBJGK086vLYDBxt31
        lOsxuWr0ETgQRPxVndPQHkOMRvxN7YY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295--bgF-J0OOsq5LKkAuenMIQ-1; Tue, 18 Aug 2020 09:45:53 -0400
X-MC-Unique: -bgF-J0OOsq5LKkAuenMIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 261251015C92;
        Tue, 18 Aug 2020 13:45:52 +0000 (UTC)
Received: from krava (unknown [10.40.193.152])
        by smtp.corp.redhat.com (Postfix) with SMTP id AFBDE7A401;
        Tue, 18 Aug 2020 13:45:44 +0000 (UTC)
Date:   Tue, 18 Aug 2020 15:45:43 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, sdf@google.com,
        andriin@fb.com, Mark Wielaard <mjw@redhat.com>
Subject: Re: Kernel build error on BTFIDS vmlinux
Message-ID: <20200818134543.GD177896@krava>
References: <20200818105555.51fc6d62@carbon>
 <20200818091404.GB177896@krava>
 <20200818105602.GC177896@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818105602.GC177896@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:56:08PM +0200, Jiri Olsa wrote:
> On Tue, Aug 18, 2020 at 11:14:10AM +0200, Jiri Olsa wrote:
> > On Tue, Aug 18, 2020 at 10:55:55AM +0200, Jesper Dangaard Brouer wrote:
> > > 
> > > On latest DaveM net-git tree (06a4ec1d9dc652), after linking (LD vmlinux) the
> > > "BTFIDS vmlinux" fails. Are anybody else experiencing this? Are there already a
> > > fix? (just returned from vacation so not fully up-to-date on ML yet)
> > > 
> > > The tool which is called and error message:
> > >   ./tools/bpf/resolve_btfids/resolve_btfids vmlinux
> > >   FAILED elf_update(WRITE): invalid section alignment
> > 
> > hi,
> > could you send your .config as well?
> 
> reproduced.. checking on fix

I discussed this with Mark (cc-ed) it seems to be a problem
with linker when dealing with compressed debug info data,
which is enabled in your .config

it works for me when I disable CONFIG_DEBUG_INFO_COMPRESSED option

Mark will fix this upstream, meanwhile he suggested workaround
we can do in resolve_btfids tool, that I'll try to send shortly

thanks,
jirka

