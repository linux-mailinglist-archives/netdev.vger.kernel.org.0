Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205A7648B8D
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiLJAIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLJAIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:08:41 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A0A3D3A1
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:08:41 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id z12so1995744qtv.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 16:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q0E2Dcfo4EQHjfR/zJisrUPt7Z/LXDZE19kPiILMZFs=;
        b=b7KrSCr6eZILbbRLjWG403Pb6Vci1rE0MV0RMmwMPpXo+fY34W0Pi7xlsSalMFTPAy
         khLsuZCdH5V/lsbVzexrGjq3FQJGdNQjIHFfMaeVc/6niEA4/qgEqcGBq5a4/FcocXmB
         kXCcdZuTC9B9chxNkFnZstJ3RWkPQm/lLwer54QTAxLXhqM8zF3EHEqWPeANJW2BBl5Q
         +BiQ9atGE+TpOt+azMQz1M9ftR/9qYBgP4HPrgUVLfBWVHFK/nfzgvAd6qxuhoLuIMa1
         VK2DUOCy4bvAcV81w/Zle8eVDdWr2uXhrpy6EAfLy3wPOmoxZABcnyR6Hc0hmvlFOSi7
         MdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0E2Dcfo4EQHjfR/zJisrUPt7Z/LXDZE19kPiILMZFs=;
        b=bgplbpr6LeUpp1OSW07W4C4QCECg2LEIlIbeDxp7p+w4zSNUKdEhWfWDdT3euvfD5C
         AcpH4zPMIRneBSqz2VZuoas9vpSXJclvxRfaDjQsiEP4oLb56pQXf1PBEJCp/Si0bDQD
         UAkkni4ZSuOZrVF3wlR7nXCqyd3NfRKi2/IoOinM73G1ZEUp0W85kkMFRXsSFt7fjNRM
         FAy4REvgkf3pYI8rFRA4ZTextivJniBL1DuAhtJlIXbKEvWJXPwGWyL/zNnFt363pwaJ
         ROJpwu5y5kvkC2OUL4gnuyH6lAJe6OXJuKdganCrZxnQ9jVIbVy1yWC9R5VBQqVz7YVv
         Wa+g==
X-Gm-Message-State: ANoB5pkJVNmxuMN2ylh+47wEg3XiHN/nSf//29CEKtOky16yfl/EJn9/
        mM1Xklla1mxaFYgK/aNd8PU=
X-Google-Smtp-Source: AA0mqf6BrrldkuMgAwzCLYb4lfPqPHx/zZg/bhkpYXxjKU7O9BI3KiNIHs9VFc53rD8uAn6W9KHbKQ==
X-Received: by 2002:ac8:110e:0:b0:3a5:f9cb:886f with SMTP id c14-20020ac8110e000000b003a5f9cb886fmr10725864qtj.29.1670630920089;
        Fri, 09 Dec 2022 16:08:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z20-20020ac84554000000b003a591194221sm1808984qtn.7.2022.12.09.16.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:08:39 -0800 (PST)
Message-ID: <3fd85490-0a78-2d2e-0156-22ca209420af@gmail.com>
Date:   Fri, 9 Dec 2022 16:08:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] net: dsa: don't call ptp_classify_raw() if
 switch doesn't provide RX timestamping
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
References: <20221209175840.390707-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209175840.390707-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/22 09:58, Vladimir Oltean wrote:
> ptp_classify_raw() is not exactly cheap, since it invokes a BPF program
> for every skb in the receive path. For switches which do not provide
> ds->ops->port_rxtstamp(), running ptp_classify_raw() provides precisely
> nothing, so check for the presence of the function pointer first, since
> that is much cheaper.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

