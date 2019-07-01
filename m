Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F355C432
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfGAUQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:16:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAUQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:16:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KDcac152954;
        Mon, 1 Jul 2019 20:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wbyhRpK5X7IDyWWw0TQa3oXL37AH0TSMThOIA/oncL0=;
 b=IYPNj7FDvfLtgzcF4InzM+ChpeFb2PdQ5tzSckOb8oktc46vB4+o5YjSyQ2dmf2xGtJO
 OLn2BUjCcOl2ZJndcnt/lCchzS8ytxea28stXCUTzTBJg+RVeSXRNllur1jJmsRD7L/v
 PIQPc60alTPkqcNz06Y6ox53fgmZ0lHZVjX4Ieou6Q4TX1trXy5tuDcLNylbkxLrMgB5
 y+asx9aXKssTS8+IuxA83hT0MkSKKMcVxpj9P3uWLLPchiXcCXEktsg3L6bgMQ1jHnYB
 +55F9FkMUEl76PXO+Yu/digaCuE8lqXTtFmKtVmPOyqtXKMQi125rcLeZLj+iY1WMJOX DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61dyr27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:16:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KD4q8087783;
        Mon, 1 Jul 2019 20:14:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tebktvmwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:14:41 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61KEeod025169;
        Mon, 1 Jul 2019 20:14:40 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:14:40 -0700
Subject: Re: [PATCH net-next 4/7] net/rds: Fix NULL/ERR_PTR inconsistency
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <9f46098a-bcc7-bc0e-20db-2cbf05fefdee@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <c090ec92-1ae4-e487-fed1-f5efa270192c@oracle.com>
Date:   Mon, 1 Jul 2019 13:14:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <9f46098a-bcc7-bc0e-20db-2cbf05fefdee@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:39 AM, Gerd Rausch wrote:
> Make function "rds_ib_try_reuse_ibmr" return NULL in case
> memory region could not be allocated, since callers
> simply check if the return value is not NULL.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Looks good to me. Will add this to other fixes.
