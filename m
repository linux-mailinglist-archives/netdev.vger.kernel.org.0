Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC7D442A6C
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKBJc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:32:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhKBJcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 05:32:53 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A28F9Nv005079;
        Tue, 2 Nov 2021 09:30:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=IOQijjjE+9e7i9Ca6RdvxAoupGYFL+SD2p4SUDIWewo=;
 b=Qk3GKGdVZUon2AufuruH1ybXU57tlMUbbei/6Gci5Vw5K1YiHNBfgpJ/DH5OhiqAYGfa
 JCoIEDaOzQydMiKdFZCYYT70N+W0dSSZQiJB4T+XduSIn3eVN+ECArT/q6qOyzP1xSod
 vaFTxSwTwTCcULqMx+8SrzaE/wLReGU7tlWtGIwK0f/lBLrKlCX5NTZMz1pXpFZ8mLtP
 I3DtiQPguOzjuNaTUHmo9mlfWl/3peatqcCt2eGjqEosYeywPa4MPfMRpl+0XwIMB+yY
 KVYBWSnDfGcxgUxMI9+v96VX6sYb3MHEu5E2puiNmVgRjxxklWdFSvOGSPhJHtrKLPAe tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2p6sxdhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:30:17 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A28udKX021804;
        Tue, 2 Nov 2021 09:30:16 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2p6sxdgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:30:16 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A29DnJ6016565;
        Tue, 2 Nov 2021 09:30:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3c0wp9rc3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:30:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A29UBik46924190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 09:30:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D47D04C052;
        Tue,  2 Nov 2021 09:30:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AED94C059;
        Tue,  2 Nov 2021 09:30:11 +0000 (GMT)
Received: from [9.145.173.195] (unknown [9.145.173.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Nov 2021 09:30:11 +0000 (GMT)
Message-ID: <11f17a34-fd35-f2ec-3f20-dd0c34e55fde@linux.ibm.com>
Date:   Tue, 2 Nov 2021 10:30:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net-next 3/3] net/smc: Introduce tracepoint for smcr link
 down
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211101073912.60410-1-tonylu@linux.alibaba.com>
 <20211101073912.60410-4-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211101073912.60410-4-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O3mwP6vKG-gy8aVKpZa6lAjS58OpBU13
X-Proofpoint-ORIG-GUID: Pijjz2RppCs8q1UHk5mK7z3ujNeulg16
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_06,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2021 08:39, Tony Lu wrote:
> +
> +	    TP_printk("lnk=%p lgr=%p state=%d dev=%s location=%p",
> +		      __entry->lnk, __entry->lgr,
> +		      __entry->state, __get_str(name),
> +		      __entry->location)

The location is printed as pointer (which might even be randomized?),
is it possible to print the function name of the caller, as described
here: https://stackoverflow.com/questions/4141324/function-caller-in-linux-kernel

  printk("Caller is %pS\n", __builtin_return_address(0));

Not sure if this is possible with the trace points, but it would be
easier to use. You plan to use a dump to find out about the function caller?
