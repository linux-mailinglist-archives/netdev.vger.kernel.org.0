Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39304B9EB0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbiBQLdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:33:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiBQLdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:33:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275DB276D60;
        Thu, 17 Feb 2022 03:33:14 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HB9NVa003053;
        Thu, 17 Feb 2022 11:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=nwLjJVz/Q5MleaH+ZbrjfIPPEx/r11++oHZynpKVNJY=;
 b=Vysf73Vu0TJKJIEgU2LSZBqjtayOi5oqjcX/LpWo1L3M0LW4UyuXB6KUXXff54sY0JFV
 DkdCx8gzWlH6LHCWNr43PXLvftCvPCQWi5z2TwyunmZ31zTQrB5u+0pb12aKZP9TEbZf
 GLsZtMnQiQD+1TP0M97gqjgWmsOEAizzxMUUrjpZPh8vbnNODvMuOxCFyCbvNGgQRvk+
 yhvsqMB+R/UwJG2jyhMndCXl1iQuqiILJKa6fhm0MqrP+BXkifLvC500A96huymysvHY
 CJw90sOEXXIcL3xIO8uuMIYSUIoZGIRBlELd80iv/lYU5s3I4/T7U9eW+Y2sBPiFyHUV Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9hu2chb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 11:33:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HBUwnI014195;
        Thu, 17 Feb 2022 11:33:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9hu2chad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 11:33:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HBCSmO008641;
        Thu, 17 Feb 2022 11:33:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3e64hah8dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 11:33:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HBX7fU46596354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 11:33:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 641154C050;
        Thu, 17 Feb 2022 11:33:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED9064C052;
        Thu, 17 Feb 2022 11:33:06 +0000 (GMT)
Received: from sig-9-145-65-211.uk.ibm.com (unknown [9.145.65.211])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 11:33:06 +0000 (GMT)
Message-ID: <8701fa4557026983a9ec687cfdd7ac5b3b85fd39.camel@linux.ibm.com>
Subject: Re: [PATCH 0/4] RDMA device net namespace support for SMC
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, kgraul@linux.ibm.com,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Date:   Thu, 17 Feb 2022 12:33:06 +0100
In-Reply-To: <20211228130611.19124-1-tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pxawglC3Kr8JGH5Jan7ufYDzNbjb7mHy
X-Proofpoint-ORIG-GUID: 6jm5bxHTMgk6avyDmbVBIBypVXWIyP5s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_04,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-28 at 21:06 +0800, Tony Lu wrote:
> This patch set introduces net namespace support for linkgroups.
> 
> Path 1 is the main approach to implement net ns support.
> 
> Path 2 - 4 are the additional modifications to let us know the netns.
> Also, I will submit changes of smc-tools to github later.
> 
> Currently, smc doesn't support net namespace isolation. The ibdevs
> registered to smc are shared for all linkgroups and connections. When
> running applications in different net namespaces, such as container
> environment, applications should only use the ibdevs that belongs to the
> same net namespace.
> 
> This adds a new field, net, in smc linkgroup struct. During first
> contact, it checks and find the linkgroup has same net namespace, if
> not, it is going to create and initialized the net field with first
> link's ibdev net namespace. When finding the rdma devices, it also checks
> the sk net device's and ibdev's net namespaces. After net namespace
> destroyed, the net device and ibdev move to root net namespace,
> linkgroups won't be matched, and wait for lgr free.
> 
> If rdma net namespace exclusive mode is not enabled, it behaves as
> before.
> 
> Steps to enable and test net namespaces:
> 
> 1. enable RDMA device net namespace exclusive support
> 	rdma system set netns exclusive # default is shared
> 
> 2. create new net namespace, move and initialize them
> 	ip netns add test1 
> 	rdma dev set mlx5_1 netns test1
> 	ip link set dev eth2 netns test1
> 	ip netns exec test1 ip link set eth2 up
> 	ip netns exec test1 ip addr add ${HOST_IP}/26 dev eth2
> 
> 3. setup server and client, connect N <-> M
> 	ip netns exec test1 smc_run sockperf server --tcp # server
> 	ip netns exec test1 smc_run sockperf pp --tcp -i ${SERVER_IP} # client
> 
> 4. netns isolated linkgroups (2 * 2 mesh) with their own linkgroups
>   - server

Hi Tony,

I'm having a bit of trouble getting this to work for me and was
wondering if you could test my scenario or help me figure out what's
wrong.

I'm using network namespacing to be able to test traffic between two
VFs of the same card/port with a single Linux system. By having one VF
in each of a client and server namespace, traffic doesn't shortcut via
loopback. This works great for TCP and with "rdma system set netns
exclusive" I can also verify that RDMA with "qperf -cm1 ... rc_bw" only
works once the respective RDMA device is also added to each namespace.

When I try the same with SMC-R I tried:

  ip netns exec server smc_run qperf &
  ip netns exec client smc_run qperf <ip_server> tcp_bw

With that however I only see fallback TCP connections in "ip netns exec
client watch smc_dbg". It doesn't seem to be an "smc_dbg" problem
either since the performance with and without smc_run is the same. I
also do have the same PNET_ID set on the interfaces.

As an aside do you know how to gracefully put the RDMA devices back
into the default namespace? For network interfaces I can use "ip -n
<ns> link set dev <iface> netns 1" but the equivalent "ip netns exec
<ns> rdma dev set <rdmadev> netns 1" doesn't work because there is no
PID variant. Deleting the namespace and killing processes using the
RDMA device does seem to get it back but with some delay.

Thanks,
Niklas

