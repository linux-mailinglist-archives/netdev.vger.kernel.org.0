Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916BA3AFDE4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFVHcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:32:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25820 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhFVHcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:32:14 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7HOjb003662;
        Tue, 22 Jun 2021 07:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aRf6xLnEm9+6xp3u9Dzr2nAls6BZEoFl3WU5DBo6Ixg=;
 b=suzrBd7rPalCuds3MHmqbx3AsBazlvoH7cXkZ9uGoX2WMCuqRHu/uK4HEdxJAR/c7pbZ
 zbMwnXs2TR/P+Z4fcmfraFzLFbOEjX/d6MpI6XNliJDbPmJyxDexb6fJlq/WIstSP0OJ
 UuwhdCdmvUXXBasYlksglmsa6VcTw+m7fIbfaA5bVQjZz3hxTvg9DD6Hlu4rYPb11LqX
 k1Gfrgoic8lI4K2tuPkkindRZNqi3eVExAR7sI5Od34Piezopv8IH5ZHe9Cf7NpNnkF/
 j1q+dAQhx5b2FGwd7mSnGWvvBff8ZDAt4qAhFi6tgzOAVFG6HMJEqkzAA9/u09G2nW/t pw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39aqqvtavs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:29:51 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15M7GuLw130836;
        Tue, 22 Jun 2021 07:29:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3996md05k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:29:50 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15M7Tn3T172152;
        Tue, 22 Jun 2021 07:29:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3996md05jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:29:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15M7Tm4A020374;
        Tue, 22 Jun 2021 07:29:48 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jun 2021 00:29:47 -0700
Date:   Tue, 22 Jun 2021 10:29:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 16/19] staging: qlge: remove deadcode in qlge_build_rx_skb
Message-ID: <20210622072939.GL1861@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-17-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: H8brXNyokHDH6HQjjU4sfR0IX4u4SXte
X-Proofpoint-GUID: H8brXNyokHDH6HQjjU4sfR0IX4u4SXte
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 09:48:59PM +0800, Coiby Xu wrote:
> This part of code is for the case that "the headers and data are in
> a single large buffer". However, qlge_process_mac_split_rx_intr is for
> handling packets that packets underwent head splitting. In reality, with
> jumbo frame enabled, the part of code couldn't be reached regardless of
> the packet size when ping the NIC.
> 

This commit message is a bit confusing.  We're just deleting the else
statement.  Once I knew that then it was easy enough to review
qlge_process_mac_rx_intr() and see that if if
ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL is set then
ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV must be set.

regards,
dan carpenter

