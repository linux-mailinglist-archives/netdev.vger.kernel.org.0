Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FC6615457
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 22:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiKAVhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 17:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKAVhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 17:37:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6611EAFC
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 14:37:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gw22so1504989pjb.3
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 14:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cAGeZclIjBMFiBmV0n4LbZW8io+5YMRxyVOhuTAk5qw=;
        b=FYEKX7LpkD3IyhVOK2UB4R1S8Ui+o/o1MFilXFE+ITlFq/9x6MeK2KLm0E8IVhfOOu
         3cPOHKbTHaTg57/V5O7YzNhABL1msNpCOul4oX4Hx1BOLHcDF9vD5ZVyBqHxnGb4mGzw
         L47q0wTWQbxWh/JLB9fx45Y8WkUDFfWRHBmR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAGeZclIjBMFiBmV0n4LbZW8io+5YMRxyVOhuTAk5qw=;
        b=Ku2ThEkIspyHQ2Jqv048Ja1OhRRuVAuTp/SFc3PY3zF6emzmEPr99bwthc3QC+/88C
         KVQa9VPECUlRiDqTZM5k5xOmL/N/LpkA0aCVjhoe7cG2937mviQjQ+8LTOleIEAo528T
         5mxKqivI7MYGO64o7p9a0/AM4mCPyLSMgJstjbFfFrVoQzlkGuZ3/iill0wZyG6tIyTx
         OagnfIRQq0cNMlnufrZPvCNqMhLtDQVsMLRoxYa8YHTLP27f3a1R21iVoLDYqq/KlQ9+
         H5gveOxNST4IiBoFstQ1cxpLAKow6boaSzcGZpxMsN6I0PkxYqFFdYX4JYVGFVfN5nMN
         R3eA==
X-Gm-Message-State: ACrzQf1J4BnTbTefQZao3ltIaA1PoISqYvmRQT6K8QhpnZ3Mt9D3Rqiv
        tTH+JXhliV1L1Ri7Jx/122eMww==
X-Google-Smtp-Source: AMsMyM5Fz7z4//NNU/2FQNhB3+uFr7/xzcvoPBqfaxkDh2S2pNYrRUQ5dD2oLYwynDTb/ap+OrDczA==
X-Received: by 2002:a17:903:2596:b0:186:a395:c4bd with SMTP id jb22-20020a170903259600b00186a395c4bdmr21887754plb.60.1667338638881;
        Tue, 01 Nov 2022 14:37:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k36-20020a635624000000b0046ae5cfc3d5sm6232753pgb.61.2022.11.01.14.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 14:37:18 -0700 (PDT)
Date:   Tue, 1 Nov 2022 14:37:17 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket size
Message-ID: <202211011433.A64BF17F46@keescook>
References: <20221018092340.never.556-kees@kernel.org>
 <20221018092526.4035344-2-keescook@chromium.org>
 <202210282013.82F28AE92@keescook>
 <DM5PR11MB1324802F3F2098CB3239CF36C1379@DM5PR11MB1324.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR11MB1324802F3F2098CB3239CF36C1379@DM5PR11MB1324.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 08:42:36PM +0000, Ruhl, Michael J wrote:
> Looking at the size usage (from elixir), I see:
> 
> --
> 	if (!q_vector) {
> 		q_vector = kzalloc(size, GFP_KERNEL);
> 	} else if (size > ksize(q_vector)) {
> 		kfree_rcu(q_vector, rcu);
> 		q_vector = kzalloc(size, GFP_KERNEL);
> 	} else {
> 		memset(q_vector, 0, size);
> 	}
> --
> 
> If the size is rounded up, will the (size > ksize()) check ever be true?
> 
> I.e. have you eliminated this check (and maybe getting rid of the need for first patch?)?

Hi!

It looked like igb_alloc_q_vector() was designed to be called multiple
times on the same q_vector (i.e. to grow its allocation size over time).
So for that case, yes, the "size > ksize(q_vector)" check is needed. If
it's only ever called once (which is hard for me to tell), then no. (And
if "no", why was the alloc/free case even there in the first place?)

-Kees

-- 
Kees Cook
