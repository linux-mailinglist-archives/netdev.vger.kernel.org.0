Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C04585329
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiG2QFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiG2QFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:05:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79CD98874F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659110700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hUIefpTqdDU1KPmNQbI90pVWvnIpLa50z8ZT7749rxA=;
        b=Sw0PXsLl/+wzwAjebHCZ9J5DydOSCCD5jBuICUvN8kwqDKbSSLfXvqs7F2PNPb1YyyvdQn
        W5s+Cu0XDyNeYFLNswGyWYHbo7aO91hfMyqpin/ZaYsZaD35Xxt5QggHwEki5c0E2nS0Vr
        kWjxOeTK8hAtly+BdGNvRUrQrK0uFac=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-oPJdoPtRM8WC5dDKe-VEHg-1; Fri, 29 Jul 2022 12:04:59 -0400
X-MC-Unique: oPJdoPtRM8WC5dDKe-VEHg-1
Received: by mail-wm1-f69.google.com with SMTP id k27-20020a05600c1c9b00b003a2fee19a80so4188193wms.1
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hUIefpTqdDU1KPmNQbI90pVWvnIpLa50z8ZT7749rxA=;
        b=64aiZ+Xty2/LiJEnlYfhNrh5RRt5t7viNC1bLWAsAbblBddFDcWfaIoQlEj8xEnnP8
         faTTY5HSBCmeJrMYHD/ZsLeYMDsRkWQeywGcF88gdVLFmB5otiuVoGrKlx4KXa4SSvR3
         pEl9RhxZH5YWAjNQ04ycwimVmBcIIGMoEXlWcFVmFfaK07uqTEgsX7NA6+gViSD75YGk
         j10ldFmnFQ4HbhjccsJ+Ae1Dc4BKH684c1/5fMo135Lt5brDqXtrKNqU4NKpcU1hdu1P
         HcsJMdpbJpp3qjq9iE3dimZ2w3FFo7UdEfJmJeEv5P7FBejM0kDeVlnGo1YrsGV9+riO
         XM0A==
X-Gm-Message-State: AJIora/AKh8Ixb9WQLy++oLxFNcuw1WKucozLnFdt0nPdeBIXr0fnI1f
        9c6L/6Q9EKcqxUskSvXro7bXGYsP4kIT/QXhC9cUG7w+bd4qMlK3oBjb48UBAJkWy4I61ZDSHrl
        xDGUgpMCZyRUbmyHv
X-Received: by 2002:a7b:c7d1:0:b0:3a3:1890:3495 with SMTP id z17-20020a7bc7d1000000b003a318903495mr3351735wmk.18.1659110697870;
        Fri, 29 Jul 2022 09:04:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uwl2k9WgvxB+UofeWRcHVukTcWLkz7VO7gtiXHahVmIOS1JEOMNhZ2+/6vDGhv4nDG/Ld4Vg==
X-Received: by 2002:a7b:c7d1:0:b0:3a3:1890:3495 with SMTP id z17-20020a7bc7d1000000b003a318903495mr3351716wmk.18.1659110697586;
        Fri, 29 Jul 2022 09:04:57 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l5-20020a056000022500b0021ee0e233d9sm3889276wrz.96.2022.07.29.09.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:04:57 -0700 (PDT)
Date:   Fri, 29 Jul 2022 18:04:55 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
Message-ID: <20220729160455.GE10877@pc-4.home>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-2-wojciech.drewek@intel.com>
 <20220729132200.GA10877@pc-4.home>
 <MW4PR11MB5776E25C99B1DC3505BB4A54FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR11MB5776E25C99B1DC3505BB4A54FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 02:32:36PM +0000, Drewek, Wojciech wrote:
> 
> 
> > -----Original Message-----
> > From: Guillaume Nault <gnault@redhat.com>
> > Sent: piątek, 29 lipca 2022 15:22
> > To: Drewek, Wojciech <wojciech.drewek@intel.com>
> > Cc: netdev@vger.kernel.org; dsahern@gmail.com; stephen@networkplumber.org
> > Subject: Re: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
> > 
> > On Fri, Jul 29, 2022 at 10:50:33AM +0200, Wojciech Drewek wrote:
> > > Move core logic of ll_proto_n2a and ll_proto_a2n
> > > to utils.c and make it more generic by allowing to
> > > pass table of protocols as argument (proto_tb).
> > > Introduce struct proto with protocol ID and name to
> > > allow this. This wil allow to use those functions by
> > > other use cases.
> > 
> > Acked-by: Guillaume Nault <gnault@redhat.com>
> 
> Sorry, I forgot to add your Acked-by, if next version will be needed I'll add it.

No worry :)

