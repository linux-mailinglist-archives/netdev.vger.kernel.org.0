Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94D010AED0
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfK0LlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:41:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37744 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726204AbfK0LlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 06:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574854859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2MTh3sn/YgUzo7BT+awl8HsuGfDfwhUCejX1QPvEAw=;
        b=FZGJXLjv6yDJZMtymOFQEH7qdULTfWfquatfXiQzlSNHmZMywUcC1OaXabDiSOYvrw/Q3S
        3Vvno8vYeP8y/n7x3DbQZn6Ihj0NO9lTMazbPkTQNH55nTiFTfexbop8XezX1IKQrXOAV3
        SlB8p3vRIdJYRP7pTel2L1PwKhyOGJI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-ODNOzqU0OuWO4Oapb7g3jw-1; Wed, 27 Nov 2019 06:40:58 -0500
Received: by mail-wr1-f69.google.com with SMTP id h7so12099382wrb.2
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 03:40:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZ69cqNkgRpKOiZ3h2rwuEogSUZ9kEE8/cm9II5vyBg=;
        b=gzB3ckuXm717eRWKQ+tdpMpK80tN6joUGA+M+p+Axvlu2x4iPtp3qv3P0lxT9ks34+
         xkVSnqmq0gcAZ4TE4izhtnMOLYXBZlnL9fVd6SZrnpXtMi9cSFjYFyMO8waxnfMN/63o
         E6fu8yV8UsyKgitMKVMzp9+OsJwgtiNpZFkrpDM8XsUCxg73VBz84Il0lKUFllgD060I
         fXtt1mWlx4AvCyVeFKFGP86xt2eBNoZDc1xqxs+35ltYmyEDdo+ygxgHHeaHVkYnXgDq
         bV9ei1vvQyUsByitd5OYC+/XdsqTT33EC71PqNrUKElUGGgbmInpLqiLm9n1mMmre3NP
         lCDg==
X-Gm-Message-State: APjAAAV8Th7n/WtKYxi/gYmCTJ4toLqWXnSGX3xIn63d5CYThjOQC5cb
        wKbKvEtMOoV55gmPqa2ClaJRpK67brgxrZKlHa8h8CiwKUTXmi9r8yzSkm7BFk/nPNmVIueyADW
        AAq1LDqfZ/sm2rqQ0
X-Received: by 2002:a05:600c:2944:: with SMTP id n4mr3955910wmd.57.1574854856476;
        Wed, 27 Nov 2019 03:40:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwZ/QBEsQ+X1s4efkDz9dRO4IGVX6KoJpp1ZLnXg0uOuyaTXWEfcsMy9j8KVa0jIkfLV3LMdg==
X-Received: by 2002:a05:600c:2944:: with SMTP id n4mr3955894wmd.57.1574854856346;
        Wed, 27 Nov 2019 03:40:56 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id u14sm19057119wrm.51.2019.11.27.03.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 03:40:55 -0800 (PST)
Date:   Wed, 27 Nov 2019 06:40:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jcfaracco@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [net-next V3 0/2] drivers: net: virtio_net: implement
Message-ID: <20191127064037-mutt-send-email-mst@kernel.org>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
 <20191126.140630.1195989367614358026.davem@davemloft.net>
 <20191127063624-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191127063624-mutt-send-email-mst@kernel.org>
X-MC-Unique: ODNOzqU0OuWO4Oapb7g3jw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 06:38:39AM -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 26, 2019 at 02:06:30PM -0800, David Miller wrote:
> >=20
> > net-next is closed
>=20
> Could you merge this early when net-next reopens though?
> This way I don't need to keep adding drivers to update.


I just mean 1/2 btw. I think 2/2 might still need some work.

> Thanks,
>=20
> --=20
> MST

