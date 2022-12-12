Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90E064ABD1
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiLLXyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiLLXyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:54:01 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B7115703
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:54:00 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id d2so9303103qvp.12
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XO6Sw5PYxRUl6S3VXJovGLuPBASsvvommJS9OgDIpNM=;
        b=bTxCqIxuB9BRrbPIDg2sxGyWRvGic4KhMhP9fnxS0e8lW66/LZY5j4rV8/JZbRXgza
         PjR1Y0WFd/iuK4Yc/pWqTA0i49imjLySeWGQ6Edn9wgM9x2VokHK5eOmNT5jT9HshlD4
         eY6KxwZ4i4CKFPApclEjBhzZ3oFmfBdwc7nwVryIGchtfN2L5KCzNrEHDnf9B7SMZshs
         kPimdNRhVG40ZNcTopkayAxZpB8mFMTaHkxECqN9xWZAdfBEZ2FkzCYUQ0S6MJ6EN5hE
         kKcg4hcvZ1KR2pvUdpt1OUlm56WZjVnmrPipCKr6q5CL7z4H40zNF235OewUgRJFYxmZ
         7/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XO6Sw5PYxRUl6S3VXJovGLuPBASsvvommJS9OgDIpNM=;
        b=gxNPD9dLVB6lRY0rGcdh2YW5taaPMKEcMslWhBlkLuRNXWfW3rlt8cpDPWGnlmHp0u
         TfM0p4iwVl4ZnDXtqG7ANQEJwtmMhXHWkSRYMbBViNfynUSObJ7e3q8foSfCy5fgCtrm
         CEXKm+ImpH/b6jLYrtO5oNFuU8cES6NzIZniYs9TlhKsgEE4CC5hrXrbQbilHvVs+wTd
         sFxZJs9s3yqcZi16zIKVPkLRfm/MX5urTUVQttev9YeZ7ECroEhThrBbJzHT33/b/DzE
         F6p5x15X3TXhOxRPdbi8FbcG4H58VDIEj3FlyOh8uOJc6UIb64Eu8/Wqn4vN2pX9Sw9A
         3DJw==
X-Gm-Message-State: ANoB5pnqy0Hs4lgoNhJO8YIrfOnEEh7cxvt720BVxr9q1ouaO+SQ+fna
        VIkTmZHYjjT+ssAo1TniMgTieQ==
X-Google-Smtp-Source: AA0mqf5BMC9ibrWRA+CvDfV3Zhy69k6S5Mw5+emtf0OtsKgew9mi1x7u3XdO404paUWfcazAIy6low==
X-Received: by 2002:a05:6214:e6c:b0:4c7:7257:68a2 with SMTP id jz12-20020a0562140e6c00b004c7725768a2mr32678719qvb.15.1670889239715;
        Mon, 12 Dec 2022 15:53:59 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id bj41-20020a05620a192900b006cbe3be300esm6911699qkb.12.2022.12.12.15.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 15:53:59 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p4scQ-00901g-L9;
        Mon, 12 Dec 2022 19:53:58 -0400
Date:   Mon, 12 Dec 2022 19:53:58 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Message-ID: <Y5e/FjounudVaf4p@ziepe.ca>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com>
 <Y5ES3kmYSINlAQhz@x130>
 <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
 <Y5OMXATsatvNGGS/@x130>
 <Y5ONXuY+TlvOx1aV@nvidia.com>
 <MW5PR11MB5811C27393271A563A009821DDE29@MW5PR11MB5811.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB5811C27393271A563A009821DDE29@MW5PR11MB5811.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 05:03:39PM +0000, Ertman, David M wrote:
> > On Fri, Dec 09, 2022 at 11:28:28AM -0800, Saeed Mahameed wrote:
> > 
> > > IMO it's wrong to re-initialize a parallel subsystems due to an ethtool,
> > > ethtool is meant to control the netdev interface, not rdma.
> > 
> > We've gotten into locking trouble doing stuff like this before.
> > 
> > If you are holding any locks do not try to unplug/plug an aux device.
> > 
> > Jason
> 
> The unplug/plug is done outside the ethtool context.  No locks are being held.

That's a good, trick, so I'm skeptical *no* locks are held.

Jason
