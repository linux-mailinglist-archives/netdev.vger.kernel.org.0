Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7514BA7F1
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244142AbiBQSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:16:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244134AbiBQSQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:16:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE118213428;
        Thu, 17 Feb 2022 10:16:07 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HIBOcL000385;
        Thu, 17 Feb 2022 18:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=QbNiDzaXtugwEq/apbFl+z2s7Z8n99Z5EqF8nRXa5pY=;
 b=WMJzYKbQ2hp/BteDRj3AOYLEsg1Bny4jQ8k+u4dfJ+FWztcVmoHhRmzQZFDh/lHG5dTv
 9+vxzM6MOtpXNECQHN+Lg27qdYkCH93fD6bXcWyfbdFbG/DMd16B0UOA8ZKJybRPt/nx
 f56/GOG9YI+09HozeNYG7kABW6L/nICUbKKo81bu6Dlh2tpXzzrtw9QDsqYph1gREeGV
 kf76IT7cvJBZ9MVGVOH7OnulrkWr6x10RWxf4+x184Qz6mczSDtFRqurIR54weq4nRQx
 QV4uEAYbdkSVM9reZ6B/CHhWq0k2ZAHg21bkPSoWmfF7+2C3E/bz0nl8vEJ8u2aOnEff /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9qk4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 18:16:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HIDZrD009100;
        Thu, 17 Feb 2022 18:16:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9pp9qk3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 18:16:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HIC4VB009474;
        Thu, 17 Feb 2022 18:16:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3e64hajr5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 18:16:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HIFveF28246432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 18:15:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 090474204C;
        Thu, 17 Feb 2022 18:15:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E786E42045;
        Thu, 17 Feb 2022 18:15:56 +0000 (GMT)
Received: from vela (unknown [9.145.66.38])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 17 Feb 2022 18:15:56 +0000 (GMT)
Received: from brueckner by vela with local (Exim 4.94.2)
        (envelope-from <brueckner@linux.ibm.com>)
        id 1nKlJr-000BTQ-47; Thu, 17 Feb 2022 19:15:55 +0100
Date:   Thu, 17 Feb 2022 19:15:54 +0100
From:   Hendrik Brueckner <brueckner@linux.ibm.com>
To:     "dust.li" <dust.li@linux.alibaba.com>
Cc:     Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH] net/smc: Add autocork support
Message-ID: <Yg6Q2kIDJrhvNVz7@linux.ibm.com>
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
 <20220216152721.GB39286@linux.alibaba.com>
 <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
 <20220217132200.GA5443@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217132200.GA5443@linux.alibaba.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r1Qw7Syfysn6uzD6Ngi2E5jnB7tqPgKb
X-Proofpoint-ORIG-GUID: TZwbOgHYVcUo3bK-1MjZAyVEOw1N7kwi
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1011 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 09:22:00PM +0800, dust.li wrote:
> On Thu, Feb 17, 2022 at 10:37:28AM +0100, Stefan Raspl wrote:
> >On 2/16/22 16:27, dust.li wrote:
> >> On Wed, Feb 16, 2022 at 02:58:32PM +0100, Stefan Raspl wrote:
> >> > On 2/16/22 04:49, Dust Li wrote:
> >> >
> 
> >Now we understand that cloud workloads are a bit different, and the desire to
> >be able to modify the environment of a container while leaving the container
> >image unmodified is understandable. But then again, enabling the base image
> >would be the cloud way to address this. The question to us is: How do other
> >parts of the kernel address this?
> 
> I'm not familiar with K8S, but from one of my colleague who has worked
> in that area tells me for resources like CPU/MEM and configurations
> like sysctl, can be set using K8S configuration:
> https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/

For K8s, this involves container engines like cri-o, containerd, podman,
and others towards the runtimes like runc.  To ensure they operate together,
specifications by the Open Container Initiative (OCI) at
https://opencontainers.org/release-notices/overview/

For container/pod deployments, there is especially the Container Runtime
Interface (CRI) that defines the interface, e.g., of K8s to cri-o etc.

CRI includes support for (namespaced) sysctl's:
https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.2

In essence, the CRI spec would allow users to specify/control a specific
runtime for the container in a declarative way w/o modifying the (base)
container images.


Thanks and kind regards,
  Hendrik

