Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E425EC73F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiI0PJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiI0PJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:09:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282D8F08A2;
        Tue, 27 Sep 2022 08:09:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r18so21316616eja.11;
        Tue, 27 Sep 2022 08:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=KHLyz6AkS4gp/pOeIr3BypKhbZG4yCjiW/SpU96Iryo=;
        b=cjw8/h7VG0SaIVmCFjdWpsAHxpp3nWFe1RznpM3jek+WCdZFl+Mslsvh/jH11HvKtJ
         AVWFJWhJo8Y6gzmy7DGnbKf/FyFxWPrGMLZXqfqBTcPn18YJxiwqJQfsZDNMqohVTPgJ
         wTTtxLIbVhILuOo/4SdugzMqcaWPXKQlkPHMwwTDcMaHMS72Wjubi9D3PHMf3GEMqUz/
         /2TB9oc2zqC15CD3Iqa1IwrbMZBvVVajmAQzfUV7AE6zAz5ZTfyrQp3Omow7wuRCHv5m
         XozGtO9VY++ihFR91pnLXMIwO6hK1QSlV5nzS9ElZAXcQyN46sB5j+ntvkft+ONQsAg+
         NzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=KHLyz6AkS4gp/pOeIr3BypKhbZG4yCjiW/SpU96Iryo=;
        b=YRiys61GFrZPWYVh8nYibYOpZygnHgfcRrlrtsAhQaRpgXqvYyUJRGmBeKBazFdDZQ
         l/bmSUqdHM9X09ocZRohYxkk/etMwWLz7mlkNxZ4dZRlMxYqyIKragMN3spctgqJB8/Q
         0jeQ11HEiS8m/FUKAE66UUg3c0DxlTov74pR0cMJWmW1smN2UtnSS3Fj024YHHHdBuJn
         4L5lZga8uHVvRaBIK9x2PKl6Q3v4GBiU3fgclZ26/TGRl2/jB9WZKXNAbRexn284RDLf
         XImPmJTmMopVd5uqQyBwPusmhmrrH1tWI447bnMYRmHPfuMLuqC3RGuUCe6REzbcYbkO
         kxkg==
X-Gm-Message-State: ACrzQf1P7BPWa0r6y33VMhLf7Em9nJrwX01UNVkZQR5+RRdvbUIGnK6b
        gf9O9jVsFqF0AzSP3ILzdz8=
X-Google-Smtp-Source: AMsMyM7H+F+9f3bZUmPnQj7mocZmAZM3JwbpiyfuZwoyIF1GkZ93FtMqWrR8NEJjIsl7SSWtI6u8QQ==
X-Received: by 2002:a17:907:a40e:b0:783:4d41:a159 with SMTP id sg14-20020a170907a40e00b007834d41a159mr10683296ejc.212.1664291366308;
        Tue, 27 Sep 2022 08:09:26 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v2-20020aa7d9c2000000b00457c321454asm1097001eds.37.2022.09.27.08.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:09:25 -0700 (PDT)
Date:   Tue, 27 Sep 2022 18:09:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 01/12] net/sched: taprio: allow user input of
 per-tc max SDU
Message-ID: <20220927150921.ffjdliwljccusxad@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
 <20220923163310.3192733-2-vladimir.oltean@nxp.com>
 <20220926133829.6bb62b8a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926133829.6bb62b8a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 01:38:29PM -0700, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 19:32:59 +0300 Vladimir Oltean wrote:
> > +	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
> > +		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");
> 
> NL_SET_ERR_ATTR_MISS() ?
> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
> > +	if (tc >= TC_QOPT_MAX_QUEUE) {
> > +		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");
> 
> NLA_POLICY_MAX()
> 
> Are you not using those on purpose? :(

I don't exactly see it as being super user friendly to leave it to the
policy validator (or to use NL_SET_ERR_ATTR_MISS()) because all that
will be reported back to user space will be the offset to the original
attribute in the nlmsghdr, which is pretty hard to retrieve and
re-interpret (at least in the iproute2 tc source code, I can't seem to
find a way to stringify it or something like that). For the NLA_POLICY_MAX(),
all I'll get now is an uninformative "Error: integer out of range."
What integer?  What range?

I don't understand what is the gain of removing extack message strings
and just pointing to the netlink attribute via NLMSGERR_ATTR_OFFS? Could
I at least use the NL_SET_ERR_ATTR_MISS() helper *and* set a custom message?
That's for the missing nlattr. Regarding the range checking in the
policy, I'd like a custom message there as well, but the NLA_POLICY_MAX()
doesn't provide one. However, I see that struct nla_policy has a const
char *reject_message for NLA_REJECT types. Would it be an abuse to move
this outside of the union and allow U32 policies and such to also
provide it?
