Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4434B5025F5
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 09:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350847AbiDOHDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245147AbiDOHDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:03:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6003193B;
        Fri, 15 Apr 2022 00:00:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b15so8987114edn.4;
        Fri, 15 Apr 2022 00:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5zPCnkK90E2Oh6mxzRxHexOiUMKiXmsFDOzETkQOi4k=;
        b=cdGUylniFInC4QsCc4NKF6/T8nwCjXOKZpl/+PKeOWE/uSXwBJehWX2QyzArD4Lpvn
         vKYcow0jenIAhL0kUdujm7xWFFzKIOn38Y+IOfZON/hl+eSZDEp94yt6/DMq0EOiyJ12
         Ke2LKsNWS8nWH1WDuccIMvpGuhTxpAeP1MRUGMHDFzZiAqk4ZvPLkS2C+GTKQa+ShsRd
         F1Y1no0PKSLj8xaXBoj43QoiMdorSk2KaXW6WZ5vXFeoEz1ujeVt9ayVL+gfrzagCeGf
         cvwUjumFiyb9QH1Dn/h8bLQd6e82f5JUmG+o9bdiNxnQ7dnmkOv8pm2PsZLWBmZ8weU1
         eJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5zPCnkK90E2Oh6mxzRxHexOiUMKiXmsFDOzETkQOi4k=;
        b=5Mxw4y7mVINmxKSBRcytxYqYBQ6Bi/BKI0fUWsSqK5MFEWVLROO619la+vazWxa6Zs
         e8OME7JsIcYCkqcvHDq6cAHDInNlrAqLN4rpVn9uIXofdQLlsFS2nd5RiGEtkC5GA8i3
         eXSPUQrhhWuO6jIxAm0TrWT7c0VaqRFzEtmkQ1AkKRbzj4xBMAMIKiwBGfSX7Ud9610D
         AjZCbyOs2or3rxmSYE6Z80kQFwkuomMo4tIf1X/gz5sm5ardRDC0KQDTPesA4dOQWe9i
         Nm7+QuM5im8PPRXbHNZepxtUVhtgApo8EHc0XvBE5sLpXzfXtIZwq/5YNwNg6jaSgsEX
         vo6g==
X-Gm-Message-State: AOAM533SI2sfZ68KphXA1+Ds0GiElwN55R6UE2vpQWf5hOvWJk70xaFi
        tq9KB06xGiGrWeVQQxL1Drk=
X-Google-Smtp-Source: ABdhPJydsb8KR4qodehzOz9rACN/YAmiaugQweTeN3IkZowT/byEj5+61OfXSCec0ZxSPu4jEyb1Hw==
X-Received: by 2002:a50:d78e:0:b0:416:2cd7:7ac5 with SMTP id w14-20020a50d78e000000b004162cd77ac5mr6840206edi.320.1650006035060;
        Fri, 15 Apr 2022 00:00:35 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7c7c3000000b0042237eda622sm647318eds.83.2022.04.15.00.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 00:00:34 -0700 (PDT)
Date:   Fri, 15 Apr 2022 09:00:31 +0200
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
Message-ID: <20220415070031.GE2961@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-7-parri.andrea@gmail.com>
 <PH0PR21MB302516C5334076716966B7EED7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB302516C5334076716966B7EED7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -470,7 +471,6 @@ struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct
> > vmbus_channel *channel)
> > 
> >  	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> > >priv_read_index);
> >  }
> > -EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
> 
> Does hv_pkt_iter_first_raw() need to be retained at all as a
> separate function?  I think after these changes, the only caller
> is hv_pkt_iter_first(), in which case the code could just go
> inline in hv_pkt_iter_first().  Doing that combining would
> also allow the elimination of the duplicate call to 
> hv_pkt_iter_avail().

Good point.  Will do.

Thanks,
  Andrea
