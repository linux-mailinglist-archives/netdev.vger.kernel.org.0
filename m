Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD22521DDC
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbiEJPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345721AbiEJPQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:16:22 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE0C1F3EAD;
        Tue, 10 May 2022 07:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x1CTARxTCcBRmbOr4xdk6jXfgn0v4S9YKk4prgzATyE=; b=UleV9ZTWCCUELqwT4Zl/Uyh1D8
        h/koyeCGeQ+PSs1/86JHD39OsfbdjRYromqJT11p00JgkD4b42U9LBVnjjKZ58nBoQPc2+J+U+kJR
        uX0yVmQsX/X7GqwdEQ9UZT5Bl7c69a5CH0LsBaf5A8DrLsVJUpLiQpWRlHHxHOxta6Pk=;
Received: from p200300daa70ef200fccd1f935f1cf3cd.dip0.t-ipconnect.de ([2003:da:a70e:f200:fccd:1f93:5f1c:f3cd] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1noRDl-0000yY-5w; Tue, 10 May 2022 16:52:17 +0200
Message-ID: <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
Date:   Tue, 10 May 2022 16:52:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20220510123724.i2xqepc56z4eouh2@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.05.22 14:37, Vladimir Oltean wrote:
> On Tue, May 10, 2022 at 11:40:13AM +0200, Felix Fietkau wrote:
>> Padding for transmitted packets needs to account for the special tag.
>> With not enough padding, garbage bytes are inserted by the switch at the
>> end of small packets.
> 
> I don't think padding bytes are guaranteed to be zeroes. Aren't they
> discarded? What is the issue?
With the broken padding, ARP requests are silently discarded on the 
receiver side in my test. Adding the padding explicitly fixes the issue.

- Felix
