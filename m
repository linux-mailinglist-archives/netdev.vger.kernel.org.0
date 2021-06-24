Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0D63B2F5D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhFXMwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:52:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9772 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhFXMwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:52:10 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OClilb000737;
        Thu, 24 Jun 2021 12:49:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tTXYPVGUdsmiZlWzXn1z66pheEdsc859vJWttFTpo4k=;
 b=owzCGi5QzoM2EwzMpDAbsFdlcov4JoLSWBAmgU4FkGe8uNPum/RVs9IHKGqJ3FtO+qgP
 NWySZkTZeWXNGVF6X4XGYaez5Kv5aAPwxUB2Mcex3HFmh4RKjQOzUZl5m8IjQBjv8JS0
 T/NNGi8ni2hIfRXbFozC6/nPu4xOLX2tzHGJ8McYM/20zOU0+Rtt9AdWzTrV/7/qoH8N
 VXI/KJNmeyuEyqv3zI1NswNObeeUvRa4v+JtnJtLadJp8lis8Niof/gHDpTyqKyq+zSb
 JCeoB59LXYSpFelSXV/jLcW/ivMx0yb3EeoHbKQ7Sj51I/xZklJyX5mHr/PMQBbdSsC/ 7Q== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39c2wnjwdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:49:39 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15OClAxt133781;
        Thu, 24 Jun 2021 12:49:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 399tbvytsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:49:38 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15OCnbuY139782;
        Thu, 24 Jun 2021 12:49:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 399tbvytrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:49:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15OCnZPt015144;
        Thu, 24 Jun 2021 12:49:36 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Jun 2021 05:49:35 -0700
Date:   Thu, 24 Jun 2021 15:49:26 +0300
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
Message-ID: <20210624124926.GI1983@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
 <20210624112500.rhtqp7j3odq6b6bq@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624112500.rhtqp7j3odq6b6bq@Rk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: lipDCRF4j_xMTV666h0dItMv6AFRmmRS
X-Proofpoint-ORIG-GUID: lipDCRF4j_xMTV666h0dItMv6AFRmmRS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 07:25:00PM +0800, Coiby Xu wrote:
> On Tue, Jun 22, 2021 at 10:29:39AM +0300, Dan Carpenter wrote:
> > On Mon, Jun 21, 2021 at 09:48:59PM +0800, Coiby Xu wrote:
> > > This part of code is for the case that "the headers and data are in
> > > a single large buffer". However, qlge_process_mac_split_rx_intr is for
> > > handling packets that packets underwent head splitting. In reality, with
> > > jumbo frame enabled, the part of code couldn't be reached regardless of
> > > the packet size when ping the NIC.
> > > 
> > 
> > This commit message is a bit confusing.  We're just deleting the else
> > statement.  Once I knew that then it was easy enough to review
> > qlge_process_mac_rx_intr() and see that if if
> > ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL is set then
> > ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV must be set.
> 
> Do you suggest moving to upper if, i.e.
> 
>         } else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL && ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {
> 
> and then deleting the else statement?
> 

I have a rule that when people whinge about commit messages they should
write a better one themselves, but I have violated my own rule.  Sorry.
Here is my suggestion:

    If the "ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" condition is true
    then we know that "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" must be
    true as well.  Thus, we can remove that condition and delete the
    else statement which is dead code.

    (Originally this code was for the case that "the headers and data are
    in a single large buffer". However, qlge_process_mac_split_rx_intr
    is for handling packets that packets underwent head splitting).

TBH, I don't know the code well enough to understand the second
paragraph but the first paragraph is straight forward.

regards,
dan carpenter
