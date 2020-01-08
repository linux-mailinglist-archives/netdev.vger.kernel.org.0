Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE7134072
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 12:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgAHL05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 06:26:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38964 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgAHL05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 06:26:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so1474804pfs.6;
        Wed, 08 Jan 2020 03:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OyEwIf+brcpdIFP5riG0lncLBlwH96PTMEeMCIA2zzA=;
        b=D3NAVIM7clRMhS/BZxyoNCJNM+BYQBpegIc9wBhDjGqfApLd5n9Nv/ynfk6/6oM3oJ
         YgdPdNOTXxUEXbDSdCDABMCmDjaYibstmrINYgVo5rPaRHcMRn9vQSucVDKF6EfxpNo3
         Bc1qfwBOPV8u73bTwcHGS4Itg1v6X1sZQ6Q4uvoTsmgkS/KbgTdW9V7CVVHNsOg2JluG
         +WSFFi3KEyYrZUM7hYq8jpjWXk6rtQj8ajFKPtkCeBcMkxsdgUuT3wGAgrAGT2OelZG5
         8T5uqPSa9jdnX225AzmhovdA4fABGD8WZmBAocWpRaDUBJEOSIJ8hLQ0VJsXgNuMa/E7
         CUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OyEwIf+brcpdIFP5riG0lncLBlwH96PTMEeMCIA2zzA=;
        b=Xv11fPfDQyUNMw9Aescy6Ri/f+xDacxhAI8dP+igD0AS/IlgbTjxTgXah5Y9H8P/vs
         qFKwaPqem2oDJ5UbhxSwxlAdbk5wpMHmZUGmmXq78tNMMw9G/wJq1tgPyqfqFVuJyT5y
         thyHhD55t12SNfA7Vy/MrMmY3A1Zz5dm+JYPQDiQX/75AVUXBLNTto9yh+eyTsSMdRoJ
         Bupesp9lPISnzftvPcTMHUah/2P5wGKBKyj4v0b9Ue3kkbSUR/0Kh8OiT1jjomzDfwJH
         AE1Qags5QjDnwkwlTGC/NDUagY91pX0/bw8keRIfrn46AOD2judp4RINTfVal6oGuU4+
         eymQ==
X-Gm-Message-State: APjAAAVP8oUCok89lDdDBdd/4s818wDsptNrfCSX8trCW+XTGNke+qEp
        6VViIgZHgeL1PkBLgVrKaKA=
X-Google-Smtp-Source: APXvYqxLYaAC/+wgObu27QstOjgjV05SmQu9JZgFn+fS5p/fUwMT2k3N03riIS+dfV4lMRDQ1G3iug==
X-Received: by 2002:a63:4723:: with SMTP id u35mr4546002pga.194.1578482816504;
        Wed, 08 Jan 2020 03:26:56 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id w20sm3297806pfi.86.2020.01.08.03.26.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 03:26:55 -0800 (PST)
Date:   Wed, 8 Jan 2020 19:26:52 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] net: stmmac: remove useless code of phy_mask
Message-ID: <20200108112652.GA5316@nuc8i5>
References: <20200108072550.28613-1-zhengdejin5@gmail.com>
 <BN8PR12MB326627D0E1F17AE7515B78E4D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB326627D0E1F17AE7515B78E4D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 07:57:14AM +0000, Jose Abreu wrote:
> From: Dejin Zheng <zhengdejin5@gmail.com>
> Date: Jan/08/2020, 07:25:48 (UTC+00:00)
> 
> > Changes since v1:
> > 	1, add a new commit for remove the useless member phy_mask.
> 
> No, this is not useless. It's an API for developers that need only 
> certain PHYs to be detected. Please do not remove this.
>
Hi Jose:

Okay, If you think it is a feature that needs to be retained, I will
abandon it. since I am a newbie, after that, Do I need to update the
other commit in this patchset for patch v3? Thanks!

BR,
dejin

> ---
> Thanks,
> Jose Miguel Abreu
