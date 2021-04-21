Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD136725F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245173AbhDUSTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:19:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51520 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243837AbhDUSTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:19:02 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13LI3RIX172526;
        Wed, 21 Apr 2021 14:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uR2hhhmlgVC7UqNbr5vUmtd29tZvzRai4k7iE4bMG7o=;
 b=Np1d5frT5y8PzoLAEwVIDbePp3JwD48t3XxscjVoCE3Zj2zi68sKI/jN1XZaAcV99ZbO
 0AVh3xcTPc2fO70T0G49eveHV6c2AYt4Y+PG0cLcTSrvXbRsf9hMUUql0vk0DdB2/RQj
 1k9RMSkE6TAFgjxXi9KkNBsl+ydYE29wxEkMX2//S38gjAVPsGSWI6MNbZIYjGVhheRI
 EDHWCcsteggXcE2aIssJ4l2jztFUnjAF1EBs6z9C/fD01U0oettk9rn2TxpQuvDqgYAX
 Z67ZovSNyzr1lA6kXbQW7EyHd4CjhwUMdI8U6ABxDMmk0q/T5t6cp0JRXr/c6DHezJwf og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382qwr2ar9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 14:18:15 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13LI4qPR179501;
        Wed, 21 Apr 2021 14:18:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382qwr2aqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 14:18:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13LIDDgA019022;
        Wed, 21 Apr 2021 18:18:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 37yqa8jf8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 18:18:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13LII9tf42926346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 18:18:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B07424C046;
        Wed, 21 Apr 2021 18:18:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99C2D4C040;
        Wed, 21 Apr 2021 18:18:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 21 Apr 2021 18:18:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 3A93EE07F0; Wed, 21 Apr 2021 20:18:09 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@nvidia.com, roopa@nvidia.com,
        vladimir.oltean@nxp.com, linux-next@vger.kernel.org,
        borntraeger@de.ibm.com
Subject: Re: net: bridge: propagate error code and extack from br_mc_disabled_update
Date:   Wed, 21 Apr 2021 20:18:08 +0200
Message-Id: <20210421181808.5210-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414192257.1954575-1-olteanv@gmail.com>
References: <20210414192257.1954575-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WIK0vHtpz8j21R-t7s8xJshvGjLqw9w_
X-Proofpoint-GUID: bwMelXlosi6aoef6iv7ZLpLJ4KmLPpg0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_05:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 clxscore=1011 adultscore=0 mlxlogscore=670
 malwarescore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whatever version landed in next, according to bisect this broke libvirt/kvms use of bridges:


# virsh start s31128001
error: Failed to start domain 's31128001'
error: Unable to add bridge virbr1 port vnet0: Operation not supported

# grep vnet0 /var/log/libvirt/libvirtd.log

2021-04-21 07:43:09.453+0000: 2460: info : virNetDevTapCreate:240 : created device: 'vnet0'
2021-04-21 07:43:09.453+0000: 2460: debug : virNetDevSetMACInternal:287 : SIOCSIFHWADDR vnet0 MAC=fe:bb:83:28:01:02 - Success
2021-04-21 07:43:09.453+0000: 2460: error : virNetDevBridgeAddPort:633 : Unable to add bridge virbr1 port vnet0: Operation not supported
2021-04-21 07:43:09.466+0000: 2543: debug : udevHandleOneDevice:1695 : udev action: 'add': /sys/devices/virtual/net/vnet0

Christian
