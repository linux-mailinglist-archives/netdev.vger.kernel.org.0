Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D52C5EB39C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiIZVu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiIZVu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:50:56 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47247AF4B3;
        Mon, 26 Sep 2022 14:50:55 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id 13so16947200ejn.3;
        Mon, 26 Sep 2022 14:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=G+v4KheO70hIczRUfrwqD8naVXQT69IaDlKdrI5tlvw=;
        b=mS3/vXIJp+h9xLtaUSxXTmEB+/ZD0ZqMdsoXv7uG1lJMf7CWXMVYay3/VgPlqx7crQ
         S1X39sP36ylfF6BkYeBUa+QRsYov+go+T+c8BGn07jvCvOLDzorH64JC50qgWuMVA8E7
         fzT5szySm85CoQYJ95LzNsvuB0720+K//s2ffwS4jo0/yFYL/5EpV4LYKr2u9Zmn08SE
         Tm74n9hfyiRaNyE7OqJGrrSQsV0ouv8a5YNYIyF7JYkElTO12b8LzmZhSntxN/K9dL35
         vdjY/liMylGmEFAXRbMcFn5fev752DuLPz6h73EGBN/2K0cJDTwXkuAkmKsYTyGnmfp6
         ZtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=G+v4KheO70hIczRUfrwqD8naVXQT69IaDlKdrI5tlvw=;
        b=0/IkQdGI0UADQQXg3WJ0/EfnnZzxnvmQjymHGDOiBVhSGt6FCih94Cy3O0lMy7KzNS
         XDWnNxy5+51fjFE1pQkJBq3/+zNEJKXaNeQujw34aDA2vqP31W4Yl6UDsKYwRwCxgfGr
         v0LWr2H7dT4WVoNAZKRMwb+XzYi11VX90KZbW1zkwf1TR/q9Is2CFrfXVajsQGbQFSOS
         J02oNOkoCwmtdaPw410Z16l0164K6xO9tJb5EvIz4bJNaK5glzvEWNYs0Tc994vESby0
         J30DQ3ZV5GlMfJDqbIJ3NolTpuUs/lucw27DalU5kaiq1VIA4li74h3xO7eMFWGvvYdT
         ZGWw==
X-Gm-Message-State: ACrzQf125kUoqtX+w5hrnpU1TyxoQ6hI5EGmLBA0OMHrxbLfLENpMD+j
        4UeefHdjEDcR9sj1X3F9L7k=
X-Google-Smtp-Source: AMsMyM4AwRmWYrUReXKfyRRLMQ5K05O7bqpsYtAS0TwhNv4oGKIO45cN89zVJ2s/MSl2yDXdRErVTg==
X-Received: by 2002:a17:907:b1b:b0:772:1dcc:a512 with SMTP id h27-20020a1709070b1b00b007721dcca512mr19736400ejl.247.1664229053367;
        Mon, 26 Sep 2022 14:50:53 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b00782e3cf7277sm4571011ejf.120.2022.09.26.14.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:50:52 -0700 (PDT)
Date:   Tue, 27 Sep 2022 00:50:49 +0300
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
Subject: Re: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to
 per-tc max SDU
Message-ID: <20220926215049.ndvn4ocfvkskzel4@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
 <20220923163310.3192733-3-vladimir.oltean@nxp.com>
 <20220926134025.5c438a76@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926134025.5c438a76@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 01:40:25PM -0700, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 19:33:00 +0300 Vladimir Oltean wrote:
> > Since the driver does not act upon the max_sdu argument, deny any other
> > values except the default all-zeroes, which means that all traffic
> > classes should use the same MTU as the port itself.
> 
> Don't all the driver patches make you wanna turn this into an opt-in?

Presumably you're thinking of a way through which the caller of
ndo_setup_tc(TC_SETUP_QDISC_TAPRIO, struct tc_taprio_qopt_offload *)
knows whether the driver took the new max_sdu field into consideration,
and not just accepted it blindly?

I'm not exactly up to date with all the techniques which can achieve
that without changes in drivers, and I haven't noticed other qdisc
offloads doing it either... but this would be a great trick to learn for
sure. Do you have any idea?

> What are the chances we'll catch all drivers missing the validation 
> in review?

Not that slim I think, they are all identifiable if you search for
TC_SETUP_QDISC_TAPRIO.
