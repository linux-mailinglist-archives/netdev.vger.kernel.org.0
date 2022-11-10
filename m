Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04497624A1D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 20:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiKJTDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 14:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiKJTDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 14:03:45 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DFAC12
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=16Tw1zPwIJX0LOjxziI4qGFph7FkOhTOdwaCIO6qXhc=; b=Ci8sKtKRR96YW4AlfISS6ZISVP
        7J6V8MjZeQ+lW/W0SVO60006w0t1ouR6FhmFEao20UfaCgnkum0PnVBMtutqjzZG1MUc+1+U7Af6P
        tvP6etw/8vaJ+3nut6l3P0gdza7vXTnbPRQiRK0H57q5fuTkY2LuEr+0+oGRwfxICSrM=;
Received: from p200300daa72ee10c199752172ce6dd7a.dip0.t-ipconnect.de ([2003:da:a72e:e10c:1997:5217:2ce6:dd7a] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1otCpw-0010K3-CZ; Thu, 10 Nov 2022 20:03:40 +0100
Message-ID: <472709c2-a58e-0af0-59f6-7ff504e38d44@nbd.name>
Date:   Thu, 10 Nov 2022 20:03:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 00/12] Multiqueue + DSA untag support + fixes
 for mtk_eth_soc
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20221109163426.76164-1-nbd@nbd.name>
 <Y21H22Geh0a0pcta@shell.armlinux.org.uk>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <Y21H22Geh0a0pcta@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 10.11.22 19:50, Russell King (Oracle) wrote:
> Hi Felix,
> 
> Not directly related to your patch series, but as you seem to be
> tinkering with the driver, it seems appropriate to ask. Are you
> using hardware that uses RGMII? If not, do you know anyone who is?
> 
> It would be good to fix mtk_mac_config(), specifically the use
> of state->speed therein - see the FIXME that I placed in that
> function. Honestly, I think this code is broken, since if the
> RGMII interface speed changes, the outer if() won't allow this
> code path to be re-executed (since mac->interface will be the
> same as state->interface for speed changes.)
The only device I'm aware of which uses RGMII has the RGMII port 
connected to a switch with no proper upstream driver support - no speed 
changes expected there.

- Felix
