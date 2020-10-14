Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6578B28D908
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 05:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgJND6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 23:58:24 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:53106 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729395AbgJND6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 23:58:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 61EF91730847;
        Wed, 14 Oct 2020 03:58:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:2904:3138:3139:3140:3141:3142:3352:3865:3867:3870:4321:4605:5007:10004:10400:10848:11026:11233:11473:11657:11658:11914:12043:12262:12296:12297:12438:12555:12679:12740:12760:12895:13439:14096:14097:14181:14659:14721:21080:21324:21365:21451:21627:21990:30029:30030:30054:30055:30064:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: pail67_620b2a027208
X-Filterd-Recvd-Size: 3589
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Wed, 14 Oct 2020 03:58:20 +0000 (UTC)
Message-ID: <73e7098a7dacbbc3a3b77065222f488e23e17201.camel@perches.com>
Subject: iwlwifi: spaces in procfs filenames ?
From:   Joe Perches <joe@perches.com>
To:     Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org
Date:   Tue, 13 Oct 2020 20:58:18 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 64fa3aff89785b5a924ce3934f6595c35b4dffee
Author: Sharon Dvir <sharon.dvir@intel.com>
Date:   Wed Aug 17 15:35:09 2016 +0300

    iwlwifi: pcie: give a meaningful name to interrupt request

perhaps unintentionally for file:

drivers/net/wireless/intel/iwlwifi/pcie/internal.h
in function static inline const char *queue_name

creates spaces in procfs filenames.

drivers/net/wireless/intel/iwlwifi/pcie/internal.h:static inline const char *queue_name(struct device *dev,
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                                  struct iwl_trans_pcie *trans_p, int i)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-{
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     if (trans_p->shared_vec_mask) {
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             int vec = trans_p->shared_vec_mask &
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                       IWL_SHARED_IRQ_FIRST_RSS ? 1 : 0;
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             if (i == 0)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                     return DRV_NAME ": shared IRQ";
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             return devm_kasprintf(dev, GFP_KERNEL,
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                                   DRV_NAME ": queue %d", i + vec);
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     }
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     if (i == 0)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             return DRV_NAME ": default queue";
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     if (i == trans_p->alloc_vecs - 1)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             return DRV_NAME ": exception";
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     return devm_kasprintf(dev, GFP_KERNEL,
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                           DRV_NAME  ": queue %d", i);
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-}

# find /proc/ | grep " "
/proc/irq/130/iwlwifi: default queue
/proc/irq/131/iwlwifi: queue 1
/proc/irq/132/iwlwifi: queue 2
/proc/irq/133/iwlwifi: queue 3
/proc/irq/134/iwlwifi: queue 4
/proc/irq/135/iwlwifi: exception

Can these names be changed back or collapsed
to avoid the space use in procfs?


