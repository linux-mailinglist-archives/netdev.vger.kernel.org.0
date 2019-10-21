Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202CDDE231
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfJUCjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:39:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43208 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfJUCjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:39:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id l24so1875498pgh.10;
        Sun, 20 Oct 2019 19:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FXX0eimPN51agwu4IUgl2Y0MLDo3hLD4MB7m/Xqc9Vk=;
        b=V/lNMqIv52M7BGUqI7bDaG9JIhTtFuYkms/GF44oEjDACl1JaxMdpa/agcoVNiWlkL
         oNdxM/UZKAbywRpq4fyC/wnO9+VVOZA64fvIsc9rFYsTQxVWs7Dfqxdymjktz/x9veXj
         /HjowO7T0Z5UBxEZ+/rkiCNz7Fiug3dmpeYtIo31olX7j9EeCl5ebieKBKLz8tn8bzhy
         IoLT9QHm2fPx7u7xoOoqI0u7fcV/UajMO2S1IeHjS7CtQlCSrIyY1x6GNuBXIhOUJyb8
         YDz2W0R+VyFQDwaHiq1ojDXkyYI1653s19VdKx+JDcHjCFtZo9ViqejdCvcatT9N4LOi
         W+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FXX0eimPN51agwu4IUgl2Y0MLDo3hLD4MB7m/Xqc9Vk=;
        b=A73eCSzQo741z/3wc3BRLroQ3AzoD8qApv33fs0MB/+D6gPQH647M5hn4cFbFL7Jtz
         mcn0/DgD2xwAykc05bGCXr7LvPZyFAntqlzk43tSbm2Ux0kzYEPWem4FHcjo/XZxRqv1
         hPUcpLQt8Lm38kPqED+2HJnG/5L6LtVcx0wYykzqpjrrsd1DHcC1rZElc6fXArEo7vN3
         2AikysanV6njhlRQ6FzVpaSVDkrnHTqlu+Q7LZ00hGOOHI2c6xhQBYAb2EgY6m33ihAo
         gnbmpz2jJzNupgPRPPDAbjBl+hjfY7MG+8ArdkUraNJzqGs+NIag+vUvBUm5vfr/+hbu
         jZkw==
X-Gm-Message-State: APjAAAVPBxNfRBA1EQFBzlUFxkLG9i8jIfhQsCHVoxgXj6xgNTJypDLs
        2gn+98fem8FOLp1qvmMzLUFd65dg
X-Google-Smtp-Source: APXvYqyHw/R3WJ2dtQbajyHADqcnyCm4owRP6PJDKFQqsakdZn5+zKhoby2IVhQCXoVNhfDJBOVPdg==
X-Received: by 2002:a62:7c4d:: with SMTP id x74mr19913197pfc.259.1571625556961;
        Sun, 20 Oct 2019 19:39:16 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z25sm14410808pfn.7.2019.10.20.19.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:39:16 -0700 (PDT)
Subject: Re: [PATCH net-next 04/16] net: dsa: use ports list to find slave
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-5-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0b1fbb2e-a7d9-de3a-eac3-0bc4e2e717c9@gmail.com>
Date:   Sun, 20 Oct 2019 19:39:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-5-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of iterating over switches and their
> ports when looking for a slave device from a given master interface.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
