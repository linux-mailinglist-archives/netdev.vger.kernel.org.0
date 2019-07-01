Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB865C4A2
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfGAU6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:58:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAU6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:58:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KwRXU093514;
        Mon, 1 Jul 2019 20:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Sq3dAqQsD+2xQk0Qs0NpVV+nzG6KzxcI3U/S2XM2oqc=;
 b=0HMD5M7dsZr+GDIA0W/9GVc7gjvEujgXIKxsaS89w0p6hmXaS0DlWwnj+hhtkMSBuUNa
 xLHmkO3S8GewENPEvj2FTaukOtofdpKs1ihi0bELVtrt1IRNo5okcv20Ep1mkQhp0aOO
 W7uuKo/somtuegDqbDdoF6WfRx2ugFKN4bXIN9rYxaKxXeq9T+rKosYEAme9fsT3XAE+
 6htkyIRQ1vdj+5n2ZCcJP9dIdklAjtBvqoEB20eV3IZXPe5Yx6OvXCJbxBnZxSis7893
 6qmfG9VcOUL4xlHrzphA9SZrDaU+mLKwhT4da1bdeYk8bzeYZagLbQj9/TEYo8AU6YL8 GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2te5tbfx1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:58:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KvPMi002219;
        Mon, 1 Jul 2019 20:58:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tebbjd6t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:58:25 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61KwOFm016624;
        Mon, 1 Jul 2019 20:58:24 GMT
Received: from [10.211.54.238] (/10.211.54.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:58:24 -0700
Subject: Re: [PATCH net-next 1/7] net/rds: Give fr_state a chance to
 transition to FRMR_IS_FREE
To:     santosh.shilimkar@oracle.com, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <44f1794c-7c9c-35bc-dc64-a2a993d06a6e@oracle.com>
 <20190701.112751.509316780582361121.davem@davemloft.net>
 <a4834749-4aa2-7e79-dbf8-004580364a39@oracle.com>
 <95d566af-30dc-fecc-9a1b-3c8c7d69b880@oracle.com>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <b6638ee6-a8c4-5a71-28a8-7769e6e0a109@oracle.com>
Date:   Mon, 1 Jul 2019 13:58:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <95d566af-30dc-fecc-9a1b-3c8c7d69b880@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010244
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010244
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

On 01/07/2019 13.53, santosh.shilimkar@oracle.com wrote:
> LOCAL_INV/REG etc are all end being HCA commands and the command timeouts are large. 60 seconds is what CX3 HCA has for example.
> Thats the worst case timeout from HCA before marking the command
> to be timeout and hence the operation to be failed.
> 

It's a tradeoff between waiting for 60 seconds or just putting that memory-region on a drop_list.
IMO, penalizing an application with an up-to 60 seconds wait time is not necessarily the better of the 2 options.

Thanks,

  Gerd

PS: If you've got a pointer to the 60 seconds CX3 HCA timeout, please share.
