Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868214ADEE7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383704AbiBHRGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383697AbiBHRGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:06:34 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23414C061576;
        Tue,  8 Feb 2022 09:06:34 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FajJ8015590;
        Tue, 8 Feb 2022 17:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/1LX+vj/LRzlrh6WXHNend0jpSfIr1+0ON1akUYJdCA=;
 b=sQizHAVRkgow8xj0DNH7IQ2QTebfBRYjb9oETOPQS07EPnaNY31AlOxYiSilXgB9PiRt
 oyyaDcD7YJthTpoihmkitY0rIxzCt47K9K77APKzzq4WA/2vpJpX/ZyI7rj5uM2IuUe2
 0m7hEjFdoDQ0SohOdFubfqIGexlOpT70hPxVc2jAFCoIqQZ3uW43/X0Nb2UnC6SVV/yM
 912drbzwPfiPF9j1A178b65dAcVsvl2frBx87RihiFTH1tsi4Ud8bH8gp9wM4RFjItzB
 Y/xFYXy/yhgM12YpWk4mOSqUITFCZ+HAaDzKlcY3N1d0MWX+fzNcwQE6pHbFpfIDz6Rf /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236fqbpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:06:30 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218FUJ0i030533;
        Tue, 8 Feb 2022 17:06:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236fqbp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:06:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218Gx3Ha009115;
        Tue, 8 Feb 2022 17:06:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gva6u9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:06:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218H6Pa834865656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 17:06:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9394A4059;
        Tue,  8 Feb 2022 17:06:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E7D4A404D;
        Tue,  8 Feb 2022 17:06:25 +0000 (GMT)
Received: from [9.145.157.102] (unknown [9.145.157.102])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 17:06:25 +0000 (GMT)
Message-ID: <0d1363b7-6080-5fb3-1dcb-cdedf82303fa@linux.ibm.com>
Date:   Tue, 8 Feb 2022 18:06:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v5 1/5] net/smc: Make smc_tcp_listen_work()
 independent
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <58c544cb206d94b759ff0546bcffe693c3cbfb98.1644323503.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <58c544cb206d94b759ff0546bcffe693c3cbfb98.1644323503.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TMYjX_2OwEFk0zU5tHVGqUMhbwTEen9t
X-Proofpoint-GUID: uNuDzk7ZSRvvSFyoDjY4UvvbyLVBdIPL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202080101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2022 13:53, D. Wythe wrote:
> +static struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
>  struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>  struct workqueue_struct	*smc_close_wq;	/* wq for close work */
>  
> @@ -2227,7 +2228,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
>  	lsmc->clcsk_data_ready(listen_clcsock);
>  	if (lsmc->sk.sk_state == SMC_LISTEN) {
>  		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
> -		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
> +		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
>  			sock_put(&lsmc->sk);

It works well this way, but given the fact that there is one tcp_listen worker per 
listen socket and these workers finish relatively quickly, wouldn't it be okay to
use the system_wq instead of using an own queue? But I have no strong opinion about that...

