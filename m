Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB7E3B7430
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhF2OZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:25:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35396 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232518AbhF2OZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:25:02 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TEBbFv003542;
        Tue, 29 Jun 2021 14:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lLJ8lJ+tk56H2xMDeCiScxxh2TPwBGDGWp2csCN+ehU=;
 b=zCEMxeOelRRdabx2qOifO/qtwz4WOnDM+Tbn7DDZ5TysfcPL1onheT+8Xg6iNHKTI7+x
 2g4zH5EFRaz+KzpiJyLJD5McR6JwuewzGUHB1hbZLVZ9wR5RV/aqahxnCwzpWOSlWhCu
 O44Ni45qGOEjFgpQwYeiAzy9ukZIGTRNmGXzF3puHNKMwVfjo+8a7bTzaI7Gupp694pa
 hr5MSTTWq371o5P4K/b06sctntfe+OaVfVa2/Hp2mieGxQxNk8pt//HY3OoXi1+rzj3+
 ge8+H0vmT1V5vw+t8535bkc+2L5oe2CJ8DrxaInAd4hivdODlbaxzyto663aCFc3HK7A lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39fpu2hnun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:22:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TEBkCA137256;
        Tue, 29 Jun 2021 14:22:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 39dsbxydgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:22:12 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15TEJgGm164208;
        Tue, 29 Jun 2021 14:22:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 39dsbxydev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:22:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15TEM91n028443;
        Tue, 29 Jun 2021 14:22:09 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jun 2021 07:22:09 -0700
Date:   Tue, 29 Jun 2021 17:22:02 +0300
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
Message-ID: <20210629142201.GQ2040@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
 <20210624112500.rhtqp7j3odq6b6bq@Rk>
 <20210624124926.GI1983@kadam>
 <20210627105349.pflw2r2b4qus64kf@Rk>
 <20210628064645.GK2040@kadam>
 <20210629133541.2n3rr7vzglcoy56x@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629133541.2n3rr7vzglcoy56x@Rk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: Bc4mm9iE6NF56iRfHovnkM_32uIA4lV6
X-Proofpoint-ORIG-GUID: Bc4mm9iE6NF56iRfHovnkM_32uIA4lV6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*sigh*

You're right.  Sorry.

I misread IB_MAC_IOCB_RSP_HV as IB_MAC_IOCB_RSP_HS.  In my defense, it's
a five word name and only one letter is different.  It's like trying to
find Waldo.

regards,
dan carpenter

