Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D310B717
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK0T64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:58:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55739 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbfK0T64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:58:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574884734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4tGDBi5zjoUswRrgwv5c3aU+wWyuxHCnduBquwVclQ=;
        b=bXCwWe23VSfKqXXfGsLdpks2l2Dqq65dewPpDj2mDFxKuCcFi/tAEaw0X7Ua4w664z9Kwh
        tZyjNGNU4y2/564liKRzMbN1YQtmqtFPIYyr5PXs6G3Lpnm01Y+0bvfeaH+xziWhxEe2Mt
        YmWa3D9pejAQnRa2vFMT+eLD6/t30tg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-fpzx8EesMweenfF1_enilQ-1; Wed, 27 Nov 2019 14:58:53 -0500
Received: by mail-qv1-f70.google.com with SMTP id q20so3011990qvl.21
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 11:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w7lbDjreCJ/+n3nZbRY5zssEIPogdb2ZU5R4OKVip7Q=;
        b=KO4lE0WIm+xYSnomO8YkLJjO+FncOkZ3uRitiu2qaGA0QkKjCr1QU4k0hcRdaoNdUy
         W6xe2BqN0YaZ9wNxKCagpf+fhI6j7d1pFbT6V6I9bWmNLGUKTJOhuZ9gaCARmjpRI9ZL
         scm5slc6A3edKss0iA/oo82mdgg0zH8ogvN4GV5Rmx1saOSm5UNPVb4c4UWqVlk4+O+M
         ag3/iEEYZMfd0jSWXtZA2HNtnirY+vieQrDuwKgSeUjWNiJ6Zl6YGH7vA5t7BFCtxrz7
         iH8trG47UiWHIuLifbnRjzo/g4Taft5R6SD4DUGaw4AMRBUus3LndoVbStlrrcGBXrrf
         Eaow==
X-Gm-Message-State: APjAAAXgZDexrC+hrYIM10ZEnAdZmp+q4wKzA33XIj73AkQzo+9he+Gl
        gVOg/EVu8f/BEPxaCg5Dwg/UEIos8lQWGMMvWxtCZnGNpsbyS5760QTF0yrsx4o4SCVFbsBrc6R
        H68Ll2vesXY94DdVi
X-Received: by 2002:ac8:7550:: with SMTP id b16mr42375282qtr.286.1574884732213;
        Wed, 27 Nov 2019 11:58:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqyp1uYljGzQNQj1GUOP8o1QRLYz3GJR/t9h5oKrZE1r3QICK2aYBTYfj0ZMQGR+d/lwG3YesQ==
X-Received: by 2002:ac8:7550:: with SMTP id b16mr42375271qtr.286.1574884731992;
        Wed, 27 Nov 2019 11:58:51 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id 97sm8245913qtb.11.2019.11.27.11.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 11:58:51 -0800 (PST)
Date:   Wed, 27 Nov 2019 14:58:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jcfaracco@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [net-next V3 0/2] drivers: net: virtio_net: implement
Message-ID: <20191127145831-mutt-send-email-mst@kernel.org>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
 <20191126.140630.1195989367614358026.davem@davemloft.net>
 <20191127063624-mutt-send-email-mst@kernel.org>
 <20191127.105956.842685942160278820.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191127.105956.842685942160278820.davem@davemloft.net>
X-MC-Unique: fpzx8EesMweenfF1_enilQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:59:56AM -0800, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Wed, 27 Nov 2019 06:38:35 -0500
>=20
> > On Tue, Nov 26, 2019 at 02:06:30PM -0800, David Miller wrote:
> >>=20
> >> net-next is closed
> >=20
> > Could you merge this early when net-next reopens though?
> > This way I don't need to keep adding drivers to update.
>=20
> It simply needs to be reposted this as soon as net-next opens back up.
>=20
> I fail to understand even what special treatment you want given to
> a given change, it doesn't make any sense.  We have a process for
> doing this, it's simple, it's straightforward, and is fair to
> everyone.
>=20
> Thanks.

Will do, thanks.

