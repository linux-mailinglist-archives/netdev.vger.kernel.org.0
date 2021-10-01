Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F46041F629
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhJAUME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 16:12:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhJAUMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 16:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633119018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XiGtJZlVMPsm2Li879wR6Wr450jla08RUNWR3dUvcq8=;
        b=NH8L6gZQhuOhfwWzDmr18pPneVHXpkkv6CRBfMKbMch1+COubCEG9Dm2go8qY00DQ5KB1q
        8F9mQW9UuJDMLz1yqqf4O05zowG1TK/upel0OOskwbuvN+LETw+wQXUY/TFQOJcO4N9obn
        NS1LMUjsc/FarPKVtW4UKVXh+8d97lQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-IQnDggNHOVaQ_pu9syFdpw-1; Fri, 01 Oct 2021 16:10:15 -0400
X-MC-Unique: IQnDggNHOVaQ_pu9syFdpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9919B8015C7;
        Fri,  1 Oct 2021 20:10:13 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 824A65F4E1;
        Fri,  1 Oct 2021 20:10:10 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Cufi, Carles" <Carles.Cufi@nordicsemi.no>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jukka.rissanen@linux.intel.com" <jukka.rissanen@linux.intel.com>,
        "johan.hedberg@intel.com" <johan.hedberg@intel.com>,
        "Lubos, Robert" <Robert.Lubos@nordicsemi.no>,
        "Bursztyka, Tomasz" <tomasz.bursztyka@intel.com>,
        linux-toolchains@vger.kernel.org
Subject: Re: Non-packed structures in IP headers
References: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
Date:   Fri, 01 Oct 2021 22:10:08 +0200
In-Reply-To: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
        (Carles Cufi's message of "Thu, 30 Sep 2021 12:30:05 +0000")
Message-ID: <87bl48v74v.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Carles Cufi:

> I was looking through the structures for IPv{4,6} packet headers and
> noticed that several of those that seem to be used to parse a packet
> directly from the wire are not declared as packed. This surprised me
> because, although I did find that provisions are made so that the
> alignment of the structure, it is still technically possible for the
> compiler to inject padding bytes inside those structures, since AFAIK
> the C standard makes no guarantees about padding unless it's
> instructed to pack the structure.

The C standards do not make such guarantees, but the platform ABI
standards describe struct layout and ensure that there is no padding.
Linux relies on that not just for networking, but also for the userspace
ABI, support for separately compiled kernel modules, and in other
places.

Sometimes there are alignment concerns in the way these structs are
used, but I believe the kernel generally controls placement of the data
that is being worked on, so that does not matter, either.

Therefore, I do not believe this is an actual problem.

Thanks,
Florian

