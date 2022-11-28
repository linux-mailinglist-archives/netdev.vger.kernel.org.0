Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B931E639F82
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 03:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiK1Cir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 21:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK1Cip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 21:38:45 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68C3A1B1;
        Sun, 27 Nov 2022 18:38:44 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id s196so8734766pgs.3;
        Sun, 27 Nov 2022 18:38:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1kG9z2qzxuFG+VRjNYAaaunJxmRkVIHKxHuUo9QjcyE=;
        b=xpq/ddy9z30TTL8jOYYx+QH71jompOnAITlXG+/Q1SiCODz5cYlaf0vjWFE3f52vzr
         GNw2vsAdcRB1jcqVSY4MynR3K4RQC/qab86MHxqkjpf3O+MEi5RwS2oeepxt2mh8z1ks
         fdqFtgnoMBOu/QS+Ns8Ubtev3NmPGrlAklOmb/1Vr4lIT2UgGvYY3UFeIoIBuZ5gnug2
         VWDAEZn/tPz+Anpr5vpw82wIqmBk7fYCidUVF1iMPh+Kmgmfr+Edx8IKulMIqborvP29
         sFKWqMP3EYOcj5T+vQ4Vzx/KLwGzSL6O/qihDYlmy1obapyz6JY9h00JJHczDJ3ZLwWb
         jxvg==
X-Gm-Message-State: ANoB5pkdOvMNP2ETKz5fRr4ZM1ZIuWMlFE/Vh+llRsp5BAReHGwXftCV
        iMqCyh/pUNi8vV9n5bbxd7o=
X-Google-Smtp-Source: AA0mqf5vmCbco6ZHPjAXXxhwtD8PwFo1rRkGl5sk/L6YEIBylIo5gFL0rkxaBBXNXZfCI6rD4vcBjA==
X-Received: by 2002:a63:388:0:b0:477:c828:dd2d with SMTP id 130-20020a630388000000b00477c828dd2dmr18012978pgd.105.1669603124285;
        Sun, 27 Nov 2022 18:38:44 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j8-20020a170902da8800b00176ea6ce0efsm7507123plx.109.2022.11.27.18.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 18:38:43 -0800 (PST)
Message-ID: <5b14cdea-1bbe-1900-0004-a218ba97bbcb@acm.org>
Date:   Sun, 27 Nov 2022 18:38:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/5] driver core: make struct class.dev_uevent() take a
 const *
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Raed Salem <raeds@nvidia.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Avihai Horon <avihaih@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Ian King <colin.i.king@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Wang Yufen <wangyufen@huawei.com>, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
 <d448b944-708a-32d4-37d7-0be16ee5f73c@acm.org> <Y4NqAJW5V0tAP8ax@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y4NqAJW5V0tAP8ax@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/22 05:45, Greg Kroah-Hartman wrote:
> On Fri, Nov 25, 2022 at 03:51:11PM -0800, Bart Van Assche wrote:
>> On 11/23/22 04:25, Greg Kroah-Hartman wrote:
>>> diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
>>> index 7dd1f01ec4f9..7aab4a769736 100644
>>> --- a/include/linux/mISDNif.h
>>> +++ b/include/linux/mISDNif.h
>>> @@ -586,7 +586,7 @@ extern struct mISDNclock *mISDN_register_clock(char *, int, clockctl_func_t *,
>>>    						void *);
>>>    extern void	mISDN_unregister_clock(struct mISDNclock *);
>>> -static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
>>> +static inline struct mISDNdevice *dev_to_mISDN(const struct device *dev)
>>>    {
>>>    	if (dev)
>>>    		return dev_get_drvdata(dev);
>>
>> Why does the dev_to_mISDN() function drop constness? I haven't found an
>> explanation for this in the cover letter.
> 
> I agree, this is going to be fixed up, see the thread starting here:
> 	https://lore.kernel.org/r/Y34+V2bCDdqujBDk@kroah.com
> 
> I'll work on making a const / non const version for these so that we
> don't loose the marking.
> 
> Oh wait, no, this function is fine, it's not modifying the device
> structure at all, and only returning the pointer in the private data
> stored in the device.  There is no loss of const-ness here.

Hi Greg,

This is what I found in include/linux/mISDNif.h:

struct mISDNdevice {
	struct mISDNchannel	D;
	u_int			id;
	u_int			Dprotocols;
	u_int			Bprotocols;
	u_int			nrbchan;
	u_char			channelmap[MISDN_CHMAP_SIZE];
	struct list_head	bchannels;
	struct mISDNchannel	*teimgr;
	struct device		dev;
};

As one can see 'dev' is a member of struct mISDNdevice. I still think 
that dev_to_mISDN() drops constness. Did I perhaps overlook something?

Bart.
