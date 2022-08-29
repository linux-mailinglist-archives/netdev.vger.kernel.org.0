Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA2A5A4F95
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiH2Osr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 10:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiH2Osq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 10:48:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D548E448;
        Mon, 29 Aug 2022 07:48:45 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TEfwRJ031051;
        Mon, 29 Aug 2022 14:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6PkRSB+NbEWYa9XguBPkoR/gZHyuFfR6jw7EA33/Sis=;
 b=s7y2/MwNTd/WaMgFnDtHjGP4YWel8Uf+IOOfHGNntd9ZML6XU8c7bspzwdPsY+wqNR0B
 bkxBSqIlKYru50PDD19Q0cCCRNJgBRYihmOWuE64gOgE1TcNw0GT6czW2cNe9MAbvU5N
 BfHN19e+zKv4jp7DjW5D/kieplbTtzHhhR9dE/VwzlpriaIuZ0ldemnghu+WC63kudCJ
 OcU2dB1OHFH90TjLwWQRWN1k5hx+09mNSULT23eSVEJ0KES1cqltBf+CJRVv5NVJhobi
 z8FtSI4O/pWVlXiF4rUU5F8KY9FajOUVtUuntQEXQV/xex1lrLGP17cHfkZZWRyD+mmf TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j8yenr9dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 14:48:41 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27TEgdEP000843;
        Mon, 29 Aug 2022 14:48:41 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j8yenr9ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 14:48:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27TEZQWd000697;
        Mon, 29 Aug 2022 14:48:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3j7aw8tf6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 14:48:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27TEmZ5A37618078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 14:48:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 544FDAE056;
        Mon, 29 Aug 2022 14:48:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF037AE045;
        Mon, 29 Aug 2022 14:48:34 +0000 (GMT)
Received: from [9.171.14.126] (unknown [9.171.14.126])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Aug 2022 14:48:34 +0000 (GMT)
Message-ID: <304f04ad-59f5-962d-6cfe-1905cbe7440f@linux.ibm.com>
Date:   Mon, 29 Aug 2022 16:48:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net-next v2 01/10] net/smc: remove locks
 smc_client_lgr_pending and smc_server_lgr_pending
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
 <688d165fe630989665e5091a28a5b1238123fbdc.1661407821.git.alibuda@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
In-Reply-To: <688d165fe630989665e5091a28a5b1238123fbdc.1661407821.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EC1sacyVJCP3D8F2Qhk5nvq-WagxSBTT
X-Proofpoint-GUID: 9wzKDi4SWwyGjytb8iSMCL5SiPyI0ju7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.08.2022 11:51, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch attempts to remove locks named smc_client_lgr_pending and
> smc_server_lgr_pending, which aim to serialize the creation of link
> group. However, once link group existed already, those locks are
> meaningless, worse still, they make incoming connections have to be
> queued one after the other.
> 
> Now, the creation of link group is no longer generated by competition,
> but allocated through following strategy.
> 
> 1. Try to find a suitable link group, if successd, current connection
> is considered as NON first contact connection. ends.
> 
> 2. Check the number of connections currently waiting for a suitable
> link group to be created, if it is not less that the number of link
> groups to be created multiplied by (SMC_RMBS_PER_LGR_MAX - 1), then
> increase the number of link groups to be created, current connection
> is considered as the first contact connection. ends.
> 
> 3. Increase the number of connections currently waiting, and wait
> for woken up.
> 
> 4. Decrease the number of connections currently waiting, goto 1.
> 
> We wake up the connection that was put to sleep in stage 3 through
> the SMC link state change event. Once the link moves out of the
> SMC_LNK_ACTIVATING state, decrease the number of link groups to
> be created, and then wake up at most (SMC_RMBS_PER_LGR_MAX - 1)
> connections.
> 
> In the iplementation, we introduce the concept of lnk cluster, which is
> a collection of links with the same characteristics (see
> smcr_lnk_cluster_cmpfn() with more details), which makes it possible to
> wake up efficiently in the scenario of N v.s 1.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   net/smc/af_smc.c   |  13 +-
>   net/smc/smc_core.c | 352 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   net/smc/smc_core.h |  53 ++++++++
>   net/smc/smc_llc.c  |   9 +-
>   4 files changed, 411 insertions(+), 16 deletions(-)

Thank you for the v2.
I'm going to start testing and give you feedback ASAP.

- Jan
