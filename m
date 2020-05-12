Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80091CF52A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgELNBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:01:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49972 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727859AbgELNBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:01:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9DED920075;
        Tue, 12 May 2020 13:01:44 +0000 (UTC)
Received: from us4-mdac16-2.at1.mdlocal (unknown [10.110.49.148])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9B7348009B;
        Tue, 12 May 2020 13:01:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3FC084008A;
        Tue, 12 May 2020 13:01:43 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CF66C580094;
        Tue, 12 May 2020 13:01:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 May
 2020 14:01:27 +0100
Subject: Re: [PATCH net-next 2/8] sfc: make capability checking a nic_type
 function
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
 <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
 <20200511153636.0f9cd385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <05438101-2706-e791-abd3-e52694fdfe9c@solarflare.com>
Date:   Tue, 12 May 2020 14:01:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200511153636.0f9cd385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25414.003
X-TM-AS-Result: No-4.315900-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL9TJDl9FKHbrljLp8Cm8vwFwoe
        RRhCZWIB3MJzkJ3+U/XsW5cPdFl0/pE4FU2ZdQO4GjzBgnFZvQ42peumOpNjtBAdD7sCRtOxuYT
        mfPxyM3h7RiXLCorjz8LudCkv+zQyeIh1rW8bWHm84C/3iwAgxKbwyy5bAB/921KK0dlzZ7r+ez
        fog1uF08cf83XSWDzmK8CAdxh72JKDdmeMibEYB6JVTu7sjgg1SuH+GfgmQGe9V4YavKxf483+w
        mITvMn4585VzGMOFzAQVjqAOZ5cjQtuKBGekqUpm+MB6kaZ2g4eMNFq12xjtyydBWABzJXYjctz
        99r8+0Hu0Gop94Mor46iUi3d0e1p9cf9j6Mwhr7G1pj5SA3d/3ISmDYA39NZpEePV+HP7SWHzGT
        HoCwyHhlNKSp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.315900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25414.003
X-MDID: 1589288503-5VeFGF_yKU6k
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/05/2020 23:36, Jakub Kicinski wrote:
> Also with W=1:
>
>  ../drivers/net/ethernet/sfc/siena.c:951:14: warning: symbol 'siena_check_caps' was not declared. Should it be static?
> 1a3,5
>  ../drivers/net/ethernet/sfc/siena.c:951:14: warning: no previous prototype for â€˜siena_check_capsâ€™ [-Wmissing-prototypes]
>    951 | unsigned int siena_check_caps(const struct efx_nic *efx,
>        |              ^~~~~~~~~~~~~~~~
Yup, it turns out not only is this missing 'static' but it's also not
 used — the assignment into siena_a0_nic_typeis missing, I must have
 screwed up a rebase at some point.  I'll send a follow-up, since Dave
 has already applied it.  Thanks for the review.

(And I'll try to get in the habit of checking the SOBs better; sorry
 about that.  I'm still used to the old "first sign-off is the point
 of exit from the company" flow; plus I messed up my checkpatch
 invocation in a way that prevented it catching this.)

-ed
