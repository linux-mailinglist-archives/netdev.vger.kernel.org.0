Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5B64DF7F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiLORQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiLORQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:16:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873701C434
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:16:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so3410279pjp.1
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSZ4xGjM97yH/XECyyreD45DnuxTBLX6FPnWMBm8748=;
        b=qmPqkOqfX2pKlyRAru3cdx8iYuvEHV8KajeejDBkx0tFdnjFLAYAab7c0g1Df3KQnP
         YsjYWInCkHz7MaAM7QLSm9tjqTgXzz6pMOBq5jlkwzoLPQZF4aNPP2AlEyPZBjfq5wWw
         SXFgd5w6FnngZ4DR94UEck2KG+Q0A3s4MBdGrJvLKoVjxrFhb+Eu2Dp+GfsGSRv3ngK4
         OJ6VFntW3LgwqFu/xJXXjlsb0ZJ7GQuHQFtA17t4avodleWQr9PizN6RBxeIu8wxfAtB
         jQ1MRHAXrRU9AkNhGJe9Ej9L4SfpoNc9qB15e/e/PGr08jILRdTUvyNaEN8rdWtXWGRI
         PhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSZ4xGjM97yH/XECyyreD45DnuxTBLX6FPnWMBm8748=;
        b=BGzYlGz2cthJY9FUUtgslH5J2CBEAvhp5U7QmQLyN8XM/AnqDKHUF0gzwITFGA/kBN
         LarO18146HRI2Pu0dKaro/8mL21aR4X3/sK1VzL85jwLFatOGTqBp9GYTaPsK8Ib6h3C
         G+bHP4U6UGUSbJ/F8tdiL36HEpBaWmuRay1qyQxGtzfiXhsgGYwbNeN0yUr77zQFsxzJ
         PFkYbRnU4w/2S+mf6QOO2BrYNxRKN58+CV0DZ8HugeFlU8Pm9CC1WWSDBLhiGW4bJP5a
         su82mwRcqKb4YAAEWq4hwPX5FbUyCYPtHNwXnlnz4PWuVj5gAzaPZRAorjvK2Xs+3gwc
         XBHw==
X-Gm-Message-State: ANoB5pmQsaqBqMX/UY2LZ02BGNQF9UntVCdKWIVRSbhXWXcc4eZ7ofxd
        1FFoPCF8WlxZDCjC4LbxzsNqZ9Tc1jJ+4kMx3Xc=
X-Google-Smtp-Source: AA0mqf6wu33zLUAF72pD6zk4st2iNDWX3JAj5mGZrtQpLFnXSRL+xbVJb/vlcTEpF7fY6u95BDOs4w==
X-Received: by 2002:a05:6a20:2aa4:b0:ad:d982:5c0 with SMTP id v36-20020a056a202aa400b000add98205c0mr16462556pzh.44.1671124597543;
        Thu, 15 Dec 2022 09:16:37 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ep14-20020a17090ae64e00b00219cf5c3829sm3390235pjb.57.2022.12.15.09.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 09:16:37 -0800 (PST)
Date:   Thu, 15 Dec 2022 09:16:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Missing patch in iproute2 6.1 release
Message-ID: <20221215091635.15cde90c@hermes.local>
In-Reply-To: <MW4PR11MB57760310424E2B73F53F933CFDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <MW4PR11MB5776DC6756FF5CB106F3ED26FDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
        <20221215075943.3f51def8@hermes.local>
        <MW4PR11MB57760310424E2B73F53F933CFDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022 16:13:07 +0000
"Drewek, Wojciech" <wojciech.drewek@intel.com> wrote:

> > -----Original Message-----
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > Sent: czwartek, 15 grudnia 2022 17:00
> > To: Drewek, Wojciech <wojciech.drewek@intel.com>
> > Cc: netdev@vger.kernel.org
> > Subject: Re: Missing patch in iproute2 6.1 release
> > 
> > On Thu, 15 Dec 2022 10:28:16 +0000
> > "Drewek, Wojciech" <wojciech.drewek@intel.com> wrote:
> >   
> > > Hi Stephen,
> > >
> > > I've seen iproute2 6.1 being released recently[1] and I'm wondering why my patch[2] was included.
> > > Is there anything wrong with the patch?
> > >
> > > Regards,
> > > Wojtek
> > >
> > > [1] https://lore.kernel.org/netdev/20221214082705.5d2c2e7f@hermes.local/
> > > [2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9313ba541f793dd1600ea4bb7c4f739accac3e84  
> > 
> > Iproute2 next tree holds the patches for the next release.
> > That patch went into the next tree after 6.1 was started.
> > It will get picked up when next is merged to main.  
> 
> Merge windows for iproute2 are sync to kernel windows?
> I should sent this patch before merge window for 6.1 was closed (I sent it after it was closed)?

I do merge of release from next to main during the kernel merge window.
