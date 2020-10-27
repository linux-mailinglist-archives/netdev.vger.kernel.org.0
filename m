Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFD29CC60
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832571AbgJ0W4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:56:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:4850 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1832619AbgJ0W4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 18:56:40 -0400
IronPort-SDR: y4UgJofeW97Nytpq2bzPJfQmjztpdc5VA8QCouaXpFwzVs5D5615MBHWNputnLIBlSRLPMHcnm
 FCJXYbT5Wv1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="168304817"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="168304817"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:56:38 -0700
IronPort-SDR: pf6DV1vVwxseNaqXFU3YAALoqn2vd9RmJW2k5Ug22jgRFGT6r/+pOYRVK5t3557MEGoeYglvOl
 x0SqrpYpENxg==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="350777327"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.204.205]) ([10.212.204.205])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:56:38 -0700
To:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Subject: checkpatch.pl broke in net-next
Organization: Intel Corporation
Message-ID: <e8ea2204-b74a-3b75-c257-0f8acbb916a6@intel.com>
Date:   Tue, 27 Oct 2020 15:56:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

It looks like net-next just pulled in a change to checkpatch.pl which
causes it to break:

$ ./scripts/checkpatch.pl
Global symbol "$gitroot" requires explicit package name (did you forget
to declare "my $gitroot"?) at ./scripts/checkpatch.pl line 980.
Execution of ./scripts/checkpatch.pl aborted due to compilation errors.
ERROR: checkpatch.pl failed: 255

It is caused by commit f5f613259f3f ("checkpatch: allow not using -f
with files that are in git"), which appears to make use of "$gitroot".

This variable doesn't exist, so of course the perl script breaks.

This commit appears in Linus' tree, and must have been picked up when we
merged with his tree.

This issue is fixed by 0f7f635b0648 ("checkpatch: enable GIT_DIR
environment use to set git repository location") which is the commit
that actually introduces $gitroot.

Any chance we can get this merged into net-next? It has broken our
automation that runs checkpatch.pl

Thanks,
Jake
