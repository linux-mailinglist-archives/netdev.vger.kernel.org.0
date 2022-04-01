Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30A64EE7BF
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 07:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiDAFXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 01:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbiDAFXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 01:23:46 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AB061A2B
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 22:21:57 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id q5so2422361ljb.11
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 22:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jHLyrqL3sLJgHUMl5qIal+JJ179vMst7kl7shW3js1g=;
        b=LWEPO+BkV3vF+tzuiDgPMCCZAOMxtIOUjmWGfOuPTAY4P1ZV/VeWtZsaXKJQXh3M/a
         feGn3XmZy+vw7Zl1r/ANzuSSbRbTTCiYnyHoR5w7apUIqju/suHqKvfMqOiuNgRG/I9w
         eJfy+I6HO9K7pyTyMZrnRK5oMtoGJufGK3hkr+Nm0mRcr5t/zqmfgcDGnWhUrLfoJaPZ
         EW30fJEbkR+PVUIlKPPMlbDIwPeedWmnIu/JuPe5eZXTRHLoBrOgswHme2TKZFAAUqOf
         ipAptzCJd3hHp2IGnh6XljaSjUKrx6JBEOcn0p2I8vptdkVz+5yZVAxqFB+REyraLQre
         G9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jHLyrqL3sLJgHUMl5qIal+JJ179vMst7kl7shW3js1g=;
        b=kBsn47SWgj99oZiObCXS7XkayLE6Z40NUNd5es+4hYDN3y5772a0OYd13bDr3X2R3I
         9ZoIBHF68DimCrZqb0gvILYn93VNyzhAs6+7vt6RVhIu+upr9SeNGEr3krRetOOY4obu
         XjoEI0sUrGyz9pKNP+Q4dlIl0DZctemkUywQ/xkexddkiROoaQN4wKyEoIgV5xyeQqxM
         qrKwDsbP7mB2NrqIOG01gxcAg9JbU8JeSVAjsiBHOPpATMNhbGa1tSEJyi5TI20WApkH
         sxr6wAEkBeAMhTRs4qm6iS5MXQC/jpRDZ92r3ewG4QRChKinKyEE9A7vCYEZ/SNR/NVV
         na1A==
X-Gm-Message-State: AOAM532vgto7WIsrSTazpAWKQh2398Xf+uYLX2SMmIiWOLn3+XcvShh7
        a+xKCWt/ivSpdPJLcHQGGLE=
X-Google-Smtp-Source: ABdhPJzbZelajVlS0iCJymneum7k+HoUnJPGk1jymEhFUvEVdxXz+vcj5JuDV8gN9gYeF89sT30paA==
X-Received: by 2002:a2e:84ce:0:b0:24b:23e:9928 with SMTP id q14-20020a2e84ce000000b0024b023e9928mr1079476ljh.475.1648790514145;
        Thu, 31 Mar 2022 22:21:54 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id h23-20020a056512339700b0044a15d1c6adsm131853lfg.26.2022.03.31.22.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 22:21:53 -0700 (PDT)
Message-ID: <10775971-c700-4b7b-77f5-6d6cd221de67@gmail.com>
Date:   Fri, 1 Apr 2022 07:21:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
 <20220330120919.ibmwui3jwfexjes4@skbuf>
 <744ca0a6-95a3-cc81-5b09-ff417ffde401@gmail.com>
 <20220331134257.zi32tftbz3yo2lg3@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220331134257.zi32tftbz3yo2lg3@skbuf>
Content-Type: text/plain; charset=UTF-8
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

On 2022-03-31 15:42, Vladimir Oltean wrote:
> On Thu, Mar 31, 2022 at 10:06:20AM +0200, Mattias Forsblad wrote:
>> Hi Vladimir,
>> thanks for your comments. The patch series takes in account that a foreign
>> interface is bridged and doesn't offload the rule in this case (dsa_slave_check_offload).
> 
> I certainly appreciate the intention, but it could be that a foreign
> interface will join the bridge after the matchall action drop is
> installed on the bridge. So actively monitoring bridge joins/leaves
> would be required to offload/unoffload the rule.
> 

Ah, you're right. I'll fix that. Thanks.



