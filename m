Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9AB9622D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbfHTOPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:15:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59246 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729762AbfHTOPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:15:24 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E2F76A40096;
        Tue, 20 Aug 2019 14:15:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 20 Aug
 2019 07:15:17 -0700
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jakub.kicinski@netronome.com>, <jiri@resnulli.us>,
        <vladbu@mellanox.com>
References: <20190820105225.13943-1-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
Date:   Tue, 20 Aug 2019 15:15:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190820105225.13943-1-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24858.005
X-TM-AS-Result: No-3.996300-4.000000-10
X-TMASE-MatchedRID: csPTYAMX1+EbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizy9K1jOJyKSaxpu
        cUfHeAYFYBvFeBi5hVwU+XxHR7shmcf2eXl6VFIUnMQdNQ64xfcvXkmKVNgrfoYZnWnmoyARbBU
        Wr0rJkZb+ZMYcdCElL2KeBpw0S0VLetHSA0D98/EYb31sdExP27zETYfYS4xZjiLABC6i+1gwHg
        2tXEUFqJtgZDIw5SUrnagtny7ZPcS/WXZS/HqJ2tAtbEEX0MxBxEHRux+uk8ifEzJ5hPndGQPDg
        aqQOnZEKQxd0sLKdQ6g0tpoi8GQBXs6IBGiGwpMc4sbUG/MKN1DDx0E5CwA3eqKL3eu6ngHVVMd
        h382zdNDrUFI5NgpnNQ17CngTb9OBKmZVgZCVnezGTWRXUlrxxtsJUxyzWNSVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.996300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24858.005
X-MDID: 1566310523-JbCC8AW6UiM4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2019 11:52, Pablo Neira Ayuso wrote:
> The existing infrastructure needs the front-end to generate up to four
> actions (one for each 32-bit word) to mangle an IPv6 address. This patch
> allows you to mangle fields than are longer than 4-bytes with one single
> action. Drivers have been adapted to this new representation following a
> simple approach, that is, iterate over the array of words and configure
> the hardware IR to make the packet mangling. FLOW_ACTION_MANGLE_MAX_WORDS
> defines the maximum number of words from one given offset (currently 4
> words).
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
What's the point of this?
Why do you need to be able to do this with a single action?  It doesn't
 look like this extra 70 lines of code is actually buying you anything,
 and it makes more work for any other drivers that want to implement the
 offload API.
