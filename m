Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2785F10EC50
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 16:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLBP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 10:29:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28815 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727435AbfLBP3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 10:29:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575300588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0z2tQm4iXkieh7Y2qc0PIyltREwM+PT4orb8BcP5pjQ=;
        b=hRMlCTQXnuVQ3Nnqz0nxWgZFK9SweGw58EVWmJp0B9Ze0KHggQ+/g7VWhT58x2w6j2YOcM
        +m2z50nzUJu1d/PKtX1SbHklTfXR4v/vqOhCQYLVBeQKrAdNAXwK/D++4VSWNw9MWKleK3
        RdtDf0uTTh4vKrW20lOZVDlytqg2Nuo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-eXPGVTJENJajwtUyyI8rTg-1; Mon, 02 Dec 2019 10:29:45 -0500
Received: by mail-qt1-f198.google.com with SMTP id u9so97229qte.5
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 07:29:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UHNVZK66LNTKTGCBCYSRNRG2nM4kaD92FRubfSh9yTo=;
        b=iI6MLn+iOnwiYUAblRu3BOfP2DSWP45LhHrP4/VldXV/qG02HTevT943ljS5OMfVyi
         yTIlNBjOzvlh9z5JAWfOJnVi3mpROoXyFsdDiyMUjVKhz6IN7c3Lwa1SPvNKoQb+ONrN
         AY0JP+McFMEN+Vo1cj6UIogof2Kn3fi/J7wv6ziCC2kVWLuDW/6CxHFip4y9kxDdn/HB
         WQU+xarBqcO+dBc12OaOye6ozRpBNduznNxN7YZsOG6sXh7HJldar0+h+vTC+4G6ZVPm
         A3QZ5TGbynKWGNTWUE+Nv3x4O9V8+WtDepOabMPDm5xdoUVRMn/MQdPa1csxw+dpW3Ka
         nHIg==
X-Gm-Message-State: APjAAAWNh1Ks5veE7o0rHn1uIL5a5dRlqktH5pD7psPzNriFSBJBxovc
        Y43D/luArOBjk0d6rkNsij0ymr0FcN/w6dn98/OdlVLL8cUXUZMIdFtBgCYoSQJGfOm04U5kMta
        3YatjYjT2HPBq9VSX
X-Received: by 2002:a0c:f990:: with SMTP id t16mr16297119qvn.134.1575300584890;
        Mon, 02 Dec 2019 07:29:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqwiflZ/75vDGfgMJ5OKhk/kspL4JpVa3xIK//K0jByQmCbTNb/IuB45oI9Mm2q6ml+h0rnrOg==
X-Received: by 2002:a0c:f990:: with SMTP id t16mr16297085qvn.134.1575300584679;
        Mon, 02 Dec 2019 07:29:44 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id v7sm16794967qtk.89.2019.12.02.07.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 07:29:43 -0800 (PST)
Date:   Mon, 2 Dec 2019 10:29:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
Message-ID: <20191128024912-mutt-send-email-mst@kernel.org>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126123514.3bdf6d6f@cakuba.netronome.com>
 <20191127152653-mutt-send-email-mst@kernel.org>
 <20191127154014.2b91ecc2@cakuba.netronome.com>
MIME-Version: 1.0
In-Reply-To: <20191127154014.2b91ecc2@cakuba.netronome.com>
X-MC-Unique: eXPGVTJENJajwtUyyI8rTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 03:40:14PM -0800, Jakub Kicinski wrote:
> > For better or worse that's how userspace is written.
>=20
> HW offload requires modifying the user space, too. The offload is not
> transparent. Do you know that?

It's true, offload of program itself isn't transparent. Adding a 3rd
interface (software/hardware/host) isn't welcome though, IMHO.

--=20
MST

