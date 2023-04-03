Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB76D4743
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 16:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjDCOSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 10:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjDCOSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 10:18:41 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC49A2C9E7;
        Mon,  3 Apr 2023 07:18:39 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so14642635wmq.3;
        Mon, 03 Apr 2023 07:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680531518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKLsk5IUpt5OvNB2SRCyd8+q4w9jTom8wBgpZDcc4sc=;
        b=grUviwFCk4nGmk0LXsOGf+/LrAuekKtemeECdyxxrqCoqpMuJdQ7I8hFlWKNhaqeDW
         AFHMI0NXyixdyCcX3pmtf/SCHCLFwutIHpDfGXCNyskVVraCmHeZlrIlmzbz9wy7DsAS
         qgnzTbULnaP3rbxU0YcNNSUVV0Guq/kmOnUAaKeuiz9peIhGhfGaM35g1UK0g+W6Mev+
         IKvzverKoNSgu87ud2eQwnW1EX2+FR72kueBiuq/DqhAikZg0uvEIk8J6i3epr7t2mBC
         BLXbjzZe/pGLm3KQEQyndN5Fw2CZy2gJnqJHe8cNFo8f8L5OUoopOxjd6B5oBi9sl+V0
         r+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680531518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKLsk5IUpt5OvNB2SRCyd8+q4w9jTom8wBgpZDcc4sc=;
        b=4AxAD7g3DpL5nfhDMaWNeSFJ5qxHisnSx1tPTmW2R8jjHrJ7fQhZUi76t+dbGXJzHM
         p6bwl3sto61N9bKli56aTCZrO3yMM/fEGiLUyM2u/ZT5Fl2pvYwcCmNYUfjmzDjRaIxO
         n6jN2oD/dWwDmo+HVsG4PhKdtAe5Gn4QWlEnCYLm7NLzE5XsPaa37lqFIxq3cuYahW7o
         XfUFYhNCofJo2DiJlv4p75PC/WdFumWVUP9C6C2AVuhNEmofh+hXLi0bV+/v+12ZxpLo
         /kkhhk8jcbgvuz3Rqe3AwGEDH7i+7pKXMpuEW2HdVWtUiALl7YzTvJE5ijMoTRNWWoP/
         7Cxg==
X-Gm-Message-State: AO0yUKWM3MHPPKCmuSv9T29awd5Vz+VHT7DnJazxCPGINwu0xIktM/+h
        hZ7W82MYr7FMavYIxv/UuYQ=
X-Google-Smtp-Source: AK7set9SfiAk7icn3B+iyLUj/qSUxFe0+oDE64leKFOftA/vJPjUXX25BgAM4S+RJIbNwA7BpDC9rA==
X-Received: by 2002:a7b:ce08:0:b0:3ed:9a37:acbf with SMTP id m8-20020a7bce08000000b003ed9a37acbfmr26566520wmc.31.1680531518192;
        Mon, 03 Apr 2023 07:18:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z7-20020a7bc7c7000000b003ed1f111fdesm12261315wmk.20.2023.04.03.07.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:18:37 -0700 (PDT)
Date:   Mon, 3 Apr 2023 17:18:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <20230403141835.eqzivmcwenhzdgab@skbuf>
References: <CAOMZO5BTAaEV+vzq8v_gtyBSC24BY7hWVBehKa_X9BFZY4aYaA@mail.gmail.com>
 <20230328152158.qximoksxqed3ctqv@skbuf>
 <2023040343-grip-magical-89d2@gregkh>
 <2023040308-entwine-paralyses-c870@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023040308-entwine-paralyses-c870@gregkh>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 03:16:25PM +0200, Greg KH wrote:
> On Mon, Apr 03, 2023 at 03:15:19PM +0200, Greg KH wrote:
> > Agreed, this sounds like the removal of printk messages is removing the
> > noise, not the actual fix for the reason the printk messages in the
> > first place, right?
> 
> But, in looking at the above commits, that makes more sense.  I'll go
> queue these up for now, thanks.
> 
> greg k-h

No objections there, although that might have just bombed my attempts to
find out what is truly going on :)
