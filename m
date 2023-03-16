Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008326BCD5F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCPK54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCPK5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:57:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54E2B8569;
        Thu, 16 Mar 2023 03:57:50 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32G9nNlO006145;
        Thu, 16 Mar 2023 10:55:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=7zUVLqfgkxlB/CvIYtJSDlbWyrbMGiJIYvxL53W0EtM=;
 b=PL08ZsD+XtRM09GxqYDQj39mqLXK8twanm7rwQqnIQfwioUlu8HBi0o0Aglcuj1RSBMW
 Tta74D7W0va/3zRGoMytz/7QIWFORrhqDDBiQ1xAsPZixxzWKOSTJPUtf/4p1EgT/1dC
 5ne0FkzdJwCC7siVMR9QsX65QmXpiuJa3Lw0G4XiFHqkPP2lICNkZc3Pp/XyYkmJEkU6
 77iPpJiAXoNyPD/NUkXXH1ulGqxFK9LZ1M8BX1lS1vJcuZ0jN3xKfjVl36LR+aKXspqx
 Ibvd99uv/XQXvlKADPpOmaH4NIbmTA8thfyWigMu+31RVbk3bv1CUOpAi7unR7supj2S UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbsp13s59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 10:55:36 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GARZTS026173;
        Thu, 16 Mar 2023 10:55:36 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbsp13s3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 10:55:35 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32G1dJX9001150;
        Thu, 16 Mar 2023 10:55:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pbsmrgf2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 10:55:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32GAtTlv44433682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 10:55:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2A6120043;
        Thu, 16 Mar 2023 10:55:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54B7220040;
        Thu, 16 Mar 2023 10:55:27 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.126.150.29])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
        Thu, 16 Mar 2023 10:55:27 +0000 (GMT)
Date:   Thu, 16 Mar 2023 16:25:26 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Naveen Rao <naveen.n.rao@linux.vnet.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "naamax.meir" <naamax.meir@linux.intel.com>
Subject: Re: [Intel-wired-lan] igc driver causes suspend to fail if powersave
 is enabled
Message-ID: <20230316105526.GH1005120@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20230315072019.GG1005120@linux.vnet.ibm.com>
 <f59701c0-3cf1-8053-2790-4a543ac4f461@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <f59701c0-3cf1-8053-2790-4a543ac4f461@intel.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YoBWzne-AGpI5mg3tI1NeRCKZDxzNv_k
X-Proofpoint-ORIG-GUID: tn3_PS5-vYKxDjHTdP9K4hJ-TkG9j5WM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_07,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 adultscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Neftin, Sasha <sasha.neftin@intel.com> [2023-03-15 21:04:07]:

> On 3/15/2023 09:20, Srikar Dronamraju wrote:
> > Hi,
> >
> > On Lenovo ThinkPad P15 Gen 2i with I225-LM Ethernet card running Fedora 37
> > kernel 6.1.13-200.fc37.x86_64, running powertop --auto-tune causes suspend
> > and reboot to fail. Once suspend fails, networking stops working even for
> > wireless. Infact as a normal user, I cant even start a sudo session after
> > trying to suspend.
> Hello,
> Is the i225 card on board (under PCH downstream port) or connected via
> thunderbolt?
> Did you see the same problem on other platforms?
> I will forward this inquiry to our PAE.>

I dont think its connected to thunderbolt. But I am not sure.
So, can you let me know how do I figure this out?

Some additional information if that helps

$ lspci -vt
-[0000:00]-+-00.0  Intel Corporation 11th Gen Core Processor Host Bridge/DRAM Registers
           +-01.0-[01]--+-00.0  NVIDIA Corporation TU117GLM [T1200 Laptop GPU]
           |            \-00.1  NVIDIA Corporation Device 10fa
           +-02.0  Intel Corporation TigerLake-H GT1 [UHD Graphics]
           +-04.0  Intel Corporation TigerLake-LP Dynamic Tuning Processor Participant
           +-06.0-[04]----00.0  Micron Technology Inc Device 5407
           +-07.0-[20-49]--
           +-07.1-[50-79]--
           +-0d.0  Intel Corporation Tiger Lake-H Thunderbolt 4 USB Controller
           +-0d.2  Intel Corporation Tiger Lake-H Thunderbolt 4 NHI #0
           +-14.0  Intel Corporation Tiger Lake-H USB 3.2 Gen 2x1 xHCI Host Controller
           +-14.2  Intel Corporation Tiger Lake-H Shared SRAM
           +-16.0  Intel Corporation Tiger Lake-H Management Engine Interface
           +-16.3  Intel Corporation Device 43e3
           +-1c.0-[1c]--
           +-1c.4-[0b]----00.0  Intel Corporation Ethernet Controller I225-LM
           +-1c.5-[09]----00.0  Intel Corporation Wi-Fi 6 AX210/AX211/AX411 160MHz
           +-1c.7-[0a]----00.0  Genesys Logic, Inc GL9755 SD Host Controller
           +-1f.0  Intel Corporation Device 4389
           +-1f.3  Intel Corporation Tiger Lake-H HD Audio Controller
           +-1f.4  Intel Corporation Tiger Lake-H SMBus Controller
           \-1f.5  Intel Corporation Tiger Lake-H SPI Controller

I can use ethernet even after removing thunderbolt module.

Even when loaded, o/p of
$ lsmod | grep -e thunderbolt -e igc
thunderbolt           397312  0
igc                   163840  0

I dont have any other platform with the same Ethernet Controller device.

--
Thanks and Regards
Srikar Dronamraju
