Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC74D1EE8C9
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgFDQq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 12:46:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44665 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729789AbgFDQqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 12:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591289214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rYFGtIC552gLkUpERPIGUzsoKzT9woC/5boahqlmcS4=;
        b=YOmVYOUCyyEKE2aJXm4+5+D2vg03XY556FQA9SI4ZkiI5Jps76QesjY+jEe6oBl08lpOiJ
        LH3WeyX6jggRO/3p03lvatUhINnDHoyMz7x5R5fg2lR6jvRNyigmUQcoZBegICwTFpsrlh
        Gm5SYK9U4d5rBtY0TkZEvmbSwQqCsWs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-SrSrd51WPYK5l-iJ8aQDyA-1; Thu, 04 Jun 2020 12:46:53 -0400
X-MC-Unique: SrSrd51WPYK5l-iJ8aQDyA-1
Received: by mail-wr1-f72.google.com with SMTP id s7so2654441wrm.16
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 09:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rYFGtIC552gLkUpERPIGUzsoKzT9woC/5boahqlmcS4=;
        b=r5qRc8+yDx+jcVQh6X2LvcPI/klxYhtOY8ZD39GLZVlKZ2aPT7wQAosRaqRd5F4YC5
         aJzgFWcvQP8SOrZ5KXsl++GVXes+WLglWB5hd+KvdDmipQfnxPzLnM1wRI58qMUCrdVK
         fWBjGqqMvGYnlC0W9v/Ffebe5nubMD/RPgmOLLYIVkyF9vhFS1egVQ7CvbHJQEe5ruOo
         IhsWZ3tmI+ztusgBQyi4XEikvJlttEy2vpzGKVzlyYzZhcB1RC5NvO1WrF+lAoRtkQjp
         wRlwWhH398SV2h+aiJH04a/Sn3qCFvMBpEBrSrCpw936VQE/tEBhja89FpfbLmcRqjlU
         ZjUw==
X-Gm-Message-State: AOAM531EGKidvhoKYVL+bpl7XiCi/TMYF7rzcT7T841vnITfS4mokKFg
        X2I2kyMj/sIxr7+ClzCNwNlXOi7nZA/cLl5We14P+44PAMih03BLaGnmyprE5WIQEwsSRHhps9+
        DEziRGV0wi3od0syx
X-Received: by 2002:a7b:c0d9:: with SMTP id s25mr5089891wmh.175.1591289212191;
        Thu, 04 Jun 2020 09:46:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9dODiYy5HcsVQeCdjVQOA6jF0pYa9ZPQQTKb/equwgut+prFilWfFwLf9io2WRO1UvoUCSQ==
X-Received: by 2002:a7b:c0d9:: with SMTP id s25mr5089876wmh.175.1591289211954;
        Thu, 04 Jun 2020 09:46:51 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id d17sm7757908wme.43.2020.06.04.09.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 09:46:51 -0700 (PDT)
Date:   Thu, 4 Jun 2020 12:46:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200604124332-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
 <20200603165205.GU23230@ZenIV.linux.org.uk>
 <ec086f7b-be01-5ffd-6fc3-f865d26b0daf@redhat.com>
 <20200604145924.GF23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604145924.GF23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 03:59:24PM +0100, Al Viro wrote:
> On Thu, Jun 04, 2020 at 02:10:27PM +0800, Jason Wang wrote:
> 
> > > > get_user(flags, desc->flags)
> > > > smp_rmb()
> > > > if (flags & VALID)
> > > > copy_from_user(&adesc, desc, sizeof adesc);
> > > > 
> > > > this would be a good candidate I think.
> > > Perhaps, once we get stac/clac out of raw_copy_from_user() (coming cycle,
> > > probably).  BTW, how large is the structure and how is it aligned?
> > 
> > 
> > Each descriptor is 16 bytes, and 16 bytes aligned.
> 
> Won't it be cheaper to grap the entire thing unconditionally?

Yes but we must read the rest of descriptor after the flags are valid.
If it's read before then the value we get might be the invalid one -
the one it had before another thread gave up control.

>  And what does
> that rmb order, while we are at it - won't all coherency work in terms of
> entire cachelines anyway?

Would be great to know that, but it's hardly guaranteed on all architectures, is it?

> Confused...


