Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D1BDA28C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 02:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437719AbfJQACm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 20:02:42 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:34798 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbfJQACm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 20:02:42 -0400
Received: by mail-lj1-f169.google.com with SMTP id j19so572608lja.1
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 17:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IG9YROqsuweQxU4gZqYe/1Sj06Dsztauwp1SkspMgRI=;
        b=lTG1XGXANtCT1P8EMk2waxHM35+a2y3AZdswJDfk2P1hVUKMaYVcJ1R5Dwc5qWQaoz
         Dpiun+FzbVUOW083c40SudZkV/0G4mFxU20tjtn+Tc9JXwAfLGgfdBMY8vm4Yxru2fY0
         FqDaHcqYuTfuxABtSKBPpJqbLg65tFj7wMhBzZN/vb1gox4xCO7iN2wPxbZXQ+2iSnNa
         69YUJACl/TvAHLVU72sD8vmPKGJhLRApXXGZId8fUKErVKGHFKV7SVPIJcrD4dNw1bSq
         Yzn9mCrOan9Esdqzq80jujteDTO97aCmRnRLjJ+jJJGBvg6zqRE5Y/Iup9BqB4t5jjxs
         906Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IG9YROqsuweQxU4gZqYe/1Sj06Dsztauwp1SkspMgRI=;
        b=kgq7OszcWe6qyGzLDL7O0+OFb3Hg0GKsBolUfPZdK1/dof4OWVO+1VhmNAAWgwk5lW
         9ilxcnHK39yz2mT1D7hibVoyTeC3vkns0BX0o/1LMAb94b8uEb4OtsEwvmkGcnAO7X/n
         GMWAwGUwuODBf0JPHb6XRhKIklYuO3DCWqvv7PO9J7sirad4KtbDmJuBPDb3vUQOcWQu
         gznpX9aOSHPGaE7nr8upEsrfY6eSyD/dSOhffEiY7fs7egDqGWT9r8nEg02cmvnahPrj
         xaTNPcXznMgeizqQtyLiVbhjKMgki/+H6jZl6w2PNhxVdquzp69XpTwNwW4NwKkIqYi2
         o80A==
X-Gm-Message-State: APjAAAUajPvZuTbweWcuhw9brHbmH4+uLfWV6eh7rErRk0s1XpdvNxQy
        VlTs21Ho6vNH+P2sdKgpr//TQA==
X-Google-Smtp-Source: APXvYqxf3VOcUBAlrJEfTxCkWLjWNIZKaCITM6e329UTnEgXmcJIl4sBHDDaBifYAPeGjXuzbpftcg==
X-Received: by 2002:a2e:a0ca:: with SMTP id f10mr452962ljm.84.1571270558999;
        Wed, 16 Oct 2019 17:02:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i17sm166879lfj.35.2019.10.16.17.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 17:02:38 -0700 (PDT)
Date:   Wed, 16 Oct 2019 17:02:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Sasha Neftin <sasha.neftin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 4/7] e1000e: Add support for S0ix
Message-ID: <20191016170231.4ac6a021@cakuba.netronome.com>
In-Reply-To: <20191016234711.21823-5-jeffrey.t.kirsher@intel.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
        <20191016234711.21823-5-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 16:47:08 -0700, Jeff Kirsher wrote:
>  static int e1000e_pm_freeze(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
> @@ -6650,6 +6822,9 @@ static int e1000e_pm_thaw(struct device *dev)
>  static int e1000e_pm_suspend(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
> +	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	struct e1000_hw *hw = &adapter->hw;
>  	int rc;

reverse xmas tree?

>  
>  	e1000e_flush_lpic(pdev);
> @@ -6660,14 +6835,25 @@ static int e1000e_pm_suspend(struct device *dev)
>  	if (rc)
>  		e1000e_pm_thaw(dev);
>  
> +	/* Introduce S0ix implementation */
> +	if (hw->mac.type >= e1000_pch_cnp)
> +		e1000e_s0ix_entry_flow(adapter);

the entry/exit functions never fail, you can make them return void

>  	return rc;
>  }
>  
>  static int e1000e_pm_resume(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
> +	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	struct e1000_hw *hw = &adapter->hw;
>  	int rc;
>  
> +	/* Introduce S0ix implementation */
> +	if (hw->mac.type >= e1000_pch_cnp)
> +		e1000e_s0ix_exit_flow(adapter);
> +
>  	rc = __e1000_resume(pdev);
>  	if (rc)
>  		return rc;
