Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDC54A3FDD
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348399AbiAaKJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:09:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232024AbiAaKI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:08:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643623738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pebP+NEU7H4Z5WTTl3wEP7d3X+lMy2AUTov479lBhyw=;
        b=NudqZ1PH0pOUKj8sYUoNlXXznXx8YtzzheJFnddmALWjb5aO+pqsJGTsffrbrIRYnJ0I5o
        wt33ixsfY7ZVKnOvPLvQvlKeN4pQmFhRQ/R+WcgmY49hIqNwY4TfEm7ebaA6URCrAvY65k
        ohQ3IH1vYll+JVQ5y//ZS9D4vn/45M8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-dBjDec5xPPCT6gdiX1Ry_Q-1; Mon, 31 Jan 2022 05:07:57 -0500
X-MC-Unique: dBjDec5xPPCT6gdiX1Ry_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C628C363A4;
        Mon, 31 Jan 2022 10:07:55 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6226262D77;
        Mon, 31 Jan 2022 10:07:54 +0000 (UTC)
Date:   Mon, 31 Jan 2022 11:07:52 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 1/5] ptp: unregister virtual clocks when
 unregistering physical clock.
Message-ID: <Yfe0+N2cMJaWNbo7@localhost>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-2-mlichvar@redhat.com>
 <87czkcn33p.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czkcn33p.fsf@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 03:58:02PM -0800, Vinicius Costa Gomes wrote:
> Miroslav Lichvar <mlichvar@redhat.com> writes:
> 
> > When unregistering a physical clock which has some virtual clocks,
> > unregister the virtual clocks with it.

> I am not against this change, but I think this problem was discussed
> before and the suggestions were to fix it differently:
> 
> https://lore.kernel.org/all/20210807144332.szyazdfl42abwzmd@skbuf/

Is a linked device supposed to be unregistered automatically before
the parent? The referenced document mentions only suspending
and resuming, nothing about unregistering.

I tried

	device_link_add(parent, &ptp->dev, DL_FLAG_AUTOREMOVE_CONSUMER);

and also with no flags specified, but it didn't seem to do anything
for the vclock. It was still oopsing.

Any hints?

-- 
Miroslav Lichvar

