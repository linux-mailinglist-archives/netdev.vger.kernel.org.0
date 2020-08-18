Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E9E248BB3
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgHRQds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:33:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726918AbgHRQde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597768412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5msNc8qKCzsD6V4bz+uWSdwzCCAzbNPjuKDpd5aaGms=;
        b=hj1gT4dYiYjnirSrToIGZXjeTNi1LILEmLicMvzW4JFbGbqV0ocjj6LDr6ynhDSk/TsBZz
        NC9pJ9O0teZZj/kUYMrjKdmz5vQoMu8TdP+Xp+haYtMVhQpIzYBAJ1U9QHlQ8plx0OqLVY
        CV+VYGdU5H79bVwCFIUNc2e+mMmsV3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-TCiH__iONaqb5ZgMjnDcaQ-1; Tue, 18 Aug 2020 12:33:29 -0400
X-MC-Unique: TCiH__iONaqb5ZgMjnDcaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 332F51DDF4;
        Tue, 18 Aug 2020 16:33:28 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8E027DFD7;
        Tue, 18 Aug 2020 16:33:19 +0000 (UTC)
Date:   Tue, 18 Aug 2020 18:33:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     brouer@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, sdf@google.com,
        andriin@fb.com, Mark Wielaard <mjw@redhat.com>
Subject: Re: Kernel build error on BTFIDS vmlinux
Message-ID: <20200818183318.2c3fe4a2@carbon>
In-Reply-To: <20200818134543.GD177896@krava>
References: <20200818105555.51fc6d62@carbon>
        <20200818091404.GB177896@krava>
        <20200818105602.GC177896@krava>
        <20200818134543.GD177896@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 15:45:43 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Aug 18, 2020 at 12:56:08PM +0200, Jiri Olsa wrote:
> > On Tue, Aug 18, 2020 at 11:14:10AM +0200, Jiri Olsa wrote:  
> > > On Tue, Aug 18, 2020 at 10:55:55AM +0200, Jesper Dangaard Brouer wrote:  
> > > > 
> > > > On latest DaveM net-git tree (06a4ec1d9dc652), after linking (LD vmlinux) the
> > > > "BTFIDS vmlinux" fails. Are anybody else experiencing this? Are there already a
> > > > fix? (just returned from vacation so not fully up-to-date on ML yet)
> > > > 
> > > > The tool which is called and error message:
> > > >   ./tools/bpf/resolve_btfids/resolve_btfids vmlinux
> > > >   FAILED elf_update(WRITE): invalid section alignment  
> > > 
> > > hi,
> > > could you send your .config as well?  
> > 
> > reproduced.. checking on fix  
> 
> I discussed this with Mark (cc-ed) it seems to be a problem
> with linker when dealing with compressed debug info data,
> which is enabled in your .config
> 
> it works for me when I disable CONFIG_DEBUG_INFO_COMPRESSED option

Thanks for finding this!
I confirm that disabling CONFIG_DEBUG_INFO_COMPRESSED fixed the issue.


> Mark will fix this upstream, meanwhile he suggested workaround
> we can do in resolve_btfids tool, that I'll try to send shortly

Great!
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

