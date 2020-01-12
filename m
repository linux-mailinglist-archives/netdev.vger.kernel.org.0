Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C481385FB
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 12:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbgALLWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 06:22:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35406 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732676AbgALLWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 06:22:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578828121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8nvNYdnOnHKFbS8/LYeXsgPEAOrXmzDXiryXTrP7kA=;
        b=KUezT57lX0eIMnaZ8J9mQZLlX4aq5BOtSJ5UpirQr9vZbpa3b2VlmP84WH/5YkhObwKSFn
        YIi7GPehVFwX1hjyviP9McU9JEJrlDQH0a7tNvRg1ERaXNqoVOKAtwJVxW08PoD54H6K1K
        6VPlHbHajFr45C1TR+WWdF3BWHoNC9Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-_a1dXzKOP1KeYfB_xLnUFQ-1; Sun, 12 Jan 2020 06:22:00 -0500
X-MC-Unique: _a1dXzKOP1KeYfB_xLnUFQ-1
Received: by mail-wm1-f71.google.com with SMTP id s25so1023499wmj.3
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 03:21:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=q8nvNYdnOnHKFbS8/LYeXsgPEAOrXmzDXiryXTrP7kA=;
        b=cYrJ4faCrLWJg/2MeXaFNnVaOTzz9aLNrk0MDp+aBwECi+ZptNHlEE4YOKtZVkaMx3
         b5Ra1J/mTopto2opTKlukYOJMhsnNMMkgCdztf3QK+M6LCco252wDxOT+Rwn/rzH7qzh
         aK7o3kFIkHr910kf07nOeWPZRft/2qEXkx6xyCG0n4n0VPPgYGazjK7xMayg/KOj7oq2
         2+HGDuuF94TrGWNmMlET4og/2AwjTWQOMA79eNSq/Fub20eviBIPBw72MExdlNQVE1b3
         fDxQ6uVes97dzswWs4VtdaIkeY2dhZctuH7L2741LAeIrSMHUtGalxIjXNamzCq6qGRP
         GzdA==
X-Gm-Message-State: APjAAAX6iPqzLhoCgoGZxA0yzrkfCfTIEqXUT7MCKGTTmdC8BwbqnEJa
        Loo39D8r4cAO0mIqVprtCyAqlvomqDW8bO+LnaiPlxq16sYKvkzpeLNnniqwT79H/LE/Dkceg1g
        cgevrRtPfRgd4FeCB
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr15331168wmi.15.1578828119180;
        Sun, 12 Jan 2020 03:21:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDsuuKG8vHwSnLT+LMQHn5oy+j9kDw+V82XT8AVURuZrbbW/6wUtNSHgMv7Jp6t5BEuf22Lg==
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr15331152wmi.15.1578828118962;
        Sun, 12 Jan 2020 03:21:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t125sm9951793wmf.17.2020.01.12.03.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 03:21:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D3B821804D6; Sun, 12 Jan 2020 12:21:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>, bjorn.topel@gmail.com,
        bpf@vger.kernel.org, toshiaki.makita1@gmail.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf-next PATCH v2 1/2] bpf: xdp, update devmap comments to reflect napi/rcu usage
In-Reply-To: <157879664156.8200.4955971883120344808.stgit@john-Precision-5820-Tower>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower> <157879664156.8200.4955971883120344808.stgit@john-Precision-5820-Tower>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 12 Jan 2020 12:21:56 +0100
Message-ID: <87pnfox6ln.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Now that we rely on synchronize_rcu and call_rcu waiting to
> exit perempt-disable regions (NAPI) lets update the comments
> to reflect this.
>
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

