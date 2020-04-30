Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F711BFACE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgD3N4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728074AbgD3N4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:10 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDaqYF065752;
        Thu, 30 Apr 2020 09:56:09 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqaw0ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmR2C031741;
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu4j251511568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E904B4C044;
        Thu, 30 Apr 2020 13:56:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A820D4C040;
        Thu, 30 Apr 2020 13:56:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:03 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/14] net/smc: add event-based framework for LLC msgs
Date:   Thu, 30 Apr 2020 15:55:37 +0200
Message-Id: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=1
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=575 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are the next step towards SMC-R link failover support. They add
a new framework to handle Link Layer Control (LLC) messages and adapt the
existing code to use the new framework.

Karsten Graul (14):
  net/smc: add event-based llc_flow framework
  net/smc: enqueue all received LLC messages
  net/smc: introduce link group type
  net/smc: add logic to evaluate CONFIRM_LINK messages to LLC layer
  net/smc: adapt SMC server code to use the LLC flow
  net/smc: adapt SMC client code to use the LLC flow
  net/smc: multiple link support and LLC flow for
    smc_llc_do_confirm_rkey
  net/smc: multiple link support and LLC flow for smc_llc_do_delete_rkey
  net/smc: move the TEST_LINK response processing into event handler
  net/smc: new smc_rtoken_set functions for multiple link support
  net/smc: adapt SMC remote CONFIRM_RKEY processing to use the LLC flow
  net/smc: adapt SMC remote DELETE_RKEY processing to use the LLC flow
  net/smc: remove handling of CONFIRM_RKEY_CONTINUE
  net/smc: remove obsolete link state DELETING

 net/smc/af_smc.c   | 108 +++++----
 net/smc/smc_clc.h  |   1 +
 net/smc/smc_core.c |  63 +++++-
 net/smc/smc_core.h |  50 ++++-
 net/smc/smc_llc.c  | 535 ++++++++++++++++++++++++++++++---------------
 net/smc/smc_llc.h  |  15 +-
 6 files changed, 525 insertions(+), 247 deletions(-)

-- 
2.17.1

