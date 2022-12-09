Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA58648A96
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiLIWHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLIWHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:07:01 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA596F4AF;
        Fri,  9 Dec 2022 14:06:55 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bj12so14508067ejb.13;
        Fri, 09 Dec 2022 14:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8wPCATI61mY32fXQYmfY3129eaQGge22oi1yD8Q6Bg4=;
        b=HpFZ5eCCcE2pzxG3d+u3WTfen1O8FvjZ6fVnHdPH9NqUv1UmM4UPV0yVLvT8YEl/i2
         DJQAQEenFOf13Zk+Zy3Jlp+8JYukV/IGDxIYxgq1PLa6LT+NSe2aeLUd6lDliyVV22eC
         HRc5PVHmLy7ybrqUp45+PBoAFDubxmbCYJFWrBSSGdB9XZveq2A3yg0ZUJ89lxpPHNtm
         zo28o3XhXhDY0z7Ui5JRJFgwiQAwygzC0SWNgCZnKJbdBh0OPiCRkmVI8TC3ZrUTtHcn
         cofzDLF7KF2Ghlr3Q6FoDUfmwfVMfNfro+yoYXq8Xf8K7enLfOXH6WqJgbEsgq7C0ama
         yfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wPCATI61mY32fXQYmfY3129eaQGge22oi1yD8Q6Bg4=;
        b=owU276iMN9CwEUAohBCxK4V2iHNAbQ3I3raNqY8Ti/eN6XSyikmsX9tNshXOU0e3yZ
         5R74AUVVTDp38o7I0BMDfRnX/+TOZoOctrtk7E433QNQMFL3UNbl5LFykmyjyV3nawWw
         s0wNV3X6kZOox42f6HzRwtZmieZcQ1gc+ehFgnCDzvCy61DylZCcekn8SiJXNAHWQ4lp
         0/lNBoMa/BE8bTVzRIbAbcGLijJxoEg86hEqdPl+8kSHYdOtb9AFAJAuua+FCmLHhf4S
         66+uxqDeA5UH1DWGOHK7sr1iqGq0p96sG55Cay+xpm17TcLbzJqS8UeaRy39jvdyQGus
         Ib9Q==
X-Gm-Message-State: ANoB5pn8uXQ25TJPB8cuClHA4C0zXEWSjIcYURK3v6zxpSUOW4St9SFX
        bWY6fpf0z6kPRJCTfrvGI1mHmQyy09ZP7A==
X-Google-Smtp-Source: AA0mqf6gZSBSmHjGJTmLBJdcDaSOndnOL3mYrFX4JbCZ43ZBb0YITkeh+b73hD5rfIlKXqPuyMlLoA==
X-Received: by 2002:a17:906:1dd6:b0:7c0:aa8e:af5b with SMTP id v22-20020a1709061dd600b007c0aa8eaf5bmr295460ejh.60.1670623614203;
        Fri, 09 Dec 2022 14:06:54 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id g16-20020a1709065d1000b007adf2e4c6f7sm345972ejt.195.2022.12.09.14.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:06:53 -0800 (PST)
Date:   Sat, 10 Dec 2022 00:06:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uladzislau Koshchanka <koshchanka@gmail.com>
Cc:     Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221209220651.i43mxhz5aczhhjgs@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <CAHktU2C00J7wY5uDbbScxwb0fD2kwUH+-=hgS5o_Timemh0Auw@mail.gmail.com>
 <20221209143024.ad4cckonv4c3yhxd@skbuf>
 <CAHktU2A2MQ4hW0WYcLDXuCuMsN84OmfrnrhTiOKqvHB_oFaVwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHktU2A2MQ4hW0WYcLDXuCuMsN84OmfrnrhTiOKqvHB_oFaVwg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 12:01:28AM +0300, Uladzislau Koshchanka wrote:
> Hi Vladimir,
> 
> > The problem I see with bitrev8 is that the byte_rev_table[] can
> > seemingly be built as a module (the BITREVERSE Kconfig knob is tristate,
> > and btw your patch doesn't make PACKING select BITREVERSE). But PACKING
> > is bool. IIRC, I got comments during review that it's not worth making
> > packing a module, but I may remember wrong.
> 
> Do you really think it's a problem? I personally would just select
> BITREVERSE with/without making PACKING tristate. BITREVERSE is already
> selected by CRC32 which defaults to y, so just adding a select isn't a
> change in the default. Can't think of a practical point in avoiding
> linking against 256 bytes here.
> 
> In any case, it just doesn't look right to have multiple bit-reverse
> implementations only because of Kconfig relations.

Ok, let's use BITREVERSE then. Could you submit your patch formally please?
