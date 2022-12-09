Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97C764882A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLISHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLISHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:07:34 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9DC9582;
        Fri,  9 Dec 2022 10:07:32 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kw15so13288131ejc.10;
        Fri, 09 Dec 2022 10:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aWX2o35JtDo4arDjBhAYZzskmwuvzgncFqXLd1vU4Uo=;
        b=KdCTt9Xz3LU95bpfG3R7J8LXUipE37UBmf33MtBixuOSUpI2tpBoCyPUClpehArZy2
         z8LE8TGkIaJrzgrBTNmaNQzscd/st6PXsdr6rbib++DSdSPxTfrEaep/gPlSf8ivTEev
         vUqp+XeFNlDxybMLwBysmOS+jGHc1ATNkhE3NQOjKHhBPN3/wtkqztqrOaIP9y5uzycL
         +qJlFMyqyXwGUUjRFyasxmSi2SnUYfVvaKo2CJx70iiEovhNv5SuZQfKTvq/SHaQqiit
         tz1vImFdoSeJ7efPQ2vA8DlKksQZKGCbmS4s+QesL110hIVzZG+cZ92wadQ+935+hJLI
         qBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWX2o35JtDo4arDjBhAYZzskmwuvzgncFqXLd1vU4Uo=;
        b=RQahEx6Xnr+h/YBlnIkvrndqJExPIyDjQYKtOXfwzi3KQJQAQM2ZFth+zYQuCq+LoK
         4BILNWCBht5BUOVeZi2RzVahqo1siX6vrRdkcc7xXD8Hzj/gSXbQb785W9qrE9I4eS49
         Hvyj3/0ODGc2cB+i++CWfuV1dodcU/ysp0M9OK+6zpjN9jWPXvPJMBlHkIQie0ShusuJ
         KKHtH43TBr9/yTC4gY69ImP1cmkyg76GWalJz6z3Hs5csmZZ1cnp/SNooWJzz+wWXsnD
         b7bTXOG/LYsQXYN7KULsJUG3HnaFT20R/HlBBX84QHMWe8w4vxukOXslm0IzGWE8PbQr
         yKwQ==
X-Gm-Message-State: ANoB5plde0NDzGNBTWTtxUqDWe5qTigt7mmgJEfRCkprzpGptYE8OrIN
        TgR7dC5Qz4qCAXiD+YO5Bhs=
X-Google-Smtp-Source: AA0mqf4tO7r+4sVI+K3zrC2j6HcLHblDIRjn7zLshpq8DaW3bWy9xoeW4z9HbXMtF1g03isH3M+oTQ==
X-Received: by 2002:a17:906:b6c9:b0:7bc:9a78:bc3a with SMTP id ec9-20020a170906b6c900b007bc9a78bc3amr5339121ejb.68.1670609250496;
        Fri, 09 Dec 2022 10:07:30 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id ku11-20020a170907788b00b007adaca75bd0sm171847ejc.179.2022.12.09.10.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 10:07:30 -0800 (PST)
Date:   Fri, 9 Dec 2022 20:07:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 2/2] dsa: lan9303: Migrate to PHYLINK
Message-ID: <20221209180728.d4ljemueqawbng4t@skbuf>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
 <20221208172105.4736qmzfckottfvm@skbuf>
 <MWHPR11MB169364EFBC8FE61E0772A25BEF1C9@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB169364EFBC8FE61E0772A25BEF1C9@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 06:00:47PM +0000, Jerry.Ray@microchip.com wrote:
> > As a reader, I find my intelligence insulted by self-evident comments such as this.
> > 
> > Especially in contrast with the writes below to the MII_BMCR of the
> > Virtual PHY, which would certainly deserve a bit more of an explanation,
> > yet there is none there.
> > 
> 
> I struggle with the lack of comments I see in the kernel codebase. While
> experts can look at the source code and understand it, I find I spend a
> good deal of time chasing down macros - following data structures - and
> reverse engineering an understanding of the purpose of something that could
> have been explained in the maintained source.  In-line comments target the
> unfamiliar reader as there are a lot of us out here and far too few experts.
> But I do see your point and I'll try to do a better job on this.

I do see that maybe my observation about the rest of this driver's code
lacking comments might have been unfair to you since it's not you who
added that uncommented code. But still, let's try to add comments where
those add value, and there are plenty of other places in this driver
which sorely need that. I still maintain that "if (!dsa_is_cpu_port()) return"
doesn't need a repeat in words of what that set of instructions does.
Maybe why, or something that isn't completely obvious from actually
reading what's already in the code.
