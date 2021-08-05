Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5523E141F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241120AbhHELvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:51:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54738 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241116AbhHELvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:51:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175BXR3B100094;
        Thu, 5 Aug 2021 07:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=446wwEmq1DAA0zb5B/LS/a4Q2zxSuWc7pxhRgHEmZNA=;
 b=PQXN+Qk9jlsVP7gUqbx6wCZQVU15UzEl23CQdYm45QZcDizZGul8BrCYd0zFyql/H0ON
 d6DanP86erqZQWBCxwklhXhEVOhQ3GsOZXHJzeqJqzq9A2dbXOnapCHJLlcPcgaH2OXD
 MfEesqimEHngjl7pOJOYx1TUo3nhmS5gYCMfjeYwPNAmf6HTt1T2fhv2D+vJgxvA0aRj
 HiBpPt+AUuSAbttKDJ+/ydcSwsRy/x9SwQEofdGSwLb/DIJaj/kZZikQIHyjBOPRiCvf
 lwIpVqY4lzyDYtU3Q25PI3OBNT0p/K8cQb9HMI42m0Zs6e51smpTZyASPjhza+rZ3LY7 yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7b796ykg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 07:51:07 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 175Bg1GS135604;
        Thu, 5 Aug 2021 07:51:06 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7b796yjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 07:51:06 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 175BlgQJ011127;
        Thu, 5 Aug 2021 11:51:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3a4x59354r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 11:51:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 175Bp2lN56492370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 11:51:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 962F1A4064;
        Thu,  5 Aug 2021 11:51:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14F3A4060;
        Thu,  5 Aug 2021 11:51:01 +0000 (GMT)
Received: from [9.145.20.243] (unknown [9.145.20.243])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Aug 2021 11:51:01 +0000 (GMT)
Subject: Re: [PATCH net-next 4/4] ethtool: runtime-resume netdev parent in
 ethnl_ops_begin
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <05bae6c6-502e-4715-1283-fc4135702515@gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <89f026f5-cc61-80e5-282d-717bc566632c@linux.ibm.com>
Date:   Thu, 5 Aug 2021 14:51:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <05bae6c6-502e-4715-1283-fc4135702515@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RmGMuRV5Vq8yaikeyMIZhmeZwCrhoWK9
X-Proofpoint-ORIG-GUID: bsKC0Lmw4w9_RZpUSWwNkRYlvx-21Wy1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxlogscore=976 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.21 13:41, Heiner Kallweit wrote:
> If a network device is runtime-suspended then:
> - network device may be flagged as detached and all ethtool ops (even if not
>   accessing the device) will fail because netif_device_present() returns
>   false
> - ethtool ops may fail because device is not accessible (e.g. because being
>   in D3 in case of a PCI device)
> 
> It may not be desirable that userspace can't use even simple ethtool ops
> that not access the device if interface or link is down. To be more friendly
> to userspace let's ensure that device is runtime-resumed when executing the
> respective ethtool op in kernel.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  net/ethtool/netlink.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
> 

[...]

>  
>  void ethnl_ops_complete(struct net_device *dev)
>  {
>  	if (dev && dev->ethtool_ops->complete)
>  		dev->ethtool_ops->complete(dev);
> +
> +	if (dev->dev.parent)
> +		pm_runtime_put(dev->dev.parent);
>  }
>  
>  /**
> 

Hello Heiner,

Coverity complains that we checked dev != NULL earlier but now
unconditionally dereference it:


*** CID 1506213:  Null pointer dereferences  (FORWARD_NULL)
/net/ethtool/netlink.c: 67 in ethnl_ops_complete()
61     
62     void ethnl_ops_complete(struct net_device *dev)
63     {
64     	if (dev && dev->ethtool_ops->complete)
65     		dev->ethtool_ops->complete(dev);
66     
>>>     CID 1506213:  Null pointer dereferences  (FORWARD_NULL)
>>>     Dereferencing null pointer "dev".
67     	if (dev->dev.parent)
68     		pm_runtime_put(dev->dev.parent);
69     }
70     
71     /**
72      * ethnl_parse_header_dev_get() - parse request header
