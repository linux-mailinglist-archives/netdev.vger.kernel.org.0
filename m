Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D77D1E17
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 03:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbfJJBxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 21:53:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35470 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfJJBxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 21:53:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so2843098pfw.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 18:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xOtAm7vQuBLidshHU7kDHckjp0ms8oqtNNNnhKSMyjY=;
        b=hKEvnero81oZtsaIeqVFFSTuD51qS0fqimdzGIvFKd8UdmY3W5rz4BlHiNtm9ZihPR
         JhJbj1eyd8i17COeSCy9kBMPg/yBLi92pAlknaDY1obox5IrQmFu9C2SMe0BlCGUepqR
         lxXGLVSejrdMaJfjHfs3F40nAHBytPxo0UwUs0gZWi+8YO20OolbCnfkqzfqL/Msfv/v
         8nwMm3cYg1Ysi2Azpoee391sE3ksLG3bMqwPQReyueNmKNyEk2D9vMkZ197QRrADwm1e
         eExS4jrFR5dhDEP0UGAXK8kU81rLhzQ9oAE+5awkCBKgocnORn7vdRG8Iu3wQg/Y1KL/
         uF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xOtAm7vQuBLidshHU7kDHckjp0ms8oqtNNNnhKSMyjY=;
        b=XczczSdpsMFskMkOetBoXCRVbGa3GtCWFdA+YARQ+YzVjQ0y4dPulv1nvrih8oXUXm
         z6CxJwXjHfatSwyrz3EWNN6GUqmbL7xFsL9CGr4M3+1a9p5Qw41LhONHu8Ej54RndGrm
         65zfnoLh5eAzoTbF20imPS+/1NuIbtbfeGnFIHJFmSuz2+PSH2Ihu49zGYR6yzgnCyiP
         8k7H+TTMyCBj11CU7EhO9fD1l7bF5n+P3MfFmtGCD7XRrAIvbUGnMCqq6U+pktaBipGb
         WYSbABeU/MGKjTN4UUOJDXSrI5wQTFEwGu0T+ULYLUai94YrjWz08ur5RBdR0fDKyZRk
         ZuFA==
X-Gm-Message-State: APjAAAVdRNJUQUpOO1L/iNT0d7Mtble6ycLvLoEOodLV1Xb/Ztrlu8f6
        r7iaiYV2zUNyVptXAxP3TQQU8A==
X-Google-Smtp-Source: APXvYqxdSeqLQon+/vFSyT9+UELawwTPdLNncrMbU2c3O/vumQmCJyc/2wKvvbGQAGyE5LrlMji+1g==
X-Received: by 2002:aa7:9295:: with SMTP id j21mr6958090pfa.87.1570672388833;
        Wed, 09 Oct 2019 18:53:08 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id g6sm5632299pgk.64.2019.10.09.18.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 18:53:08 -0700 (PDT)
Date:   Wed, 9 Oct 2019 18:52:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, olteanv@gmail.com
Subject: Re: [PATCH net v1] net: taprio: Fix returning EINVAL when
 configuring without flags
Message-ID: <20191009185253.151636e1@cakuba.netronome.com>
In-Reply-To: <20191008232007.16083-1-vinicius.gomes@intel.com>
References: <20191008232007.16083-1-vinicius.gomes@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 16:20:07 -0700, Vinicius Costa Gomes wrote:
> When configuring a taprio instance if "flags" is not specified (or
> it's zero), taprio currently replies with an "Invalid argument" error.
> 
> So, set the return value to zero after we are done with all the
> checks.
> 
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied, thanks.
