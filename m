Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9C14D22F5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 21:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243797AbiCHU4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 15:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiCHU4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 15:56:08 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8573CFDC
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 12:55:10 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so426708pjl.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 12:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AC/iGqiTz/V5Y3WL/wIEhOf/zQOJMobaScq5jDHM+tc=;
        b=kGykJWwhb6HN2Y281ISa/OkQkxoqrnwh5BbrXcKfNYRd/E1u4kOOQZ1eKl4/pJN3MV
         mChoJ0Klh0SNhowHNsqMRdFmv2RBtBlTnBQB8nphuVNYAWwrZ73JpZDzd3NztYfOsNRF
         Y6s2GstlSkYjYa7Wh1aoShjF9/GQ7doHsQ4BbqdZQUo99OcO0bLwwuFx54z2zRaZm5h5
         Qgp7ik6/3sg5pMofAb5+5svh57PqcEgo2s0k/to92xJxgFJ6xHMDyJZpzLygK8yKz3/7
         tQqynq6T5dEhXdWsAisHA7uYiTHpLr0A1qKTbQmAgTms/jYm0T19SHc1hxpLZZIt2Y0A
         fgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AC/iGqiTz/V5Y3WL/wIEhOf/zQOJMobaScq5jDHM+tc=;
        b=f4CJmPrdgjTnPMxZwyakRLmbqO2aiBP8XwDEXlbLGw2HL/HWhDds7YhrYjeeO+wMrK
         ze+y0r1ecAvqU7qy0oqENRiNnOl6Ut+UqmZC/ulg1Fc5XS7DXRBEm29372EJtFB2w17F
         WHXKxMQLRM06FzeuomyPJL5SMplnD+G14K+1VlQa8m+WDXU8a8RX16I+pliypTGt/IAG
         u7OkZiu0OS1rOwHPf+iHQ6Kn6GSPt433e7+V6ipfHqCAD+jM+XY9prMsZXHu/uCClfsg
         Joq5BuIBjXz9g42kWOHidy0Purf7PwS7zqrhuyDgZiKNoF6UsGx2GdYehxwetMkDjj14
         bf4w==
X-Gm-Message-State: AOAM531GRplNm+a3l0bjaGOgTcp7tx5QeHXMWNLy51wZFSph3IwZ/+gK
        dJQ31TFd+pVnS3G4VV3razg=
X-Google-Smtp-Source: ABdhPJxt1hHnGQuARP4Vh0xhBXZYEc8oUGgGeYOjlvUEDJXC5pucVeJ6+CHe8djnRYyTehu59BSQgw==
X-Received: by 2002:a17:902:f789:b0:14e:ebbc:264b with SMTP id q9-20020a170902f78900b0014eebbc264bmr19244129pln.169.1646772910067;
        Tue, 08 Mar 2022 12:55:10 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090a178c00b001bd036e11fdsm3800787pja.42.2022.03.08.12.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 12:55:09 -0800 (PST)
Date:   Tue, 8 Mar 2022 12:55:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Michael Walle <michael@walle.cc>, gerhard@engleder-embedded.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, yangbo.lu@nxp.com
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220308205507.GD16895@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220307120751.3484125-1-michael@walle.cc>
 <20220307140531.GA29247@hoboy.vegasvil.org>
 <YiYVfrulOJ5RtWOy@localhost>
 <20220307143748.GD29247@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307143748.GD29247@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:37:48AM -0800, Richard Cochran wrote:
> On Mon, Mar 07, 2022 at 03:23:58PM +0100, Miroslav Lichvar wrote:
> 
> > There is a need to have multiple PHCs per device and for that to work
> > the drivers need to be able to save multiple timestamps per packet.
> 
> That is a big job that entails a new user API.

On second thought, maybe the address/cookie idea will at least open up
multiple driver timestamps in a practical way...

Thanks,
Richard
