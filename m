Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED7310F805
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 07:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfLCGqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 01:46:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726521AbfLCGqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 01:46:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575355575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vA5yYzMVeAR7MX5nLItDNvtlR0z5cP32F/L2j1iptT8=;
        b=PkR9MgLuKcKF67OSNiyBGWZZjba3O6v+5bcAXZqSC9JDcYSWVr5rXmZzbVrmkiOZ17m+gK
        hrnyyf7YIVbCxGjY8+xf+V6Zkj/z9zuUh/POLmKjXxhMS/GMBRRpkPWoDglj58jgI/ONgj
        R/yPwdjCj2E8JCy+yprg0z/QoLk1BVY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-Fec3ukJmM9auJv_vPlkuNg-1; Tue, 03 Dec 2019 01:46:14 -0500
Received: by mail-qt1-f200.google.com with SMTP id l1so1721931qtp.21
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 22:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5lD9ys/e6n0/iiFHbZsselpEih6ljzAg0Ol2fd6ghc8=;
        b=NfNaXUM/EvSlmZqdQsoXxPnHnToh3BjOIIVB/fP29EPyzAgGYjkvp3QuhrRAXXXKb0
         h/cW5ztsOMjBHRhwWYET+YDMHsIHZra/0WfOoRzQ9mkF2vB9sEREYe59smBpIrO8/0Nv
         5b1LpiP+616xbxGWtY/7+eewN4by3+R2oT600D2LYZmNMfqn3wYsWtZfRq00uBeZyQye
         RNm0Wi8/7CRwCL8ZN8+Zr77A9XrYYFaPtZ/HAMOKRZzw8cLKVrkuIt9djn1cdxVAOTYL
         wqYzVDNYTmFsVINKaxcAM4tv6kpkiCfIYhJ2j+4jHLRvQD4oQ2YjQpfHJhVWZm5pMQrL
         vEtg==
X-Gm-Message-State: APjAAAWbxyH6L3jGIeA1ivdx4NuIR3WuiUBC8sWBv2PL4simw+RoW2VB
        /yUD6AeJmhJp6XntOwmU53/0tio8BGZrJpTv2ObbZu9yMha+7jUjNdufxOHvggoarumZY3NCjfN
        xbUR6FRINa9aTKnZJ
X-Received: by 2002:a05:6214:6f2:: with SMTP id bk18mr3637688qvb.10.1575355573809;
        Mon, 02 Dec 2019 22:46:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHP1tQP7g2Sng6YU0HR1cRLUHJw7uxyUQLE+cn94MbMnvnCBHBi0CW36CkABjS5928Kye+qQ==
X-Received: by 2002:a05:6214:6f2:: with SMTP id bk18mr3637672qvb.10.1575355573480;
        Mon, 02 Dec 2019 22:46:13 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id v143sm1222002qka.3.2019.12.02.22.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 22:46:12 -0800 (PST)
Date:   Tue, 3 Dec 2019 01:46:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Martin Habets <mhabets@solarflare.com>
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [net-next V3 1/2] netdev: pass the stuck queue to the timeout
 handler
Message-ID: <20191203014532-mutt-send-email-mst@kernel.org>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
 <20191126200628.22251-2-jcfaracco@gmail.com>
 <c2cddeea-8a6e-f0b9-1fde-7d2a29538518@solarflare.com>
MIME-Version: 1.0
In-Reply-To: <c2cddeea-8a6e-f0b9-1fde-7d2a29538518@solarflare.com>
X-MC-Unique: Fec3ukJmM9auJv_vPlkuNg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 03:11:51PM +0000, Martin Habets wrote:
> Your @work correctly identifies that the drivers/net/ethernet/sfc drivers=
 need patching, but the actual patches for them are missing.
> Please add those. Makes me wonder if any other files are missing patches.
>=20
> Martin

Good point, pattern was missing _ in variable name. Will repost a
fixed version.

