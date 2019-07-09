Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4010263711
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfGINhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:37:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36353 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGINhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:37:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so21113234wrs.3
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 06:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GpIh13u/cFzuWBQ8S8qolq1RE/EQMXPMGuUalJBBVIk=;
        b=M40+oWDy/ZSU6dpfiIv668od3PlBfx9/VeKWAizpcGWWIUAqXQHxiwUm+Dl8Egsmvm
         OCf3HiwjngS3ZnJje1WdIX6EwJsslPBZoQoCe5qrN2TPaImnfa+tlqVcVubFb8svKnya
         GM78UYZ4TEMqC33EUatcA2AUPA6l+2LUJSRc7/xgRsudPkWLzpAlARi7NNVPthy2evXt
         KfxMSpnZiPHXSBxgA81fxvnrfo6ZK96e+pWqZ7utR2wDY6UtDT03G1oD1OLP0D1yHeEH
         BCURYcE9U8MgIrbOPprJipwb7aDR7DY4xGvsQBiXb8dzfc7bC9S+R+Y36ujFiDqeYILw
         PWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GpIh13u/cFzuWBQ8S8qolq1RE/EQMXPMGuUalJBBVIk=;
        b=ACFk3OaEOeCRK4n4D+vMYHU4XklpPpZ969a6BeVMo+F0pZI7CWyD9Ffl1dMy/9BAFQ
         KHOi6vM3RTij65vCJ7SNSY9qveOFWS2FsTFTBQmhgDhjOtXk4Gw8h+oA4VAFDg8qws22
         cfeulgtYLWp8C8L7qM5igv3okIaW+yViMxwBMQyuF3tJ+nzvgbcnfz7K3TbAmp2/8RV2
         EOhsj92YvrffBZqbXlrso6IjWJ/po6MJKGE4DHPuGsiA6gqpVTjKM/HTLcYJfn/ILG2P
         w5s9ozW2zLcinqwLoXuHCZiooCKwRk2dLrwb1XWPOXTfbf9CT/OBweQM+0gRXhiYYsbD
         MM6A==
X-Gm-Message-State: APjAAAVw/LTu3O7agJXp7kTGtLA7O0i7QiDvFaeaOKzvLEAld/DSr8pi
        bQg+FNJ2k8ItMlu3bNDTooEPKcl90p0=
X-Google-Smtp-Source: APXvYqxTySso+z/NW2/OxAmSEdY1JlJNHwMO3hXfa8C0tcUdFvv1s3SMvjEX1ReazY0si2g8tJGOuQ==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr25323357wrn.285.1562679464697;
        Tue, 09 Jul 2019 06:37:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l2sm1987937wmj.4.2019.07.09.06.37.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 06:37:44 -0700 (PDT)
Date:   Tue, 9 Jul 2019 15:37:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 04/11] net: flow_offload: add
 flow_block_cb_alloc() and flow_block_cb_free()
Message-ID: <20190709133743.GB2301@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-5-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:06PM CEST, pablo@netfilter.org wrote:

[...]


>+struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,

You don't use net any longer.


>+					  void *cb_ident, void *cb_priv,
>+					  void (*release)(void *cb_priv))

[...]
