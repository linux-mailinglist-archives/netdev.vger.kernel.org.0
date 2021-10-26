Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3799543B54C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhJZPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:19:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235600AbhJZPTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:19:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635261406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QvA05aXxutxxuf4alvCn/tpNnAap84Nz2gzVRaRAagI=;
        b=ODXHmgFWpeGnXkQCDitq7ZBj5z2xDhSYtJwpCuADgvhp6tLgRsPdy1QSK6N2M26cKRbJRE
        g672rsYKV84w6Q4DqBRrZLoykrDiT/Wx7C+clLg6qK/q+GB2A9PQpow6Ok/iO/sbhwId3x
        Sll3s+CIEnS/+deK1x+34BWylDfd1jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-WTS0u1CtO12nii2zTtgFcA-1; Tue, 26 Oct 2021 11:16:44 -0400
X-MC-Unique: WTS0u1CtO12nii2zTtgFcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B63F2112A0A1;
        Tue, 26 Oct 2021 15:16:43 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF23169117;
        Tue, 26 Oct 2021 15:16:41 +0000 (UTC)
Date:   Tue, 26 Oct 2021 17:16:38 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Eli Cohen <eli@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Liran Liss <liranl@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH for-next 01/10] net/core: Add support for configuring VF
 GUIDs
Message-ID: <20211026151408.GA18227@asgard.redhat.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-2-git-send-email-eli@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1456851143-138332-2-git-send-email-eli@mellanox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2016 at 06:52:14PM +0200, Eli Cohen wrote:
> +struct ifla_vf_guid {
> +	__u32 vf;
> +	__u64 guid;
> +};

This type definition differs in size on 64-bit and (most of) 32-bit
architectures, and it breaks 32-on-64-bit compat applications, as a result.

