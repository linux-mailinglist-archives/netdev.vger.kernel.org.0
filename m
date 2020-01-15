Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CF713BCA8
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgAOJpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:45:16 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:46736 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbgAOJpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 04:45:16 -0500
Received: by mail-wr1-f53.google.com with SMTP id z7so14997713wrl.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 01:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dFBhTHpC7CyrTauKs7b51rFwl6gHvh8r009ho3+H9fQ=;
        b=u6hV/8oBm+tdQ7sbOfXVu0x+ho3/Sts/R2w5dgZ96hvOfDyTCg8Rp6K/aKLIME5IrR
         py6kCCfWZpNaNb8oIgIQ7a7pvYJEKzwjT2j4puNj+MRZLN0VFx32bJraQ1LdUe2Bo1rM
         t6X1Z7FbnlGGRDIe+G3+wGVN5CretzD1xiZXIgLWcKQ2Wu1bT5nYq5GN+HJrHyQZ5KE7
         iDRY+0GGW/IeLvkJqNN+mMtKN+0+osnEdjtakZHoSdmut30U9/eJwHjg8sNg6xFUFkga
         EgJG9YRtR2ZTDnhqBcCziPIihGiNU48LSueKH2EDtMWYLzM8S/sCa5k7FE9TBDZe2HVU
         OCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dFBhTHpC7CyrTauKs7b51rFwl6gHvh8r009ho3+H9fQ=;
        b=KQO2NixgNnDKguPZTrrMr1dlY/iQEzOlwwXHWWGMgEcbEiDmieg7BTW3qc+U/c+Vlu
         purdlBHFoeVeqrbtNbRedjimc+y6XvQtlSj4PWt8i9PUd3oob/ezt9eP9/mtn6I1HnoR
         WRlTtVVtCM/Z+fh6WS8//DBwZJpLVXj2G3lKdR9I3qzZADB8O03zXRLfWTdqhrp/iB6g
         /a4gjYMGYQr7BpCaGOaXLPUtGyBPER3EOzWOE0jD6I4Xxy3StS3pnYW5wrmr3fKt14mw
         XRR8fFhjV2fl9FTVxHzSTG4fVXSuv423WLY5wyS4N59L9KQr/0UEO7J/gyJVbwtfnzLy
         aZmg==
X-Gm-Message-State: APjAAAU19cqQuum3FFU7k5l3oHPqhdERUAXNzerToDGTCnqguSabH8cv
        nFJo9q3F1x4EQ4O8H7geKz74YG8F/H8=
X-Google-Smtp-Source: APXvYqztS3LY6iYuZu7XZSL7rjWRk1i52nzEyV8djbsISOhmBoWLC6Z2KJc3ol/kaJDNoYdX76wHAw==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr30647004wrw.132.1579081514449;
        Wed, 15 Jan 2020 01:45:14 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id z83sm23375845wmg.2.2020.01.15.01.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 01:45:14 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:45:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Message-ID: <20200115094513.GS2131@nanopsycho>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 15, 2020 at 09:01:43AM CET, maorg@mellanox.com wrote:
>RDMA over Converged Ethernet (RoCE) is a standard protocol which enables 
>RDMA’s efficient data transfer over Ethernet networks allowing transport 
>offload with hardware RDMA engine implementation.
>The RoCE v2 protocol exists on top of either the UDP/IPv4 or the 
>UDP/IPv6 protocol:
>
>--------------------------------------------------------------
>| L2 | L3 | UDP |IB BTH | Payload| ICRC | FCS |
>--------------------------------------------------------------
>
>When a bond LAG netdev is in use, we would like to have the same hash 
>result for RoCE packets as any other UDP packets, for this purpose we 
>need to expose the bond_xmit_hash function to external modules.
>If no objection, I will push a patch that export this symbol.

I don't think it is good idea to do it. It is an internal bond function.
it even accepts "struct bonding *bond". Do you plan to push netdev
struct as an arg instead? What about team? What about OVS bonding?

Also, you don't really need a hash, you need a slave that is going to be
used for a packet xmit.

I think this could work in a generic way:

struct net_device *master_xmit_slave_get(struct net_device *master_dev,
					 struct sk_buff *skb);

