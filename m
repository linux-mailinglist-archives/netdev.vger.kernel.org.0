Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7F11427E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfEEVWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:22:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35619 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEEVWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:22:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id t87so5059766pfa.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 14:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HHKVhCOnqeLJsl6JvnIDCZrNYV798cOYOiPxV2wMUok=;
        b=U+isgnYFOz8Me5Y+/+mHdYwjEpxeS/7Qonze9r0XJI485krwTzrlkDBJDvlEJQ0f/2
         YdZPn7YWJeC2oO3858QWKPdML89uksdWMk6Q3R2xTxroG/ncclVjWA+qowVbI5v/P+cm
         ePRH6qk89VRSTxQ33UMfWt8UXCr6rXF5R9bs16K0bvqbX55A05qg/dpfCaSVESO4+yvN
         6GEM//wODy5zwcUNSnMt8rfoq4BlxtdYKwYbkFX8h+pDKes5BTeYxLC6cXQHMTAtL6nc
         pUCjJ9694MwS5mVSKCgs7woLqQOqqeenB/Qd/nUUrA8CIrZP+ymdOYowGFqgzHJhnWNJ
         kraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHKVhCOnqeLJsl6JvnIDCZrNYV798cOYOiPxV2wMUok=;
        b=QsWo64FsyMSAI7kVqKCxf+sksuEsTMw2QNnd2BGXKlZr8u2fLuDognu68d6S5vQsOE
         GCMB2uyeBsagl/qSfAlD4UQ2JC2wiCyvmKU1NPDNOb9D4HbnKYjVxcopwpUpOKf8+J9S
         5bqWEUkHtMsqoh4rKFOCFMPuOaqn+ASNnDDs+inCbwOE7RC8COxuzqO87N2YgQAyrV9W
         SJoXFfA+XdvCX6i6m/SYa7KcanxHhVmyKctcx1NLowcerXQAq5KVkSVzink/XABWJtoJ
         gVDRNLjGYG9O5UpAuItH0rYdHJJ0eudpCTOW7ht/V78ObqhLJ89gdR2ref78LJ5ljlzl
         6gsQ==
X-Gm-Message-State: APjAAAX70b5Jg97t9v5u86ghDElMnDo6OkPtE+BYt0bmMsxfplRXvA2W
        OiFdi0ujol4hw+5Lr4u7ik83eGiT
X-Google-Smtp-Source: APXvYqzlJWKTnXX0+N333C/sBFN04lXrqYM5wTOjKpR/mSEfPnhri6ZDwOttl+y592WoUYahEIOtqA==
X-Received: by 2002:a63:e550:: with SMTP id z16mr27874261pgj.329.1557091342441;
        Sun, 05 May 2019 14:22:22 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id x66sm11833706pfb.78.2019.05.05.14.22.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:22:21 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] net: dsa: lantiq: Add Forwarding Database access
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20190505211517.25237-1-hauke@hauke-m.de>
 <20190505211517.25237-6-hauke@hauke-m.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8b1e332e-5f75-67bb-ccee-c15d2eca9650@gmail.com>
Date:   Sun, 5 May 2019 14:22:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505211517.25237-6-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 2:15 PM, Hauke Mehrtens wrote:
> This adds functions to add and remove static entries to and from the
> forwarding database and dump the full forwarding database.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

[snip]

> +	mac_bridge.table = 0x0b;
> +	mac_bridge.key_mode = true;
> +	mac_bridge.key[0] = addr[5] | (addr[4] << 8);
> +	mac_bridge.key[1] = addr[3] | (addr[2] << 8);
> +	mac_bridge.key[2] = addr[1] | (addr[0] << 8);
> +	mac_bridge.key[3] = fid;
> +	mac_bridge.val[0] = add ? BIT(port) : 0; /* port map */
> +	mac_bridge.val[1] = 0x01; /* static entry */

Could you add a define for that bit?

[snip]
> +		addr[0] = (mac_bridge.key[2] >> 8) & 0xff;
> +		if (mac_bridge.val[1] & 0x01) {

And use it here as well? The rest looks fine to me, so if you fix that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
