Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9015C1FA365
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgFOWVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 18:21:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725843AbgFOWVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 18:21:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FM2NMR163141;
        Mon, 15 Jun 2020 18:21:16 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31msf012w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 18:21:16 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FMFk22026375;
        Mon, 15 Jun 2020 22:21:15 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 31pey48r1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 22:21:15 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FMLDr520185518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 22:21:13 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD0CEC605F;
        Mon, 15 Jun 2020 22:21:14 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80295C605A;
        Mon, 15 Jun 2020 22:21:14 +0000 (GMT)
Received: from Davids-MBP.randomparity.org (unknown [9.211.152.140])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 22:21:14 +0000 (GMT)
Subject: Re: [PATCH] tg3: driver sleeps indefinitely when EEH errors exceed
 eeh_max_freezes
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200615190119.382589-1-drc@linux.vnet.ibm.com>
 <CACKFLimd0a=Y8WyvqCt4BD7SU_Cg1vQ=baKs6-uPv0dZuCm=mw@mail.gmail.com>
From:   David Christensen <drc@linux.vnet.ibm.com>
Message-ID: <95bf20c6-a812-32ad-fd38-45cba7e10491@linux.vnet.ibm.com>
Date:   Mon, 15 Jun 2020 15:21:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CACKFLimd0a=Y8WyvqCt4BD7SU_Cg1vQ=baKs6-uPv0dZuCm=mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_09:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 clxscore=1011
 cotscore=-2147483648 phishscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 1:45 PM, Michael Chan wrote:
> On Mon, Jun 15, 2020 at 12:01 PM David Christensen
> <drc@linux.vnet.ibm.com> wrote:
>>
>> The driver function tg3_io_error_detected() calls napi_disable twice,
>> without an intervening napi_enable, when the number of EEH errors exceeds
>> eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.
>>
>> The function is called once with the PCI state pci_channel_io_frozen and
>> then called again with the state pci_channel_io_perm_failure when the
>> number of EEH failures in an hour exceeds eeh_max_freezes.
>>
>> Protecting the calls to napi_enable/napi_disable with a new state
>> variable prevents the long sleep.
> 
> This works, but I think a simpler fix is to check tp->pcierr_recovery
> in tg3_io_error_detected() and skip most of the tg3 calls (including
> the one that disables NAPI) if the flag is true.

This might be the smallest change that would work.  Does it make sense 
to the reader?

diff --git a/drivers/net/ethernet/broadcom/tg3.c 
b/drivers/net/ethernet/broadcom/tg3.c
index 7a3b22b35238..1f37c69d213d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18168,8 +18168,8 @@ static pci_ers_result_t 
tg3_io_error_detected(struct pci_dev *pdev,

         rtnl_lock();

-       /* We probably don't have netdev yet */
-       if (!netdev || !netif_running(netdev))
+       /* May be second call or maybe we don't have netdev yet */
+       if (tp->pcierr_recovery || !netdev || !netif_running(netdev))
                 goto done;

         /* We needn't recover from permanent error */

