Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7E6149D06
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgAZV3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:29:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726438AbgAZV3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 16:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580074141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtCYfnm+uG6GtMlTEsToW55W8p4uANyr3cm/mhfmV5Q=;
        b=NVT9dok3ZrYywUe+loGoJhrfoz+yyr80Wa7Amr22NzEty2jSEcwQNqJcyWWCQ3xMoTc3Qo
        QKghx8FrhS93CQ+p8zDcUiFR7c7SB7aD3scir9N7mIp84NVb63+Bf1dAOoAW04lOTtdawk
        nEwa4BDCl06+5TUG425biDcToJG6yeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-GEvdCDjiPO6K-1f3G5EtVA-1; Sun, 26 Jan 2020 16:29:00 -0500
X-MC-Unique: GEvdCDjiPO6K-1f3G5EtVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5EA3107ACC5;
        Sun, 26 Jan 2020 21:28:58 +0000 (UTC)
Received: from carbon (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E4248E613;
        Sun, 26 Jan 2020 21:28:51 +0000 (UTC)
Date:   Sun, 26 Jan 2020 22:28:50 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, bjorn.topel@intel.com,
        songliubraving@fb.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/3] bpf: xdp, virtio_net use access ptr
 macro for xdp enable check
Message-ID: <20200126222850.04aff480@carbon>
In-Reply-To: <1580011133-17784-3-git-send-email-john.fastabend@gmail.com>
References: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
        <1580011133-17784-3-git-send-email-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 19:58:52 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> virtio_net currently relies on rcu critical section to access the xdp
> program in its xdp_xmit handler. However, the pointer to the xdp program
> is only used to do a NULL pointer comparison to determine if xdp is
> enabled or not.
> 
> Use rcu_access_pointer() instead of rcu_dereference() to reflect this.
> Then later when we drop rcu_read critical section virtio_net will not
> need in special handling.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

