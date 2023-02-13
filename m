Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD78D694A59
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjBMPH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBMPH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:07:28 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E93B1710;
        Mon, 13 Feb 2023 07:07:27 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m10so3657122wrn.4;
        Mon, 13 Feb 2023 07:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=haFLIaedXT6lSzQN/BFfWC+Qgcnkz7HtZEKxAyIGp8k=;
        b=XlWFLkOjCu08JC1QX/FNmIngUGQgB/HPIysH9yuMradqS9IkNpqvLrnl8ISbLbWQJc
         o8EkyKdR15LDcoef2nbpm5/gRpVBzNM9qDzwMi8dZ3pSrZ5909oUaPGHIvJ1WZs9rENO
         6nqD1Lp7/MCxA5eblkTdFcOiCYCR+SZDxXXhpnGFcHtcfo13iVxMt6kkO1zRkN16i5Si
         YNanLgnw/wTiFI1YAhdB1OjouIFcbXY2AaHXsF7vtHtdKyGMMXEz+pqywq4bHn7gFnRf
         RRbJn0bB5u5+iPRgHwA/1t7bD+r0a+zR/4aNaUc2zb47Qo7cfzPVd169ujd4sbgjrFf9
         teIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=haFLIaedXT6lSzQN/BFfWC+Qgcnkz7HtZEKxAyIGp8k=;
        b=rUnQSesLeT8TGQKQTXSVr/fLHpv5Ug1WpQfYL2967Vp+LLTABW+7LVeTHpFIzm9F3O
         doS0PtMwklKbF9sMx2luL5e4PXhjWfHjk3NgaPsIGiSopfL7QGoswIAZQBNaRcQBJOTl
         kxlgYYWUK4q8tY8sRMYGTLjY8KwELxbEkIhf4ig7115oV7VIY8g1i61Aq1H+Za9ZKMvy
         +B50/OmBmBjicpiqNug03UTiTv3AucW5Cpkx12RUc55Le98MZOuR0zJEKtLk6NNZtsPj
         vQJUXOIe+Hkfymm6QxTev6CN6feuu1JcLvfT/I2PEUhid4v2wHqp81KNzJpVqreF0ZJr
         br1A==
X-Gm-Message-State: AO0yUKVx3IiVLz1SQlnLTvOsLsv1pntBMSLGuBnfv6xjoecGmILjGM39
        5tZYXooKQy5XQv3xsMEvzcs=
X-Google-Smtp-Source: AK7set+GIguYmobmwx3+S2MT+Q9stky3DoNFwgoGxedt3sX/HAnAJTDBVDrKyp52mZ7CQP3xPMfrHA==
X-Received: by 2002:adf:fdc7:0:b0:2c5:5836:4e1b with SMTP id i7-20020adffdc7000000b002c558364e1bmr3759794wrs.60.1676300845751;
        Mon, 13 Feb 2023 07:07:25 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j16-20020adfff90000000b002c55efa9cbesm1239308wrr.39.2023.02.13.07.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:07:25 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:07:21 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 04/10] net: microchip: sparx5: Use chain ids
 without offsets when enabling rules
Message-ID: <Y+pSKQdcpMw3YGvh@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-5-steen.hegelund@microchip.com>
 <Y+oZjg8EkKp46V9Z@kadam>
 <b755fa1c818639a1e7c11ab3b2ac56443757ac3c.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b755fa1c818639a1e7c11ab3b2ac56443757ac3c.camel@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 01:48:50PM +0100, Steen Hegelund wrote:
> Hi Dan,
> 
> On Mon, 2023-02-13 at 14:05 +0300, Dan Carpenter wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > content is safe
> > 
> > On Mon, Feb 13, 2023 at 10:24:20AM +0100, Steen Hegelund wrote:
> > > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > index 68e04d47f6fd..9ca0cb855c3c 100644
> > > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > @@ -1568,6 +1568,18 @@ static int vcap_write_counter(struct
> > > vcap_rule_internal *ri,
> > >       return 0;
> > >  }
> > > 
> > > +/* Return the chain id rounded down to nearest lookup */
> > > +static int vcap_round_down_chain(int cid)
> > > +{
> > > +     return cid - (cid % VCAP_CID_LOOKUP_SIZE);
> > > +}
> > > +
> > > +/* Return the chain id rounded up to nearest lookup */
> > > +static int vcap_round_up_chain(int cid)
> > > +{
> > > +     return vcap_round_down_chain(cid + VCAP_CID_LOOKUP_SIZE);
> > 
> > Just use the round_up/down() macros.
> 
> The only round up/down macros that I am aware of are:
> 
>  * round_up - round up to next specified power of 2
>  * round_down - round down to next specified power of 2
> 
> And I cannot use these as the VCAP_CID_LOOKUP_SIZE is not a power of 2.
> 
> Did I miss something here?
> 

Oh wow.  I didn't realize they needed to be a power of 2.  Sorry!

regards,
dan carpenter

