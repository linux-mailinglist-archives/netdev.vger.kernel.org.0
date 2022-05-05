Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736E151BCA2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354847AbiEEKDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354789AbiEEKDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:03:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C230650B27;
        Thu,  5 May 2022 02:59:28 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2459aFeB024134;
        Thu, 5 May 2022 09:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eY2YObbcFr4e3utydicajCplfb/dauutThJaiKhuaBI=;
 b=YJAfb2Tx1B2BE1qq0eQzJh6g0XaIvjk/wKcIaqZMntb2j8S8dEKjP0pDTmYk7uc5shAe
 x/3csDSUbmdfudFVxvoD+SVBgZ5xFQX52TcpSUm/0FWQck6KJG7QCg+imXgK8wGieVP+
 KP7e0qE7B/U6Th+4tuq9o+5xUZshq0dX/oxphycjDk8quIp7ZwSNP27hPP2NXINS/bBs
 /me6mxYaJdf2eUVxNkhcgVuWuxU4Fip1s1cb/W3gXKt4B7JgZlNt7nKj1FULAWwmrMTz
 IvOLNZJ3OoQK70Pn9z7NoqIDNBhvCE6NBmKivdCJutRRFLqr5pGjpByfOCOtL5JyYmLb oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvc3j0bb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 09:58:44 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2459hPTQ021697;
        Thu, 5 May 2022 09:58:44 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvc3j0ban-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 09:58:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2459wNvA028720;
        Thu, 5 May 2022 09:58:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3fscdk50qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 09:58:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2459wcHr47579582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 09:58:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FBBB4C046;
        Thu,  5 May 2022 09:58:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA37C4C044;
        Thu,  5 May 2022 09:58:36 +0000 (GMT)
Received: from [9.145.10.86] (unknown [9.145.10.86])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 09:58:36 +0000 (GMT)
Message-ID: <99841fd9-da83-a482-b86d-c82d53d3ebbb@linux.ibm.com>
Date:   Thu, 5 May 2022 11:58:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next 1/2] net: switch to netif_napi_add_tx()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        rafal@milecki.pl, f.fainelli@gmail.com, opendmb@gmail.com,
        dmichail@fungible.com, hauke@hauke-m.de, tariqt@nvidia.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, shshaikh@marvell.com,
        manishc@marvell.com, jiri@resnulli.us,
        hayashi.kunihiko@socionext.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, grygorii.strashko@ti.com,
        elder@kernel.org, wenjia@linux.ibm.com, svens@linux.ibm.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        s-vadapalli@ti.com, chi.minghao@zte.com.cn,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
        mptcp@lists.linux.dev
References: <20220504163725.550782-1-kuba@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220504163725.550782-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FQKgPrf0AWcYtwf2epIDAiiAJ0Y93y-W
X-Proofpoint-ORIG-GUID: iAZJdqaevE2kmwUaneOsutwQhM8oos7d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_04,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=855
 clxscore=1011 lowpriorityscore=0 impostorscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050063
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.05.22 18:37, Jakub Kicinski wrote:
> Switch net callers to the new API not requiring
> the NAPI_POLL_WEIGHT argument.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: rafal@milecki.pl
> CC: f.fainelli@gmail.com
> CC: opendmb@gmail.com
> CC: dmichail@fungible.com
> CC: hauke@hauke-m.de
> CC: tariqt@nvidia.com
> CC: kys@microsoft.com
> CC: haiyangz@microsoft.com
> CC: sthemmin@microsoft.com
> CC: wei.liu@kernel.org
> CC: decui@microsoft.com
> CC: shshaikh@marvell.com
> CC: manishc@marvell.com
> CC: jiri@resnulli.us
> CC: hayashi.kunihiko@socionext.com
> CC: peppe.cavallaro@st.com
> CC: alexandre.torgue@foss.st.com
> CC: joabreu@synopsys.com
> CC: mcoquelin.stm32@gmail.com
> CC: grygorii.strashko@ti.com
> CC: elder@kernel.org
> CC: wintera@linux.ibm.com
> CC: wenjia@linux.ibm.com
> CC: svens@linux.ibm.com
> CC: mathew.j.martineau@linux.intel.com
> CC: matthieu.baerts@tessares.net
> CC: s-vadapalli@ti.com
> CC: chi.minghao@zte.com.cn
> CC: linux-rdma@vger.kernel.org
> CC: linux-hyperv@vger.kernel.org
> CC: mptcp@lists.linux.dev
> ---
...
>  drivers/s390/net/qeth_core_main.c                  | 3 +--


For drivers/s390/net/qeth_core_main.c :

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
