Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21E21865B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgGHLoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:44:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728592AbgGHLoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:44:15 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068BWV4p046623;
        Wed, 8 Jul 2020 07:44:11 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324y8sdfqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 07:44:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068BaNWd001494;
        Wed, 8 Jul 2020 11:44:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 322hd7vg8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:44:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068Bi5ot57933864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 11:44:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53734A4057;
        Wed,  8 Jul 2020 11:44:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C793EA404D;
        Wed,  8 Jul 2020 11:44:04 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.30.152])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 11:44:04 +0000 (GMT)
Subject: Re: [REGRESSION] mlx5: Driver remove during hot unplug is broken
To:     Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Shay Drory <shayd@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ubraun@linux.ibm.com" <ubraun@linux.ibm.com>,
        "kgraul@linux.ibm.com" <kgraul@linux.ibm.com>,
        "raspl@de.ibm.com" <raspl@de.ibm.com>
References: <f942d546-ee7e-60f6-612a-ae093a9459a5@linux.ibm.com>
 <7660d8e0d2cb1fbd40cf89ea4c9a0eff4807157c.camel@mellanox.com>
 <26dedb23-819f-8121-6e04-72677110f3cc@linux.ibm.com>
 <AM0PR05MB4866585FF543DA370E78B992D1670@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <0e94b811-7d2e-5c2d-f6a4-64dd536aa72d@linux.ibm.com>
Date:   Wed, 8 Jul 2020 13:44:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4866585FF543DA370E78B992D1670@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_08:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=771 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 cotscore=-2147483648
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Parav, Hi Shay,

On 7/8/20 12:43 PM, Parav Pandit wrote:
> Hi Niklas,
> 
... snip ...
>>>
> 
> Sorry for my late response.
> Yes, this looks good and I also found same in my analysis.
> With latest code mlx5_pci_close() already does drain_health_wq(), so the additional call in remove_one() is redundant.
> It should be just removed.
> If you can verify below hunk in your setup, it will be really helpful.
> You still need patch 42ea9f1b5c6 in your tree.
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 8b658908f044..ebec2318dbc4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1382,7 +1382,6 @@ static void remove_one(struct pci_dev *pdev)
> 
>         devlink_reload_disable(devlink);
>         mlx5_crdump_disable(dev);
> -       mlx5_drain_health_wq(dev);
>         mlx5_unload_one(dev, true);
>         mlx5_pci_close(dev);
>         mlx5_mdev_uninit(dev);
> 

thanks for looking into this. Sadly it looks like this
doesn't quite work, I'm getting the bewlow illegal dereference after
removing the mlx5_drain_health_wq(dev) from remove_one() on top of
v5.8-rc4.
I think this is similar to what happned when I tried recreating the
reordering on -rc3 which is why I contacted Shay as I wasn't
able to get this to work again with the current code.
(Sorry if there are formatting issues with the below, plugged this
out of a x3270).

64.735421¨ Unable to handle kernel pointer dereference in virtual kernel address space 
64.735470¨ Failing address: 6b6b6b6b6b6b6000 TEID: 6b6b6b6b6b6b6803 
64.735476¨ Fault in home space mode while using kernel ASCE. 
64.735484¨ AS:0000000088da0007 R3:0000000000000024  
64.735533¨ Oops: 0038 ilc:3 Ý#1¨ PREEMPT SMP  
64.735538¨ Modules linked in: rpcrdma sunrpc rdma_ucm rdma_cm iw_cm ib_cm configfs mlx5_ib ib_uverbs ib_core mlx5_core dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua s390_trng ghash_s390 prng ctr aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 vfio_ccw vfi
64.735421¨ Unable to handle kernel pointer dereference in virtual kernel address space 
64.735558¨ CPU: 0 PID: 762 Comm: kworker/u128:3 Not tainted 5.8.0-rc4-dirty #2 
64.735561¨ Hardware name: IBM 3906 M04 704 (z/VM 7.1.0) 
64.735618¨ Workqueue: mlx5_health0000:00:00.0 mlx5_fw_fatal_reporter_err_work mlx5_core
64.735623¨ Krnl PSW : 0704e00180000000 00000000876936c6 (notifier_call_chain+0x3e/0xe8)01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from CPU 01.01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from CPU 00.
64.735702¨            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3 
64.735704¨ Krnl GPRS: 00000000a38fc246 0000000080000001 00000000e814db00 0000000000000080 
64.735706¨            0000000000000001 ffffffffffffffff 0000000000000000 0000000000000001 
64.735708¨            0000000000000080 0000000000000001 ffffffffffffffff 6b6b6b6b6b6b6b6b 
64.735710¨            00000000e5ff0100 0000000000000000 000003e000973bf8 000003e000973ba0 
64.735716¨ Krnl Code: 00000000876936ba: b9040083            lgr     %r8,%r3 
64.735716¨            00000000876936be: b9040074            lgr     %r7,%r4 
64.735716¨           #00000000876936c2: a7d80000            lhi     %r13,0 
64.735716¨           >00000000876936c6: e390b0080004        lg      %r9,8(%r11) 
64.735716¨            00000000876936cc: e320b0000004        lg      %r2,0(%r11) 
64.735716¨            00000000876936d2: c0e5ffffd773        brasl   %r14,000000008768e5b8 
64.735716¨            00000000876936d8: ec280032007e        cij     %r2,0,8,000000008769373c 
64.735716¨            00000000876936de: e310b0000004        lg      %r1,0(%r11) 
64.735731¨ Call Trace: 
64.735740¨  <00000000876936c6>¨ notifier_call_chain+0x3e/0xe8  
64.735764¨  <000000008769392c>¨ __atomic_notifier_call_chain+0x9c/0x138  
64.735766¨  <00000000876939f2>¨ atomic_notifier_call_chain+0x2a/0x38  
64.735782¨  <000003ff801e99c4>¨ mlx5_enter_error_state+0xec/0x100 mlx5_core
64.735797¨  <000003ff801e9a0c>¨ mlx5_fw_fatal_reporter_err_work+0x34/0xb8 mlx5_core¨  
64.735802¨  <000000008768784c>¨ process_one_work+0x27c/0x478  
64.735805¨  <0000000087687aae>¨ worker_thread+0x66/0x368  
64.735807¨  <0000000087690a96>¨ kthread+0x176/0x1a0  
64.735811¨  <0000000088202820>¨ ret_from_fork+0x24/0x2c  
64.735812¨ INFO: lockdep is turned off. 
64.735814¨ Last Breaking-Event-Address: 
64.735816¨  <0000000087693926>¨ __atomic_notifier_call_chain+0x96/0x138 
64.735820¨ Kernel panic - not syncing: Fatal exception: panic_on_oops 
00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 8762103E
