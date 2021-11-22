Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A800A4590F2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbhKVPLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:11:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46148 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232194AbhKVPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:11:54 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMF2WHC010448;
        Mon, 22 Nov 2021 15:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hkEt6EUnpd2QOQcb5OoImYzeD54WeZPwxSc6rCVkF/s=;
 b=F+elT9zE57+C4s65cexX6Zx3kSLaIQYAhVttwB0j8KqVgx8dqkhg4YEOVml8t0IY76HS
 4A+/qIXhOgxZv8UuIN8kmvT0PXPpiYqzfZ7CFUkEYMxuc9RdJaUNwHvMDrkw0L+EhbXf
 p533JP0gHTgqBvNWPoXpahN5hkgu6EBDV++XB4eHuCkROj/PecVfUw1M/Ml5S/U+v9Bn
 gzrIfgs0M46hI5uVbSWD4ck8JZTmv07YhnySRGLyhLNjqG/A/RQKStdh0nqpzkMnOhbi
 4NH9Sqg+XNyxo4RugOFWgY1tAJk61hDluX1fjfpWNrvxzl/g2zJb0eLYbqcovjdD0Aj0 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgdgh057y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 15:08:42 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AMF5YOw024194;
        Mon, 22 Nov 2021 15:08:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgdgh057e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 15:08:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AMF7CM2029910;
        Mon, 22 Nov 2021 15:08:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernafmdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 15:08:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AMF8cDa61735354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 15:08:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 222BF42042;
        Mon, 22 Nov 2021 15:08:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACE9D4204D;
        Mon, 22 Nov 2021 15:08:37 +0000 (GMT)
Received: from [9.145.56.120] (unknown [9.145.56.120])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Nov 2021 15:08:37 +0000 (GMT)
Message-ID: <f08e1793-630f-32a6-6662-19edc362b386@linux.ibm.com>
Date:   Mon, 22 Nov 2021 16:08:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH RFC net-next] net/smc: Unbind buffer size from clcsock and
 make it tunable
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211122134255.63347-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211122134255.63347-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hx3ZXLxC7y6VD0aMKNj4KHUCuMqFUDpg
X-Proofpoint-ORIG-GUID: dXt_ONC907U6klxHxIzRw2HbB6t27PzV
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-22_07,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111220077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2021 14:42, Tony Lu wrote:
> SMC uses smc->sk.sk_{rcv|snd}buf to create buffer for send buffer or
> RMB. And the values of buffer size inherits from clcsock. The clcsock is
> a TCP sock which is initiated during SMC connection startup.
> 
> The inherited buffer size doesn't fit SMC well. TCP provides two sysctl
> knobs to tune r/w buffers, net.ipv4.tcp_{r|w}mem, and SMC use the default
> value from TCP. The buffer size is tuned for TCP, but not fit SMC well
> in some scenarios. For example, we need larger buffer of SMC for high
> throughput applications, and smaller buffer of SMC for saving contiguous
> memory. We need to adjust the buffer size apart from TCP and not to
> disturb TCP.
> 
> This unbinds buffer size which inherits from clcsock, and provides
> sysctl knobs to adjust buffer size independently. These knobs can be
> tuned with different values for different net namespaces for performance
> and flexibility.
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> ---

To activate SMC for existing programs usually the smc_run command or the
preload library (both from the smc-tools package) are used.
This commit introduced support to set the send and recv window sizes
using command line parameters or environment variables:

https://github.com/ibm-s390-linux/smc-tools/commit/59bfb99c588746f7dca1b3c97fd88f3f7cbc975f

Why another way to manipulate these sizes?
Your solution would stop applications to set these values.
