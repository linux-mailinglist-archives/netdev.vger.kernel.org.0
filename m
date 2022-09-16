Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3AB5BB307
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiIPTyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiIPTyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:54:23 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E299B99FC;
        Fri, 16 Sep 2022 12:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vFiZ6J6rKleWghPafAo9+rN4nJo/ie0UFtGpkuXvE18=; b=IpiW7HKn1yvZMBBTCQ0QCCGW9q
        0WHcGrM1WPfNg4Kcwta9mynVdqSovYgsH/48fWxxaQX/2Wx8cF+86xKJ1+Ctwi4J5nY+TEVvdZaHI
        ba5YHAdFvWQ7HLY8o3OB8zB0LuAxtXcq5YUOUHa60RJQdrh0vt4A28LVtLflsoM0aALE=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oZHPR-0005s5-F9; Fri, 16 Sep 2022 21:53:57 +0200
Message-ID: <7f09367e-2236-692c-4adf-cb262ff1c109@engleder-embedded.com>
Date:   Fri, 16 Sep 2022 21:53:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc
 max SDU
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-11-vladimir.oltean@nxp.com>
 <ecf497e3-8934-1046-818e-4ee5dc5889eb@engleder-embedded.com>
 <20220916135752.abmpagmyjt4gnolk@skbuf>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20220916135752.abmpagmyjt4gnolk@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.09.22 15:57, Vladimir Oltean wrote:
> On Thu, Sep 15, 2022 at 09:01:19PM +0200, Gerhard Engleder wrote:
>> Does it make any difference if the MAC already guarantees that too
>> long frames, which would violate the next taprio interval, will not
>> be transmitted?
> 
> This is not, in essence, about gate overruns, but about transmitting
> packets larger than X bytes for a traffic class. It also becomes about
> overruns and guard bands to avoid them, only in relation to certain
> hardware implementations.
> 
> But it could also be useful for reducing latency in a given time slot
> with mixed traffic classes where you don't have frame preemption.
> 
>> MACs are able to do that, switches not.
> 
> Switches could in principle be able to do that too, but just in store
> and forward mode (not cut-through).
> 
>> The user could be informed, that the MAC is considering the length of the
>> frames by accepting any max_sdu value lower than the MTU of the netdev.
> 
> By accepting any max_sdu lower than the MTU of the netdev, I would
> expect that the observable behavior is that the netdev will not send any
> frame for this traffic class that is larger than max_sdu. But if you
> accept the config as valid and not act on it, this will not be enforced
> by anyone. This is because of the way in which the taprio qdisc works in
> full offload mode.

Ok, denying max_sdu makes sense. It can be used to prevent too large
frames for a traffic class by discarding them.

In my opinion for MACs a software implementation would make sense even
in full offload mode, because it would prevent copying frames from RAM
to MAC which are discarded anyway. But that should be decided driver
specific.

Thanks for your explanations!
