Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD65610865
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiJ1CrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiJ1CrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:47:12 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F021CBC78E
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:47:09 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id w29so2757088qtv.9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M3A+RcCRbHpJkXfUICP+fFblHs6KoPnsrejID4WQ0po=;
        b=Tm7H0CEdo2x/UcgL8Wa/h/uxGLuJd/oQ9yZYASlBcJEXKX5GdZ7CdXCXiU8L7rCvrL
         BEUXp4WD+6GwwAus1VLRkjUYtilSs8KcEIL8r+LkaoyQzwdoPmeBCzldlsc+i3fLbx7b
         D75rXeZLhZuc0+ATp+biQO9E0wp5sopCJexwb4+KtmfY9kKWoiZqorizd0thfyx2rN8C
         96BFEyhmUoW5XlWyNiJPoeeCR2qRWTRC9Ty4GIfge8idI13j1iKKEWsA/oX7htyqwMJE
         v4hKxF2xKa7bpbf26iYkgaODA81SjNRPLwlC+jQTZ7c1WNb09zKJbezHZQ2ZH3qqL5SN
         WG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3A+RcCRbHpJkXfUICP+fFblHs6KoPnsrejID4WQ0po=;
        b=OQv0II9ACIGTywAxdIkb7jR9Jdkl+UoqsbWJ+X7xfRJJoe5M+pf6sUOiKWNUrrduvF
         ZumBBstyirWMXIRfZhXg/rIOSHqXx4RmvEUCs7Z0FoavX93CNeCoQx/3HohxlP4ouPMV
         dd0zKTPkPHHSZULo8ukBM+aZs2jMVv8Tad6xTmF5FwTmgylXs/LoH8XKQmUBkjTVDD1A
         Ntpdkecky4ZtYrnIANTBJJ/H6BVS7az9eT+xSAU/EbiML3IDHKtdpyG97O2wgpUA86zw
         3u+ewx+mg4CW5Ak+bbXsvS/S+TAEmD6qm9g+YbnP+tb7bZZUteH7NtZYyGlg1O+J0VDD
         ewCw==
X-Gm-Message-State: ACrzQf3MGad17Iir2JhVQrOCJSl6sbekiOFkjIfNbem07bihkDs4u9Yz
        wABuRuggXfALTMCjS7QAaPY=
X-Google-Smtp-Source: AMsMyM5M6sp8XPhPPowB5OT3Bkb4qPTgXgWYUL181nf6roh5A6RF3X3FXZ0jzv5hcFKtYyrNvg07NA==
X-Received: by 2002:a05:622a:10a:b0:39c:c4fd:4c6e with SMTP id u10-20020a05622a010a00b0039cc4fd4c6emr42623092qtw.441.1666925229026;
        Thu, 27 Oct 2022 19:47:09 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y13-20020a05620a25cd00b006e6a7c2a269sm2158238qko.22.2022.10.27.19.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 19:47:08 -0700 (PDT)
Message-ID: <9a5a168f-f6e3-d907-68da-ba2836211871@gmail.com>
Date:   Thu, 27 Oct 2022 19:47:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] net: dsa: fall back to default tagger if we can't
 load the one from DT
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/2022 7:54 AM, Vladimir Oltean wrote:
> DSA tagging protocol drivers can be changed at runtime through sysfs and
> at probe time through the device tree (support for the latter was added
> later).
> 
> When changing through sysfs, it is assumed that the module for the new
> tagging protocol was already loaded into the kernel (in fact this is
> only a concern for Ocelot/Felix switches, where we have tag_ocelot.ko
> and tag_ocelot_8021q.ko; for every other switch, the default and
> alternative protocols are compiled within the same .ko, so there is
> nothing for the user to load).
> 
> The kernel cannot currently call request_module(), because it has no way
> of constructing the modalias name of the tagging protocol driver
> ("dsa_tag-%d", where the number is one of DSA_TAG_PROTO_*_VALUE).
> The device tree only contains the string name of the tagging protocol
> ("ocelot-8021q"), and the only mapping between the string and the
> DSA_TAG_PROTO_OCELOT_8021Q_VALUE is present in tag_ocelot_8021q.ko.
> So this is a chicken-and-egg situation and dsa_core.ko has nothing based
> on which it can automatically request the insertion of the module.
> 
> As a consequence, if CONFIG_NET_DSA_TAG_OCELOT_8021Q is built as module,
> the switch will forever defer probing.
> 
> The long-term solution is to make DSA call request_module() somehow,
> but that probably needs some refactoring.
> 
> What we can do to keep operating with existing device tree blobs is to
> cancel the attempt to change the tagging protocol with the one specified
> there, and to remain operating with the default one. Depending on the
> situation, the default protocol might still allow some functionality
> (in the case of ocelot, it does), and it's better to have that than to
> fail to probe.
> 
> Fixes: deff710703d8 ("net: dsa: Allow default tag protocol to be overridden from DT")
> Link: https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
> Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
