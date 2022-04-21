Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FF650A439
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346484AbiDUPdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345052AbiDUPdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:33:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEE265AF;
        Thu, 21 Apr 2022 08:30:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lc2so10755554ejb.12;
        Thu, 21 Apr 2022 08:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=huQqspaZHPvV/8IOlr6z6gZgnSzIiLdiEX7SuuM2584=;
        b=G7tH+56qA4f9NTwapDG+DLXd06PdDvJdLtVjhiBrgMxFwbfmKNbeILawc7wQBAW8J8
         TMUN2fHEhgyyK02LQme1FcI4Ot2S2kn0oZQypIDi5IuoQCNoofWKNPBoq/MbCnirQ3iN
         E2q+rkJE+0AxG5KvBy622bjkL+5B0S2aFcT1zexE6i0Uk+Yyvv6TATPdhsw3eAQvzoX/
         8Ao8uZ/vUwixk4DopyvSmYrPPhaX71JXRmoScz80JYsmzBI6v2brUcYks7IS5Pes7lfI
         tVRX8B1E6PX3z+ce5Ni2h5UlfAtDUxVMn7NQwm4g3gOzi5cjb1y+lhhhFaD2VwxSBngz
         HKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=huQqspaZHPvV/8IOlr6z6gZgnSzIiLdiEX7SuuM2584=;
        b=cB61EpsUlJainHKbvbby8NyPUrT8jvz58WQDFnHR6ft0O5xrXoj5vPmf4A/HrEYkvR
         h80fVMVL8D8ESaot0Y/B0wskWe7tV99EwEEjp3PQU0OqxVlqeeqopeulXqwAW1R+ulit
         QuBlt9vKjiF7bH+hxK+rqvIRXkC4W2ABU3gyxyVdys9PBr2VgBrVj/vVQLHGvjDT0V3t
         NdBv3zLttYo5WOSVHu19sWMIWMB5Rd84ei4NHsInI1Xypq9N4iMOPq0ybIfaeaJgZGD3
         aVvHBEN1cD1fo1npAgibVSvXv4xwXlDaG1hElmrTZyazJtjlCVY6ED+Jlx9nSMYRj+tN
         /OGA==
X-Gm-Message-State: AOAM533ek2cURIQOJahG55+26r8G+9/rrrpPCQUbQSh5lHF6gsSSc32w
        hF0RhpgTF+JrstO/5nreCVM=
X-Google-Smtp-Source: ABdhPJwyZvvXbzrjPnijUBhIHh4D/IOpU8atxwVAmF8xsYhY1OmheTkQbc01WUbQwvAoHa+H3JKqjA==
X-Received: by 2002:a17:906:7950:b0:6f0:e53:a864 with SMTP id l16-20020a170906795000b006f00e53a864mr123481ejo.0.1650555040435;
        Thu, 21 Apr 2022 08:30:40 -0700 (PDT)
Received: from anparri (host-79-30-22-114.retail.telecomitalia.it. [79.30.22.114])
        by smtp.gmail.com with ESMTPSA id bl20-20020a170906c25400b006efeef97b1esm2546120ejb.206.2022.04.21.08.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 08:30:40 -0700 (PDT)
Date:   Thu, 21 Apr 2022 17:30:37 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] hv_sock: Add validation for untrusted Hyper-V values
Message-ID: <20220421152827.GB4679@anparri>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-4-parri.andrea@gmail.com>
 <20220421140805.qg4cwqhsq5vuqkut@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421140805.qg4cwqhsq5vuqkut@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -577,12 +577,19 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
> > static int hvs_update_recv_data(struct hvsock *hvs)
> > {
> > 	struct hvs_recv_buf *recv_buf;
> > -	u32 payload_len;
> > +	u32 pkt_len, payload_len;
> > +
> > +	pkt_len = hv_pkt_len(hvs->recv_desc);
> > +
> > +	/* Ensure the packet is big enough to read its header */
> > +	if (pkt_len < HVS_HEADER_LEN)
> > +		return -EIO;
> > 
> > 	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
> > 	payload_len = recv_buf->hdr.data_size;
> > 
> > -	if (payload_len > HVS_MTU_SIZE)
> > +	/* Ensure the packet is big enough to read its payload */
> > +	if (payload_len > pkt_len - HVS_HEADER_LEN || payload_len > HVS_MTU_SIZE)
> 
> checkpatch warns that we exceed 80 characters, I do not have a strong
> opinion on this, but if you have to resend better break the condition into 2
> lines.

Will break if preferred.  (but does it really warn??  I understand that
the warning was deprecated and the "limit" increased to 100 chars...)


> Maybe even update or remove the comment? (it only describes the first
> condition, but the conditions are pretty clear, so I don't think it adds
> much).

Works for me.  (taking it as this applies to the previous comment too.)

Thanks,
  Andrea
