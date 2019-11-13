Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06686FB542
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfKMQh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:37:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbfKMQhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 11:37:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573663044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ndthkMwH6OcHM/HTdHcb3WGgoPNTz7U8dEVp3xxEIIM=;
        b=Si2niha1xR35I9RV/iL41xGKchfEuMNx+jnloUr56mQ8OlyBiW92NU7EosfaTedc2E6xDv
        UeiA29oeAjKbx++YAhKufeZV2hJh+lAGGB1gWiE3KTG1wletpV01g8By5fpUIOcorstC4a
        WHPTZ2y6jRZdy89mDcdu8aIEAWsOWFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-0zvU3qpxPDGukduaJBpHlg-1; Wed, 13 Nov 2019 11:37:21 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AD94100F126;
        Wed, 13 Nov 2019 16:37:19 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E3EB5F784;
        Wed, 13 Nov 2019 16:37:13 +0000 (UTC)
Date:   Wed, 13 Nov 2019 17:37:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Alexei Starovoitov" <ast@fb.com>, netdev@vger.kernel.org,
        davem@davemloft.net, "Kernel Team" <Kernel-team@fb.com>,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191113173712.173a1813@carbon>
In-Reply-To: <20191113110823.0e1186a5@carbon>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
        <20191112130832.6b3d69d5@carbon>
        <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
        <20191112174822.4b635e56@carbon>
        <e4aa8923-7c81-a215-345c-a2127862048f@fb.com>
        <04EECB84-2958-4D59-BE2D-FD7ABD8E4C05@gmail.com>
        <20191113110823.0e1186a5@carbon>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 0zvU3qpxPDGukduaJBpHlg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 11:08:23 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> The basic idea is to use these tracepoints to detect if we leak
> DMA-mappings. I'll try write the bpftrace script today, and
> see it I can live without the counter.

Didn't finish, here is how far I got:
 https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftrace/=
page_pool_track_leaks01.bt

In the end of the bpftrace script, I needed to iterate over a map,
which I don't think bpftrace supports (Brendan) ?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

