Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FC9640489
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiLBK0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLBK0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:26:21 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E1926AC0;
        Fri,  2 Dec 2022 02:26:20 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bs21so7122148wrb.4;
        Fri, 02 Dec 2022 02:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jNLrMQiEM6rpQlVYEUNGp4QXPdu9DtLm7iUcNPRtKZw=;
        b=RjH3ddx6KxF5pUy3UjLPOERQnD+F6WxodSR7IxcB2vbYsVBWIF0hgjm6udRXUhASbv
         4ey8t12fwULfJ0ZMR7Vqs7oATPjSei7v6ZgPJuk9Kv9OS2To+YkgbLMQv4LrxVWRH4VF
         88tmGpuUvQbsilOQmRL3tjx3ac92rGJVLCfIeXsvIuJz0X4aAVCgv7r7h2LnQxxU/y2+
         qxkxdCs+pINgyJZ0MLkVe2YQDu3dIN0MY54rRDsM16GLwm5mXmyNZ0N3eZ0SwljbDcDB
         aMrzBeG3u6Ri0iEsQbiw0sF0xgGoP2SY03Os4t9dEQTsW++hnCVme8xZioDeSQsdiRWl
         9oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNLrMQiEM6rpQlVYEUNGp4QXPdu9DtLm7iUcNPRtKZw=;
        b=55W3NceivZ5KTW36kC1SfJmOliovdY1/1+Wr5KTd6p8hMuCJ12mO1oAdSkmaSMu6Vv
         ZXZntripPjx2285b5JXIORTE4Xx6WNrDGcuKtEdF+2crax9/gV/PAbRNNX+M+RBo4NPX
         4KKqQabip/WBxOnGJbPB+YGJUIugV+P0ieECu2hJUc+0prHNxRrKkLv1xAz5A2ZZ5N3+
         9zveoLrWrGkDjdvq3UPvAcegeWNPmE4RgXdZOcsD46r6+TUgE7E9UglBGCdaTkjQiReY
         D2A5h4E6NYTHoHdsLiW3x69lmdkJnCfiP9yTPCuLMwzMGSTttNn8vzhYQFklf0KHdbbb
         y0Lg==
X-Gm-Message-State: ANoB5plYMkDGJelfnNBJEIRH4D7mpm8GLlvF5PFiX5+tTUaSJQ2TzbXd
        s2r+BJUqdPUBuFTrDC1Gbbc=
X-Google-Smtp-Source: AA0mqf4Er2ZY9L/YcgQphvw5kybsI2mvqT/p/UmoQ5FIfH6LRnk/GiXYKTOGKQh+FMjRT3yt0hUx/g==
X-Received: by 2002:a5d:438e:0:b0:242:3b4f:96ed with SMTP id i14-20020a5d438e000000b002423b4f96edmr3976231wrq.261.1669976778858;
        Fri, 02 Dec 2022 02:26:18 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o12-20020a5d670c000000b002424b695f7esm212568wru.46.2022.12.02.02.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:26:18 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:26:03 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     liqiong <liqiong@nfschina.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] ipvs: initialize 'ret' variable in do_ip_vs_set_ctl()
Message-ID: <Y4nSu7D5T2jDkXGK@kadam>
References: <20221202032511.1435-1-liqiong@nfschina.com>
 <Y4nORiViTw0XlU2a@kadam>
 <9bc0af1a-3cf0-de4e-7073-0f7895b7f6eb@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bc0af1a-3cf0-de4e-7073-0f7895b7f6eb@nfschina.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 06:18:37PM +0800, liqiong wrote:
> 
> 
> 在 2022年12月02日 18:07, Dan Carpenter 写道:
> > On Fri, Dec 02, 2022 at 11:25:11AM +0800, Li Qiong wrote:
> >> The 'ret' should need to be initialized to 0, in case
> >> return a uninitialized value because no default process
> >> for "switch (cmd)".
> >>
> >> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> > If this is a real bug, then it needs a fixes tag.  The fixes tag helps
> > us know whether to back port or not and it also helps in reviewing the
> > patch.  Also get_maintainer.pl will CC the person who introduced the
> > bug so they can review it.  They are normally the best person to review
> > their own code.
> >
> > Here it would be:
> > Fixes: c5a8a8498eed ("ipvs: Fix uninit-value in do_ip_vs_set_ctl()")
> >
> > Which is strange...  Also it suggest that the correct value is -EINVAL
> > and not 0.
> >
> > The thing about uninitialized variable bugs is that Smatch and Clang
> > both warn about them so they tend to get reported pretty quick.
> > Apparently neither Nathan nor I sent forwarded this static checker
> > warning.  :/
> >
> > regards,
> > dan carpenter
> 
> It is not a real bug,   I  use tool (eg: smatch, sparse) to audit the
> code,  got this warning and check it, found may be a real problem.

Yeah.  If it is a false positive just ignore it, do not bother to
silence wrong static checker warnings.

The code in question here is:

	if (len != set_arglen[CMDID(cmd)]) {

The only time that condition can be true is for the cases in the switch
statement.  So Peilin's patch is correct.

Smatch is bad at understanding arrays so Smatch cannot parse the if
statement above as a human reader can.

regards,
dan carpenter

