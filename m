Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241E4D95A0
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404944AbfJPPbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:31:53 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:46185 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfJPPbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 11:31:53 -0400
Received: by mail-pf1-f182.google.com with SMTP id q5so14924719pfg.13
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 08:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Zue4LWZkN0lbJorMKtJ6hn2RTsJQnvotQW3R9wHdgnI=;
        b=jEOo2stE9JkAwPgqMqZFXVFK9N7EOS6/woQbv0NbKLdh/Sj9VdQ8bjCs063cvIcDea
         P9r8TqQ9UZpjaOVDlQPJlpyDkbrySzlmDXaC0XBl/wMkcfVPLzNEIBUAfsgif4nGqydB
         0ZrS/pxxcO9gY4Drt4j22F/f0jpXm0GoSlFDyIOHJ/lDXh3ZqzmjdfpRJY9ASa05RPGf
         naIvBGu6anqCrGRTUiLw4HGzSmschF7zigSFhjam+Szmgw97CFRbty2FZBzLTPYu0g1h
         dC34XkvvZOpPY+ivErOykmPiZ51mCgiCdCUMIbnlgp3wGZcMh6iyOeNtBfxvMa9S06cm
         Eh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zue4LWZkN0lbJorMKtJ6hn2RTsJQnvotQW3R9wHdgnI=;
        b=i+eHxy3IJnvfo1obbxh4gCWMTV/DHl/4I7Xmn1GAElMVLE+WT27VVttgdJVdPbZf9w
         wJBkY4GmWa4RaCbXB1r8i7+soP7MlnQ3sbqcya3CBFgYfOARJlUzpQGJfpE5CwQVip2E
         gf2ZcKkQMOTNWa5o12vd3MT4PghY2uFvT0/UTj9aqIrLusfOk2HL66yB3HnKZi6rfzQQ
         CpT0Uf/1ERVuKOyuix32Gz1C63YfI/8cbvGs+D3iYy0phy9w+pEFdi/307PEdpjr0KEh
         1Fq17SuToEBwsT9plvw4KicrIkdyPHiSz5/mnCh8uwdbaRec6m0MA52i/jPNe7PS2Lan
         7zhw==
X-Gm-Message-State: APjAAAXL1USmOq5y8qfDUVgUCbKPkbiSdqOJkKqilI9r9hWUvwezvCy5
        NDHdehMycctxRsWHtzzzK8Zckumm
X-Google-Smtp-Source: APXvYqxL+ckoszTYtZXlYLvMtYuICl2jE7npyt9f/dBWrTiXHJpREt0cL87VMUS8nW0/d9dePCYPGw==
X-Received: by 2002:a63:1564:: with SMTP id 36mr45671581pgv.149.1571239912052;
        Wed, 16 Oct 2019 08:31:52 -0700 (PDT)
Received: from [192.168.84.99] (94.sub-166-161-180.myvzw.com. [166.161.180.94])
        by smtp.gmail.com with ESMTPSA id t68sm23845083pgt.61.2019.10.16.08.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 08:31:50 -0700 (PDT)
Subject: Re: big ICMP requests get disrupted on IPSec tunnel activation
To:     "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>,
        'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
References: <EB8510AA7A943D43916A72C9B8F4181F62A096BF@cvk038.intra.cvk.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <24354e08-fa07-9383-e8ba-7350b40d3171@gmail.com>
Date:   Wed, 16 Oct 2019 08:31:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <EB8510AA7A943D43916A72C9B8F4181F62A096BF@cvk038.intra.cvk.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/19 5:57 AM, Bartschies, Thomas wrote:
> Hello,
> 
> did another test. This time I've changed the order. First triggered the IPSec policy and then tried to ping in parallel with a big packet size.
> Could also reproduce the issue, but the trace was completely different. May be this time I've got the trace for the problematic connection?
> 

This one was probably a false positive.

The other one, I finally understood what was going on.

You told us you removed netfilter, but it seems you still have the ip defrag modules there.

(For a pure fowarding node, no reassembly-defrag should be needed)

When ip_forward() is used, it correctly clears skb->tstamp

But later, ip_do_fragment() might re-use the skbs found attached to the master skb
and we do not init properly their skb->tstamp 

The master skb->tstamp should be copied to the children.

I will send a patch asap.

Thanks.

