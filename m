Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821E32AFF5D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgKLFc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbgKLDO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 22:14:29 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B54C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 19:14:29 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id g7so3211592pfc.2
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 19:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6hzjSqwPX5IyPhYEkbyg/vCM05Kg+jqiwFrs36wweJA=;
        b=jcIhHHDHehZqZr7Pym5knu/EDbrakDuLiF80Hk6oT7X+Agts8DTXP5IAxx/JZYVY/s
         B7CFGT5z5ZCxedjAU98WTdiWlQNOVuIkNiFQKf21XCCEhz8Ul2qPTqGppYaS5M4L157w
         nay6otMHajjAAUDAnt8Ye63x5/M2q3UMLW2la8j/s8p7tmNGDO2Ryu1c2TruErh0QPjP
         Tsk616Jkupt1GgFs8GnumaOM7+CSKOx2Fjx0uKEXQHI1CIFFknfIB6RFl2mEXQ3R+n2s
         n0KIBehTpecPF0wYIKRFTOgRzTTSw23L0Wn/1AydyIgNvaZjZJ5Ku75d7aNaGmNZg0mH
         k8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6hzjSqwPX5IyPhYEkbyg/vCM05Kg+jqiwFrs36wweJA=;
        b=qWMXOVa1TB7XY2q0bdmag+Ub80og/41Um4DXZhQutSw4w0Jv+oJZnB3d8SL/A0NPJM
         6yZpG/FV5tu8qqbjeJlMcHMmR4tjsaqT/AHLnO9LtO1VDAAyC9uXT54CWH0m19tufkWG
         r/leN6JWQyzaWdsz9fmz4vGVLdVzN/+JcRX0flUkeeuiLfr7DKvjtcXFxx7xeMrCzLeS
         QNT4BAa8gp17Wvz0b6soq/Uw0YFmOvReruONra/SZRa6qJDCCqg4mbX0Q2P0XO/MSAJC
         35GoTm1mpoIu2nusiWcUu0fG61bjCFfjdLUAibumuw9IZWZoAJnNgoT0BUjBa3OLKhxM
         wMWQ==
X-Gm-Message-State: AOAM53293CP4ZKTy+itNC7xLpgmNh0xUxEV5K3zRcXyuPDWk7CxYxG9u
        Hxi/gmZhKC382OqeIZUlZOVS
X-Google-Smtp-Source: ABdhPJzAVKhCd3n92Ogg40iCuVUaFgNXUFnz7GLqX53Y2owJVVpBYlttY2x9aS0EcJMCV5s+uVokFw==
X-Received: by 2002:a62:5382:0:b029:155:6333:ce4f with SMTP id h124-20020a6253820000b02901556333ce4fmr25458528pfb.28.1605150868916;
        Wed, 11 Nov 2020 19:14:28 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:639b:9d11:cd64:b750:3a8a:63e7])
        by smtp.gmail.com with ESMTPSA id h5sm4667879pfk.126.2020.11.11.19.14.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Nov 2020 19:14:27 -0800 (PST)
Date:   Thu, 12 Nov 2020 08:44:15 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cjhuang@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
Message-ID: <20201112031415.GA2491@Mani-XPS-13-9360>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
 <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com>
 <20201109103946.4598e667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi88N8WjA7ZEU0X_dhX_t-kXkAjhnhjzK7TY7HCurrLSqA@mail.gmail.com>
 <20201110094427.5ffb1d1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110094427.5ffb1d1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 09:44:27AM -0800, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 10:03:29 +0100 Loic Poulain wrote:
> > On Mon, 9 Nov 2020 at 19:39, Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Mon, 9 Nov 2020 09:49:24 +0100 Loic Poulain wrote:  
> > > > > Looks like patch 1 is a bug fix and patches 2-5 add a new feature.
> > > > > Is that correct?  
> > > >
> > > > That's correct, though strictly speaking 2-5 are also bug fix since remote node
> > > > communication is supposed to be supported in QRTR to be compatible with
> > > > other implementations (downstream or private implementations).  
> > >
> > > Is there a spec we can quote to support that, or is QRTR purely
> > > a vendor interface?  
> > 
> > There is no public spec AFAIK, this is a vendor interface.
> > 
> > > What's the end user issue that we're solving? After firmware upgrade
> > > things stop working? Things don't work on HW platforms on which this
> > > was not tested? Don't work on new HW platforms?  
> > 
> > QRTR is usually something used in SoC context as communication
> > protocol for accessing the differents IPs (modem, WiFi, DSP, etc)
> > around the CPU. In that case, these components (nodes), identified
> > with a 'node ID', are directly reachable by the CPU (QRTR over shared
> > memory). This case is not impacted by the series, all nodes beeing CPU
> > immediate neighbours.
> > 
> > But today QRTR is no more a ARCH_QCOM thing only, It is also exposed
> > as communication channel for QCOM based wireless modules (e.g. SDX55
> > modem), over PCIe/MHI. In that case, the host is only connected to the
> > Modem CPU QRTR endpoint that in turn gives access to other embedded
> > Modem endpoints, acting as a gateway/bridge for accessing
> > non-immediate nodes from the host. currently, this case is not working
> > and the series fix it.
> > 
> > However, AFAIK, the only device would request this support is the
> > SDX55 PCIe module, that just landed in mhi-next. So I assume it's fine
> > if the related part of the series targets net-next.
> 
> Thanks! Sounds like net-next will work just fine, but won't you need
> these changes in mhi-next, then? In which case you should send a pull
> request based on Linus' tree so that both Mani and netdev can pull it
> in.
> 
> Mani, WDYT?

Sorry, missed this. mhi-next doesn't need these changes and since you've
applied to net-next, everything is fine!

I still need to apply the MHI patch which got applied to net-next and
provide an immutable branch to Kalle for another set of MHI patches...

Thanks,
Mani

