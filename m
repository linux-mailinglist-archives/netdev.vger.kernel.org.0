Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C74B1C2569
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEBMgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727844AbgEBMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:18 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CVWe8170584;
        Sat, 2 May 2020 08:36:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v54w2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZK6x027079;
        Sat, 2 May 2020 12:36:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5gs7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042Ca87t8978648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 760B2A4054;
        Sat,  2 May 2020 12:36:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ED86A4065;
        Sat,  2 May 2020 12:36:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/13] net/smc: add and delete link processing
Date:   Sat,  2 May 2020 14:35:39 +0200
Message-Id: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches add the 'add link' and 'delete link' processing as 
SMC server and client. This processing allows to establish and
remove links of a link group dynamically.

They are based on the patches I sent yesterday, I cannot see yesterdays
patches in the net-next git tree yet.

Karsten Graul (13):
  net/smc: first part of add link processing as SMC client
  net/smc: rkey processing for a new link as SMC client
  net/smc: final part of add link processing as SMC client
  net/smc: first part of add link processing as SMC server
  net/smc: rkey processing for a new link as SMC server
  net/smc: final part of add link processing as SMC server
  net/smc: delete an asymmetric link as SMC server
  net/smc: activate SMC server add link functions
  net/smc: llc_del_link_work and use the LLC flow for delete link
  net/smc: delete link processing as SMC client
  net/smc: delete link processing as SMC server
  net/smc: enqueue local LLC messages
  net/smc: save state of last sent CDC message

 net/smc/af_smc.c   |   4 +-
 net/smc/smc.h      |   4 +
 net/smc/smc_cdc.c  |   6 +
 net/smc/smc_core.c |  29 +-
 net/smc/smc_core.h |   4 +-
 net/smc/smc_llc.c  | 774 +++++++++++++++++++++++++++++++++++++++++++--
 net/smc/smc_llc.h  |   5 +
 net/smc/smc_wr.c   |   2 +-
 net/smc/smc_wr.h   |   1 +
 9 files changed, 786 insertions(+), 43 deletions(-)

-- 
2.17.1

