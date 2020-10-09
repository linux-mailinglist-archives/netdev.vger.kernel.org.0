Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924A7289088
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390308AbgJISD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:03:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388010AbgJISD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:03:59 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099I33UP033756;
        Fri, 9 Oct 2020 14:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0EKkovHSx8gCKGgmZ9pniGfwMyqE61lxvST43ETO1Ew=;
 b=XQ5WFw9iXmCPoBQE6b+87RqM1P7Ldb6yxFtn1JEsq2xPPIuZmeZQ+H/TkqLm616vWrN+
 JK8dOTaOoLa/n0oS68UvwduCd/vCGTS1RK3Ht9O/1y2XMMsWkuX2Xk2P/0EQUA7NW2F8
 uazCZYJ6xIyHLWyb56Yd9rXbb9vc4o0aPI8N1WNvhl0lKhznjatEdBi3uDcQWMhgowTt
 4nJEEhmSClhHIJiDN8dmkTI5sufwQwtFTYzzqXFUI5aNIy6L7apb/lZMwgxYRz5lDq/G
 QA5j4Eu5RrK/ohCnCGqLYkJvNVRKogl0hlLw7tYaXqi86+IK+azqEtEzvyiuRhfeKnv6 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 342u9cautp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 14:03:54 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 099I3mC6040701;
        Fri, 9 Oct 2020 14:03:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 342u9causx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 14:03:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 099HviAC011418;
        Fri, 9 Oct 2020 18:03:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3429hm0vqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 18:03:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 099I3o5H22872476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Oct 2020 18:03:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E54B1A4054;
        Fri,  9 Oct 2020 18:03:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BF67A4065;
        Fri,  9 Oct 2020 18:03:49 +0000 (GMT)
Received: from LAPTOP-VCUDA2TK (unknown [9.145.59.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  9 Oct 2020 18:03:49 +0000 (GMT)
Date:   Fri, 9 Oct 2020 20:03:49 +0200
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ursula Braun <ubraun@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com
Subject: Re: [PATCH 1/2] net: smc: fix missing brace warning for old
 compilers
Message-Id: <20201009200349.9bad6973760905b7d452e67a@linux.ibm.com>
In-Reply-To: <20201008121929.1270-1-shipujin.t@gmail.com>
References: <20201008121929.1270-1-shipujin.t@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_09:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 clxscore=1011 mlxscore=0 adultscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 20:19:28 +0800
Pujin Shi <shipujin.t@gmail.com> wrote:

> For older versions of gcc, the array = {0}; will cause warnings:
> 
> net/smc/smc_llc.c: In function 'smc_llc_send_link_delete_all':
> net/smc/smc_llc.c:1317:9: warning: missing braces around initializer [-Wmissing-braces]
>   struct smc_llc_msg_del_link delllc = {0};
>          ^
> net/smc/smc_llc.c:1317:9: warning: (near initialization for 'delllc.hd') [-Wmissing-braces]
> 
> 1 warnings generated
> 

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

-- 
Karsten
