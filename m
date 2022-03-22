Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013C24E4328
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 16:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbiCVPmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 11:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiCVPmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 11:42:05 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF7C88B08
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:40:37 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w27so30480260lfa.5
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4d7gIjQl0V3Oh4gsfkrKWLngKVWGvQPuyJmJmLTtyAk=;
        b=azjrQH8IGXtaShcDdecwREomUrYlvqjAfzFbSKdRMMy8X2dJFkX0JyjpBvqmiBMdEN
         aSy39kmJjfNdgt0xrB5e3hWFqn/mYDSMKgbkobkuE1z7JNrJ2gLbANAUqsZ4b7ON9PeY
         rqr0Jled6btZvLT4gOJD8tG15k5gsYkeoEn3jm3k7rVNsBxLbZHIYLPjEWgRPWEds6D3
         ir6uvoBaM9ai4koWC4UokseR3qZfRbpTpIcOL7oDg/QphYSvGkP5t0NL1tOmasqVhiS7
         CKzLleTFRTNGWPvbEFX2EalYtYYEhWL36oNgEtgHl8YA+MYqZTvVhInOQn16IDeTaZwg
         odSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4d7gIjQl0V3Oh4gsfkrKWLngKVWGvQPuyJmJmLTtyAk=;
        b=m7nWKXsZkINh1w2hjwdhBGM9EMjC2zzrnXmlQyzDiqF0nzZRhjf9CdUXZJbz+hQE8G
         OQGbj3VXgCnZakoywNamFXVUtqbs7zBZW25bUvny/LwGhOIj+VDCaPxJ5rOsFS52xysX
         PUvLyQqmtj/gaJI0a4aUjWRmvqH/y5aUco0i0HvEmjlgvR60YRHg/bRIbYD6fj7YFIwM
         lWImxCVmZdxLoAZnwwAxvEByTq2eOBQWLDkxv0iVVCZMiAU/Utcoykw4is/LInlzmO7Z
         gdJOp/rdy3yPC1Rp2o8TmJfAewGULkagpOPWio0JjGPd59P3undQ578bJbEA1r6Ex59r
         36Hg==
X-Gm-Message-State: AOAM533T0QKNbYUUlc1txDCpb+/xC3Eka06841sHIH39v8kzxIeA0yS6
        Vtk+Lp1arSvqtOy01E9BLknaFSZvDQTH1w==
X-Google-Smtp-Source: ABdhPJwhpZTXQYIAppVBhjyboUXU758ayJh7oEx4TQIIdFH6WY/u7Hn73wPf+mmk53vFxVzWQh1Imw==
X-Received: by 2002:a19:6a14:0:b0:44a:1ef1:c198 with SMTP id u20-20020a196a14000000b0044a1ef1c198mr11029606lfu.396.1647963633297;
        Tue, 22 Mar 2022 08:40:33 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n1-20020a2e7201000000b00249588970b7sm2432275ljc.46.2022.03.22.08.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 08:40:32 -0700 (PDT)
Date:   Tue, 22 Mar 2022 16:40:31 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/2] net: sparx5: Add mdb handlers
Message-ID: <20220322154031.df5o2xtosem2aio4@wse-c0155>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
 <20220321101446.2372093-3-casper.casan@gmail.com>
 <23c07e81392bd5ae8f44a5270f91c6ca696baa31.camel@microchip.com>
 <20220322095920.hptmgkby3tfxwmw4@wse-c0155>
 <ac37852d1fd2715209ad7679fa4d705083322b23.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac37852d1fd2715209ad7679fa4d705083322b23.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-22 15:51, Steen Hegelund wrote:
> Hi Casper
> 
> On Tue, 2022-03-22 at 10:59 +0100, Casper Andersson wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > So this was already merged, but I have some comments on the feedback for
> > the follow up patch.
> > 
> > > > +static int sparx5_handle_port_mdb_add(struct net_device *dev,
> > > > +                                     struct notifier_block *nb,
> > > > +                                     const struct switchdev_obj_port_mdb *v)
> > > > +{
> > > > +       struct sparx5_port *port = netdev_priv(dev);
> > > > +       struct sparx5 *spx5 = port->sparx5;
> > > > +       u16 pgid_idx, vid;
> > > > +       u32 mact_entry;
> > > > +       int res, err;
> > > > +
> > > > +       /* When VLAN unaware the vlan value is not parsed and we receive vid 0.
> > > > +        * Fall back to bridge vid 1.
> > > > +        */
> > > > +       if (!br_vlan_enabled(spx5->hw_bridge_dev))
> > > > +               vid = 1;
> > > > +       else
> > > > +               vid = v->vid;
> > > > +
> > > > +       res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> > > > +
> > > > +       if (res) {
> > > > +               pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> > > > +
> > > > +               /* MC_IDX has an offset of 65 in the PGID table. */
> > > > +               pgid_idx += PGID_MCAST_START;
> > > 
> > > This will overlap some of the first ports with the flood masks according to:
> > > 
> > > https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html?select=ana_ac,pgid
> > > 
> > > You should use the custom area (PGID_BASE + 8 and onwards) for this new feature.
> > 
> > I'm aware of the overlap, hence why the PGID table has those fields
> > marked as reserved. But your datasheet says that the multicast index
> > has an offset of 65 (ie. MC_IDX = 0 is at PGID = 65). This is already
> > taken into account in the mact_learn function. I could set the
> > allocation to start at PGID_BASE + 8, but the offset still needs to
> > be 65, right?
> 
> As I understand the PGID table functionality, you will need to start your custom table at PGID_BASE
> + 8 as the bitmasks at offset 65 to 70 are used as flood masks, so their purpose are already
> defined.

It is fine to start the allocation of multicast entries at PGID_BASE + 8,
but the multicast index (MC_IDX) in the mactable (that points at the
PGID table, to get the port mask) assumes that MC_IDX = 0 is at PGID = 65.
Not sure if it's appropriate to reference the datasheet here on Netdev,
but on figure 4-48 (PGID Layout) this is shown.

I tried setting the offset to base + 8 but it does not seem to find the 
right mask. Because if I say I put the mask on MC_IDX 0, and then place
it on base + 8 (73), then it will not find that mask because the hardware
will look for the mask at 65.

Even though the offset is 65, the PGID allocation will make sure
that it never allocates anything below 73. Meaning that the lowest
possible MC_IDX it can allocate will be 8.

I'm also a bit confused as to why the multicast offset is 65, but there
are a lot of overlapping areas in the PGID table and, e.g., GLAG has 
another offset where its index 0 is at PGID = 833 (as can be seen in
figure 4-48).

BR
Casper

> BR
> Steen
> 
> > 
> > BR
> > Casper
> 
