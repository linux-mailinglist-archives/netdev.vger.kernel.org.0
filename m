Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704F314651F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 10:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgAWJyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 04:54:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728799AbgAWJyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 04:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579773240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T+Gr5UZzqUm/R1DdhVa+YySUu4oLR4o8dZsB4KvLRbo=;
        b=AkbcIXtKLQgRJV8BR8wakDKI98K8D5gR/ljfaM7fvEuhD+Mdy0W5uIMIvB1O5pLSTPziEp
        g+PNnc7FRB2iSisvWrjDRx2Vrc7glSvbY3poxgIeuZg21BckeVilXHdg/3kMoklEOrZweK
        5EoepFNLFQFiiBKeLoiBZfphIpFaMqE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-TYYVt9F4PF62mLo8cf068g-1; Thu, 23 Jan 2020 04:53:58 -0500
X-MC-Unique: TYYVt9F4PF62mLo8cf068g-1
Received: by mail-lf1-f72.google.com with SMTP id x5so373917lfe.6
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 01:53:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=T+Gr5UZzqUm/R1DdhVa+YySUu4oLR4o8dZsB4KvLRbo=;
        b=tvuTpfCTx63U3XgqYJMpjIyxBFuqCdN/NC64CqM46cXfC1Rh2yyq9bmAAYx926qtTy
         9b3J2cwYJevp10YIYwnZlHdIsz/CjXzYFZ57csvp6JK7HPBeQwGQs+oNXj6pLDMq5jOm
         0d9oUgF942nyKuLfqjcsz1QpzK7YfcB7C+w6eu1UhikzLN9rVC3Nlou8MmW7CC1gRndB
         ObLTaSPh5X0RtKZLKdoXKLU44ox+FIDcRsaIk8glTHLbi+zVMCdZxxeOyXEIE51TjCZc
         OoqDWlTXFN+SI51yEEfQlS/sivh9ALRix1XFdO9WngkV7MRSf2PLkEpL3ziNEsRvnS5L
         oYOw==
X-Gm-Message-State: APjAAAXI73ZfKgAVoUpUtbTAn0Y+LncD5FDoHksumtudJ2g+gqXNOcpH
        XoLXdXL3XsyV3FoRsTaqYGKtJJDaf1zTpCZkfUxeOhzRsvdhWeMMK3k67On9mV1L9i+V/4uKAg2
        +aAo6zHAHDhFZRFZd
X-Received: by 2002:a19:48c5:: with SMTP id v188mr4354681lfa.100.1579773237392;
        Thu, 23 Jan 2020 01:53:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUJyqIx5m7u22SP1H3NdA6eZIT/KptNIdqSSuYsXsRF1TmEQrGrVCbh7oDYmzC/97QvKAKWQ==
X-Received: by 2002:a19:48c5:: with SMTP id v188mr4354671lfa.100.1579773237171;
        Thu, 23 Jan 2020 01:53:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r12sm873727ljh.105.2020.01.23.01.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 01:53:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7EDD41800F2; Thu, 23 Jan 2020 10:53:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <20200122203253.20652-1-lrizzo@google.com>
References: <20200122203253.20652-1-lrizzo@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 10:53:51 +0100
Message-ID: <875zh2bis0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> Add a netdevice flag to control skb linearization in generic xdp mode.
> Among the various mechanism to control the flag, the sysfs
> interface seems sufficiently simple and self-contained.
> The attribute can be modified through
> 	/sys/class/net/<DEVICE>/xdp_linearize
> The default is 1 (on)

Erm, won't turning off linearization break the XDP program's ability to
do direct packet access?

-Toke

