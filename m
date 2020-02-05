Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23781535C0
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgBEQ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:59:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43717 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgBEQ7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 11:59:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id z9so3600473wrs.10
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 08:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=glnjeYfj7CXlX0oXqWEDa4SaRTPpERU3X53s2vCGPQ4=;
        b=VCoSqLh3L/8hiOY3N11IlILO/6cKk6FBagfOy/4gZC2SH42xU9wJ2DTDhPw858MJyn
         EyWLWkYgXpqfY+uWkoMlqyaYOs+UH3i++WkBvfpG7bjYdwBPJp+HrQDw2mFRcAYWnJrv
         XpYlOAeazsg4wGqng15teriCEEggXcJhfPDIA3dT97xZbjJD+iKQ2XMoAz3C43WWWxaV
         0bt8NUw5B9mCqcWOTsU46w78nsMY1L73gLQG+FtFHR7HMxWGCyzmbV6tW88i7LSXDlZK
         i8+f8oz5kBLtdxwfg5s26QeXYCZOv2ETNEJHB9QBJOQRqT68FTNMvG3v9yT9Xf16Qcls
         uPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=glnjeYfj7CXlX0oXqWEDa4SaRTPpERU3X53s2vCGPQ4=;
        b=hDDn7jH5p0oQuBAsIoJD/9FCPySd8iGkW+mhpEkHpi9Q8sb4rcOBu7n57wDHj08fDB
         qfeeKQpQh56lq53qKaNov1aaQxXwTm7eofItAJt7uFan+CyTLhfiUsR8rZWSIykPsz/1
         Cp6OGEcHF+D5nftbfP95Pqh2zsaOu/EHt0F5iymveA+K1RKlBUAI2jrLnCxIqCALRSzU
         map6N9avxgc7s1NYEUKWwjm3ZxN9BQDlNOLyk8mkJMQnA982kSdrkx/rBVccYlhEv4cv
         qhjgw+kjpkhr07IA56uFHy5HGuL65Rk8BadDnn1TiDl6IR9dEShwXq4vOolOJ3XNi5V3
         1nbw==
X-Gm-Message-State: APjAAAXu573YgCA8RWkplZzxQhz6Ldew+SSCBTGqyzpOthuPY1tNKzVU
        O3ZsupUrU0AzGlwVuz7zPBWzqNKToJU=
X-Google-Smtp-Source: APXvYqyCYmOe8ai+/q3XF/PlgoUKM2Gnw1aO5N53sM/U49IXDKLDWHCu7eBIwgCtU5ggQ57Tp4dyjA==
X-Received: by 2002:adf:e9c5:: with SMTP id l5mr28982438wrn.322.1580921984764;
        Wed, 05 Feb 2020 08:59:44 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:9c0f:f129:76a:d5c? ([2a01:e0a:410:bb00:9c0f:f129:76a:d5c])
        by smtp.gmail.com with ESMTPSA id a184sm201957wmf.29.2020.02.05.08.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 08:59:44 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 2/2] net, ip6_tunnel: enhance tunnel locate with type
 check
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
 <20200205162934.220154-3-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d9913ff8-988a-0c24-d614-ff59815bf6d7@6wind.com>
Date:   Wed, 5 Feb 2020 17:59:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205162934.220154-3-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/02/2020 à 17:29, William Dauchy a écrit :
> As it is done in ip_tunnel, compare dev->type when trying to locate an
> existing tunnel.
Can you elaborate? What problem does this solve?
Which tree are you targeting? net or net-next?
