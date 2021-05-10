Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD1A377EC9
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 10:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhEJI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 04:58:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhEJI6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 04:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620637063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZZqhl1lPZ55ZI62hYWzaYM8RnSN2emKsTAUPinh/Kg=;
        b=Qf6fK+GLK69kLmHfLdlFi/AdAe4W2ZAQq2hNqlDO7qejMTcGTreXf+AyrcUp6TeSdyQvXw
        7C3FTowzB6rgNOQ9v0huOJbCGDAY0fVncfiWDQPC80fi6kneHqdqjXsYW0UABPmziKzhCY
        k0Snfb/qaYDD66y5wLbncvQHAKFjFQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-zET4am8tP2erlHUFmfIydg-1; Mon, 10 May 2021 04:57:40 -0400
X-MC-Unique: zET4am8tP2erlHUFmfIydg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9740219251A1;
        Mon, 10 May 2021 08:57:38 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72EE35D765;
        Mon, 10 May 2021 08:57:29 +0000 (UTC)
Date:   Mon, 10 May 2021 10:57:28 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        brouer@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH intel-net 0/5] i40e: ice: ixgbe: ixgbevf: igb: add
 correct exception tracing for XDP
Message-ID: <20210510105728.2eac4666@carbon>
In-Reply-To: <CAJ8uoz0Pgfn8kai34_MFGYv3m7c24bpo4DhjZ8oLgd4zaGMWsg@mail.gmail.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
        <75d0a1d13a755bc128458c0d43f16d54fe08051e.camel@intel.com>
        <CAJ8uoz0Pgfn8kai34_MFGYv3m7c24bpo4DhjZ8oLgd4zaGMWsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 08:06:00 +0200
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Sat, May 8, 2021 at 12:58 AM Nguyen, Anthony L
> <anthony.l.nguyen@intel.com> wrote:
> >
> > On Fri, 2021-04-23 at 12:04 +0200, Magnus Karlsson wrote:  
> > > Add missing exception tracing to XDP when a number of different errors
> > > can occur. The support was only partial. Several errors where not
> > > logged which would confuse the user quite a lot not knowing where and
> > > why the packets disappeared.
> > >
> > > This patch set fixes this for all Intel drivers with XDP support.
> > >
> > > Thanks: Magnus  
> >
> > This doesn't apply anymore with the 5.13 patches. It looks like your
> > "optimize for XDP_REDIRECT in xsk path" patches are conflicting with
> > some of these. Did you want to rework them?  
> 
> I will rebase them and resubmit.

Thanks for working on this Magnus, highly appreciated.  This should
help end-users troubleshoot these kind of 'exception' packet drops.

We have people that will look at updating the sample/bpf/ programs
(that does XDP redirect) to report on these exception errors/drops.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

