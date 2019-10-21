Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E59DE24E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfJUCnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:43:32 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36198 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfJUCnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:43:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id j11so5874573plk.3;
        Sun, 20 Oct 2019 19:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=whcljhgwF/VLMrwCM5sav3bSUHoyALVsT42DyK47xIs=;
        b=J6MvKpTZvj81SJeygT9J9FhClSqtd4dxaBL06/APdYtg17qm3Cj28xzUSIjpN9TZnZ
         T11atwWb8NZ2nPAf0mODEdldt7uWpZHf1M8fChKCRtURpyFgtI3YN9LGhkyKb9QwdXPK
         fqn5VlD+Cawi2CeU7hhbzUNtuwRW9rIYN96r59VFCdng91DGhZctdbRHjTsCtDtCfALt
         9QIBrwI52p0PlTaav60qBn4haWV7WOvQwgN7X+umJ1utoMg+2AjLSQxtK9yeTfS7Jirv
         mHuh2bOtVrcE5CsoIZ+SBdSYt68HKgxHLxTnk7TfGpouVO09C557nnZd6QaDXv/Cg3QM
         ipeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=whcljhgwF/VLMrwCM5sav3bSUHoyALVsT42DyK47xIs=;
        b=qYkvg/kAxsvxul14ONFaiKsrnj4fA7lpr+KIJMg4kKh3/m2LiRBW5k+VA52s/lTbmS
         qLQ9YpSUpYZ7RQGZJCu2zJudApkO+kplmkEjKP+5spyFVxzAYIoZiQhidx+xHLIsC9W4
         05pomsfHzypMgVW3iH0YC4Zx/d7OKtWi34vJtvWRkzoz+jGM61ARCi+nhJ3z3WBDTL8K
         tw/+mQnrWEnrPlznuTPI/hSXklrQF1nHLYvEb8Q/tji2cz/T+T89NvDI0C+vhv+Xxb7R
         6zg3gBOxEAnRWg1FZzz8O9z+WwJKC/Omhr8dlDCfs+c866+olmUUm+zBom0RfG5qAiLb
         d3EA==
X-Gm-Message-State: APjAAAXQYacYF1eJJki+Xy0ike8z0ljIJ4HxxeSVYTfenFOpHc5l6w9+
        CSoCdp6MB2yHV6JFSCqkOz7m6TeD
X-Google-Smtp-Source: APXvYqzjODtwIm5TOg0wG4xQRry5/Vd32nImiJN7YmiLsMpNMGPemffSN7dYm+D8X9iNALGRhBbHGQ==
X-Received: by 2002:a17:902:8342:: with SMTP id z2mr21953393pln.309.1571625810874;
        Sun, 20 Oct 2019 19:43:30 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 71sm17725136pfw.147.2019.10.20.19.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:43:30 -0700 (PDT)
Subject: Re: [PATCH net-next 07/16] net: dsa: use ports list to find a port by
 node
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-8-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c22f6790-7c75-d53e-a540-07e61f901479@gmail.com>
Date:   Sun, 20 Oct 2019 19:43:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-8-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of iterating over switches and their
> ports to find a port from a given node.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
