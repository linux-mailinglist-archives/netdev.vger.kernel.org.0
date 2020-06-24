Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AAB206EBE
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390289AbgFXINN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:13:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57042 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387732AbgFXINM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592986391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btNstdrh8V34VEAlZ04qz65tgKgC9MS40ZzIsFVbqvs=;
        b=RuO/gUHheRhfU80Zu3vKv9w57d9ya3SG20Pz5mCKXKrpC7lDGKvbD7Krq1G+qLYstxWb1v
        zHI6gjUUqYt2LMLDFQ6ihwWqOL8EqABQzC/Sc51aDVxSDkybGMjoVI2kQsMquLscyCqHKy
        1Ji53EZlNH8syZ/dpYrv3LdHN0WyKrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-BoaKT5FVPgqycT2A0NidTQ-1; Wed, 24 Jun 2020 04:13:08 -0400
X-MC-Unique: BoaKT5FVPgqycT2A0NidTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E2F08064AB;
        Wed, 24 Jun 2020 08:13:06 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C54387FE82;
        Wed, 24 Jun 2020 08:12:54 +0000 (UTC)
Date:   Wed, 24 Jun 2020 10:12:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 5/9] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
Message-ID: <20200624101253.57daa0f0@carbon>
In-Reply-To: <7f40456531a507b53e30165afa229b4e2a22e8e7.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
        <7f40456531a507b53e30165afa229b4e2a22e8e7.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 23:39:30 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce the capability to attach an eBPF program to cpumap entries.
> The idea behind this feature is to add the possibility to define on
> which CPU run the eBPF program if the underlying hw does not support
> RSS. Current supported verdicts are XDP_DROP and XDP_PASS.
> 
> This patch has been tested on Marvell ESPRESSObin using xdp_redirect_cpu
> sample available in the kernel tree to identify possible performance
> regressions. Results show there are no observable differences in
> packet-per-second:
> 
> $./xdp_redirect_cpu --progname xdp_cpu_map0 --dev eth0 --cpu 1
> rx: 354.8 Kpps
> rx: 356.0 Kpps
> rx: 356.8 Kpps
> rx: 356.3 Kpps
> rx: 356.6 Kpps
> rx: 356.6 Kpps
> rx: 356.7 Kpps
> rx: 355.8 Kpps
> rx: 356.8 Kpps
> rx: 356.8 Kpps
> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

