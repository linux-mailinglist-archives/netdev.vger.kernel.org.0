Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963452A3565
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgKBUvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgKBUvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:51:13 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD526C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:51:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 133so12195023pfx.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9USa59Sl1sSDbogb/g/I6VRPX0+3kmuw5B4Mat2Kz5g=;
        b=jE/795KAC/YFPAX0dTVRLj0+KYAX8dKMPIZF6Rw/nlDuVEB4/CIuRY9uMtZsXTotgw
         3MNRx1SMloOU/cTJbsl0u2jao1NsZSZB6AlkJmA17Qgt2xbbUFifGGbUnFA5Sdqbt76Q
         BTmqbbGWJ/IWGmo05138DFzKREqEO7kThTBwEsAiGlzkyW8hZiX5cxlRj7JfNiCuSNPc
         wLacUs7+Le3+VVQW5n8rBt1GdPrLPMSHVwbDug7zzcItnF3hMctTXa8nEF7PzXFyJncD
         o4K3srHOLBrR18lUfx+bgSCvcahfgeBBoypFdv+XkfCyEL0hd8NUGuu989aUiPrNkOK+
         yBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9USa59Sl1sSDbogb/g/I6VRPX0+3kmuw5B4Mat2Kz5g=;
        b=Ct+8R6iZLplZzcDeZkvtk5RNfAv3x8/MGoUcGNA+s7RIhF6GG4nKsHb3rVh1WHtVmf
         k9Tv8HwEB3CvFrA2ZNTEQ750YnHImmEiqFR+L5b6mHXf3RdjCaDf5p/b5597p5m7LkkZ
         ahkDf6ljz9Sv3VXsik9zFPuW5EQV9k27tx02c1Et57VEPc+/un/BLTK2SOotNbfDvQbG
         tToUV+n+B+gaNqZkVmLEyniJkxQo2QFC9G3Fnar4gGjN4m1nDWgEocGVxK/BavHPqRWF
         TSRUnTEv9EZSWaVGm4MQT14ArgrasCmhAn2xHeZwz3zmskD5zdKgeVfme2AgeNIyxIMB
         PB1Q==
X-Gm-Message-State: AOAM531EnaeAlgKwxiNHDuLNwkxps1w3Ae689OrJlqBvVExtcgpCh2+e
        uaJGhsWVKn0kpm6AVjE1rXU=
X-Google-Smtp-Source: ABdhPJz4QqXHCc9S0+CZNdeW9yGJWtqNmShYvimc/gZmU+BH1pxg2DoOIlpwx4WRqOvc5bhiOsArtQ==
X-Received: by 2002:a17:90a:590a:: with SMTP id k10mr6596369pji.59.1604350273345;
        Mon, 02 Nov 2020 12:51:13 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f4sm366567pjs.8.2020.11.02.12.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:51:12 -0800 (PST)
Subject: Re: [PATCH v3 net-next 07/12] net: dsa: tag_lan9303: let DSA core
 deal with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <40812b1d-0ba5-f9ff-56c1-9ec9d9429bfe@gmail.com>
Date:   Mon, 2 Nov 2020 12:51:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-8-vladimir.oltean@nxp.com>
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
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
