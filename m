Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B91B64EA17
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiLPLQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiLPLQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:16:41 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC9B566F2;
        Fri, 16 Dec 2022 03:16:41 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 0790732005B5;
        Fri, 16 Dec 2022 06:16:39 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 16 Dec 2022 06:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1671189399; x=
        1671275799; bh=urmZCaqP5uUKG9f3w/5JTsr/NxjJLfj/bS5O5zJbL3k=; b=B
        P9QPaWyUZsW0J7NWwNNXiRe/NP294gh+txwjjTkkU7clAeWF6FQVMwjQPV++4p1G
        7zFWR2NZpqnvdtedG0DPxcX0WJ5f1gT450S+q96g0V7/x8i1qpxhKnnQFLO3QAfS
        sKp/ijlHu1aKWKhWG3rt6l42y1GQxjdALSSObWQH1iPo+1dEBoF/J+lr7N8Sst32
        fNnN98J8FL767UA7dMHFGUxba6wuqILe4HlKqwngxvEWCfCWVoA70R13rKvAytDa
        pvY//qtyEeKZvD7dtLw5bG/u6lJl0g/uUEn3PC2rmoremmWGeEnCoTKj+5YVTHuX
        NTpScNCJLj0Veh/qWENzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671189399; x=
        1671275799; bh=urmZCaqP5uUKG9f3w/5JTsr/NxjJLfj/bS5O5zJbL3k=; b=h
        JIGQ2wRfu8pouckzEfxNWbPfRSPaO6SywY5VipBipFb0SYlKTf2BU8rQETn7goSG
        ZuxIpeT9eDYAza2ft8WopgRVO8PQsRJYejVHzw1l/7WrzETdahgwh1dqKoj8gRhk
        zjKxAnrdOQH1s8vgq1Pcxjf4LkpU1pxVakRPnprG+IurIzY8pMXgmCGII3trEqqF
        wtuZRnlvP7SXRhNZr4ShfO+zGsYmWpdBQipfyMVfY+BJvoquqpC8ms4Bz6gxQvE6
        NP/fQPmjyv2ZKdpMCJS1XRSfC0CSylaOVKRkDIK9Ojy1bZad6S25sf36DPHbsl8B
        kBY6Jv0MDpVr6tNR8VcBQ==
X-ME-Sender: <xms:llOcYyL18Ft-JhsVdpqThXN3ciCGyoPjree7-ZSiqUKwI-iVCFQiuw>
    <xme:llOcY6IHI2ErJgRxFa7y5Ta25FW5I7Agjy_16qzgYiZpHjehyclz5LeS3mNiOHVah
    rSIE1oZntNowtGQ1h0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepgeefjeehvdelvdffieejieejiedvvdfhleeivdelveehjeelteegudektdfg
    jeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:llOcYyskflETP8t1zefHbbyYYHF2Uce1IHgY2irqUlMRMKLH1P3tNA>
    <xmx:llOcY3Z0u-2oIYML-ikr6AGGk4c9eEZPJQ5z0MSS-3YpDQY39XnCkA>
    <xmx:llOcY5ZefpA51A6Ke9qK5v6ptX6wpZkzmJzdnzJaNB8W0oLhM2rkWA>
    <xmx:l1OcY7meDvbcNTtSMtNfYLNJraVZY_-_AxQX_DzFIrNdCymRfxvT_Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D009AB60086; Fri, 16 Dec 2022 06:16:38 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <486f9bc9-408f-4c29-b675-cbd61673f58c@app.fastmail.com>
In-Reply-To: <87k02sd1uz.fsf@toke.dk>
References: <20221215165553.1950307-1-arnd@kernel.org>
 <87k02sd1uz.fsf@toke.dk>
Date:   Fri, 16 Dec 2022 12:16:17 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Arnd Bergmann" <arnd@kernel.org>, "Kalle Valo" <kvalo@kernel.org>,
        "Pavel Skripkin" <paskripkin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: use proper statements in conditionals
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022, at 18:16, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> index 30f0765fb9fd..237f4ec2cffd 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -327,9 +327,9 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB=
(struct sk_buff *skb)
>>  }
>> =20
>>  #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>> -#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv =
? (expr) : 0)
>> -#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
>> -#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q=
]++)
>> +#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_=
priv ? (expr) : 0); } while (0)
>> +#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued+=
+); } while (0)
>> +#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_st=
ats[q]++); } while (0)
>
> Hmm, is it really necessary to wrap these in do/while constructs? AFAI=
CT
> they're all simple statements already?

It's generally safer to do the same thing on both side of the #ifdef.

The "do { } while (0)" is an empty statement that is needed to fix
the bug on the #else side. The expressions you have on the #ifdef
side can be used as values, and wrapping them in do{}while(0)
turns them into statements (without a value) as well, so fewer
things can go wrong when you only test one side.

I suppose the best solution would be to just use inline functions
for all of them and get rid of the macros.

     Arnd
