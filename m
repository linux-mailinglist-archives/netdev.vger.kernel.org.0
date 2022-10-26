Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE8460EA15
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 22:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiJZUOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 16:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiJZUN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 16:13:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F09148FC8;
        Wed, 26 Oct 2022 13:13:55 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y12so23212416edc.9;
        Wed, 26 Oct 2022 13:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GtbjOs5xt1golOMFbE0MLUuUPBXNTm7j8UDzOf2o2Qc=;
        b=GzvLPcnUWC5GlhudLqTUB2mt5J4cD80BFslDh8xCYiyVup5NXEUDyvlnXPHnIsf/bX
         tnWrVpkRhuS3hDL8OYcEHKwCXwYo3a2A39i5bCnlWAZD9zyCUMQryVn/h5ByQbOJIoGl
         kNtIwuqlMKdDZlc0vlSn+WaUftU5o7nGlh5XfBhgUNLGzzOmSP+qqZzzFzyfq4p6bebp
         DpXTntU1QA0ylaUx32YhY+Nagi3u51HF/30/ibp7ZLIBsD/+S9eky+/0yGa0ya6V/+jW
         LY5TH4Ys+qme40nlvYVwdOGgTzllYbGdv3q1h5lwOiJjYNwK0gdSEyCSFyAulfgM7Kpp
         2Y+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtbjOs5xt1golOMFbE0MLUuUPBXNTm7j8UDzOf2o2Qc=;
        b=d56VwEDbQ2YXBUvv3myM2CUv41OMHgulmcNlojLh/5I5OGDcAl34/yinFCy91JBTIb
         i3x/N/knOrVO+4wkPARijwh0lmD2NxRYtBME5UwHQ7ZOwlhRRvehTalDgegrm36r8R30
         GvUUB+FVWDV9NB0VTinbcDTDC9Kaq/1BFf1VzCvPNIUO1MV+9VxEOj0KoFNDV6hI/UsO
         Kmb2bcaMCIw/jQj4EF5j8+5qk2gMyQ5nt4JRp+HJOOJrYYAj+bYYMq+mbrPr5/R39eBe
         HBXAriY5Y2K4dew/DN9dryZwCEg6wmW4PU4iQqtfT5uP6ATaBD0ecGPIxWkjc0z4qeI2
         gC3A==
X-Gm-Message-State: ACrzQf2gZnPgpdDAyAwQ2E9treodOzfg9GvepoIy1Lqr/+CJz4LvV9sH
        ZNYqohUwqGoApcSHYTjv+cA=
X-Google-Smtp-Source: AMsMyM4PBYfEVA3/UvpHQ9o1P2NEhZJjlljgA22WgyAyR8LzwyKbZ3E0aRNGqpBldZFyF02bWKbM6A==
X-Received: by 2002:a05:6402:27cf:b0:462:75b3:a277 with SMTP id c15-20020a05640227cf00b0046275b3a277mr3083676ede.175.1666815233852;
        Wed, 26 Oct 2022 13:13:53 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id y17-20020a50eb91000000b00461816beef9sm4017623edr.14.2022.10.26.13.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 13:13:53 -0700 (PDT)
Date:   Wed, 26 Oct 2022 23:13:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, Tristram.Ha@microchip.com
Subject: Re: [RFC Patch net-next 5/6] net: dsa: microchip: Adding the ptp
 packet reception logic
Message-ID: <20221026201351.iqh5776hqnyoj56v@skbuf>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
 <20221014152857.32645-6-arun.ramadoss@microchip.com>
 <4458429.LvFx2qVVIh@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4458429.LvFx2qVVIh@n95hx1g2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 08:17:37AM +0200, Christian Eggers wrote:
> > +static int ksz_connect_tag_protocol(struct dsa_switch *ds,
> > +				    enum dsa_tag_protocol proto)
> > +{
> > +	struct ksz_tagger_data *tagger_data;
> > +
> > +	tagger_data = ksz_tagger_data(ds);
> 
> NULL pointer dereference is here:
> 
> ksz_connect() is only called for "lan937x", not for the other KSZ switches.
> If ksz_connect() shall only be called for PTP switches, the result of
> ksz_tagger_data() may be NULL.
> 
> > +	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
> > +
> > +	return 0;
> > +}
> > +

The observation is correct. All other drivers which use this API check
the protocol given as argument, and for good reason. Only "lan937x"
allocates tagger-owned storage in Arun's implementation, but the common
ksz library supports more tagging protocols.
