Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C86645BF5
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiLGODs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiLGOCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:02:51 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD8B5FB8B;
        Wed,  7 Dec 2022 06:01:27 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id b2so14172335eja.7;
        Wed, 07 Dec 2022 06:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWIrJH4UoIoZiDf7F/vSiZ3gjhe55HNOLzi7v49e38Q=;
        b=KTxCfa1p6hMuXO79BUyUaKZi9fdoUIy1ql/gWYLm+XaTdUQlVpN+TGZh8gg4e2Mgkz
         vclE5n2y3/LhAasB8jIJYB+ELvF+vlPW9uPX9vg9PxYki+3DN291q387sL3AE7LYCz20
         ztJJpekAnHucjdNoq5AUsT9e2QfMrYZjujg4DkhvY0o4HGa5e+v3bMAkACdo9Ta7FRed
         RkvIxB0v4grpMBShJr2Zep4txSWuiwjsEJTiAZvtjD7Clu2KbZJsbpwnuke0/FYFBK+e
         Fux+A5XMmu+JczVhlShF0LS1AZ4gOlLNQty7LK1PRFuOJ49k9xyzcwhJYD7Ci+nkoXZP
         PGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWIrJH4UoIoZiDf7F/vSiZ3gjhe55HNOLzi7v49e38Q=;
        b=FsKPkVwKO13rf4eKpvttsXgXomXy8r8aQe+dv5imjjVGHgbT1QC3d11QAyDFU4XjnR
         6RBe69lSpUjnaO8i29hOme4Mxt29hb/jwK0c3qQ3ME9UdtBO9bxvm6cotYWghzlAEktq
         pkAJoesNhlKM5vWsK+BGZWSufJWVvw5h0tjSqzhoEBz/sDgUTmSe9BdQHbn3qNIap2xn
         BJzV1qt6FQGr6kNJa5ZSWu2kK3EhhyjxF9SRi3fTSM+YnpzlScyCaaJWOi3Ewegc0ilR
         4MvwBKY/wl5PcMqfxqaJ/AqoJ9OSNvMtEB6NfRUq2HyU7jJcI/rFXiLLkSRNbXMI6JbI
         nZ1A==
X-Gm-Message-State: ANoB5pkxFXd2177A89UUNAhTQ2CzlY+H+/8KPb6oIScztmF96Lq4HM4o
        5NPhZKBqrQrQUAT1GAAAHeM=
X-Google-Smtp-Source: AA0mqf6rBGqvRQsRou+yh2RvdQOdILMIX+g40OrtXH4aFEi+omtmw7algnxe3rbCsiAieWjCf9xHLw==
X-Received: by 2002:a17:906:4704:b0:7c1:13b7:a5a1 with SMTP id y4-20020a170906470400b007c113b7a5a1mr374947ejq.46.1670421685525;
        Wed, 07 Dec 2022 06:01:25 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906211200b007b29eb8a4dbsm8693074ejt.13.2022.12.07.06.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:01:25 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:01:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Message-ID: <20221207140122.usg7vvfutcpmy7py@skbuf>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206193224.f3obnsjtphbxole4@skbuf>
 <Y4+vKh8EfA9vtC2B@shell.armlinux.org.uk>
 <MWHPR11MB1693565E49EAB189C2084C58EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1693565E49EAB189C2084C58EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:58:25PM +0000, Jerry.Ray@microchip.com wrote:
> I, too, thought I would need phylink_mac_config and phylink_mac_link_up to
> completely migrate away from PHYLIB to PHYLINK.  But it seems as though the
> phylink layer is now taking care of the speed / duplex / etc settings of the
> phy registers.  There is no DSA driver housecleaning needed at these other
> phylink_ api hook functions.  At least, that's my current level of
> understanding...

Did you understand my request? To create a separate patch, not phylink
conversion, which deletes the MII_BMCR writes to the Virtual PHY, which
says that you don't know why they're there and you don't think that
they're needed, but at least you thought about what you're doing?
