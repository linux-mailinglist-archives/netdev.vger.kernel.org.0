Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3433B5941
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 08:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhF1Gte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 02:49:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29932 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230287AbhF1Gtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 02:49:33 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15S6kuGT025434;
        Mon, 28 Jun 2021 06:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OhIoP0rxAMXrzDq3P2Ed2DiqX/EtAOszCegGoPD42RA=;
 b=pd/hR+HOtX60U4zjMJggmec1ccR+4KqdU1y7dL5nJqYIfqC3YBvBA/a9raxHnqOLonHm
 Ovn0VJF6gkhA9H8NVwo81k2PPtlytexRKamxvea3KNEma1BeVROPXIWNPDRwVxOyaLcP
 KwQOve2hM8q7u34WSUi5LpzvUUtLq6zWYiLBRryiEQDVpVxP2MAC9LhRuc72EXxXggHh
 ke7SaqqStsIs7BgD1uUj7aRYvl8zdt6TyiwYun3ke4xBtk5FKOA+a06rJdMCBP6KYbuI
 oRnPstwDG1MJ9d76A0HvwBXFwpSA5Q8ZPfIqcXn+UtV+hARAkJKx7cd/S8kY64PPnyP6 UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3g77e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 06:46:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15S6jkot170205;
        Mon, 28 Jun 2021 06:46:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 39dv23563x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 06:46:55 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15S6ksDU173358;
        Mon, 28 Jun 2021 06:46:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 39dv23563n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 06:46:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15S6krhc000999;
        Mon, 28 Jun 2021 06:46:53 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Jun 2021 23:46:53 -0700
Date:   Mon, 28 Jun 2021 09:46:45 +0300
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
Message-ID: <20210628064645.GK2040@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
 <20210624112500.rhtqp7j3odq6b6bq@Rk>
 <20210624124926.GI1983@kadam>
 <20210627105349.pflw2r2b4qus64kf@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210627105349.pflw2r2b4qus64kf@Rk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: _45IzylkndOd4vmvVv2-SalLk-aXYorF
X-Proofpoint-ORIG-GUID: _45IzylkndOd4vmvVv2-SalLk-aXYorF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 27, 2021 at 06:53:49PM +0800, Coiby Xu wrote:
> On Thu, Jun 24, 2021 at 03:49:26PM +0300, Dan Carpenter wrote:
> > On Thu, Jun 24, 2021 at 07:25:00PM +0800, Coiby Xu wrote:
> > > On Tue, Jun 22, 2021 at 10:29:39AM +0300, Dan Carpenter wrote:
> > > > On Mon, Jun 21, 2021 at 09:48:59PM +0800, Coiby Xu wrote:
> > > > > This part of code is for the case that "the headers and data are in
> > > > > a single large buffer". However, qlge_process_mac_split_rx_intr is for
> > > > > handling packets that packets underwent head splitting. In reality, with
> > > > > jumbo frame enabled, the part of code couldn't be reached regardless of
> > > > > the packet size when ping the NIC.
> > > > >
> > > >
> > > > This commit message is a bit confusing.  We're just deleting the else
> > > > statement.  Once I knew that then it was easy enough to review
> > > > qlge_process_mac_rx_intr() and see that if if
> > > > ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL is set then
> > > > ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV must be set.
> > > 
> > > Do you suggest moving to upper if, i.e.
> > > 
> > >         } else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL && ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {
> > > 
> > > and then deleting the else statement?
> > > 
> > 
> > I have a rule that when people whinge about commit messages they should
> > write a better one themselves, but I have violated my own rule.  Sorry.
> > Here is my suggestion:
> > 
> >    If the "ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" condition is true
> >    then we know that "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" must be
> >    true as well.  Thus, we can remove that condition and delete the
> >    else statement which is dead code.
> > 
> >    (Originally this code was for the case that "the headers and data are
> >    in a single large buffer". However, qlge_process_mac_split_rx_intr
> >    is for handling packets that packets underwent head splitting).
> 
> Thanks for sharing your commit message! Now I see what you mean. But I'm
> not sure if "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" is true when
> "ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" is true.

Well... It is true.  qlge_process_mac_split_rx_intr() is only called
when "->flags4 & IB_MAC_IOCB_RSP_HS" is true or when
"->flags3 & IB_MAC_IOCB_RSP_DL" is false.

To me the fact that it's clearly dead code, helps me to verify that the
patch doesn't change behavior.  Anyway, "this part of code" was a bit
vague and it took me a while to figure out the patch deletes the else
statement.

regards,
dan carpenter

