Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD1C627D82
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiKNMRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiKNMRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:17:38 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223731E3F1;
        Mon, 14 Nov 2022 04:17:37 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v17so17001910edc.8;
        Mon, 14 Nov 2022 04:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1+DRgmN0eqZmnocBxTuNg6H1IaiSGYensI9rua5pGB0=;
        b=hsnePPpd6m7s3TvGrYDM5jZwj4FUd7jdqvnDDC3ztrWspx/Pn79ur0hsiW3FWUI2Lr
         LMJRf/m3QAWaMpWrT/gntlGSXY9U4Ecyh32TCKhsfcazRk9a/f+FVrgaxpeEGxP2ZGEw
         cq/nCQhxKyGh6mZoXnAntk/cqTpfooTC9Q74ZinPYjRVPYJPqDN0Gl1sNTIjg04JGz4g
         PaM2NuItdlg1jQd5KQyvlmzfdOioiNXbins5iER7DK9tKiDSAY7VQZ2XRNP0v4/cVhID
         bzzcURuCtGtAkdmWU1HcWLrwOhhLiNwBxAeJsOPMSsy8xENLK688eBzifx5j/Oq9SrC5
         f/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1+DRgmN0eqZmnocBxTuNg6H1IaiSGYensI9rua5pGB0=;
        b=TzFny4vPR1T2ZcdeMKbZKZXsBqShut2qS+CSI4yRaJ5MvFId0pVUEFmY6wKvfeK70K
         Jhxb9oCks/aDH7HA5Rv7VqFLlRe6KanV8amEM4cUt77C6Xk8XgMw+5QhZrMLSub7Aw7n
         ehGGPRQxagnAUA5/JXbzrI9dafLLq4pAHEcbFJvQI27BplqIOeKN5mbe3sgHJohRExHC
         h6nicMwTTpepN/uMjiAqdOzR4Nv+rWFr5MKGUmLweL5pft4RHIdVN6DVE8yjZSsTi6y/
         APqtvytC6b5QNLVAMgWqflcdH5/BeslpKVr8oXwKqifd/S623nIAmrqquGwVnE6zCpAR
         gVIQ==
X-Gm-Message-State: ANoB5pm6vqWhuC/hdnvKdCOaDKK8Wzrt6uutPKEwyaTOC6NbZRrptzzh
        OQ46OL9hRu5vXn+GorkUH0PiuAavlnACig==
X-Google-Smtp-Source: AA0mqf5Ysy1gz6yN4XSCdgx0UdizC8de7NO9AbjAcjx0sX17V3gzgpPi+UwLXHfaHliRk1f05MG8Hg==
X-Received: by 2002:a05:6402:528b:b0:463:c2f9:8a07 with SMTP id en11-20020a056402528b00b00463c2f98a07mr10896989edb.319.1668428255615;
        Mon, 14 Nov 2022 04:17:35 -0800 (PST)
Received: from skbuf ([188.27.184.37])
        by smtp.gmail.com with ESMTPSA id d13-20020aa7c1cd000000b00463597d2c25sm4756403edp.74.2022.11.14.04.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 04:17:35 -0800 (PST)
Date:   Mon, 14 Nov 2022 14:17:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221114121732.3sqlg5ey4fnmjj2o@skbuf>
References: <20221110212212.96825-1-nbd@nbd.name>
 <20221110212212.96825-2-nbd@nbd.name>
 <20221111233714.pmbc5qvq3g3hemhr@skbuf>
 <20221111204059.17b8ce95@kernel.org>
 <bcb33ba7-b2a3-1fe7-64b2-1e15203e2cce@nbd.name>
 <20221114115559.wl7efrgxphijqz4o@skbuf>
 <8faa9c5d-960c-849b-e6af-a847bb1fd12f@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8faa9c5d-960c-849b-e6af-a847bb1fd12f@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:06:42PM +0100, Felix Fietkau wrote:
> In that case it likely makes sense to disable DSA tag offloading whenever
> driver XDP is being used.
> Generic XDP probably doesn't matter much. Last time I tried to use it and
> ran into performance issues, I was told that it's only usable for testing
> anyway and there was no interest in fixing the cases that I ran into.

Don't know about generic XDP performance, sorry. But I think it's
reasonable that XDP programs written for a DSA switch should also work
if the DSA master has no driver support for XDP. At least until it gains
driver level support.

> > > How about this: I send a v4 which uses skb_dst_drop instead of skb_dst_set,
> > > so that other drivers can use refcounting if it makes sense for them. For
> > > mtk_eth_soc, I prefer to leave out refcounting for performance reasons.
> > > Is that acceptable to you guys?
> > 
> > I don't think you can mix refcounting at consumer side with no-refcounting
> > at producer side, no?
> skb_dst_drop checks if refcounting was used for the skb dst pointer.
> 
> > I suppose that we could leave refcounting out for now, and bug you if
> > someone comes with a real need later and complains. Right now it's a bit
> > hard for me to imagine all the possibilities. How does that sound?
> Sounds good. I think I'll send v4 anyway to deal with the XDP case and to
> switch to skb_dst_drop.

Sounds good.
