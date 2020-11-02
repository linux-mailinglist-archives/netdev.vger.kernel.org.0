Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB452A355E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgKBUqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKBUpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:45:09 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01987C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:45:09 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id o129so12200452pfb.1
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QCl/Kor3xFuFDHdemr+4MvCV8wrwrxmK2qqeqj9fIOY=;
        b=O4ADT/pTCIURC5oD6kFNWtwDr2o+LdAdLnKZx+av6oFc4YwZLcV5xUJmfxZVHxuPIg
         /fBbq93Lc4KPYg+W8kiSJ0fY5OGn64vedUVrWGz1XmnHM3g3QCnAODI5O4B4e4D20kj/
         rCekzNyUhjmEEo0Wg46IrQ9AEoj/IDt+ph1Glkqu/08pTQ9QXRfTl+FfHcXAyaxdPtdw
         pcmjlZwSyFlCW109CvCb5IaLyUJ/Y2G63auEWNRQVV4FNINYJ//zZa+no9vri2xjFqvz
         r45kD6+7w+UJfvFBC9zt26MBz80bDyq9JYMeALPj2C/kMPYCU6y0RZ1Y5rAtVUcFiK5y
         loEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QCl/Kor3xFuFDHdemr+4MvCV8wrwrxmK2qqeqj9fIOY=;
        b=aY3LXb+OFKnjfKJpIVjBIDFs0ENFc1fSTbmIzjqVs+DH8x5ptEbbfzY1WbylkLh7e2
         MOvCs9/37nKh5pKjDvUWftZFbVvPq4qhxNrROnCG0y4iXcfKmTRPHJaRzHVq48SaCdtl
         H86Iu6HNhY1SKx/Pg7gMHENm2hfI+sfatNODeOz3rd8eeg/oHNoDh1FwaaFHNu/zUMp2
         GmpBiqaD1wfi51YYhjvF/pNtFHCZqXSb+nQqXMShHOyJHq9SPd4ZwCjPUxxNY7m5J/Fu
         R/M6TYDJDwXZFf+euk+Q00DM20zC1DzwAruNzPDk+9hDCOgLhEaLGJJ1C3W2PQQjb9vR
         e6RA==
X-Gm-Message-State: AOAM531z9TZsWjB2hhhiVBsWHJJBt17trl3GHoXNV7SRD2sTcNsWybD7
        WV54EWKACphE3moOyqjJWzabIW7awv4=
X-Google-Smtp-Source: ABdhPJyV4+MAxkPIuQHj+io3ctSJBNRPrgPEIZodu78tIm51rtbqWFM9eaHsm9WXGIYT2ZYcT+Ak1g==
X-Received: by 2002:aa7:96ce:0:b029:155:8c02:e74a with SMTP id h14-20020aa796ce0000b02901558c02e74amr22679621pfq.32.1604349908583;
        Mon, 02 Nov 2020 12:45:08 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cm20sm360181pjb.18.2020.11.02.12.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:45:07 -0800 (PST)
Subject: Re: [PATCH v3 net-next 04/12] net: dsa: tag_qca: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        John Crispin <john@phrozen.org>,
        Alexander Lobakin <alobakin@pm.me>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <42d8cb39-35b6-593f-3287-015a2234bfc3@gmail.com>
Date:   Mon, 2 Nov 2020 12:45:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> Cc: John Crispin <john@phrozen.org>
> Cc: Alexander Lobakin <alobakin@pm.me>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
