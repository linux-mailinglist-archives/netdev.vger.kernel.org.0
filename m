Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EEE4C6450
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 09:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiB1IG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 03:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiB1IGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 03:06:55 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ACC53E1C;
        Mon, 28 Feb 2022 00:06:17 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso14102534pjk.1;
        Mon, 28 Feb 2022 00:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p/2fgVuZqh8XuIo59HcuS/AvNnvELf2at/rDeF9p7Xw=;
        b=pC6jDKAtOsFH++jIFFGJLd3evif6wCsTWkslH47SRfgwGrXja7Sze7tl7zFb65LPBq
         2Og1Wendwtos4c1YtSC1pObv6cyRcJwxXEbWSOuKa6Hq75Y+Y3+LaY16LnJ6OmfafZE4
         nsJgTUKgbkEQu0RgoBfIPAHKXAnJEMokM8PWhIyS4ov9Vx+JZPiLjL8KQWgI/NRXnbyU
         l+8onewRLWGEqkZ3endhWyeZYTE7kKyZTQiS6dANRvilbDMNylEh+Zdoo5uNo7qMD2u5
         vI6byOsHIcAAYNX87rZr8LWUvfClmHlAzXyQivt3UvF6WSu82INJR6D1isLKuek7E8i0
         BJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p/2fgVuZqh8XuIo59HcuS/AvNnvELf2at/rDeF9p7Xw=;
        b=lmkiwGkkD2Q+GrUsqKJ+SODBEpri207pU5QatunxUfyUu1RvzqG9RjIqgHI39/SHtQ
         Smg1S+t8Bq8k+UDs4NKGJTpvuDGfymdjXM02AEX0ld2xzhstb7eeU7zxqKslUhEoF8Fg
         2OTtUJ8aLe2/jhuxgo5mnVJd+Fpgzn8yM/U3TENuzWxt3w/XYiZW7y6DHz8KSGmo6DWf
         WfvWQ9zgZZ/qWbbJIvEZyno63CupWzxYdaYbrH9WlDmgQSgDkvRWRmNxsC6SVJ/2UDPN
         VsMaGXdC3tVxZnWnQRuYsnrhYodO3TCSGsQxoxHJwTKkEymhYLCoQN/Omff5DZqVfidY
         Qh5g==
X-Gm-Message-State: AOAM531WGmVw07IjCyt5qG6ivyukXqlCh13xSvRkBmExINQWCoFZzi2L
        AO8B18QwhH98UEd8csyYQMg=
X-Google-Smtp-Source: ABdhPJxHlyaMS9+qTY94J/VeLcfDgHDVjwNg69Gt/XHy3gzWJlkAtRxiaeYuNdeJ1kZs3C/DF1qMiQ==
X-Received: by 2002:a17:902:904a:b0:149:b6f1:3c8b with SMTP id w10-20020a170902904a00b00149b6f13c8bmr19550635plz.83.1646035576732;
        Mon, 28 Feb 2022 00:06:16 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id pj12-20020a17090b4f4c00b001bc97c5b255sm10019364pjb.44.2022.02.28.00.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 00:06:16 -0800 (PST)
Message-ID: <340590e9-2150-cd6e-5333-21c4fde59e98@gmail.com>
Date:   Mon, 28 Feb 2022 16:06:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: usb: fix a possible memory leak in
 esd_usb2_start_xmit
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, thunder.leizhen@huawei.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220225060019.21220-1-hbh25y@gmail.com>
 <20220225155621.7zmfukra63qcxjo5@pengutronix.de>
 <69b0dd44-93ac-fa33-f9c1-6f787185ab47@gmail.com>
 <20220228075146.hvui3iow7niupij4@pengutronix.de>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220228075146.hvui3iow7niupij4@pengutronix.de>
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

Yes. I will create a patch later.

Thanks.

On 2022/2/28 15:51, Marc Kleine-Budde wrote:
> On 28.02.2022 10:05:03, Hangyu Hua wrote:
>> I get it. But this means ems_usb_start_xmit have a redundant
>> dev_kfree_skb beacause can_put_echo_skb delete original skb and
>> can_free_echo_skb delete the cloned skb. While this code is harmless
>> do you think we need to delete it ?
> 
> ACK. This dev_kfree_skb() should be deleted:
> 
> | 	err = usb_submit_urb(urb, GFP_ATOMIC);
> | 	if (unlikely(err)) {
> | 		can_free_echo_skb(netdev, context->echo_index, NULL);
> |
> | 		usb_unanchor_urb(urb);
> | 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
> | 		dev_kfree_skb(skb);
> 
> Can you create a patch?
> 
> regards,
> Marc
> 
