Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B693B3B8AFC
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 01:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbhF3XiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 19:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbhF3XiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 19:38:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A890C061756;
        Wed, 30 Jun 2021 16:35:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso2647878pjp.2;
        Wed, 30 Jun 2021 16:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=votCsR8QuC+BJJYuIxcHQ0x9+KTlBJzpPzzO+5vNEZg=;
        b=kfeG4KUCtbuMI2RLmqJGZDydOwhKjll5sSqDv3t1Ce6JcNf9RLaOIuKVtkOnCB2Y2c
         yu3rc2f5OdkS9JTpEqH3ugYrL08zUg1ror7qjfOx0GGSIS528YW+G9sBmRnk+GI322cH
         hjSDM7pv+6fLN9vG7LOTSm6ML0PEPig0qL9deap2vU9xycDcCOC0eZpiZmrcpM5BLgn+
         A3SAxIMc5rEmnVQWTAR/sl3XoQIE6mThQumrqycQ5KH7RiOQmcg+ECuuvImSLxwQ8noz
         hMjx+40qlk6kKJeXvsylwDc83ltplzEF2CIuklhodVwDKzUrLlQhg+xizoUg4qDxJgP8
         zLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=votCsR8QuC+BJJYuIxcHQ0x9+KTlBJzpPzzO+5vNEZg=;
        b=pjxJMcpVRGYIaJ5ThK5NhyeKh3MsW1hlh0w3CelJrn8dwlvhukFKDsNLdvRwxqHIgX
         /5lMCMOM74yW0//FL0RkpH9Jgz7UHtea/6joY8CIRSTI0n2g84SlpkCoBvj+rAeLu48o
         2HCDyQKGq85dbG1kBkZiCurQ1QxUMqBu/5FCfbYzP+ThizTygpDKzGSsxlxQrwCYFduz
         eMU7cOeyrCihngyZfjVSyqCUNFqcR5zn0O3kLj9ERpThdsC+hGYdNfDxdL6hg1CilJWS
         th0iBIgV76wCVzIgjY1kCmxR6Uho596pLO2TrBbU/Qr/oHJjNnIfBYFqk9g8tbzSu+mC
         7Adg==
X-Gm-Message-State: AOAM531BfRDGZ5cRcaz7Pjd1KeuFTA/YmX4qRhf8ObD3QVmJgd6RMte0
        f4IZI/qX4mjTfs5LCA4bEVE=
X-Google-Smtp-Source: ABdhPJzd5JEwCoPqJU17RS0Lrgrkyu2E4sKAT1naAE8xJJf2bR4D/5IEkWgkAJ+hOiFB1KUAnrYq/w==
X-Received: by 2002:a17:90a:fa97:: with SMTP id cu23mr1645386pjb.126.1625096131882;
        Wed, 30 Jun 2021 16:35:31 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id i13sm8202807pgm.26.2021.06.30.16.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 16:35:31 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 1 Jul 2021 07:33:38 +0800
To:     Joe Perches <joe@perches.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 13/19] staging: qlge: rewrite do while loop as for loop in
 qlge_sem_spinlock
Message-ID: <20210630233338.2l34shhrm3bdd4gx@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-14-coiby.xu@gmail.com>
 <20210622072036.GK1861@kadam>
 <20210624112245.zgvkcxyu7hzrzc23@Rk>
 <f7beb9aee00a1cdb8dd97a49a36abd60d58279f2.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7beb9aee00a1cdb8dd97a49a36abd60d58279f2.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 03:58:06AM -0700, Joe Perches wrote:
>On Thu, 2021-06-24 at 19:22 +0800, Coiby Xu wrote:
>> On Tue, Jun 22, 2021 at 10:20:36AM +0300, Dan Carpenter wrote:
>> > On Mon, Jun 21, 2021 at 09:48:56PM +0800, Coiby Xu wrote:
>> > > Since wait_count=30 > 0, the for loop is equivalent to do while
>> > > loop. This commit also replaces 100 with UDELAY_DELAY.
>[]
>> > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
>[]
>> > > @@ -140,12 +140,13 @@ static int qlge_sem_trylock(struct qlge_adapter *qdev, u32 sem_mask)
>> > >  int qlge_sem_spinlock(struct qlge_adapter *qdev, u32 sem_mask)
>> > >  {
>> > >  	unsigned int wait_count = 30;
>> > > +	int count;
>> > >
>> > > -	do {
>> > > +	for (count = 0; count < wait_count; count++) {
>> > >  		if (!qlge_sem_trylock(qdev, sem_mask))
>> > >  			return 0;
>> > > -		udelay(100);
>> > > -	} while (--wait_count);
>> > > +		udelay(UDELAY_DELAY);
>> >
>> > This is an interesting way to silence the checkpatch udelay warning.  ;)
>>
>> I didn't know this could silence the warning :)
>
>It also seems odd to have unsigned int wait_count and int count.
>
>Maybe just use 30 in the loop without using wait_count at all.

Thanks for the suggestion. I will apply it to v1.
>
>I also think using UDELAY_DELAY is silly and essentially misleading
>as it's also used as an argument value for mdelay
>
>$ git grep -w UDELAY_DELAY
>drivers/staging/qlge/qlge.h:#define UDELAY_DELAY 100
>drivers/staging/qlge/qlge_main.c:               udelay(UDELAY_DELAY);
>drivers/staging/qlge/qlge_main.c:               udelay(UDELAY_DELAY);
>drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY);
>drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY);
>drivers/staging/qlge/qlge_mpi.c:                mdelay(UDELAY_DELAY); /* 100ms */

Thanks for spotting this issue! How about "#define MDELAY_DELAY 100" for
mdelay?

>
>

-- 
Best regards,
Coiby
