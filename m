Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0090864625D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 21:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiLGU3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 15:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLGU3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 15:29:40 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8769130563;
        Wed,  7 Dec 2022 12:29:39 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fc4so16659176ejc.12;
        Wed, 07 Dec 2022 12:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nn9DbrBt5zFvvuKZFZtzTIGCaDA/3AtXgkoS+oaC8A0=;
        b=HZw2VldoZwMX855M5VvSrV4MycKX+RzwP6X1yHeudVKt0Q8DGtJ85iv2rEaaqu3GRF
         KEZ8Z/B185XweHodw49ajVnUCInWd+ZOtv/Fz/n7eO+zphH3BN6u93H3p9S3UDyNbFzv
         ynCFoMy7jQhrKJD10LZOT0E3VvRveYYrlJLD/uEUNbIrZLjnuxqPAo1AM+5wjxdHmqZO
         SqjZopbnHg7Cg3P3Vcn4Ni5IOGKwH8VA0dEhpF+1+nQgaM486s/wfY02CM+8OOJsCxxb
         kVCTUPBdgy4mnH24EzfCPxiCrIytfTMq+VUQIhiYuFnwe1daEmAR7AmflvF1CtOR8TZy
         hsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nn9DbrBt5zFvvuKZFZtzTIGCaDA/3AtXgkoS+oaC8A0=;
        b=5yXAT8QXHyXVBiYeDZWwQXFN6ZfxPwMiahQwNG1ZrCSsFBmWSLK8UNwpEIXfhx9mQT
         pqHys71IaSPL87JLxsYx5rGnJlg99tLKdFxmi4YV0U7ucsIgFFcQa3pSqHYzPFsM0/zW
         UlBg+Xv9/vq9A0dV3iQZC8+yUSVe06MbhtHrpeAVQY4VNEskhP8S1o69jGyipIU2aBxS
         faZYwlc46QLZfEWduh03MppKV7hNHaN/0CKa1p3Z9EDtWtqMhfVxD1lKDFtVu3peMFbc
         1EIQGhj2Ni/cQ+pEgRHQsENb/qy/D958kZcLroBGVUz/RQDXFBTtd2RWL2eEg6g2do6v
         VbEA==
X-Gm-Message-State: ANoB5pm9UlP4eBpmfwKeycz39yKaif0dINzAZj6H+BNXkCGzMTk1NX0B
        o+fTPuETb5ZBqUg9+oBmM+E=
X-Google-Smtp-Source: AA0mqf5TWjdWyACQTbauFE/5tpXUtZeS5dXiSRX9p/9NF6M3B2iKUN8lRY2UpEFGIuF4BB5/KcVQLA==
X-Received: by 2002:a17:906:3493:b0:7c0:bd68:ce30 with SMTP id g19-20020a170906349300b007c0bd68ce30mr675315ejb.54.1670444977991;
        Wed, 07 Dec 2022 12:29:37 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b0077b523d309asm8823148ejf.185.2022.12.07.12.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 12:29:37 -0800 (PST)
Date:   Wed, 7 Dec 2022 22:29:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221207202935.eil7swy4osu65qlb@skbuf>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
 <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:36:42PM +0100, netdev@kapio-technology.com wrote:
> > I was under the impression that we agreed that the locking change will
> > be split to a separate patch.
> 
> Sorry, I guess that because of the quite long time that has passed as I
> needed to get this FID=0 issue sorted out, and had many other different
> changes to attend, I forgot.

Well, at least you got the FID=0 issue sorted out... right?
What was the cause, what is the solution?
