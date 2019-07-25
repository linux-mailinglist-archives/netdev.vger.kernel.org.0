Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDCC74D49
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404095AbfGYLj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:39:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53322 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389834AbfGYLj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:39:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so44685225wmj.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 04:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/KNocy2+ZfOQXTjSVoKpw5gYwyEUDk8UgKcJTP4ngYE=;
        b=MAEDyrQNT8xSuX9iSr/7BWAuVtiFFg0r91vvdxT2++HHJS9g3J0YPwvOtkJtKUq8Jv
         5iKmWqJK52t0LH1sXJk3PO+C21INeHi4V/ZYW7YuPXVIBflnQMtUHe6awRTT5dvD1DaE
         WpfQIVfVij+bSGThMlicGuVLRiLpF6rqQwZpgSsW3OX9UHyDapWCYIrbuJner3poxc++
         G0Bn8vzCLpCMRU3GuO3rYDre/AQ/pQH9pBaRn/BU0lkFmSiIGNMktCQBPARjaQkabMe+
         GuF14I1ZfrdG7ZX9sunB4JjQ9JvX8MVHFeTldfj+sF04kvwCNlmOmMZTYqLm/phbk5K8
         qnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/KNocy2+ZfOQXTjSVoKpw5gYwyEUDk8UgKcJTP4ngYE=;
        b=fysYU4QbSh8ojqfh6BIq2ByAM3SuSYRLUCGpnSSBkCW8rG74qAsGRIZBgorrW7S92b
         Uht/0FYogkB8yvSEo9trjzoQEkuVLI/5fHzAubPKJhr3CbOp7Fw+l1YrAKP4A6hyMVuu
         FiHQYDRxvCE9NyA4RJ4/34Ns2T5IcRHbTSqBj83JwZ1d4QXDYT1fJnR37BGBj3kXhavn
         pmzTDpK3jPHsTEKgCEXm3VtZB33TMTyjaVWg4IjkhXqU/lK8U7IdyFE+Hd7Oeb0Y1eW/
         DTaSCInOjAMXyUKwMQCCwjiv7RtF6oCFmzQ31v8GN46k9WwEh0K2Bd7hKzyrobY+CSFh
         5wlg==
X-Gm-Message-State: APjAAAVST1DVTfAxcLUOibbb79wwciXvIWEQTfqu/qm92u+2lfv96BE2
        EZ/62Dv6Govk5/gKAWelmilZTg==
X-Google-Smtp-Source: APXvYqxKToM60L7WegP6mEG3X3RaqPtSEAUsT9RXfSRetFr+Hk/NVm3V8WF2BD26TvV4TjAbT9vnuA==
X-Received: by 2002:a7b:c5c2:: with SMTP id n2mr77541522wmk.92.1564054766915;
        Thu, 25 Jul 2019 04:39:26 -0700 (PDT)
Received: from apalos (athedsl-373703.home.otenet.gr. [79.131.11.197])
        by smtp.gmail.com with ESMTPSA id p6sm53195376wrq.97.2019.07.25.04.39.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 04:39:26 -0700 (PDT)
Date:   Thu, 25 Jul 2019 14:39:22 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "lists@bofh.nu" <lists@bofh.nu>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "wens@csie.org" <wens@csie.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190725113922.GA1703@apalos>
References: <20190723.115112.1824255524103179323.davem@davemloft.net>
 <20190724085427.GA10736@apalos>
 <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <20190724095310.GA12991@apalos>
 <BYAPR12MB3269C5766F553438ECFF2C9BD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <33de62bf-2f8a-bf00-9260-418b12bed24c@nvidia.com>
 <BYAPR12MB32696F0A2BFDF69F31C4311CD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <a07c3480-af03-a61b-4e9c-d9ceb29ce622@nvidia.com>
 <BYAPR12MB3269F4E62B64484B08F90998D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <d2658b7d-1f24-70f7-fafe-b60a0fd7d240@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2658b7d-1f24-70f7-fafe-b60a0fd7d240@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon, Jose,
On Thu, Jul 25, 2019 at 10:45:46AM +0100, Jon Hunter wrote:
> 
> On 25/07/2019 08:44, Jose Abreu wrote:
> 
> ...
> 
> > OK. Can you please test what Ilias mentioned ?
> > 
> > Basically you can hard-code the order to 0 in 
> > alloc_dma_rx_desc_resources():
> > - pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
> > + pp_params.order = 0;
> > 
> > Unless you use a MTU > PAGE_SIZE.
> 
> I made the change but unfortunately the issue persists.

Yea tbh i didn't expect this to fix it, since i think the mappings are fine, but
it never hurts to verify.
@Jose: Can we add some debugging prints on the driver?
Ideally the pages the api allocates (on init), the page that the driver is
trying to use before the crash and the size of the packet (right from the device
descriptor). Maybe this will tell us where the erroneous access is

Thanks
/Ilias
