Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3560CF31B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfJHG6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:58:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59763 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730026AbfJHG6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:58:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570517903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjiVfnfo3B219hJevj+nUA5nd9HYypooTjDbpxlfu2E=;
        b=aw3SvIoBru9E25cI0qJmm707w3jzpsTGCS/b75o9/i4KhyygCyBvLxLqQr5puj9rMj7/Rh
        F0tcZ4kRH15GYPg/r3w42zR/xvLoRuxtfMNz3c7IHXP2WcGrg14/xnjibBGJ5XSpeVfdg8
        uzUH8oMXNDDIqlzkTlicjtU7Lz0TVDE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-xp0mXQlqNHO62Le9YkzygQ-1; Tue, 08 Oct 2019 02:58:20 -0400
Received: by mail-lf1-f72.google.com with SMTP id c13so2027024lfk.23
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 23:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=S9PjHaofBE8WvE/gCT9+Hpu5GwookQh45Bj4/FXFqOI=;
        b=Qz5ltdxpSMNvSL3Y9FLUKP9dfElNiEyy1nalw4Aef8+HNi6ssKFo+WXnv7e1WQ/jj2
         p9hlSiV2l2GtEq7QBd7PfNgv7axtdNz+mCZsvg/+eghR0XPX73yaT+iQ0MXgWuoaUCdZ
         pch45Gnt+2V560EwrxwaXCmPKNVJQU+g1VGU05pOY6D2UcnXn/fz/zow8RFaN4dVirzV
         oDx9A1Rt5dzHECUM2WLJPczbkZcYN2uUSz9Yf0VjCa7GiMJVEU1T7SLLhjtEN5WgKgHZ
         d/EKXypWePRI8V0PhdK5ZptBe2OnTIGssjsB5OULRjpg9kkh15IZxm0M22ZrjN2lionu
         IVOQ==
X-Gm-Message-State: APjAAAWWmgj/VFPuwBFKGGQmbEfvKWyGdxr/v5gkBu7a8KAVcErkgt9d
        iQPSn7AYRbylA3YQYP0gLKPC35X5H2Jn7Q5WSNlEXfzesIa3zareNmtJVVUHfWUsGVlTW49jM3W
        QZMMMM80nD3fj0jaR
X-Received: by 2002:a2e:730a:: with SMTP id o10mr21912306ljc.214.1570517898816;
        Mon, 07 Oct 2019 23:58:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzcpPsm8E/3M1oXM5bmklENMw0tvOHJJmGog/AgsVSfuHgI1NlUp2BPNtR6+WN3vcVRbtaEPA==
X-Received: by 2002:a2e:730a:: with SMTP id o10mr21912299ljc.214.1570517898646;
        Mon, 07 Oct 2019 23:58:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id b6sm3972837lfi.72.2019.10.07.23.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 23:58:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BF15F18063D; Tue,  8 Oct 2019 08:58:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: Re: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets directly from a queue
In-Reply-To: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com> <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Oct 2019 08:58:16 +0200
Message-ID: <875zkzn2pj.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: xp0mXQlqNHO62Le9YkzygQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sridhar Samudrala <sridhar.samudrala@intel.com> writes:

>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  =09=09    struct bpf_prog *xdp_prog)
>  {
>  =09struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>  =09struct bpf_map *map =3D READ_ONCE(ri->map);
> +=09struct xdp_sock *xsk;
> +
> +=09xsk =3D xdp_get_direct_xsk(ri);
> +=09if (xsk)
> +=09=09return xsk_rcv(xsk, xdp);

This is a new branch and a read barrier in the XDP_REDIRECT fast path.
What's the performance impact of that for non-XSK redirect?

-Toke

