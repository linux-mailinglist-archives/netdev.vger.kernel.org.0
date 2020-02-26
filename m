Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99516FAC7
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBZJdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:33:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726764AbgBZJdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582709579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQgTIEekebr7M7QEl8o/zFLUAsmKAq6AQb+bi+hw7MM=;
        b=CWMYlT7V+Y7/Xbz2s2M8bBIQyY6tBFxpvzZoZbYdlfrtM7D13IBmWlITYrBREQ20aiLcoS
        Edcot5jYqtzdlfJD+wDM6Li6pTKjGwJNDXVfJeq9dVo84606pkLBq+5QvqsDiES1wpT6iB
        JX+hBBqLJa/tn9FY+NOgj6kWv8b3mXM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-BN8cZfQkNiSwUWMG-VYemg-1; Wed, 26 Feb 2020 04:32:54 -0500
X-MC-Unique: BN8cZfQkNiSwUWMG-VYemg-1
Received: by mail-qt1-f200.google.com with SMTP id f25so3205658qtp.12
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 01:32:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NQgTIEekebr7M7QEl8o/zFLUAsmKAq6AQb+bi+hw7MM=;
        b=MYACZdGwHPWipr5Ofa7q+13djDaw74ewDDOf1hyeUP8BU+rFULLt+Kn1XaKmcLiTbw
         MUW2GSFK9MFGq1/SYLMBktkQc8qpzrQLrsz7sKYrQ1Hsgy1viWtq3A7KFEVi53Li7L85
         QG2yPXwV3wl8+ARyw1+aAbozKWQbDcNTi7ijFVbQ3QkNxlEgGYV1mpuPvalBdoseYq5g
         BI5jISH2z8pwuIdhYNiqeGqu5J4iFG/5cBbsC2DPpi8i5S+fKsb8Glbyi6KPyEy0u4/W
         BS/hk760kZ+73RLF3/DiPZaL1HLWOj5JUpudDdH8AKMIpZ63GlB/ef0kzYNx3QIetO6H
         mn8g==
X-Gm-Message-State: APjAAAXpuULEbgMJqKDO2h3VQxSECUC/iecHEdeh7PGyIPGHydmvlIMo
        O9eug6Bw4CWo6ISaZswYbRliInGyR6fvM4FqzsGw4P5MH1oZcXQh5g8tSQDlowI1iGFbo2/ZFyb
        oQxpZaiMFPOQDpnjB
X-Received: by 2002:a37:8683:: with SMTP id i125mr4690660qkd.491.1582709573595;
        Wed, 26 Feb 2020 01:32:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxllHPVgVJKCXVIepL36PQ6oXaUdONXf2PjWGvwZrHhoQ5Xp9mcXh8e/k+EDZmLDQM/aQJ2oA==
X-Received: by 2002:a37:8683:: with SMTP id i125mr4690630qkd.491.1582709573296;
        Wed, 26 Feb 2020 01:32:53 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id w60sm792453qte.39.2020.02.26.01.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 01:32:52 -0800 (PST)
Date:   Wed, 26 Feb 2020 04:32:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226043219-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org>
 <87r1yhzqz8.fsf@toke.dk>
 <20200226034004-mutt-send-email-mst@kernel.org>
 <87o8tlzppw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8tlzppw.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 10:02:03AM +0100, Toke Høiland-Jørgensen wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > On Wed, Feb 26, 2020 at 09:34:51AM +0100, Toke Høiland-Jørgensen wrote:
> >> we already do block some reconfiguration if an XDP program is loaded
> >> (such as MTU changes), so there is some precedence for that :)
> > Do we really block MTU changes when XDP is loaded?
> > Seems to work for me - there's a separate discussion going
> > on about how to handle MTU changes - see
> > https://lore.kernel.org/r/7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com
> > 	virtio_net: can change MTU after installing program
> 
> Maybe not for virtio_net, but that same thing doesn't work on mlx5:
> 
> $ sudo ip link set dev ens1f1 mtu 8192
> RTNETLINK answers: Invalid argument
> 
> -Toke

Let's take it to that thread please. I'll CC you.

-- 
MST

