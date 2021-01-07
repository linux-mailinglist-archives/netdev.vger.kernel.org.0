Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85F2EEA0E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbhAGX7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:59:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727300AbhAGX7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 18:59:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610063903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rac20jbc+HZUTIRq8HeTeM5nvA7TtlA4vvI9RN7mu6Q=;
        b=UxG8L8OSwbKu8m47n7PjZn4myAuD5Up8Y1y3qCzPkPYPv63iM4MSfXbRpepMsb387aZzrs
        6HictMQoow1jvjBV+kSgg6pCyj7Y4dHNjq/YczPX0/r//Hhonx3bW+4IBgWv3Nfy+sRJLd
        dKlMfSO/Q05EJshvqysHAvwsYSc31WM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-Pac8vphWMPqgQbeoQ6I6ew-1; Thu, 07 Jan 2021 18:58:19 -0500
X-MC-Unique: Pac8vphWMPqgQbeoQ6I6ew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D13D180A094;
        Thu,  7 Jan 2021 23:58:17 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E09365C8AA;
        Thu,  7 Jan 2021 23:58:15 +0000 (UTC)
Date:   Thu, 7 Jan 2021 18:58:13 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210107235813.GB29828@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20201228101145.GC3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228101145.GC3565223@nanopsycho.orion>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:11:45AM +0100, Jiri Pirko wrote:
> Fri, Dec 18, 2020 at 08:30:33PM CET, jarod@redhat.com wrote:
> >This comes from an end-user request, where they're running multiple VMs on
> >hosts with bonded interfaces connected to some interest switch topologies,
> >where 802.3ad isn't an option. They're currently running a proprietary
> >solution that effectively achieves load-balancing of VMs and bandwidth
> >utilization improvements with a similar form of transmission algorithm.
> >
> >Basically, each VM has it's own vlan, so it always sends its traffic out
> >the same interface, unless that interface fails. Traffic gets split
> >between the interfaces, maintaining a consistent path, with failover still
> >available if an interface goes down.
> >
> >This has been rudimetarily tested to provide similar results, suitable for
> >them to use to move off their current proprietary solution.
> >
> >Still on the TODO list, if these even looks sane to begin with, is
> >fleshing out Documentation/networking/bonding.rst.
> 
> Jarod, did you consider using team driver instead ? :)

That's actually one of the things that was suggested, since team I believe
already has support for this, but the user really wants to use bonding.
We're finding that a lot of users really still prefer bonding over team.

-- 
Jarod Wilson
jarod@redhat.com

