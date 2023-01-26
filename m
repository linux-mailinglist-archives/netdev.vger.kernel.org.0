Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8374A67CC44
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbjAZNeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbjAZNeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:34:21 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ABF173A;
        Thu, 26 Jan 2023 05:34:19 -0800 (PST)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QCu1Ne021964;
        Thu, 26 Jan 2023 08:34:09 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3navamh717-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 08:34:09 -0500
Received: from m0167088.ppops.net (m0167088.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30QDTvg4023818;
        Thu, 26 Jan 2023 08:34:09 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3navamh70y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 08:34:09 -0500
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 30QDY7xG008411
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 26 Jan 2023 08:34:07 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 26 Jan
 2023 08:34:07 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 26 Jan 2023 08:34:07 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.156])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 30QDXoan000628;
        Thu, 26 Jan 2023 08:33:52 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <yangyingliang@huawei.com>,
        <weiyongjun1@huawei.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <lennart@lfdomain.com>
Subject: [net-next v2 0/3] net: ethernet: adi: adin1110: add PTP support
Date:   Thu, 26 Jan 2023 15:33:43 +0200
Message-ID: <20230126133346.61097-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: XPsFH3nU6XD2mMO2IT_HV1Ydor2cI3UN
X-Proofpoint-ORIG-GUID: gn-TbrNuZsjqOIwComvhn_X45KvgV4MU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_05,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 clxscore=1015
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260131
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
phc2sys[140.318]: CLOCK_REALTIME phc offset    109350 s0 freq      +0 delay      0
phc2sys[141.319]: CLOCK_REALTIME phc offset    124742 s1 freq  +15385 delay      0
phc2sys[142.319]: CLOCK_REALTIME phc offset      -159 s2 freq  +15226 delay      0
phc2sys[143.319]: CLOCK_REALTIME phc offset        55 s2 freq  +15392 delay      0
phc2sys[144.320]: CLOCK_REALTIME phc offset      -101 s2 freq  +15252 delay      0
phc2sys[145.320]: CLOCK_REALTIME phc offset       -82 s2 freq  +15241 delay      0

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

Changelog v1 -> v2:
  - added phylib locking when writing to the integrated PHY registers in
  adin2111_enable_ts_timer()  and adin2111_enable_extts()
  - instead of ktime_get_fast_timestamps() used ktime_get_mono_fast_ns() and
  ktime_get_real_fast_ns() as I only need the real and mono part. The device
  part is added from the MAC-PHY.
  - in adjfine() use the new adjust_by_scaled_ppm() helper instead of writing
  the implementation

Alexandru Tachici (3):
  net: ethernet: adi: adin1110: add PTP clock support
  net: ethernet: adi: adin1110: add timestamping support
  dt-bindings: net: adin1110: Document ts-capt pin

 .../devicetree/bindings/net/adi,adin1110.yaml |   7 +
 drivers/net/ethernet/adi/adin1110.c           | 824 +++++++++++++++++-
 2 files changed, 821 insertions(+), 10 deletions(-)

-- 
2.34.1

