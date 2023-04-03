Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4AF6D425B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjDCKlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjDCKlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:41:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C6B12866;
        Mon,  3 Apr 2023 03:40:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id ew6so115354390edb.7;
        Mon, 03 Apr 2023 03:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680518455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7rH4uIzXK6l/huexlMRSE33rdhZjT66DcZAUi1ClaS4=;
        b=VjzIrsxcDH0WJ3uHgurjG8DLu7Ww0YaToip4InOiw5KExsOZhE+D/y/Ui07bKpTXNL
         Rp4jc5oYrBvXumCxwwiFEOlGrnQYRN+0P9dsQuNuiTcZ3K038TfNUK74tJpntKiVhnlp
         +0oZxYiGVujBc4kN/8SSAD7RPmRRhjVqksKKUHUYY50pkXoelsGSOlKtuwSw+DusZptk
         ba80/tO4D51qtrIEiRkhQou4Hk9pqZaPxYDH+kPzh/D11yQSd+mkpl+L8DuVONzxFToP
         nstJnVb4Su/u8u0PzC1WUHjDr3RNyLj3BOncQDyF2K2AJKE/OVvcjUfBqPmTuwto21Ic
         5BRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680518455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rH4uIzXK6l/huexlMRSE33rdhZjT66DcZAUi1ClaS4=;
        b=sjM1RheZ6h2F83fNEkVhohjkhhw/MYqp+kJdzoNIrwrJL2XWBsVRMYFWVAi/CRklaN
         k8jhjMeO7G37zjI2kYrdAwD8PmFs64Q05HlxH8QwXrSGgTPPe1wxHFihX8crOjLzVWNl
         oitx0QDWAe3hH1S6enxSeCaGbEx7uH+Yt8INbxeqb5wJWY0z+2IYFhI5Q+IRWt7KaBsb
         8DsFdorg2BPbCgR++ztN1WxuxGIJEQqzwI/h2Vnfqi/UHbfIHs1W6hYLiv5pSofO6K82
         PBoVncLBjB73S0WbqhPPchpDAw+R9S/sjdrRgq1kv82Yhtx3Eg+SqpkXb146AoQLs192
         l0Gg==
X-Gm-Message-State: AAQBX9fXmNckBUEjAJkNavYzWUOiMpGzM3CHzlPLccOrlZbGwvhzu0J+
        lZwf//AR9EbYBCxHAg0nRRs=
X-Google-Smtp-Source: AKy350aa1xWzLgKsAnyzR7hMjG5OX0qJ4S0qBFsoTR/lpvin5ToJ/JsS0ZwD4gLSvUfrbT3kW4xzKw==
X-Received: by 2002:a17:906:4fc5:b0:939:4d6d:1f26 with SMTP id i5-20020a1709064fc500b009394d6d1f26mr41117892ejw.50.1680518454254;
        Mon, 03 Apr 2023 03:40:54 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l22-20020a1709061c5600b00927f6c799e6sm4349395ejg.132.2023.04.03.03.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 03:40:53 -0700 (PDT)
Date:   Mon, 3 Apr 2023 13:40:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-stm32] [PATCH] net: stmmac: remove the limitation of
 adding vlan in promisc mode
Message-ID: <20230403104051.swr25d3bpenha3wp@skbuf>
References: <20230403081717.2047939-1-xiaoning.wang@nxp.com>
 <33b8501c-f617-3f66-91c4-02f9963e2a2f@pengutronix.de>
 <AM0PR04MB5089AD62F07221A7FC326E85F3929@AM0PR04MB5089.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB5089AD62F07221A7FC326E85F3929@AM0PR04MB5089.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clark,

On Mon, Apr 03, 2023 at 08:43:54AM +0000, Clark Wang wrote:
> Thanks. I will add it in V2.

Please always check the latest state of net.git/main before submitting
patches. In this case, you seem to have missed the existence of commit
a7602e7332b9 ("net: stmmac: don't reject VLANs when IFF_PROMISC is set").

Please also check Documentation/process/maintainer-netdev.rst for next
time, especially the part where it says to designate the patch as
"[PATCH net]" (it also says to add a Fixes tag as Ahmad already pointed out).
