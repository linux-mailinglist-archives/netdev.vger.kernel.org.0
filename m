Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B42128EC3A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgJOE0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOE0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:26:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60824C061755;
        Wed, 14 Oct 2020 21:26:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so1216625pfk.2;
        Wed, 14 Oct 2020 21:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KmLWiTcOmmjLTrrn22jVJ7/COvI0q5pT3DXtKHVvFIE=;
        b=ijgJr+7FId4/CSIH0DhfVqvliBZfLgMpxavEJhtmQyKe9XhvGbVbvKBvUQYqiJMn7m
         qm+7+49Dxk4/H93QEbq8xiavqCI+D69P58TdgaO5nTnymMNpfJLXpADSOtLDHNEyP6yo
         XW86eNoxcWAyIKXjxAkKXuoElVXnLZw0bHTWLtU8N4el9qiyzZipm5DJH6+HNG8nuYYL
         Tl/46pz7XAdDDIeyDvVCa5XHrClmKjCuZ2GtrB8wvqiHaOh64Lx+mbVq03v2EJzxLeuG
         5f2okgLxmC7/FfB4KQyg0jceESNdLFqg2GE8BmsGC5GX97UdYE2ce5iFso207Tl8BU5N
         zaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KmLWiTcOmmjLTrrn22jVJ7/COvI0q5pT3DXtKHVvFIE=;
        b=F9RZll/Vy1LME86mOWKVuRHWzmzM3kshBmaX1bDpH+7ZtOe/RVhqgeueCT2y4dAywj
         gIfbtxEXWhI1BTBEd9w4C7OOXuxhcFO04lvjoEidb9MX7ICWyvzuIIcTr/SPsakFjHHF
         Zh18TkBA8QNBadBe9Spm949V5H0RokvquDw8UPuQ8PMtc+5t54bU9I8gkoPM5FIfyl2T
         qonhVUxspkLHYx2utrJxWhL34DHfu9bPEMpq7jUfaQauDCSgqcgNu2X/y3ryRDOaq7X+
         uUEcVDc15dJTuNVYMBZ+d6HEqO6jcVuY2RCEzZeJCtUq0LBYHnP6tcL08RKsnkY3c3ia
         EiYA==
X-Gm-Message-State: AOAM531WjU7HQrskBckzWFbrTbOzcdT63JUxjGZWZowm+x5RqUrSnB4N
        kdOu5TPQyhv9I1q29N0ixfw=
X-Google-Smtp-Source: ABdhPJzQF0FlImqo4paPN4ynz906WpQe7uA64b1AAfdEzPEr6qnDf5YDXl1m1JHv91i5TplUdvqpLA==
X-Received: by 2002:a63:df42:: with SMTP id h2mr1927869pgj.239.1602736008980;
        Wed, 14 Oct 2020 21:26:48 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id g14sm1346060pfo.17.2020.10.14.21.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:26:48 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 15 Oct 2020 12:22:08 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] staging: qlge: Initialize devlink health dump
 framework
Message-ID: <20201015042208.otne7sizy2bj2on6@Rk>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-3-coiby.xu@gmail.com>
 <20201014130846.GU1042@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201014130846.GU1042@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 04:08:46PM +0300, Dan Carpenter wrote:
>On Wed, Oct 14, 2020 at 06:43:01PM +0800, Coiby Xu wrote:
>>  static int qlge_probe(struct pci_dev *pdev,
>>  		      const struct pci_device_id *pci_entry)
>>  {
>>  	struct net_device *ndev = NULL;
>>  	struct qlge_adapter *qdev = NULL;
>> +	struct devlink *devlink;
>>  	static int cards_found;
>>  	int err = 0;
>>
>> -	ndev = alloc_etherdev_mq(sizeof(struct qlge_adapter),
>> +	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_adapter));
>> +	if (!devlink)
>> +		return -ENOMEM;
>> +
>> +	qdev = devlink_priv(devlink);
>> +
>> +	ndev = alloc_etherdev_mq(sizeof(struct qlge_netdev_priv),
>>  				 min(MAX_CPUS,
>>  				     netif_get_num_default_rss_queues()));
>>  	if (!ndev)
>> -		return -ENOMEM;
>> +		goto devlink_free;
>>
>> -	err = qlge_init_device(pdev, ndev, cards_found);
>> -	if (err < 0) {
>> -		free_netdev(ndev);
>> -		return err;
>
>In the old code, if qlge_init_device() fails then it frees "ndev".
>
>> -	}
>> +	qdev->ndev = ndev;
>> +	err = qlge_init_device(pdev, qdev, cards_found);
>> +	if (err < 0)
>> +		goto devlink_free;
>
>But the patch introduces a new resource leak.

Thank you for spotting this issue!

>
>>
>> -	qdev = netdev_priv(ndev);
>>  	SET_NETDEV_DEV(ndev, &pdev->dev);
>>  	ndev->hw_features = NETIF_F_SG |
>>  		NETIF_F_IP_CSUM |
>> @@ -4611,8 +4619,14 @@ static int qlge_probe(struct pci_dev *pdev,
>>  		qlge_release_all(pdev);
>>  		pci_disable_device(pdev);
>>  		free_netdev(ndev);
>> -		return err;
>> +		goto devlink_free;
>>  	}
>> +
>> +	err = devlink_register(devlink, &pdev->dev);
>> +	if (err)
>> +		goto devlink_free;
>> +
>> +	qlge_health_create_reporters(qdev);
>>  	/* Start up the timer to trigger EEH if
>>  	 * the bus goes dead
>>  	 */
>> @@ -4623,6 +4637,10 @@ static int qlge_probe(struct pci_dev *pdev,
>>  	atomic_set(&qdev->lb_count, 0);
>>  	cards_found++;
>>  	return 0;
>> +
>> +devlink_free:
>> +	devlink_free(devlink);
>> +	return err;
>>  }
>
>The best way to write error handling code is keep tracke of the most
>recent allocation which was allocated successfully.
>
>	one = alloc();
>	if (!one)
>		return -ENOMEM;  //  <-- nothing allocated successfully
>
>	two = alloc();
>	if (!two) {
>		ret = -ENOMEM;
>		goto free_one; // <-- one was allocated successfully
>                               // Notice that the label name says what
>			       // the goto does.
>	}
>
>	three = alloc();
>	if (!three) {
>		ret = -ENOMEM;
>		goto free_two; // <-- two allocated, two freed.
>	}
>
>	...
>
>	return 0;
>
>free_two:
>	free(two);
>free_one:
>	free(one);
>
>	return ret;
>
Thank you for teaching me this pattern!

>In the old code qlge_probe() freed things before returning, and that's
>fine if there is only two allocations in the function but when there are
>three or more allocations, then use gotos to unwind.
>
>Ideally there would be a ql_deinit_device() function to mirror the
>ql_init_device() function.  The ql_init_device() is staging quality
>code with leaks and bad label names.  It should be re-written to free
>things one step at a time instead of calling ql_release_all().
>
I'll see how I can improve ql_init_device. Thank you for the suggestion!

>Anyway, let's not introduce new leaks at least.
>
>regards,
>dan carpenter

--
Best regards,
Coiby
