Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DB26BA8EA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCOHVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjCOHU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:20:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63D45A6EB;
        Wed, 15 Mar 2023 00:20:54 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F5IOuL014179;
        Wed, 15 Mar 2023 07:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : content-type : mime-version; s=pp1;
 bh=qPb6bHlGHyAYa8z6S6TmjTPR2kL2cYjv5cIagZOGV2E=;
 b=L4RPA6gmio5khQ6i5KhFrP/r3saPDiXY87iMddjy+5TTULRwMsoR2BOkAGxqBR4MIl8w
 inDXpRmtwbznrYE0m+5SkTsRMMGBBdQwXzDlTqemqKKP3LX70QZjUlAyH6x73MIUlT8P
 u0agUWCSGhkrdHe1dnSo7M01XgTA/RogebFZZTNDIWzd084k6tLvRPRaHffc2SS2HHNC
 tqW6hQmvTFDEuhAJQXx/SaawG0VeA7jjLavSgnZ+1vehUpL9EZBWKqFLJLM8ql8oAZBD
 LcHbIVrSr7gkmR8uDpl6OpXS1czYgOQdt+dITcy9oYTZdp2WqSEy6KNORJxSqQZsSxt5 Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pb7rqjn16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 07:20:27 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32F6fnQW005279;
        Wed, 15 Mar 2023 07:20:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pb7rqjn00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 07:20:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32EN5eQ0008598;
        Wed, 15 Mar 2023 07:20:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pb29sgeey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 07:20:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32F7KMEJ27918942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 07:20:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60DB920043;
        Wed, 15 Mar 2023 07:20:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B24620040;
        Wed, 15 Mar 2023 07:20:20 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.126.150.29])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
        Wed, 15 Mar 2023 07:20:20 +0000 (GMT)
Date:   Wed, 15 Mar 2023 12:50:19 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Naveen Rao <naveen.n.rao@linux.vnet.ibm.com>
Subject: igc driver causes suspend to fail if powersave is enabled
Message-ID: <20230315072019.GG1005120@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CdIxsayXKZM8ERmQ2ckknuAhHhmY0PLg
X-Proofpoint-ORIG-GUID: EFzzz51A6tX6_f5nn0TrhnnIntMM29iK
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_02,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=784 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Lenovo ThinkPad P15 Gen 2i with I225-LM Ethernet card running Fedora 37
kernel 6.1.13-200.fc37.x86_64, running powertop --auto-tune causes suspend
and reboot to fail. Once suspend fails, networking stops working even for
wireless. Infact as a normal user, I cant even start a sudo session after
trying to suspend.

Reboot/shutdown fails since Network-Manager cant be killed. (More below)
The only option left is for the system to be hard-reboot.

I finally found that the problem was because enabling auto or powersave on
ethernet card was causing this issue. i.e

echo 'auto' > '/sys/bus/pci/devices/0000:0b:00.0/power/control'

Pls do note, I was not using ethernet, I was just using wireless even before
suspend.

lspci -v reports
0b:00.0 Ethernet controller: Intel Corporation Ethernet Controller I225-LM (rev 03)
	Subsystem: Lenovo Device 22d8
	Flags: fast devsel, IRQ 16, IOMMU group 17
	Memory at be300000 (32-bit, non-prefetchable) [size=1M]
	Memory at be400000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable- Count=5 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 88-a4-c2-ff-ff-5f-09-88
	Capabilities: [1c0] Latency Tolerance Reporting
	Capabilities: [1f0] Precision Time Measurement
	Capabilities: [1e0] L1 PM Substates
	Kernel modules: igc

When suspend fails, we see messages like this

kernel: Freezing of tasks failed after 20.001 seconds (3 tasks refusing to freeze, wq_busy=0):
kernel: task:NetworkManager  state:D stack:0     pid:2014  ppid:1      flags:0x00004006
kernel: Call Trace:
kernel:  <TASK>
kernel:  __schedule+0x35f/0x1360
kernel:  ? asm_sysvec_reschedule_ipi+0x16/0x20
kernel:  schedule+0x5d/0xe0
kernel:  schedule_preempt_disabled+0x14/0x30
kernel:  __mutex_lock.constprop.0+0x390/0x6e0
kernel:  ? __cond_resched+0x1c/0x30
kernel:  igc_resume+0xfc/0x1d0 [igc]
kernel:  ? pci_pm_restore_noirq+0xc0/0xc0
kernel:  __rpm_callback+0x41/0x170
kernel:  rpm_callback+0x35/0x70
kernel:  ? pci_pm_restore_noirq+0xc0/0xc0
kernel:  rpm_resume+0x5bb/0x800
kernel:  __pm_runtime_resume+0x47/0x80
kernel:  dev_ethtool+0x124/0x2eb0
kernel:  ? avc_has_extended_perms+0x22a/0x520
kernel:  ? inet_ioctl+0xd8/0x1e0
kernel:  dev_ioctl+0x156/0x520
kernel:  sock_do_ioctl+0xda/0x120
kernel:  sock_ioctl+0xed/0x330
kernel:  ? security_file_ioctl+0x39/0x60
kernel:  __x64_sys_ioctl+0x8d/0xd0
kernel:  do_syscall_64+0x58/0x80
kernel:  ? __x64_sys_ioctl+0xa8/0xd0
kernel:  ? syscall_exit_to_user_mode+0x17/0x40
kernel:  ? do_syscall_64+0x67/0x80
kernel:  ? do_syscall_64+0x67/0x80
kernel:  ? do_syscall_64+0x67/0x80
kernel:  ? do_syscall_64+0x67/0x80
kernel:  entry_SYSCALL_64_after_hwframe+0x63/0xcd
kernel: RIP: 0033:0x7ff964b93d6f
kernel: RSP: 002b:00007ffc96c6f540 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
kernel: RAX: ffffffffffffffda RBX: 00005608c0ba8040 RCX: 00007ff964b93d6f
kernel: RDX: 00007ffc96c6f640 RSI: 0000000000008946 RDI: 000000000000001e
kernel: RBP: 00007ffc96c6f7c0 R08: 0000000000000000 R09: 0000000000000000
kernel: R10: 0000000000000021 R11: 0000000000000246 R12: 0000000000000000
kernel: R13: 00007ffc96c6f640 R14: 00007ffc96c6f620 R15: 00007ffc96c6f620
kernel:  </TASK>

We have seen similar problems even with people running other distros like
Arch Linux and RHEL 8 (which is 4.18 based)distros. So this is not distro
specific or kernel specific too.

Even installing tlp package from https://linrunner.de/tlp/index.html causes
similar issues.

-- 
Thanks and Regards
Srikar Dronamraju
