Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBE5D92A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfGCAfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:35:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36050 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfGCAfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:35:47 -0400
Received: by mail-lj1-f195.google.com with SMTP id i21so473872ljj.3
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EFkIeXpXPtkmklqfCJHZIPWaUa8k7rvjDvZooschSt0=;
        b=rHd762UbGnahCLryJGa1V5ZeMAyD36SkyUs4X1frl2y0FBAOLBIKwlDdCGSIX+hgSg
         7z8NSWAyAhzTaBnGoD867ymuPf7oKh1xsQ3AO/qVbuZ7CZVSe6/bXtG02w+gL3hZiVdW
         wHvLUC7q04HYqiktxHNa/1RcLQlxu9ARjJL81i5JQ9fyu6LlDsMD5PscYhUzNUw/0o+1
         8dvpVT68hyVAf+bHgmM8erO+vZEYj1j4JcRjpSl8XTFwHKw1wZX2zGB4Herk/S4pQ9QB
         c7UwBmgkfh+TznGgYrX7ROflI9fKIZIVhDky8Gd3QvzLI9Ur+jRgi8QM+sw15pXkASv9
         Uz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=EFkIeXpXPtkmklqfCJHZIPWaUa8k7rvjDvZooschSt0=;
        b=RrlKiaK319pZIdhPhESs4CF2xGedGpC2iRakGQHyd+dqcUfzI2/Q1dP++NfYxXy5Ca
         YxUokUTZ6jJgklxXNpV24kCE4x2rEDrIgPfQ3u5uYTY7DmGn4bo72xF5OaHLE+MXLUTV
         iLS1SYnwu71PKY4SYEl85H3qXiCWBfYuN1ySE5w9maYWADO/Vo9ZDMTC+mgEjSoqg0RC
         C97mGsSzNM5BmNkY7Hk6yJlKK0/SKsREGg8vvSJ0gk83hzhWJd4aF7/AFHTQx/M7DBiD
         RTOR7m7OaVWVE8sLWEmhD5Je6b7BuIij+FwpePL24YXGPxcvN4dNi2zLYmjaiZxqoSy5
         8Yjw==
X-Gm-Message-State: APjAAAUcJllU3MEz2VDEzst0jaV0O9hb3ynfdpKzgOuC3zhcDijd/MS5
        Ka66uXfFnbqM5NMNh8vghlSzmw==
X-Google-Smtp-Source: APXvYqyK8XCk0LNPfZc7yl0eXnoTmmXKNuF5DgLOtCrcIhwHjVb42s/ttUXt6h2tWcidM5ZqBmX1tg==
X-Received: by 2002:a2e:80c8:: with SMTP id r8mr4089003ljg.168.1562103706177;
        Tue, 02 Jul 2019 14:41:46 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id h23sm40479ljg.17.2019.07.02.14.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 14:41:45 -0700 (PDT)
Date:   Wed, 3 Jul 2019 00:41:43 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
Message-ID: <20190702214142.GJ4510@khorivan>
Mail-Followup-To: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <156207778364.29180.5111562317930943530.stgit@firesoul>
 <20190702144426.GD4510@khorivan>
 <20190702165230.6caa36e3@carbon>
 <20190702145612.GF4510@khorivan>
 <20190702171029.76c60538@carbon>
 <20190702152112.GG4510@khorivan>
 <20190702202907.15fb30ce@carbon>
 <20190702185839.GH4510@khorivan>
 <20190702230241.3be6d787@carbon>
 <20190702211536.GA22618@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702211536.GA22618@apalos>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:15:36AM +0300, Ilias Apalodimas wrote:
>Hi Jesper,
>Getting late here, i'll respond in detail tomorrow. One point though
>
>[...]
>>
>> This special use-case, seems confined to your driver. And Ilias told me
>> that XDP is not really a performance benefit for this driver as the HW
>> PPS-limit is hit before the XDP and netstack limit.  I ask, does it
>> make sense to add XDP to this driver, if it complicates the code for
>> everybody else?
>I think yes. This is a widely used driver on TI embedded devices so having XDP
>to play along is a nice feature. It's also the first and only armv7 we have
>supporting this. Ivan already found a couple of issues due to the 32-bit
>architecture he is trying to fix, i think there's real benefit in having that,
>performance aside.
>I fully agree we should not impact the performance of the API to support a
>special hardware though. I'll have a look on the 2 solutions tomorrow, but the
>general approach on this one should be 'the simpler the better'
>
>Cheers
>/Ilias

BTW even w/o optimization it has close to 300kpps (but with increased number of
descs) on drop which is very close to netsec measurements Ilias sent. But from
what I know there is no h/w limit on cpsw at all that this CPU can serve, so
my assumption it's rather s/w limit. But that's not main here and XDP usage
has not been estimated enough yet in embedded, where hi speed not only benefit
that can be taken from XDP.

I need more clear circumstances to send v6 ...

-- 
Regards,
Ivan Khoronzhuk
