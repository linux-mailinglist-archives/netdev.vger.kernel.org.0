Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160D21E4405
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388546AbgE0NlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:41:23 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:43773 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgE0NlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:41:23 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N7Qp3-1ixLzb0LZl-017j0Y; Wed, 27 May 2020 15:41:14 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Alex Maftei (amaftei)" <amaftei@solarflare.com>,
        Tom Zhao <tzhao@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] sfc: avoid an unused-variable warning
Date:   Wed, 27 May 2020 15:41:06 +0200
Message-Id: <20200527134113.827128-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:2qV0ouQ231GRn5/kmWBmCmf9v/l6VkWkkO3TQdHRDfHjfMM+7ni
 uNhtbVK3yyHkAKZcYRcmUOtm9iCNP0EJwVz8jtshL8KiO72f7c7oRw8njgaQMbX7LD3RmCt
 6eQMcNDRSdNV5euilakJ078ge8+A2zQrCjKcQ58RAv96TdUAmOUNyAptZy+nG254GOrDmIb
 mWZ21CET7e5EYyb9j2RRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xyZRuz9UDIc=:ROAlNwSe1jkIIEWyvDI7sy
 b4OxXNEOVdY3DzEPD+lC8Y4PLENkqKSEfAsl1yXE6SlNx0c2DQAa4coaw2TnbqwdQEXIOsa9h
 oKwAAmbni18D996g/cKxF3OfljaLKdFUNWug0DLb+pIz9ryqJDd/qI1NmDwjFErNTBt/3xec1
 dI+SwVJQsFGnuRR/pK1AtiisYgeD30kJQzUoKUF6fWFBWMi25gQw75g4MldGR9T/TbfWRT5Pl
 diwIA+VkipOpLdYg09S0/yDFTaFIx4LaArr5vTY+cuRQTD9ddpGiNPsBYJz7utG7Icgf23KHz
 9Jfjir+liGxJt4vmZkS/a5CSMQTymez0JegbR5SqPD8Bg6ELX9SyXiKlSk+dszBuu05Cc4mBY
 IbLWKF8W+WN8nuoUaUdLc2Bg6WC8gfCAuB6k7ln8Wk9l7uBP+m8RPpKlxuMfZ+lBm6Nl7kOuM
 r+RACoXjZSCoAzuNp6vKd76UYy6PW+trZBWiV0Crv/dpGrkDIEFrXFA7tXgDzx+dzhGQWHmSO
 hlDTUAEnmT5qZzugIC0XnyNbJJtHrn7B0lewu95cZ+7Rj8JCC6ZKd70KwCca2ScszqeGhBYNm
 n+F0E8Q33P7pUCzs2Aka6Jnu5ZFRMs+NgrcClvG1HZ/MPkNca2h7tav7hJoG+2Rq6dzHeS8w6
 Sk2stqiNbXXPWWXUS3eX4l2lezOC2izmSnmsLU8tHJTqwSwoIonw+Q+MnmNNutZ3ptbNhkVb1
 jIMEjurL55VygZqdIKBeX+nz96Y7NIz6S062I0J8qrdVkyztSQ9iYd+ij9f1YGXqo3gvXNYZe
 1MGFsIy0OsZRBeS8bI0yCZ9IT5dSy92+ZnG8vX1hIBztW2OrhM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'nic_data' is no longer used outside of the #ifdef block
in efx_ef10_set_mac_address:

drivers/net/ethernet/sfc/ef10.c:3231:28: error: unused variable 'nic_data' [-Werror,-Wunused-variable]
        struct efx_ef10_nic_data *nic_data = efx->nic_data;

Move the variable into a local scope.

Fixes: dfcabb078847 ("sfc: move vport_id to struct efx_nic")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index e634e8110585..964c5e842cec 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3228,7 +3228,6 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 static int efx_ef10_set_mac_address(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_VADAPTOR_SET_MAC_IN_LEN);
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	bool was_enabled = efx->port_enabled;
 	int rc;
 
@@ -3256,6 +3255,7 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 
 #ifdef CONFIG_SFC_SRIOV
 	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
+		struct efx_ef10_nic_data *nic_data = efx->nic_data;
 		struct pci_dev *pci_dev_pf = efx->pci_dev->physfn;
 
 		if (rc == -EPERM) {
-- 
2.26.2

