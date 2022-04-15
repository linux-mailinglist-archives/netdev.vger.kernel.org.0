Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E432D502DBE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243948AbiDOQa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiDOQaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:30:55 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91829D4EC;
        Fri, 15 Apr 2022 09:28:25 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c64so10413401edf.11;
        Fri, 15 Apr 2022 09:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lt30n1Aq/tzWW8ndjvKsPkYlvSJxMZf9UGwNEhedf/A=;
        b=Ff9oqa1iAsuPAzGx0tVdZPiY0U3yCIp95gYwLMxSfyTD3QrAiHfCwy+aZzgMr2P5zs
         1D0zHpZgKEink25n9Sv6+JlfcJD6HHnBJKmyfYiQKvlLf9lxajkLafHRrInxVx8SoF/m
         5x1BR2A4bowsQFVr2pBQDNGSt4wmcuLKoI2rB7wn+OUk67+M3n0kUjD7N2o26S+ofxl2
         N3hhVQ1lM5MOTb4w5hfXves4/BgMNqYOr/pQ4zsZj5jHt4BQVdIlfYwGIkEaSLEIwkqy
         1V5m3NCTMg4YW9iD6OaYjgzbVfCOIFzIIkCj1fTvsEfd1Iu7xc3kl5ODW3l8AFoEIuiC
         6hjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lt30n1Aq/tzWW8ndjvKsPkYlvSJxMZf9UGwNEhedf/A=;
        b=T2MEu+fhvC4otrSOW7aceeks3Bn2kMUWSnVW7GDjnUulZjavksWwXCmyCjJ+FL5QPP
         Lo/h0fHERpkF95ildCBOGEQLNsv3nQFHuZZ363Ghk1FkgFdyyNsHvHEmcoeNngmZ8FAe
         oLnkmOLVPqvxq47qJQLaobs8ozotnzWLWTwSdUIcfvwmqCreLhterG+2ZTITqQ+IGf8o
         XWfAD2pWkv4K6jRMagvMWmcnjNel8mdN3HGQR5AEnjmG3MOc+TmHHua4So2bUSOVvRp/
         SOCrThJ7d+apU0jf3HekjeAV5oz42NdRnyPOT96VN6nER5GyeXQdoSIypcHN4jq/+TSu
         52Dw==
X-Gm-Message-State: AOAM531aXTfBd+cjb6S2xcVzsESku7n1njwVH5AIlJ5b1LQWcqt5eZVO
        H9XEatBVFFiDDER6XCnTiKM=
X-Google-Smtp-Source: ABdhPJyx+TJF7YU3cKfpbeJfitnyKRE7+FSxxS2OY5D6atRrP0ktRKcRDKOFaZfRyc1P2n8NwRyWcg==
X-Received: by 2002:aa7:d3c7:0:b0:41d:805a:153a with SMTP id o7-20020aa7d3c7000000b0041d805a153amr48460edr.316.1650040104512;
        Fri, 15 Apr 2022 09:28:24 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170906f88400b006e869103240sm1800717ejb.131.2022.04.15.09.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 09:28:23 -0700 (PDT)
Date:   Fri, 15 Apr 2022 18:28:11 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Message-ID: <20220415162811.GA47513@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-7-parri.andrea@gmail.com>
 <PH0PR21MB302516C5334076716966B7EED7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415070031.GE2961@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415070031.GE2961@anparri>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 09:00:31AM +0200, Andrea Parri wrote:
> > > @@ -470,7 +471,6 @@ struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct
> > > vmbus_channel *channel)
> > > 
> > >  	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> > > >priv_read_index);
> > >  }
> > > -EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
> > 
> > Does hv_pkt_iter_first_raw() need to be retained at all as a
> > separate function?  I think after these changes, the only caller
> > is hv_pkt_iter_first(), in which case the code could just go
> > inline in hv_pkt_iter_first().  Doing that combining would
> > also allow the elimination of the duplicate call to 
> > hv_pkt_iter_avail().

Back to this, can you clarify what you mean by "the elimination of..."?
After moving the function "inline", hv_pkt_iter_avail() would be called
in to check for a non-NULL descriptor (in the inline function) and later
in the computation of bytes_avail.

Thanks,
  Andrea


> 
> Good point.  Will do.
> 
> Thanks,
>   Andrea
