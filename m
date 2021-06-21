Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB063AE3EC
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFUHOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:14:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51918 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhFUHO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:14:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15L7C8cC032499;
        Mon, 21 Jun 2021 07:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EQqERGEjxu/SgUzY5JPFO9RhKV43wJBMWs4lIpjFDpE=;
 b=QERhmGKlPztaucY5nM4ZCBNmt1LRLvTEPwyx135SvVViAgTYzNtm+7j/pxXyEcSW9W8c
 j1vjG2q4nHeP2Dtb6/+ujTGZs+dDdEqS5uu0p2/exwznW21Gt/aSGdzKwEoj0OCs+lzx
 aZmZfxqTscIvoZlxZw/5YEolmgPjlNZsNvhvMTDY064glhRlmDGSGsyUT8PlB0echoun
 Tik+l6JGJ7pYO6yKosAaF7aJLPwYyM3uPlXWHkhEyYwl/0JPtYyRxpCBgps1GRHVD7Qo
 ErNg3Lmayueiqv/GTvBbyI7tGSnt2CJBLFYhG0NSsZCiBFrN1/ZPRuRR9I5N8628dlzc Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39acyq8kbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 07:12:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15L7BNso028635;
        Mon, 21 Jun 2021 07:12:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3998d59ejq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 07:12:09 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15L7C9io032231;
        Mon, 21 Jun 2021 07:12:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3998d59ehj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 07:12:09 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15L7C6D0004658;
        Mon, 21 Jun 2021 07:12:07 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Jun 2021 00:12:06 -0700
Date:   Mon, 21 Jun 2021 10:11:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     subashab@codeaurora.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: fix two pointer math bugs
Message-ID: <20210621071158.GA1901@kadam>
References: <YM32lkJIJdSgpR87@mwanda>
 <027ae9e2ddc18f0ed30c5d9c7075c8b9@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <027ae9e2ddc18f0ed30c5d9c7075c8b9@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: MKak_c4ZnJtBgcj5hbueOmquQxUQqkm_
X-Proofpoint-ORIG-GUID: MKak_c4ZnJtBgcj5hbueOmquQxUQqkm_
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 01:12:09PM -0600, subashab@codeaurora.org wrote:
> On 2021-06-19 07:52, Dan Carpenter wrote:
> 
> Hi Dan
> 
> Thanks for fixing this. Could you cast the ip4h to char* instead of void*.
> Looks like gcc might raise issues if -Wpointer-arith is used.
> 
> https://gcc.gnu.org/onlinedocs/gcc-4.5.0/gcc/Pointer-Arith.html#Pointer-Arith

The fix for that is to not enable -Wpointer-arith.  The warning is dumb.

regards,
dan carpenter
