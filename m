Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7DE34ACFA
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhCZQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhCZQ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 12:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616777895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=326ND84gFC7lKH4j62OSQ950MBlw4NHyvH44eCZxOtI=;
        b=g2CSZr5m9iRfuxiN/tdF/gFOyfLCwVbBCLQn2FsakgDAs4qXCwQYCPvUWqIB1Y8PzjQzd9
        BW0Th5/LOztpeEjtnMhFXVkOM+M7B7p3FsF0uFF6yUiPXHlJwfeVYV7U5uDzN86QDq1uGv
        4zBl6safMmu2xPTEyUBI5j4QuYTqeyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-t1bKPwOoPTe5V0qW2jRcXg-1; Fri, 26 Mar 2021 12:58:13 -0400
X-MC-Unique: t1bKPwOoPTe5V0qW2jRcXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 662D1107ACCD;
        Fri, 26 Mar 2021 16:58:11 +0000 (UTC)
Received: from horizon.localdomain (ovpn-118-56.rdu2.redhat.com [10.10.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D10BC60C4A;
        Fri, 26 Mar 2021 16:58:07 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 0185CC07AE; Fri, 26 Mar 2021 13:58:04 -0300 (-03)
Date:   Fri, 26 Mar 2021 13:58:04 -0300
From:   Marcelo Leitner <mleitner@redhat.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     wenxu <wenxu@ucloud.cn>, Ilya Maximets <i.maximets@ovn.org>,
        "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Paul Blakey <paulb@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
Message-ID: <YF4SnCaDTfKcVImr@horizon.localdomain>
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
 <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
 <YEvlysueK+eiMc1b@horizon.localdomain>
 <58820355-7337-d51b-32dd-be944600832d@corigine.com>
 <fc269566-9652-ed80-cea4-016c069fa104@ucloud.cn>
 <c32bac8a-8127-1bf1-3b3e-13afdfbe7379@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c32bac8a-8127-1bf1-3b3e-13afdfbe7379@corigine.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 05:12:22PM +0200, Louis Peens wrote:
> So in the end I think there are two problems - the on you identified with only checking
> the mask in commit 1bcc51ac0731. And then the second bigger one is that the behaviour
> differs depending on whether the recirc upcall is after the a rule installed in tc
> or a rule installed in ovs, as Marcelo mentioned.

Hi Louis,

Not sure if you noticed but both fixes landed in upstream kernel
already.
That's basically:
afa536d8405a ("net/sched: cls_flower: fix only mask bit check in the
validate_ct_state")
d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after
do conntrack in act_ct")

If testing again, it's probably better if you use the latest one.

Thanks,
Marcelo

