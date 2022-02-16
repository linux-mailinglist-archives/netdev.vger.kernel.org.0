Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357924B8B33
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiBPOQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:16:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiBPOP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:15:59 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F4B2604DB
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:15:47 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id i11so2511957eda.9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gqRTxS7qLg3EkYHTSRr5mdcjuSMSNQDCp0E+VQJUqJw=;
        b=O8Zi/soj1+P6K/IGsMrZyLH/wYS6HstYIw6SCPvZ3PcsUCYvI+hVsaEUexHXEi6MNK
         4QtksSRSjA1OWaRcxdH4JYU2AfcyD8bV61Q8QKXwGXrBqDLPuzyCBH5zO582uIx6XeQ6
         UVoBH5oTpTIgDEIFpAfXpHXo/srp0Ul/4sIwLpiHGOK6XzRbPuhvzJDeQYcS4PTZq1BF
         PZaXBNR+8E6GuNHOYxsfBnXT0n7ykbePm61vuYIcnBb4lnOP4FZxlhzyQMUUuoi6X3aY
         hqWFe/hkIAuq/DsAcywe6lPVZXuXT3srGSguYgb7/QRHNa/XNbLfh3mTss8bHY4fPjd7
         EuDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gqRTxS7qLg3EkYHTSRr5mdcjuSMSNQDCp0E+VQJUqJw=;
        b=affITp872msjQ8jbO+rb5ezoTS048LHnBp0DGkx8sHsc1AfoSnTyM+jPgCKY/+hbZp
         EQnoehvtqDnxo+ze9/Ht74amYqdIoa0tV6Rdvz6ExFOfjUV6cQms3gdZKvI+A4uPypCc
         iswBHkI2i9QleD5lsuvlryu42u2qz6JArarkEdL3Q8Qe3erSPJ77dMFHnPd8O9aPEcj9
         IVN92hgj1ijK4EvqlBRcpRk0zdzEHdZS1yn2ZejoOR072ERmzUm17EP+HEsO35dPsbvd
         qoaqIhjYJAxFhvVRJmASRzfU23ME5truSPoDBhIS03l+E8A3RZoALu2Vx6d8XkE64pT0
         4nAQ==
X-Gm-Message-State: AOAM532Obu4TGrF6Dn+6NNt0yH8XyX0e881nPOI5xqFKj+ThrWSRq7uj
        jtSAcQgHqi73T7YkRxfKQoOfYqvIZrc=
X-Google-Smtp-Source: ABdhPJwK9T4us/9PUPS9S1KXK8NBy47GBWoe1qtLuJf5WPprQLEGVu9dFJN0FNfcjp3qusW7QP5B1g==
X-Received: by 2002:a50:fe14:0:b0:410:8621:6e0c with SMTP id f20-20020a50fe14000000b0041086216e0cmr3130995edt.356.1645020945868;
        Wed, 16 Feb 2022 06:15:45 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id w15sm1822878edd.79.2022.02.16.06.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 06:15:45 -0800 (PST)
Date:   Wed, 16 Feb 2022 16:15:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
Message-ID: <20220216141543.dnrnuvei4zck6xts@skbuf>
References: <yw1x8rud4cux.fsf@mansr.com>
 <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
 <20220215205418.a25ro255qbv5hpjk@skbuf>
 <yw1xa6er2bno.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1xa6er2bno.fsf@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 01:17:47PM +0000, Måns Rullgård wrote:
> > Some complaints about accessing the CPU port as dsa_to_port(chip->ds, 0),
> > but it's not the first place in this driver where that is done.
> 
> What would be the proper way to do it?

Generally speaking:

	struct dsa_port *cpu_dp;

	dsa_switch_for_each_cpu_port(cpu_dp, ds)
		break;

	// use cpu_dp

If your code runs after dsa_tree_setup_default_cpu(), which contains the
"DSA: tree %d has no CPU port\n" check, you don't even need to check
whether cpu_dp was found or not - it surely was. Everything that runs
after dsa_register_switch() has completed successfully - for example the
DSA ->setup() method - qualifies here.
