Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7746B28A41B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbgJJWzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbgJJTWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:22:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 555EB2240C;
        Sat, 10 Oct 2020 16:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602348673;
        bh=O7G/XCcPTVmLB+LfQ658dP8/bq3RxUpJpXT8EjDdMTA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u4qTV5kSVp7kUBKH8c/SjkbRQfmUs2QzSqgSymfpt1QlVirFKJq/iU0qqpiwH+4NC
         0KpT1i2VnRu8Q1HeFm5NKffN3f8efGJWlLi38y/9BdkBWXIiP6GtbVnLht2z3Va9sR
         2xk8TE1YgDJcaHj8dNu1FWEQbuXVtsUCohz44BrE=
Date:   Sat, 10 Oct 2020 09:51:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Subject: Re: pull-request: wireless-drivers-next-2020-10-09
Message-ID: <20201010095111.655b32ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201009160759.A44E1C433FE@smtp.codeaurora.org>
References: <20201009160759.A44E1C433FE@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 16:07:59 +0000 (UTC) Kalle Valo wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> The following changes since commit c2568c8c9e636a56abf31da4b28b65d3ded02524:
> 
>   Merge branch 'net-Constify-struct-genl_small_ops' (2020-10-04 21:13:36 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-2020-10-09
> 
> for you to fetch changes up to b7d96bca1f004b5f26ee51ea9c9749a28dac8316:
> 
>   Revert "iwlwifi: remove wide_cmd_header field" (2020-10-09 18:04:50 +0300)

Pulled, thanks Kalle!

Intel folks - do you really need to pack all your structs? 
Do they come from the device unaligned or something?

+/**
+ * struct iwl_statistics_duration_ntfy
+ *
+ * @hdr: general statistics header
+ * @cont_burst_chk_cnt: number of times continuation or
+ *      fragmentation or bursting was checked
+ * @cont_burst_cnt: number of times continuation or fragmentation
+ *      or bursting was successful
+ * @wait_for_silence_timeout_cnt: ???
+ * @reserved: reserved
+ */
+struct iwl_statistics_duration_ntfy {
+       struct iwl_statistics_ntfy_hdr hdr;
+       __le32 cont_burst_chk_cnt;
+       __le32 cont_burst_cnt;
+       __le32 wait_for_silence_timeout_cnt;
+       __le32 reserved;
+} __packed; /* STATISTICS_DURATION_NTFY_API_S_VER_1 */
