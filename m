Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B324F14278
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfEEVS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:18:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38712 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEVS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:18:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id 10so5636304pfo.5
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 14:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mKfv7r+o2Ng6CsMyUxLR925WvyqMBV2KXWMDD6SEnSA=;
        b=aRKsuSo/nhogI/kporkwqyzzawCx5+7w/xi8t853/hQUYyByoF0WfeqYDswJAH1Ht2
         qTKBxzfqpr8Oz4ESNG3aGJUEkYSd2+YAX2j0KjJ8KVaOAyDbumb6nUtG3+ykJDPy0AjU
         TKQI4jNcT+hePZUeTSjtTPVQUARlHLLbD6DWN16wn3kGvQjJFl3bUUvQTJ9eLdH6fXPd
         kC5odzpSNNTv7i7Tt38QpkP0u59UL4BpUNnipKosZbCxZAC4aA0jboasdQNEI7qt91Qf
         I5ugWEH+rHVBqn+6iQTLfix8I3yNQWbH1wUl1VrjcyB2Z7Xf9SA7rqdELZWETzspg4rL
         ZWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mKfv7r+o2Ng6CsMyUxLR925WvyqMBV2KXWMDD6SEnSA=;
        b=SsYcwvVSpZ0VGY6tnbUlmnp5jhTKnLAEEQaAr/Wr7LZs21/SFsevtDVMs/yCQmgeDC
         d4hcMvT2oqtEjhrMNQAFi2F96VH/zn4GUEFrMNovo23/Tj3y2TQXFvbyw7YQGhbkJfqG
         K52FGyzEUpnRqX1EQhJw6rP6wl6UysVoMfofIAefQj5/ORwEtfqb4XbuThJfljslhrqD
         dPEIpAovUYJom3fK32Db1srrRMFyh7dqudG5+at78SBSZ83XmrEUt3oH5P9B5G9l1eYT
         AgoEXRYy3V36WvNHGCPwse3tSR7t2nD+NVyVTOTwdM24MV9bW8FXerTt/vrkknjDMnjk
         herA==
X-Gm-Message-State: APjAAAXtLBLfLaqNvMF50W1p5QiZnMr7ofCUk4pZOC5ZQLnp1SmqVzSi
        BsSVCFSaq4eKuDboidFmXNjHbdlQ
X-Google-Smtp-Source: APXvYqyr5PUZYdr42wSPkWHSMnLZwQaxLZ0SUQP2mA+FPC+Fw84qkugB9EogwPT7DnOLqO0z4sBy2A==
X-Received: by 2002:a62:2b4e:: with SMTP id r75mr28366999pfr.131.1557091106899;
        Sun, 05 May 2019 14:18:26 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id w125sm13974499pfw.69.2019.05.05.14.18.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:18:26 -0700 (PDT)
Subject: Re: [PATCH v2 4/5] net: dsa: lantiq: Add fast age function
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20190505211517.25237-1-hauke@hauke-m.de>
 <20190505211517.25237-5-hauke@hauke-m.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a21ef00f-7b7a-9767-25a5-bc20bfdd4c1a@gmail.com>
Date:   Sun, 5 May 2019 14:18:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505211517.25237-5-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 2:15 PM, Hauke Mehrtens wrote:
> Fast aging per port is not supported directly by the hardware, it is
> only possible to configure a global aging time.
> 
> Do the fast aging by iterating over the MAC forwarding table and remove
> all dynamic entries for a given port.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
