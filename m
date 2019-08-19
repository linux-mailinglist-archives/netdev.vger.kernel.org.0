Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2B79513C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfHSXCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:02:00 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:39642 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbfHSXB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:01:59 -0400
Received: by mail-lf1-f52.google.com with SMTP id x3so2609506lfn.6
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 16:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nIkHbBY97v3NTTTIs8zxzFyZ2XkqOFJ7Qh+S3CO7Epk=;
        b=ATGoK0Jz51cxqVyYtY7WfldselN69Np6jo6C2++CJbhY28YHToInrrJW/xF4VHxlb/
         hEOS0OwvMz4T1T7i4edOtvp4ROsaJ/+aboKUp4iom6UGihE3hYJ7HCzkuIFfFtNWgANb
         sA2BxytM+zCqbtvEGr0M1yDF1Fs6yjWUOD468=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIkHbBY97v3NTTTIs8zxzFyZ2XkqOFJ7Qh+S3CO7Epk=;
        b=k88nJBrOtLTe71oBrtcmb0Y8dU6Rcih20x4TLdRNGFk3IC7g2qcVhYbGTbvjZlD00F
         3GKAfRyJ6rf+0YF9e3UI0BvDKPHcg2ljat1c05c+xFLNnQ4kosqB3IqWrCtQcwGtMjrT
         JRFvogLUe8f1XPE8j8ctsTtDguF3MqaRznXUrLvGYJbu90qGHn7eE9yPJSSn3QcPCTGH
         bX+ZcWPC0iOCowG5B06LJt97qyMN8/a4V47zNbDvKHBHNlpZlAZslXAK2ApR9Nz6t/lr
         aXDwhDtJQ2g7XB1oTjVdzIGjwgUQfopLpMd9ZTEk9Y+F9fmWZzuti60AEjhiY+eOjWv2
         QUGQ==
X-Gm-Message-State: APjAAAW7qveuNnHcfrvq/nL5qFspxBVyR5jkudfY39pbMBcJp7qyWpyj
        OIL/nk9hc2a7c+OXlirLjofh2A==
X-Google-Smtp-Source: APXvYqwOVkcSeMvpdESBLnib8rOXgT2fFF0DQd+z+x8myWIt8JjTs0ankSz93ihLLiEI9wxkm2OPnA==
X-Received: by 2002:a19:428c:: with SMTP id p134mr12307031lfa.166.1566255716885;
        Mon, 19 Aug 2019 16:01:56 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id w8sm2540360lfq.53.2019.08.19.16.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 16:01:56 -0700 (PDT)
Subject: Re: What to do when a bridge port gets its pvid deleted?
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
 <20190628123009.GA10385@splinter>
 <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
 <bb99eabb-1410-e7c2-4226-ee6c5fef6880@gmail.com>
 <4756358f-6717-0fbc-3fe8-9f6359583367@gmail.com>
 <20190819201502.GA25207@splinter>
 <CA+h21hrt9SXPDZq8i1=dZsa4iPHzKwzHnTGUM+ysXascUoKOpQ@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <031521d2-2fb5-dd0f-2cb0-a75daa76022d@cumulusnetworks.com>
Date:   Tue, 20 Aug 2019 02:01:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrt9SXPDZq8i1=dZsa4iPHzKwzHnTGUM+ysXascUoKOpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 12:10 AM, Vladimir Oltean wrote:
[snip]
> It's good to know that it's there (like you said, it explains some
> things) but I can't exactly say that removing it helps in any way.
> In fact, removing it only overwrites the dsa_8021q VLANs with 1 during
> bridge_join, while not actually doing anything upon a vlan_filtering
> toggle.
> So the sja1105 driver is in a way shielded by DSA from the bridge, for
> the better.
> It still appears to be true that the bridge doesn't think it's
> necessary to notify through SWITCHDEV_OBJ_ID_PORT_VLAN again. So my
> best bet is to restore the pvid on my own.
> However I've already stumbled upon an apparent bug while trying to do
> that. Does this look off? If it doesn't, I'll submit it as a patch:
> 
> commit 788f03991aa576fc0b4b26ca330af0f412c55582
> Author: Vladimir Oltean <olteanv@gmail.com>
> Date:   Mon Aug 19 22:57:00 2019 +0300
> 
>     net: bridge: Keep the BRIDGE_VLAN_INFO_PVID flag in net_bridge_vlan
> 
>     Currently this simplified code snippet fails:
> 
>             br_vlan_get_pvid(netdev, &pvid);
>             br_vlan_get_info(netdev, pvid, &vinfo);
>             ASSERT(!(vinfo.flags & BRIDGE_VLAN_INFO_PVID));
> 
>     It is intuitive that the pvid of a netdevice should have the
>     BRIDGE_VLAN_INFO_PVID flag set.
> 
>     However I can't seem to pinpoint a commit where this behavior was
>     introduced. It seems like it's been like that since forever.
> 
>     Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 021cc9f66804..f49b2758bcab 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -68,10 +68,13 @@ static bool __vlan_add_flags(struct
> net_bridge_vlan *v, u16 flags)
>      else
>          vg = nbp_vlan_group(v->port);
> 
> -    if (flags & BRIDGE_VLAN_INFO_PVID)
> +    if (flags & BRIDGE_VLAN_INFO_PVID) {
>          ret = __vlan_add_pvid(vg, v->vid);
> -    else
> +        v->flags |= BRIDGE_VLAN_INFO_PVID;
> +    } else {
>          ret = __vlan_delete_pvid(vg, v->vid);
> +        v->flags &= ~BRIDGE_VLAN_INFO_PVID;
> +    }
> 
>      if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
>          v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
> 

Hi Vladimir,
I know it looks logical to have it, but there are a few reasons why we don't
do it, most importantly because we need to have only one visible pvid at any single
time, even if it's stale - it must be just one. Right now that rule will not
be violated  by your change, but people will try using this flag and could see
two pvids simultaneously. You can see that the pvid code is even using memory
barriers to propagate the new value faster and everywhere the pvid is read only once.
That is the reason the flag is set dynamically when dumping entries, too.
A second (weaker) argument against would be given the above we don't want
another way to do the same thing, specifically if it can provide us with
two pvids (e.g. if walking the vlan list) or if it can provide us with a pvid
different from the one set in the vg.
If you do need that flag, you can change br_vlan_get_info() to set the flag like
the other places do - if the vid matches the current vg pvid, or you could change
the whole pvid handling code to this new scheme as long as it can guarantee a single
pvid when walking the vlan list and fast pvid retrieval in the fast-path.

Cheers,
 Nik
 
