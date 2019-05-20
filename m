Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC02623C60
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392271AbfETPky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:40:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43342 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388939AbfETPkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:40:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id i26so16776174qtr.10
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 08:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8THvH1WQJtGVoUK6eqZtfhWJEkUnsc5JWCjWKhLHCHM=;
        b=iRtdO800nb71u7XH9vkSQBSmfW75oGi5o+6I3+Gc7Bq4kTPYxM3A5TtWP5uVSn3PCR
         PPAYjIBHWgN3fZVV1XCu4Hzegbwuwhw9DnxFqPIVl4ETEMKLRhAkvooeGX0vjOa/mxjU
         Y3Z7/l/xJdbTxg2f2Snt4qknt8iCLvAbAdaKewQzk7sdqzQy37w/ox2LY5NLgzTTLBiW
         l8ETiS2Xc/u/UTjzjqTGaMvcfNJwNBWIJVxXuJBSOkRgkL7V5vbLMrbyQJumoYsvWMYV
         DllKCqNKBjm20Zks5Twp8zKetSwFD63l5AASpkaq/ZddLA3t4Kk8GcBW0R77x7A9n7Fy
         tNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8THvH1WQJtGVoUK6eqZtfhWJEkUnsc5JWCjWKhLHCHM=;
        b=eHqLZmCnWUj7q4I2qylMvDW3dhnpHnjDOtHvd+5CvXl0j0bcDaYWQLK3UVHGbNeO2Y
         ovkvJS9LFt3zgWmoRFdN7m6TTlnB8hygag2on1H7OU/b4e0L7I9oXY8kqCdghQnZuWSe
         ohiGO3kdyCk0NN4LXNApcX4i8aw84/gfb1P2sf5QsTOzha62yapfy+w11/jNNKnAa3G+
         ryrcRn648x2yAzQkatlNAAhnZR3YbQZC9bzMZ3Q3DYzDXarHW49pMa4BOHNItkAUHIJN
         OCbWjJgSZcqEv7QEwB1gV4JeJOtyh5ryNyXrzo9Sggp4as4ZXWvjg4ezIP+cb4zyorAo
         EOOA==
X-Gm-Message-State: APjAAAXs8k+RUUf0zgJY+qthnuF18UNCRZjClOPau4UygVe3LuOUSuSG
        PmV+JyspyQ+8ByJq/MFipOJ4EA==
X-Google-Smtp-Source: APXvYqySN0Kq8+rwlU8QK019f9YHQZaFlKuXLku+Mu6CHtQe6/acd3cpy68C2D52smLScuuTB26gjw==
X-Received: by 2002:a0c:b64a:: with SMTP id q10mr6670572qvf.59.1558366852910;
        Mon, 20 May 2019 08:40:52 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id x126sm9035928qkd.34.2019.05.20.08.40.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:40:52 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <20190519002218.b6bcz224jkrof7c4@salvia>
 <7cdc59fd-e90f-6ff2-f429-257c8844be26@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <c9f578f4-4dc9-f640-d4ed-fce264e65adf@mojatatu.com>
Date:   Mon, 20 May 2019 11:40:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7cdc59fd-e90f-6ff2-f429-257c8844be26@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 11:37 a.m., Edward Cree wrote:
> On 19/05/2019 01:22, Pablo Neira Ayuso wrote:
>> On Fri, May 17, 2019 at 04:27:29PM +0100, Edward Cree wrote:

> Thanks.  Looking at net/netfilter/nfnetlink_acct.c, it looks as though you
>   don't have a u32 index in there; for the cookie approach, would the
>   address of the struct nf_acct (casted to unsigned long) work to uniquely
>   identify actions that should be shared?
> I'm not 100% sure how nf (or nfacct) offload is going to look, so I might
>   be barking up the wrong tree here.  But it seems like the cookie method
>   should work better for you — even if you did have an index, how would you
>   avoid collisions with TC actions using the same indices if both are in
>   use on a box?  Cookies OTOH are pointers, so guaranteed unique :)

A little concerned:
Hopefully all these can be manipulated by tc as well - otherwise we are
opening some other big pandora box of two subsystems fighting each
other.

cheers,
jamal
