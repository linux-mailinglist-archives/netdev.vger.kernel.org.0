Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1DC220EA5
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgGOOB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:01:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgGOOBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 10:01:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FDuwVl027967;
        Wed, 15 Jul 2020 14:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9BvVf4ov8y9GNDgXx7dmL5UHFwADFLA8MOMmd0Derfs=;
 b=hetpCsZ9hxOQ13W2sDw2HPpmDM2481hzxMgBR5h0DIIIK+G39urlQacO2ec8rOCqvZRn
 KxAJmjUxxSTmnAAGxtl9NPn86YvxPmJGgYFnt8zoKiRY9XWhLoSS9HofgZDd7PRqs6S6
 XSgFZwapCRr0gu3BvYtjW9WZF0hf5aw1HO+KqdjAa93AFntV3ELna4PJ13RrNFBlRxLm
 sAAfiHHF+6RapvUlBQajjOsIC2OG6RitB3siI2Iv+lhMUQ+jzvy1hJLvneCI0tGxjvm2
 zCWIgWDXnxtYINTex5s81VYy1qp4/IVqlWmob3TtOrrzBZYl/ymeCw2ecVZohhgxgE+J lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cmbj1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 14:01:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FDvcdf040076;
        Wed, 15 Jul 2020 14:01:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb7p48k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 14:01:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FE1mtY012527;
        Wed, 15 Jul 2020 14:01:48 GMT
Received: from [10.39.239.123] (/10.39.239.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 07:01:48 -0700
Subject: Re: [PATCH 1/1] ax88172a: fix ax88172a_unbind() failures
To:     David Miller <davem@davemloft.net>
Cc:     dan.carpenter@oracle.com, kuba@kernel.org, dhaval.giani@oracle.com,
        netdev@vger.kernel.org
References: <20200714080038.GX2571@kadam>
 <20200714.140323.590389609923321569.davem@davemloft.net>
 <b7423f65-53d5-35d7-a469-509163c85853@oracle.com>
 <20200714.143731.1428321936444887200.davem@davemloft.net>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
Message-ID: <be3a5564-00ee-cdb0-866e-084c41965a82@oracle.com>
Date:   Wed, 15 Jul 2020 10:01:45 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714.143731.1428321936444887200.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=2 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2020 5:37 PM, David Miller wrote:
> From: George Kennedy <george.kennedy@oracle.com>
> Date: Tue, 14 Jul 2020 17:34:33 -0400
>
>> For example, the failing case here has "ret" = 0 (#define ETH_ALEN 6):
>>
>>      172 static int ax88172a_bind(struct usbnet *dev, struct
>> usb_interface *intf)
>>      173 {
>> ...
>>      186         /* Get the MAC address */
>>      187         ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0,
>> ETH_ALEN, buf, 0);
>>      188         if (ret < ETH_ALEN) {
>>      189                 netdev_err(dev->net, "Failed to read MAC
>> address: %d\n", ret);
>>      190                 goto free;
>>      191         }
>> "drivers/net/usb/ax88172a.c"
> Then this is the spot that should set 'ret' to -EINVAL or similar?

Made the suggested fix and sent the updated patch with following:

Subject: [PATCH v2 1/1] ax88172a: fix ax88172a_unbind() failures

George

