Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A023A599C
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 18:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhFMQd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 12:33:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33660 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMQd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 12:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Rfpd3/bKKCNWwkSNXhRu75K3KXs2S+zGTIfGuFswvLs=; b=Mj
        gvFaDw3lND4PyN5ThRZiMAoB5uVhB8oTRYdmQeDsMwhF3KyM2kqkeBIwVSAxR3XUA01KZ9BLPz2fn
        dLKNsN7NN2rWKswvyPjZuuoisztG4KxMa/3s/sqhpF2C+Utc0c7z0ED94Cud5rML6G7k9WNdgxPBZ
        1SfGlSYoF/AC9/E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsT1M-009B5K-CB; Sun, 13 Jun 2021 18:31:36 +0200
Date:   Sun, 13 Jun 2021 18:31:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YMYy6JMSHm1Cqdt2@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YMGEutCet7fP1NZ9@lunn.ch>
 <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
 <YMICTvjyEAgPMH9u@lunn.ch>
 <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
 <12f35415-532e-5514-bc97-683fb9655091@wanyeetech.com>
 <YMIoWS57Ra19E1qT@lunn.ch>
 <20210613163452.1f01d418@zhouyanjie-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210613163452.1f01d418@zhouyanjie-virtual-machine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 04:34:52PM +0800, 周琰杰 wrote:
> 于 Thu, 10 Jun 2021 16:57:29 +0200
> Andrew Lunn <andrew@lunn.ch> 写道:
> 
> > > Here is Ingenic's reply, the time length corresponding to a unit is
> > > 19.5ps (19500fs).  
> > 
> > Sometimes, there is a negative offset in the delays. So a delay value
> > of 0 written to the register actually means -200ps or something.
> 
> Ah, perhaps this explains why we still need to add fine-tuning
> parameter in rgmii-id and rgmii-txid modes to ensure that the network
> works properly.

Please try to find this out. rgmii means no delay. If the hardware is
doing -500pS by default, you need to take this into account, and add
the 500pS back on.

    Andrew
