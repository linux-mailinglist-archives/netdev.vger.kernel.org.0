Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FAE1DECC3
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgEVQEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:04:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730114AbgEVQEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 12:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590163493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yy4GmOiwgEqnHILmNJXpm2vUJeLRsh0E1bTnr1IYuC8=;
        b=FlM/o6dD483jbfXDNO8t8l5hWU/01XeLDdEjrBZj0SQUpxmY2Db1K+nVaadhbsX9goIwUW
        aA1Ru6ykqwKYHxqsdexA0BzTojgIrKiXZ5r2BBcqYchyPdNOpMEpLG4V06IovRfG4VpPxy
        1JMf17LDcmwLzVAeyH/nt8e1OyMBw+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-jGGh03f0PGedeAUW2ikiPw-1; Fri, 22 May 2020 12:04:47 -0400
X-MC-Unique: jGGh03f0PGedeAUW2ikiPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1875D100CCC9;
        Fri, 22 May 2020 16:04:45 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73A2F4EEC2;
        Fri, 22 May 2020 16:04:33 +0000 (UTC)
Date:   Fri, 22 May 2020 18:04:31 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC bpf-next 1/4] bpf: Handle 8-byte values in DEVMAP
 and DEVMAP_HASH
Message-ID: <20200522180431.6fa89cc7@carbon>
In-Reply-To: <20200522140805.045b8823@carbon>
References: <20200522010526.14649-1-dsahern@kernel.org>
        <20200522010526.14649-2-dsahern@kernel.org>
        <20200522140805.045b8823@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 14:08:05 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Thu, 21 May 2020 19:05:23 -0600
> David Ahern <dsahern@kernel.org> wrote:
> 
> > Add support to DEVMAP and DEVMAP_HASH to support 8-byte values as a
> > <device index, program id> pair. To do this, a new struct is needed in
> > bpf_dtab_netdev to hold the values to return on lookup.  
> 
> I would like to see us leverage BTF instead of checking on the size
> attr->value_size. E.g do the sanity check based on BTF.
> Given I don't know the exact details on how this should be done, I will
> look into it... I already promised Lorenzo, as we have already
> discussed this on IRC.
> 
> So, you can Lorenzo can go ahead with this approach, and test the
> use-case. And I'll try to figure out if-and-how we can leverage BTF
> here.  Input from BTF experts will be much appreciated.

Published my current notes here:
 https://github.com/xdp-project/xdp-project/blob/BTF01-notes.public/areas/core/BTF_01_notes.org

And created PR that people can GitHub "subscribe" to, if you are interested:
 https://github.com/xdp-project/xdp-project/pull/36

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

