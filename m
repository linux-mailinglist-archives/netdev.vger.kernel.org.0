Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400C52EFDA4
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 05:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbhAIEEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 23:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbhAIEEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 23:04:43 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6440C061573
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 20:04:02 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v3so6703794plz.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 20:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sX38bWPpEprRNZ9k68w2UlCRgBvPB+0bMYLDcGIiIvk=;
        b=gIswEYANxTDYmYjmJKqxejErVRgQzQa7jb2ah9rU0FtVAFjEbshggPBxHLmlfRhKlC
         tZ2pQaTA/qP/y486RmMgi9MzxNwndz/dwkpELHxz0N0iwnVuDYUpuOs2PpHJ+waDN6r0
         JKZTAzrZ24KfPOCCqWdgh3q5bINOPLwXZK81UrulVRM2VoikLfg5w783Cwx+xZVhKwh6
         CLWb2HlmIuEwYRf3HLrBvMyRKvoWvdVS+2NUBIvKmnU9Lx68Cqe+fa5bWeQkFFqfO0d3
         rvqtuGhJ/FzLILdhfTlPf46e86L420i71W06usnOnlB35N+GSLAW8ErSFhCZibIfbXwh
         trEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sX38bWPpEprRNZ9k68w2UlCRgBvPB+0bMYLDcGIiIvk=;
        b=dW7FFAD1dbMdoZZHyJGzoL4QZE5Q2P7Q3PxJZBIliCvgBxMquTOVcwMijGhNrIWadb
         T6sbPG17FkHNmsiqK9JD7qoweBogMHzKlpezeVaiZP1yGWkkmjvYEh68b0rywBoRpQeF
         HchCDE/qXbV3Rw9oG7eDyHwgQek97/p6sH1eJJci5HarD7u4bcEsATbEIQXUbLi4cOnn
         XdRc4itY8Qkrb5ORKRjI+vsdGNDnmvF+/WSseiq/9nJcMytqkS5XK/rfxdYuqxP+aBs1
         J0XqsfGk1khOzz3ugkLUx5ghmoJMoMB9L+hPoMUlrSkE08rJ3aCljtTxvy7WV2hUtz94
         zTzQ==
X-Gm-Message-State: AOAM532nVKNkfhizPGU/1x0XWLg4YbFJRgcn3n9ns6tlM83ST4JmMsD4
        MSQhb0TkoWI27uPhT/YC0Lg=
X-Google-Smtp-Source: ABdhPJymf/10Gs3gNKeiolJ8czA1h0DBSQG+uJpgRuSqfOr6p0QYb/cmFasJHlFgP4BHIwiKKVTATA==
X-Received: by 2002:a17:902:ee82:b029:dc:78e:6905 with SMTP id a2-20020a170902ee82b02900dc078e6905mr6952546pld.48.1610165042275;
        Fri, 08 Jan 2021 20:04:02 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm6547307pjh.24.2021.01.08.20.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 20:04:01 -0800 (PST)
Subject: Re: [PATCH v3 net-next 10/10] net: mscc: ocelot: configure watermarks
 using devlink-sb
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e802d4c0-7247-346f-e6da-4965068d131c@gmail.com>
Date:   Fri, 8 Jan 2021 20:03:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Using devlink-sb, we can configure 12/16 (the important 75%) of the
> switch's controlling watermarks for congestion drops, and we can monitor
> 50% of the watermark occupancies (we can monitor the reservation
> watermarks, but not the sharing watermarks, which are exposed as pool
> sizes).
> 
> The following definitions can be made:
> 
> SB_BUF=0 # The devlink-sb for frame buffers
> SB_REF=1 # The devlink-sb for frame references
> POOL_ING=0 # The pool for ingress traffic. Both devlink-sb instances
>            # have one of these.
> POOL_EGR=1 # The pool for egress traffic. Both devlink-sb instances
>            # have one of these.
> 
> Editing the hardware watermarks is done in the following way:
> BUF_xxxx_I is accessed when sb=$SB_BUF and pool=$POOL_ING
> REF_xxxx_I is accessed when sb=$SB_REF and pool=$POOL_ING
> BUF_xxxx_E is accessed when sb=$SB_BUF and pool=$POOL_EGR
> REF_xxxx_E is accessed when sb=$SB_REF and pool=$POOL_EGR
> 
> Configuring the sharing watermarks for COL_SHR(dp=0) is done implicitly
> by modifying the corresponding pool size. By default, the pool size has
> maximum size, so this can be skipped.
> 
> devlink sb pool set pci/0000:00:00.5 sb $SB_BUF pool $POOL_ING \
> 	size 103872 thtype static
> 
> Since by default there is no buffer reservation, the above command has
> maxed out BUF_COL_SHR_I(dp=0).
> 
> Configuring the per-port reservation watermark (P_RSRV) is done in the
> following way:
> 
> devlink sb port pool set pci/0000:00:00.5/0 sb $SB_BUF \
> 	pool $POOL_ING th 1000
> 
> The above command sets BUF_P_RSRV_I(port 0) to 1000 bytes. After this
> command, the sharing watermarks are internally reconfigured with 1000
> bytes less, i.e. from 103872 bytes to 102872 bytes.
> 
> Configuring the per-port-tc reservation watermarks (Q_RSRV) is done in
> the following way:
> 
> for tc in {0..7}; do
> 	devlink sb tc bind set pci/0000:00:00.5/0 sb 0 tc $tc \
> 		type ingress pool $POOL_ING \
> 		th 3000
> done
> 
> The above command sets BUF_Q_RSRV_I(port 0, tc 0..7) to 3000 bytes.
> The sharing watermarks are again reconfigured with 24000 bytes less.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
