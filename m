Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8484E3FF2
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiCVOCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiCVOCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:02:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CF222BFA;
        Tue, 22 Mar 2022 07:01:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mz9-20020a17090b378900b001c657559290so2833606pjb.2;
        Tue, 22 Mar 2022 07:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ucF8X/ru747b6gOWvx4+oiyC4RRj7HH4AUsYaKe1X4o=;
        b=GBBWBYzqkyZsj+S/k4SV+0KuwR+q6Czyk7hnburccuH39DaIAQ7yneQ2b9wDVflyaf
         WtuPlTk9AB1mXxnXZ9bTdtLLTujkhzjyttG67jbBNM6xiRAfnk+msyBzIv9tD6uTqbzM
         Iq+cMr2489ixsubKRzOjpH669UxNg3xHrFh/5YWN4aq1OyPAtXqWuq08OpKgEckQCyo3
         wzChtD9UcqzkESrZ6HAeh2FEy8yRwEY5YJxMVTNEG3n8D3KpBzErnO+HD652evJJNyXd
         oW3+uB6uXnnBBw4Pxx4bz7kNagmNnDlv5B0nAMfEOpFzdp+yl2emagnH4Ya35cXVhrma
         h6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ucF8X/ru747b6gOWvx4+oiyC4RRj7HH4AUsYaKe1X4o=;
        b=U0/XrAuUE1W+514Y89dAW1pm5Tr76kx+625mzxUWMnicHM540r0z6WoQlKZRMmB/V+
         S+nWZWquAxJD+4rKVPafDHJbSFOiWZ6wtXX/4DINWZYVeAdeHL3EsNbJhTzI5bs2u/yE
         AGhkIWTlKlaD+Yx2ASfmAdHqFDl1EVDzbQ947xpIqI37hYD3GJU6rvS+B9HEi9DkwKhT
         u5ceRpjKzRCJWuAN6nuzQ+4apJO2Nrdb4PX7NfwcbW6nL4xLYO/JEC9srgZK/faqT23J
         2lqEFGtzMEQnnhAkMObQbVntTl7sF/dLEfZQ6zbuxsLPdl5Oihn7ykEr0c/Iw1Km33mr
         aQXw==
X-Gm-Message-State: AOAM531Jm+E5Wzt4Vz3GuRzyWBKq7mc4BUpev0UmVaoOItFw/pnCWz3w
        5Stc49HQkWiqdC9HqfYL7qc=
X-Google-Smtp-Source: ABdhPJzHhOFhZ4ulGYF5UmmBHf45uOml+/vin/wZl0DE+uYnWm+g0SxCfdYAUU6QQb3iITLIlzpVrQ==
X-Received: by 2002:a17:90a:af88:b0:1bd:6b5d:4251 with SMTP id w8-20020a17090aaf8800b001bd6b5d4251mr5284265pjq.134.1647957664527;
        Tue, 22 Mar 2022 07:01:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090adac100b001c67cedd84esm2956983pjx.42.2022.03.22.07.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 07:01:04 -0700 (PDT)
Message-ID: <55b5d052-7171-0da8-0dcd-38b107f52f52@gmail.com>
Date:   Tue, 22 Mar 2022 07:01:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v3 2/3] net: ipvlan: add net device refcount
 tracker
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Cc:     edumazet@google.com, brianvv@google.com,
        linux-kernel@vger.kernel.org
References: <cover.1647664114.git.william.xuanziyang@huawei.com>
 <185e45470629ad7a0aeef7a61b608d5cf13fcbf3.1647664114.git.william.xuanziyang@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <185e45470629ad7a0aeef7a61b608d5cf13fcbf3.1647664114.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/19/22 02:53, Ziyang Xuan wrote:
> Add net device refcount tracker to ipvlan.


Just squash this to prior patch.


Ideally all new dev_hold()/dev_put() should be

dev_hold_track() and dev_put_track()


> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>   drivers/net/ipvlan/ipvlan.h      | 1 +
>   drivers/net/ipvlan/ipvlan_main.c | 4 ++--
>   2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
> index 3837c897832e..6605199305b7 100644
> --- a/drivers/net/ipvlan/ipvlan.h
> +++ b/drivers/net/ipvlan/ipvlan.h
> @@ -64,6 +64,7 @@ struct ipvl_dev {
>   	struct list_head	pnode;
>   	struct ipvl_port	*port;
>   	struct net_device	*phy_dev;
> +	netdevice_tracker	dev_tracker;
>   	struct list_head	addrs;
>   	struct ipvl_pcpu_stats	__percpu *pcpu_stats;
>   	DECLARE_BITMAP(mac_filters, IPVLAN_MAC_FILTER_SIZE);
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index dcdc01403f22..be06f122092e 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -160,7 +160,7 @@ static int ipvlan_init(struct net_device *dev)
>   	port->count += 1;
>   
>   	/* Get ipvlan's reference to phy_dev */
> -	dev_hold(phy_dev);
> +	dev_hold_track(phy_dev, &ipvlan->dev_tracker, GFP_KERNEL);
>   
>   	return 0;
>   }
> @@ -674,7 +674,7 @@ static void ipvlan_dev_free(struct net_device *dev)
>   	struct ipvl_dev *ipvlan = netdev_priv(dev);
>   
>   	/* Get rid of the ipvlan's reference to phy_dev */
> -	dev_put(ipvlan->phy_dev);
> +	dev_put_track(ipvlan->phy_dev, &ipvlan->dev_tracker);
>   }
>   
>   void ipvlan_link_setup(struct net_device *dev)
