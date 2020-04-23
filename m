Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A171B5F83
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgDWPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:38:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57185 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729020AbgDWPiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587656299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qy57pUbOaQDEl/Ihs/Qx24WETKKMPboDRhW1Bi6Io20=;
        b=BJfMjyABTfDfbLrPrsadQA5n0SnI7A3cb1NYFl2qLH/J9WPgdwGfGy03iO4Q4wGDxjAJZz
        0fDcSTupRp2HfzLXVr7b4db+WIszNQAmtzMS4uTFnMwjN0CHBmfBAufK3846+hqmdzqi8+
        5qvUczxU4MHtALe95QukwcE03mURP/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-O2o2MIzjOJOpUrn9E8wq0A-1; Thu, 23 Apr 2020 11:38:15 -0400
X-MC-Unique: O2o2MIzjOJOpUrn9E8wq0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 292BF80B70C;
        Thu, 23 Apr 2020 15:38:14 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6D835C1BD;
        Thu, 23 Apr 2020 15:38:05 +0000 (UTC)
Date:   Thu, 23 Apr 2020 17:38:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200423173804.004fd0f6@carbon>
In-Reply-To: <20200423082804.6235b084@hermes.lan>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
        <158765387082.1613879.14971732890635443222.stgit@firesoul>
        <20200423082804.6235b084@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 08:28:58 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Thu, 23 Apr 2020 16:57:50 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> 
> > Drivers ndo_setup_tc call should return -EOPNOTSUPP, when it cannot
> > support the qdisc type. Other return values will result in failing the
> > qdisc setup.  This lead to qdisc noop getting assigned, which will
> > drop all TX packets on the interface.
> > 
> > Fixes: ab1e6de2bd49 ("dpaa2-eth: Add mqprio support")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> Would it be possible to use extack as well?

That is what patch 1/2 already does.

> Putting errors in dmesg is unhelpful

This patchset does not introduce any dmesg printk.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

