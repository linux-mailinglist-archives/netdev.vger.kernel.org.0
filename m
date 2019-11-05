Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DEF01DF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390014AbfKEPtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:49:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36909 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389506AbfKEPtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:49:35 -0500
Received: by mail-wr1-f68.google.com with SMTP id t1so16045192wrv.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 07:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Omqe6S/pyFxJI7C1o2eETHJWbUrn/qTQRRvTn+QMfyg=;
        b=RzkorrMjvOIWN4UkPK8Y7Znou9DRHdIJJdzqduj9U84TzYPrjarP5nbfB2T3swqAB5
         9Y4y4+jLERhtnMbGydLfoIP7oKOq9Lbt+z/x4iM2zB/1jh9RKh+7UAwC3b6hkptTaK2S
         0N1gWFkaqSOVwEhcdWVR2NnZua3pPeXC2ao/eiRZ/Pq28qVBUTUMoUtBEcfx9mturcua
         W57o+fVlOrvvBoaR5/BlNfZfePVlIW5lUUKkURAkP8b1muUDkgcEssXTw3OJn1YCI4v3
         BKm7gm6qrGLbL5bqO/X0FxUAnuf16r3yC+mPOMIyLxnFewmNSlIiA2LRv/rwARn2Ij9o
         Jhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Omqe6S/pyFxJI7C1o2eETHJWbUrn/qTQRRvTn+QMfyg=;
        b=byhn/UPqiKR5ArX8ZL8rgmDR1lKVRyWi7OR5wq3Z3GCCfoZJHZwuLRVmDEZYYtUyqq
         qJSDw474YoPRN555Odqr+onsmmiYvNl7BkuQbHjhRB3zHYKracDtLYxfrXq4ifXywO1K
         WfrRsGqcoLN2Np3m9DWir1pLnpS/C2pDU0kpKg++uPNDimidabpHfpR1ydD7sDnqHdHV
         Twvy/Dp28q7I7DsyyrGgSCpEuSgcmrkBeBfZjSRczXTQWOGeploCY97NRaMA9SliFspW
         ZFpDBqEuyGfo0lgWNRFRvPU6Eyh3enJY32F7U9ZoTL18zzII4YYc7ZlTFvIgY6twR7ss
         7fjg==
X-Gm-Message-State: APjAAAXC5DhqxQp0kBaY7MlN9GYBPAmAS4ExQJLOWCHYhrmZA/76hPoJ
        ip3RBoS57fFA3cCFWS1dqcIoPp7JZjA=
X-Google-Smtp-Source: APXvYqwfdUO6eajK1OfvTLlh5zvD1jlHgPwHU9A53yqddwlElP4rSVoRkaamvkSt3D41UleMCuvALA==
X-Received: by 2002:a5d:5444:: with SMTP id w4mr26585867wrv.164.1572968973724;
        Tue, 05 Nov 2019 07:49:33 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:f096:9925:304a:fd2a? ([2a01:e35:8b63:dc30:f096:9925:304a:fd2a])
        by smtp.gmail.com with ESMTPSA id g184sm26057395wma.8.2019.11.05.07.49.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 07:49:33 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 5/5] net: namespace: allow setting NSIDs outside current
 namespace
To:     Jonas Bonn <jonas@norrbonn.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191105081112.16656-1-jonas@norrbonn.se>
 <20191105081112.16656-6-jonas@norrbonn.se>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <739c409a-bfbf-99c0-9624-38264d52087a@6wind.com>
Date:   Tue, 5 Nov 2019 16:49:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105081112.16656-6-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/11/2019 à 09:11, Jonas Bonn a écrit :
> Currently it is only possible to move an interface to a new namespace if
> the destination namespace has an ID in the interface's current namespace.
> If the interface already resides outside of the current namespace, then
> we may need to assign the destination namespace an ID in the interface's
> namespace in order to effect the move.
> 
> This patch allows namespace ID's to be created outside of the current
> namespace.  With this, the following is possible:
> 
> i)    Our namespace is 'A'.
> ii)   The interface resides in namespace 'B'
> iii)  We can assign an ID for NS 'A' in NS 'B'
> iv)   We can then move the interface into our own namespace.
> 
> and
> 
> i)   Our namespace is 'A'; namespaces 'B' and 'C' also exist
> ii)  We can assign an ID for namespace 'C' in namespace 'B'
> iii) We can then create a VETH interface directly in namespace 'B' with
> the other end in 'C', all without ever leaving namespace 'A'
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
