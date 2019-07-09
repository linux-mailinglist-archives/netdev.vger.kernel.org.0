Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A377E631DF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGIHYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:24:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39992 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfGIHYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 03:24:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so1983564wmj.5
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 00:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=03TkoezjgkAZL2YmFuoEqna7NSM8InGqJI+3ARKjL1o=;
        b=FDJIw/XXd8rciEohBUKmddB8phPThT/PekIFiIN1cV+l66VsdC0Itam9we2NMoOqYP
         zBHeqKlzeTGyY3g/sM4yKyKMITVauqjdMGiSqi7Qe4u+ideDdLeEycXFIt1qMs8O091N
         IeEHWcipFxAp5FvVKok6cqbLm6foJ2Zf78DS35yfTVQp2IRNPHG4wJGKr5BCgRYX1fsC
         Gal52Dc2u9+vN7WHfgRi/AJPwy43zH8kL5FeQ6phfuf96q/RVuy7h5wgcKb5pNvQxq19
         j822OniI4eL5t2RDAoE5UHnZycbkUczRRXkOvxqbuVFHb0Bmuj/7/zlTbr6HBedkBEHo
         b7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=03TkoezjgkAZL2YmFuoEqna7NSM8InGqJI+3ARKjL1o=;
        b=pkuXAZZTepk8h1UoyMxbTsiPBRF3DWJcTA+2nytXJODO9Sx3+q58kUI8SxZwTvEhjn
         5n8fhIIwD3gr8LydDRVzhvxpdg9dNZyecFK6HNRUbAvKKJthvb/1K9FhxCTAZVIVdxaB
         WhFX49g/AG2SBsWhMM6HVb27mZG40eMcf8xqCBPoWtKIOel3RbvfYFidv9co7zVCBo+M
         epBLIFhz18MKZHbe/AkT7EolT4uUd87dJmEyRhFlELxkPc7yaJuB6STuunqxfcDowhRR
         IiG2gY9o42504mMhcWItGKe/Nds5eORySmqq9Xv4g9LJbRqokIgf3nDo7y29mBAAIFOu
         ypQA==
X-Gm-Message-State: APjAAAW9PMk1H3RSlP74OinjHxLlcoeNki+Z1boGqdh4myIoU5xpMpY6
        c+lrubpsBiEgdnq5O+cHdG7F9DS3N9M=
X-Google-Smtp-Source: APXvYqwV3mcuJnhnz6QQouw2JqDfmNZCuA8kTITJotydtLJak8JAyntXVQPkwnHos7Fs8wIPg2lpNg==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr20552772wml.126.1562657039819;
        Tue, 09 Jul 2019 00:23:59 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id v67sm2225652wme.24.2019.07.09.00.23.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 00:23:59 -0700 (PDT)
Date:   Tue, 9 Jul 2019 10:23:56 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     David Miller <davem@davemloft.net>
Cc:     Jose.Abreu@synopsys.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com, brouer@redhat.com,
        arnd@arndb.de
Subject: Re: [PATCH net-next v3 3/3] net: stmmac: Introducing support for
 Page Pool
Message-ID: <20190709072356.GA4599@apalos>
References: <BN8PR12MB32666359FABD7D7E55FE4761D3F50@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190705152453.GA24683@apalos>
 <BN8PR12MB32667BCA58B617432CACE677D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190708.141515.1767939731073284700.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708.141515.1767939731073284700.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, 

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Date: Mon, 8 Jul 2019 16:08:07 +0000
> 
> > From: Ilias Apalodimas <ilias.apalodimas@linaro.org> | Date: Fri, Jul 
> > 05, 2019 at 16:24:53
> > 
> >> Well ideally we'd like to get the change in before the merge window ourselves,
> >> since we dont want to remove->re-add the same function in stable kernels. If
> >> that doesn't go in i am fine fixing it in the next merge window i guess, since
> >> it offers substantial speedups
> > 
> > I think the series is marked as "Changes Requested" in patchwork. What's 
> > the status of this ?
> 
> That means I expect a respin based upon feedback or similar.  If Ilias and
> you agreed to put this series in as-is, my apologies and just resend the
> series with appropriate ACK and Review tags added.

The patch from Ivan did get merged, can you change the free call to
page_pool_destroy and re-spin? You can add my acked-by

Thanks
/Ilias
