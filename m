Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5166878BF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjBBJZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjBBJZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:25:09 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E066F70A;
        Thu,  2 Feb 2023 01:25:00 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h16so1050649wrz.12;
        Thu, 02 Feb 2023 01:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhMM04GmsiAnyNDTn9vje/fUm/yTcbn2+Xc7peVV29I=;
        b=pFZ+YKIFB83mmfNjjNRa3J67dKflj83n5RPkYmVxDGKh3C739XIs8elwYn+ympmrNn
         ZaDoPxeZF+mfPEOLbPrM9N9nsTmz/fdYIQzNpUAg2BZNFoUZRthcWnG3liQuNCYUoo2z
         IsEnCcKabye7FUXrriNZjek2FaJcGLbAO6DzP9H2DsVGNpbnjwJE5+GcA5V7DjJFsuHa
         hciJIRqax/7bDVNC9N1hP/i7s6AM0zBwrd/pdEGIAhGTsVWsLoUIJMbGFquNYCBobFqs
         z3fj1oecYBpEs1ierVItPGdnWe9rlscu41pD5zu2rFAPIe5OGuktf9yM1ir0Jt3VzY+2
         a0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhMM04GmsiAnyNDTn9vje/fUm/yTcbn2+Xc7peVV29I=;
        b=UnBYzH7iDEQ4lEA7ywp7idyNTOCqKGnPcGfj7r9KyaEMphbtoJUyZ7P8sUw4EpJ3O/
         +Y2NtTzdHc/AT1GzwE98e+nw+gRYiuJWVOWt44JxlmP6D8pzivqFrehrrzlP/1nwUpiz
         geWXSQyC/7Fa3gwBx2gjBenlknlkqUuRiQ6yNyDX6HTNpMuYUizuadWNjIV15GL7LyXh
         Nr3WJfs9EtDJZA3mUrdzUlOOAbCUKypCtWGpdpRcEdF/t/i4dZCnRRH0u2BMNC8qkhMA
         5//K4AtXU8RJPF3F+5TSRVmRmTVQH7QyI4zTQCvQpGRLMIU/NK5xfjp0OS3Leveukb8N
         sKUA==
X-Gm-Message-State: AO0yUKVKotddNlp9NaHQHiWLnHnUZP3+Qi8O6nxhkZ80y/tpJOBsGLFX
        Iq/ZakNbEYz55nupAeyjjBbd0sUxPpo=
X-Google-Smtp-Source: AK7set/d5mxwH//BvN4l6jgAFiyILrJZbZTMSRSg3GHIn3ZnyZWLi2YKblROV7QIAUaank8ww1OTdg==
X-Received: by 2002:adf:f452:0:b0:2bf:ddf6:5063 with SMTP id f18-20020adff452000000b002bfddf65063mr5042339wrp.35.1675329899181;
        Thu, 02 Feb 2023 01:24:59 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id t8-20020a5d6908000000b002bc7e5a1171sm19699558wru.116.2023.02.02.01.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:24:58 -0800 (PST)
Date:   Thu, 2 Feb 2023 09:24:56 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <Y9uA8Vk430k+ezTt@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
 <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
 <Y9k7Ap4Irby7vnWg@nanopsycho>
 <44b02ac4-0f64-beb3-3af0-6b628e839620@amd.com>
 <Y9or1SWlasbNIJpp@nanopsycho>
 <20230201110148.0ddd3a0b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201110148.0ddd3a0b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 11:01:48AM -0800, Jakub Kicinski wrote:
> On Wed, 1 Feb 2023 10:07:33 +0100 Jiri Pirko wrote:
> > >This is due to the recommended/required devlink lock/unlock during 
> > >driver initialization/removal.
> > >
> > >I think it is better to keep the lock/unlock inside the specific driver 
> > >devlink code, and the functions naming reflects a time window when 
> > >devlink related/dependent processing is being done.
> > >
> > >I'm not against changing this, maybe adding the lock/unlock suffix would 
> > >be preferable?:
> > >
> > >int efx_probe_devlink_and_lock(struct efx_nic *efx);
> > >void efx_probe_devlink_unlock(struct efx_nic *efx);
> > >void efx_fini_devlink_lock(struct efx_nic *efx);
> > >void efx_fini_devlink_and_unlock(struct efx_nic *efx);  
> > 
> > Sounds better. Thanks!
> 
> FWIW I'd just take the devl lock in the main driver code.
> devlink should be viewed as a layer between bus and driver rather 
> than as another subsystem the driver registers with. Otherwise reloads
> and port creation get awkward.

I see it a bit differently. For me devlink is another subsystem, it even is
an optional subsystem.
At the moment we don't support devlink port for VFs. If needed we'll add that
at some point, but likely only for newer NICs.
Do you think vDPA and RDMA devices will ever register with devlink?
At the moment I don't see devlink port ever applying to our older hardware,
like our sfn8000 or X2 cards. I do think devlink info and other commands
could apply more generally.

There definitely is a need to evolve to another layer between bus and
devices, and devlink can be used to administer that. But that does not
imply the reverse, that all devices register as devlink devices.
For security we would want to limit some operations (such as port creation)
to specific devlink instance(s). For example, normally we would not want a
tennant VM to flash new firmware that applies to the whole NIC.
I hope this makes sense.

Martin
