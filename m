Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAA244B104
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 17:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbhKIQUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 11:20:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24826 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238397AbhKIQUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 11:20:38 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9EhfFo017617;
        Tue, 9 Nov 2021 16:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3BhKIdkkjzzQwMO5VpHYb6yx8DHSvDdQyMMyui674o4=;
 b=lMbNibKu/3IxC14QWmorNhUf+XXW9mfYQwc1iDlfuDYKz/cKv+n2gnrxRq0x/JDG6p7R
 WsIn925RtIVtdRU1fkfuK7Q05LTxBBcNuUiWygjFBI8qk15f1D5loKaAuXzSP7G2f5K9
 RWo1QPxvgGsinETvFb3t61+vTiJCDZ9Hg1xxcgIhCfvflNSP/xIO819dlEsPl5aCdAIG
 EdvWuqH1QrPj2vemtqdKecGfjsszZz4MCW4PZOJiSJa0LJcsdtGHknCAv3y4JfpKDU+Q
 VuPBq9EC+0t3V61DVPXqJi+x5SRAAqdD7AtOQsQvGtDlh/A7RsV29rIoLGlzymyHTcnD sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c7u0j2q5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 16:17:48 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A9EhmKp017727;
        Tue, 9 Nov 2021 16:17:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c7u0j2q5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 16:17:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A9G1sDa029826;
        Tue, 9 Nov 2021 16:17:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hbaa2xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 16:17:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A9GHiqZ63635928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Nov 2021 16:17:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D1DE11C050;
        Tue,  9 Nov 2021 16:17:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACB5B11C04C;
        Tue,  9 Nov 2021 16:17:43 +0000 (GMT)
Received: from [9.145.144.3] (unknown [9.145.144.3])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Nov 2021 16:17:43 +0000 (GMT)
Message-ID: <ed52790a-3e39-6e2e-8cfc-4a4ca1970f99@linux.ibm.com>
Date:   Tue, 9 Nov 2021 17:17:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net/smc: Print function name in smcr_link_down
 tracepoint
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211103124836.63180-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211103124836.63180-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4mdB0oDZjM2ekn-MChV7NfzTkTlwfoqP
X-Proofpoint-ORIG-GUID: mF2N1x_tQ3ZvMwqojgBy1QavotxG_9id
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_03,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 mlxlogscore=928
 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/11/2021 13:48, Tony Lu wrote:
> This makes the output of smcr_link_down tracepoint easier to use and
> understand without additional translating function's pointer address.
> 
> It prints the function name with offset:
> 
>   <idle>-0       [000] ..s.    69.087164: smcr_link_down: lnk=00000000dab41cdc lgr=000000007d5d8e24 state=0 rc=1 dev=mlx5_0 location=smc_wr_tx_tasklet_fn+0x5ef/0x6f0 [smc]
> 
> Link: https://lore.kernel.org/netdev/11f17a34-fd35-f2ec-3f20-dd0c34e55fde@linux.ibm.com/
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

