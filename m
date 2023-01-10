Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5295B664ECC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjAJW3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbjAJW2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:28:21 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E1CDF64
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:28:04 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r18so9237747pgr.12
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ias0kMa7Dpy6efuLqrMPmSju6ftdtGi0Nmp23Kp7S60=;
        b=XXqEZV35GiUq6pq4Fv+UgCrauqMiD+CbacNK0Eg5U+Xbt61mykjd2HobW4m3cmqmOu
         es4hViNqJdXNfRIHUKinGb4qLYnxUVXm2AxE9Gw7YjggXtvVDlflp2HswMyv7P9agSyv
         vLzcgH6cclTRj/3YlDx3/8iv6PrFWbhE7cNGk/69kAMUy+G+5OKKK2gdlYrLi/25sSkC
         5zB0xjHZQJY62OURG8R7hWCTmufEhePADGcn0/nnJIEc4fl1bL49o/JGvaxgd3OM5NQw
         qesZstLwHHLgnlRpB1iB5PcWj10NdXajEzLKilpCnZrbYYiyH80BzkOxwOfl6ZZKQ22/
         4JkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ias0kMa7Dpy6efuLqrMPmSju6ftdtGi0Nmp23Kp7S60=;
        b=x1Vlr175H7dKuwJNF75wfN/4kIQdkLByc6znbJmlfCEwvWrsQNQiPyqFCPiY5S0brx
         PqPMe6K/UVIaxj2P7hWJ6N12qLNFaaTTRaMd/wHhF8bZtPx21QARL0Rn0/GKceToZsJJ
         kFhPPQd5AYizTujv7cbn7PQe1X2wvwX1ON1awgWLhzDhODMNDnY/mq0hZjVIBNvjhjKa
         W38yZQjqN1phh34GoSK9+TlpTUwyLKSMXtLxHC9Dx4YcS3lBdHkodNMtFRb/0pQUYCdS
         OFMOXmFzbACHn0yY1PR8vfkpV6mMdnfMVT8J5nCXcgMa0RnZFi47AoEeP0zYAuOhTaN+
         hbcg==
X-Gm-Message-State: AFqh2kqnVYy4Hyv7UfuYmT9yTuffMxBT51joafcvyNYcFonb6slM89yB
        nv3Zuit/hxW59Qn3O7FItPskiShJrt9bL91oTCc=
X-Google-Smtp-Source: AMrXdXudUxIkUz1Njejf2jt23sSfGDrzbwa5oJQjgd8ZCtJUPIqIJVP1JBvag93JwytC9tcWkZlw9jfmksaC37aZf1A=
X-Received: by 2002:a63:1f44:0:b0:476:d2d9:5151 with SMTP id
 q4-20020a631f44000000b00476d2d95151mr5029792pgm.487.1673389683572; Tue, 10
 Jan 2023 14:28:03 -0800 (PST)
MIME-Version: 1.0
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-9-gerhard@engleder-embedded.com> <464fd490273bf0df9f0725a69aa1c890705d0513.camel@gmail.com>
 <d2c69906-4686-c2e1-0102-a73a2d9ca061@engleder-embedded.com>
In-Reply-To: <d2c69906-4686-c2e1-0102-a73a2d9ca061@engleder-embedded.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Jan 2023 14:27:51 -0800
Message-ID: <CAKgT0UfeAus3GtVqBAtPA6mFC=kJ8YEq-Sdr6+A6O83JjyutAA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] tsnep: Add RX queue info for XDP support
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 1:21 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On 10.01.23 18:29, Alexander H Duyck wrote:
> > On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> >> Register xdp_rxq_info with page_pool memory model. This is needed for
> >> XDP buffer handling.
> >>

<...>

> >> @@ -1317,6 +1333,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
> >>                      tsnep_rx_close(adapter->queue[i].rx);
> >>              if (adapter->queue[i].tx)
> >>                      tsnep_tx_close(adapter->queue[i].tx);
> >> +
> >> +            netif_napi_del(&adapter->queue[i].napi);
> >>      }
> >>      return retval;
> >>   }
> >> @@ -1335,7 +1353,6 @@ static int tsnep_netdev_close(struct net_device *netdev)
> >>              tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
> >>
> >>              napi_disable(&adapter->queue[i].napi);
> >> -            netif_napi_del(&adapter->queue[i].napi);
> >>
> >>              tsnep_free_irq(&adapter->queue[i], i == 0);
> >>
> >
> > Likewise here you could take care of all the same items with the page
> > pool being freed after you have already unregistered and freed the napi
> > instance.
>
> I'm not sure if I understand it right. According to your suggestion
> above napi and xdp_rxq_info should be freed here?

Right. Between the napi_disable and the netif_napi_del you could
unregister the mem model and the xdp_info. Basically the two are tried
closer to the NAPI instance than the Rx queue itself so it would make
sense to just take care of it here. You might look at just putting
together a function to handle all of it since then you just pass
&adapter->queue once and then use a local variable in the function.
