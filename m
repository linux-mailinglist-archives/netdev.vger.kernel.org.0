Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD632767D6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIXE1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXE1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 00:27:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492E1C0613CE;
        Wed, 23 Sep 2020 21:27:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id bw23so973840pjb.2;
        Wed, 23 Sep 2020 21:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pdfEazDp+agLl7HQcta1riwD62sJSmywvu4uw6QPifc=;
        b=vDywTJgUzAM4gacg69P9qMa3Lymmb4fe5DrEizJtsUJVYlT8QQNPvbpiWHTNEH+zW6
         u59NbPUCS+cBPInRLuoziYiwxOSvu/HLf3K5P7WfbWryRPZqL5FiG6C1xs0w7pd+x9s0
         No6r1X19NoUDlRBPyLytPjsziggUnBg/x0C0ePiUwZIEyRdLuraFoSSrm7xrJsef0rZJ
         sJ8LfvkbHuBOhjTvhIaS9+V+SWFcxZ20w0yCjqUWmXVQhQGwckp6fxSK28OtT8GUYekz
         Fh3KgAu7cpIRCJLD0+wxPDXHUQgp9aW0+xOCu64Zz4GgplA6ZSr9/X2lLsvuhyG6llct
         oShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdfEazDp+agLl7HQcta1riwD62sJSmywvu4uw6QPifc=;
        b=hhqceZlYPsBNI+gcpaTbf/n/pCZDcmWMWhkWknU2lXHPNhJrAQTgGOm1Mv+iGYcHqd
         dqgEJmC7j3aHG/j+62H0MPkurEi8yVpy9SFGlYt8OnA4f8/yglpiDkOCT7JIVYA1kiFl
         n9hprtr/XF1RNhE8F+9h/Jwte/IfzSlyLLurRqldQYlNH1cwektyC7IFvR7iSQjThHdj
         rZEbWakLFpImsrmNGKPnKfjMta0PuZE129BE4u4gOdRpaQs9fXVSevsQlCMhKsHJKEB/
         EO2m8Lhj9Znd6MBDOrqC87V1YUJvvc2tSMflUY6ZinuPNHUlSQBt6C1qo9r92kvXCCra
         pfTQ==
X-Gm-Message-State: AOAM532sBHTuions2B4FQYCxzlrCNITDmgiNuxHlz3U6wIkeryqixa83
        Tk+MYVJ6lbp38ETiRfpLWXU=
X-Google-Smtp-Source: ABdhPJxmsk1ZywZgo4jXmVQxoMddIp1q0672UrCFNgKLDLo+3mJYSgRtqsaoNYI0itYRGoigIqsDeQ==
X-Received: by 2002:a17:90a:d315:: with SMTP id p21mr2382182pju.88.1600921658742;
        Wed, 23 Sep 2020 21:27:38 -0700 (PDT)
Received: from [10.230.28.160] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u14sm1121112pfm.80.2020.09.23.21.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 21:27:38 -0700 (PDT)
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <e5f1d482-1b4f-20da-a55b-a953bf52ce8c@gmail.com>
 <20200923225802.vjwwjmw7mh2ru3so@skbuf>
 <a573b81e-d4cc-98ad-31a8-beb37eade1f3@gmail.com>
 <20200923230821.s4v4xda732ah3cxy@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Message-ID: <623b6091-aa87-dc1b-e3ed-d5d22000ccba@gmail.com>
Date:   Wed, 23 Sep 2020 21:27:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200923230821.s4v4xda732ah3cxy@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/2020 4:08 PM, Vladimir Oltean wrote:
> On Wed, Sep 23, 2020 at 03:59:46PM -0700, Florian Fainelli wrote:
>> On 9/23/20 3:58 PM, Vladimir Oltean wrote:
>>> On Wed, Sep 23, 2020 at 03:54:59PM -0700, Florian Fainelli wrote:
>>>> Not having much luck with using  __vlan_find_dev_deep_rcu() for a reason
>>>> I don't understand we trip over the proto value being neither of the two
>>>> support Ethertype and hit the BUG().
>>>>
>>>> +       upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
>>>> +       if (upper_dev)
>>>> +               return skb;
>>>>
>>>> Any ideas?
>>>
>>> Damn...
>>> Yes, of course, the skb->protocol is still ETH_P_XDSA which is where
>>> eth_type_trans() on the master left it.
>>
>> proto was obtained from br_vlan_get_proto() a few lines above, and
>> br_vlan_get_proto() just returns br->vlan_proto which defaults to
>> htons(ETH_P_8021Q) from br_vlan_init().
>>
>> This is not skb->protocol that we are looking at AFAICT.
> 
> Ok, my mistake. So what is the value of proto in vlan_proto_idx when it
> fails? To me, the call path looks pretty pass-through for vlan_proto.

At the time we crash the proto value is indeed ETH_P_XDSA, but it is not 
because of the __vlan_find_dev_deep_rcu() call as I was mislead by the 
traces I was looking it (on ARMv7 the LR was pointing not where I was 
expecting it to), it is because of the following call trace:

netif_receive_skb_list_internal
   -> __netif_receive_skb_list_core
     -> __netif_receive_skb_core
       -> vlan_do_receive()

That function does use skb->vlan_proto to determine the VLAN group, at 
that point we have not set it but we did inherit skb->protocol instead 
which is ETH_P_XDSA.

The following does work though, tested with both br0 and a br0.1 upper:

+       upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
+       if (upper_dev) {
+               skb->vlan_proto = vlan_dev_vlan_proto(upper_dev);
+               return skb;
         }

I should have re-tested v2 and v3 with a bridge upper but I did not 
otherwise I would have caught that. If that sounds acceptable to you as 
well, I will submit that tomorrow.

Let me know what you think about the 802.1Q upper of a physical switch 
port in the other email.
-- 
Florian
