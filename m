Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0DADA465
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 05:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407159AbfJQDxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 23:53:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33680 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbfJQDxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 23:53:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so513609pgc.0;
        Wed, 16 Oct 2019 20:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZBBWbJU41twge5ff6QiBScfLS8wqzevnYznNbwsX7g=;
        b=uH1q2XflQa/MBVdb/ypOz+nDUI2H50mLz1A4rz0wfIKjfN4L8bP9VS63Se+gZd2CAN
         qoqY63dGMqLEIyQbXiM6vs8Pge5ZaesdYlRN4WgOmoy5sgkOtgJiBjgBMLkW7nYmKQP+
         CJB74pqmSl11Cj3IFSBHl4cmmiTfd2KVQEgI4HD2mySQP67gSQW+S/rpFkWdevnN2JDF
         b2dsZvk9EKKMqD55dBmqNTxT2/nJzFUZoIfe3vg91p/FXB8wxOcpbeVhZHjmJV82BBZU
         lgYLmzXei4PI0R1XyG7mR5zsk4dvskbrZBxU14d+ITFW/lYPwUmMBPpmrm7hrvriTASF
         tQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZBBWbJU41twge5ff6QiBScfLS8wqzevnYznNbwsX7g=;
        b=mjac9Z5TH2MHrA0WlcbRflz3tvKiySJlX/E1zEQ5zvmexdYnPTJMhy2vOn/DRx6SbY
         KDBLLVQFWdzTXpKm5lRyOtQ4bLSBfglBidHJx36h87B8qLJvB5kax4/YO06NZ9MUfKVW
         3oBFSOM7Dj/tN/J3EUtjpn0WFLVXchrUuhiwyQH4PF92MBrYUuiM0ANH+6jjz2t4MrF5
         FG+N87jjZbJP9fw4KT+FWJGbyLpTil4ww7QA+tAprjFKWjQEVRCpwDTx4xl2VJNUERi5
         LkWR0rJm7ZFmVFIhXvs9W43CPvbO3Kz6jY5ndaQejhaaH7qnqnB5w5mmWCIYtNB9D0VI
         +cJw==
X-Gm-Message-State: APjAAAWWnCM6h8cUY7d3KpnJfzUScaEasRbFngXx5jZb0RoaDLEFTAQF
        HaDoukDjspG168AhIun279kFzyO7
X-Google-Smtp-Source: APXvYqxrViIkThxofIHW3me2IL/WFq2bAKH/zEzSLk4/bo4IU+thWvMhcdnG6vYfqgs3rxFaMzoa9Q==
X-Received: by 2002:a63:eb47:: with SMTP id b7mr1689551pgk.179.1571284389032;
        Wed, 16 Oct 2019 20:53:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 30sm607564pgz.2.2019.10.16.20.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 20:53:08 -0700 (PDT)
Subject: Re: [PATCH net 2/4] net: phy: bcm7xxx: define soft_reset for 40nm
 EPHY
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jaedon.shin@gmail.com
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
 <1571267192-16720-3-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fd2f9e50-a6f3-bcbd-78a0-fb4abb3c4ef8@gmail.com>
Date:   Wed, 16 Oct 2019 20:53:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1571267192-16720-3-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/2019 4:06 PM, Doug Berger wrote:
> The internal 40nm EPHYs use a "Workaround for putting the PHY in
> IDDQ mode." These PHYs require a soft reset to restore functionality
> after they are powered back up.
> 
> This commit defines the soft_reset function to use genphy_soft_reset
> during phy_init_hw to accommodate this.
> 
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
