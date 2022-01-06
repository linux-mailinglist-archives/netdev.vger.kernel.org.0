Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26188486292
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbiAFKAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:00:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236540AbiAFKAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 05:00:22 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2067BaLf012346;
        Thu, 6 Jan 2022 10:00:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SDJWgGctbuYhUnOsL3nfXe6Xk0un0bxz1Ugrkwlp8Kk=;
 b=tsWp+sE+yIRX0ylYthW7VbAZCeCBTL+/NfVQrfqfB/gAzXpbNnHqEjriVZqsGn2+GaZM
 UNxcTP6o58/1WhkIxidFkYnrMVHlm2ofJWTfEL9ZArhCAwHDIWwTh/WqBuEv4W2guFET
 bdMFMVRQHvOsTKR40XaEtUQWrwJ72wbE0UL02kxNp2jBD/whwABKZO3tDmKG1qiQJ+Qq
 5YFzlxSBEallvNNCaV3od0rWxNNqAeu63fnTXO5v+cPhxN+Q+TVK4G0AT/0cdO1PvanH
 Co9p4vey/Kab0N5WiRXgtHE2+xm5BoCK+tEQCf7DkEQ53O1+D18nZuL7KaUHOggtw6CI WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ddutpjnd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 10:00:15 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206A0Eht006113;
        Thu, 6 Jan 2022 10:00:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ddutpjnbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 10:00:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2069rXuN016364;
        Thu, 6 Jan 2022 10:00:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ddmsvkt24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 10:00:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2069pJoP41026032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 09:51:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F14F842061;
        Thu,  6 Jan 2022 10:00:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D11342064;
        Thu,  6 Jan 2022 10:00:08 +0000 (GMT)
Received: from [9.145.54.64] (unknown [9.145.54.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 10:00:08 +0000 (GMT)
Message-ID: <96521e26-7d51-7451-3cf4-cca37da9dc24@linux.ibm.com>
Date:   Thu, 6 Jan 2022 11:00:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net v4] net/smc: Reset conn->lgr when link group
 registration fails
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641451455-41647-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641451455-41647-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k7ioqxigDw1RKCfrfZyPEI740sFFEXmt
X-Proofpoint-ORIG-GUID: IXF1DaRezTXYSJs5r5zvgThajOXdDYE2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_03,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=904 bulkscore=0 clxscore=1015 mlxscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2022 07:44, Wen Gu wrote:
> @@ -630,10 +630,11 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
>  
>  static void smc_conn_abort(struct smc_sock *smc, int local_first)
>  {
> +	struct smc_connection *conn = &smc->conn;
> +
> +	smc_conn_free(conn);
>  	if (local_first)
> -		smc_lgr_cleanup_early(&smc->conn);
> -	else
> -		smc_conn_free(&smc->conn);
> +		smc_lgr_cleanup_early(conn->lgr);
>  }

Looks like I missed a prereq patch here, but wo'nt conn->lgr be set to NULL
after smc_conn_free() called smc_lgr_unregister_conn()?
