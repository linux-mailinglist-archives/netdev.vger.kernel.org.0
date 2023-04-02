Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A485E6D3ADB
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 00:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjDBWzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 18:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBWzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 18:55:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A075FD9;
        Sun,  2 Apr 2023 15:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD1FACE06B2;
        Sun,  2 Apr 2023 22:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5C6C4339B;
        Sun,  2 Apr 2023 22:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680476141;
        bh=Lx2idhvRNG1dw9LUdErWFhzY49bD2WkzlnwBAK0/08w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=k4LJgGNBzxmSzkENVv50EPCcN09TK1s4ETBR3y1MO/ZjryOpwZ2BGQie9vAbSGDCj
         YedY01t/R6fTl2PlJedmkABb5+2/70NYndNK24OQ1Zti+Q8wkNaHvauYIUsA4bx0kw
         EGa1/ODVlzxRmANTfKnvLgFMZXsv3QKgnJm/Bf31WLFBbYfZEQ5bL0NsWiL7rO1b+l
         VMYBHBeFqP/+H+xyugZVQOsQ0Bnc66KNpxNvxNOPrBnOuD7JMv92E/Fn6h+Et/dCOD
         5tZt0cNTF24NsdvFt70zkuMRUtkntDhjGBk69BhvcUfXlTWK02rUWgf8agYhdJ4xsB
         1Dzvt48I9d+BA==
Date:   Sun, 2 Apr 2023 17:55:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
Message-ID: <20230402225539.GA3388013@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD4GDZwgOVn4dR2qiqrQWz-fw52aT9uyv22NCdo+hY4HJEgofQ@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> > because it apparently has an ACPI firmware node, and there's something
> > we don't expect about its status?
> 
> Yes they are built-in, to my knowledge.
> 
> > Hopefully Rob will look at this.  If I were looking, I would be
> > interested in acpidump to see what's in the DSDT.
> 
> I can get an acpidump. Is there a preferred way to share the files, or just
> an email attachment?

I think by default acpidump produces ASCII that can be directly
included in email.  http://vger.kernel.org/majordomo-info.html says
100K is the limit for vger mailing lists.  Or you could open a report
at https://bugzilla.kernel.org and attach it there, maybe along with a
complete dmesg log and "sudo lspci -vv" output.

Bjorn
