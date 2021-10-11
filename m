Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3821D42850B
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhJKCNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhJKCN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:13:26 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00198C061570;
        Sun, 10 Oct 2021 19:11:26 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w8so5935904qts.4;
        Sun, 10 Oct 2021 19:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=TjqKF2G+ot9TWefZKW3C9zHAsRlyIodJTLXAqIsvayg=;
        b=gDWcKZ0UQztjnosn+22+oduSALPggiMtDr3olLnvrtYEutZ786C4flvHc2fHJjmPU0
         PPwaWBzvwFuZ+326y4SVRvpv2eb8sN216gPGVTv0dT0Qs20IDijIIxPzaiVtgggPqnFE
         WT5t8aHKxXA3zOKNtalmN/r3756ntnokcVPRFvVED5OtbTC3AJyN8vN8Vo3DPZ2BSGP7
         lC56keMz8sBpmzihf9FiJtahDFabdcX70lHM4DdH3TD5Z3BMz2tkVYjX6gyA95kqxXAZ
         KaA7O8KFJFUSApVDM23gK3dkY2pbty16Eakpc31z1Tk3W8naj8Qao6Z01vShxF5iqJfK
         jiiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TjqKF2G+ot9TWefZKW3C9zHAsRlyIodJTLXAqIsvayg=;
        b=rVeNK2rOJK7O0ggKZ39F0YdaCn9J1p9JY/z6V0NLGZNdtkbVahOeBlyRDk4xI8ji/s
         OzLPEPOf2/fpv+Al+OWCI4E2Z5qjJXTBcQ6XD2oORiPprrkFJL6D7f9J6qfr2axrW7vi
         2lWZbunhhQzmdWyigHlrd4KLqBsuHAXP4IkHIdP6Eq0khurstp0gCOUbGkgcPTA3Hzk/
         QcdpADW8C7AHHsgpaNAqb0R8j8m8ST4dxk0L2G0xq8b4zdWnSN1qpFFlHINOQzYidAfY
         0LlY6Ev9rUf5Bwi86I1iw48JG+RmJJpphCuzmm63hHBJrarYnT70o0HCUdQG74XxWefh
         9DMA==
X-Gm-Message-State: AOAM531cKSr94M5MkzAnfwnTLata80A1/jdtnzWDomYCSysYIbzfyF7k
        hARHi3e0jDUrwBn8F4rHQSI=
X-Google-Smtp-Source: ABdhPJwnOFDzduH2yaeDsuWn7nxMdHFMXNlCkIL5KytE07B7ka8nsZDabGpiUT2Vna/P7Qgr0GFaCA==
X-Received: by 2002:a05:622a:316:: with SMTP id q22mr12131941qtw.225.1633918286096;
        Sun, 10 Oct 2021 19:11:26 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id q22sm619750qkj.64.2021.10.10.19.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:11:25 -0700 (PDT)
Message-ID: <fe8833a4-df21-475b-7ddf-dcda54550652@gmail.com>
Date:   Sun, 10 Oct 2021 19:11:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 06/14] net: dsa: qca8k: rework rgmii delay
 logic and scan for cpu port 6
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-7-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Future proof commit. This switch have 2 CPU port

Plural: ports.

> and one valid
> configuration is first CPU port set to sgmii and second CPU port set to
> regmii-id. 

rgmii-id

> The current implementation detects delay only for CPU port
> zero set to rgmii and doesn't count any delay set in a secondary CPU
> port. Drop the current delay scan function and move it to the sgmii
> parser function to generilize

generalize

> and implicitly add support for secondary
> CPU port set to rgmii-id. Introduce new logic where delay is enabled
> also with internal delay binding declared and rgmii set as PHY mode.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Otherwise, looking good to me.
-- 
Florian
