Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA3D5991A2
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiHSAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHSAOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:14:02 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7587C3D59D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:14:00 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id tl27so6097731ejc.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=o1FY/AC3IB+IcELjmFTSuPn2MO9oEkJsOBsq/dEEIec=;
        b=WOB3rNBFa67tsDzsAtXqUJv9JtFFmzfBwcsv2G7sB4fWLY5Ni08ITDVAG4ZMU2lS+A
         PyBga+vp9v7AJN2ArZoNdKzC9VjlTHnpSAezrEtny3x5ZkBxdmuWwjwOyjyrDt1gWKcA
         EtHGzfP1NtBHGxRhQVn9YcRwC6tmTloRagWskQcR9kY32C2HTXyA52Aa+iZ3lMxRH5Kn
         RISuY0rkNPtvqFPPcH598bUw2g1j2beJZ0ipchewQObFuJJnVzy80JW6CWcNu2oSWVrv
         YJhsENIgwMs8HBr62fTDvWCQoe2PP/5kvb/04cRfuBa2MbxqABQQW50Z/ehsBboEjnxp
         ualg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=o1FY/AC3IB+IcELjmFTSuPn2MO9oEkJsOBsq/dEEIec=;
        b=gBWygUUEuOL5RAMVRIuT9bx7CyBtElC4JrAFYSrsOTGriWuurjSD4Sldv0TP4b6vMu
         sZnRPDP7NRSooM+Yw+yV7bjwLFsI3/p5s3E8lIGENd+UQ5R9eWsgU+dSBXHYXgznUC5I
         4aIcpOnPMtqQr3XsW2g/oZYTkcujS83YeyXdp/dyVQeMIHwD2XkdKou436Ejnhy8pkid
         eHUjqoxg2DtMqvjc5ORnhFBJkSJ1G/YHoGngf+VbIWN10UW7q5D7Kp3C0TIOUc53hO0t
         NSJ1NYuTA0xBnNMa9y5O2NG6hezakrUPqe6cKVMJcq5jHAMXGNWzkkuLqkaoImiWhOaX
         iYcQ==
X-Gm-Message-State: ACgBeo3BC1SQpIN9XIjhKzx3/xNb4Hg+SwOn3FHdAkXaxCTVVdjzDthA
        8UR1fCK3LOTSMpfEsRSxd8A=
X-Google-Smtp-Source: AA6agR5nqQhTvk2nRxNia4gHSXW2qF+L+RPcx5eyC9+MjqcBEbtMgSs0ZnJFvUTR1jComP3ci24vtA==
X-Received: by 2002:a17:907:2816:b0:733:c08:fe6c with SMTP id eb22-20020a170907281600b007330c08fe6cmr3238299ejc.325.1660868039020;
        Thu, 18 Aug 2022 17:13:59 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id l9-20020a056402124900b00435a62d35b5sm2009750edw.45.2022.08.18.17.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 17:13:58 -0700 (PDT)
Date:   Fri, 19 Aug 2022 03:13:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH net-next 00/10] Use robust notifiers in DSA
Message-ID: <20220819001355.7kw6rm5bf257huc2@skbuf>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
 <Yv6z5HTyenpJ+pex@lunn.ch>
 <20220818222850.mskqhmzpvz2ooamv@skbuf>
 <Yv6+m7T4HqYnYoDm@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv6+m7T4HqYnYoDm@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 12:35:07AM +0200, Andrew Lunn wrote:
> > So you think that rollback at the cross-chip notifier layer is a new
> > problem we need to tackle, because we don't have enough transactional
> > layering in the code?
> 
> No, i don't think it is a new problem, but it might help explain why
> you don't feel quite right about it. Some errors we simply don't care
> about because we cannot do anything about it. Other errors we should
> try to rollback, and hence need robust notifiers for those errors.

So most of the actual errors I've had to handle in the kernel were
caused by half the code (the callee) expecting one thing, and half the
code (the caller) providing another. That doesn't fit well in neither of
your categories, but it's more like how to best treat the unexpected.
And I'm not talking unexpected as in

  switchdev                               dsa
----------------------------------------------------------------------

- Please add MAC 00:01:02:03:04:05
  to the FDB
                                       - Whoa, after all these years, I
                                         never knew you could speak!

but rather

  switchdev                               dsa
----------------------------------------------------------------------

- Please add MAC 00:01:02:03:04:05
  to the FDB
                                       - Sure thing, man!

- Please delete MAC 00:01:02:03:04:05
  from the FDB
                                       - Aye!

- Please delete MAC 00:01:02:03:04:05
  from the FDB
                                       - Wait, what MAC 00:01:02:03:04:05?
                                         I have no such thing!
- Wha?
                                       - Wha?

There's nothing to do about that except to wait for Mr Developer to come
and debug, and the severity of the problem might be low even though the
problem is just as intractable programmatically as a hardware I/O error.
Nonetheless it's still indicative of a problem worth propagating as high
as possible, because one side of the code had expectations of what the
other side could do that were clearly violated, so their models of the
other side are wrong.

This patch set makes that worse for Mr Developer that gets to debug,
because it makes dsa_port_fdb_del() return void, and the errors will now
get reported to the console at the level of dsa_port_notify() and then
suppressed. dsa_port_notify(), being at the low cross-chip notifier
level, won't print all the gory details of the FDB entry that failed to
be deleted and on what port, it will just say that the operation failed
and return void.

That's what felt wrong for me doing this conversion.
