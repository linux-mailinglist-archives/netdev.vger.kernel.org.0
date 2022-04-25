Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E197950DB5B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 10:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiDYIlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 04:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiDYIlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 04:41:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3F06D4D5;
        Mon, 25 Apr 2022 01:38:20 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23P7M6cE002305;
        Mon, 25 Apr 2022 08:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mXQw9yJibjU1LOUw/Nwttj2XAYMW9xCb91lhW+5mnS4=;
 b=oQgDq8GPdYWc8jve/dB+rDxuDx3g93Me/f8JEDVKRHF59pYJcfomFzladwjw9pnhedWH
 7/kLqHqudTPKwh4LZWQCv5TUsEsnUJzWIxVoNHXp64FdtZdk+BEI/+Tvuo2tLjjh9FOg
 CwsteKrNZcQPnyimMXPQ6+BHV1IZJ1SFMbwG4fAujh83xuDL4daWiiEOCiCkDM79AL97
 7hJz1BQa8D3lbwo+N1dZJivRoEsQd0g2HSHinkAb9aTB65TatzFrbVqAyTeng4hIdPt/
 ZurnEMm6l2Bx+CuHmYJ8eCuUvPdvgIsBnnhv40I7VcZKAd49dOKfWbJryG32UuPdT1N9 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fmu3k44c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 08:38:19 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23P8NmgZ005178;
        Mon, 25 Apr 2022 08:38:19 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fmu3k44b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 08:38:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23P8ZLEC019335;
        Mon, 25 Apr 2022 08:38:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3fm938sp74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 08:38:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23P8cQXv6881846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 08:38:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D43FB52050;
        Mon, 25 Apr 2022 08:38:13 +0000 (GMT)
Received: from [9.145.148.76] (unknown [9.145.148.76])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6067F5204E;
        Mon, 25 Apr 2022 08:38:13 +0000 (GMT)
Message-ID: <3572a765-17b4-b2df-e3d5-0d30485c4c67@linux.ibm.com>
Date:   Mon, 25 Apr 2022 10:38:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: ctcm: rename READ/WRITE defines to avoid redefinitions
Content-Language: en-US
To:     "Colin King (gmail)" <colin.i.king@gmail.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <ae612043-0252-e8c3-0773-912f116421c1@gmail.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <ae612043-0252-e8c3-0773-912f116421c1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O7aAhaJNIP8QJHWu4prMcZkegVRX_kXl
X-Proofpoint-ORIG-GUID: 3gGAMDN6DFtdax5lFiLGFEYQqHxfsrmG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_02,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 impostorscore=0 clxscore=1011 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250036
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.04.22 20:58, Colin King (gmail) wrote:
> Hi,
> 
> static analysis with cppcheck detected a potential null pointer deference with the following commit:
> 
> commit 3c09e2647b5e1f1f9fd383971468823c2505e1b0
> Author: Ursula Braun <ursula.braun@de.ibm.com>
> Date:   Thu Aug 12 01:58:28 2010 +0000
> 
>     ctcm: rename READ/WRITE defines to avoid redefinitions
> 
> 
> The analysis is as follows:
> 
> drivers/s390/net/ctcm_sysfs.c:43:8: note: Assuming that condition 'priv' is not redundant
>  if (!(priv && priv->channel[CTCM_READ] && ndev)) {
>        ^
> drivers/s390/net/ctcm_sysfs.c:42:9: note: Null pointer dereference
>  ndev = priv->channel[CTCM_READ]->netdev;
> 
> The code in question is as follows:
> 
>         ndev = priv->channel[CTCM_READ]->netdev;
> 
>         ^^ priv may be null, as per check below but it is being dereferenced when assigning ndev
> 
>         if (!(priv && priv->channel[CTCM_READ] && ndev)) {
>                 CTCM_DBF_TEXT(SETUP, CTC_DBF_ERROR, "bfnondev");
>                 return -ENODEV;
>         }
> 
> Colin

Thank you very much for reporting this, we will provide a patch.

Do you have any special requests for the Reported-by flag? Or is
Reported-by: Colin King (gmail) <colin.i.king@gmail.com>
fine with you?

Kind regards
Alexandra
