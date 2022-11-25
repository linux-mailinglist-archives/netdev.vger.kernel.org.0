Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B603639270
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiKYXvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKYXvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:51:18 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8895E18E;
        Fri, 25 Nov 2022 15:51:17 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so8907494pjh.2;
        Fri, 25 Nov 2022 15:51:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBCy9qp7TSwSwGwI/krp6oqH0EI9xTeC+ExI/AlQHzg=;
        b=1OQZpXZ9Ed1f3U724rkw+MtCYUcdJtTOkQ3OJ37kYyDX/+ASIHd6vmK9sV2RyiKbDR
         ffkPd2ZaEPqioDrIqq60oCchjlF1lDAjF6VQHiegOBVIjzBfg9O5LIsr17MGXVrhfHJ1
         EpSV4AkvHA61ahLrikQ2SE8nCgoDrWzsdzSJlEvmLg0VS+Mfjt+DoY/n7vJxRMSDT0yY
         M+5bSNwfcAKFZcSNTjEgcGXAitcGRLhVqwn8PT38U/J8WQuqXeGpHSbYU7jTEST9os7J
         lhcWIDCR0gTByg9ebWcdcGzslqg1QCVb16SGCkSxfiJymBuUdmuTNnhxFpy5HCr5kqjH
         8B4w==
X-Gm-Message-State: ANoB5pmSedKMG6RkTCcAwZoIvPyhtzK5azH+FU+4AfjKzrZo/Eipmx+E
        RQuM+oZM4QaEN5RqE01/84Q=
X-Google-Smtp-Source: AA0mqf40CELg5Cd4cKADSnuQ7zDvszL+QjMGY2dYDbM8qR4FVWtlF2gM/wXRLECZg2wkT9gOazTizw==
X-Received: by 2002:a17:90a:b88c:b0:218:e1c1:b4f3 with SMTP id o12-20020a17090ab88c00b00218e1c1b4f3mr15351878pjr.201.1669420276891;
        Fri, 25 Nov 2022 15:51:16 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b001865c298588sm3937409plh.258.2022.11.25.15.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 15:51:15 -0800 (PST)
Message-ID: <d448b944-708a-32d4-37d7-0be16ee5f73c@acm.org>
Date:   Fri, 25 Nov 2022 15:51:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/5] driver core: make struct class.dev_uevent() take a
 const *
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
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
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/22 04:25, Greg Kroah-Hartman wrote:
> diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
> index 7dd1f01ec4f9..7aab4a769736 100644
> --- a/include/linux/mISDNif.h
> +++ b/include/linux/mISDNif.h
> @@ -586,7 +586,7 @@ extern struct mISDNclock *mISDN_register_clock(char *, int, clockctl_func_t *,
>   						void *);
>   extern void	mISDN_unregister_clock(struct mISDNclock *);
>   
> -static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
> +static inline struct mISDNdevice *dev_to_mISDN(const struct device *dev)
>   {
>   	if (dev)
>   		return dev_get_drvdata(dev);

Why does the dev_to_mISDN() function drop constness? I haven't found an 
explanation for this in the cover letter.

Thanks,

Bart.

