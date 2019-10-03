Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231A7CAA8E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393435AbfJCRI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:08:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34730 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393432AbfJCRIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:08:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id y35so2172042pgl.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3wpFvt6T3M4UoY71U3fdDiemKDugzUtNArfIoe81f18=;
        b=ShF50fkQ7yRZcRuU5JDxgmiwhEU7c1qwBaMS7y01ThVma/iGsbgLXVnv0l5XBc6pqW
         ydE428lBIXooDdhNWHXY809lddQa+nLjdahsB2yny8smUSGDme4VyqJyKN8qZ4WWVTgw
         RM+wtkSAgYNNpmr7WLGGmYm367gHj2IbUdVrirIVsAzN5rygxZG86QSInSwOEMhfJudr
         a3I1dxUBa51mFiq4yI1h1akQix2rnZ96Cwb5/3XQQ5Ifucw9jIN6vTTC7suBJNtSTqip
         5agv9Aj0+CzTV2H61BXBRNEUGTnfUIPiY+JRCr9WSd/6bHYAcu8ly1dP1zC1dM40KgGz
         it9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3wpFvt6T3M4UoY71U3fdDiemKDugzUtNArfIoe81f18=;
        b=l+yxUFEoh7LM9UckrE+Ky7Xd126YI2B5hMPWrZs8ONmZ7oIMgr+dvkKyffUsTxh2sA
         U/cVOswI3xf3Lk0qraVfeNAsFTni9kkF3KvPEJRM0KAlsJz5hITX7yHZMzz+pSOV7vbF
         KvRYaHv8magiySs1ILLMM3htnwsa3Kv5/esOTY0zpNrj5LHXpzyWdmchEUpwBBa7aYjy
         5m1Bi6qpp+9vm19u1qFtTybBwSz6/heuvQ09Wbnpf/o1uvNuMRDWQdSZz+MiQlifdk/e
         e4AyqIfRnIlZqElgoKPJO047s3xYD74UVdagQOeEFjdZ1Rp8FU7HxWC9M4POs3pCyfBp
         Pr7g==
X-Gm-Message-State: APjAAAWCkPnoxpWMnjvSx4s5dGKAz9Z6J/Xdkni9p+6gbDhHMa1zJeMQ
        +1SRlcv+CeeHnqHs9cuLCTpLoodl59E=
X-Google-Smtp-Source: APXvYqzFJ+nzpoNkOfnjL6zJfDXu+8KQq5ej5MQiIEcjfwjbTeoP6hXeidshPnVBmEmMvL9ORGRZRg==
X-Received: by 2002:a62:d152:: with SMTP id t18mr11841560pfl.259.1570122505107;
        Thu, 03 Oct 2019 10:08:25 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g202sm4653355pfb.155.2019.10.03.10.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 10:08:24 -0700 (PDT)
Date:   Thu, 3 Oct 2019 10:08:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: Re: [PATCH V2 net-next 5/5] net: ena: ethtool: support set_channels
 callback
Message-ID: <20191003100819.733be30a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <577acdeedc7a4db6a28b5e8350e7b88f@EX13D11EUB003.ant.amazon.com>
References: <20191002082052.14051-1-sameehj@amazon.com>
        <20191002082052.14051-6-sameehj@amazon.com>
        <20191002131132.7b81f339@cakuba.hsd1.ca.comcast.net>
        <577acdeedc7a4db6a28b5e8350e7b88f@EX13D11EUB003.ant.amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Oct 2019 15:32:33 +0000, Jubran, Samih wrote:
> > > +int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count) {
> > > +	struct ena_com_dev *ena_dev = adapter->ena_dev;
> > > +	bool dev_was_up;
> > > +
> > > +	dev_was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
> > > +	ena_close(adapter->netdev);
> > > +	adapter->num_io_queues = new_channel_count;
> > > +       /* We need to destroy the rss table so that the indirection
> > > +	* table will be reinitialized by ena_up()
> > > +	*/

Ugh, this comment is broken in the same way the comment Colin fixed in
commit 4208966f65f5 ("net: ena: clean up indentation issue") was.
Please double check your submission for this and use checkpatch.

> > > +	ena_com_rss_destroy(ena_dev);
> > > +	ena_init_io_rings(adapter);
> > > +	return dev_was_up ? ena_open(adapter->netdev) : 0;  
> > 
> > You should try to prepare the resources for the new configuration before
> > you attempt the change. Otherwise if allocation of new rings fails the open
> > will leave the device in a broken state.  
> 
> Our ena_up() applies logarithmic backoff mechanism on the rings size if
> the allocations fail, and therefore the device will stay functional.

Sure, a heuristic like that will help, but doesn't give hard
guarantees, which is what engineers like :)

> > This is not always enforced upstream, but you can see mlx5 or nfp for
> > examples of drivers which do this right..
> >   
> > >  }
> > >
> > >  static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx, struct
> > > sk_buff *skb)  

