Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B629A965CA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfHTQAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:00:43 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56582 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbfHTQAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 12:00:42 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F0A40A40094;
        Tue, 20 Aug 2019 16:00:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 20 Aug
 2019 09:00:28 -0700
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <jiri@resnulli.us>, <vladbu@mellanox.com>
References: <20190820105225.13943-1-pablo@netfilter.org>
 <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
 <20190820144453.ckme6oj2c4hmofhu@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c8a00a98-74eb-9f8d-660f-c2ea159dec91@solarflare.com>
Date:   Tue, 20 Aug 2019 17:00:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190820144453.ckme6oj2c4hmofhu@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24858.005
X-TM-AS-Result: No-0.209100-4.000000-10
X-TMASE-MatchedRID: pBwXUM+nCwsbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizziXr4PGSaEWM8J
        UuVypuWwB4Co4PVKNKkhIV9c+BD6MkUoQAen0GQcKf/HxnllDygLBPYMfuIybh1rVWTdGrE4QXQ
        Js8w+HtLnzlXMYw4XMKHUf3pt8cg10C1sQRfQzEHEQdG7H66TyJ8TMnmE+d0ZFFXVg9UmWWDqBd
        lb9z4SQsz/oub4GvCvR90Chiz7xZvi+fTMx9KaNitss6PUa4/cD6GAt+UbooSj1CO4X0Eqeb0SA
        hXRHTr3ZyMWcibO/JI=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.209100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24858.005
X-MDID: 1566316833-jeWVkV15BaN2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2019 15:44, Pablo Neira Ayuso wrote:
> It looks to me this limitation is coming from tc pedit.
>
> Four actions to mangle an IPv6 address consume more memory when making
> the translation, and if you expect a lot of rules.
Your change means that now every pedit uses four hw entries, even if it
 was only meant to be a 32-bit mangle.  Host memory used to keep track of
 the pedit actions is cheap, hw entries in pedit tables are not.  Nor is
 driver implementation complexity.
NAK.
