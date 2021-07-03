Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187B33BA798
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 08:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhGCGtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 02:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhGCGtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 02:49:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19319C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 23:46:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso7736532pjp.2
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 23:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lpOTqypZyxtIpHFRzx4qIPmrE1PnUqrG1SNhRQLuIOs=;
        b=NXO1PppLTgIRN/vXBnF9ON/SGdrjRVgvxOzMvl2gXa3cGJKF4ieiJ2ATtkGI6/Wetd
         x2wtRqb9mBiB/UG8DCKr9ejg4EjN/HauH3w5PWXO7meiQEkzTa4ZxKzGagdtb9HunVDF
         Kbd6Eu8Ch6kmnFtXtKu2FJ6S6ocSiNHhpKmRp3HjnJlO2f6JgSIvaKPS/nyXHBEsY271
         6CoPU1t6U+rwVJZCYjpF9Z0oKXfLUkt4hz9t7DwttTtIbC02ZqVTylAxJoY5b5lOrDsE
         XmwWLXYHT75XqzOMg0YZb21AzvII9hVKdLHA1njsF/gJzTLFIX/zuTVEPTVbnmPaRq0J
         8THQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lpOTqypZyxtIpHFRzx4qIPmrE1PnUqrG1SNhRQLuIOs=;
        b=GihYwMoI8pexzEdERPxndV9Aey8YkRZN/0NdeJDZq1OMDiChKYKQkDsBneaxxbqQWh
         hpLfurLXKSLvMFtiYX0Cry2JIPyKKu3dI5P3aAztn3BM6n0d/hu24v5S8N06fGMZYiYh
         S7+0m4vpEBFJTh8r99YHCk93AzVLjoyCzXyM2S3dZKlRRAKfHNwyQcL9MzfyDJKIyYKV
         bWfZ2u3yU+gH4gQVAwS3jfRiE+5o50iFpsq4Mru+XjXhd6N8JtDlaKv2W7lYJ3ijC8dT
         QBwSJFbCx87bUd/G9zHWKbd2797P3hsUZjcS79FXs0xA8alGbMNpzxoXPjslc4HMmlry
         t/1w==
X-Gm-Message-State: AOAM5301HVnAaKOga4knEAFkN8fk2Mz1I8g4EFO4vHkRF+toWFFftrQo
        e8sqVISJBaYgAZnv0fWJzPI=
X-Google-Smtp-Source: ABdhPJzvq7xn4q8Tjty232pOch0TdcjZ+0SGc5vlLRCkdG716EDHjVjS2DXjK0YL1OkgcH5ZMO9frg==
X-Received: by 2002:a17:90a:4417:: with SMTP id s23mr3324624pjg.228.1625294797568;
        Fri, 02 Jul 2021 23:46:37 -0700 (PDT)
Received: from [172.30.1.44] ([211.250.74.184])
        by smtp.gmail.com with ESMTPSA id 18sm14348043pje.22.2021.07.02.23.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 23:46:37 -0700 (PDT)
Subject: Re: [PATCH net 6/8] bonding: disallow setting nested bonding + ipsec
 offload
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
References: <20210702142648.7677-1-ap420073@gmail.com>
 <20210702142648.7677-7-ap420073@gmail.com> <14516.1625261184@famine>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <f6f99418-fc81-6ddb-2a44-1b3d02179730@gmail.com>
Date:   Sat, 3 Jul 2021 15:46:33 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <14516.1625261184@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/21 6:26 AM, Jay Vosburgh wrote:
 > Taehee Yoo <ap420073@gmail.com> wrote:
 >
 > [...]
 >> @@ -479,8 +481,9 @@ static bool bond_ipsec_offload_ok(struct sk_buff 
*skb, struct xfrm_state *xs)
 >> 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 >> 		return true;
 >
 > 	Not a question about this patch, but isn't the "return true"
 > above incorrect (i.e., should return false)?  I understand that the
 > ipsec offload is only available for active-backup mode, but the test
 > above will return true for all modes other than active-backup.
 >

I really agree with you.
I tried to test it but I couldn't because my NIC isn't working TX side 
ipsec offload(ixgbevf).
(dev->ndo_dev_offload_okf() is called in only tx side.)
So, I didn't include that change.

Thanks a lot,
Taehee

 > 	-J
 >
 >> -	if (!(slave_dev->xfrmdev_ops
 >> -	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
 >> +	if (!slave_dev->xfrmdev_ops ||
 >> +	    !slave_dev->xfrmdev_ops->xdo_dev_offload_ok ||
 >> +	    netif_is_bond_master(slave_dev)) {
 >> 		slave_warn(bond_dev, slave_dev, "%s: no slave 
xdo_dev_offload_ok\n", __func__);
 >> 		return false;
 >> 	}
 >> --
 >> 2.17.1
 >>
 >
 > ---
 > 	-Jay Vosburgh, jay.vosburgh@canonical.com
 >
