Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C223E1207A4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 14:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfLPNwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 08:52:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24443 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727894AbfLPNwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 08:52:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576504361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=87rXzV1NWhfpl77XrvBudXUsnuk0dqBMGM04qX4iFnU=;
        b=fy2NAbKoq67Vn2yk7n1WyTwyq1BmMykzdSkeo5muVgePxhH0bcrK6TB0SKR9FvcgnPplL9
        o61b9HQmCiB6XbdKPvI3wVmWrO8yqqzfVDsnCrmfHrPQWhsTrW1cLVS3P1kbSHkGlXmF1b
        j7C2fffQOOtT3Nqwr5g0IoIaLAMCyI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-0BEJIaBDPTqB5of12qC6DA-1; Mon, 16 Dec 2019 08:52:40 -0500
X-MC-Unique: 0BEJIaBDPTqB5of12qC6DA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE0348017DF;
        Mon, 16 Dec 2019 13:52:38 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E67E1001B07;
        Mon, 16 Dec 2019 13:52:31 +0000 (UTC)
Date:   Mon, 16 Dec 2019 14:52:30 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next] libbpf: Print hint about ulimit when getting
 permission denied error
Message-ID: <20191216145230.103c1f46@carbon>
In-Reply-To: <20191216124031.371482-1-toke@redhat.com>
References: <20191216124031.371482-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 13:40:31 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Probably the single most common error newcomers to XDP are stumped by is
> the 'permission denied' error they get when trying to load their program
> and 'ulimit -r' is set too low. For examples, see [0], [1].
>=20
> Since the error code is UAPI, we can't change that. Instead, this patch
> adds a few heuristics in libbpf and outputs an additional hint if they are
> met: If an EPERM is returned on map create or program load, and geteuid()
> shows we are root, and the current RLIMIT_MEMLOCK is not infinity, we
> output a hint about raising 'ulimit -r' as an additional log line.
>=20
> [0] https://marc.info/?l=3Dxdp-newbies&m=3D157043612505624&w=3D2
> [1] https://github.com/xdp-project/xdp-tutorial/issues/86
>=20
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

This is the top #1 issue users hit again-and-again, too bad we cannot
change the return code as it is UAPI now.  Thanks for taking care of
this mitigation.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

