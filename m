Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004225B59B4
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiILLzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiILLzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:55:42 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C320F2B1BE
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1662983736; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mESeykJpVn1M0FMWDrXbnPTNyJmjCOsEv2moN8MsIR6k96I9hB1LAo3/TLSF0JqZMKjR+gnZvZm3HcDT5Psc8HqDGZRoeHfuWHrF25DNJmd2pBgIYNSFBmZFNSPTZ5ULp6vbKi91qVV725yqIXaIBGD/hmBbQBNktT9/gE3AeIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1662983736; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Bw3lQ4u+KOX+MzXxrcM9tHH6sCTkJvR3lBzL9Mp+/K4=; 
        b=cEBkSB/U6lq6FL8knFNkSii/D/e6BoMTbwtsYTCqVUyrf0Gk1XKlIe1/vuPABLiVRlTqvFFLVAtUI8TMBepxGLpPUqpi1YE6FSBc5aO8Yuyi2eHBdRuFqLzQCXtHDG6KJFZrED1VZ2xE00BLQiAvJJ52V9rU9f3l2QpnBkrVcJE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1662983736;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:To:To:Cc:Cc:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Bw3lQ4u+KOX+MzXxrcM9tHH6sCTkJvR3lBzL9Mp+/K4=;
        b=UzlY5qh17oSnLis13srn/B1EcJ+cQs+2D16PZdlwwn3h6bniF/Tx7P/T9eCT3YLo
        ZYO+iHOcStZXC4rsrrC3ddHWlZyd4Pequ59iPD7SFSrBCo58V1EpQkU2Jg4wl2DpAAT
        FIZVs/P1JtWzOS3pQNUScP/FSyYhTtFve/UNivpY=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1662983736033177.97181205686218; Mon, 12 Sep 2022 04:55:36 -0700 (PDT)
Message-ID: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
Date:   Mon, 12 Sep 2022 14:55:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet for MT7621 SoCs no longer works after changes introduced to 
mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Packets 
are sent out from the interface fine but won't be received on the interface.

Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1001 PHY 
connected to gmac1 of the SoC.

Last working kernel is 5.19. The issue is present on 6.0-rc5.

Arınç
