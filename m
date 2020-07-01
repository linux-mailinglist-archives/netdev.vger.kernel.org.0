Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA6E210DC1
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbgGAOcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:32:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:46262 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731328AbgGAOcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:32:14 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 98FA42005F;
        Wed,  1 Jul 2020 14:32:13 +0000 (UTC)
Received: from us4-mdac16-67.at1.mdlocal (unknown [10.110.49.162])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9754C8009B;
        Wed,  1 Jul 2020 14:32:13 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2F2E140078;
        Wed,  1 Jul 2020 14:32:13 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E7F3740084;
        Wed,  1 Jul 2020 14:32:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:32:07 +0100
Subject: Re: [PATCH net-next] sfc: remove udp_tnl_has_port
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mhabets@solarflare.com>,
        <linux-net-drivers@solarflare.com>
References: <20200630225038.1190589-1-kuba@kernel.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <29d3564b-6bcc-9df7-f6a9-3d3867390e15@solarflare.com>
Date:   Wed, 1 Jul 2020 15:32:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200630225038.1190589-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-2.094600-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9L7DjpoDqNZmA6UrbM3j3qQVF
        HBHRPrhRNealxAIT8MXkv2xupLQ6wpcLewwAa76fC4s/hE51YdUrXO/DnwR5yxW+93iqRvX7pIs
        onG6IBJKVta6x57a423qFMKsSZiAboycGiHkOAtBntBdRwfYtoWiatLqAxumkmyiLZetSf8kir3
        kOMJmHTBQabjOuIvShC24oEZ6SpSmcfuxsiY4QFC9oQZZd6fZpel0W6peXu3nvZm6DDMsy8pK59
        x+vTIv4B6G9fuGZE4dJLeZHuU4g/EACbK/alPw7iOh5UN/BWNwW9N7A+/IhX4fMZMegLDIeGU0p
        Knas+RbnCJftFZkZizYJYNFU00e7YDttQUGqHZU=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.094600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593613933-I_4v6SRVpqdP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2020 23:50, Jakub Kicinski wrote:
> Nothing seems to have ever been calling this.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
That was intended to be used by encap offloads (TX csum and TSO), which
 we only recently realised we hadn't upstreamed the rest of; the
 udp_tnl_has_port method would be called from our ndo_features_check().
I'll try to get to upstreaming that support after ef100 is in, hopefully
 within this cycle, but if you don't want this dead code lying around in
 the meantime then have an
Acked-by: Edward Cree <ecree@solarflare.com>
 and I can revert it when I add the code that calls it.
(And don't worry, ef100 doesn't use ugly port-based offloads; it does
 proper CHECKSUM_PARTIAL and GSO_PARTIAL, so it won't have this stuff.)

-ed
