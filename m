Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF7637AA1E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhEKPCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhEKPCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 11:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A5361396;
        Tue, 11 May 2021 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620745297;
        bh=qY7RgSbBhtJrOZl3S+BtvW9dnG8fpGtapUyyA8e+AFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtBCQQSYMVVyYLTTnMTsn/gslJON3WpDPHgBNkGTKUC1k9PthZjW/OtZ96o4H+cZF
         LwvTMrP2wBm39AI5tZe2DYm5TzfkSH3wCMfhhSKUCp3Iw30TLhZQlZg6yTDI0rVkJi
         Cp0YG0xjfKfWFj7NifyKLyxXtnvQGqKzeHggcdlsl+6fqVuIpydbl0xNhG7AzopSb5
         b2yXxyvknpNSQ51guwzH1CPbya2u0hd2x/3xRQdJu4EzB0fHupQUmL7jA2Yv4Sbm7W
         AAlNGDWF8NnmZKENg0iP/V3qjS9NI2YNnV/+NpYqoKRDAxL5ahcH3IT/OMZtIeve/g
         8oQTRSV4Rhzqw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgTt7-000k1I-VT; Tue, 11 May 2021 17:01:33 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 5/5] docs: networking: device_drivers: fix bad usage of UTF-8 chars
Date:   Tue, 11 May 2021 17:01:32 +0200
Message-Id: <95eb2a48d0ca3528780ce0dfce64359977fa8cb3.1620744606.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620744606.git.mchehab+huawei@kernel.org>
References: <cover.1620744606.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probably because the original file was pre-processed by some
tool, both i40e.rst and iavf.rst files are using this character:

	- U+2013 ('–'): EN DASH

meaning an hyphen when calling a command line application, which
is obviously wrong. So, replace them by an hyphen, ensuring
that it will be properly displayed as literals when building
the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/ethernet/intel/i40e.rst         | 4 ++--
 .../networking/device_drivers/ethernet/intel/iavf.rst         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index 8a9b18573688..2d3f6bd969a2 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
@@ -173,7 +173,7 @@ Director rule is added from ethtool (Sideband filter), ATR is turned off by the
 driver. To re-enable ATR, the sideband can be disabled with the ethtool -K
 option. For example::
 
-  ethtool –K [adapter] ntuple [off|on]
+  ethtool -K [adapter] ntuple [off|on]
 
 If sideband is re-enabled after ATR is re-enabled, ATR remains enabled until a
 TCP-IP flow is added. When all TCP-IP sideband rules are deleted, ATR is
@@ -688,7 +688,7 @@ shaper bw_rlimit: for each tc, sets minimum and maximum bandwidth rates.
 Totals must be equal or less than port speed.
 
 For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
-monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
+monitoring tools such as `ifstat` or `sar -n DEV [interval] [number of samples]`
 
 2. Enable HW TC offload on interface::
 
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 52e037b11c97..25330b7b5168 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
@@ -179,7 +179,7 @@ shaper bw_rlimit: for each tc, sets minimum and maximum bandwidth rates.
 Totals must be equal or less than port speed.
 
 For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
-monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
+monitoring tools such as ``ifstat`` or ``sar -n DEV [interval] [number of samples]``
 
 NOTE:
   Setting up channels via ethtool (ethtool -L) is not supported when the
-- 
2.30.2

