Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938186E8D50
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbjDTIzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjDTIyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:54:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A357C1FFD;
        Thu, 20 Apr 2023 01:52:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sz19so4770717ejc.2;
        Thu, 20 Apr 2023 01:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681980734; x=1684572734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zBLes227ZmGUNlrR4Hrc178F7lyu/NFgEoTkP/9x/pU=;
        b=kiMgfwaCg3MIrV16uRyfNUX8tZdNDyDTu9PErvTQyII31rpMbX9t8jmWNV8HK89Qfe
         fP00KNdXTnLEEcDcja2GV/o42VVV4snivWAbIC/IgghD00hJoit8WjBmgXT/J8PwIbi2
         jD4qgRxRIYzsAbeHVWwJ+8QamMHNU1Xza6H/ujIfBkIxRmwKIxG/Lma4OwuG2poIJqx0
         P0K/cJmHPUkkpWTCyp0qOQysxAo2Fbw0wQfWrW7oolU+MI5Y8d/U7248ZSkFrzaTTWzD
         BiRmtUn9KdV1CzCHKgV+Fwh+uppNFrISzfxLMDL6WaeRS/OaW1HYSG96lI+5Kumdacoh
         0m1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980734; x=1684572734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBLes227ZmGUNlrR4Hrc178F7lyu/NFgEoTkP/9x/pU=;
        b=Lkye1GXnjpHSOfWjQSMfi+UYVPSRq4jNR+KgbX3J/Ol8x6YiQSbeMy7KiGl/fTzGU8
         i01loMLZj99Fgsa+lS+4MQVNVMWH/U5jBdSV6z9y8xbHrMT0wKW7+/PwQ8RajVMqRm+B
         i5IiJRujaBMuLmgB+XMJszlTZpdkeFvdpAz06DnDs3O6eGaSAEZJWZLjOTsUOSZGTxya
         uUroIGKulvNrKvAnUF9Z+SWijl5y1o6cMLTJNQ7MsRe3NT0IkMkAu2Dvz4zNeTAHwIqe
         vqcjUedwIE7lOvQkff7ihKQy96H5rO/SeADC7G58xgp0ZWIJax6Rcp14QXxeWP92GqVm
         6ETQ==
X-Gm-Message-State: AAQBX9c2ZFtcfWz43tdXvA+VAlYXrs20YdSe+xE+dzSJ6HPSi+yncM6A
        r0yLWElAKivywvz6x2bVyvI=
X-Google-Smtp-Source: AKy350Y+6v7kvcANIiWzMVx1OPRQPLrfl4E34LEYrMO66zBxtlFeUYYPBgX/1OLaUlqWxbjEbAnVDg==
X-Received: by 2002:a17:906:ce2b:b0:94f:6218:191c with SMTP id sd11-20020a170906ce2b00b0094f6218191cmr864048ejb.18.1681980733982;
        Thu, 20 Apr 2023 01:52:13 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090610c800b0093313f4fc3csm484346ejv.70.2023.04.20.01.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:52:13 -0700 (PDT)
Date:   Thu, 20 Apr 2023 11:52:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, 'Jose Abreu' <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net-next v3 6/8] net: pcs: Add 10GBASE-R mode for
 Synopsys Designware XPCS
Message-ID: <20230420085211.6kt2oj3k5k54mtuf@skbuf>
References: <20230420080312.6ai6yrm6gikljeto@skbuf>
 <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
 <20230419131938.3k4kuqucvuuhxcrc@skbuf>
 <037501d9732b$518048d0$f480da70$@trustnetic.com>
 <20230420080312.6ai6yrm6gikljeto@skbuf>
 <03d301d97363$874123d0$95c36b70$@trustnetic.com>
 <03d301d97363$874123d0$95c36b70$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03d301d97363$874123d0$95c36b70$@trustnetic.com>
 <03d301d97363$874123d0$95c36b70$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:38:48PM +0800, Jiawen Wu wrote:
> It needs to implement compat->pma_config, and add a flag in struct dw_xpcs
> to indicate board with specific pma configuration. For 10GBASE-R interface, it
> relatively simple, but a bit more complicate for 1000BASE-X since there are
> logic conflicts in xpcs_do_config(), I haven't resolved yet.
> 
> In addition, reconfiguring XPCS will cause some known issues that I need to
> workaround in the ethernet driver. So I'd like to add configuration when I
> implement rate switching.
> 
> There is a piece codes for my test:

The PMA initialization procedure looks pretty clean to me (although I'm
not clear why it depends upon xpcs->flags & DW_MODEL_WANGXUN_SP when the
registers seem to be present in the common databook), and having it in
the XPCS driver seems much preferable to depending on an unknown previous
initialization stage.

Could you detail a bit the known issues and the 1000BASE-X conflicts in
xpcs_do_config()?
