Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89964BF049
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiBVDv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:51:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiBVDv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:51:58 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D4024F19
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:51:33 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4so17101824pjh.2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TYvTg01gtYSFDvfjTpacPqr6C4GcHWxyLJi85eRpLqA=;
        b=nsi3XHmD9vjhDzbTpzWx1Akyt6kmX0c6fWLde/DabmFKbTTUB7jxohCCForqxoiu3Y
         Oh5G9/8KtIHhcwhaKeAXEucyJCy0YntCw9G/ucu2UWI+ZGw+R2U4lxwUFzVDuDCt8DC1
         z/aU7McMJu//s8EbVJ9V9Y5LUyIV5zCrIzFe7wLny5MYfMNz6NWohjIYx2mV3LowaYAf
         d2ZmAd8w25g5Lij3aQKiQLlZIP3nDfPl3HqolgiVYUIsEg7DKImQLxW66huytUIPFqf7
         czi7BqYJe5KSKstj/mhIg+ZM2Rgdmv4aSeEbWSldXP3tjQaUyr2onjFiVr5eRg1YVacd
         yrFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TYvTg01gtYSFDvfjTpacPqr6C4GcHWxyLJi85eRpLqA=;
        b=XY93jtjRrVKHsN43yNnaL3QKTKDd76FHT8jIDIb9O7asEtM9av/xb0OA5tGFb+30Pn
         kwpMJU6mvVSmKiPeQ9f+kyoYiAinweVBZuoZmW5Yel+nsSnOv1LZ58klNloquiGAUSr3
         f8C7vLQepH//00N/WBglYkdT02ts07A239FikhHppH8kRLy9NfyVsVOwX1Z3qcsDNErw
         4DkyBi5B6nli0K1h13ltmd3oJdrBJ6bM8d9WzSMfIU35Z0oDHHJCKXVMSNxupmkjetLu
         4bhhovBE5GjYlr74U5qNmWApkTY8Yr9H3oPU2qF9kHRLkUI8hEgTjCg9e5R6QhpJPpYp
         DUIw==
X-Gm-Message-State: AOAM531QqIqITKoq5gTVt0KmKPnTfCADbh5OYPgWY6qHK96Zd5wsuqQM
        vxIuynOTS/TaMN5ou2lG++0=
X-Google-Smtp-Source: ABdhPJzUCxR2xupUD1iIegvqU0xmiUDbly3LmdsdzcCDsT0v4FKSrLQVRLxgp5YYbn2b3DbrACShkg==
X-Received: by 2002:a17:902:b091:b0:14b:4b27:48d1 with SMTP id p17-20020a170902b09100b0014b4b2748d1mr22087539plr.52.1645501893424;
        Mon, 21 Feb 2022 19:51:33 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r12sm19573031pgn.6.2022.02.21.19.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:51:32 -0800 (PST)
Message-ID: <0dc398f1-0719-b60d-2b8e-5227f35c712d@gmail.com>
Date:   Mon, 21 Feb 2022 19:51:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 09/11] net: dsa: call SWITCHDEV_FDB_OFFLOADED
 for the orig_dev
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
 <20220221212337.2034956-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2022 1:23 PM, Vladimir Oltean wrote:
> When switchdev_handle_fdb_event_to_device() replicates a FDB event
> emitted for the bridge or for a LAG port and DSA offloads that, we
> should notify back to switchdev that the FDB entry on the original
> device is what was offloaded, not on the DSA slave devices that the
> event is replicated on.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
