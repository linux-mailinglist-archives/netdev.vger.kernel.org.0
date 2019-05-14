Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DC91C69C
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 12:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfENKFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 06:05:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39886 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfENKFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 06:05:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id w8so16054462wrl.6
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 03:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+viHHyAFSguJj8sEz6N0xjErwC0KIopS3IA4u0afpUE=;
        b=IV8lUmBu5+yknluxiN7aqDKGhIQYmRTfctmhyEKI+WN6i0IbSp777uwTpg2tUms9aD
         Yzn4KMM9ec2rccaLurP7zZ52GUQutF0Aq08POXQkiCwXohV9ebKAQzoJVmsqacvh7l+O
         96tEu4RCreVDLNgnpc53Nq4LxV1Pxeh2CnVuknQJFq2tcbDrbYsWzGCd/KY8wuyxfylZ
         eCZr9JA74GtZ9oyoJXmvE1ff3cbLJ+NZzJSKgAu6x19AMpxGGLuSdan6LCkPGXun9c7U
         ZkljEsE9LW76a/kbMB30vzOTaeFVptJrYkRO1YA0Rn3fOm9vCL9IFacvAAPpMC8CxVjk
         40Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+viHHyAFSguJj8sEz6N0xjErwC0KIopS3IA4u0afpUE=;
        b=WGdjA1OPY00GuX1sV51DPF6dVZ2W4gc3w00ms//6OfoWJomXwrWmPTY7Tp9bnzL8vg
         2OESlkUGD9MC/oLN9WhenDVr1PBLDeFKrLC6Gn3QAMsxJmfB9N9GLnSoixIvpiSlKYJd
         ATF6TLgfBhAkxLL1ld9mQBwirbONTb8futUKKmtrZ9cIFVK+ELBcV0o5oakw2+6gCviN
         hv27nmwO5Td/U5cYL6EqIeQgXTzTOBdV4K1dRlKVVBif8+b7r86KxZuJbcMNAfCD71T+
         QsSB+vgtUKeyaVah6Z569sTbencL+yHSprMZTxMyufufGWqIPoRD/JraepYrMY+rgIWi
         RX2A==
X-Gm-Message-State: APjAAAVycm8xGM/hPStrU6El0gWZjcxuiSjqD6gkQe3n7HxQDbgmjM6E
        wpm03JrueXP1aqQ/5dFhNJ994w==
X-Google-Smtp-Source: APXvYqyI97Ubis8ECyfXSTDGFmNX1iIBcb79YE0jLvXjdkcGXpjQfabEAzx5SSIeKKUglB8F0L2LVA==
X-Received: by 2002:adf:82ae:: with SMTP id 43mr2177461wrc.41.1557828317764;
        Tue, 14 May 2019 03:05:17 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:64b3:e115:e5ef:6e9d? ([2a01:e35:8b63:dc30:64b3:e115:e5ef:6e9d])
        by smtp.gmail.com with ESMTPSA id h14sm5429896wrt.11.2019.05.14.03.05.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 03:05:16 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
 <20190513150812.GA18478@bistromath.localdomain>
 <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
 <20190513214648.GA29270@bistromath.localdomain>
 <65c8778c-9be9-c81f-5a9b-13e070ca38da@6wind.com>
 <20190514080127.GA17749@bistromath.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <7c8880b4-86a0-c4b0-4b92-136b2ab790db@6wind.com>
Date:   Tue, 14 May 2019 12:05:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514080127.GA17749@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/05/2019 à 10:01, Sabrina Dubroca a écrit :
> 2019-05-14, 09:32:32 +0200, Nicolas Dichtel wrote:
[snip]
>> What about this one?
>> Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network
>> namespaces.")
> 
> Nice. Now I think the bug can't really trigger unless one of these
> commits are present:
> 
> aa79e66eee5d ("net: Make ifindex generation per-net namespace")
> 9c7dafbfab15 ("net: Allow to create links with given ifindex")
> 
I don't think so.

Please have a look to commit ce286d327341 ("[NET]: Implement network device
movement between namespaces").
In dev_change_net_namespace(), there is the following code:

       /* If there is an ifindex conflict assign a new one */
       if (__dev_get_by_index(net, dev->ifindex)) {
               int iflink = (dev->iflink == dev->ifindex);
               dev->ifindex = dev_new_index(net);
               if (iflink)
                       dev->iflink = dev->ifindex;
       }

This code may change the ifindex of an interface when this interface moves to
another netns. This may happen even before the commits you propose, because the
global ifindex counter can wrap around.


Regards,
Nicolas
