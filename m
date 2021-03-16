Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBC633D4E3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 14:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhCPNbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 09:31:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60140 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229931AbhCPNaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 09:30:55 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GD40Bi025232;
        Tue, 16 Mar 2021 09:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=qFlyR3IDy3IYTKuc0uPMVh14k8s633tZpdmCYezt/aQ=;
 b=Ddgt0ZJ9HU6qgjZr+ToipsQ3vVz0sAzRFqnkO0tgGq01Z6ZNNaFEr92OKmSsrY/5Txpp
 gOAaQx9Loq7y5KEg/gk7FFk35x7NrZqjoQ68mE5/sUl2L6SV8S8nrI8lIKUFxpz252ue
 E6+Ephq+xmJKGx0Sf+LEc8Kd2cuEggirGSZwDrvMCzWt0+QHLBb+zDWyTH4j0gPPAYSg
 owxcTKWlTJb5WKARmnAGBk7VYX2aIoUVCtioO5oOCP9ljfcQe9ojyEKXS2LBL4EY9pHU
 Yv7NnbcGIaMmvm4egwgIJbspXgNgN72+qvaks3Er4Cunqa1vrhWjVnlhyVJpX/nks2/p Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37aum043qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:30:50 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12GD4GR0026458;
        Tue, 16 Mar 2021 09:30:49 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37aum043pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:30:49 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12GDTmKb003038;
        Tue, 16 Mar 2021 13:30:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 378n189grw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 13:30:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12GDUjkr42533366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 13:30:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E997C42045;
        Tue, 16 Mar 2021 13:30:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B894203F;
        Tue, 16 Mar 2021 13:30:43 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.165.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Mar 2021 13:30:43 +0000 (GMT)
Date:   Tue, 16 Mar 2021 15:30:40 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Jarvis Jiang <jarvis.w.jiang@gmail.com>
Cc:     davem@davemloft.net, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, cchen50@lenovo.com, mpearson@lenovo.com
Subject: Re: [PATCH] Add MHI bus support and driver for T99W175 5G modem
Message-ID: <YFCzAPkpqO7qslax@linux.ibm.com>
References: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_04:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 05:42:37AM -0700, Jarvis Jiang wrote:
> T99W175 using MBIM or RmNet over PCIe interface with
> MHI protocol support.
> Ported from IPQ8072 platform, including MHI, MBIM, RmNet
> 
> Supporting below PCI devices:
> 
>   PCI_DEVICE(0x17cb, 0x0300)
>   PCI_DEVICE(0x17cb, 0x0301)
>   PCI_DEVICE(0x17cb, 0x0302)
>   PCI_DEVICE(0x17cb, 0x0303)
>   PCI_DEVICE(0x17cb, 0x0304)
>   PCI_DEVICE(0x17cb, 0x0305)
>   PCI_DEVICE(0x17cb, 0x0306)
>   PCI_DEVICE(0x105b, 0xe0ab)
>   PCI_DEVICE(0x105b, 0xe0b0)
>   PCI_DEVICE(0x105b, 0xe0b1)
>   PCI_DEVICE(0x105b, 0xe0b3)
>   PCI_DEVICE(0x1269, 0x00b3)
>   PCI_DEVICE(0x03f0, 0x0a6c)
> 
> Signed-off-by: Jarvis Jiang <jarvis.w.jiang@gmail.com>
> ---
>  MAINTAINERS                                   |   16 +
>  drivers/bus/Kconfig                           |    1 +
>  drivers/bus/Makefile                          |    3 +
>  drivers/bus/mhi/Kconfig                       |   27 +
>  drivers/bus/mhi/Makefile                      |    9 +
>  drivers/bus/mhi/controllers/Kconfig           |   13 +
>  drivers/bus/mhi/controllers/Makefile          |    2 +
>  drivers/bus/mhi/controllers/mhi_arch_qti.c    |  275 ++
>  drivers/bus/mhi/controllers/mhi_qti.c         |  970 +++++++
>  drivers/bus/mhi/controllers/mhi_qti.h         |   44 +
>  drivers/bus/mhi/core/Makefile                 |    2 +
>  drivers/bus/mhi/core/mhi_boot.c               |  590 +++++
>  drivers/bus/mhi/core/mhi_dtr.c                |  223 ++
>  drivers/bus/mhi/core/mhi_init.c               | 1901 ++++++++++++++
>  drivers/bus/mhi/core/mhi_internal.h           |  826 ++++++
>  drivers/bus/mhi/core/mhi_main.c               | 2261 +++++++++++++++++
>  drivers/bus/mhi/core/mhi_pm.c                 | 1158 +++++++++
>  drivers/bus/mhi/devices/Kconfig               |   43 +
>  drivers/bus/mhi/devices/Makefile              |    3 +
>  drivers/bus/mhi/devices/mhi_netdev.c          | 1830 +++++++++++++
>  drivers/bus/mhi/devices/mhi_satellite.c       | 1155 +++++++++
>  drivers/bus/mhi/devices/mhi_uci.c             |  802 ++++++
>  drivers/net/ethernet/qualcomm/rmnet/Makefile  |    2 +-
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    |  131 +-
>  .../ethernet/qualcomm/rmnet/rmnet_config.h    |  110 +-
>  .../qualcomm/rmnet/rmnet_descriptor.c         | 1225 +++++++++
>  .../qualcomm/rmnet/rmnet_descriptor.h         |  152 ++
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  321 ++-
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.h  |   27 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |  238 +-
>  .../qualcomm/rmnet/rmnet_map_command.c        |  304 ++-
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 1029 +++++++-
>  .../ethernet/qualcomm/rmnet/rmnet_private.h   |   19 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_trace.h |  250 ++
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  101 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   16 +-
>  include/linux/ipc_logging.h                   |  291 +++
>  include/linux/mhi.h                           |  743 ++++++
>  include/linux/mod_devicetable.h               |   22 +-
>  include/linux/msm-bus.h                       |  214 ++
>  include/linux/msm_pcie.h                      |  173 ++
>  include/linux/netdevice.h                     |   18 +-
>  include/uapi/linux/if_link.h                  |    4 +
>  include/uapi/linux/msm_rmnet.h                |  170 ++
>  mm/memblock.c                                 |    2 +
>  net/core/dev.c                                |  192 +-
>  46 files changed, 17700 insertions(+), 208 deletions(-)

This is way too much for a single patch. Please split your changes into a
series of patches, with one logical change per patch. For instance, you can
start with adding skeleton infrastructure for MHI, then add particular
implementations for it, and on top you can add device drivers that rely on
MHI core.

-- 
Sincerely yours,
Mike.
