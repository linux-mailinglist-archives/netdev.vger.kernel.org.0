Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736EB6B0967
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjCHNhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjCHNhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:37:10 -0500
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAB6B690F
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 05:35:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678282460; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=jEgIGIj/R9+TCbQjpVB+yRelWtUfRmVhc4sVl9k4fMfV3Rw5CY6KSxE4Hno/phvwkINYlExmaa5lbqXE3F21cImwPkF3dhdZvYUt2sRqHhwOcZnEvLBg5XMQ9RkF32XzbSwhN/a5BXsIcStozJhVYjldb7W53omsFXXANpXdu8k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678282460; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qJ42TYXNstwFFfe6ILMTlfwXNOmGVKYsc07XVk19C3Q=; 
        b=mz7PSeRcc0j8mcTgdFqP7VRWtS4Byv3IWYPiAQaCSd1MtM1VKWo8yrABcyQNHdQkMTvFzAVJ6U1hIMQn/bb4I+ZEmwObj8r99j2+rImHj35zPdk90aomze95f2Hx9YlkKbgQ75smRI2UEcBhtkqOfB5/OxlJDx3dv7XjiCOdYeQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678282460;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=qJ42TYXNstwFFfe6ILMTlfwXNOmGVKYsc07XVk19C3Q=;
        b=P7+afE+EgFgNc4vdOd8BcOu1m9RjdUx20r9HAXqNC7AiSmzxKHHMXiWnri0DsA0A
        xf9lPd/uO15RAY5/fnr20+WrSMYv+dX31NSfiQ6zB5GE2tcq6MXjquKVolTdlxKzRc5
        lh2GK+P3HrqxEbXRUf8138q4kFqhXz40C1dtmvus=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678282457259930.2971623266512; Wed, 8 Mar 2023 05:34:17 -0800 (PST)
Message-ID: <6da6d5bf-be12-ec7a-58ac-a1a1cef23fd0@arinc9.com>
Date:   Wed, 8 Mar 2023 16:34:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] Fix Flooding: Disable by default on User ports and Enable
 on CPU ports
To:     Richard van Schagen <richard@routerhints.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230212214027.672501-1-richard@routerhints.com>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230212214027.672501-1-richard@routerhints.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard, will you send a new patch series for this and your other two 
patches? They are essential for the port5 <-> gmac1 link to work 
properly. Without them, port5 as a CPU port won't work properly.

Arınç
