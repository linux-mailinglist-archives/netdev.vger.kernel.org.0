Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C578F1D2CC1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgENK3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:29:25 -0400
Received: from mail-eopbgr20075.outbound.protection.outlook.com ([40.107.2.75]:43589
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbgENK3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:29:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcgXAApe5eIE8Co3b0NIDcUsp+/RbB34OaecIkfCSnbe5NS2tipULpEOQokkncd40kNrHWlQ6Vzal470OAUsh0TjXPH9vaKBfIgZ5f2a6GxJlg78+GJnViqRYilgkCJoujVEv9OkyK4OblDHRobGRqXlfSzQlG+xV1cCOgzRkOtR1mqQKIsE6/o9QW0sWvwLP4b0Ld2jKgoPsLKUZeW+po/An3O90Eabg6CiqEhlQm7YyxYao6oigbwziQpMhmIiIdBSOR+Fd7M2Nytx5buIlP6SGdPk53d/a3Y183VUmjuE6z1wuXM3i4IjA8DUNsTHyXZsEK4hbHmV3sSBYHxEjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qblLRZ6lu8F4Ng90jSF1BeWlrvXHLzCxEwu50MWzhRE=;
 b=ofSAyLSLjfyREqadPOU8UxVGjezeSPFt8tinWA342tuc5EmUQ+uQsjPhkkB3/BFRZen9XhGcFEV1XBkkRNQ2hb2Mn0nRsd8dqCUeffDYfeGg38zuDvFvRhEYIq8TyfIJazKZEICcjKqKtt0+mLUIrkcIx6Dqs37rw22nA5sifakwF5evaTzKhdfLaGhuo+vvdH2jMM5u5y3Ii34qab3qnYIBdTF19h4mjzr9QxFudHrRJyxEu9sP2vtpD/mV2kiMCOTFb/XBZiNOQBVsMsbRSClAf+fCiktWsAdB159UmDIM+5cF/OKFzNVNKOaEsFG5XS8ykv972MvTIIjQ6HMyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qblLRZ6lu8F4Ng90jSF1BeWlrvXHLzCxEwu50MWzhRE=;
 b=OBBomCXBO60Y2zSX/LOo2suQZO3fxQEJNl9CB+/8P83fLTYLOy0p53KQ/VskT4pAvThURrcIkWu7SK/IV5/lOfS+wHeCe1H6fVKrs62NCxt7j/h70TBEiuGo0bxsXxm8uw6z4TNODAQr8NI6hqc66+Qge/dw3DN/naMFVxPnfBc=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB6752.eurprd06.prod.outlook.com (2603:10a6:800:181::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Thu, 14 May
 2020 10:29:19 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 10:29:18 +0000
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Olivier Dautricourt <olivier.dautricourt@orolia.com>
Subject: [PATCH 0/3] Patch series for a PTP Grandmaster use case using stmmac/gmac3 ptp clock
Date:   Thu, 14 May 2020 12:28:05 +0200
Message-Id: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:101:16::34) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a01:e35:1390:8ba0:9b:4371:f8a6:4d92) by PR2PR09CA0022.eurprd09.prod.outlook.com (2603:10a6:101:16::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Thu, 14 May 2020 10:29:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [2a01:e35:1390:8ba0:9b:4371:f8a6:4d92]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33c4d5ff-6d6a-4cb8-ca71-08d7f7f1a89c
X-MS-TrafficTypeDiagnostic: VI1PR06MB6752:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB6752A403A4269A0787BD8E8A8FBC0@VI1PR06MB6752.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G50lxTTQ0qFQvRiQOuZEfcDPTAGKhfpHCLmP1LJUsl+7RnQQchB6UplOQlPFWwrHPMG59/hFcb7eL2s7MCJ99R2vhmTt63YFXMFF1S+JhcLlUxF+w0rO82BTsH9GZv3TpPApeCW4a8MhP1OYFzRur7dnIKktuYsqb85HwY3nmOj4brP4CuF/Vv7Ajgcy+fgcbqh4IA/poHMi8jngAw3LjkWdLDM1Pv9ZQ41lKPRFw8qCifASu++whMfE4s9p+Yv9r8JwGcjenb1IYu9dObMoJxFv+KzQNPQQJw2CmRiVbys3DGRa9gTamQIkVOj+Wy0Op3Xx89+txa1TFXHpduZAfamn4qNDHXkp66YiNUoaEIGRCrdPEQLIDoans2/lEQk8GCPeSzV0baS8b7Y6PGQq+xuDYHOJOHBYCJBN3rw7I7Som94EKEBFEk+wfcfw17D1PeDUkh4AnnTerRoPt0/Z5Z/j3Kl4ET4LTV6sjfZQAF822Au/NsAVVUq7P8xBO+FC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(8676002)(44832011)(6486002)(66476007)(66556008)(2616005)(66946007)(110136005)(316002)(107886003)(2906002)(54906003)(4326008)(6666004)(6512007)(69590400007)(478600001)(8936002)(52116002)(16526019)(5660300002)(1076003)(186003)(36756003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 79+Ofua1oGA7mTYF3YRkSpmEH/jAw31g+6qPDgzuVese6DM11QxitdHnYxAsz0Ylno4MylpdBYs3WavvIW4sbvOhws9SsA6oKmGxe3vcssEY+V98HB3dXa6fWCMcKuy3fRGF/HshVqXxwMzSXWhOIFgoq6//zRf2VvtzSMEqAReoMMnAsDcrbEF5ARH+qzlanHP8OBjN7k2P+jJVp4RxB3C3CQNFnomk1t9cYWaFPvbag18MgtbEU0tcKPppO96CT7zjZzb15xHmZQfLlj672tpro3igHbF8TOq39XPUDryR3xfcS8QGHGoxRtWI6vrj5aJ5H7JeOdhprGTgoqXbLsoQ50tojhLAfQOdLMHmPMNFlHMU2bTVT1l5X5SHjfEdmQe6PDa4wzSQkl1ZCjJ3j2UUDwbKtycA+TKOEgYyJmfOpZXtuVa6N/wyYsAZ0HdJJspypYQdPjZ01fqAm75Yivk7APvTVEmbxdgzW98kuUYMtzt1qGkEQA9AaMrhP6CdxCuXh4OCV6zEfEec8W2B8uKfDt2FJ/wmJiyykDCWbFw=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c4d5ff-6d6a-4cb8-ca71-08d7f7f1a89c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 10:29:18.6979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+eD58fZDvBfEnQKvOOctQ28M6Xb3rSKSl1eqJzvF1HTqKmKvJ1qDdrfAnrCbzB9Zh5OJMAN1XjnhBbPX1tJ3P5CAuumJmt3PCOEuZXcbQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB6752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series covers a use case where an embedded system is
disciplining an internal clock to a GNSS signal, which provides a
stable frequency, and wants to act as a PTP Grandmaster by disciplining
a ptp clock to this internal clock.

In our setup a 10Mhz oscillator is frequency adjusted so that a derived
pps from that oscillator is in phase with the pps generated by 
a gnss receiver.

An other derived clock from the same disciplined oscillator is used as
ptp_clock for the ethernet mac.

The internal pps of the system is forwarded to one of the auxiliary inputs
of the MAC.

Initially the mac time registers are considered random.
We want the mac nanosecond field to be 0 on the auxiliary pps input edge.


PATCH 1/3: 
	The stmmac gmac3 version used in the setup is patched to retrieve a
	timestamp at the rising edge of the aux input and to forward
	it to userspace.

* What matters here is that we get the subsecond offset between the aux 
edge and the edge of the PHC's pps. *


PATCH 2,3/3:

	We want the ptp clock to be in time with our aux pps input.
	Since the ptp clock is derived from the system oscillator, we
	don't want to do frequency adjustements.

	The stmmac driver is patched to allow to set the coarse correction
	mode which avoid to adjust the frequency of the mac continuously
	(the default behavior), but instead, have just one
	time adjustment.


We calculate the time difference between the mac and the internal
clock, and adust the ptp clock time with clock_adjtime syscall.


To summarize this in a user-space program:

****
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

#include <arpa/inet.h>
#include <net/if.h>

#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <sys/timex.h>

#include <linux/ptp_clock.h>
#include <linux/net_tstamp.h>
#include <linux/sockios.h>

#define NS_PER_SEC 1000000000LL

#define CLOCKFD 3

#define FD_TO_CLOCKID(fd) \
	((clockid_t) ((((unsigned int) ~fd) << 3) | CLOCKFD))


static inline int clock_adjtime(clockid_t id, struct timex *tx)
{
	return syscall(__NR_clock_adjtime, id, tx);
}

int main(void)
{
	int fd;
	struct timex tx = {0};
	struct ifreq ifreq = {0};
	struct hwtstamp_config cfg = {0};
	struct ptp_extts_event event = {0};
	struct ptp_extts_request extts_request = {
		.index = 0,
		.flags = PTP_RISING_EDGE | PTP_ENABLE_FEATURE
	};

	const char *iface = "eth0";
	const char *ptp_dev = "/dev/ptp2";

	strncpy(ifreq.ifr_name, iface, sizeof(ifreq.ifr_name) - 1);
	ifreq.ifr_data = (void *) &cfg;
	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);

	if (fd < 0)
		return 1;

	if (ioctl(fd, SIOCGHWTSTAMP, &ifreq) < 0)
		return 1;

	// Activate coarse mode for stmmac
	cfg.flags |= HWTSTAMP_FLAGS_ADJ_COARSE;
	cfg.flags &= ~HWTSTAMP_FLAGS_ADJ_FINE;

	if (ioctl(fd, SIOCSHWTSTAMP, &ifreq) < 0)
		return 1;

	fd = open(ptp_dev, O_RDWR);

	if (fd < 0)
		return 1;

	// Enable extts input index 0
	if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request) < 0)
		return 1;

	// Read extts
	if (read(fd, &event, sizeof(event)) != sizeof(event))
		return 1;

	// Correct phc time subsecond: note that this does not correct the phc
	// second count for concision. The delta is (event.t.nsec - NS_PER_SEC).
	tx.modes = ADJ_SETOFFSET | ADJ_NANO;
	tx.time.tv_sec = -1;
	tx.time.tv_usec = event.t.nsec;

	if (clock_adjtime(FD_TO_CLOCKID(fd), &tx))
		return 1;

	// Disable extts index 0
	extts_request.index = 0;
	extts_request.flags = 0;

	if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request) < 0)
		return 1;

	return 0;
}
****

Artem Panfilov (1):
  net: stmmac: GMAC3: add auxiliary snapshot support

Olivier Dautricourt (2):
  net: uapi: Add HWTSTAMP_FLAGS_ADJ_FINE/ADJ_COARSE
  net: stmmac: Support coarse mode through ioctl

 .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  3 +-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 24 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  9 ++--
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 10 +++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 21 ++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 47 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.h  | 20 ++++++++
 include/uapi/linux/net_tstamp.h               | 12 +++++
 net/core/dev_ioctl.c                          |  3 --
 9 files changed, 133 insertions(+), 16 deletions(-)

-- 
2.17.1

