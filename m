Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49581105DE0
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVAyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:54:36 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34323 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVAyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:54:36 -0500
Received: by mail-qv1-f68.google.com with SMTP id n12so2249113qvt.1;
        Thu, 21 Nov 2019 16:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EPQAEqBFNpkDyyTK+R9WPTLjmSkdfSxe7vIkaj9qO1I=;
        b=Kqc6NQKeFqK45usUnJ0MSuILDlZ+3IXLesAys1Ix1KWiF5+GI3jN5vTI9pFbokkh6x
         Z8pz9hn+UCIKozNwRwxXagR8jI8vM5/ljKCVSvxjCwvq/ZTFTYo0JfORxNkzAZGXwKEM
         GgiCRcrf2TJhNePmxcKrKjkn14Wns0m9wDrzdhCMTA5L9exOjEOmMALqdFYxBdiUf56h
         aPK5alvOQ7f4WCuBCQi1jaKr8hDPwnnzo8HMj2oAt/GF6P5f/bvGrxHIo3ARIKzYuF/c
         VznYGsZwzUzKkQEtCx2NdU55X3Xn6phDfMPQ+1uzMRDOdkoph+9XWtQhjEHndmWNY5KD
         Ry5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EPQAEqBFNpkDyyTK+R9WPTLjmSkdfSxe7vIkaj9qO1I=;
        b=UIB0RmYWT6Uin8FsaR2LHkxolq+noY6cde+quAHI8fmwAWIK5ko3n+vKKiLxvcjmnr
         4vKBPNHWw2Zclwj8ewxFns96/TrqbPVbFlTlb/Yf9ePk+Lpdsun6ntblc1QuU8sbLL/u
         Rz7jcXszARLwM8av9csJnd9U1ZDC533golFx3otjHY0qOBFNXDDUElJ7pRskh2bKkiYo
         cMAH3oyQDcyp2lwdP3Jv8MYx2g+lC1eUhoKlgtiWNtaXpkAd3pMmkkUX7tCYP7Hwue3I
         Iyv+jKyI97IclTSgfS60Pyg2EeJVUXen/MAZxkyDbADJ3upEEbpy4/ka2xfj/FmhkHeX
         cajA==
X-Gm-Message-State: APjAAAVuInnNcHbEogvwAH6rFiMINj1htQkem4xxjlAkt1rHlF7AKr0v
        +a9+1IYh0iar+kxhH5sQwGoKXXUA
X-Google-Smtp-Source: APXvYqzzVIsMw+6PPWPqn0YKP551Jn/0Io+mxPjxk6HcDTnHAv1Mia7EtVFVwotM3m7LbXQKWuO31w==
X-Received: by 2002:a0c:ee41:: with SMTP id m1mr11206534qvs.201.1574384073348;
        Thu, 21 Nov 2019 16:54:33 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id r8sm2529598qti.6.2019.11.21.16.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 16:54:32 -0800 (PST)
Subject: Re: [PATCH rdma-next 1/4] net/core: Add support for getting VF GUIDs
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20191114133126.238128-1-leon@kernel.org>
 <20191114133126.238128-3-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0e99c61b-ee89-a2cb-6f7a-b0ab5d06249c@gmail.com>
Date:   Thu, 21 Nov 2019 17:54:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191114133126.238128-3-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 6:31 AM, Leon Romanovsky wrote:
> From: Danit Goldberg <danitg@mellanox.com>
> 
> 
> Introduce a new ndo: ndo_get_vf_guid, to get from the net
> device the port and node GUID.
> 
> New applications can choose to use this interface to show
> GUIDs with iproute2 with commands such as:
> 
> - ip link show ib4
> ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
> link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
> spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off
> 
> Signed-off-by: Danit Goldberg <danitg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  include/linux/netdevice.h |  4 ++++
>  net/core/rtnetlink.c      | 11 +++++++++++
>  2 files changed, 15 insertions(+)
> 


LGTM

Acked-by: David Ahern <dsahern@gmail.com>


