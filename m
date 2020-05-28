Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9667F1E5E65
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388406AbgE1LgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:36:00 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34530 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388326AbgE1Lf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 07:35:59 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F38B160060;
        Thu, 28 May 2020 11:35:58 +0000 (UTC)
Received: from us4-mdac16-47.ut7.mdlocal (unknown [10.7.66.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F13982009A;
        Thu, 28 May 2020 11:35:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6FE031C0052;
        Thu, 28 May 2020 11:35:28 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1300570006D;
        Thu, 28 May 2020 11:35:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 May
 2020 12:35:20 +0100
Subject: Re: [PATCH net-next 0/2] net/mlx5e: add nat support in ct_metadata
To:     <wenxu@ucloud.cn>, <paulb@mellanox.com>, <saeedm@mellanox.com>
CC:     <netdev@vger.kernel.org>
References: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c9b94b29-5a1a-8812-f9fa-b921a7a9e7c7@solarflare.com>
Date:   Thu, 28 May 2020 12:35:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25446.003
X-TM-AS-Result: No-0.101000-8.000000-10
X-TMASE-MatchedRID: fgYTp5XatxbmLzc6AOD8DfHkpkyUphL9NV9S7O+u3KYda1Vk3RqxOKTA
        VMIKlsVHEZQta9bCaojMxWUqHxw9jL8q1zjO7UWhvVl3GmT9KRwyJlZlUbAvWJsoi2XrUn/JIq9
        5DjCZh0wUGm4zriL0oQtuKBGekqUpm+MB6kaZ2g7+8HrOg0zkhtCzpMVzjvAtkSWwgLcoTj1jai
        BgSHLf3ZFk8vn/Dh1emFkoJOGtT8BPB4RXMowqUKya+JONBRhxhT3m8tWLb0iHzGTHoCwyHhlNK
        Sp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.101000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25446.003
X-MDID: 1590665728-aZWs14w5d0xu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2020 08:15, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Currently all the conntrack entry offfload rules will be add
> in both ct and ct_nat flow table in the mlx5e driver. It is
> not makesense.
>
> This serise provide nat attribute in the ct_metadata action which
> tell driver the rule should add to ct or ct_nat flow table 
I don't understand why changes to the core are needed.
A conntrack entry should be a NAT if and only if it has
 FLOW_ACTION_MANGLE actions.  AIUI this is sufficient information
 to distinguish NAT from non-NAT conntrack, and there's no need
 for an additional bool in ct_metadata.
But it's possible my understanding is wrong.

-ed
