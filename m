Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF0735D0B1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhDLTA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhDLTAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:00:55 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30488C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:00:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x4so16405556edd.2
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FS6obb1fYd9y5VnDyMOJpgbMLP2kVn1KDTuzOjvcJrk=;
        b=TlGqowRNy7dFJojrXMmvYPxoRQtILtMNcSLKXcpNPqNNn9Vx6zuzC2eFnbAU9b61iD
         PRhd6k4bLrlmP0ydsKsOLCRBwhpduuNhuh9BkaOK7NGgaDyaKEuDhLIsDaAFjpaO9NMs
         mjhK4s3WS4e7nVWE62R/yoJvqSxj+x2DYOPC/Rp3UH6DqVwjPyNKg6MbJhLpivHn8wth
         jUG6DEhhtgCSojtd7znrN0HW8saCyeQJ3wql/yCl9IxxdZQiom09ZXxWBYLTt2hazwvw
         4JaPga72P8qKqME6MERlVsGJZGYQpZYBsCZPXeouoqrNqIX3BAmfF2iHfVS3p/JQrVc0
         5+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FS6obb1fYd9y5VnDyMOJpgbMLP2kVn1KDTuzOjvcJrk=;
        b=nIA82fizxUvzMUHzzkmnGWRWWeC/pumxXfwaPokEZgUMA5ZEgMqKYsbznDVjIfStAQ
         f/4scx7Z/aVMQ385pKiFGIIAqNhg2PVrf8eLhVb4vK5CJbttwl30aR61KGntARVfR4y4
         o/+UsMOJF83lHrgG0cU43KzO+OE4rX3tpAybMGaYu0cGqRQpYrIY3OWc1v36rNGjRBjp
         d9cFRHE7y/k+zawoPI57x1ecrnkrAg21qI61VXl6lDw2amV47n64sAO7+6kvPpn/nqqF
         aFPtB1fljX2RRKMgiV8LaiC6cHf7RHm3i5taoMZBCFVN0hHMzA4R3q+XBnPWcTjo7+V/
         LgTQ==
X-Gm-Message-State: AOAM533f9DYPGEcyRMng8KQu5UWY8mu+1kxPA9fglSHD5R5Wij399mNZ
        +hlmv7Hrrf17+xjEDNcshXU=
X-Google-Smtp-Source: ABdhPJx2XIh//ktM/Es2KVgOQ8iVm7DSd67sbQsWKuuG8xOiq5h4c9qwwMjsh1DopIYCqzMQ+XvwXg==
X-Received: by 2002:a05:6402:35c8:: with SMTP id z8mr30645564edc.341.1618254035240;
        Mon, 12 Apr 2021 12:00:35 -0700 (PDT)
Received: from [192.168.0.129] ([82.137.32.50])
        by smtp.gmail.com with ESMTPSA id d10sm7461353edp.77.2021.04.12.12.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:00:34 -0700 (PDT)
Subject: Re: [net-next, v3, 2/2] enetc: support PTP Sync packet one-step
 timestamping
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
References: <20210412090327.22330-1-yangbo.lu@nxp.com>
 <20210412090327.22330-3-yangbo.lu@nxp.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <d53dba3a-3241-b424-5f86-2d032a33e06d@gmail.com>
Date:   Mon, 12 Apr 2021 22:00:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210412090327.22330-3-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2021 12:03, Yangbo Lu wrote:
> This patch is to add support for PTP Sync packet one-step timestamping.
> Since ENETC single-step register has to be configured dynamically per
> packet for correctionField offeset and UDP checksum update, current
> one-step timestamping packet has to be sent only when the last one
> completes transmitting on hardware. So, on the TX, this patch handles
> one-step timestamping packet as below:
> 
> - Trasmit packet immediately if no other one in transfer, or queue to
>    skb queue if there is already one in transfer.
>    The test_and_set_bit_lock() is used here to lock and check state.
> - Start a work when complete transfer on hardware, to release the bit
>    lock and to send one skb in skb queue if has.
> 
> And the configuration for one-step timestamping on ENETC before
> transmitting is,
> 
> - Set one-step timestamping flag in extension BD.
> - Write 30 bits current timestamp in tstamp field of extension BD.
> - Update PTP Sync packet originTimestamp field with current timestamp.
> - Configure single-step register for correctionField offeset and UDP
>    checksum update.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
[...]
> +	/* Queue one-step Sync packet if already locked */
> +	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
> +		if (test_and_set_bit_lock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS,
> +					  &priv->flags)) {
fyi, I had to check with objdump that test_and_set_bit_lock translates 
to a atomic bit set operation on ARM64, it's LDSETA. I'd appreciate any 
pointers on how to look it up in the arm64 arch code.

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
