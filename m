Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6473E1CA0FE
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 04:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEHCio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 22:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHCio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 22:38:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2477C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 19:38:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id v63so152502pfb.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 19:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RHyqvNQF9OWAStcOOvRZftKIBAf7GSrTJ/0SFcfXQa0=;
        b=h5xGmAqbuaXAfLxd4ZrwmYTi0QCG5yZQ6kCQv6M4hgsvfeO+3GVaFelFfmVyM2fAvg
         95KSHmEeHXBrOySDw6V6jqqMkJ0wMilnC08Ag/rXJKrSMcz+S+hG7+TCEwRtZ+7XuVq8
         jMeZIeNJMN7yOj+4ZfRdXyAK/rAegoCsNeB98poEkkIr9DAHksYRcliMt3C5Lo/zMvgX
         jespTT4Ki6/nrGX1Nv+cWZuHIC+7NTxqn21ZzD77sQMMKX7bZzJ8I6TJriKSl/N5K1LI
         AqA7TfdvZIhTtIIMz7gjRemBPJTdXTykdodxILyI75ICWET7hiGJLIBvCJ9oEpDOwidH
         dwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RHyqvNQF9OWAStcOOvRZftKIBAf7GSrTJ/0SFcfXQa0=;
        b=Ye2wEN+EEPKtdsqjowCNs6dkCUsjwlZbNQpCZRG3oVawi9o4CSPBUqChPzN/vRxFnC
         7JZFzhRd/gtIDK7SStQmWxnRQHGP+eZRirsMXLto2iKguIl4xsoX5L90jBxqGetjiUQy
         RKJhJEwoiKUq06b/PEMo68GbsxVyE7uTj+bITDMovsS9QtlQZTBbiVuRI3utDM07I3Cr
         8r8H/aIIwhaw4XmveeijACSpsms1VDWdqeq8MwLipxLWgr6XZGMHrWW488Ry97ZRj/c0
         KOOm9iDrAgygfyLFTIOjyJD/fSF0j7iKVAlsmTraVGIUnEb3U2BxpJ81SOqa+xetbHet
         l2mQ==
X-Gm-Message-State: AGi0Pua58ho07OW+5lBFYLD4lN0RJw/XWiXOnZ4HvKeJSKj8sPVveDiT
        4b5rx+tn2CxiQ3rcazfrmTY=
X-Google-Smtp-Source: APiQypKHNduhAgvXjmDXs86Z9m1F4MTv61K+xnVab0UlYXlVGHFntyxUwg5GdX3qrYtaRGnuWapizg==
X-Received: by 2002:a63:778d:: with SMTP id s135mr295623pgc.238.1588905522271;
        Thu, 07 May 2020 19:38:42 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o6sm125741pfp.172.2020.05.07.19.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 19:38:41 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 1/4] net: bridge: allow enslaving some DSA
 master network devices
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
References: <20200503221228.10928-1-olteanv@gmail.com>
 <20200503221228.10928-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <22c691fc-c935-02b8-a370-96d9393b1cac@gmail.com>
Date:   Thu, 7 May 2020 19:38:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503221228.10928-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:12 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
> as bridge members") added a special check in br_if.c in order to check
> for a DSA master network device with a tagging protocol configured. This
> was done because back then, such devices, once enslaved in a bridge
> would become inoperative and would not pass DSA tagged traffic anymore
> due to br_handle_frame returning RX_HANDLER_CONSUMED.
> 
> But right now we have valid use cases which do require bridging of DSA
> masters. One such example is when the DSA master ports are DSA switch
> ports themselves (in a disjoint tree setup). This should be completely
> equivalent, functionally speaking, from having multiple DSA switches
> hanging off of the ports of a switchdev driver. So we should allow the
> enslaving of DSA tagged master network devices.
> 
> Instead of the regular br_handle_frame(), install a new function
> br_handle_frame_dummy() on these DSA masters, which returns
> RX_HANDLER_PASS in order to call into the DSA specific tagging protocol
> handlers, and lift the restriction from br_add_if.
> 
> Suggested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
