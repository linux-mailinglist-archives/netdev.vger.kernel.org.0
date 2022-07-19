Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB3D57A0E8
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbiGSOMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbiGSOMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:12:06 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D2145991;
        Tue, 19 Jul 2022 06:34:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id sz17so27187845ejc.9;
        Tue, 19 Jul 2022 06:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z6xDSfAHK+BBQJZyK140qnQ9OO2D3PdlxD4xhuvsKj4=;
        b=KEn4wOj0CcTFN+w68/vqdQUgXcJevK8GV52zDvtSu7OanGPud8r1CB0HPQqNpqLdLR
         SVL6gt1GTmiLVPMuMWxbcKrkTGLV50U1cM1Df5+tpXnEIO1N5tu3rinaVf9jVtmvuf/E
         h4+j/flwd1TuzCW8z+FvMQ1d0xwn+sJ6Dvk37KIU4iM3hHk6SalKeNEtFTmzNeDsY7uD
         ZSHsn3amPpI4ghzyNJS01PtIzdhxIEb9zxE1dLbDNk0XmWng0PGJaNKbKojmqnYzIyED
         mwuSDYyM/ctAMWDuUdNOkM+JncMo+7wFEr2o77rrjsd7mmBO/xBZj9/UF99Xl9h+8y0s
         JheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z6xDSfAHK+BBQJZyK140qnQ9OO2D3PdlxD4xhuvsKj4=;
        b=MZUzPtN+2ZzVknLd1mYkL2hUM+3o2p7PIL1ciXfgELsRqxDPNv3lCQDqnPXQN/K+5k
         nUzN1FzDDpyLFTTOHeRUQ6v+BawPxgnZ4W1heUepPQIEt9Ce5AjkWZdUbHocJ2Ri7qjd
         A3hlrYESE6Z9/nmDY7XMqRIYuKRJtdGYFUdN6YMenrHovuyuWdeC8oYmtDs3lAve32Iv
         Ysgp7w6lsikl5VXAFSyPBXVPPQrLZddowQlvBbTQU1dU/p9BB7ZjFHeeAgyLbZce5YME
         aJm7X/41U9XVmXJhpl6ttCz1ivMbzLUp7d0E/7TvBj6eZlkiN7bYIMfnn/M4lcxSqUDX
         ZwpA==
X-Gm-Message-State: AJIora9PKzVbQXQK0l7WhiBAnCgx0CGHiWn3q8HQfbp1YMojrCGVk3h8
        R2qvOWjfMpRhcxzfCu7VRNq2EhDd/1Bhuw==
X-Google-Smtp-Source: AGRyM1vYlG9DRVyycefPGSd4rQth0b9k4pq9UAUJDsuPPsY5ODFj8zD4DDbavJVNIdsGJ4ZY0mY+Sw==
X-Received: by 2002:a17:907:72ce:b0:72f:7b3:b9c8 with SMTP id du14-20020a17090772ce00b0072f07b3b9c8mr17643941ejc.248.1658237672545;
        Tue, 19 Jul 2022 06:34:32 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id r17-20020aa7d591000000b0043b9d4f7678sm801879edq.96.2022.07.19.06.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:34:31 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:34:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 03/15] net: dsa: qca8k: move
 qca8kread/write/rmw and reg table to common code
Message-ID: <20220719133429.mhd5t4ekjlz7k6yw@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-5-ansuelsmth@gmail.com>
 <62d60620.1c69fb81.42957.a752@mx.google.com>
 <20220718183006.15e16e46@kernel.org>
 <62d609d8.1c69fb81.d2fea.5a4b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d609d8.1c69fb81.d2fea.5a4b@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:16:05AM +0200, Christian Marangi wrote:
> On Mon, Jul 18, 2022 at 06:30:06PM -0700, Jakub Kicinski wrote:
> > On Tue, 19 Jul 2022 03:00:13 +0200 Christian Marangi wrote:
> > > This slipped and was sent by mistake (and was just a typo fixed in the
> > > title)
> > > 
> > > Please ignore. Sorry.
> > 
> > Please make sure you wait 24h before reposting, as per
> 
> Oh sorry... you are right, had a long discussion with Vladimir on the
> changes to do and I thought it was a good idea (since v1 was really not
> reviewable)

I think Jakub said "please wait at least 24h until reposing v3". Your RFC v1
was posted 3 days ago, I believe we all agree that's more than 24 hours ago,
and therefore not what Jakub was talking about.
