Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A861F6751B5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjATJyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjATJya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:54:30 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43C73EE3;
        Fri, 20 Jan 2023 01:54:22 -0800 (PST)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30K8g3ci023460;
        Fri, 20 Jan 2023 04:54:10 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n7qnw09hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 04:54:10 -0500
Received: from m0167089.ppops.net (m0167089.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30K9oVqq026484;
        Fri, 20 Jan 2023 04:54:09 -0500
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n7qnw09hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 04:54:09 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 30K9s8We036473
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Jan 2023 04:54:08 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 20 Jan
 2023 04:54:07 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 20 Jan 2023 04:54:07 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.139])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 30K9rqTv021132;
        Fri, 20 Jan 2023 04:53:54 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <yangyingliang@huawei.com>,
        <weiyongjun1@huawei.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <lennart@lfdomain.com>
Subject: [net-next 0/3] net: ethernet: adi: adin1110: add PTP support
Date:   Fri, 20 Jan 2023 11:53:45 +0200
Message-ID: <20230120095348.26715-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: owdE7b4BtcC6l1n-GXg-_AUVyRcv3JEX
X-Proofpoint-ORIG-GUID: 1I1KDlhbmhCwgZ576S4G8biYI3O2dqwG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_06,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 clxscore=1011 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200093
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control for the PHC inside the ADIN1110/2111.
Device contains a syntonized counter driven by a 120 MHz
clock  with 8 ns resolution.

Time is stored in two registers: a 32bit seconds register and
a 32bit nanoseconds register.

For adjusting the clock timing, device uses an addend register.
Can generate an output signal on the TS_TIMER pin.
For reading the timestamp the current tiem is saved by setting the
TS_CAPT pin via gpio in order to snapshot both seconds and nanoseconds
in different registers that the live ones.

Allow use of hardware RX/TX timestamping.

RX frames are automatically timestamped by the device at hardware
level when the feature is enabled. Time of day is the one used by the
MAC device.

When sending a TX frame to the MAC device, driver needs to send
a custom header ahead of the ethernet one where it specifies where
the MAC device should store the timestamp after the frame has
successfully been sent on the MII line. It has 3 timestamp slots that can
be read afterwards. Host will be notified by the TX_RDY IRQ.

root@analog:~# ethtool -T eth1
Time stamping parameters for eth1:
Capabilities:
	hardware-transmit
	software-transmit
	hardware-receive
	software-receive
	software-system-clock
	hardware-raw-clock
PTP Hardware Clock: 0
Hardware Transmit Timestamp Modes:
	off
	on
Hardware Receive Filter Modes:
	none
	all

root@analog:~# sudo phc2sys -s eth1 -c CLOCK_REALTIME -O 0 -m
phc2sys[4897.317]: CLOCK_REALTIME phc offset   -511696 s0 freq  -19464 delay      0
phc2sys[4898.317]: CLOCK_REALTIME phc offset  -1023142 s1 freq -530689 delay      0
phc2sys[4899.318]: CLOCK_REALTIME phc offset      -663 s2 freq -531352 delay      0
phc2sys[4900.318]: CLOCK_REALTIME phc offset      -327 s2 freq -531215 delay      0
phc2sys[4901.318]: CLOCK_REALTIME phc offset      -603 s2 freq -531589 delay      0
phc2sys[4902.318]: CLOCK_REALTIME phc offset       288 s2 freq -530879 delay      0

root@analog:~# ptp4l -m -f /etc/ptp_slave.conf
ptp4l[1188.692]: port 1: new foreign master 00800f.fffe.950400-1
ptp4l[1192.329]: selected best master clock 00800f.fffe.950400
ptp4l[1192.329]: foreign master not using PTP timescale
ptp4l[1192.329]: port 1: LISTENING to UNCALIBRATED on RS_SLAVE
ptp4l[1194.129]: master offset   29379149 s0 freq -297035 path delay   -810558
ptp4l[1195.929]: master offset   32040450 s1 freq +512000 path delay   -810558
ptp4l[1198.058]: master offset    1608389 s2 freq +512000 path delay   -810558
ptp4l[1198.058]: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[1199.529]: clockcheck: clock jumped forward or running faster than expected!
ptp4l[1199.529]: master offset    2419241 s0 freq +512000 path delay   -810558
ptp4l[1199.529]: port 1: SLAVE to UNCALIBRATED on SYNCHRONIZATION_FAULT
ptp4l[1201.329]: master offset    2004645 s0 freq +512000 path delay   -810558
ptp4l[1203.130]: master offset    1618970 s1 freq +319234 path delay   -810558
ptp4l[1204.930]: master offset   -1098742 s2 freq -230137 path delay   -810558
ptp4l[1204.930]: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[1206.730]: master offset   -1689657 s2 freq -512000 path delay   -810558
ptp4l[1208.530]: master offset   -1692389 s2 freq -512000 path delay   -345770
ptp4l[1210.330]: master offset    -404021 s2 freq  -47588 path delay   -166813
ptp4l[1212.130]: master offset    1098174 s2 freq +512000 path delay   -104916
ptp4l[1214.061]: master offset    1579741 s2 freq +512000 path delay    -60321
ptp4l[1215.730]: master offset    1180121 s2 freq +512000 path delay    -60321
ptp4l[1217.531]: master offset    -345392 s2 freq  -78876 path delay    -43020

Above ptp4l run was not the best as I do not have access (to my knowledge)
to an accurate PTP grandmaster. Foreign master here is just my laptop
(with only SW timestamping capabilities) with the
ptp4l service runnning and NTP disabled.

Alexandru Tachici (3):
  net: ethernet: adi: adin1110: add PTP clock support
  net: ethernet: adi: adin1110: add timestamping support
  dt-bindings: net: adin1110: Document ts-capt pin

 .../devicetree/bindings/net/adi,adin1110.yaml |   7 +
 drivers/net/ethernet/adi/adin1110.c           | 811 +++++++++++++++++-
 2 files changed, 808 insertions(+), 10 deletions(-)

-- 
2.34.1

