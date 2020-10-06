Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014F028471D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgJFH2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFH2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 03:28:51 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD37DC061755;
        Tue,  6 Oct 2020 00:28:50 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f21so1820278wml.3;
        Tue, 06 Oct 2020 00:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=enqWQqsF33LtsfWeCNvWbYWRWQx76ClgLc90oOHzcJM=;
        b=jDIf+N4IwGdO9Q1V0aV1aUob+nFT5zcTvwWPaKdu+pzfKKM0lJsQJoQg8mMp+b4gsv
         WXDHZN+8d7iOkjm2aq+HzoKdRtHEjjXIauwAXmbkQBh7jauqkO2ZPKfH8OHqu5psUAmG
         D9DxG+q67R1PC+peQl6fICoqPTA1wfgC+QDWOLRlt57AIgFlDnFjgWshTMpV+gkf/Lfx
         hnMkkLSRKpv4S+gN5hoPcDxmmq4Ijp4ISGn0XzYnc7Zb3ckTQFrAVvMDP2T6nk5YrwpZ
         W/IZJ8f4mn7stPldZb7+bml7QsApeT/T4Y8ybTwpxWOiYqDShAxTpcLnpgSVKSDzoiVv
         WYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=enqWQqsF33LtsfWeCNvWbYWRWQx76ClgLc90oOHzcJM=;
        b=KhK7/Da7Dc5Zk59hIhbrieDGqC7P8OnLXer1pbBto4PhqSdzS1SkDsBJ1vS1l63IbA
         irN1u6JqpIYCL9/atqUuS8/Qg3bwpSr3QJZjl3d6/2xcz/K1JMyvwszzyK3O63gRu16V
         FHH4AD0e9IvlUXYgCzzI9YKc/IUV/KYaD1lWYgke5DPooWK1XBFsCEITA6/VmqmaE6Cx
         3DrSZmHZpM2ndvbcwZvHmn/8tOBTp4mQCadovUQs1m1zrTfNEPf7N//jXnl7xEZT11vq
         I8pbaTd6B4+Sekv785pSJ4vyEec+gygqDZ8ySdxaMn0ouH5JQgMOt5gGYjI+2CxXPD7o
         nfrA==
X-Gm-Message-State: AOAM53260XHYEa0TE+WKzB05qC6298Nxxh3E8BopRhDOD+YRVJWjaOWt
        FbGJvPm0VNnTekhjxKkA+4k=
X-Google-Smtp-Source: ABdhPJzlTlZ3jhRE8xHZ6JltR5CMqC5OKSdJSSAXMDYRtxhMR10SHhd/H7lVoVjJ4upUTaN1NA32GA==
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr3371874wmg.72.1601969329322;
        Tue, 06 Oct 2020 00:28:49 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id d9sm2474127wmb.30.2020.10.06.00.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 00:28:48 -0700 (PDT)
Date:   Tue, 6 Oct 2020 10:28:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201006072847.pjygwwtgq72ghsiq@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-5-kurt@linutronix.de>
 <20201004143000.blb3uxq3kwr6zp3z@skbuf>
 <87imbn98dd.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imbn98dd.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 08:27:42AM +0200, Kurt Kanzenbach wrote:
> On Sun Oct 04 2020, Vladimir Oltean wrote:
> > On Sun, Oct 04, 2020 at 01:29:08PM +0200, Kurt Kanzenbach wrote:
> >> +/* Enabling/disabling TX and RX HW timestamping for different PTP messages is
> >> + * not available in the switch. Thus, this function only serves as a check if
> >> + * the user requested what is actually available or not
> >> + */
> >
> > Correct me if I'm wrong, but to the user it makes zero difference
> > whether the hardware takes timestamps or not.
> 
> Why not? I think it makes a difference to the user b/o the precision.
> 
> > What matters is whether the skb will be delivered to the stack with a
> > hardware timestamp or not, so you should definitely accept a
> > hwtstamp_config with TX and RX timestamping disabled.
> >
> 
> Sorry, I cannot follow you here.

What I meant to say is that there is no reason you should refuse the
disabling of hardware timestamping. Even if that operation does not
really prevent the hardware from taking the timestamps, you simply
ignore the timestamps in the driver.
