Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155AC1797A8
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgCDSQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:16:27 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52536 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbgCDSQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:16:27 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 29C91B8005A;
        Wed,  4 Mar 2020 18:16:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 4 Mar 2020
 18:16:15 +0000
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <thomas.lendacky@amd.com>,
        <benve@cisco.com>, <_govind@gmx.com>, <pkaustub@cisco.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <snelson@pensando.io>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jeffrey.t.kirsher@intel.com>, <jacob.e.keller@intel.com>,
        <michael.chan@broadcom.com>, <saeedm@mellanox.com>,
        <leon@kernel.org>, <netdev@vger.kernel.org>
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-2-kuba@kernel.org>
 <20200304075926.GH4264@unicorn.suse.cz>
 <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
 <45b3c493c3ce4aa79f882a8170f3420d348bb61e.camel@linux.intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <410f35ef-b023-1c24-f7e7-2724bae121ff@solarflare.com>
Date:   Wed, 4 Mar 2020 18:16:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <45b3c493c3ce4aa79f882a8170f3420d348bb61e.camel@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25268.003
X-TM-AS-Result: No-3.458400-8.000000-10
X-TMASE-MatchedRID: O/y65JfDwwvmLzc6AOD8DfHkpkyUphL9vMRNh9hLjFmYeMTPaAHLLcTr
        /G24o7RrDoU0NWBqzAFMPoFLAOXpHfr7uaNX5h+59FQh3flUIh4bAqzdFRyxuGh76/bDpGEryMM
        mqnLQ9DUvVHX///pviM2BzhpDD8tiPB7z3tT8+MKeAiCmPx4NwJwhktVkBBrQayvnI0oh5pdQSF
        bL1bvQASdET58jp62SrLJwwtub1Elzz1RcEe5xp8lXzbtQfV+AQvr9+m/XI8ylGn2M+CRilaKAQ
        fLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.458400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25268.003
X-MDID: 1583345786-f06Z2btFIei9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/03/2020 18:12, Alexander Duyck wrote:
> So one thing I just wanted to point out. The used_types won't necessarily
> be correct because it is only actually checking for non-zero types. There
> are some of these values where a zero is a valid input
Presumably in the netlink ethtool world we'll want to instead check if
 the attribute was passed?  Not sure but that might affect what semantics
 we want to imply now.
