Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C12728908A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390328AbgJISES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:04:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4988 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731771AbgJISES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:04:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099I2wsp123233;
        Fri, 9 Oct 2020 14:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vw4gx5k6KMrv8IODdBnIS3HtpuS+J3XDtlLQZIByiEw=;
 b=Asqt5dJF461LjFBjcsjlB7cYlat9IFUPul8ebkY3IoIaLN7B/RbJOePzmu+jW/7ekoo3
 zUXnUuf6G3P1T+jzrgsG88Y6AD4c4BcAMnw15XDto33Y1bpyr25kQqIm0AshDvjUbyjy
 KmRYY73t3RRxxHMdu6LLX99StAEIiVfxy/U5/8oxTSe4hXXs/dSp3ZjJSEXy8fAiRl0Y
 DRVF9Brc5xBiR8tHsJlGcJnvauCcdtjkN5tmPtxlXv31oEvVmv5VEMVSOp/kbcpJKWcX
 NgXUBmmbdTKR2M9CVamyKaSh2Rq/2uY9ZicOlYUMK3wPPbW4yAI4rAT/OybuVnZ0Zxxb Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 342vma099u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 14:04:14 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 099I2wLC123228;
        Fri, 9 Oct 2020 14:04:13 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 342vma0996-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 14:04:13 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 099HukJj028598;
        Fri, 9 Oct 2020 18:04:12 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3429h9rf2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 18:04:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 099I49hu30671264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Oct 2020 18:04:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEB4FA405C;
        Fri,  9 Oct 2020 18:04:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BA82A405B;
        Fri,  9 Oct 2020 18:04:09 +0000 (GMT)
Received: from LAPTOP-VCUDA2TK (unknown [9.145.59.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  9 Oct 2020 18:04:09 +0000 (GMT)
Date:   Fri, 9 Oct 2020 20:04:08 +0200
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ursula Braun <ubraun@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com
Subject: Re: [PATCH 2/2] net: smc: fix missing brace warning for old
 compilers
Message-Id: <20201009200408.35d9575b2813afb57015ec7e@linux.ibm.com>
In-Reply-To: <20201008121929.1270-2-shipujin.t@gmail.com>
References: <20201008121929.1270-1-shipujin.t@gmail.com>
        <20201008121929.1270-2-shipujin.t@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_09:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 20:19:29 +0800
Pujin Shi <shipujin.t@gmail.com> wrote:

> For older versions of gcc, the array = {0}; will cause warnings:
> 
> net/smc/smc_llc.c: In function 'smc_llc_add_link_local':
> net/smc/smc_llc.c:1212:9: warning: missing braces around initializer [-Wmissing-braces]
>   struct smc_llc_msg_add_link add_llc = {0};
>          ^
> net/smc/smc_llc.c:1212:9: warning: (near initialization for 'add_llc.hd') [-Wmissing-braces]
> net/smc/smc_llc.c: In function 'smc_llc_srv_delete_link_local':
> net/smc/smc_llc.c:1245:9: warning: missing braces around initializer [-Wmissing-braces]
>   struct smc_llc_msg_del_link del_llc = {0};
>          ^
> net/smc/smc_llc.c:1245:9: warning: (near initialization for 'del_llc.hd') [-Wmissing-braces]
> 
> 2 warnings generated
> 

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

-- 
Karsten
